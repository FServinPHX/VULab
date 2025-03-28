function [distances] = SDAVectorTargetFusedAblation_CombinedProbe_CGBT(TargetPoints, QuerryPointsOG, AllProbes)
% SDAVectorTargetFusedAblation_CombinedProbe_CGBT
% This function calculates shortest distances between query points and target points,
% considering probe points, to determine their proximity relationships.
%
% Inputs:
% - TargetPoints: Nx3 matrix of target ablation points.
% - QuerryPointsOG: Mx3 matrix of query points (image grid).
% - AllProbes: Px3 matrix of probe points.
%
% Output:
% - distances: Vector indicating the proximity relationship of each query point
% to the nearest target point and associated probe points.

% Extract x, y, z coordinates from query points and target points
x1 = QuerryPointsOG(:,1);
y1 = QuerryPointsOG(:,2);
z1 = QuerryPointsOG(:,3);

x2 = TargetPoints(:,1);
y2 = TargetPoints(:,2);
z2 = TargetPoints(:,3);

% Precompute max and min values of target points for the boundary check
max_vals = max(TargetPoints, [], 1);
min_vals = min(TargetPoints, [], 1);

% Initialize an array to store distances
distances = zeros(size(x1));

% Utilize pdist2 for pairwise distance calculations
distProbesMatrix = pdist2(QuerryPointsOG, AllProbes);
distTargetsMatrix = pdist2(QuerryPointsOG, TargetPoints);

% Identify the nearest probe and target points for each query point
[~, nearestProbeIdx] = min(distProbesMatrix, [], 2);
[distMin, nearestTargetIdx] = min(distTargetsMatrix, [], 2);

% Implement parallel processing using a parfor loop
parfor i = 1:length(x1)



    
    % Get the nearest probe and target indices
    center = AllProbes(nearestProbeIdx(i), :);
    targetPoint = TargetPoints(nearestTargetIdx(i), :);
    
    % Step 3: Compute distances with respect to the closest probe and target point
    vectorT = norm(center - targetPoint);
    vectorB = norm(center - QuerryPointsOG(i, :));

    % Step 4: Determine if the query point is inside the bounding box of target points
    inside_mask = all(QuerryPointsOG(i, :) >= min_vals & QuerryPointsOG(i, :) <= max_vals);

    % Step 5: Adjust distance based on geometric comparison and boundary checks
    if vectorT > vectorB
        distMin(i) = -distMin(i);
    end
    if ~inside_mask
        distMin(i) = distMin(i);
    end
    
    % Store the computed distance in the distances array
    distances(i) = distMin(i);
end

end