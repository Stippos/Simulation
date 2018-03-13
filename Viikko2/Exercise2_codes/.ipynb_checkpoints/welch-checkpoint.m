function welch(y,w)
% Creates a plot for the Welch-mehtod of determining a warm-up period of a
% steady-state simulation.

ybar = mean(y,1);
ym = ma(ybar,w);

h = figure('Name','MS-E2710, Exercise 2.3: Welch''s prodedure');
ax =axes('Parent',h);
hold(ax,'on');

% Plot averaged waiting time.
plot(ybar,'Color',[0.8 0.8 0.8]);

% Plot smoothed waiting time
plot(ym,'b');

set(gca,'Box','on');
xlabel('Jobs (i)');
ylabel('Y_i(w)');


function y = ma(x,w)
% Calculates the moving average of process x with window w

y = zeros(length(x) - w,1);

for i = 1:length(x) - w
    if i <= w
        y(i) = mean(x(1:(2*i-1)));
    else
        y(i) = mean(x((i-w):(i+w)));
    end    
end
