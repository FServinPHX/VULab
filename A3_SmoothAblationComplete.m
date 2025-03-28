

function [ProbePts_filtered, pointsExport] =  A3_SmoothAblationComplete(points, ProbePts, ...
                                                    num_iterations, num_neighbors, scale)




A = ProbePts;
% Step 1: Find the maximum and minimum z values in B
maxZ = max(points(:,3))* .95 ;
minZ = min(points(:,3));
% Step 2: Remove points in A that have z values outside the range [minZ, maxZ]
ProbePts_filtered = A(A(:,3) <= maxZ & A(:,3) >= minZ, :);
% Step 3: Plot the results


num_points = length(points);
centerType = "PROBE";
for iter = 1:num_iterations
    for i = 1:num_points
        % Vector and distance from current point to center

        if centerType == "PROBE"
            distances = pdist2(ProbePts_filtered, points(i,:), 'euclidean');
            % Find the smallest distance and corresponding index
            [minDistance, indexNearest] = min(distances);
            % Get the nearest point
            center = ProbePts_filtered(indexNearest, :);
        end 

        vector_to_center = points(i,:) - center;
        dist_to_center = norm(vector_to_center);
        
        % Calculate distances to all other points
        distances = sqrt(sum((points(i,:) - points).^2, 2));
        
        % Find the five closest neighbors (excluding self)
        [~, idx] = mink(distances, num_neighbors+1);
        idx = idx(idx~=i); % Remove self from neighbors
        
        % Average distance of neighbors from center
        avg_neighbor_dist = mean(sqrt(sum((points(idx,:) - center).^2, 2)));
        


        % Adjust the current point based on comparison with average distance
        SubtractVector = vector_to_center * (dist_to_center - avg_neighbor_dist) / dist_to_center;
        AddVector = vector_to_center * (avg_neighbor_dist - dist_to_center) / dist_to_center;

        if dist_to_center > avg_neighbor_dist
            points(i,:) = points(i,:) -  SubtractVector.* scale;
        elseif dist_to_center < avg_neighbor_dist
            points(i,:) = points(i,:) +  AddVector .* scale;
        end
    end
end

pointsExport = points;

end 


