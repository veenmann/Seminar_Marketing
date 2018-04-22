function [table,hit_rate,true_positive,true_negative,F1_score,...
          alpha_acceptance] = performance(s, s_forecast, ...
                                          plot_true_vs_forecast)
% PERFORMANCE Calculates performance measures
% [table,hit_rate,true_positive,true_negative,F1_score,alpha_acceptance] =
% performance(s, s_forecast, plot_true_vs_forecast)
% Inputs:
%   s                       Vector with labels (1 and -1)
%   s_forecast              Vector with predicted labels (1 and -1)
%   plot_true_vs_forecast   Plot true labels vs forecast labels (boolean)
% Outputs:
%   table                   Prediction realization matrix
%   hit_rate                Hit rate = True positive + True Negative
%   true_positive           True positive fraction
%   true_negative           True negative fraction
%   F1_score                NO IDEA HOW TO DEFINE ??????????????????
%   alpha_acceptance        Significance level for which e_forecast is not
%                           significantly different from random hits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = length(s);

% Plotting labels
if plot_true_vs_forecast
    figure()
    hold on
    scatter(1:n, s, '.m','LineWidth',10)
    scatter(1:n, s_forecast, '.g','LineWidth',10)
    hold off
    title('Label comparison')
    axis([0 n+1 -1.5 1.5])
    legend('Real labels', 'Estimated labels','Location','southeast')
end

% Realization table
p_11 = mean(s_forecast == 1 & s == 1);
p_10 = mean(s_forecast == 1 & s == -1);
p_01 = mean(s_forecast == -1 & s == 1);
p_00 = mean(s_forecast == -1 & s == -1);
p_v1 = p_11 + p_01;
p_v0 = p_10 + p_00;
                                               % y = 1           y = -1
table = [p_11 p_10;...     %  y_hat =  1   % True_positive   False_positive
         p_01 p_00];       %  y_hat = -1   % False_negative  True_negative
 
% Measurements
hit_rate = p_11 + p_00;
true_positive = p_11;
true_negative = p_00;
F1_score = (p_11 + p_00 - p_v1^2 - p_v0^2) / (1 - p_v1^2 - p_v0^2);

% Testing hit_rate against random hit
p = mean(s);
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