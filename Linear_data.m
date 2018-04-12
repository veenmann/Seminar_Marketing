function [A,e] = Linear_data()
A = rand(401,2);
A(1:200,:) = -1*A(1:200,:);
e = ones(401,1);
e(1:200) = -1;

% Noise
n = randi(2,40,1)-1;
e(n==0) = e(n==0)*(-1);
end