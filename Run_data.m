%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close Figures, clear Workspace and clean Command Window
close all; clear; clc;

% Parameters
use_user_input_data = false;
plot_user_data = true;
user_input_data = 'data_small.mat';
use_linear_data = true;
nr_positive_labels = 2250;                 % number of V rows
nr_negative_labels = 1260;                 % number of V rows (add to above)
nr_noise_points = 0;
add_random_noise = false;
nr_data_columns = 2;                     % number of V columns
training_set_proportion = 0.8;

% Data Reading or Generation
[V, e, allow_data_plot] = fix_data(use_user_input_data, user_input_data, ...
                                   use_linear_data, nr_positive_labels, ...
                                   nr_negative_labels, nr_noise_points, ...
                                   add_random_noise, nr_data_columns);
                               
% Split data into Training and Test sets
[V_train,e_train,V_test,e_test] = split_data(V, e, training_set_proportion);
