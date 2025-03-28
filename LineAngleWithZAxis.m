


function [angle1_deg, angle2_deg] = LineAngleWithZAxis(line1, line2)
% LineAngleWithZAxis calculates the angle between two 3D lines and the Z-axis.
% INPUTS:
% line1: Nx3 matrix representing the first line's 3D coordinates [x1 y1 z1]
% line2: Nx3 matrix representing the second line's 3D coordinates [x2 y2 z2]
%
% OUTPUTS:
% angle1_deg: Angle between the first line and the Z-axis in degrees
% angle2_deg: Angle between the second line and the Z-axis in degrees

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

% Define the Z-axis direction vector
zAxis = [0, 0, 1];

% Calculate the angle between each line and the Z-axis
cos_theta1 = dot(v1, zAxis) / (norm(v1) * norm(zAxis));
angle1_rad = acos(cos_theta1); % Angle in radians
angle1_deg = rad2deg(angle1_rad); % Angle in degrees

cos_theta2 = dot(v2, zAxis) / (norm(v2) * norm(zAxis));
angle2_rad = acos(cos_theta2); % Angle in radians
angle2_deg = rad2deg(angle2_rad); % Angle in degrees
end