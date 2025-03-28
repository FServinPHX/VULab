


function [intensity_X, intensity_Y, intensity_Z, intensity_I] = transformQuerryPointsToMeshgrid(QuerryPointsOG, intensityI, ...
    pVoxVolxelx, pVoxVolxely, pVoxVolxelz, intensityspc)
    % Extract X, Y, Z coordinates from QuerryPointsOG
    intensity_X_coords = QuerryPointsOG(:, 1);
    intensity_Y_coords = QuerryPointsOG(:, 2);
    intensity_Z_coords = QuerryPointsOG(:, 3);
   
    
    % Determine the dimensions of the original meshgrid
    dimension_x = length(pVoxVolxelx : intensityspc : abs(pVoxVolxelx    ));
    dimension_y = length(pVoxVolxely : intensityspc : abs(pVoxVolxely    ));
    dimension_z = length(pVoxVolxelz : intensityspc : abs(pVoxVolxelz    ));
    
    % Reshape the X, Y, Z coordinates back to their original meshgrid dimensions
    intensity_X = reshape(intensity_X_coords, [dimension_x, dimension_y, dimension_z]);
    intensity_Y = reshape(intensity_Y_coords, [dimension_x, dimension_y, dimension_z]);
    intensity_Z = reshape(intensity_Z_coords, [dimension_x, dimension_y, dimension_z]);
    
    % Create the intensity grid I
    intensity_I = reshape(intensityI, [dimension_x, dimension_y, dimension_z]);
end