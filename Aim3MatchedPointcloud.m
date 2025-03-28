

%A is what you start off with (t), Z is what you get (t+1);
function [pointcloud_Z] = Aim3MatchedPointcloud(pointcloud_A, pointcloud_B ) 

% Cartesian coordinates conversion
x_A = pointcloud_A(:,1);
y_A = pointcloud_A(:,2);
z_A = pointcloud_A(:,3);

x_B = pointcloud_B(:,1);
y_B = pointcloud_B(:,2);
z_B = pointcloud_B(:,3);
NumPoints = length(x_A);

% Initialize an array to store the matched indices
matched_indices = zeros(size(x_A, 1), 1);

% Find nearest point in pointcloud B for each point in pointcloud A
distances_to_B = [];
for i = 1:size(x_A, 1)
    
    distances = sqrt((x_B - x_A(i)).^2 + (y_B - y_A(i)).^2 + (z_B - z_A(i)).^2);
    
    % Find the index of the nearest point with unique match
    [~, min_index] = min(distances);
    while ismember(min_index, matched_indices)
        distances(min_index) = nan;
        [~, min_index] = min(distances);
    end
    
    % Store the matching index
    matched_indices(i) = min_index;
    distances_to_B = [distances_to_B, min(distances)]; 
end

% Calculate the average distance between matched pointscolorNew
avg_distance = mean(sqrt((x_B(matched_indices) - x_A).^2 + (y_B(matched_indices) - y_A).^2 ...
                    + (z_B(matched_indices) - z_A).^2));

%-------------------------------------------------------------------------%
% Initialize arrays to store matched indices and point cloud C
matched_indices = zeros(NumPoints, 1);
x_C = zeros(NumPoints, 1);
y_C = zeros(NumPoints, 1);
z_C = zeros(NumPoints, 1);

% Find nearest 8 points from point cloud B for each point in point cloud A
distances_to_C = []; 
for i = 1:size(x_A, 1)
    % Compute distances
    distances = sqrt((x_B - x_A(i)).^2 + (y_B - y_A(i)).^2 + (z_B - z_A(i)).^2);
    
    % Find the indices of the 8 nearest points
    [~, sorted_indices] = sort(distances);
    nearest_indices = sorted_indices(1:3);
    
    % Store the matching indices
    matched_indices(i) = nearest_indices(1);
    
    % Compute the average coordinates of the 8 nearest points
    x_C(i) = mean(x_B(nearest_indices));
    y_C(i) = mean(y_B(nearest_indices));
    z_C(i) = mean(z_B(nearest_indices));
    
    min_distance = sqrt( (x_C(i) - x_A(i)).^2 + (y_C(i) - y_A(i)).^2 + (z_C(i) - z_A(i)).^2 );
    distances_to_C = [distances_to_C, min_distance]; 
end


%-------------------------------------------------------------------------%
    %
    %compare A and B
    pointcloud_Z = zeros(3, NumPoints);
    pointcloud_A = [x_A, y_A, z_A];
    pointcloud_B = [x_B, y_B, z_B];
    pointcloud_C = [x_C, y_C, z_C];
    for i = 1:NumPoints

        [min_distance, min_index] = min([distances_to_B(i); distances_to_C(i) ]);

        if min_index == 1
            pointcloud_Z(:, i) = pointcloud_B( matched_indices(i), :);
        elseif min_index == 2
            pointcloud_Z(:, i) = pointcloud_C(i, :);
        end
    end

end 
