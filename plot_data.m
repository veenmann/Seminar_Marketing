function [axis] =  plot_data(V, s, p, n)
% PLOT_DATA Plots the data points V and s into a new figure based on value 
% of s (1 or -1) 
% plot_data(V, s, p, n)
% Inputs:
%   V      Data matrix
%   s      Vector with labels (1 and -1)
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
pos = find(s == 1); 
neg = find(s == -1);

% Plot Examples
plot(V(pos, 1), V(pos, 2),'.','Color',p,'LineWidth',1,'MarkerSize',10, ...
     'DisplayName', 'Positive')
hold on;
plot(V(neg, 1), V(neg, 2),'.','Color',n,'LineWidth',1,'MarkerSize',10, ... 
     'DisplayName', 'Negative')
hold off;
axis = get(gca,'Children');
end