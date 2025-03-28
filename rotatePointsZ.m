

function rotatedPoints = rotatePointsZ(points, center, angleDegrees)
    % Rotate 3D points around the Z-axis by a specified degree about a center point.
    %
    % Inputs:
    %   points       - Nx3 matrix containing the x, y, z coordinates of the points
    %   center       - 1x3 vector specifying the center of rotation (x, y, z)
    %   angleDegrees - scalar, the angle in degrees for rotation around the Z-axis
    %
    % Output:
    %   rotatedPoints - Nx3 matrix containing the rotated x, y, z coordinates

    % Convert angle from degrees to radians
    angleRadians = deg2rad(angleDegrees);
    
    % Define the rotation matrix around the Z-axis
    Rz = [cos(angleRadians) -sin(angleRadians) 0;
          sin(angleRadians)  cos(angleRadians) 0;
          0                  0                 1];
    
    % Translate points to the origin based on the center
    translatedPoints = points - center;
    
    % Apply the rotation matrix
    rotatedTranslatedPoints = (Rz * translatedPoints')';
    
    % Translate points back to the original center
    rotatedPoints = rotatedTranslatedPoints + center;
end