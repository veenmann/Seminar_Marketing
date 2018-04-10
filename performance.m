function [table, hit_rate, True_positive, True_negative, F1_score, alpha_acceptance] = performance(y, y_hat)

% Plotting labels
n = length(y);
hold on
scatter(1:n, y, 'MarkerFaceColor', 'b')
scatter(1:n, y_hat, 'r','LineWidth',1.5)
hold off
title('Label comparison')
axis([0 n+1 -1.5 1.5])
legend('Real labels', 'Estimated labels')

% Realization table
p_11 = mean(y_hat == 1 & y == 1);
p_10 = mean(y_hat == 1 & y == -1);
p_01 = mean(y_hat == -1 & y == 1);
p_00 = mean(y_hat == -1 & y == -1);
p_v1 = p_11 + p_01;
p_v0 = p_10 + p_00;

                                                 % y = 1           y = -1
table = [p_11 p_10;...       %  y_hat =  1   % True_positive   False_positive
         p_01 p_00];         %  y_hat = -1   % False_negative  True_negative
 
% Measurements
hit_rate = p_11 + p_00;
True_positive = p_11;
True_negative = p_00;
F1_score = (p_11 + p_00 - p_v1^2 - p_v0^2) / (1 - p_v1^2 - p_v0^2);

% Testing hit_rate against random hit
p = mean(y);
q = p^2 + (1-p)^2;
z_score = (hit_rate - q) / sqrt(q*(1-q));

% Significance levels:
critical_value = Inf;
alpha = 0.01;
while z_score < critical_value
   alpha = alpha + 0.01;
   critical_value = norminv(1 - alpha/2);
end
% Alpha for which y_hat is the same as random labeling
alpha_acceptance = alpha;
end
