% Function to transform (x, y, z) data points and intensity values into a segmentation file
function [nii] =   transformAndSegment(xyzData, intensityData, newCenter, gridSize, outputDir, FileName)
    % Adjust coordinates to the new center point
    initialCenter = estimateCenter(xyzData);
    shiftVector = newCenter - initialCenter;
    adjustedDataPoints = xyzData + shiftVector;
    
    % Transform the adjusted (x, y, z) data points back into a grid
    binaryGrid = zeros(gridSize, gridSize, gridSize);
    validIndices = all(adjustedDataPoints > 0 & adjustedDataPoints <= gridSize, 2);
    validPoints = adjustedDataPoints(validIndices, :);
    validIntensities = intensityData(validIndices);
    
    % Assign binary intensity values to the grid
    for idx = 1:size(validPoints, 1)
        point = validPoints(idx, :);
        binaryGrid(point(1), point(2), point(3)) = validIntensities(idx);
    end

    % Convert the binary grid into a 3D segmentation format
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    
    
    % 'adjusted_sphere_segmentation.nii'
    niftiFile = fullfile(outputDir, FileName);
    
    % Create NIFTI structure using the make_nii function
    nii = make_nii(binaryGrid, [1 1 1], [0 0 0], 2); % Ensuring datatype is int16

    % Save NIFTI file using the save_nii function provided by the NIFTI toolbox
    fprintf('Saving segmentation to %s\n', niftiFile);
    %save_nii(nii, niftiFile);
end