function [s_forecast] = forecast(V_test, a, b)
% FORECAST predicts labels {1 and -1} based on optimal inputs
% [e_forecast] = forecast(V_test, a, b).
% Inputs:
%   A     Data matrix
%   a     Hyperplane coefficients vector
%   b     Hyperplane intercept
% Outputs:
%   e     Vector with predicted labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_forecast = V_test*a + b;
s_forecast(s_forecast > 0) = 1;
s_forecast(s_forecast < 0) = -1;
end