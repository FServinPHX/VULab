

clear
close all


% 1. create a pointcloud A of 2000 random intensity values
A_coord = rand(300, 3) *10; % random coordinates in a 10*10*10 space
A_intensity = rand(300, 1) * 255;  % random intensity values 

% 2. a pointcloud B curve with dimensions 8*8*8 with a point every 2mm
[x, y, z] = meshgrid(0:.2:8, 0:.2:8, 0:.2:8);
B_coord = [x(:), y(:), z(:)];

% 3. interpolate intensity values from A to get intensity values in pointcloud B
B_intensity = griddata(A_coord(:,1), A_coord(:,2), A_coord(:,3), A_intensity,...
                       B_coord(:,1), B_coord(:,2), B_coord(:,3));

% 4. convert all x,y,z coordinates from A and B into column vectors
% This is already done in the above steps

% visualize all the results with colormap 'jet'
figure;
subplot(1,2,1);
scatter3(A_coord(:,1), A_coord(:,2), A_coord(:,3), 20, A_intensity, 'filled');
colormap('jet');
colorbar;
title('PointCloud A');

subplot(1,2,2);
scatter3(B_coord(:,1), B_coord(:,2), B_coord(:,3), 20, B_intensity, 'filled');
colormap('jet');
colorbar;
title('PointCloud B, Interpolated');


set(gcf,'Position',[100 100 1500 700])

%%
close all 
clear


% 1. create a pointcloud A of 2000 random intensity values
A_coord = rand(1000, 3) * 10; % random coordinates in a 10*10*10 space
A_intensity = rand(1000, 1) * 255;  % random intensity values 

% 2. a pointcloud B curve with dimensions 8*8*8 with a point every 2mm
[x, y, z] = meshgrid(0:.2:10, 0:.2:10, 0:.2:10);
B_coord = [x(:), y(:), z(:)];


% 3. interpolate intensity values from A to get intensity values in pointcloud B
B_intensity = griddata(A_coord(:,1), A_coord(:,2), A_coord(:,3), A_intensity, ...
                       B_coord(:,1), B_coord(:,2), B_coord(:,3));

%%-Nearest_Neighboor 
BcordNan = B_coord(isnan(B_intensity), :);
[minDist,I] = min(pdist2(BcordNan, A_coord),[], 2);
NewB_Intense = A_intensity(I);
B_intensity(find(isnan(B_intensity)) ) = NewB_Intense;


% 4. convert all x,y,z coordinates from A and B into column vectors
% This is already done in the above steps

% visualize all the results with colormap 'jet'
figure;
subplot(1,2,1);
scatter3(A_coord(:,1), A_coord(:,2), A_coord(:,3), 20, A_intensity, 'filled');
colormap('jet');
colorbar;
title('PointCloud A');

subplot(1,2,2);
scatter3(B_coord(:,1), B_coord(:,2), B_coord(:,3), 20, B_intensity, 'filled');
colormap('jet');
colorbar;
title('PointCloud B, Interpolated');




set(gcf,'Position',[100 100 1500 700])

%%
