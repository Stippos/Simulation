% MS-E2170 Simulation
% Exercise 2.3: A computer center
% a) The probability that a job is not executed immediately on submission.
% b) The average time until the output of a job is returned to the user.
% c) The average number of jobs awaiting execution.
% d) The percentage of time the entire computer center is idle.
% e) The average number of idle computers.
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-02-21 Heikki Puustinen

%% Initialization

% Number of replications 
M = <your_code_here>;

% Number of jobs to simulate
n = <your_code_here>;

% Number of users
u = <your_code_here>;

% Number of computers 
k =<your_code_here>;

% Mean time between submissions (minutes)
lambda = <your_code_here>;

% Mean execution time (minutes)
mu = <your_code_here>;

% Warmup period. Set = 0 when determining the warmup period
warmup = 0;


%% Simulation

% Initialize delays
d = zeros(M,n);

% Other metrics
busy_time = zeros(M,1);
total_time = zeros(M,1);
ninq = zeros(M,1);
idle_time = zeros(M,1);
nidle = zeros(M,1);

% Open a waitbar
hWait = waitbar(0,'','Name','MS-E2170, Exercise 2.3');

% Loop through replications
for ii = 1:M
    
    % Update waitbar
    waitbar((ii-1)/M, ...
        hWait, ...
        ['Calculating replication ' num2str(ii) '/' num2str(M)])
    
    % Call the computer center simulation function
    [d(ii,:), busy_time(ii), total_time(ii), ninq(ii), idle_time(ii), nidle(ii)] = ...
        computercenter(n,warmup,k,lambda,mu);
end

% Kill waitbar
delete(hWait)

% All other results except a) are provided.
% a) The probability that a job is not executed immediately on submission
p_queue = <your_code_here>;

%% Results

% Determine the warmup period.
if warmup == 0
    % Warmup period window. From lecture: w <= n/4
    w = <your_code_here>;
    % Welch's procedure
    welch(d,w)
else
    
    fprintf('Results:\n')
    fprintf('---------------------------------------------\n')
    fprintf('a) Probability that job is queued: \t\t%.2f\n',mean(p_queue))
    fprintf('b) Average processing time of a job: \t%.2f\n',mean(total_time))
    fprintf('c) Average number of jobs in queue: \t%.2f\n',mean(ninq))
    fprintf('d) Computer center total idle time: \t%.2f\n',mean(idle_time))
    fprintf('e) Average number of idle computers: \t%.2f\n',mean(nidle))
    fprintf('---------------------------------------------\n')
end
