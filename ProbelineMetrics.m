

function [center_distance, angle_deg] = ProbelineMetrics(line1, line2)
% lineMetrics calculates the distance between centers and angle between two 3D lines.
%   INPUTS:
%   line1: Nx3 matrix representing the first line's 3D coordinates [x1 y1 z1]
%   line2: Nx3 matrix representing the second line's 3D coordinates [x2 y2 z2]
%
%   OUTPUTS:
%   center_distance: Distance between the centers of the two lines
%   angle_deg: Angle between the two lines in degrees

    % Extract coordinates from input
    x1 = line1(:, 1);
    y1 = line1(:, 2);
    z1 = line1(:, 3);
    x2 = line2(:, 1);
    y2 = line2(:, 2);
    z2 = line2(:, 3);
    
    % Calculate direction vectors for each line
    v1 = [x1(end) - x1(1), y1(end) - y1(1), z1(end) - z1(1)];
    v2 = [x2(end) - x2(1), y2(end) - y2(1), z2(end) - z2(1)];

    % Calculate the angle between the two lines (vectors)
    cos_theta = dot(v1, v2) / (norm(v1) * norm(v2));
    angle_rad = acos(cos_theta); % Angle in radians
    angle_deg = rad2deg(angle_rad); % Angle in degrees

    % Calculate the average center of each line
    center1 = [mean(x1), mean(y1), mean(z1)];
    center2 = [mean(x2), mean(y2), mean(z2)];

    % Calculate the distance between the centers of the lines
    center_distance = norm(center1 - center2);
end






%%
% clc
% clear
% 
% 
% % Define the points for the two lines
% n_points = 100;
% % Line 1 points
% x1 = linspace(0, 10, n_points);
% y1 = linspace(0, 10, n_points);
% z1 = linspace(0, 10, n_points);
% 
% % Line 2 points (let's make a line with a different direction)
% x2 = linspace(0, 10, n_points);
% y2 = linspace(10, 0, n_points);
% z2 = linspace(0, 10, n_points);
% 
% % Plot the lines
% figure;
% plot3(x1, y1, z1, '-r', 'LineWidth', 2);
% hold on;
% plot3(x2, y2, z2, '-b', 'LineWidth', 2);
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('3D Lines and Calculations');
% grid on;
% 
% % Calculate direction vectors
% 
% %   START FUNCTION   inputs:   [ [x1 y1 z1], [x2 y2 z2]  ]
% v1 = [x1(end) - x1(1), y1(end) - y1(1), z1(end) - z1(1)];
% v2 = [x2(end) - x2(1), y2(end) - y2(1), z2(end) - z2(1)];
% 
% % Calculate the angle between the two lines (vectors)
% cos_theta = dot(v1, v2) / (norm(v1) * norm(v2));
% angle_rad = acos(cos_theta); % Angle in radians
% angle_deg = rad2deg(angle_rad); % Angle in degrees
% 
% % Calculate the average center of each line
% center1 = [mean(x1), mean(y1), mean(z1)];
% center2 = [mean(x2), mean(y2), mean(z2)];
% 
% % Calculate the distance between the centers of the lines
% center_distance = norm(center1 - center2);
% % End functions 
% % OUTPUTS  [  center_distance     angle_deg  ]
% 
% 
% 
% % Annotate the plot with the calculated values
% text(center1(1), center1(2), center1(3), ['C1: (' num2str(center1) ')'], 'Color', 'r');
% text(center2(1), center2(2), center2(3), ['C2: (' num2str(center2) ')'], 'Color', 'b');
% annotation_text = sprintf('Angle: %.2f degrees\nDistance between centers: %.2f', angle_deg, center_distance);
% text(center1(1), center1(2), center1(3)-2, annotation_text, 'Color', 'k');
% 
% % Finalize plot
% legend({'Line 1', 'Line 2'}, 'Location', 'Best');
% hold off;