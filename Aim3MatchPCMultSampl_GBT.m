

function [pointcloud_Z] = Aim3MatchPCMultSampl_GBT(pointcloud_A, pointcloud_B, tol)

    tolerance = 1 + tol;

    % Extract coordinates
    x_A = pointcloud_A(:, 1);
    y_A = pointcloud_A(:, 2);
    z_A = pointcloud_A(:, 3);
    x_B = pointcloud_B(:, 1);
    y_B = pointcloud_B(:, 2);
    z_B = pointcloud_B(:, 3);

    NumPoints = size(pointcloud_A, 1);
    
    % Compute all pairwise distances between pointcloud_A and pointcloud_B
    distances = sqrt((x_B' - x_A).^2 + (y_B' - y_A).^2 + (z_B' - z_A).^2);

    % Find nearest point in B for each point in A and ensure uniqueness
    [min_distances, matched_indices] = min(distances, [], 2);

    % Use knnsearch for finding 3 and 4 nearest neighbors
    C_indices = knnsearch(pointcloud_B, pointcloud_A, 'K', 4);
    D_indices = knnsearch(pointcloud_B, pointcloud_A, 'K', 3);

    % Calculate pointcloud C and D
    pointcloud_C = mean(reshape(pointcloud_B(C_indices, :), [], 4, 3), 2);
    pointcloud_D = mean(reshape(pointcloud_B(D_indices, :), [], 3, 3), 2);
    
    % Calculate distances to warped pointcloud C and D
    distances_to_C = sqrt(sum((squeeze(pointcloud_C) - pointcloud_A).^2, 2)) * tolerance;
    distances_to_D = sqrt(sum((squeeze(pointcloud_D) - pointcloud_A).^2, 2)) * tolerance;

    % Initialize the output pointcloud Z
    pointcloud_Z = zeros(NumPoints, 3);

    % Compare distances and select the best matching point
    for i = 1:NumPoints
        [~, min_index] = min([min_distances(i), distances_to_C(i), distances_to_D(i)]);
        
        switch min_index
            case 1
                pointcloud_Z(i, :) = pointcloud_B(matched_indices(i), :);
            case 2
                pointcloud_Z(i, :) = pointcloud_C(i, :);
            case 3
                pointcloud_Z(i, :) = pointcloud_D(i, :);
        end
    end
end