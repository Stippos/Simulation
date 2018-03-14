% MS-E2170 Simulation
% Exercise 3.3b:
% Further, repeat the whole experiment 10 times and compare the variance in
% uncontrolled and controlled estimates for queuing delay.
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-03-06 Heikki Puustinen

%% Initialization

% Reset random number stream to produce reproducable results
rng(0)

% Number of experiments 
n_E = 10;

% Number of replications
n_M = 10;

% Number of customers
N = 100;

% Mean time between customer arrivals
lambda = 1;

% Mean service time
mu = 0.7;

% Probability that the customer leaves the system after server
p = 0.8;

% Average queuing times for experiments
Q_mean = zeros(n_E,1);

% Average service time for experiments
S_mean = zeros(n_E,1);

% Controlled estimates for experiments
Q_c = zeros(n_E,1);

for ii = 1:n_E
    % Total queuing times
    Q = zeros(n_M,1);
    
    % Service times
    S = zeros(n_M,1);
    
    for jj = 1:n_M
        [tq,ts] = queue2(N,1/lambda,1/mu,p);
        
        Q(jj) = tq;
        S(jj) = ts;
        
    end
    
    % Calculate averages
    Q_mean(ii) = mean(Q);
    S_mean(ii) = mean(S);
    
    % Calculate the controlled estimate: X_c = X_mean - a* (Y_mean - v)
    
    % Covariance matrix
    covmat = cov(Q,S);
    % Pick covariance of Q and S
    C_QS = covmat(1,2);
    
    % Variance of service time
    V_s = var(S);
    
    % a*
    a = C_QS / V_s;
    
    % Controlled estimate
    Q_c(ii) = Q_mean(ii) - a * (S_mean(ii) - (1 + (1-p)) * mu);
end


%% Results
fprintf('Results:\n')
% Header
fprintf('Experiment \t| Uncontrolled\t| Controlled\t| Control\n')
fprintf('----------------------------------------------------------------\n')
% Results of each experiment
for ii = 1:n_E
    fprintf('%i\t\t\t  %.2f\t\t\t  %.2f\t\t\t  %.4f\n',ii,Q_mean(ii),Q_c(ii),S_mean(ii))
end
fprintf('----------------------------------------------------------------\n')
% Means
fprintf('Avg\t\t\t  %.3f \t\t  %.3f\n',mean(Q_mean),mean(Q_c))
% Variances
fprintf('Var\t\t\t  %.3f \t\t  %.3f\n',var(Q_mean),var(Q_c))
