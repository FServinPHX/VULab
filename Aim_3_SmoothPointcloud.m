
% Parameters
num_points = 1000; % Number of points in the point cloud
radius = 5; % Radius of the sphere
noise_level = 0.05; % Noise level



% Create a spherical point cloud with noise
theta = 2*pi*rand(num_points, 1);
phi = acos(2*rand(num_points, 1)-1);
r = radius * (1 + noise_level*randn(num_points, 1));
x = r .* sin(phi) .* cos(theta);
y = r .* sin(phi) .* sin(theta);
z = r .* cos(phi);



%points = [x, y, z];
points = NewPoints;
num_points = length(points);

% Save original points for plotting
original_points = points;

% Smooth the point cloud
num_iterations = 4; % Number of smoothing iterations
num_neighbors = 6; % Number of closest neighbors to find

for iter = 1:num_iterations
    for i = 1:num_points
        % Calculate distances to all other points
        distances = sqrt(sum((points(i,:) - points).^2, 2));
        
        % Find the five closest neighbors (excluding self)
        [~, idx] = mink(distances, num_neighbors+1);
        %idx = idx(idx~=i); % Remove self from neighbors
        
        
        % Calculate the midpoint
        midpoint = mean(points(idx,1:3), 1);
        
        % Update the current point (except z)
        points(i,1:3) = midpoint;
    end
end

% Plot the original and smoothed point clouds
figure;
subplot(1,2,1);
scatter3(original_points(:,1), original_points(:,2), original_points(:,3), '.', 'r');
title('Original Point Cloud');
axis equal;

subplot(1,2,2);
scatter3(points(:,1), points(:,2), points(:,3), '.', 'b');
title('Smoothed Point Cloud');
axis equal;

%%

input_str = name;
experiment_num = extract_experiment_number(input_str);
disp(['The experiment number is: ', num2str(experiment_num)]);


file_path2 = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
[filepath2,name2,ext] = fileparts(file_path2);    
OGdata = readtable(file_path2);
AntnaNames = ( OGdata(:, 1) );
data2 = table2array(OGdata(:, 2:end));




        % Example table creation with a single column of names
        T = AntnaNames;
        % Assuming all names are stored in the first column, convert to string matrix
        if istable(T) && width(T) >= 1
            % Preallocate string array based on the number of rows in the table
            stringMatrix = strings(height(T), 1);
            % Iterate through the table and fill the string matrix
            for i = 1:height(T)
                % Assign each name to the string array
                stringMatrix(i) = string(T.Name(i));
            end
        end
        AntnaNames = stringMatrix;


%
experiment_num_Ant_All = [];
for i = 1: size(AntnaNames,1)
   
    
    experiment_num_Ant = extract_experiment_number(AntnaNames(i));
    experiment_num_Ant_All = [experiment_num_Ant_All ,experiment_num_Ant];
end

% Find the indices of the specific number
[rowIndices, colIndices] = find(experiment_num_Ant_All == experiment_num);
% Combine row and column indices to have pairs of indices
indices = [rowIndices, colIndices];

%%
% Parameters
% num_points = 1000; % Number of points in the point cloud
% radius = 5; % Radius of the sphere
% noise_level = 0.05; % Noise level
% Create a spherical point cloud with noise
% theta = 2*pi*rand(num_points, 1);
% phi = acos(2*rand(num_points, 1)-1);
% r = radius * (1 + noise_level*randn(num_points, 1));
% x = r .* sin(phi) .* cos(theta);
% y = r .* sin(phi) .* sin(theta);
% z = r .* cos(phi);


% points = [x, y, z];
points = NewPoints;
num_points = length(points);


% Save original points for plotting
original_points = points;




% Parameters for adjustments
num_iterations = 4; % Number of adjustment iterations
num_neighbors = 5; % Number of closest neighbors to find

% Center of point cloud (assuming it's centered at the origin)
center = mean(points);

%
% Smooth/Adjust the point cloud

center = "PROBE"; 
for iter = 1:num_iterations
    for i = 1:num_points
        % Vector and distance from current point to center

        if center == "PROBE"

            distances = pdist2(PointCloud, points(i,:), 'euclidean');
            % Find the smallest distance and corresponding index
            [minDistance, indexNearest] = min(distances);
            % Get the nearest point
            center = PointCloud(indexNearest, :);

        end 

        vector_to_center = points(i,:) - center;
        dist_to_center = norm(vector_to_center);
        
        % Calculate distances to all other points
        distances = sqrt(sum((points(i,:) - points).^2, 2));
        
        % Find the five closest neighbors (excluding self)
        [~, idx] = mink(distances, num_neighbors+1);
        idx = idx(idx~=i); % Remove self from neighbors
        
        % Average distance of neighbors from center
        avg_neighbor_dist = mean(sqrt(sum((points(idx,:) - center).^2, 2)));
        
        % Adjust the current point based on comparison with average distance
        if dist_to_center > avg_neighbor_dist
            points(i,:) = points(i,:) - vector_to_center * (dist_to_center - avg_neighbor_dist) / dist_to_center;
        elseif dist_to_center < avg_neighbor_dist
            points(i,:) = points(i,:) + vector_to_center * (avg_neighbor_dist - dist_to_center) / dist_to_center;
        end
    end
end

% Plot the original and smoothed/adjusted point clouds
figure;
subplot(1,2,1);
scatter3(original_points(:,1), original_points(:,2), original_points(:,3), '.', 'r');
title('Original Point Cloud');
axis equal;

subplot(1,2,2);
scatter3(points(:,1), points(:,2), points(:,3), '.', 'b');
title('Adjusted Point Cloud');
axis equal;



