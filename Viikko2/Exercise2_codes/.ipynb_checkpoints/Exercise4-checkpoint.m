% MS-E2170 Simulation
% Exercise 2.4: M/M/k queue
% 
% Created: 2018-02-21 Heikki Puustinen

%% Initialization

% Number of replications
M = 100;
% Confidence level
alpha = 0.05;

% 1) single server
k = 1;
n = 100;
lambda = 1;
mu = 0.9; 

% % 2) 2 servers
% k = 2;
% n = 200;
% lambda = 0.5;
% mu = 0.9; 

%% Simulation

% Initialize variables
d_mean = zeros(M,1);
u_mean = zeros(M,1);
nq_mean = zeros(M,1);

% Loop through replications
for ii = 1:M
    % Call the queuing simulation
    [d, u, nq] = queue2(n,k,lambda,mu);
    
    % Save results 
    d_mean(ii) = mean(d);
    u_mean(ii) = u;
    nq_mean(ii) = nq;
end

% CIs
d_ci = tinv(1-alpha/2,M-1) * sqrt(var(d_mean)/M);
u_ci = tinv(1-alpha/2,M-1) * sqrt(var(u_mean)/M);
nq_ci = tinv(1-alpha/2,M-1) * sqrt(var(nq_mean)/M);

%% Results

% Print results
fprintf('Results:\n')
fprintf('Average queuing delay: \t%.2f %s %.2f\n',mean(d_mean),177,d_ci)
fprintf('Number in queue: \t\t%.2f %s %.2f\n',mean(nq_mean),177,nq_ci)
fprintf('Server utilization: \t%.2f %s %.2f\n',mean(u_mean),177,u_ci)
