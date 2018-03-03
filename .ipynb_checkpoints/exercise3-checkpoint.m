% MS-E2170 Simulation
% Exercise 1.3: Random number generation
% 1) Make your own function for both inverse transform and
%    acceptance/rejection method, e.g., 'trirndA' and 'trirndB'.
% 2) Then use this script to plot and compare the generated random numbers.
%
% Fill the '<your_code_here>' with your own input.
%
% Created: 2018-02-19 Heikki Puustinen


%% Initialization

% Sample size
N = <your_code_here>;

% Parameters of the triangular distribution
% a = min, b = max, c = mode.
a = <your_code_here>;
b = <your_code_here>;
c = <your_code_here>;

% Initialize variables for random variates for both methods.
r1 = zeros(N,1);
r2 = zeros(N,1);


%% Simulation

% Initialize timing
tic;

% Generate Nx1 random numbers using the inverse transform method.
for ii = 1:N
    r1(ii) = trirndA(a,b,c);
end

% Observe the spent time.
t1 = toc;

% Generate Nx1 random numbers using the acceptance/rejection method.
for ii = 1:N
    r2(ii) = trirndB(a,b,c);
end

% Observe the spent time.
t2 = toc - t1;

%% Results
fprintf('Results:\n')
fprintf('Inverse transform: %.5f seconds\n',t1)
fprintf('Acceptance/rejection: %.5f seconds\n',t2)
