



function [predicted_data_sda] = analyzePointClouds(predicted_data, ground_truth_data)


    % predicted_data = [fltrd_cords2, filtered_intensities2];
    % ground_truth_data = [fltrd_cords, filtered_intensities] ;

    % Extract relevant columns
    x_pred = predicted_data(:, 1);
    y_pred = predicted_data(:, 2);
    z_pred = predicted_data(:, 3);
    intensity_pred = predicted_data(:, 4);

    x_gt = ground_truth_data(:, 1);
    y_gt = ground_truth_data(:, 2);
    z_gt = ground_truth_data(:, 3);
    intensity_gt = ground_truth_data(:, 4);

    % Filter predicted data based on intensity
    pred_filter = (intensity_pred >= -2) & (intensity_pred <= 1.5);
    predicted_data_filtered = predicted_data(pred_filter, :);

    % Filter ground truth data based on intensity
    gt_filter = (intensity_gt >= -2) & (intensity_gt <= 1.5);
    ground_truth_filtered = ground_truth_data(gt_filter, :);

    % Initialize the output for signed distance analysis
    num_points = size(predicted_data_filtered, 1);
    predicted_data_sda = zeros(num_points, 4); % Allocate space for distance + point coordinates

    % Perform signed distance analysis
    for i = 1:num_points
        % Current point in the predicted data
        point_pred = predicted_data_filtered(i, 1:3);

        % Calculate distances to all points in the ground truth
        distances = sqrt(sum((ground_truth_filtered(:, 1:3) - point_pred).^2, 2));

        % Find the nearest point and its distance
        [min_distance, idx] = min(distances);
        nearest_point = ground_truth_filtered(idx, 1:3);

        % Record the signed distance and the coordinates of the nearest point
        predicted_data_sda(i, 1) = min_distance; % Distance
        predicted_data_sda(i, 2:4) = nearest_point; % Nearest point's coordinates
    end

 
end



