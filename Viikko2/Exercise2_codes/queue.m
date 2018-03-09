function D = queue(N,lambda,mu)
% function D = queue(N,lambda,mu)
% Simulate delays in queue for single server queuing model (M/M/1)
% 
% ---------------------------------------------------------------
% INPUT
% N:       Number of customers (1x1 int)
% lambda:  The mean time between customer arrivals (1x1 double)
% mu:      The mean service time (1x1 double)
% ---------------------------------------------------------------
% OUTPUT
% D:      Service delays of each customer (Nx1 double)
% ---------------------------------------------------------------
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-02-21 Heikki Puustinen


%% Initialization

% Inter-arrival times (create all inter-arrival times at the same time)
% Note that there are N-1 time intervals.
T = <your_code_here>; 

% Service times (again, create all times at the same time)
S = <your_code_here>;     

% Initialize delays
D = zeros(N,1);

%% Simulation

% Delay for customer 1 equals 0 (queue is empty)
D(1) = 0; 

% Loop trough customers 2 to N
for ii = 2:N
    % Calculate the delay using the formula on the exercise paper
    % Delay of the i:th customer is last customers delay + last customers
    % service time - time between the arrivals of the last and current
    % customer
    D(ii) = <your_code_here>;
end

