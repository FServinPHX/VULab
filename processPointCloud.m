




function [sortedPoints, indices] = processPointCloud(points)
    % Input: points - an Nx3 matrix where each row is an [x, y, z] coordinate

    % Step 1: Compute the center of the point cloud
    center = mean(points, 1);

    % Step 2: Calculate distances from the center
    distances = sqrt(sum((points - center).^2, 2));

    % Step 3: Sort points by distance
    [~, indices] = sort(distances);

    % Step 4: Rearrange points based on sorted indices
    sortedPoints = points(indices, :);

    % Step 5: Export the new order of indices
    % (output indices is a secondary output)
end





% 
% % Sample data
% points = [
%     1.0, 2.0, 3.0;
%     4.1, 5.9, 6.7;
%     1.5, 2.5, 3.5
% ];
% 
% % Process the point cloud
% [sortedPoints, newIndices] = processPointCloud(points);
% 
% % Display the results
% disp('Sorted Points:');
% disp(sortedPoints);
% 
% disp('Indices of New Order:');
% disp(newIndices);