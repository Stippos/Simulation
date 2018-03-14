% MS-E2170 Simulation
% Exercise 3.1:
% a) Suppose there are 2 configurations of the system with p being either
%    0.3 or 0.8. Make 10 replications of the simulation with both values of
%    p by first using independent random numbers. Then repeat the
%    experiment using common random numbers (CRN) for both inter-arrival
%    times and service times across the systems. Compare the estimated
%    variances of the difference between the performance measures.
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-03-06 Heikki Puustinen

%% Initialization

% Number of replications
M = <your_code_here>;

% Number of customers
N = <your_code_here>;

% Mean time between arrivals
lambda = <your_code_here>;

% Mean service time for server 1
mu1 = <your_code_here>;

% Mean service time for server 2
mu2 = <your_code_here>;

% Probability that a customer leaves the system after server 1
% p is a 1x2 vector [p1 p2]
p = <your_code_here>

% Create 4 random number streams for each replication (2*M)
% 1) inter-arrival times (ua)
% 2) service times for server 1 (ud1)
% 3) servive times for server 2 (ud2)
% 4) probabilities that the customers leave after server 1 (up)
% Hint: randStream.create and use 'mrg32K3a'-keyword for multiple sreams

% Initialize stream variables
ua = cell(2*M,1);
ud1 = cell(2*M,1);
ud2 = cell(2*M,1);
up = cell(2*M,1);

% M replications, 2 experiments => 2 * M * 4 streams
for ii = 1:2*M
    % Create streams for each entity (4 streams for each replication):
    % Use, e.g., 'mrg32K3a' algorithm and 'shuffle' as seed
    [ua{ii}, ud1{ii}, ud2{ii}, up{ii}] = <your_code_here>
end

% Variable for average waiting time (independent case).
% Column 1: p = 0.3, Column 2: p = 0.8
W_i = zeros(M,2);

% Variable for average waiting time (CRN case)
% Column 1: p = 0.3, Column 2: p = 0.8
W_c = zeros(M,2);

%% Simulation

% 1) Independent random numbers: use new streams on each replication

% Case 1: Probability p=0.3 (Use first 10 streams for each entity)

% Loop through replications
for jj = 1:M

    % Call the queuing model. Note that lambda, mu1 and mu2 are mean
    % times but the model takes in rates (1 / time) as input
    % Note: Use jj:th streams, i.e., ua{jj} and so on
    [y,n_in,n_out] = ...
        queue1(N,1/lambda,1/mu1,1/mu2,p(1),ua{jj},ud1{jj},ud2{jj},up{jj},0);
    
    % Save variables
    W_i(jj,1) = y;
end

% Case 2: Probability p=0.8 (Use 11-20 streams for each entity)

% Loop through replications
for jj = 1:M
    
    % Call the queuing model. Note that lambda, mu1 and mu2 are mean
    % times but the model takes in rates (1 / time) as input
    % Note: Use M+jj:th streams, i.e., ua{M+jj} and so on
    [y,n_in,n_out] = ...
        queue1(N,1/lambda,1/mu1,1/mu2,p(2),ua{M+jj},ud1{M+jj},ud2{M+jj},up{M+jj},0);
    
    % Save variables
    W_i(jj,2) = y;
end

% Calculate the difference between average waiting times (independent)
D_i = W_i(:,1) - W_i(:,2);

% Calculate average difference
M_i = mean(D_i);

% Variance of difference
V_i = var(D_i);

% 2) Common random numbers: use the first 10 streams for p = 0.3, then
%    reset streams and use them for p = 0.8

% Case 1: Probability p=0.3 (Use first 10 streams for each entity)

% Loop through replications
for jj = 1:M
    
    % Reset jj:th streams. Hint: reset
    reset(ua{jj});
    reset(ud1{jj});
    reset(ud2{jj});
    reset(up{jj});
    
    % Call the queuing model. Note that lambda, mu1 and mu2 are mean
    % times but the model takes in rates (1 / time) as input.
    [y,n_in,n_out] = ...
        queue1(N,1/lambda,1/mu1,1/mu2,p(1),ua{jj},ud1{jj},ud2{jj},up{jj},0);
    
    % Save variables
    W_c(jj,1) = y;
