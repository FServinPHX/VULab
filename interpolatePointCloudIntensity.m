

function B_intensities = interpolatePointCloudIntensity(A, B)
    % interpolatePointCloudIntensity - Interpolates and extrapolates intensities from pointcloud A to B

    % Inputs:
    % A - Nx4 matrix, where N is the number of points. Columns are x, y, z coordinates and intensity
    % B - Mx3 matrix, where M is the number of points. Columns are x, y, z coordinates

    % Output:
    % B_intensities - Mx1 vector containing the interpolated/extrapolated intensities for pointcloud B
    
    % Filter out rows in A with NaN in any column
    A = A(~any(isnan(A), 2), :);
    
    % Create interpolant object. 
    % Points are A(:,1:3), Intensities are A(:,4), and method 'natural' for natural neighbor interpolation
    % 'nearest' option in extrapolation to handle points in B outside the convex hull of A's points
    F = scatteredInterpolant(A(:,1:3), A(:,4), 'natural', 'nearest');
    
    % Interpolate/extrapolate the intensities for pointcloud B
    B_intensities = F(B);

end