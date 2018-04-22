%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN OPTIMIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%
%   
%  NOTE: Before running Main_optimization.m one needs to run Main_data.m
%
%
%   if use_Formulation1 == true
%       attempt    0   Original problem
%                  1   Private problem (x = B'w)
%   if use_Formulation1 == false
%       attempt    0 Original problem
%                  1 x = B'w
%                  2 Only V random
%                  3 Permutation
%   For more information check Formulation_nr_1.m and Formulation_nr_2.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close Figures, clear Workspace and clean Command Window
close all; clc;

% Parameters
use_Formulation1 = true;
attempt = 0;
display_performance_measures = false;
plot_real_against_forecast_labels = false;

% Optimization functions
Formulation1 = @Formulation_nr_1;  
Formulation2 = @Formulation_nr_2;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(V,2) ~=2
    allow_data_plot = false;
end

% Train the model
if use_Formulation1
    [a, b, u, f, x] = Formulation1(V_train, s_train, attempt); 
else
    [a, b, y, f, x, t] = Formulation2(V_train, s_train, attempt);
    b = -b;
end

% Do not continue with Formulation2 attempt 2
if ~use_Formulation1 && attempt == 2
    error(['Optimization is completed, but coefficients cannot be '...
           'further used in the Main_optimization.m due to incompatible '...
           'dimensions'])
end

% Forecast labels for the Test data set
s_forecast = forecast(V_test, a, b);
    
% Calculate performance measures
if size(s_test,1) == 0
    plot_real_against_forecast_labels = false;
end
if size(s_test,1) == 0 && display_performance_measures
    plot_real_against_forecast_labels = false;
    display_performance_measures = false;
    warning('The whole data set is assigned to the Training set')
    fprintf('\n');

[table,hit_rate,true_positive,true_negative,F1_score,alpha_acceptance] = ...
        performance(s_test, s_forecast, plot_real_against_forecast_labels);
if display_performance_measures
    disp('Prediction-realization table:');disp(table);
    disp('Hit-rate:');disp(hit_rate);
    disp('Proportion of True Positive:');disp(true_positive);
    disp('Proportion of True Negative:');disp(true_negative);
    disp('F1 score:');disp(F1_score);
    disp(['Our model is not significantly different from random for '...
          'significane level:']);disp(alpha_acceptance);
end
end

% Plot Training, Test data sets
if ((nr_data_columns == 2 || use_linear_data == false)&&allow_data_plot)...
    || (plot_user_data && allow_data_plot)
    hold on
    figure();
    fig1 = subplot(1,2,1);
    [~] = plotting(V_train,s_train,a,b);
    title('Train data')
    legend('off')
    pos1 = get(fig1, 'Position');
    new_pos1 = pos1 + [-0.03 -0.13 0 0.13];
    set(fig1, 'Position', new_pos1)

    fig2 = subplot(1,2,2);
    [axis] = plotting(V_test,s_test,a,b);
    title('Test data')
    legend('off')
    pos2 = get(fig2, 'Position');
    new_pos1 = pos2 + [0 -0.13 0 0.13];
    set(fig2, 'Position', new_pos1)

    legend(axis(2:3), [215 10 2 3], 'Orientation', 'horizontal')
    hold off
end

if plot_user_data && ~allow_data_plot
    warning(['User input data matrix V must have 2 columns to be plotted'...
              'check Main_data.m'])
end
