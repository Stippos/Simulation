function [tq,ts] = queue2(N,lambda,mu,p)
%Queueing model, exercise 3.2
%
% N      number of customers to simulate
% lambda arrival rate
% mu     service rate at srever 1
% p      customers re-enter server with probability 1-p, otherwise leave 
%        the system
%
%All times exponentially distributed

t=0; %Simulation clock

n_in=0; %Counter
n_out=0; %Counter

ta=0; %Next arrival
td=inf; %Next departure at server

s=[]; %Customer service at server, 0 first service, 1 second service
si=[]; %Indices of customers at server

nq=[]; %Number in queue at server, 0 first service, 1 second service
nqi=[]; %Indices of customers at server

tq=zeros(N,1); %Queueing times for first N customers
ts=zeros(N,1); %Service times for first N customers

%First arrival
ta = exprnd(1/lambda);

%The main simulation loop
while n_out<N
    
    if ta<td %Next event is arrival
        
        n_in=n_in+1;
        for i=1:length(nqi)
            if nqi(i)<=N
                tq(nqi(i))=tq(nqi(i))+(ta-t);
            end
        end
        t=ta;
        
        if isempty(s) %Server is idle
            z=exprnd(1/mu);
            td=t+z;
            if n_in<=N
                ts(n_in)=ts(n_in)+z;
            end
            s=0;
            si=[n_in];
        else %Server is busy, enter queue
            nq=[nq 0];
            nqi=[nqi n_in];
        end
        
        ta=t+exprnd(1/lambda);
        
    elseif td<ta %Next event is departure at server
        
        for i=1:length(nqi)
            if nqi(i)<=N
                tq(nqi(i))=tq(nqi(i))+(td-t);
            end
        end
        
        t=td;
        z=rand;
        
        if z>p && s==0 %Customer re-enters server
            if isempty(nq) %Queue is empty
                s=1;
                z=exprnd(1/mu);
                if si<=N
                    ts(si)=ts(si)+z;
                end
                td=t+z;
            else
                nq=[nq 1]; %Go to end of line
                nqi=[nqi si];
                s=nq(1); %Take first customer from queue
                si=nqi(1);
                nq=nq(2:end);
                nqi=nqi(2:end);
                z=exprnd(1/mu);
                if si<=N
                    ts(si)=ts(si)+z;
                end
                td=t+z;
            end
        else
            
            if s<=N %We only count first N customers
                n_out=n_out+1;
            end
            
            if isempty(nq)
                s=[];
                si=[];
                td=inf;
            else
                s=nq(1);
                si=nqi(1);
                nq=nq(2:end);
                nqi=nqi(2:end);
                z=exprnd(1/mu);
                if si<=N
                    ts(si)=ts(si)+z;
                end
                td=t+z;
            end
        end
    end
end

tq=mean(tq);
ts=mean(ts);
