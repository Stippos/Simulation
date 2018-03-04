% MS-E2170 Simulation
% Exercise 2.2: The total cost of the (s,S)-inventory simulation
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-02-21 Heikki Puustinen

%% Initialization

% Number of replications
M = <your_code_here>;

% Two policies to be tested ([s1, S1; s2, S2])
P = <your_code_here>;

% Confidence level
alpha = 0.05;

%% Simulation

% Initialize matrix where costs are stored
% C(ii,:) = [C_1(ii) C_2(ii)]
C = zeros(M,2);

% Loop through policies
for ii = 1:size(P,1)
    % Loop through replications
    for jj = 1:M
        % Call the inventory simulation
        C(jj,ii) = inventory(P(ii,1),P(ii,2));
    end
end

% Calculate differences between policies
D = <your_code_here>;

% Mean difference
D_mean = <your_code_here>;

% Calculate 1-alpha confidence interval for the difference
Ci = <your_code_here>;

%% Results 

fprintf('Results:\n')
% Print values if M is small
if M < 20
    fprintf('| (%i,%i)\t| (%i,%i)\t| difference\n',P(1,1),P(1,2),P(2,1),P(2,2))
    fprintf('------------------------------------\n')
    for ii = 1:size(C,1)
        fprintf('|  %.2f\t|  %.2f\t|  %+.2f\n',C(ii,1),C(ii,2),D(ii))
    end
    fprintf('------------------------------------\n')
end
fprintf('Average difference:\t\t%.2f\n',D_mean)
fprintf('Confidence interval:\t[%.2f %.2f]\n',D_mean-Ci,D_mean+Ci)