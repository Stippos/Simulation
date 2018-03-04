function y = trirndB(a,b,c)
% function y = trirndA(a,b,c)
% This function creates a triangularly distributed random variate using 
% the acceptance/rejection method.
% NOTE THAT: a < c < b
% ---------------------------------------------------------------
% INPUT
% a:       Minimum value (1x1 double)
% b:       Maximum value (1x1 double)
% c:       Mode (1x1)
% ---------------------------------------------------------------
% OUTPUT
% y:       Triangularly distributed random variate (1x1 double)
% ---------------------------------------------------------------
% Created:
% 2018-02-19 Heikki Puustinen

% From the lecture notes:
% Let f be the density functon of target distribution
% * Define a function t s.t. t(x) >= f(x) for all x.
% * Define a function r s.t. r(x) = t(x)/c, where c is the value of the 
%   integral of t from -infinity to +infinity.
% 
% 1) Generate Y having density r(x).
% 2) Generate U~U(0,1) independent of Y.
% 3) If U <= f(Y)/t(Y) return Y
%    otherwise return to step 1.

% t(x). Hint: you can make it a constant above the triangular function.
t = <your_code_here>;

% r(x). Hint: Scale t(x) so that integral over r equals 1.
% r = ;

% Initialize acceptance.
accept = false;


% While variate is not accepted
while ~accept
    
    % Draw a random number with density r(x).
    y = <your_code_here>;
    % Draw a random number from U(0,1).
    u = <your_code_here>;
    
    % If y is less than mode of the triangular function
    if y <= <your_code_here>
        % Density function when y < mode
        f = <your_code_here>;
    else
         % If y is greater than mode of the triangular function
        f = <your_code_here>;
    end
    
    if u < f/t
        accept = true;
    end
end


end