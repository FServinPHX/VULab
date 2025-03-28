


%function [ AllData ] = Aim3_AblationTumorIntersect( TargetPoints1 , TargetPoints2 ) 

clc
%TARTGET 1 IS Tumor
%TARTGET 2 IS Ablation
TargetPoints1 = TumorPoints.Points + [0, 0, 0 ];
%TargetPoints1 = UpSample( TumorPoints.Points, 4000 );
TargetPoints2 = BoundaryPoints.new;

numPoints = length( TargetPoints1) ;
centerA = mean(TargetPoints1)  ;
pointsA = TargetPoints1; 
centerB = mean(TargetPoints2 ) ;
pointsB = TargetPoints2;



% Find points from A that are inside B
insidePointsA = [];
outsidePointsA = [];
for i = 1:numPoints
    currentPointA = pointsA(i,:);
    nearestPointB = findNearestPoint(currentPointA, pointsB);
    isInside = norm(nearestPointB - centerB) > norm(currentPointA - centerB);
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
    isInside = norm(nearestPointA - centerA) > norm(currentPointB - centerA);
    if isInside
        insidePointsB = [insidePointsB; currentPointB];
    else
        outsidePointsB = [outsidePointsB; currentPointB];
    end
end
AblatedTumorPoints = [insidePointsA; insidePointsB ]; 





% Plot the results
figure;
set(gcf,'color', rgb('DimGray'));  
hold on;
%plot3(pointsA(:,1), pointsA(:,2), pointsA(:,3), 'k.', 'MarkerSize', 10 );
%plot3(pointsB(:,1), pointsB(:,2), pointsB(:,3), 'r.', 'MarkerSize', 10 );
plot3(AblatedTumorPoints(:,1), AblatedTumorPoints(:,2), AblatedTumorPoints(:,3), 'g.', 'MarkerSize', 12 );
% [k1, volume1] = boundary( AblatedTumorPoints );
% hold on
% trisurf(k1,AblatedTumorPoints(:,1),AblatedTumorPoints(:,2),AblatedTumorPoints(:,3),...
%         'Facecolor','red','FaceAlpha',0.1, 'EdgeAlpha', 0)



[k2, ~] = boundary( pointsA, .8);
[~, volume2] = boundary( AblatedTumorPoints, .25 );
hold on
trisurf(k2,pointsA(:,1),pointsA(:,2),pointsA(:,3),...
        'Facecolor',rgb("Peru"),'FaceAlpha',1, 'EdgeAlpha', 0)

    
    
 % pointsB = UpSample(pointsB,9000 ); 
%pointsB = UpsampledAblationSpecRange(pointsB, 20000,   2, 7, 1000 ) ;
%
x = pointsB(:,1); 
y = pointsB(:,2);
z = pointsB(:,3) ;
k3 = boundary(x,y,z, 1);
distances = [];
% Step 2: Erase triangulations based on nearest points
revisedTriangulation = [];
triangulation = k3;
points = pointsB;
% for i = 1:size(triangulation, 1)
%     currentTriplet = triangulation(i, :);
%     point1 = points(currentTriplet(1), :);
%     nearestPointIndices = findNearestPointIndices(point1, points, 200); % Find indices of 5 nearest points
%     % Step 3: Check if other two points are among the nearest points
%     if ismember(currentTriplet(2), nearestPointIndices) && ...
%        ismember(currentTriplet(3), nearestPointIndices)
%         revisedTriangulation = [revisedTriangulation; currentTriplet];
%     end
% end
% k3 = revisedTriangulation;



hold on
%colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; ...
%     rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];
trisurf(k3, pointsB(:,1),pointsB(:,2),pointsB(:,3),...
        'Facecolor',rgb("Indigo"),'FaceAlpha',  .5, 'EdgeColor', rgb("Navy") ,'EdgeAlpha',.1 )
plot3( pointsB(:,1),pointsB(:,2),pointsB(:,3), 'k.', 'MarkerSize', 10)

