% Create a 3D binary grid representation of a sphere and save it in a visualization-compatible format.
% Step 1: Initialize the parameters
clc;
clear;

% Define grid and sphere parameters
gridSize = 100;  % Define the size of the grid (NxNxN)
sphereRadius = 30; % Define the radius of the sphere
sphereCenter = [50, 50, 50]; % Define the center of the sphere at (x, y, z)

% Pre-allocate a 3D binary grid with zeros
binaryGrid = zeros(gridSize, gridSize, gridSize);

%Step 2: Create a sphere in the binary grid
% Create the meshgrid for grid coordinates
[X, Y, Z] = ndgrid(1:gridSize, 1:gridSize, 1:gridSize);
% Calculate Euclidean distance from each voxel to the sphere center
distances = sqrt((X - sphereCenter(1)).^2 + (Y - sphereCenter(2)).^2 + (Z - sphereCenter(3)).^2);
% Assign 1s to voxels inside the sphere
binaryGrid(distances <= sphereRadius) = 1;

% Step 3: Convert the binary grid into a 3D segmentation format
% ITK-Snap and Slicer often use NIFTI format for 3D imaging data
% Utilize existing Matlab library for NIFTI file IO

% Define the output directory and file name
outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
niftiFile = fullfile(outputDir, 'sphere_segmentation1.nii');

% Ensure the NIFTI library functions are available
if exist('make_nii', 'file') ~= 2 || exist('save_nii', 'file') ~= 2
    error('NIFTI library is not installed. Please install from https://github.com/xiangruili/dicm2nii');
end

% Create NIFTI structure using the make_nii function
nii = make_nii(binaryGrid, [1 1 1], [0 0 0], 2); % Ensuring datatype is int16

% Save NIFTI file using the save_nii function provided by the NIFTI toolbox
fprintf('Saving segmentation to %s\n', niftiFile);
save_nii(nii, niftiFile);
fprintf('3D segmentation saved successfully!\n');
fprintf('Script execution complete.\n');




%%


% Initialize environment
clc;
clear;

% Step 1: Generate (x, y, z) data points and binary intensity values
% Define grid parameters
gridSize = 100; % Define the size of the grid (NxNxN)
sphereRadius = 30; % Define the radius of the sphere
initialCenter = [50, 50, 50]; % Define the initial center of the sphere at (x, y, z)

% Create meshgrid for grid coordinates
[X, Y, Z] = ndgrid(1:gridSize, 1:gridSize, 1:gridSize);

% Calculate Euclidean distance from each voxel to the initial sphere center
distances = sqrt((X - initialCenter(1)).^2 + (Y - initialCenter(2)).^2 + (Z - initialCenter(3)).^2);

% Create binary intensity values (1 inside the sphere, 0 outside)
intensityValues = distances <= sphereRadius;

% Flatten the (x, y, z) coordinates and intensities for 3-column format
dataPoints = [X(:), Y(:), Z(:)];
binaryIntensities = intensityValues(:);

% Step 2: Readjust coordinates to a new center point
newCenter = [60, 60, 60]; % Define the new center point
shiftVector = newCenter - initialCenter;

% Translate data points to the new center point
adjustedDataPoints = dataPoints + shiftVector;

% Step 3: Transform the adjusted (x, y, z) data points back into a grid
% Prepare an empty binary grid 
binaryGrid = zeros(   nthroot( dataPoints ,3), nthroot( dataPoints ,3), ...
                   nthroot( dataPoints ,3) );

% Ensure the adjusted data points are within valid grid bounds
validIndices = all(adjustedDataPoints > 0 & adjustedDataPoints <= gridSize, 2);
validPoints = adjustedDataPoints(validIndices, :);
validIntensities = binaryIntensities(validIndices);

% Assign binary intensity values to the grid
for idx = 1:size(validPoints, 1)
    point = validPoints(idx, :);
    binaryGrid(point(1), point(2), point(3)) = validIntensities(idx);
end

% Step 4: Convert the binary grid into a 3D segmentation format
% ITK-Snap and Slicer often use NIFTI format for 3D imaging data

% Define output directory and file name
outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
niftiFile = fullfile(outputDir, 'adjusted_sphere_segmentation.nii');


% Create NIFTI structure using the make_nii function
nii = make_nii(binaryGrid, [1 1 1], [0 0 0], 2); % Ensuring datatype is int16

% Save NIFTI file using the save_nii function provided by the NIFTI toolbox
fprintf('Saving segmentation to %s\n', niftiFile);
save_nii(nii, niftiFile);
fprintf('3D segmentation saved successfully!\n');
fprintf('Script execution complete.\n');




%%









% -- Main Script to Create and Save 3D Segmentation --

% Step 1: Initialize environment and generate 3D sphere on a regular binary grid
clc;
clear;

% Configuration
gridSize = 100; % Define the size of the grid (NxNxN)
sphereRadius = 30; % Define the radius of the sphere
initialCenter = [50, 50, 50]; % Define the initial center of the sphere at (x, y, z)
outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data'; % Define output directory

% Generate 3D Sphere and save as segmentation
[xyzData, intensityData] = generateSphere(gridSize, sphereRadius, initialCenter);




newCenter = [60, 60, 60]; % Define new center point
FileName = 'adjusted_sphere_segmentation 2.nii'; 
%[nii] = transformAndSegment(dataPoxyzDataints, intensityData, newCenter, gridSize, outputDir, FileName);




% [nii] =   transformAndSegment(xyzData, intensityData, newCenter, gridSize, outputDir, FileName)
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




fprintf('3D segmentation saved successfully!\n');

% -- Function Definitions --

% Function to generate a 3D sphere represented as a binary regular grid



% Ensure that the NIFTI toolbox is available. You can obtain it from:
% http://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image

% make_nii and save_nii functions are part of the NIFTI toolbox.
% Ensure these functions are available in your MATLAB path.

% Sample usages and detailed function definitions are provided inside the main script and individual functions.
