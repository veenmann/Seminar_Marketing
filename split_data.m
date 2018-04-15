function [V_train, e_train, V_test, e_test] = split_data(V, e, p)
% SPLIT_DATA Splits data into Training and Test sets
% [V_train, e_train, V_test, e_test] = split_data(V, e, p)
% Inputs:
%   V         Data matrix
%   e         Vector with labels
%   p         Proportion of Training data
% Outputs:
%   V_train   Training data matrix
%   e_train   Training vector with labels
%   V_test    Test data matrix
%   e_test    Test vector with labels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
train = round(length(e)*p);
test = length(e) - train;
mix = [ones(train,1); zeros(test,1)];
mix = mix(randperm(length(mix)));
V_train = V(mix == 1,:);
e_train = e(mix == 1);
V_test = V(mix == 0,:);
e_test = e(mix == 0);
end