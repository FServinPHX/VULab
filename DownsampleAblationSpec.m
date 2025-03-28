function [DownsampledPoints] = DownsampleAblationSpec_CGBT(NewPoints, numpoints)
    % DOWNSAMPLEABLATIONSPEC - This function downsamples a set of 3D points
    % such that only the specified number of points remain. 
    % The method involves creating a spectral shape based on distances 
    % between points and sorting to retain the most distinct set of points.
    %
    % INPUTS:
    % NewPoints - A matrix of size Nx3 where each row is a point in 3D space
    % numpoints - The number of points to retain after downsampling
    %
    % OUTPUTS:
    % DownsampledPoints - A matrix of the downsampled points

    x1 = NewPoints(:,1);
    y1 = NewPoints(:,2);
    z1 = NewPoints(:,3);
    
    %----------------------------------------------------------------------------------------%
    % Step 1: Sort the Points by creating a spectral shape
    % Calculate the mean distance from each point to all other points.
    distances = zeros(length(x1), 1); 
    for i = 1:length(x1)
        % Compute the mean distance for the current point to all other points
        distances(i) = mean(sqrt((x1(i)-x1).^2 + (y1(i)-y1).^2 + (z1(i)-z1).^2));
    end
    
    % Normalize the distances
    distances = distances / max(distances);
    
    % Sort the distances in descending order to identify the most central point
    [~, I_DS] = sort(distances, 'descend');
    
    % Identify the point that is closest to all other points
    i = I_DS(1);
    
    % Sort the remaining points from furthest to closest to this central point
    [~, I_DS] = sort(sqrt((x1(i)-x1).^2 + (y1(i)-y1).^2 + (z1(i)-z1).^2), 'descend');
    %----------------------------------------------------------------------------------------%
    
    % Re-order points based on calculated indices
    NewPoints = NewPoints(I_DS, :);
    x1 = NewPoints(:,1);
    y1 = NewPoints(:,2);
    z1 = NewPoints(:,3);

    % Calculate the amount of downsampling needed
    downsample = length(x1) - numpoints - 1;
    
    % Extract points from the sorted list starting from the downsampling index
    Pablation = [x1, y1, z1];
    DownsampledPoints = Pablation(downsample:end, :);
  
    % Adjust downsampled points to ensure the correct number of points
    if size(DownsampledPoints, 1) > numpoints
        b = size(DownsampledPoints, 1) - numpoints + 1;
        DownsampledPoints = DownsampledPoints(b:end, :);
    end
end