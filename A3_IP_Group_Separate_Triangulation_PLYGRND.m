
clear
clc




% Step 1: Generate a 3D spherical point cloud shell
num_points = 1000;
theta = 2 * pi * rand(num_points, 1);
phi = acos(2 * rand(num_points, 1) - 1);
radius = 1;
x = radius * sin(phi) .* cos(theta);
y = radius * sin(phi) .* sin(theta);
z = radius * cos(phi);
points = [x y z];

% Step 2: Separate the point clouds into 4 sections using kmeans
numClusters = 3;
[idx, C] = kmeans(points, numClusters);

% Prepare for visualization and volume calculation
total_volume = 0;
figure;

% Step 3 & 4: Triangulate each section and calculate volume
for i = 1:numClusters
    cluster_points = points(idx == i, :);
    [K, v] = convhull(cluster_points);
    total_volume = total_volume + v;
    subplot(2, 3, i);
    trisurf(K, cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), 'FaceAlpha', 0.5);
    hold on;
    title(['Cluster ', num2str(i), ' Volume: ', num2str(v)]);
    axis equal;
end




% Step 5: Find the points that are closest between each group
% for i = 1:4
%     other_groups = points(idx ~= i, :);
%     distances = pdist2(points(idx == i, :), other_groups);
%     [sortedDistances, ~] = sort(distances, 2);
%     closestDistances = sortedDistances(:, 1:3); % Closest points
%     threshold = prctile(closestDistances(:), .0001); % Top 10% closest
%     topClosestPoints = points(idx == i, :);
%     topClosestPoints(mean(closestDistances, 2) < threshold, :) = [];
%     edge_points = [edge_points; topClosestPoints];
% end


%
    group1 = points(idx == 1, :); % Group 1 points
    group2 = points(idx == 2, :); % Group 2 points
    group3 = points(idx == 3, :); % Group 3 points
    group4 = points(idx == 4, :); % Group 4 points
%
    groups = {group1, group2, group3, group4}; % Store groups in a cell array for iteration
    %numGroups = numel(groups);

    numGroups = numClusters;
    % Placeholder for storing closest point pairs and their distances

    % closestPairInfo = cell(0, 5); % {Group A Index, Point A Index, Group B Index, Point B Index, Distance}
    % % Iterate over group pairs to find closest points between them

    AllTopPairs = []; 
    TopPts = []; 
        for i = 1:numGroups

        closestPairInfo = cell(0, 5); % {Group A Index, Point A Index, Group B Index, Point B Index, Distance}
        % Iterate over group pairs to find closest points between them      


        for j = i+1:numGroups
    
            distanceMatrix = pdist2(groups{i}, groups{j});
            [minDistances, minIndices] = min(distanceMatrix, [], 2);
            for k = 1:size(groups{i}, 1)
                % Store Group A Index, Point A Index, Group B Index, Point B Index, Distance
                closestPairInfo{end+1, 1} = i;
                closestPairInfo{end, 2} = k;
                closestPairInfo{end, 3} = j;
                closestPairInfo{end, 4} = minIndices(k);
                closestPairInfo{end, 5} = minDistances(k);
            end

        end

        % Convert distances to an array for finding top 10%
        allDistances = cell2mat(closestPairInfo(:, 5));
        % Finding top 10% closest pairs
        numTopPairs = ceil(numel(allDistances) * 0.25  );
        [sortedDistances, sortIdx] = sort(allDistances);
        topPairIdx = sortIdx(1:numTopPairs);



        for i = 1:length(topPairIdx )
            infoIdx = topPairIdx(i);
            pairInfo = closestPairInfo(infoIdx, :);
            groupA = pairInfo{1};
            pointAIdx = pairInfo{2};
            groupB = pairInfo{3};
            pointBIdx = pairInfo{4};
        
        
            ptsa = [ groups{groupA}(pointAIdx, 1), groups{groupA}(pointAIdx, 2), ... 
                                    groups{groupA}(pointAIdx, 3) ] ;
            ptsb = [groups{groupB}(pointBIdx, 1), groups{groupB}(pointBIdx, 2), ...
                            groups{groupB}(pointBIdx, 3)] ;
            TopPts = [TopPts; ptsa; ptsb];
        end 
  
        end
        % % Convert distances to an array for finding top 10%
        % allDistances = cell2mat(closestPairInfo(:, 5));
        % % Finding top 10% closest pairs
        % numTopPairs = ceil(numel(allDistances) * 0.005  );
        % [sortedDistances, sortIdx] = sort(allDistances);
        % topPairIdx = sortIdx(1:numTopPairs);
    

%

        % TopPts = [];
        % topPairIdx = AllTopPairs;
        % for i = 1:length(topPairIdx )
        %     infoIdx = topPairIdx(i);
        %     pairInfo = closestPairInfo(infoIdx, :);
        %     groupA = pairInfo{1};
        %     pointAIdx = pairInfo{2};
        %     groupB = pairInfo{3};
        %     pointBIdx = pairInfo{4};
        % 
        % 
        %     ptsa = [ groups{groupA}(pointAIdx, 1), groups{groupA}(pointAIdx, 2), ... 
        %                             groups{groupA}(pointAIdx, 3) ] ;
        %     ptsb = [groups{groupB}(pointBIdx, 1), groups{groupB}(pointBIdx, 2), ...
        %                     groups{groupB}(pointBIdx, 3)] ;
        %     TopPts = [TopPts; ptsa; ptsb];
        % end 

        edge_points = TopPts;
