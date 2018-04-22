function [axis] = plotting(V, s, a, b, p, n, line)
% PLOTTING Plots data points from a 2D matrix "V" according to labels 
% (1 and -1) from a vector "s". Draws a line to linearly separate data. 
% plotting(V, s, a, b, p, n, line)
% Inputs:
%    V      Data matrix
%    s      Vector with labels (1 and -1)
%    a      Line coefficients
%    b      Line intercept
% Optional inputs:
%    p      Color of positive labels
%    n      Color of negative labels
%    line   Color of the line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check for color parameters
if ~exist('p','var')
    p = 'r';
end
if ~exist('n','var')
    n = 'b';
end
if ~exist('line','var')
    line = 'k';
end

% Check for sizes
if size(V,2) ~= 2
    error('Matrix A must have 2 columns')
end
if size(V,1) ~= length(s)
    error(['Vector e must have the same length as the number of columns '...
           'of matrix A'])
end

% Sizes
x_min = min(V(:,1));
x_max = max(V(:,1));
x_delta = 0.1*max([abs(x_max), abs(x_min)]);

% Create line
xp = linspace(x_min-x_delta, x_max+x_delta, 100);
if a(2) == 0
    yp = -(a(1)*xp + b);
else
    yp = -(a(1)*xp + b)/a(2);
end

% Points plot and line
[~] = plot_data(V, s, p, n);
hold on;
plot(xp, yp, 'Color', line, 'LineWidth', 3);
hold off
axis = get(gca,'Children');

% Parameters
title('Linear data separation')
xlabel('attribute_1')
ylabel('attribute_2')
legend('Positive', 'Negative','Location','southoutside')
end