%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close Figures, clear Workspace and clean Command Window
close all; clear; clc;

% Parameters
use_linear_data = false;
nr_positive_labels = 201;
nr_negative_labels = 200;
nr_noise_points = 40;
radius1 = 1;
radius2 = 0.7;
training_set_proportion = 0.6;
plot_real_against_forecast_labels = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if use_linear_data
    % Create linearly separable data set
    [V,e] = linear_data(nr_positive_labels, nr_negative_labels, nr_noise_points);
else
    % Create linearly non-separable data set
    [V,e] = circle_data(nr_positive_labels, nr_negative_labels, nr_noise_points);
end

% Split data into Training and Test sets
[V_train,e_train,V_test,e_test] = split_data(V, e, training_set_proportion);

% Train the model
[a, b, ~, f] = Main_nienke(V_train,e_train); %%%%%%%%%%%%%%%% <--- THIS SHOULD BE CHANGED

% Forecast labels for the Test set
e_forecast = forecast(V_test, a, b);

% Calculate performance measures
[table,hit_rate,true_positive,true_negative,F1_score,alpha_acceptance] = performance(e_test, e_forecast, plot_real_against_forecast_labels);

% Plot Training, Test and Forecast sets
hold on
figure()
fig1 = subplot(1,3,1);
[~] = plotting(V_train,e_train,a,b);
title('Train data')
legend('off')
pos1 = get(fig1, 'Position');
new_pos1 = pos1 + [-0.03 -0.13 0 0.13];
set(fig1, 'Position', new_pos1)

fig2 = subplot(1,3,2);
[axis] = plotting(V_test,e_test,a,b);
title('Test data')
legend('off')
pos2 = get(fig2, 'Position');
new_pos1 = pos2 + [0 -0.13 0 0.13];
set(fig2, 'Position', new_pos1)

fig3 = subplot(1,3,3);
[~] = plotting(V_test,e_forecast,a,b);
title('Forecast data')
legend('off')
pos3 = get(fig3, 'Position');
new_pos1 = pos3 + [0.03 -0.13 0 0.13];
set(fig3, 'Position', new_pos1)

legend(axis(2:3), [215 10 2 3], 'Orientation', 'horizontal')
hold off

