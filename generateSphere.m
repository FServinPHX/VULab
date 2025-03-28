function [dataPoints, binaryIntensities] = generateSphere(gridSize, sphereRadius, center)
    [X, Y, Z] = ndgrid(1:gridSize, 1:gridSize, 1:gridSize);

    % Calculate Euclidean distance from each voxel to the sphere center
    distances = sqrt((X - center(1)).^2 + (Y - center(2)).^2 + (Z - center(3)).^2);

    % Create binary intensity values (1 inside the sphere, 0 outside)
    intensityValues = distances <= sphereRadius;

    % Flatten the (x, y, z) coordinates and intensities for 3-column format
    dataPoints = [X(:), Y(:), Z(:)];
    binaryIntensities = intensityValues(:);
end