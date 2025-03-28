% Create 200 3D points
points = randn(200, 3);

% Generate random parameters for rigid transformation (rotation and translation)
rotationMatrix = randRotationMatrix();
translationVector = rand(1, 3);

% Create the rigid transformation matrix
transformationMatrix = [rotationMatrix, translationVector'; 0 0 0 1];

% Apply the transformation to the points
homogeneousPoints = [points, ones(size(points, 1), 1)];
transformedPoints = homogeneousPoints * transformationMatrix';

% Plot the original and transformed points
figure;
scatter3(points(:, 1), points(:, 2), points(:, 3), 'b');
hold on;
scatter3(transformedPoints(:, 1), transformedPoints(:, 2), transformedPoints(:, 3), 'r');
legend('Original Points', 'Transformed Points');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Rigid Transformation');
% 
% % Function to generate a random rotation matrix
% function R = randRotationMatrix()
%     theta = 2 * pi * rand(1, 3);
%     R = eul2rotm(theta, 'ZYX');
% end
%%


A = TargetPointCloud;
B = [intervalVectorData(:,1), intervalVectorData(:,2), intervalVectorData(:,3)];


num_points = length(A  );
pc1 = pointCloud( A  );
pc2 = pointCloud( B );

% Display the initial point clouds
figure;
subplot(1, 2, 1);
plot3( pc1.Location(:,1) ,pc1.Location(:,2), pc1.Location(:,3),  '.b' , 'MarkerSize', 20);
hold on
plot3( pc2.Location(:,1) ,pc2.Location(:,2), pc2.Location(:,3),  '.r', 'MarkerSize', 20);
title('Point Cloud 1 & 2 (Original)');
axis equal

% Extract the point coordinates from the point clouds
points1 = pc1.Location;
points2 = pc2.Location;

% Perform rigid registration using the ICP algorithm
[tform, ~] = pcregistericp(pc1,  pc2);

% Transform point cloud 2 using the estimated rigid transformation
registered_points2 = [points2 ones(num_points, 1)] * tform.T';


% Create point clouds from the registered points
registered_pc2 = pointCloud(registered_points2(:, 1:3));

registered_points = registered_pc2.Location ;

% Display the registered point clouds
subplot(1, 2, 2);
plot3( pc1.Location(:,1) ,pc1.Location(:,2), pc1.Location(:,3),  '.b', 'MarkerSize', 20);
hold on
plot3( registered_points2(:,1),  registered_points2(:,2)  ,  registered_points2(:,3) ,'.r', 'MarkerSize', 20);
title('Point Cloud 1 and 2(Original)');

% Display the transformation matrix information
disp('Transformation Matrix:');
disp(tform.T);
hold off
axis equal

%% 
% Create a 2600x1 column vector ranging from -20 to 20
z.data = (rand(2600, 1) * 40) - 20;

% Normalize the data
z.normalizedData = normalize(z.data);

% Plot histogram of original data
figure;
subplot(2, 1, 1);
histogram(z.data, 'Normalization', 'pdf');
title('Original Data');
xlabel('Value');
ylabel('PDF');

% Plot histogram of normalized data
subplot(2, 1, 2);
histogram(z.normalizedData, 'Normalization', 'pdf');
title('Normalized Data');
xlabel('Value');
ylabel('PDF');

% Adjust subplot spacing
sgtitle('Histograms of Original and Normalized Data');


%%
% Generate 200 random 3D points
points = randn(200, 3);

% Generate scalar values for each point
scalarValues = rand(200, 1);

% Plot the points using the 'jet' colormap

colormap('jet');
scatter3(points(:, 1), points(:, 2), points(:, 3), [], scalarValues, 'filled');
colorbar;

% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Plot of 3D Points with Scalar Values');

% Set color limits
caxis([min(scalarValues), max(scalarValues)]);

%%
clear
% Create a random 3D vector with a magnitude of 50
vector = randn(1, 3);
vector = 50 * vector / norm(vector);

% Generate 100 points along the line
t = linspace(0, 1, 100)';
points = repmat(vector, 100, 1) .* t;

% Find the vector of the line
lineVector = points(end, :) - points(1, :);

% Calculate a plane that is perpendicular to the line
normalVector = lineVector / norm(lineVector);
[x, y] = meshgrid(-50:50, -50:50);
z = (-normalVector(1) * x - normalVector(2) * y) / (normalVector(3)+.01)


% Plot the points, line, and plane
figure;
scatter3(points(:,1), points(:,2), points(:,3), 'r', 'filled');
hold on;
line(points(:,1), points(:,2), points(:,3), 'Color', 'b', 'LineWidth', 1);
surf(x, y, z, 'FaceAlpha', 0.5, 'FaceColor', 'g');
hold off;

% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal
view( -35 , 25)
xlim([-45, 45])
ylim([-50, 50])
zlim([-50, 50]) 
hold off
title('Plot of Points, Line, and Plane');

%%

figure;
for i = 1:1
% Create a random 3D vector with a magnitude of 50
vector = randn(1, 3);
vector = 50 * vector / norm(vector);

% Generate 100 points along the line
t = linspace(0, 1, 100)';
points = repmat(vector, 100, 1) .* t;

% Find the vector of the line
lineVector = points(end, :) - points(1, :);

% Calculate a plane that is perpendicular to the line
normalVector = lineVector / norm(lineVector);
meanPoint = mean(points);
planeOrigin = meanPoint; %- normalVector * norm(lineVector) / 2;



% Create a grid for visualization
[x, y] = meshgrid(-100:100, -100:100);
z = planeOrigin(3) + (-normalVector(1) * x - normalVector(2) * y) / (normalVector(3)) ;


CenterPlane = mean( [reshape(x, [], 1), reshape(y, [], 1), reshape(z, [], 1) ] ); 

% Plot the points, line, and plane

scatter3(points(:,1), points(:,2), points(:,3), 'r', 'filled');
hold on;
% plot3(linePoints(:,1), linePoints(:,2), linePoints(:,3), 'b', 'LineWidth', 1);
surf(x, y, z, 'FaceAlpha', 0.5, 'FaceColor', 'g');

% Set labels and title
% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal
view( -35 , 25)
xlim([-45, 45])
ylim([-50, 50])
zlim([-50, 50]) 

title('Plot of Points, Line, and Plane');
pause(.5)



% Create 300 random 3D points

points2 = (rand(2600, 3) * 40) - 30;
% Calculate the approximate center of the points
center = mean(points2);
center  = CenterPlane;
% Calculate the d parameter of the plane equation
d = -(center * normalVector');


hold on
% Evaluate the side of the plane for each point
distances = points2 * normalVector' + d;
side = sign(distances);

% Plot the points and color code based on the side of the plane
scatter3(points2(side < 0, 1), points2(side < 0, 2), points2(side < 0, 3), 'r', 'filled');
hold on;
scatter3(points2(side >= 0, 1), points2(side >= 0, 2), points2(side >= 0, 3), 'b', 'filled');
surf(x, y, z, 'FaceAlpha', 0.3, 'FaceColor', 'g', 'EdgeColor', 'none');
hold off;

% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Points and Plane Visualization');
legend('Points on One Side', 'Points on Other Side');
view(3);




end 
hold off

%%
clear
close all

% Create random 3D points A and B
A_OG = rand(400, 3);
B_OG = rand(400, 3);

A = A_OG;
B = B_OG;
uniquePairs = [];

APoints = [];
BPoints = [];

for iter = 1:3
    
    
    AllMatches =[]; 
    if ~isempty(A)
        % Calculate pairwise distances between points in A and B
        distances = pdist2(A, B);
        
        if iter < 3
            for i = 1:size(A, 1)
                [minDistance, minIndex] = min(distances(i, :));
                AllMatches = [AllMatches; i, minIndex, minDistance]; 
            end         
            [C,ia,ic] = unique(AllMatches(:,2)) ;
            uniquePairs = [AllMatches(ia, :) ] ;

            Ai = uniquePairs(:,1);       Bi = uniquePairs(:,2);
            APoints = [ APoints;   A(Ai,:)];
            BPoints = [BPoints;  B(Bi,:)]; 
            A(Ai,:) = [];
            B(Bi,:) = [];  
        else
            
            for i = 1:size(A, 1)
                
                distances = pdist2(A, B);
                [minDistance, minIndex] = min(distances(1, :));
                
                if minDistance
                    APoints = [ APoints;   A(1,:)];
                    BPoints = [ BPoints;  B(minIndex,:)]; 
                    A(1, :) = [];
                    B(minIndex, :) = [];


                    AllMatches = [AllMatches;  i, minIndex, minDistance]; 
                end
        end    
    end
    end 
end 
% Plot the points and draw lines between the closest point pairs
figure;
scatter3(A_OG(:,1), A_OG(:,2), A_OG(:,3), 'b', 'filled');
hold on;
scatter3(B_OG(:,1), B_OG(:,2), B_OG(:,3), 'r', 'filled');
hold on

for i = 1:size(APoints, 1)
    
%     Ai = uniquePairs(i,1);       Bi = uniquePairs(i,2);
%     line([A(Ai,1), B(Bi,1)],...
%          [A(Ai,2), B(Bi,2)],...
%          [A(Ai,3), B(Bi,3)], 'Color', 'g');
%      
     
    line([APoints(i,1), BPoints(i,1)],...
         [APoints(i,2), BPoints(i,2)],...
         [APoints(i,3), BPoints(i,3)], 'Color', 'g');   
     
    hold on;
end

xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
axis equal


%%
clear
close all
clc

% Create two spherical point clouds A and B
numPoints = 2000;
radiusA = 10;
centerA = [0 0 0];
pointsA = getRandomSpherePoints(centerA, radiusA, numPoints);

radiusB = 8;
centerB = [15 0 0];
pointsB = getRandomSpherePoints(centerB, radiusB, numPoints);

% Find points from A that are inside B
insidePointsA = [];
outsidePointsA = [];
for i = 1:numPoints
    currentPointA = pointsA(i,:);
    nearestPointB = findNearestPoint(currentPointA, pointsB);
    isInside = norm(nearestPointB - centerB) < norm(currentPointA - centerB);
    if isInside
        insidePointsA = [insidePointsA; currentPointA];
    else
        outsidePointsA = [outsidePointsA; currentPointA];
    end
end



% Find points from B that are inside A
insidePointsB = [];
outsidePointsB = [];
for i = 1:numPoints
    currentPointB = pointsB(i,:);
    nearestPointA = findNearestPoint(currentPointB, pointsA);
    isInside = norm(nearestPointA - centerA) < norm(currentPointB - centerA);
    if isInside
        insidePointsB = [insidePointsB; currentPointB];
    else
        outsidePointsB = [outsidePointsB; currentPointB];
    end
end





% Plot the results
figure;
hold on;
plot3(pointsA(:,1), pointsA(:,2), pointsA(:,3), 'r.');
plot3(pointsB(:,1), pointsB(:,2), pointsB(:,3), 'b.');
plot3(insidePointsA(:,1), insidePointsA(:,2), insidePointsA(:,3), 'g.');
plot3(insidePointsB(:,1), insidePointsB(:,2), insidePointsB(:,3), 'c.');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('Points A', 'Points B', 'Inside A', 'Outside A', 'Inside B', 'Outside B');
axis equal;







function points = getRandomSpherePoints(center, radius, numPoints)
anglesTheta = 2 * pi * rand(numPoints, 1);
anglesPhi = acos(2 * rand(numPoints, 1) - 1);
x = radius * sin(anglesPhi) .* cos(anglesTheta);
y = radius * sin(anglesPhi) .* sin(anglesTheta);
z = radius * cos(anglesPhi);
points = [x, y, z] + center;
end

function nearestPoint = findNearestPoint(currentPoint, points)
distances = vecnorm(points - currentPoint, 2, 2);
[~, index] = min(distances);
nearestPoint = points(index,:);
end

%%


clear
% Step 1: Generate 300 3D points and triangulation matrix
numPoints = 800;
points = rand(numPoints, 3); % Generate random 3D points
[triangulation, volume2] = boundary( points, 1);

% Step 2: Erase triangulations based on nearest points
revisedTriangulation = [];
for i = 1:size(triangulation, 1)
    currentTriplet = triangulation(i, :);
    point1 = points(currentTriplet(1), :);
    nearestPointIndices = findNearestPointIndices(point1, points, 60); % Find indices of 5 nearest points
    
    % Step 3: Check if other two points are among the nearest points
    if ismember(currentTriplet(2), nearestPointIndices) && ...
       ismember(currentTriplet(3), nearestPointIndices)
        revisedTriangulation = [revisedTriangulation; currentTriplet];
    end
end

% Step 5: Plot original and revised triangulations
figure;
subplot(1, 2, 1);
trisurf(triangulation, points(:,1),points(:,2),points(:,3),...
        'Facecolor',rgb("Red"),'FaceAlpha',  .5, 'EdgeAlpha', 0)
title('Original Triangulation');

subplot(1, 2, 2);
trisurf(revisedTriangulation, points(:,1),points(:,2),points(:,3),...
        'Facecolor',rgb("Blue"),'FaceAlpha',  .5, 'EdgeAlpha', 0)
title('Revised Triangulation');




function nearestPointIndices = findNearestPointIndices(currentPoint, points, k)
distances = sqrt(sum((points - currentPoint).^2, 2));
[sortedDistances, indices] = sort(distances);
nearestPointIndices = indices(1:k);
end

