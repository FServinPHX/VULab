% Generate two spherical point clouds A and B
clear
close all

radius_A = 5;
radius_B = radius_A* 5/6;
NumPoints = 1000;


theta_A = 2*pi*rand(NumPoints, 1);   % Random angles for pointcloud A
theta_B = 2*pi*rand(NumPoints, 1);   % Random angles for pointcloud B

phi_A = pi*rand(NumPoints, 1);       % Random elevations for pointcloud A
phi_B = pi*rand(NumPoints, 1);       % Random elevations for pointcloud B

% Cartesian coordinates conversion
x_A = radius_A*sin(phi_A).*cos(theta_A);
y_A = radius_A*sin(phi_A).*sin(theta_A);
z_A = radius_A*cos(phi_A);

x_B = radius_B*sin(phi_B).*cos(theta_B);
y_B = radius_B*sin(phi_B).*sin(theta_B);
z_B = radius_B*cos(phi_B);

pointcloud_A = [x_A, y_A, z_A];
pointcloud_B = [x_B, y_B, z_B];
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
pointcloud_E = zeros(NumPoints, 3);
pointcloud_F = zeros(NumPoints, 3);
% Sample the 5, 4, and 3 nearest points to create pointclouds D, E, and F
for i = 1:NumPoints
    
    nearest_indices_C = knnsearch(pointcloud_B, pointcloud_A(i, :), 'K', 6);
    pointcloud_C(i, :) = mean(  pointcloud_B( nearest_indices_C,:) , 1)   ;
    
    nearest_indices_D = knnsearch(pointcloud_B, pointcloud_A(i, :), 'K', 5);
    pointcloud_D(i, :) = mean(  pointcloud_B( nearest_indices_D,:) , 1)  ;
    
    nearest_indices_E = knnsearch(pointcloud_B, pointcloud_A(i, :), 'K', 4);
    pointcloud_E(i, :) = mean(  pointcloud_B( nearest_indices_E,:) , 1)  ;
    
    nearest_indices_F = knnsearch(pointcloud_B, pointcloud_A(i, :), 'K', 3);
    pointcloud_F(i, :) = mean(  pointcloud_B( nearest_indices_F,:) , 1)  ;
    
    nearest_indices_G = knnsearch(pointcloud_B, pointcloud_A(i, :), 'K', 2);
    pointcloud_G(i, :) = mean(  pointcloud_B( nearest_indices_G,:) , 1)  ;
end

distances_to_C = sqrt(sum((pointcloud_C - pointcloud_A).^2, 2));
distances_to_D = sqrt(sum((pointcloud_D - pointcloud_A).^2, 2));
distances_to_E = sqrt(sum((pointcloud_E - pointcloud_A).^2, 2));
distances_to_F = sqrt(sum((pointcloud_F - pointcloud_A).^2, 2));
distances_to_G = sqrt(sum((pointcloud_G - pointcloud_A).^2, 2));
%-------------------------------------------------------------------------%



%compare A and B
pointcloud_Z = zeros(3, NumPoints);

min_indexALL = []; 
for i = 1:NumPoints
    

    [min_distance, min_index] = min([distances_to_B(i); distances_to_C(i); distances_to_D(i);...
              distances_to_E(i);   distances_to_F(i)  ]);
    
    if min_index == 1
        pointcloud_Z(:, i) = pointcloud_B( matched_indices(i), :);
    elseif min_index == 2
        pointcloud_Z(:, i) = pointcloud_C(i, :);
    elseif min_index == 3
        pointcloud_Z(:, i) = pointcloud_D(i, :);
    elseif min_index == 4
        pointcloud_Z(:, i) = pointcloud_E(i, :);
    elseif min_index == 5
        pointcloud_Z(:, i) = pointcloud_F(i, :); 
    elseif min_index == 6
        pointcloud_Z(:, i) = pointcloud_G(i, :);                 
    end
    
    min_indexALL = [min_indexALL, min_index];
end

%

%-------------------------------------------------------------------------%
% Plotting
figure;
set(gcf,'color','w' );
h = histogram(min_indexALL);
xlabel("Indices of selected pointcloud")
ylabel("Number of Indices")

figure;
set(gcf,'color','w' );
hold on;
x_Z = pointcloud_Z(1,:);
y_Z = pointcloud_Z(2,:);
z_Z = pointcloud_Z(3,:);
colorsPlot = jet(NumPoints);

plot3(x_A, y_A, z_A, 'r.');        % Pointcloud A in red
%plot3(x_B, y_B, z_B, 'b.');        % Pointcloud B in blue
plot3( x_Z , y_Z , z_Z , 'k.');     % Point cloud Z in black

% Plot vectors between matched points
for i = 1:size(x_A, 1)
    
%     plot3([x_A(i) x_B(matched_indices(i))], [y_A(i) y_B(matched_indices(i))],...
%         [z_A(i) z_B(matched_indices(i))], 'g-');  %, 'Color', colorsPlot(i,:) );
   
   % plot3([x_A(i) x_C(i)], [y_A(i) y_C(i)], [z_A(i) z_C(i)], 'r--');
    
    plot3([x_A(i) x_Z(i)], [y_A(i) y_Z(i)], [z_A(i) z_Z(i)], 'g--');