%
% Removing duplicates
[edge_points_unique, ~, ~] = unique(edge_points, 'rows');

% Step 6: Triangulate points in group 5 (simplified -- using all unique edge points directly)
%T = delaunay(edge_points_unique);
[T, volInside] = convhull(edge_points_unique);
hold on;


% Step 7: Visualize all results including group 5
subplot(2, 3, 5);
trisurf(T, edge_points_unique(:, 1), edge_points_unique(:, 2), edge_points_unique(:, 3), 'FaceAlpha', 0.5, 'EdgeColor', 'k');
title( join(['Edge Points Triangulation - Group 5', newline, ' Volume: ', num2str(volInside)]) );
axis equal;
hold off;

% Final output
% disp(['Total Volume: ', num2str(total_volume)]);



subplot(2, 3, 6);
[T_all, TrueVol] = boundary(points);
trisurf(T_all, points(:, 1), points(:, 2), points(:, 3), 'FaceAlpha', 0.5, 'EdgeColor', 'k');
title( join([ ' True Volume: ', num2str(TrueVol), newline, ...
                'Calc Vol:  ', num2str(total_volume) ]) );
axis equal;
hold off;


set(gcf,'position',[80,80,800,600])  

%


figure()
hold on


for fi = 1:4

subplot(2,2, fi)

    
    % for i = 1:4
        cluster_points = points(idx == fi, :);
        [K, v] = convhull(cluster_points);
        trisurf(K, cluster_points(:, 1), cluster_points(:, 2), cluster_points(:, 3), ...
            'FaceAlpha', 0.5, 'FaceColor', 'r');
        hold on;
        axis equal;
    % end
    trisurf(T, edge_points_unique(:, 1), edge_points_unique(:, 2), edge_points_unique(:, 3), ...
                'FaceAlpha', 0.85, 'FaceColor', 'b', 'EdgeColor', 'k');
    axis equal;
    subtitle( join(["Group ", num2str(fi), "and Inside"])  )
    hold off;

end 

set(gcf,'position',[80,80,800,600])  



%%



clc


% Sample data for demonstration
rng(1); % For reproducibility
group1 = rand(100, 3); % Group 1 points
group2 = rand(100, 3) * 2; % Group 2 points
group3 = rand(100, 3) * 3; % Group 3 points
group4 = rand(100, 3) * 4; % Group 4 points



groups = {group1, group2, group3, group4}; % Store groups in a cell array for iteration
numGroups = numel(groups);
% Placeholder for storing closest point pairs and their distances
closestPairInfo = cell(0, 5); % {Group A Index, Point A Index, Group B Index, Point B Index, Distance}
% Iterate over group pairs to find closest points between them
for i = 1:numGroups

    for j = i+1:numGroups

        distanceMatrix = pdist2(groups{i}, groups{j});
        [minDistances, minIndices] = min(distanceMatrix, [], 2);
        for k = 1:size(groups{i}, 1)
            % Store Group A Index, Point A Index, Group B Index, Point B Index, Distance
            closestPairInfo{end+1, 1} = i;
            closestPairInfo{end, 2} = k;
            closestPairInfo{end, 3} = j;
            closestPairInfo{end, 4} = minIndices(k);
            closestPairInfo{end, 5} = minDistances(k);
        end
    end
end
% Convert distances to an array for finding top 10%
allDistances = cell2mat(closestPairInfo(:, 5));
% Finding top 10% closest pairs
numTopPairs = ceil(numel(allDistances) * 0.2);
[sortedDistances, sortIdx] = sort(allDistances);
topPairIdx = sortIdx(1:numTopPairs);

TopPts = [];
for i = 1:numTopPairs
    infoIdx = topPairIdx(i);
    pairInfo = closestPairInfo(infoIdx, :);
    groupA = pairInfo{1};
    pointAIdx = pairInfo{2};
    groupB = pairInfo{3};
    pointBIdx = pairInfo{4};


    ptsa = [ groups{groupA}(pointAIdx, 1), groups{groupA}(pointAIdx, 2), groups{groupA}(pointAIdx, 3) ] ;
    ptsb = [groups{groupB}(pointBIdx, 1), groups{groupB}(pointBIdx, 2), groups{groupB}(pointBIdx, 3)] ;
    TopPts = [TopPts; ptsa; ptsb];

end 
plot3( TopPts(:,1),  TopPts(:,2),  TopPts(:,3), '.k', 'MarkerSize', 20)
axis equal

%%
% Visualization
figure;
for i = 1:numTopPairs
    infoIdx = topPairIdx(i);
    pairInfo = closestPairInfo(infoIdx, :);
    groupA = pairInfo{1};
    pointAIdx = pairInfo{2};
    groupB = pairInfo{3};
    pointBIdx = pairInfo{4};
    plot3(groups{groupA}(pointAIdx, 1), groups{groupA}(pointAIdx, 2), groups{groupA}(pointAIdx, 3), 'ro');
    hold on;
    plot3(groups{groupB}(pointBIdx, 1), groups{groupB}(pointBIdx, 2), groups{groupB}(pointBIdx, 3), 'bo');
    plot3([groups{groupA}(pointAIdx, 1), groups{groupB}(pointBIdx, 1)],...
          [groups{groupA}(pointAIdx, 2), groups{groupB}(pointBIdx, 2)],...
          [groups{groupA}(pointAIdx, 3), groups{groupB}(pointBIdx, 3)], 'k-');
    %title(sprintf('Closest Points from Group %d to %d', groupA, groupB));
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold on
    axis equal
end
sgtitle('Top 10% Closest Point Pairs');


