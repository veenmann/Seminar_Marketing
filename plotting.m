function plotting(optimization, A, e)
%PLOTTING Plots data points from a 2D matrix "A" according to labels (1 and -1)
%from a vector "e". Draws a line to linearly separate data. Line 
%coefficients are obtained from a function handle "optimizaiotn"
%
% How to call: plotting(@write_function_name, A, e)

if size(A,2) ~= 2
    error('Matrix A must have 2 columns')
end
if size(A,1) ~= length(e)
    error('Vector e must have the same number of columns as the matrix A')
end

% Sizes
x_min = min(A(:,1));
x_max = max(A(:,1));
x_delta = 0.1*max([abs(x_max), abs(x_min)]);
y_min = min(A(:,2));
y_max = max(A(:,2));
y_delta = 0.1*max([abs(y_max), abs(y_min)]);

% Optimization function
[a, b] = optimization(A,e);

% Line plot
xp = linspace(x_min-x_delta, x_max+x_delta, 100);
if a(2) == 0
    yp = -(a(1)*xp + b);
else
    yp = -(a(1)*xp + b)/a(2);
end

% Points plot
plotData(A, e);
hold on;
plot(xp, yp, '-g'); 
hold off

% Parameters
title('Linear data separation')
xlabel('attribute_1')
ylabel('attribute_2')
legend('Positive', 'Negative','Location','southwest')
%axis([x_min-x_delta x_max+x_delta y_min-y_delta y_max+y_delta])
end

function plotData(X, y)
%PLOTDATA Plots the data points X and y into a new figure 
%   PLOTDATA(x,y) plots the data points with + for the positive examples
%   and o for the negative examples. X is assumed to be a Mx2 matrix.
%
% Note: This was slightly modified such that it expects y = 1 or y = -1

% Find Indices of Positive and Negative Examples
pos = find(y == 1); neg = find(y == -1);

% Plot Examples
plot(X(pos, 1), X(pos, 2), 'b.', 'LineWidth', 1, 'MarkerSize', 10)
hold on;
plot(X(neg, 1), X(neg, 2), 'r.', 'LineWidth', 1, 'MarkerSize', 10)
hold off;
end
