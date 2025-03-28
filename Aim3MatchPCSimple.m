function [pointcloud_Z] = Aim3MatchPCSimple(pointcloud_A, pointcloud_B, tol ) 

tolerance = 1 + tol;
% Cartesian coordinates conversion
x_A = pointcloud_A(:,1);
y_A = pointcloud_A(:,2);
z_A = pointcloud_A(:,3);

x_B = pointcloud_B(:,1);
y_B = pointcloud_B(:,2);
z_B = pointcloud_B(:,3);

pointcloud_A = [x_A, y_A, z_A];
pointcloud_B = [x_B, y_B, z_B];
%
NumPoints = length(z_A); 
%-------------------------------------------------------------------------%

% Initialize an array to store the matched indices
matched_indices = zeros(size(x_A, 1), 1);
min_distances = zeros(size(x_A, 1), 1);
% Find nearest point in pointcloud B for each point in pointcloud A
distances_to_B = [];

for i = 1:size(x_A, 1)

    distances = sqrt((x_B - x_A(i)).^2 + (y_B - y_A(i)).^2 + (z_B - z_A(i)).^2);
    % Find the index of the nearest point with unique match
    [min_distance, min_index] = min(distances) ;
    % while ismember(min_index, matched_indices)
    %     distances(min_index) = nan;
    % end
    x_B(min_index) = nan;
    y_B(min_index) = nan;
    z_B(min_index) = nan;
    
    % Store the matching index
    matched_indices(i) = min_index;
    min_distances(i) = min_distance;
    distances_to_B = [distances_to_B; min(distances)];
end

x_B = pointcloud_B(:,1);
y_B = pointcloud_B(:,2);
z_B = pointcloud_B(:,3);

% Calculate the average distance between matched pointscolorNew
avg_distance = mean(sqrt((x_B(matched_indices) - x_A).^2 + (y_B(matched_indices) - y_A).^2 + (z_B(matched_indices) - z_A).^2));


%
%compare A and B
pointcloud_Z = zeros(3, NumPoints);
min_indexALL = []; 
for i = 1:NumPoints
    
    if min_distances(i) > .2
            pointcloud_Z(:, i) = pointcloud_B( matched_indices(i), :);
            min_indexALL = [min_indexALL, min_index];
    else 
            pointcloud_Z(:, i) = pointcloud_B( matched_indices(i), :).*1.05;
            min_indexALL = [min_indexALL, min_index];
    end
end

end 


