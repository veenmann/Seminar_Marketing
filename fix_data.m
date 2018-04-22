function [V, s, allow_data_plot] = fix_data(use_user_input_data, ...
                                       user_input_data, use_linear_data,...
                                       nr_positive_labels, ...
                                       nr_negative_labels, ...
                                       nr_noise_points, ...
                                       add_random_noise, nr_data_columns)
% FIX_DATA Reads user data or generates random data
% [V, s, allow_data_plot] = fix_data(use_user_input_data, ...
%                                       user_input_data, use_linear_data,...
%                                       nr_positive_labels, ...
%                                       nr_negative_labels, ...
%                                       nr_noise_points, ...
%                                       add_random_noise, nr_data_columns)
% Inputs:
%    use_user_input_data     true if user input data should be read
%    user_input_data         user defined data set (String)
%    use_linear_data         true if generate linearly separable data,
%                            false if generate linearly non-separable data
%    nr_positive_labels      Number of V rows with positive labels
%    nr_negative_labels      Number of V rows with negative labels
%    nr_noise_points         Number of noise points in matrix V
%    nr_data_columns         Number of V columns
%    add_random_noise        true to add more random noise to matrix V
% Outputs:
%    V                       Data matrix
%    s                       Vector with labels
%    allow_data_plot         true if V has 2 columns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allow_data_plot = true;
if use_user_input_data
    load(user_input_data);
    if size(V,2) ~=2
        allow_data_plot = false;
    end
else
    if use_linear_data
        % Create linearly separable data set
        [V,s] = linear_data(nr_positive_labels, nr_negative_labels, ...
                            nr_noise_points, nr_data_columns, ...
                            add_random_noise);
    else
        % Create linearly non-separable data set
        [V,s] = circular_data(nr_positive_labels, nr_negative_labels, ...
                              nr_noise_points, add_random_noise);
    end
end
end