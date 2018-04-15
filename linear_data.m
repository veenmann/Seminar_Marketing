function [V,e] = linear_data(positive, negative, noise, nr_columns, randomize)
% LINEAR_DATA Creates linearly separable data with some noise
% [V,e] = linear_data(positive, negative, noise)
% Inputs:
%   positive      Number of points with label 1
%   negative      Number of points with label -1
%   noise         Number of noise points
%   nr_columns    Number of columns for matrix V
%   randomize     Add random noise to the data matrix
% Outputs:
%   V             Data matrix
%   e             Vector with labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = positive + negative;
V = rand(m,nr_columns);
V(1:negative,:) = -1*V(1:negative,:);
e = ones(m, 1);
e(1:negative) = -1;

% Noise
if randomize
    V = V + rand(size(V));
    n = randi(2,noise,1)-1;
    e(n==0) = e(n==0)*(-1);
end
end