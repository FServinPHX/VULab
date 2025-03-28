



function normalizedMatrixOpacities = normalizeToRangeOpacities(matrix)
    % Minimum and maximum values for the target range
    targetMin = 0.15;
    targetMax = 1.0;

    % Find the minimum and maximum values of the input matrix
    dataMin = min(matrix(:));
    dataMax = max(matrix(:));

    % Scale data to a 0 to 1 range
    scaledMatrix = (matrix - dataMin) / (dataMax - dataMin);

    % Scale data to the target range (0.25 to 1)
    normalizedMatrixOpacities = targetMin + scaledMatrix * (targetMax - targetMin);
end
