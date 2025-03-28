

clc

% Let's declare 3D random points
Points = rand(400,3);
Points = BoundaryPoints.new;

%%
% Use kmeans to cluster the points into 4 groups
[idx,C] = kmeans(Points, 4);

% Create a new figure
figure;
hold on;

% For each cluster: shrink wrap a boundary around it and add it to the figure
colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; ...
    rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];

for i = 1:4
    % Fetch points for the cluster
    clusterPoints = Points(idx == i, :); 

    % Use convhull to shrink wrap a boundary around the points
    %[K, vol] = convhull(clusterPoints(:,1), clusterPoints(:,2), clusterPoints(:,3));
    [K, vol] = boundary(clusterPoints(:,1), clusterPoints(:,2), clusterPoints(:,3), .25);
    
    % Plot the points and their convex hull
    plot3(clusterPoints(:,1), clusterPoints(:,2), clusterPoints(:,3), '.');
    trisurf(K, clusterPoints(:,1), clusterPoints(:,2), clusterPoints(:,3),...
         'Facecolor',colors2(i,:),'FaceAlpha',  .5, 'EdgeColor', rgb("Navy") ,'EdgeAlpha',.1 )
end

% Plot cluster centroids
plot3(C(:,1),C(:,2),C(:,3),'kx','MarkerSize',15,'LineWidth',3);

% Finalize the figure
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
hold off;