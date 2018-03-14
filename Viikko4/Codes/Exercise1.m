% MS-E2170 Simulation
% Exercise 4.1: queuing network
%  Devise and simulate a central composite design to
%  determine a full quadratic regression metamodel for the queing network 
%  with respect to mean processing times. You may decrease and increase the 
%  above parameters for mu_i with 10% to form the – and + levels for the 
%  factors in the design.
% 
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-03-12 Heikki Puustinen

%% Initialization


% Sequence of servers in the simulation 
% (destination server after leaving server i)
seq = [5 6 7 9 8 9 8 10 11 11 12];  
 % Mean inter-arrival times
lambda = [0.5 1 1 0.5];
% Mean service times
mu = [0.4 0.7 0.5 0.3 0.3 0.8 0.2 0.5 0.4 0.5 0.2];   

% Construct a central composite desing (coded factor levels)
% x = [F; E; C]
% F: from factorial experiments, has the combinations of -1 and +1
%    levels for the factors.
% E: [ a  0  0  0 ... 
%     -a  0  0  0 ...
%      0  a  0  0 ...
%      0 -a  0  0 ...
%      . 
%      . 
%      .        ...]; , where a depends on the number of factors.
% C: [ 0 0 0 0 ...];
x = ccdesign(11,'type','circumscribed','center',1);


%% Simulation

% Replicate the simulation to determine responses for each factor
% combination

% Replications per combination
r = 5;

% Initialize response variable
y = zeros(size(x,1),r);

% Loop through designs
for ii = 1:size(x,1)
    
    % Loop through replications
    for kk = 1:r
        
        % Determine simulation response for design ii and replication kk
        y(ii,kk) = queuenetwork(100,1:4,seq,lambda,(1 + 0.1 * x(ii,:)) .* mu);
    end

    % Print combination index and response
    fprintf('Combination: %i / %i \t mean response: %.3f\n',ii,size(x,1),mean(y(ii,:)))
end

%% Regression

% Estimated mean responses for each factor combination
Y = mean(y,2); 
% Estimated variances of the responses for each factor combination
V = var(y,[],2);  
% Corresponding covariance matrix
C = eye(size(x,1)) .* repmat(V,1,size(x,1)); 

% Form the design matrix that includes columns for the intercept as well as
% interaction and quadratic terms
% X = [ ...
% ones(size(x,1),1) x 
% x(:,1) .* x(:,2) x(:,2) .* x(:,3) ... x(:,k-1) .* x(:,k)
% x(:,1).^2 x(:,2).^2 ... x(:,k).^2]:
X = [ones(size(x,1),1) x];

% Generate the interaction columns, loop through factors 1 to 10
for ii = 1:10
    % Loop through factors 1 to 11
    for jj = ii+1:11
        X = [X x(:,ii) .* x(:,jj)];
    end
end

% Generate the quadratic columns, loop through factors 1 to 11
for ii = 1:11
    X = [X x(:,ii).^2];
end

% Calculate the estimated weighted least squares estimates of the 
% regression coefficients (b = (X' * C^(-1) * X)^(-1) * X' * C^(-1) * Y)
beta = inv(X' * inv(C) * X) * X' * inv(C) * Y;

%% Jackknifing

% Determine pseudo-values through jackknifing to determine confidence
% intervals for the regression coefficients 
P = zeros(size(X,2),r);

% Loop through replications
for ii = 1:r
    
    % Omit ii:th replication
    yi = y(:,[1:ii-1 ii+1:r]);
    
    % Calculate mean, variance
    Yi = mean(yi,2);
    Vi = var(y,[],2);
    % Ci: variances on the diagonal
    Ci = eye(size(x,1)).*repmat(Vi,1,size(x,1));
    
    % Calculate the estimated weighted least squares estimates of the
    % regression coefficients
    P(:,ii) = inv(X' * inv(Ci) * X) * X' * inv(Ci) * Yi;
    
end

% The pseudo-values are weighted combinations
% of the original coefficient estimates and
% the ones determined after deleting one replication
P = r * repmat(beta,1,r) - (r-1) * P;   

% Confidence intervals based on t-distribution 
Pci = [ ...
    mean(P,2) - tinv(0.975,r-1) * sqrt(var(P,[],2)/r) ...
    mean(P,2) + tinv(0.975,r-1) * sqrt(var(P,[],2)/r)];

%% RESULTS

[s.beta, CIs] = regress(Y,X);
% 
% % OR 
% % Confidence intervals with ordinary least squares
% s = regstats(Y,x,'quadratic');
% 
% % standard errors
% se = sqrt(diag(s.covb));
% 
% % Confidence intervals, 
% % dof = number of observations (designs) - number of variables
% CIs(:,1) = s.beta - (tinv(0.975,size(X,1)-size(X,2)) .* se);
% CIs(:,2) = s.beta + (tinv(0.975,size(X,1)-size(X,2)) .* se);


% New figure etc.
h = figure('Name','MS-E2170, Exercise 4.1'); 
ax = axes('Parent',h); 
xlabel('Service times mu(i), i = 1:11')
ylabel('Regression coefficient')
hold(ax,'on')

% Which independent variables to plot (mus are variables 2 to 12, the first 
% one is for the constant/intercept)
inds = 2:12; 

% Plot errorbars
b1 = errorbar(ax,mean(P(inds,:),2),(Pci(inds,2)-Pci(inds,1))/2,'rx');
b2 = errorbar(ax,s.beta(inds),(CIs(inds,2)-CIs(inds,1))/2,'bo');

% Legend
legend(ax,[b1 b2],'Jackknifed','OLS')
