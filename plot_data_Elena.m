function [axis] =  plot_data(X, y, p, n)
% PLOT_DATA Plots the data points X and y into a new figure based on value of y (1 or -1) 
% plot_data(X, y, p, n)
% Inputs:
%   X      Data matrix
%   y      Vector with labels (1 and -1)
% Optional inputs:
%   p      Color of positive labels
%   n      Color of negative labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check for color parameters
if ~exist('p','var')
    p = 'r';
end
if ~exist('n','var')
    n = 'b';
end

% Find Indices of Positive and Negative Examples
pos = find(y == 1); 
neg = find(y == -1);

% Plot Examples
plot(X(pos, 1), X(pos, 2), '.', 'Color', p, 'LineWidth', 1, 'MarkerSize', 10, 'DisplayName', 'Positive')
hold on;
plot(X(neg, 1), X(neg, 2), '.', 'Color', n, 'LineWidth', 1, 'MarkerSize', 10, 'DisplayName', 'Negative')
hold off;
axis = get(gca,'Children');
end
