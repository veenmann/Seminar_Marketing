%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close Figures, clear Workspace and clean Command Window
close all; clc;

% Parameters
use_Formulation1 = false;
display_performance_measures = false;
plot_real_against_forecast_labels = true;

% Optimization functions
Formulation1 = @Formulation_nr_1; %%%%%%%%%%%%%%%% <--- THIS SHOULD BE CHANGED %%%%%%%%%%%%%%%%
Formulation2 = @Working_Formulation_nr_2;  %%%%%%%%%%%%%%%% <--- THIS SHOULD BE CHANGED %%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(V,2) ~=2
    allow_data_plot = false;
end

% Train the model
if use_Formulation1
    [x, f, a, b, y, t] = Formulation1(V_train, e_train);
else
    [a, b, u, f] = Formulation2(V_train, e_train); 
end

% Forecast labels for the Test data set
e_forecast = forecast(V_test, a, b);

% Calculate performance measures
[table,hit_rate,true_positive,true_negative,F1_score,alpha_acceptance] = performance(e_test, e_forecast, plot_real_against_forecast_labels);
if display_performance_measures
    disp('Prediction-realization table:');disp(table);
    disp('Hit-rate:');disp(hit_rate);
    disp('Proportion of True Positive:');disp(true_positive);
    disp('Proportion of True Negative:');disp(true_negative);
    disp('F1 score:');disp(F1_score);
    disp('Our model is not significantly different from random for significane level:');disp(alpha_acceptance);
end

% Plot Training, Test and Forecast data sets
if ((nr_data_columns == 2 || use_linear_data == false) && allow_data_plot) || (plot_user_data && allow_data_plot)
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
end

if plot_user_data && ~allow_data_plot
    warning('User input data matrix A must have 2 columns')
end
