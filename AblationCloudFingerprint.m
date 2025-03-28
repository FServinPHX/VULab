function  [ HighestX1, HighestX2, LowestX1, LowestX2, HighestY1, HighestY2, LowestY1,...
            LowestY2, HighestZ1, HighestZ2, LowestZ1, LowestZ2  ]  = AblationCloudFingerprint( Upointcloud, PointSampleNum)


% Find the PointSampleNum highest and Lowest z points
[~, idxHighestZ] = maxk(Upointcloud(:, 3), PointSampleNum);
[~, idxLowestZ] = mink(Upointcloud(:, 3), PointSampleNum);

% Find the indices of the two furthest apart points among the PointSampleNum highest and Lowest z points
distHighestZ = pdist2(Upointcloud(idxHighestZ, :), Upointcloud(idxHighestZ, :));
[~, idxMaxDistHighestZ] = max(distHighestZ(:));
[idx1, idx2] = ind2sub([PointSampleNum, PointSampleNum], idxMaxDistHighestZ);
HighestZ1 = Upointcloud(idxHighestZ(idx1), :);
HighestZ2 = Upointcloud(idxHighestZ(idx2), :);

% Find the indices of the two furthest apart points among the PointSampleNum highest and Lowest x points
distLowestZ = pdist2(Upointcloud(idxLowestZ, :), Upointcloud(idxLowestZ, :));
[~, idxMaxDistLowestZ] = max(distLowestZ(:));
[idx1, idx2] = ind2sub([PointSampleNum, PointSampleNum], idxMaxDistLowestZ);
LowestZ1 = Upointcloud(idxLowestZ(idx1), :);
LowestZ2 = Upointcloud(idxLowestZ(idx2), :);

% Find the PointSampleNum highest and Lowest x points
[~, idxHighestX] = maxk(Upointcloud(:, 1), PointSampleNum);
[~, idxLowestX] = mink(Upointcloud(:, 1), PointSampleNum);

% Find the indices of the two furthest apart points among the PointSampleNum highest and Lowest x points
distHighestX = pdist2(Upointcloud(idxHighestX, :), Upointcloud(idxHighestX, :));
[~, idxMaxDistHighestX] = max(distHighestX(:));
[idx1, idx2] = ind2sub([PointSampleNum, PointSampleNum], idxMaxDistHighestX);
HighestX1 = Upointcloud(idxHighestX(idx1), :);
HighestX2 = Upointcloud(idxHighestX(idx2), :);

% Find the indices of the two furthest apart points among the PointSampleNum Lowest x points
distLowestX = pdist2(Upointcloud(idxLowestX, :), Upointcloud(idxLowestX, :));
[~, idxMaxDistLowestX] = max(distLowestX(:));
[idx1, idx2] = ind2sub([PointSampleNum, PointSampleNum], idxMaxDistLowestX);
LowestX1 = Upointcloud(idxLowestX(idx1), :);
LowestX2 = Upointcloud(idxLowestX(idx2), :);

% Find the PointSampleNum highest and Lowest y points
[~, idxHighestY] = maxk(Upointcloud(:, 2), PointSampleNum);
[~, idxLowestY] = mink(Upointcloud(:, 2), PointSampleNum);

% Find the indices of the two furthest apart points among the PointSampleNum highest and Lowest y points
distHighestY = pdist2(Upointcloud(idxHighestY, :), Upointcloud(idxHighestY, :));
[~, idxMaxDistHighestY] = max(distHighestY(:));
[idx1, idx2] = ind2sub([PointSampleNum, PointSampleNum], idxMaxDistHighestY);
HighestY1 = Upointcloud(idxHighestY(idx1), :);
HighestY2 = Upointcloud(idxHighestY(idx2), :);

% Find the indices of the two furthest apart points among the PointSampleNum Lowest y points
distLowestY = pdist2(Upointcloud(idxLowestY, :), Upointcloud(idxLowestY, :));
[~, idxMaxDistLowestY] = max(distLowestY(:));
[idx1, idx2] = ind2sub([PointSampleNum, PointSampleNum], idxMaxDistLowestY);
LowestY1 = Upointcloud(idxLowestY(idx1), :);
LowestY2 = Upointcloud(idxLowestY(idx2), :);

% Plot the resultsf
% figure;
% scatter3(Upointcloud(:, 1), Upointcloud(:, 2), Upointcloud(:, 3), 'filled', 'b');
hold on;
scatter3(HighestZ1(1), HighestZ1(2), HighestZ1(3), 61 , 'filled', 'r', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(HighestZ2(1), HighestZ2(2), HighestZ2(3), 61 , 'filled', 'r', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(LowestZ1(1), LowestZ1(2), LowestZ1(3), 61 , 'filled', 'r', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(LowestZ2(1), LowestZ2(2), LowestZ2(3), 61 , 'filled', 'r', 'MarkerEdgeColor', 'g', 'LineWidth',2);

scatter3(HighestX1(1), HighestX1(2), HighestX1(3),61 , 'filled', 'y', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(HighestX2(1), HighestX2(2), HighestX2(3), 61 ,'filled', 'y', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(LowestX1(1), LowestX1(2), LowestX1(3), 61 ,'filled', 'y', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(LowestX2(1), LowestX2(2), LowestX2(3), 61 ,'filled', 'y', 'MarkerEdgeColor', 'g', 'LineWidth',2);

scatter3(HighestY1(1), HighestY1(2), HighestY1(3), 61 , 'filled', 'k', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(HighestY2(1), HighestY2(2), HighestY2(3), 61 , 'filled', 'k', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(LowestY1(1), LowestY1(2), LowestY1(3), 61 ,'filled', 'k', 'MarkerEdgeColor', 'g', 'LineWidth',2);
scatter3(LowestY2(1), LowestY2(2), LowestY2(3), 61 , 'filled', 'k', 'MarkerEdgeColor', 'g', 'LineWidth',2);


  
% Set labels and title
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('3D Scatter Plot with Annotations');


end 




