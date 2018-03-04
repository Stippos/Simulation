% MS-E2170 Simulation
% Exercise 2.1: Simulate delays in queue for single server queuing model 
%               (M/M/1)
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-02-21 Heikki Puustinen

%% Initialization

% Number of independent replications
M = <your_code_here>;

% Number of customers
N = <your_code_here>;

% Mean time between customer arrivals
lambda = <your_code_here>;

% Mean service time
mu = <your_code_here>;

% Significance level
alpha = <your_code_here>;

%% Simulation

% Initialize vector where mean delay times are saved
D_mean = zeros(M,1);

% Loop through replications
for ii = 1:M
    % Call the queueing model
    D = queue(N,lambda,mu);
    
    % Recall that D holds all the delays. We need the mean:
    D_mean(ii) = <your_code_here>;
end

% Calculate 1-alpha confidence interval. Use the Student's t-distribution
% with M-1 degrees of freedom. Hint: 'tinv'
Ci = <your_code_here>;


%% Results 

fprintf('Results:\n')
fprintf('Estimate of the average delay: %.3f %s %.3f \n', ...
    mean(D_mean), 177, Ci)

%% Plotting

% Calculate convergence and confidence intervals
D_convergence = zeros(M,1);
Ci = zeros(M,1);
for ii = 1:M;
    % Calculate average of samples 1 to ii.
    D_convergence(ii) = mean(D_mean(1:ii));
    
    % Calculate confidence interval
    Ci(ii) = tinv(1-alpha/2,ii-1) * sqrt(var(D_mean(1:ii))/ii);
end

% Open new window etc.
f1 = figure('Name','MS-E20170, Exercise 2.1: Convergence of mean delay');
ax1 = axes('Parent',f1);
hold(ax1,'on')
title(ax1,'Convergence')
xlabel(ax1,'Replications')
ylabel(ax1,'Average delay')

% Plot convergence
plot(ax1,1:M,D_convergence,'r'); 

% Annotation
text(M,D_convergence(end),num2str(D_convergence(end)) ,'Parent',ax1,'Color','r')

% Plot Confidence intervals
plot(ax1,1:M,D_convergence + Ci,'b')
plot(ax1,1:M,D_convergence - Ci,'b')

legend(ax1,'Average delay','Ci')
