% MS-E2170 Simulation
% Exercise 3.3a:
% We are interested in estimating the expected average total delay in queue
% for the first 100 customers that enter the system. For p=0.8, calculate 
% the controlled estimate of the performance measure by using the total 
% service time as a control variate. Use n=10 as the number of replications
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-03-06 Heikki Puustinen

%% Initialization

% Reset random number stream to produce reproducable results
rng(0)

% Number of replications
M = 10;

% Number of customers
N = 100;

% Mean time between customer arrivals
lambda = 1;

% Mean service time
mu = 0.7;

% Probability that the customer leaves the system after server
p = 0.8;

% Total queuing times
Q = zeros(M,1);

% Service times
S = zeros(M,1);

% Loop through replications
for ii = 1:M
    % Call the queuing simulation
    % Note that it takes rates, not mean times as input
    [tq,ts] = queue2(N,1/lambda,1/mu,p);
    
    % Save average queuing time
    Q(ii) = tq;
    % Save average service time
    S(ii) = ts;
    
end

% Calculate the controlled estimate: X_c = X_mean - a* * (Y_mean - v)

% Covariance matrix
covmat = cov(Q,S);
% Pick covariance of Q and S
C_QS = covmat(1,2);

% Variance of service time
V_s = var(S);

% a* 
a = C_QS / V_s;

% Controlled estimate
Q_c = mean(Q) - a * (mean(S) - (1 + (1-p)) * mu);

%% Results
fprintf('Results:\n')
% Header
fprintf('Replication \t| Avg queuing time\t| Avg service time\n')
fprintf('----------------------------------------------------------------\n')
% Results of each replication
for ii = 1:M
    fprintf('%i\t\t\t\t  %.2f\t\t\t\t  %.2f\t\n',ii,Q(ii),S(ii))
end
fprintf('----------------------------------------------------------------\n')
% Averages
fprintf('Average \t\t  %.3f \t\t\t  %.3f\n',mean(Q),mean(S))
% Controlled estimate
fprintf('Controlled \t\t  %.3f\n',Q_c)

% % Test if controlled estimate is good
% Q = zeros(1000,1);
% % Loop through replications
% for ii = 1:1000
%     [Q(ii),ts] = queue2(N,1/lambda,1/mu,p);
% end
% mean(Q)
