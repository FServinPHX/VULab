clear 
close all
clc

% Create sample data: Point Cloud A and B
rng('default'); % Seed for reproducibility

% Point Cloud A (Transformed and noisy version of B)
A = mvnrnd([1, 2, 3], eye(3), 100); % Generate random data around [1, 2, 3]
R = [cos(pi/4) -sin(pi/4) 0; sin(pi/4) cos(pi/4) 0; 0 0 1]; % Rotation matrix
T = [5; -3; 2]; % Translation vector
A = A * R + T'; % Apply rotation and translation

% Point Cloud B (Base point cloud)
B = mvnrnd([0, 0, 0], eye(3), 100); % Generate random data around [0, 0, 0]

% Visualizing initial point clouds
figure;
subplot(1, 2, 1);
scatter3(A(:,1), A(:,2), A(:,3), 'r', 'filled');
hold on;
scatter3(B(:,1), B(:,2), B(:,3), 'b', 'filled');
title('Before Alignment');
legend('Point Cloud A', 'Point Bu Cloud B');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
grid on;

% Convert data to point cloud objects
ptCloudA = pointCloud(A);
ptCloudB = pointCloud(B);

% Align Point Cloud A to Point Cloud B using ICP
tform = pcregistericp(ptCloudA, ptCloudB, 'Metric','pointToPoint','Extrapolate', true);
A_aligned = pctransform(ptCloudA, tform);

% Visualizing after alignment
subplot(1, 2, 2);
scatter3(A_aligned.Location(:,1), A_aligned.Location(:,2), A_aligned.Location(:,3), 'r', 'filled');
hold on;
scatter3(B(:,1), B(:,2), B(:,3), 'b', 'filled');
title('After Alignment');
legend('Point Cloud A Aligned', 'Point Cloud B');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
grid on;



%%



% Step 1: Create 3D points
% Generate some random 3D data points
rng(10); % Seed for reproducibility
points = randn(100, 3) * 10; % 100 points spread in a Gaussian distribution

% Step 2: Flip the points upside down
% Invert the z-coordinates to flip the points
flipped_points = points;
flipped_points(:,3) = -flipped_points(:,3);

% Step 3: Plot the original and flipped points
figure;

% Plotting the original points
subplot(1, 2, 1);
scatter3(points(:,1), points(:,2), points(:,3), 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k');
title('Original Points');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
grid on;
view(3);

% Plotting the flipped points
subplot(1, 2, 2);
scatter3(flipped_points(:,1), flipped_points(:,2), flipped_points(:,3), 'filled', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
title('Flipped Points');
xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal;
grid on;
view(3);

% Enhancements for visual appeal
set(gcf, 'Color', 'w'); % Set background color to white
sgtitle('Original and Flipped 3D Points Comparison'); % Super title for the figure

%%






