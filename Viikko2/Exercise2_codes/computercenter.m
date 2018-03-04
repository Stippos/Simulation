function [d,busy_time,total_time,ninq,idle_time,nidle] = computercenter(n,warmup,k,lambda,mu)
% Simulate a computer center with k computers, i.e., a (M/M/k)-queue

%Input
%   n          the number of jobs that are simulated
%   warmup     the lenght of warmup period (#jobs)
%   lambda     the mean inter-arrival time of jobs
%   mu         the mean completion time of jobs

%Output
%   d          the queuing delays of n jobs
%   busy_time  the share of the total time all computers are busy
%   total_time the average processing time of a job
%   ninq       the average number of jobs in queue
%   idle_time  the share of the total time all computers are idle
%   nidle      the average number of idle computers


t=0;                % Simulation clock
ta=exprnd(lambda);  % The time of next job arrival
td=inf;             % Departure time of jobs (set to a dummy value)

warmup_t=0;         % Length of the warmup in simulated time

served=[];          % Jobs being completed (holds departure times)
queue=[];           % Queued jobs (holds arrival times)

n_in=0;             % Number of job arrivals
n_out=0;            % Number of job departures

d=[];               % Queueing delays of jobs in the system
busy_time=0;        % a) The fraction of time all computers are busy
total_time=0;       % b) Mean total time of jobs in the system
ninq=0;             % c) Average number of jobs in queue
idle_time=0;        % d) The fraction of time all computers are idle
nidle=0;            % e) Average number of idle computers


% The main simulation loop
while n_out < n
    
    % If next arrival time is less than next departure, 
    % -> next event is arrival
    if ta < td                  
        
        % Update the number of jobs that have entered the center
        n_in = n_in + 1;    

        % Record performance if warmup has ended
        if n_in > warmup
            
            % Job is not executed immediately on submission
            if length(served) == k
                busy_time = busy_time + (ta-t);
            end

            % Total time the jobs spend in queue or server
            total_time = total_time + (ta-t) * (length(queue) + length(served));  
            
            % Number of jobs awaiting execution.
            ninq = ninq + (ta-t) * length(queue);
            
            % Computer center is idle.
            if isempty(served)
                idle_time = idle_time + (ta-t);          
            end

            % Number of idle computers.
            nidle = nidle + (ta-t) * (k-length(served));   
            
        
        end
            
        % Add either to server or queue
        if length(served) < k
            % Calculate departure time and add to served list
            served = sort([served ta + exprnd(mu)]);
            % Queuing delay is zero
            d(end+1)= 0;
        else
            % Add job arrival time to queue list
            queue = [queue ta];
        end
        
        % Update simulation clock 
        t = ta;
        % Next job arrival time
        ta = ta + exprnd(lambda);
        % Next job departure time
        td = served(1);
        
        
    else 
        % Next event is departure
        
        % Update statistics (A job leaves the center)
        n_out = n_out + 1;
        
        % Record if warmup has ended
        if n_in > warmup
            
            % a)
            if length(served) == k
                busy_time = busy_time + (td-t);          
            end

            % b)
            total_time = total_time + (td-t) * (length(queue)+length(served));    

            % c)
            ninq = ninq + (td-t) * length(queue);           
            
            % d)
            if isempty(served)
                idle_time = idle_time+(td-t);           
            end

            % e)
            nidle = nidle + ( td-t) * (k-length(served));    
        
        end
        
        % Departure (Earliest departure time is removed from the list)
        served = served(2:end);

        % Take next customer from queue, if queue is not empty
        if ~isempty(queue)
            % Determine departure time for the new job and add to served
            served = sort([served td + exprnd(mu)]);
            % Delay is time spent in the queue
            d(end+1)= td - queue(1);
            % Remove from the queue
            queue = queue(2:end);
        end
        
        % Update simulation clock
        t = td;
        if isempty(served)
            % If center is empty, reset next departure time
            td = inf;
        else
            % if center is not empty, set the next departure time
            td = served(1);
        end
        
    end

    % Record length of warmup in time
    if n_in > warmup && warmup_t == 0
        warmup_t = t;
    end
    
end

% Return exactly n delays
d = d(1:n);

% Calculate the performance metrics and take into consideration the warmup 
% time
busy_time = busy_time/(t-warmup_t);
total_time = total_time/(n_in-warmup);
ninq = ninq/(t-warmup_t);
idle_time = idle_time/(t-warmup_t);
nidle = nidle/(t-warmup_t);



