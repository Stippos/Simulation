function c=machines(k,lambda,c_f,mu,c_r)
%Simulate availability of m machines
%lambda breakdown rate of all machines
%mu     repair rate of each machine
%k      repair capacity (number of repairmen
%c_f    cost per hour of an unavailable machine
%c_r    cost per hour of a repairman

T=800;                   %Total simulation time
m=5;                     %Number of machines

t=0;                     %Simulation clock
tb=exprnd(1/(m*lambda)); %The time of next breakdown
tr=inf;                  %The time of next repair completion

n_r=[];                  %Machines under repair
n_q=0;                   %Number queueing for repair

c=0;                     %Total cost


%The main simulation loop
while min(tb,tr)<T
    
    if tb<tr                    %Next event is breakdown
                
        %Update statistics    
        c = c+(tb-t)*(c_f*(length(n_r)+n_q)+c_r*k);        
        
        %Take to repairman or add in queue
        if length(n_r)<k                         
            n_r=sort([n_r tb+exprnd(1/mu)]);
        else                                       
            n_q=n_q+1;
        end
        
        %Update simulation clock 
        t = tb;

        %Next breakdown
        if length(n_r)+n_q<m
            tb=t+exprnd(1/(lambda*(m-length(n_r)-n_q)));
        else
            tb=inf;
        end
        
        %Next repair
        tr = n_r(1);        
        
    else                        %Next event is repair completion
        
        %Update statistics    
        c = c+(tr-t)*(c_f*(length(n_r)+n_q)+c_r*k);        
        
        %Departure
        n_r=n_r(2:end);

        %Take next customer from repair queue, if queue is not empty
        if n_q>0
            n_r=sort([n_r tr+exprnd(1/mu)]);
            n_q = n_q-1;
        end
        
        %Update simulation clock
        t = tr;
        
        %Next service completion
        if not(isempty(n_r))
            tr = n_r(1);
        else
            tr=inf;
        end
        
        %Next breakdown (breakdown intensity increasis as repair is
        %completed)
        tb=t+exprnd(1/(lambda*(m-length(n_r)-n_q)));
        
    end
        
end

%Update statistics for remaining time period
c = c+(T-t)*(c_f*(length(n_r)+n_q)+c_r*k);        

%Average hourly cost
c=c/T;