% MS-E2170 Simulation
% Exercise 3.2: 
% Consider the following changes that could be made to lower the average cost per
% hour for the above described system:
% a) The number of repairmen is increased to 4.
% b) All machines are replaced with more reliable ones. The time to failure 
%    is 16 hours on the average. However, the cost of a failed machine is 
%    100$ per hour.
% c) Expert repairmen replace all standard ones. These men cost 15$ an 
%    hour, but can repair a machine in 1.5 hours on the average. 
%
%    Perform 
%    a full 2^3 factorial experiment to examine the effects of the changes 
%    on the average hourly cost. Replicate the design 5 times to compute 
%    confidence intervals for all main and interaction effects.
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-03-06 Heikki Puustinen

%% Initialization

% Number of replications 
M = <your_code_here>;

% Confidence level 
alpha = <your_code_here>;

% Factor 1: number of repairmen [-level +level]
k = <your_code_here>;

% Factor 2: machine type
lambda = <your_code_here>;  % Mean time between breakdowns [-level +level]
c_f    = <your_code_here>;  % Cost of unavailability/hour [-level +level]

% Factor 3: Repairmen type
mu  = <your_code_here>;      % Mean time to repair a machine [-level +level]
c_r = <your_code_here>;      % Cost of employment/hour [-level +level]

% Initialize design matrix
x = zeros(8,3);

% Initialize effects estimates [e1; e2; e3; e12; e13; e23]
e = zeros(6,M);

% Initialize response variable(2^3=8 combinations)
r = zeros(8,M); 

%% Simulation

% Calculate responses for each factor combination

% Counter for combinations
iCombination = 0;

% Loop through repairmen combinations
for ii = 1:2
    % Loop through machine types
    for jj = 1:2
        % Loop through repairmen types
        for kk = 1:2
            
            % Update counter 
            iCombination = iCombination + 1;
            
            % Calculate x = [+/-1 +/-1 +/-1] for combination. 
            % ith element is -1 if ith factor is in -1 level and  +1 if
            % ith factor in +1 level
            x(iCombination,:) = [(-1)^ii (-1)^jj (-1)^kk];
            
            % Loop through replications
            for mm = 1:M
                % Simulate the repair scenario. Note that function machines
                % takes rates of arrival etc as input, not mean times.
                r(iCombination,mm) = ...
                    machines(k(ii),1/lambda(jj),c_f(jj),1/mu(kk),c_r(kk));
            end
        end
    end
end

% Calculate main effects
for ii = 1:3
    for jj = 1:M
        e(ii,jj) = <your_code_here>;
    end
end

% Calculate interaction effects
int = [1 2; 1 3; 2 3];
for ii = 4:6
    for jj = 1:M
        e(ii,jj) = 1 / (2^(3-1)) * sum(x(:,int(ii-3,1)) .* x(:,int(ii-3,2)) .* r(:,jj));
    end
end

% Calculate confidence intervals
ci = zeros(size(e,1),1);
for ii = 1:size(e,1)
    ci(ii) = tinv(1-alpha/2,M-1) * sqrt(var(e(ii,:))/M);
end

%% Results

% Which effects are significant
iSignificant = sign(mean(e,2) - ci) ==  sign(mean(e,2) + ci);

strEffect = {'e1','e2','e3','e12','e13','e23'};
strSignificant = {'no','yes'};

fprintf('Results:\n')
fprintf('Effect\tAvg\t\t\tCi\t\tSignificant\n')
fprintf('---------------------------------------\n')
for ii = 1:size(e,1)
    fprintf('%s\t\t%.2f\t%s\t%.2f\t%s\n', strEffect{ii},mean(e(ii,:)),177, ci(ii), strSignificant{iSignificant(ii)+1})
end
fprintf('---------------------------------------\n')
