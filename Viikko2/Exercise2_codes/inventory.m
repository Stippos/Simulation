function C = inventory(s,S,varargin)
% function C = inventory(s,S,varargin)
% The total cost of the (s,S)-inventory simulation
% - At s, order-up-to S
% - Inventory is controlled once a month
% 
% ---------------------------------------------------------------
% INPUT
% s:        Order level (1x1 int)
% S:        Order-up-to level (1x1 in)
% varargin: Plot inventory level if 'plot' is given
% ---------------------------------------------------------------
% OUTPUT
% C:        Total costs (1x1 double)
% ---------------------------------------------------------------
%
% Created: 2018-02-21 Heikki Puustinen

% Check if we wanted to plot
if ~isempty(varargin) && strcmp(varargin{1},'plot')
    bPlot = true;
else
    bPlot = false;
end

%% Initialization

y(1) = 60;              % Initial inventory
Tmax = 120;             % Total simulation time (months)             

held = 0;               % Number of held items during simulation
back = 0;               % Number of backlogged items during simulation              

c_f = 32;               % Fixed order costs                 
c_v = 3;                % Order cost per item

order_cost = 0;         % Total order costs during simulation
hold_cost = 1;          % Holding cost of items
short_cost = 5;         % Shortage cost of items

mtd = 0.1;              % Mean time between deliveries
dp = [1/6 3/6 5/6 1];   % Cumulative probabilities for size of demand

t(1) = 0;               % Simulation time
tp = 0;                 % Time of previous event
D = 0;                  % Demand of items
td = 0;                 % Time of next delivery (items leave inventory)
tc = 1;                 % Time, when inventory is next controlled
ts = 0;                 % Time of next supply (items arrive at inventory)
oa = 0;                 % Order amount

% Time of first supply is first set to a large number (so that it doesn't
% happen before it's time is determined)
ts = Tmax+1;

% Time of first demand
td = exprnd(mtd);

%% Simulation

% Continue simulation while simulation time is less than the maximum time
while t(end) < Tmax
    
    % The simulation has three kind of events:
    % 1) Delivery is made out of the inventory
    % 2) The inventory is controlled
    % 3) The inventory is replenished

    % Time of delivery is the next event, i.e., it has smallest time
    if td <= ts && td <= tc    
        
        % Update simulation time to the time of current event time
        t(end+1) = td;
        
        % Update counters for held or backlogged items
        
        % If there are items in inventory, add to held items the size of
        % the inventory times the time interval between now and last event
        if y(end) > 0
            held = held + y(end) * (t(end) - tp);
        elseif y(end) < 0
            % If inventory is empty and items are backlogged, calculate the
            % backlogged items similarly
            back = back - y(end) * (t(end) - tp);
        end
        
        % Update time of previous event to now
        tp = t(end);
        
        % Generate random number from the uniform distribution in order to
        % determine the demand.
        u = rand;
        
        % Loop through demand probabilities
        for ii = 1:length(dp)
            
            % If demand is less than ii:th element
            if u < dp(ii)
                % Set demand as the ii
                D = ii;
                % Break out from the loop as we found our demand
                break;
            end
        end
                
        % Update inventory level
        y(end+1) = y(end) - D;
        
        % Generate time of next demand
        td = t(end) + exprnd(mtd);
        
        
    elseif tc < td && tc < ts
        % Inventory control is the next event, i.e., it has the smallest
        % time
        
        % Update simulation time to currenct event time
        t(end+1) = tc;
        
        % Update counters for held or backlogged items
        if y(end) > 0
            held = held + y(end) * (t(end) - tp);
        elseif y(end) < 0
            back = back - y(end) * (t(end) - tp);
        end
        
        % Update time of the previous event to now
        tp = t(end);
        
        % Check, if inventory level is under s
        if y(end) < s
            % Order amount (S-inventory)
            oa = S - y(end);   
            % Order delay
            ts = t(end) + unifrnd(0.5,1);   
            % Order costs (fixed + variable)
            order_cost =  order_cost + c_f + c_v * oa;
        end 
        
        % Inventory level is not changed
        y(end+1) = y(end);
        
        % Update time of next control - at the start of next month
        tc= t(end)+1;
        
    elseif ts < td && ts < tc     
        % Order arrival (supply) is the next event
        
        % Update Simulation time to current event time
        t(end+1) = ts;
        
        % Update counters for held or backlogged items
        if y(end) > 0
            held = held + y(end) * (t(end) - tp);
        elseif y(end) < 0
            back = back - y(end) * (t(end) - tp);
        end
        
        % Update time of previous event to now
        tp = t(end);
        
        % Update inventory level, i.e., add the order amount to inventory
        y(end+1) = y(end) + oa;
        % Reset time of supply
        ts = Tmax+1;
        % Reset order ammount
        oa = 0;
        
    end
    
    % Update counters from the remaining simulation time 
    % in case all events are scheduled after Tmax
    if min(td,min(ts,tc)) >= Tmax
        
        t(end) = Tmax;
        
        if y(end) > 0
            held = held + y(end) * (t(end)-tp);
        elseif y < 0
            back = back - y(end) * (t(end)-tp);
        end    
    end
end

% Calculate average monthly cost
C = held * hold_cost + back * short_cost + order_cost;
C = C / Tmax;

% Plot inventory level from the simulation
if bPlot
    
    % Note that plotting (t,y) will connect the points with lines
    % indicating that inventory would change linearly. How ever, the
    % inventory changes in discrete time steps and in order to depict this,
    % the following trick is made:
    % Every data point is duplicated so that the size of the inventory is
    % the same between consecutive events.
    
    Y = zeros(2*length(y),1);
    T = zeros(2*length(y)-2,1);
    
    for ii = 1:length(y)
        Y(2*ii-1) = y(ii);
        Y(2*ii) = y(ii);
    end
    
    for ii=2:length(t-1)
        T(2*(ii-2)+1) = t(ii);
        T(2*(ii-2)+2) = t(ii);
    end
    T=[0; T; Tmax];
    
    % Open figure etc.
    h = figure('Name','MS-E2710, Exercise 2.2');
    ax = axes('Parent',h);
    xlabel(ax,'Time [months]')
    ylabel(ax,'Inventory')    
    hold(ax,'on')
    
    
    % Plot inventory level against time
    plot(ax,T,Y,'b');
    
    % Plot zero-level
    plot(ax,[0 Tmax],[0 0],'r')
end

