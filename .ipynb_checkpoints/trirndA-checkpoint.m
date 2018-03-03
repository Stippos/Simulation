function x = trirndA(a,b,c)
% function x = trirndA(a,b,c)
% This function creates a triangularly distributed random variate using 
% the inverse transform method.
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

% Create a uniform [0 1] distributed random numer.
y = <your_code_here>;

% Cumulative distribution function is: 
%                   0                   , if x < a
% F(x) = (x-a)^2 / ((b-a) * (c-a))      , if a <= x <= c
%        1 - (b-x)^2 / ((b-a) * (b-c))  , if c < x <= b
%                   1                   , if x > b
%
% Solve inverse function: substitute y for F(x) and solve for x.
%                       0                   , if y < 0 or y > 1
% F^(-1)(y) =   sqrt(y * (b-a)*(c-a)) + a   , if y >= 0 and y < (c-a)/(b-a)
%               b - sqrt((1-y)*(b-a)*(b-c)) , if y >= (c-a)/(b-a) and y<=1


% Fill in the proper edge of the domain
if y < <your_code_here>
    % Calculate the value using the inverse function when y is in the above
    % domain.
    x = <your_code_here>;
    % Fill in the proper edge of the domain
elseif y > <your_code_here>
    % Calculate the value using the inverse function when y is in the above
    % domain.
    x = <your_code_here>;
end

end