end

% Set plot properties
axis equal;
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title(sprintf('Nearest Point Matching - Average Distance: %.2f', avg_distance));
legend('Pointcloud A', 'Pointcloud B', 'Matched Vectors');
hold off;





%%





% Generate two spherical point clouds A and B
radius_A = 5;
radius_B = 3*radius_A/2;
NumPoints = 100;

theta_A = 2*pi*rand(NumPoints, 1);     % Random angles for pointcloud A
theta_B = 2*pi*rand(NumPoints, 1);     % Random angles for pointcloud B

phi_A = pi*rand(NumPoints, 1);         % Random elevations for pointcloud A
phi_B = pi*rand(NumPoints, 1);         % Random elevations for pointcloud B

% Cartesian coordinates conversion
x_A = radius_A*sin(phi_A).*cos(theta_A);
y_A = radius_A*sin(phi_A).*sin(theta_A);
z_A = radius_A*cos(phi_A);

x_B = radius_B*sin(phi_B).*cos(theta_B);
y_B = radius_B*sin(phi_B).*sin(theta_B);
z_B = radius_B*cos(phi_B);

% Initialize arrays to store matched indices and point cloud C
matched_indices = zeros(NumPoints, 1);
x_C = zeros(NumPoints, 1);
y_C = zeros(NumPoints, 1);
z_C = zeros(NumPoints, 1);

% Find nearest 8 points from point cloud B for each point in point cloud A
for i = 1:NumPoints
    % Compute distances
    distances = sqrt((x_B - x_A(i)).^2 + (y_B - y_A(i)).^2 + (z_B - z_A(i)).^2);
    
    % Find the indices of the 8 nearest points
    [~, sorted_indices] = sort(distances);
    nearest_indices = sorted_indices(1:8);
    
    % Store the matching indices
    matched_indices(i) = nearest_indices(1);
    
    % Compute the average coordinates of the 8 nearest points
    x_C(i) = mean(x_B(nearest_indices));
    y_C(i) = mean(y_B(nearest_indices));
    z_C(i) = mean(z_B(nearest_indices));
end


% Calculate the average distance between matched points
avg_distance = mean(sqrt((x_B(matched_indices) - x_A).^2 + (y_B(matched_indices) - y_A).^2 + (z_B(matched_indices) - z_A).^2));

% Plotting
figure;
hold on;
plot3(x_A, y_A, z_A, 'r.');         % Point cloud A in red
plot3(x_B, y_B, z_B, 'b.');         % Point cloud B in blue
plot3(x_C, y_C, z_C, 'go');         % Point cloud C in green

% Plot vectors between matched points
for i = 1:NumPoints
    %plot3([x_A(i) x_B(matched_indices(i))], [y_A(i) y_B(matched_indices(i))], [z_A(i) z_B(matched_indices(i))], 'k-');
    plot3([x_A(i) x_C(i)], [y_A(i) y_C(i)], [z_A(i) z_C(i)], 'r--');
end

% Set plot properties
axis equal;
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title(sprintf('Radial Search - Average Distance: %.2f', avg_distance));
legend('Point cloud A', 'Point cloud B', 'Point cloud C', 'Matched Vectors', 'Mean Vectors');
hold off;





%%
clear


% Step 1: Create two spherical pointclouds A and B

% Radius of pointcloud A
radius_A = 10;

% Number of points in pointcloud A
NumPoints = 400;

% Generate random points on a sphere of radius 'radius_A' to create pointcloud A
theta_A = 2*pi*rand(1, NumPoints);
phi_A = acos(2*rand(1, NumPoints) - 1);
x_A = radius_A * sin(phi_A) .* cos(theta_A);
y_A = radius_A * sin(phi_A) .* sin(theta_A);
z_A = radius_A * cos(phi_A);
pointcloud_A = [x_A; y_A; z_A];

% Radius of pointcloud B
radius_B = (2/3) * radius_A;

% Generate random points on a sphere of radius 'radius_B' to create pointcloud B
theta_B = 2*pi*rand(1, NumPoints);
phi_B = acos(2*rand(1, NumPoints) - 1);
x_B = radius_B * sin(phi_B) .* cos(theta_B);
y_B = radius_B * sin(phi_B) .* sin(theta_B);
z_B = radius_B * cos(phi_B);
pointcloud_B = [x_B; y_B; z_B];

% Step 2: Find the nearest point from pointcloud A to a point in pointcloud B

% Initialize variables to store distances and point indices
distances = zeros(1, NumPoints);
point_indices = zeros(1, NumPoints);

% Find the nearest point from pointcloud A to each point in pointcloud B
for i = 1:NumPoints
    distances_to_B = sqrt(sum((pointcloud_B - pointcloud_A(:, i)).^2));
    [min_distance, min_index] = min(distances_to_B);
    distances(i) = min_distance;
    point_indices(i) = min_index;
end

% Step 3: Sample the 6 nearest points from A to B to create pointcloud C

