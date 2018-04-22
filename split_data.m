function [V_train, s_train, V_test, s_test] = split_data(V, s, p)
% SPLIT_DATA Splits data into Training and Test sets
% [V_train, s_train, V_test, s_test] = split_data(V, s, p)
% Inputs:
%   V            Data matrix
%   s            Vector with labels
%   p            Proportion of Training data
% Outputs:
%   V_train      Training data matrix
%   s_train      Training vector with labels
%   V_test       Test data matrix
%   s_test       Test vector with labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
train = round(length(s)*p);
test = length(s) - train;
mix = [ones(train,1); zeros(test,1)];
mix = mix(randperm(length(mix)));
V_train = V(mix == 1,:);
s_train = s(mix == 1);
V_test = V(mix == 0,:);
s_test = s(mix == 0);
end