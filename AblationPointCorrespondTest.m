
% Create the 3D points
points = randn(26, 3);

% Create the annotations
annotations = (1:26)';

% Plot the points
figure;
scatter3(points(:, 1), points(:, 2), points(:, 3), 'filled');
hold on;

% Add the annotations
text(points(:, 1), points(:, 2), points(:, 3), num2str(annotations), 'FontSize', 12);

% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Scatter Plot with Annotations');

%%
clear

clear

% Specify the folder containing the point cloud files
folder = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2';

% Get a list of all files in the folder
files = dir(fullfile(folder, '*.csv')); % Change the file extension as per your file format
   
% Read the point cloud data from the file
filePath = fullfile(folder, files(1).name);
pointCloudData = load(filePath);
pointCloud = pointCloudData(2:end, (13:15) );



% Find the 30 highest and lowest z points
[~, idxHighestZ] = maxk(pointCloud(:, 3), 30);
[~, idxLowestZ] = mink(pointCloud(:, 3), 30);

% Find the indices of the two furthest apart points among the 30 highest and lowest z points
distHighestZ = pdist2(pointCloud(idxHighestZ, :), pointCloud(idxHighestZ, :));
[~, idxMaxDistHighestZ] = max(distHighestZ(:));
[idx1, idx2] = ind2sub([30, 30], idxMaxDistHighestZ);
pointMaxDistHighestZ1 = pointCloud(idxHighestZ(idx1), :);
pointMaxDistHighestZ2 = pointCloud(idxHighestZ(idx2), :);

% Find the indices of the two furthest apart points among the 30 highest and lowest x points
distLowestZ = pdist2(pointCloud(idxLowestZ, :), pointCloud(idxLowestZ, :));
[~, idxMaxDistLowestZ] = max(distLowestZ(:));
[idx1, idx2] = ind2sub([30, 30], idxMaxDistLowestZ);
pointMaxDistLowestZ1 = pointCloud(idxLowestZ(idx1), :);
pointMaxDistLowestZ2 = pointCloud(idxLowestZ(idx2), :);

% Find the 30 highest and lowest x points
[~, idxHighestX] = maxk(pointCloud(:, 1), 30);
[~, idxLowestX] = mink(pointCloud(:, 1), 30);

% Find the indices of the two furthest apart points among the 30 highest and lowest x points
distHighestX = pdist2(pointCloud(idxHighestX, :), pointCloud(idxHighestX, :));
[~, idxMaxDistHighestX] = max(distHighestX(:));
[idx1, idx2] = ind2sub([30, 30], idxMaxDistHighestX);
pointMaxDistHighestX1 = pointCloud(idxHighestX(idx1), :);
pointMaxDistHighestX2 = pointCloud(idxHighestX(idx2), :);

% Find the indices of the two furthest apart points among the 30 lowest x points
distLowestX = pdist2(pointCloud(idxLowestX, :), pointCloud(idxLowestX, :));
[~, idxMaxDistLowestX] = max(distLowestX(:));
[idx1, idx2] = ind2sub([30, 30], idxMaxDistLowestX);
pointMaxDistLowestX1 = pointCloud(idxLowestX(idx1), :);
pointMaxDistLowestX2 = pointCloud(idxLowestX(idx2), :);

% Find the 30 highest and lowest y points
[~, idxHighestY] = maxk(pointCloud(:, 2), 30);
[~, idxLowestY] = mink(pointCloud(:, 2), 30);

% Find the indices of the two furthest apart points among the 30 highest and lowest y points
distHighestY = pdist2(pointCloud(idxHighestY, :), pointCloud(idxHighestY, :));
[~, idxMaxDistHighestY] = max(distHighestY(:));
[idx1, idx2] = ind2sub([30, 30], idxMaxDistHighestY);
pointMaxDistHighestY1 = pointCloud(idxHighestY(idx1), :);
pointMaxDistHighestY2 = pointCloud(idxHighestY(idx2), :);

% Find the indices of the two furthest apart points among the 30 lowest y points
distLowestY = pdist2(pointCloud(idxLowestY, :), pointCloud(idxLowestY, :));
[~, idxMaxDistLowestY] = max(distLowestY(:));
[idx1, idx2] = ind2sub([30, 30], idxMaxDistLowestY);
pointMaxDistLowestY1 = pointCloud(idxLowestY(idx1), :);
pointMaxDistLowestY2 = pointCloud(idxLowestY(idx2), :);

% Plot the results

figure;
scatter3(pointCloud(:, 1), pointCloud(:, 2), pointCloud(:, 3), 'filled', 'b');
hold on;
scatter3(pointMaxDistHighestZ1(1), pointMaxDistHighestZ1(2), pointMaxDistHighestZ1(3), 61 , 'filled', 'r', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistHighestZ2(1), pointMaxDistHighestZ2(2), pointMaxDistHighestZ2(3),61 , 'filled', 'r', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistLowestZ1(1), pointMaxDistLowestZ1(2), pointMaxDistLowestZ1(3), 61 , 'filled', 'g', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistLowestZ2(1), pointMaxDistLowestZ2(2), pointMaxDistLowestZ2(3),61 , 'filled', 'g', 'MarkerEdgeColor', 'g', 'LineWidth',2);

scatter3(pointMaxDistHighestX1(1), pointMaxDistHighestX1(2), pointMaxDistHighestX1(3),61 , 'filled', 'y', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistHighestX2(1), pointMaxDistHighestX2(2), pointMaxDistHighestX2(3), 61 ,'filled', 'y', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistLowestX1(1), pointMaxDistLowestX1(2), pointMaxDistLowestX1(3), 61 ,'filled', 'm', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistLowestX2(1), pointMaxDistLowestX2(2), pointMaxDistLowestX2(3), 61 ,'filled', 'm', 'MarkerEdgeColor', 'g', 'LineWidth',2);

scatter3(pointMaxDistHighestY1(1), pointMaxDistHighestY1(2), pointMaxDistHighestY1(3),61 , 'filled', 'g', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistHighestY2(1), pointMaxDistHighestY2(2), pointMaxDistHighestY2(3),61 , 'filled', 'g', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistLowestY1(1), pointMaxDistLowestY1(2), pointMaxDistLowestY1(3), 61 ,'filled', 'c', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(pointMaxDistLowestY2(1), pointMaxDistLowestY2(2), pointMaxDistLowestY2(3),61 , 'filled', 'c', 'MarkerEdgeColor', 'g', 'LineWidth',2);


% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal
title('3D Scatter Plot with Annotations');