% Initialize pointcloud C
pointcloud_C = zeros(3, NumPoints);

% Sample the 6 nearest points from A to B to create pointcloud C
for i = 1:NumPoints
    nearest_indices = knnsearch(pointcloud_B', pointcloud_A(:, i)', 'K', 6);
    pointcloud_C(:, i) = mean(pointcloud_B(:, nearest_indices), 2);
end

% Step 4: Sample 5, 4, and 3 nearest points to create pointclouds D, E, and F

% Initialize pointclouds D, E, and F
pointcloud_D = zeros(3, NumPoints);
pointcloud_E = zeros(3, NumPoints);
pointcloud_F = zeros(3, NumPoints);

% Sample the 5, 4, and 3 nearest points to create pointclouds D, E, and F
for i = 1:NumPoints
    nearest_indices_D = knnsearch(pointcloud_B', pointcloud_A(:, i)', 'K', 5);
    pointcloud_D(:, i) = mean(pointcloud_B(:, nearest_indices_D), 2);
    
    nearest_indices_E = knnsearch(pointcloud_B', pointcloud_A(:, i)', 'K', 4);
    pointcloud_E(:, i) = mean(pointcloud_B(:, nearest_indices_E), 2);
    
    nearest_indices_F = knnsearch(pointcloud_B', pointcloud_A(:, i)', 'K', 3);
    pointcloud_F(:, i) = mean(pointcloud_B(:, nearest_indices_F), 2);
end

% Step 5: Find the corresponding point that has the shortest distance to each point in A

% Initialize pointcloud Z
pointcloud_Z = zeros(3, NumPoints);

% Find the corresponding point that has the shortest distance to each point in A
for i = 1:NumPoints
    distances_to_B = sqrt(sum((pointcloud_B - pointcloud_A(:, i)).^2, 1));
    distances_to_C = sqrt(sum((pointcloud_C - pointcloud_A(:, i)).^2, 1));
    distances_to_D = sqrt(sum((pointcloud_D - pointcloud_A(:, i)).^2, 1));
    distances_to_E = sqrt(sum((pointcloud_E - pointcloud_A(:, i)).^2, 1));
    distances_to_F = sqrt(sum((pointcloud_F - pointcloud_A(:, i)).^2, 1));
    
    [min_distance, min_index] = min([distances_to_B; distances_to_C; distances_to_D; distances_to_E; distances_to_F]);
    
    if min_index == 1
        pointcloud_Z(:, i) = pointcloud_B(:, point_indices(i));
    elseif min_index == 2
        pointcloud_Z(:, i) = pointcloud_C(:, i);
    elseif min_index == 3
        pointcloud_Z(:, i) = pointcloud_D(:, i);
    elseif min_index == 4
        pointcloud_Z(:, i) = pointcloud_E(:, i);
    else
        pointcloud_Z(:, i) = pointcloud_F(:, i);
    end
end

%
figure;
hold on;
plot3(x_A, y_A, z_A, 'r.');         % Point cloud A in red

x_Z = pointcloud_Z(1,:);
y_Z = pointcloud_Z(2,:);
z_Z = pointcloud_Z(3,:);
plot3( x_Z , y_Z , z_Z , 'b.');     % Point cloud Z in black

% Plot vectors between matched points
for i = 1:NumPoints
    %plot3([x_A(i) x_B(matched_indices(i))], [y_A(i) y_B(matched_indices(i))], [z_A(i) z_B(matched_indices(i))], 'k-');
    plot3([x_A(i) x_Z(i)], [y_A(i) y_Z(i)], [z_A(i) z_Z(i)], 'r--');
end

% Set plot properties
axis equal;
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title(sprintf('Radial Search - Average Distance: %.2f', avg_distance));
legend('Point cloud A', 'Point cloud B', 'Point cloud C', 'Matched Vectors', 'Mean Vectors');
hold off;

%%







%-------------------------------------------------------------------------%
% Initialize arrays to store matched indices and point cloud C
% matched_indices = zeros(NumPoints, 1);
% x_C = zeros(NumPoints, 1);
% y_C = zeros(NumPoints, 1);
% z_C = zeros(NumPoints, 1);

% Find nearest 8 points from point cloud B for each point in point cloud A
distances_to_C = []; 
for i = 1:NumPoints
    Compute distances
    distances = sqrt((x_B - x_A(i)).^2 + (y_B - y_A(i)).^2 + (z_B - z_A(i)).^2);
    
    Find the indices of the 8 nearest points
    [~, sorted_indices] = sort(distances);
    
    nearest_indices = sorted_indices(1:8);
    
    Store the matching indices
    matched_indices(i) = nearest_indices(1);
    
    Compute the average coordinates of the 8 nearest points
    x_C(i) = mean(x_B(nearest_indices));
    y_C(i) = mean(y_B(nearest_indices));
    z_C(i) = mean(z_B(nearest_indices));
    
    min_distance = sqrt( (x_C(i) - x_A(i)).^2 + (y_C(i) - y_A(i)).^2 + (z_C(i) - z_A(i)).^2 );
    distances_to_C = [distances_to_C, min_distance]; 
end

