%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main_data.m generates data which will be used in Main_optimization,
% hence, it should be run before Main_optimization.
%
% For more information check Main_optimization.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Close Figures, clear Workspace and clean Command Window
close all; clear; clc;

% Parameters
use_user_input_data = true;
plot_user_data = true;
user_input_data = 'satellite_data.mat';
use_linear_data = true;
nr_positive_labels = 225;                 % number of V rows
nr_negative_labels = 126;                 % number of V rows (add to above)
nr_noise_points = 40;
add_random_noise = true;
nr_data_columns = 2;                     % number of V columns
training_set_proportion = 1;

% Data Reading or Generation
[V, s, allow_data_plot] = fix_data(use_user_input_data, user_input_data, ...
                                   use_linear_data, nr_positive_labels, ...
                                   nr_negative_labels, nr_noise_points, ...
                                   add_random_noise, nr_data_columns);
                               
% Split data into Training and Test sets
[V_train,s_train,V_test,s_test] = split_data(V, s, training_set_proportion);