% MS-E2170 Simulation
% Exercise 3.1:
% b) For p=0.3, make five pairs of runs using both independent sampling and
%    antithetic variates within each pair. Compare the estimated variances
%    of the performance measures.
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-03-06 Heikki Puustinen

%% Initialization

% Number of replication pairs
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
% Note: now there's only one probability to consider
p = <your_code_here>;

% Create 4 random number streams. Hint: randStream.create
% 1) inter-arrival times
% 2) service times for server 1
% 3) servive times for server 2
% 4) probabilities that the customers leave after server 1

% Initialize stream variables
ua = cell(2*M,1);
ud1 = cell(2*M,1);
ud2 = cell(2*M,1);
up = cell(2*M,1);

% M replications, 2 experiments => 2 * M * 4 streams
for ii = 1:2*M
    % Create streams for each entity:
    % Use, e.g., 'mrg32K3a' algorithm and 'shuffle' as seed
    [ua{ii}, ud1{ii}, ud2{ii}, up{ii}] = <your_code_here>
end

% Variable for average waiting times (independent case)
W_i = zeros(M,2);

% Variable for average waiting times (antithetic case)
W_a = zeros(M,2);

%% Simulation

% 1) Independent case

% Loop through replications (of pairs)
for jj = 1:M
    
    % First replication
    
    % Call the queuing model. Note that lambda, mu1 and mu2 are mean
    % times but the model takes in rates (1 / time) as input.
    % Note: Use jj:th streams, i.e., ua{jj} and so on
    [y,n_in,n_out] = queue1(N,1/lambda,1/mu1,1/mu2,p,ua{jj},ud1{jj},ud2{jj},up{jj},0);
    
    % Save variables
    W_i(jj,1) = y;
    
    % Second replication
    
    % Call the queuing model. Note that lambda, mu1 and mu2 are mean
    % times but the model takes in rates (1 / time) as input.
    % Note: Use M+jj:th streams, i.e., ua{M+jj} and so on
    [y,n_in,n_out] = queue1(N,1/lambda,1/mu1,1/mu2,p,ua{M+jj},ud1{M+jj},ud2{M+jj},up{M+jj},0);
    
    % Save variables
    W_i(jj,2) = y;
    
end

% 2) Antithetic case

% Loop through replication pairs
for jj = 1:M
    
    % First replication using "normal" streams
    
    % Reset jj:th streams
    reset(ua{jj});
    reset(ud1{jj});
    reset(ud2{jj});
    reset(up{jj});
    
    % Call the queuing model. Note that lambda, mu1 and mu2 are mean
    % times but the model takes in rates (1 / time) as input.
    % Note: use jj:th streams, i.e., ua{jj} and so on
    [y,n_in,n_out] = queue1(N,1/lambda,1/mu1,1/mu2,p,ua{jj},ud1{jj},ud2{jj},up{jj},0);
    
    % Save variables
    W_a(jj,1) = y;
    
    % Second replication using antithetic streams
    
    % Reset streams
    reset(ua{jj});
    reset(ud1{jj});
    reset(ud2{jj});
    reset(up{jj});
    
    % Call the queuing model. Note that lambda, mu1 and mu2 are mean
    % times but the model takes in rates (1 / time) as input.
    % Note: use jj:th streams, i.e., ua{jj} and so on
    % and last input must be 1 (for antithetic variates)
    [y,n_in,n_out] = queue1(N,1/lambda,1/mu1,1/mu2,p,ua{jj},ud1{jj},ud2{jj},up{jj},1);
    
    % Save variables
    W_a(jj,2) = y;
end

% Calculate the averages of pairs
W_mean_i = mean(W_i,2);
W_mean_a = mean(W_a,2);

% Calculate variances of the averages
W_var_i = var(W_mean_i);
W_var_a = var(W_mean_a);


%% RESULTS

fprintf('Results:\n')

% Print table if M is small
if M < 20
    % Header
    fprintf('\t\t Independent\t\t\t\t  Antithetic\n')
    fprintf('Pair\t| 1st \t| 2nd \t| average\t| 1st \t| 2nd\t| average\n')
    fprintf('-------------------------------------------------------------\n')
    % Results of each replication
    for ii = 1:M
        fprintf('%i\t\t|  %.2f\t|  %.2f\t|  %.2f \t| %.2f\t|  %.2f\t|  %.2f\n',ii,W_i(ii,1),W_i(ii,2),W_mean_i(ii),W_a(ii,1),W_a(ii,2),W_mean_a(ii))
    end
    fprintf('-------------------------------------------------------------\n')
else
    fprintf('\t\t\t\t\t\t   Independent\t\t\t\t   Antithetic\n')
end
% Averages
fprintf('Average \t\t\t\t   %.2f \t\t\t\t\t   %.2f\n',mean(W_mean_i),mean(W_mean_a))
% Variance
fprintf('Variance\t\t\t\t   %.2f \t\t\t\t\t   %.2f\n',var(W_mean_i),var(W_mean_a))

%% Plotting

fig = figure('Name','MS-E2170 Simulation, Exercise 3.1');

ax1 = axes('Parent',fig,'OuterPosition',[0 0 0.5 1],'DataAspectRatio',[1 1 1]);
hold(ax1,'on')
title(ax1,sprintf('Independent, corr: %.2f',corr2(W_i(:,1),W_i(:,2))))
xlabel(ax1,'u1')
ylabel(ax1,'u2')

ax2 = axes('Parent',fig,'OuterPosition',[0.5 0 0.5 1],'DataAspectRatio',[1 1 1]);
hold(ax2,'on')
title(ax2,sprintf('Antithetic, corr: %.2f',corr2(W_a(:,1),W_a(:,2))))
xlabel(ax2,'u')
ylabel(ax2,'1-u')

scatter(ax1,W_i(:,1),W_i(:,2))
scatter(ax2,W_a(:,1),W_a(:,2))

% Make axes limits identical
xMin = min([W_i(:,1); W_a(:,1)]);
xMax = max([W_i(:,1); W_a(:,1)]);
yMin = min([W_i(:,2); W_a(:,2)]);
yMax = max([W_i(:,2); W_a(:,2)]);

set(ax1,'XLim',[xMin xMax],'YLim',[yMin yMax])
set(ax2,'XLim',[xMin xMax],'YLim',[yMin yMax])