end

% Case 2: Probability p=0.8 (Use first 10 streams for each entity)

% Loop through replications
for jj = 1:M
    
    % Reset jj:th streams. Hint: reset
    reset(ua{jj});
    reset(ud1{jj});
    reset(ud2{jj});
    reset(up{jj});
    
    % Call the queuing model. Note that lambda, mu1 and mu2 are mean
    % times but the model takes in rates (1 / time) as input.
    [y,n_in,n_out] = ...
        queue1(N,1/lambda,1/mu1,1/mu2,p(2),ua{jj},ud1{jj},ud2{jj},up{jj},0);
    
    % Save variables
    W_c(jj,2) = y;
end
    

% Calculate the difference between average waiting times (CRN)
D_c = W_c(:,1) - W_c(:,2);

% Calculate average diference
M_c = mean(D_c);

% Variance of difference
V_c = var(D_c);


%% RESULTS

str = {'independent','common'};

fprintf('Results:\n')

% Print table if M is small
if M < 20
    
    % Header
    fprintf('\t Independent\t\t\t\t\t  CRN\n')
    fprintf('Rep\t| p=0.3\t| p=0.8\t| difference\t| p=0.3\t| p=0.8\t| difference\n')
    fprintf('----------------------------------------------------------------\n')
    % Results of each replication
    for ii = 1:M
        fprintf('%i\t|  %.2f\t|  %.2f\t|  %.2f \t\t| %.2f\t|  %.2f\t|  %.2f\n', ...
            ii,W_i(ii,1),W_i(ii,2),D_i(ii),W_c(ii,1),W_c(ii,2),D_c(ii))
    end
    fprintf('----------------------------------------------------------------\n')
else
    fprintf('\t\t\t\t\t   Independent\t\t\t\t\t   CRN\n')
end
% Averages
fprintf('Average \t\t\t   %.2f \t\t\t\t\t\t   %.2f\n',M_i,M_c)
% Variance
fprintf('Variance\t\t\t   %.2f \t\t\t\t\t\t   %.2f\n',V_i,V_c)

%% Plotting

% New figure
fig = figure('Name','MS-E2170 Simulation, Exercise 3.1a');

% First axes to plot correlation between the independent cases
ax1 = axes('Parent',fig,'OuterPosition',[0 0 0.5 1],'DataAspectRatio',[1 1 1]);
hold(ax1,'on')
title(ax1,sprintf('Independent, corr: %.2f',corr2(W_i(:,1),W_i(:,2))))
xlabel(ax1,'p=0.3')
ylabel(ax1,'p=0.8')

% Second axes to plot correlation between the CRN cases
ax2 = axes('Parent',fig,'OuterPosition',[0.5 0 0.5 1],'DataAspectRatio',[1 1 1]);
hold(ax2,'on')
title(ax2,sprintf('CRN, corr: %.2f',corr2(W_c(:,1),W_c(:,2))))
xlabel(ax2,'p=0.3')
ylabel(ax2,'p=0.8')

% Scatter plots of independent cases p=0.3 v. p=0.8
scatter(ax1,W_i(:,1),W_i(:,2))
% Scatter plots of CRN cases p=0.3 v. p=0.8
scatter(ax2,W_c(:,1),W_c(:,2))

% Make axes limits identical
xMin = min([W_i(:,1); W_c(:,1)]);
xMax = max([W_i(:,1); W_c(:,1)]);
yMin = min([W_i(:,2); W_c(:,2)]);
yMax = max([W_i(:,2); W_c(:,2)]);

set(ax1,'XLim',[xMin xMax],'YLim',[yMin yMax])
set(ax2,'XLim',[xMin xMax],'YLim',[yMin yMax])
