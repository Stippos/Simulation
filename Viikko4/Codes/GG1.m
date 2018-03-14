function [d,ps]=GG1(n,lambda,mu,sigma,rstate)
%Simulate delays in queue for queuing model (GI/G/1)
%Arrivals exponential, service normally distributed.
%
%n          the number of customers
%lambda     the arrival rate of customers
%mu         mean service time of customers
%sigma      standard deviation of the service time
%rstate     state of random numbr generator

ua=rstate;          %Random stream for arrivals
ud=rstate+2*n;      %Random stream for service delays

t=0;                %Simulation clock
rand('state',ua);   %The time of next customer arrival
ta=exprnd(lambda);  
td=inf;             %The time of next departure 

ps=zeros(1,n);      %Waiting delay perturbations of customers     

queue=[];           %Queued customers

n_in=0;             %Number of customer arrivals
n_out=0;            %Number of customer departures

d=zeros(1,n);       %Service delays


%The main simulation loop
while n_out<n
    
    if ta<td                                 %Next event is arrival
        
        %Update statistics
        n_in = n_in+1;    

        %Add either to server or queue
        if td==inf
            ud=ud+1;rand('state',ud);
            td = ta+normrnd(mu,sigma);
            d(n_in)= 0;
        else                                       
            if isempty(queue)
                ps(n_in)=1;                  %Propagate perturbation in delay
            else
                ps(n_in)=ps(n_in-1)+1;    %Propagate perturbation in delay
            end
            queue=[queue ta];
        end
        
        %Update simulation clock 
        t = ta;
        ua=ua+1;rand('state',ua);
        ta = ta+exprnd(1/lambda);
        
    elseif td<ta                          %Next event is departure
        
        %Update statistics
        n_out = n_out+1;
        
        %Update simulation clock
        t = td;
        
        %Take next customer from queue, if queue is not empty
        if not(isempty(queue))
            d(n_out+1)=td-queue(1);
            queue = queue(2:end);
            ud=ud+1;rand('state',ud);
            td = t+normrnd(mu,sigma);
        else
            td=inf;
        end
                
    end
end

d=mean(d(1:n));
ps=mean(ps(1:n));