% plot3(insidePointsA(:,1), insidePointsA(:,2), insidePointsA(:,3), 'k.', 'MarkerSize', 15 );
% plot3(insidePointsB(:,1), insidePointsB(:,2), insidePointsB(:,3), 'y.', 'MarkerSize', 15 );
% plot3(outsidePointsA(:,1), outsidePointsA(:,2), outsidePointsA(:,3), 'r.', 'MarkerSize', 15 );
% plot3(outsidePointsB(:,1), outsidePointsB(:,2), outsidePointsB(:,3), 'r.', 'MarkerSize', 15 );
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
axis off
axis equal;
view(-10, 0)
hold off
title( join([  " Ablated Vol = ", num2str( round( volume2/1000 ,2) )  "  [cm^{3}]"  ]))      
           

%%


clc
% Generate a 3D point cloud shell
num_points = 1000;
theta = 2 * pi * rand(num_points, 1);
phi = acos(2 * rand(num_points, 1) - 1);
radius = 1;
x = radius * sin(phi) .* cos(theta);
y = radius * sin(phi) .* sin(theta);
z = radius * cos(phi);
points = [x y z];

% Partition the point cloud into 4 sections using k-means clustering
[idx, centers] = kmeans(points, 4);

% Initialize variable for total volume
total_volume = 0;
    figure;
for i = 1:4
    % Points in the current cluster
    cluster_points = points(idx == i, :);
    
    % Triangulate each section and find the volume
    [T, vol] = boundary(cluster_points);
    volume_i = vol;
    total_volume = total_volume + volume_i;
    
    % Visualize the triangulation

    trisurf(T, cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 'FaceAlpha', 0.3);
    hold on;
end

% Combine clusters to find edge points
edge_points = []; % Initialize edge points container

% Assuming centers is a 4x3 matrix with each row being a cluster center
edges = zeros(4, 3); % Initialize edges
for i = 1:4
    distances = sqrt(sum((points - centers(i, :)).^2, 2));
    [sortedDistances, sortIndices] = sort(distances);
    % Assuming the edge of each group consists of points with the largest distances
    % The exact number might need adjusting
    edges(i, :) = mean(points(sortIndices(end-10:end), :), 1);
end


% Output total volume
[T_Final, True_vol] = boundary(points);

title( join(['Total Volume: ', num2str(total_volume), newline, ...
                "vs.", "True  Vol = ", num2str(True_vol)]) );
axis equal 
% Functions such as 'volume_from_triangulation' would need to be defined to calculate
% the volume based on the triangulated mesh. This typically involves summing the volumes
% of tetrahedra formed by the triangulation, which can be identified by their vertices in
% the mesh.
%%





%%

function points = getRandomSpherePoints(center, radius, numPoints)
anglesTheta = 2 * pi * rand(numPoints, 1);
anglesPhi = acos(2 * rand(numPoints, 1) - 1);
x = radius * sin(anglesPhi) .* cos(anglesTheta);
y = radius * sin(anglesPhi) .* sin(anglesTheta);
z = radius * cos(anglesPhi);
points = [x, y, z] + center;
end


function nearestPointIndices = findNearestPointIndices(currentPoint, points, k)
distances = sqrt(sum((points - currentPoint).^2, 2));
[sortedDistances, indices] = sort(distances);
nearestPointIndices = indices(1:k);
end


function nearestPoint = findNearestPoint(currentPoint, points)
distances = vecnorm(points - currentPoint, 2, 2);
[~, index] = min(distances);
nearestPoint = points(index,:);
end

function UpsampledPoints = UpSample(Points,numpoints )

    AllData1 = [];
    if size(AllData1,1) < numpoints
        [ AllData1 ] = UpsampledAblationSpec( Points, numpoints ) ;
        disp("Upsampled") 

        %--------------------------------------------------------------%
        if size(AllData1,1) < numpoints
            while size(AllData1,1) < numpoints
                [ AllData1 ] = UpsampledAblationSpec( AllData1, numpoints ) ;
                disp("Upsampled II") 
            end 
        end 
    end 

    if  size(AllData1,1) > numpoints
        [ AllData1 ] = DownsampleAblationSpec( Points, numpoints ) ;
         disp("Downsample") 
    else
        disp("Best Sample")   
    end

    UpsampledPoints = AllData1;

end 

%end 
 
