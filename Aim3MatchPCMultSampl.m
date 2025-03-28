
%A is what you start off with (t), Z is what you get (t+1);
function [pointcloud_Z] = Aim3MatchPCMultSampl(pointcloud_A, pointcloud_B, tol ) 

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

% Find nearest point in pointcloud B for each point in pointcloud A
distances_to_B = [];
for i = 1:size(x_A, 1)
    distances = sqrt((x_B - x_A(i)).^2 + (y_B - y_A(i)).^2 + (z_B - z_A(i)).^2);
    
    % Find the index of the nearest point with unique match
    [~, min_index] = min(distances);
    while ismember(min_index, matched_indices)
        distances(min_index) = nan;
        [min_distance, min_index] = min(distances);
    end
    
    % Store the matching index
    matched_indices(i) = min_index;
    distances_to_B = [distances_to_B; min(distances)]; 
end
% Calculate the average distance between matched pointscolorNew
avg_distance = mean(sqrt((x_B(matched_indices) - x_A).^2 + (y_B(matched_indices) - y_A).^2 + (z_B(matched_indices) - z_A).^2));



%-------------------------------------------------------------------------%
% Step 4: Sample 8, 5, 4, and 3 nearest points to create pointclouds D, E, and F
% Initialize pointclouds C, D, E, and F
pointcloud_C = zeros(NumPoints, 3);
pointcloud_D = zeros(NumPoints, 3);
% pointcloud_E = zeros(NumPoints, 3);
% pointcloud_F = zeros(NumPoints, 3);
% Sample the 5, 4, and 3 nearest points to create pointclouds D, E, and F
for i = 1:NumPoints
    
    nearest_indices_C = knnsearch(pointcloud_B, pointcloud_A(i, :), 'K', 4);
    pointcloud_C(i, :) = mean(  pointcloud_B( nearest_indices_C,:) , 1)   ;
    
    nearest_indices_D = knnsearch(pointcloud_B, pointcloud_A(i, :), 'K', 3);
    pointcloud_D(i, :) = mean(  pointcloud_B( nearest_indices_D,:) , 1)  ;
    

end

distances_to_C = sqrt(sum((pointcloud_C - pointcloud_A).^2, 2)) * tolerance;
distances_to_D = sqrt(sum((pointcloud_D - pointcloud_A).^2, 2)) * tolerance;
% distances_to_E = sqrt(sum((pointcloud_E - pointcloud_A).^2, 2));
% distances_to_F = sqrt(sum((pointcloud_F - pointcloud_A).^2, 2));
% distances_to_G = sqrt(sum((pointcloud_G - pointcloud_A).^2, 2));
%-------------------------------------------------------------------------%



%compare A and B
pointcloud_Z = zeros(3, NumPoints);

min_indexALL = []; 
for i = 1:NumPoints
    

    %[min_distance, min_index] = min([distances_to_B(i); distances_to_C(i); distances_to_D(i)  ]);
    [min_distance, min_index] = min([distances_to_B(i);...
                                     distances_to_C(i); distances_to_D(i)  ]);

    if min_distance > .2
        mult = 1;
    else
        mult = 1;
        min_index = 3;  %mult = 1.01 %1.05;
    end 

    if min_index == 1
        pointcloud_Z(:, i) = pointcloud_B( matched_indices(i), :) .*mult ;
    elseif min_index == 2
        pointcloud_Z(:, i) = pointcloud_C(i, :).*mult ;
    else 
        pointcloud_Z(:, i) = pointcloud_D(i, :).*mult;
%     elseif min_index == 4
%         pointcloud_Z(:, i) = pointcloud_E(i, :);
%     elseif min_index == 5
%         pointcloud_Z(:, i) = pointcloud_F(i, :); 
%     elseif min_index == 6
%         pointcloud_Z(:, i) = pointcloud_G(i, :);     

    end
    
    min_indexALL = [min_indexALL, min_index];
    
end


pointcloud_Z = pointcloud_Z'; 
end 
