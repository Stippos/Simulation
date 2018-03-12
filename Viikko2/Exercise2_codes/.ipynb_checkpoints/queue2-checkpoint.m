function [d,u,nq] = queue2(n,k,lambda,mu)
% Simulate delays in queue for queuing model (M/M/k)
% ------------------------------------ 
% n the number of customers
% k the number of servers
% lambda the arrival rate of customers
% mu the service rate
% ------------------------------------
% d the delay times for each customer
% u the utilization of servers
% nq the average queue length
% ------------------------------------

t = 0;                % Simulation clock
ta = exprnd(lambda);  % The time of next customer arrival
td = inf;             % Departure time of customers (set to a dummy value)

served = [];          % Customers being served
queue = [];           % Queued customers

n_in = 0;             % Number of customer arrivals
n_out = 0;            % Number of customer departures

d = [];               % Service delays
u = 0;                % Utilization of server
                      % (time interval * fraction of servers having
                      % customer in that time interval)
nq = 0;               % Number in queue statistic
                      % (time interval * length of queue)

% The main simulation loop
while n_out < n
    
    % Next event is arrival
    if ta < td                    
        
        % Update statistics
        
        % Number of customers entered the system
        n_in = n_in + 1;    
        % Utilization statistic
        u = u + (ta-t) * length(served) / k;
        % Number of customers in queue statistic
        nq = nq + (ta-t) * length(queue);

        % Add either to server or queue
        if length(served) < k
            % Generate departure time, add to served vector and sort
            % so that earliest departure is the first element
            served = sort([served ta+exprnd(mu)]);
            % Customer went straight to server => no delay
            d(end+1)= 0;
        else 
            % Add the arrival time to the queue vector 
            queue = [queue ta];
        end
        
        % Update simulation clock 
        t = ta;
        % Generate next arrival time
        ta = ta + exprnd(lambda);
        % Set next departure time as the earliest departure time, i.e.,
        % the first element of the served vector
        td = served(1);
        
        
    else
        % Next event is departure
        
        % Update statistics
        n_out = n_out + 1;
        u = u + (td-t) * length(served) / k;
        nq = nq + (td-t) * length(queue);
        
        % Departure, remove first element of served vector
        served = served(2:end);

        % Take next customer from queue, if queue is not empty
        if ~isempty(queue)
            % Add new customer to served list and generate departure time
            served = sort([served td+exprnd(mu)]);
            % Record delay: Now - time the customer entered the queue
            d(end+1)= td - queue(1);
            % Remove the customer, i.e., the first element from the queue
            queue = queue(2:end);
        end
        
        % Update simulation clock
        t = td;
        % If servers are empty
        if isempty(served)
            % Set next departure time high so that the event cannot happen
            td = inf;
        else
            % If there is customers in the servers, set the next departure
            % time as the earliest departure time in served
            td = served(1);
        end
        
    end
end

% Calculate utilization: In u, we have the added time intervals
% between the events times the fraction of servers having customer in the
% intervals. To get utilization we simply divide u with the simulation time 
% in the end of the simulation
u = u / t;
% Calculate average queue length: Similar to utilization
nq = nq / t;