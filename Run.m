%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear Workspace and clean Command Window
clear; clc;

% Parameters
use_linear_data = true;
nr_positive_labels = 201;
nr_negative_labels = 200;
nr_noise_points = 40;
radius1 = 1;
radius2 = 0.7;
training_set_proportion = 0.6;

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
[table,hit_rate,True_positive,True_negative,F1_score,alpha_acceptance] = performance(e_test, e_forecast);

% Plot Training, Test and Forecast sets
hold on
subplot(1,3,1)
plotting(V_train,e_train,a,b)
title('Train data')

subplot(1,3,2)
plotting(V_test,e_test,a,b)
title('Test data')

subplot(1,3,3)
plotting(V_test,e_forecast,a,b)
title('Forecast data')
hold off

