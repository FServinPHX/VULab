

%[filtered_probe_exp] = filter_AblationFixedGridPoints(Ablation, B)
% B = [QuerryPointsOG, distances];
% Ablation = chunkData(:, 1:3);
% Ablation = points(2:end, :);  


function [filtered_point_exp] = filter_AblationFixedGridPoints(Ablation, B, InsideLimit,  OutsideLimit)

% B = B
% B(:,1) = x coord, B(:,2) = y coord, B(:,3) = z coord,
% B(:,4) = intensity value

% 
% tic


B = [B, (1:length(B))']; % original index
filtered_probe = B(:, 1:3);

% Create a tetrahedral mesh using Delaunay triangulation
DT = delaunayTriangulation(Ablation);

% Extract the tetrahedral mesh connectivity list from Delaunay triangulation
tet = DT.ConnectivityList;
TR = triangulation(tet, Ablation);
[S.faces, S.vertices] = freeBoundary(TR);
in1 = in_polyhedron(S, filtered_probe);
PointsInside = filtered_probe(in1, :);
pointsOutside = filtered_probe(~in1, :);

%NExT STEP


%



% Extract x, y, z coordinates for PointsInside and PointsOutside
pointsInsideCoords = PointsInside; % Assuming PointsInside has the same structure as B
pointsOutsideCoords = pointsOutside; % Assuming PointsOutside has the same structure as B

% Create a map for quick lookup in B, using x, y, z as the key
keyFormat = '%.10g_%.10g_%.10g'; % Define format for the key
pointMap = containers.Map('KeyType', 'char', 'ValueType', 'any');

% Populate the map with entries from B
for i = 1:size(B, 1)
    % Generate a key from the x, y, z coordinates
    key = sprintf(keyFormat, B(i, 1), B(i, 2), B(i, 3));
    % Store intensity and index in the map
    pointMap(key) = [B(i, 4), B(i, 5)];
end

% Create result matrices to store results with intensity and index
pointsInsideResults = zeros(size(pointsInsideCoords, 1), 5);
pointsOutsideResults = zeros(size(pointsOutsideCoords, 1), 5);

% Process PointsInside
for i = 1:size(pointsInsideCoords, 1)
    point = pointsInsideCoords(i, :);
    key = sprintf(keyFormat, point(1), point(2), point(3));
    if isKey(pointMap, key)
        % Retrieve intensity and index from the map
        values = pointMap(key);
        % Append x, y, z, intensity, and index to results
        pointsInsideResults(i, :) = [point, values];
    end
end

% Process PointsOutside
for i = 1:size(pointsOutsideCoords, 1)
    point = pointsOutsideCoords(i, :);
    key = sprintf(keyFormat, point(1), point(2), point(3));
    if isKey(pointMap, key)
        % Retrieve intensity and index from the map
        values = pointMap(key);
        % Append x, y, z, intensity, and index to results
        pointsOutsideResults(i, :) = [point, values];
    end
end






%


PointsInside = pointsInsideResults;
pointsOutside = pointsOutsideResults;


% Process intensity values for PointsInside
insideIntensities = PointsInside(:, 4); % Extract intensity column

%InsideLimit = 10;
insideIntensities(insideIntensities > InsideLimit) = -abs(insideIntensities(insideIntensities > InsideLimit));



% Process intensity values for PointsOutside
outsideIntensities = pointsOutside(:, 4); % Extract intensity column
%OutsideLimit = -0.5;
outsideIntensities(outsideIntensities > OutsideLimit) = abs(outsideIntensities(outsideIntensities > OutsideLimit));

% Update the intensity columns
PointsInside(:, 4) = insideIntensities;
pointsOutside(:, 4) = outsideIntensities;

% Combine the inside and outside point sets
filtered_point_exp = [PointsInside; pointsOutside];

% Final step: reorganize all the rows of filtered_probe_exp back into its original row placements of B
[~, sortIdx] = sort(filtered_point_exp(:, 5));
filtered_point_exp = filtered_point_exp(sortIdx, :);

% Remove the fifth column before returning the result
filtered_point_exp = filtered_point_exp(:, 1:4);





 % Determine the min and max x, y, z limits of Ablation_Points
    xMin = min(Ablation(:, 1));
    xMax = max(Ablation(:, 1));
    yMin = min(Ablation(:, 2));
    yMax = max(Ablation(:, 2));
    zMin = min(Ablation(:, 3));
    zMax = max(Ablation(:, 3));
    
    % Get the x, y, z, and intensity columns from filtered_point_exp
    x = filtered_point_exp(:, 1);
    y = filtered_point_exp(:, 2);
    z = filtered_point_exp(:, 3);
    intensity = filtered_point_exp(:, 4);
    
    % Create a logical mask for points beyond the x, y, z limits
    beyond_limits = x < xMin | x > xMax | y < yMin | y > yMax | z < zMin | z > zMax;
    
    % Create a logical mask for intensity values that are negative
    negative_intensity = intensity < 0;
    
    % Combine masks - points beyond limits and with negative intensity
    mask = beyond_limits & negative_intensity;
    
    % Update intensity values using the mask
    filtered_point_exp(mask, 4) = abs(intensity(mask));

% 
% toc




% Visualization

% filtered_Intensities = filtered_probe_exp(:, 4);
% filtered_Intensities(filtered_Intensities > 0) = nan;
% 
% figure;
%     hold on;
% 
%     % Plot the triangulation with transparency
%     trisurf(S.faces, S.vertices(:, 1), S.vertices(:, 2), S.vertices(:, 3), ...
%         'FaceColor', 'cyan', 'FaceAlpha', 0.25, 'EdgeColor', 'none');
% 
%     % Plot the points with their intensities using jet colormap
%     scatter3(filtered_probe_exp(:, 1), filtered_probe_exp(:, 2), filtered_probe_exp(:, 3), ...
%         20, filtered_Intensities , 'filled');
%     colormap('jet');
%     colorbar;
%     title('Points and Triangulation Visualization');
%     xlabel('X');
%     ylabel('Y');
%     zlabel('Z');
%     grid on;
%     axis equal;
%     hold off;

end