





function points = filterIntensityPoints(points, specificPoint, intensityThreshold, radius)
    % COLUMN INDEXES
    X = 1; Y = 2; Z = 3; INTENSITY = 4; 

    % Calculate the squared Euclidean distance from each point to the specific point
    distancesSquared = (points(:, X) - specificPoint(X)).^2 + ...
                       (points(:, Y) - specificPoint(Y)).^2 + ...
                       (points(:, Z) - specificPoint(Z)).^2;

    % Find indices of points within 10 units distance and intensity lower than threshold
    indicesToModify = find(distancesSquared <= radius^2 & points(:, INTENSITY) < intensityThreshold);
    
    % Make the intensity values of these points positive
    points(indicesToModify, INTENSITY) = abs(points(indicesToModify, INTENSITY));
end


