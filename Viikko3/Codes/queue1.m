function [y,n_in,n_out] = queue1(N,lambda,mu1,mu2,p,ua,ud1,ud2,up,antithetic)
%Queueing model, exercise 3.1
%
%N          number of customers to simulate
%lambda     arrival rate
%mu1        service rate at server 1
%mu2        service rate at server 2
%p          customers leave system after server 1 with probability p,
%           otherwise leave the system
%ua 		rng for arrivals
%ud1, ud2 	rngs for service delays at servers 1 and 2
%up		rng for server selection
%antithetic 1 turns on antithetic variates, 0 turn them off  
%
%
%All times exponentially distributed
 
t = 0;        %Simulation clock
 
n_in = 0;     %Counter
n_out = 0;    %Counter
 
ta = 0;       %Next arrival
td1 = inf;    %Next departure at server 1
td2 = inf;    %Next departure at server 2
  
s1 = 0;       %Customer service at server 1
s2 = 0;       %Customer service at server 2
nq1 = 0;      %Number in queue at server 1
nq2 = 0;      %Number in queue at server 2
 
tq = 0;       %Total queueing time in the system

%First arrival
z = rand(ua);
if antithetic == 1;z = 1-z;end;
ta  =  -(1/lambda)*log(z);
 
%The main simulation loop
while n_out < N
    
    if ta < min(td1,td2)              %Next event is arrival
 
        n_in = n_in+1;
        tq = tq+nq1*(ta-t)+nq2*(ta-t);
        t = ta;
        
        if s1 == 0                    %Server is idle
            z = rand(ud1);
            if antithetic == 1
                z = 1-z;
            end
            td1 = t-(1/mu1)*log(z);
            s1 = 1;
        else                        %Server is busy
            nq1 = nq1+1;
        end
        
        z = rand(ua);                 %Next arrival
        if antithetic == 1
            z = 1-z;
        end
        ta = t-(1/lambda)*log(z);
        
    elseif td1 < min(ta,td2)          %Next event is departure at server 1
        
        tq = tq+nq1*(td1-t)+nq2*(td1-t);
        t = td1;
        
        z = rand(up);
%         if antithetic == 1;z = 1-z;end;
        
        if z > p                      %Customer enters server 2
            if s2 == 0                %Server is idle
                z = rand(ud2);
                if antithetic == 1
                    z = 1-z;
                end
                td2 = t-(1/mu2)*log(z);
                s2 = 1;
            else                    %Server is busy
                nq2 = nq2+1;
            end
        else                        %Customer leaves the system
            n_out = n_out+1;
        end
        

        if nq1 > 0                    %Waiting customers exist at server 1
            nq1 = nq1-1;
            z = rand(ud1);
            if antithetic == 1
                z = 1-z;
            end;
            td1 = t-(1/mu1)*log(z);
            s1 = 1;
        else
            s1 = 0;
            td1 = inf;
        end
        
    elseif td2 < min(ta,td1)          %Next event is departure at server 2
        
        tq = tq+nq1*(td2-t)+nq2*(td2-t);
        t = td2;
        n_out = n_out+1;
 
        if nq2 > 0                    %Waiting customers exist at server 2
            nq2 = nq2-1;
            z = rand(ud2);
            if antithetic == 1
                z = 1-z;
            end
            td2 = t-(1/mu2)*log(z);
            s2 = 1;
        else
            s2 = 0;
            td2 = inf;
        end
 
    end
    
end
 
y = tq/n_in;    %Return average total waiting time per customer            
