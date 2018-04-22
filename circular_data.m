function [V,s] = circular_data(positive, negative, noise)
% CIRCULAR_DATA Creates linearly non-separable data with some noise
% [V,s] = circular_data(positive, negative, noise)
% Inputs:
%   positive    Number of points with label 1
%   negative    Number of points with label -1
%   noise       Number of noise points
%   randomize   Add random noise to the data matrix
% Outputs:
%   V           Data matrix
%   s           Vector with labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta1 = linspace(0, 2*pi, positive);
theta2 = linspace(0, 2*pi, negative);
x1 = cos(theta1);
y1 = sin(theta1);

x2 = 0.7 .* cos(theta2);
y2 = 0.7 .* sin(theta2);

V = [x1 x2;y1 y2];
V = V';
s = ones(size(V,1),1);
s(1:round(size(V,1)/2)) = -1;

% Noise
if randomize
    V = V + rand(size(V));
    n = randi(2,noise,1)-1;
    s(n==0) = s(n==0)*(-1);
end
end