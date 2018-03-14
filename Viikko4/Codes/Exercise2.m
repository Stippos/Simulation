% MS-E2170 Simulation
% Exercise 4.2: Stochastic approximation
%
% Compare the following gradient estimation techniques in optimizing the 
% system:
% 1. Finite difference estimation using independent sampling
% 2. Finite difference estimation using correlated random numbers
% 3. Infinitesimal perturbation analysis
% 
% Fill the '<your_code_here>' with your own input.
%
% Created: 2016-03-15 Heikki Puustinen

%% Initialization

% Initial solution
mu0 = 0.5;

% Initial step size 
a0 = 0.01;

% Number of iterations
M = 100;

% Number of replications on each iteration
R = 2;

% Pertubation of decision variable
delta = 0.01;

% Store mus into a matrix, columns represent different techniques (1-3)
MU = zeros(M,3);

% Store simulation outputs y
Y = zeros(M,3);


%% Simulation

% For each mode (1,2,3), call the stochastic approximation routine
% [mu,Y,g,a] = sa(mu0,a0,M,R,mode,delta)

% Loop through techniques
for mode = 1:3
    
   % Call the stochastic approximation function
   [mu, y, g, a] = sa(mu0,a0,M,R,mode,delta);
   
   % Save output (MU(i,mode),Y(i,mode) represents an iteration of the
   % algorithm)
   MU(:,mode) = mu(1:M);
   Y(:,mode) = y;
   
end


%% Results

%% Plotting
h = figure('Name','MS-E2170, Exercise 4.2'); 

ax = zeros(3,1);

% Finite difference, independent
ax(1) = subplot(1,3,1,'Parent',h,'NextPlot','add');
plot(ax(1),MU(:,1),Y(:,1),'b.')
title(ax(1),'Independent')
xlabel(ax(1),'mu')
ylabel(ax(1),'J(mu)')
% Higlight first and best solution
plot(MU(1,1),Y(1,1),'bo')
[minY, ind] = min(Y(:,1));
plot(MU(ind,1),Y(ind,1),'ro')
text(MU(ind,1),Y(ind,1),sprintf('(%.2f,%.2f)',MU(ind,1),Y(ind,1)),'VerticalAlignment','top')


% Finite difference, CRN
ax(2) = subplot(1,3,2,'Parent',h,'NextPlot','add');
plot(ax(2),MU(:,2),Y(:,2),'b.')
title(ax(2),'CRN')
xlabel(ax(2),'mu')
% Higlight first and best solution
plot(MU(1,2),Y(1,2),'bo')
[minY, ind] = min(Y(:,2));
plot(MU(ind,2),Y(ind,2),'ro')
text(MU(ind,2),Y(ind,2),sprintf('(%.2f,%.2f)',MU(ind,2),Y(ind,2)),'VerticalAlignment','top')

% IPA
ax(3) = subplot(1,3,3,'Parent',h,'NextPlot','add');
plot(ax(3),MU(:,3),Y(:,3),'b.')
title(ax(3),'IPA')
xlabel(ax(3),'mu')
% Higlight first and best solution
plot(MU(1,3),Y(1,3),'bo')
[minY, ind] = min(Y(:,3));
plot(MU(ind,3),Y(ind,3),'ro')
text(MU(ind,3),Y(ind,3),sprintf('(%.2f,%.2f)',MU(ind,3),Y(ind,3)),'VerticalAlignment','top')


% Set limits to same
set(ax,'XLim',[0.5 0.8])
set(ax,'YLim',[3 5])