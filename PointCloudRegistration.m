


% % Set the number of points in each point cloud
% num_points = 500;
% 
% % Generate two 3D point clouds with random points
% rng('default');  % Set the random seed for reproducibility
% 
% a = rand(num_points, 3) * 100;
% b = rand(num_points, 3) * 100;

%A is the
function [tform] = Aim3_RegisterAblationAtlas(A, B)

% A = TargetPointCloud;
% B = [intervalVectorData(:,1), intervalVectorData(:,2), intervalVectorData(:,3)];
% num_points = length(A  );
    
pc1 = pointCloud( B  );
pc2 = pointCloud( A );

% Display the initial point clouds
% figure;
% subplot(1, 2, 1);
% plot3( pc1.Location(:,1) ,pc1.Location(:,2), pc1.Location(:,3),  '.b' , 'MarkerSize', 20);
% hold on
% plot3( pc2.Location(:,1) ,pc2.Location(:,2), pc2.Location(:,3),  '.r', 'MarkerSize', 20);
% title('Point Cloud 1 & 2 (Original)');
% axis equal

% Extract the point coordinates from the point clouds
points1 = pc1.Location;
points2 = pc2.Location;

% Perform rigid registration using the ICP algorithm
[tform, ~] = pcregistericp(pc1,  pc2);

% Transform point cloud 2 using the estimated rigid transformation
registered_points2 = [points2 ones(num_points, 1)] * tform.T';


% Create point clouds from the registered points
registered_pc2 = pointCloud(registered_points2(:, 1:3));



% Display the registered point clouds
% subplot(1, 2, 2);
% plot3( pc1.Location(:,1) ,pc1.Location(:,2), pc1.Location(:,3),  '.b', 'MarkerSize', 20);
% hold on
% plot3( registered_points2(:,1),  registered_points2(:,2)  ,  registered_points2(:,3) ,'.r', 'MarkerSize', 20);
% title('Point Cloud 1 and 2(Original)');
% 
% % Display the transformation matrix information
% disp('Transformation Matrix:');
% disp(tform.T);
% hold off
% axis equal


end 



