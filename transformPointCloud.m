



function [transformed_Ablation] = transformPointCloud(pointCloud, theta, psi, centralPoint)
    % Input:
    % pointCloud - 300x3 matrix representing the point cloud coordinates [x, y, z]
    % theta - rotation angle in degrees about the Z-axis
    % psi - rotation angle in degrees about the Y-axis
    % centralPoint - 1x3 vector [x_center, y_center, z_center] representing the central point of transformation

    % Convert angles from degrees to radians
    theta_rad = deg2rad(theta);
    psi_rad = deg2rad(psi);

    % Translation to the origin
    translated_points = pointCloud - centralPoint;

    % Rotation matrices
    R_theta = [cos(theta_rad) -sin(theta_rad) 0;
               sin(theta_rad)  cos(theta_rad) 0;
               0               0              1];  % Rotation about Z-axis

    R_psi = [cos(psi_rad)  0  sin(psi_rad);
             0             1  0;
            -sin(psi_rad)  0  cos(psi_rad)];  % Rotation about Y-axis

    % Combined rotation matrix
    R = R_psi * R_theta;

    % Apply rotation
    rotated_points = (R * translated_points')';

    % Translate back to original central point
    transformed_points = rotated_points + centralPoint;


    transformed_Ablation = transformed_points;
    % Display some information
    fprintf('Transformation complete. Rotated by θ = %.2f degrees, ψ = %.2f degrees around point [%f, %f, %f].\n', ...
        theta, psi, centralPoint(1), centralPoint(2), centralPoint(3));
end