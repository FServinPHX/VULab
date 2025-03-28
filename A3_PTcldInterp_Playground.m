

clear 
clc

% Step 1: Creating a Random Point Cloud
numPoints = 2000;
X = rand(numPoints, 1) * 100;
Y = rand(numPoints, 1) * 100;
Z = rand(numPoints, 1) * 100;
points = [X, Y, Z];

% Step 2: Determine Boundary Points
boundaryIndices = boundary(X, Y, Z, 1);
boundaryPoints = points(boundaryIndices, :);

% Step 3: Upsample Boundary to 2000 Points
% Performing linear interpolation along the boundary to upsample
upsampledBoundaryPoints = interp1(1:size(boundaryPoints, 1), boundaryPoints, linspace(1, size(boundaryPoints, 1), 2000), 'linear');

% Step 4: Plotting
figure;

% Original Point Cloud
subplot(1, 2, 1);
scatter3(X, Y, Z, 5, 'filled');
title('Original Point Cloud');
axis equal; grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');

% Final Refined Boundary with Upscaled Points
subplot(1, 2, 2);
scatter3(upsampledBoundaryPoints(:,1), upsampledBoundaryPoints(:,2), upsampledBoundaryPoints(:,3), 5, 'filled');
title('Boundary with Upscaled Points');
axis equal; grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');


%%


% Step 1: Create a Random 3D Point Cloud
numPoints = 2000;
X = rand(numPoints, 1) * 100;
Y = rand(numPoints, 1) * 100;
Z = rand(numPoints, 1) * 100;
points = [X, Y, Z];

% Step 2: Determine Boundary Points
% Delaunay triangulation to find the convex hull, which serves as the boundary
DT = delaunayTriangulation(X, Y, Z);
[K, ~] = convexHull(DT);

% Step 3: Upsample the Boundary
% Create additional points between existing boundary points to achieve a denser boundary.
targetNumBoundaryPoints = 4000; % Target number of points on the boundary
upsampledBoundaryPoints = []; % Initialize an array to hold the upsampled boundary points

for i = 1:numel(K) - 1
    % Extract start and end points of the current boundary segment
    startPoint = DT.Points(K(i), :);
    endPoint = DT.Points(K(i + 1), :);
    
    % Linearly interpolate to create more points between start and end points
    segmentPoints = [linspace(startPoint(1), endPoint(1), round(targetNumBoundaryPoints/numel(K)));
                     linspace(startPoint(2), endPoint(2), round(targetNumBoundaryPoints/numel(K)));
                     linspace(startPoint(3), endPoint(3), round(targetNumBoundaryPoints/numel(K)))]';
    
    upsampledBoundaryPoints = [upsampledBoundaryPoints; segmentPoints]; % Append to the upsampled points array
end
upsampledBoundaryPoints = unique(upsampledBoundaryPoints, 'rows'); % Remove duplicate points

% Step 4: Plotting the Original and Final Point Clouds
figure;
% Original Boundary
subplot(1, 2, 1);
trisurf(K, DT.Points(:,1), DT.Points(:,2), DT.Points(:,3), 'FaceColor', 'cyan');
title('Original Point Cloud Boundary');
axis equal; grid on;

% Final Refined Boundary
subplot(1, 2, 2);
scatter3(upsampledBoundaryPoints(:,1), upsampledBoundaryPoints(:,2), upsampledBoundaryPoints(:,3), 5, 'filled');
title('Final Refined Boundary');
axis equal; grid on;

