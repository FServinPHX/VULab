
% Clear workspace, command window, and close all figures.
clear; clc; close all;


% file1 = "group_2 Resampled\120degree_All ArrPoints Experiment  101   __Theta1  0.1    Psi1  72     __Theta2  7.5    Psi2  115.7    All__ReFilled.csv";
% file2 = "group_2\120degree_All ArrPoints Experiment  101   __Theta1  0.1    Psi1  72     __Theta2  7.5    Psi2  115.7    All.csv";



%  "OG"      "Resampled"    Resampled II
dir_Type = "Resampled II" ; 
% Specify the directory to search in.
switch dir_Type
    case "OG"
        directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2';
        outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data\Original Grid Segmentation';

        
    case "Resampled"
        directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2 Resampled'; % Change this to your directory
        outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data\Resampled Grid Segmentation';
    
    
    case "Resampled II"
        directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2 Resampled ii' ; % Change this to your directory
        outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data\Resampled Grid Segmentation ii';
                
end 
% Create a pattern to match .csv files.
filePattern = fullfile(directoryPath, '*.csv');

% Get a list of all .csv files in the directory.
FilesCSV = dir(filePattern);

% Flag indicating whether to create data.
CreateData = true;
%%
% Loop over the files in the directory.
for fi = 1:1 % length(FilesCSV)
    tic;  % Start timing.
    
    % Get the current file's full path.
    filePath = fullfile(directoryPath, FilesCSV(fi).name);
    
    % Read data from the CSV file.
    data = csvread(filePath);
    
    % Initialize the list for storing all intensities.
    All_Intensities = [];
    
    for i = 1:4:(size(data, 2) - 3)
        idx = 2 : 1 : (15*4)+2 ;
        minutes =  floor( (idx(i)*15-15)/60)   ; 
        seconds  = mod( (idx(i)*15-15), 60)    ;
    
        % Set values for processing.
        querryPointsOG = data(:, 1:3);
        ExportBinary = data(:, i+3);  % This variable is not used but assumed to be needed inside `ExportBinary`.
        ExportBinary(ExportBinary > 0) = 0;
        %ExportBinary(ExportBinary < -20) = 0 ;    
        ExportBinary(ExportBinary < 0) = 1 ;   

        % Preset values (need actual definitions or calculations).
        binaryIntensities = ExportBinary;  % Assuming ExportBinary is defined elsewhere.
        gridSize = nthroot(length(querryPointsOG), 3);
        newCenter = [0, 0, 0];

        % Generate file name.
        FileName = sprintf('RUN_num_%d_%dMin%dS.nii', fi, minutes, seconds);

        % Count the number of 1's in the original intensity matrix.
        count = countOnesInMatrix(binaryIntensities);
        disp(['Number of 1s in the Original matrix: ', num2str(count)]);
        
        % Set voxel properties.
        pVoxVoxSize = [100, 100, 100];
        center = [0, 0, 0] - (pVoxVoxSize / 2);
        strt = [0, 0, 0];
        endd = strt;

        % Generate voxel grid.
        pVoxVolxelx = center(1) + pVoxVoxSize(1) * (strt(1):pVoxVoxSize(1):endd(1));
        pVoxVolxely = center(2) + pVoxVoxSize(2) * (strt(2):pVoxVoxSize(2):endd(2));
        pVoxVolxelz = center(3) + pVoxVoxSize(3) * (strt(3):pVoxVoxSize(3):endd(3));

        % Transform querry points to meshgrid.
        [intensity_X, intensity_Y, intensity_Z, intensity_I] = transformQuerryPointsToMeshgrid(querryPointsOG, binaryIntensities, ...
            pVoxVolxelx, pVoxVolxely, pVoxVolxelz, 2);  % Assuming transformQuerryPointsToMeshgrid is defined elsewhere.
        
        % Create the binary grid.
        binaryGrid = intensity_I;

        % Convert the binary grid into a 3D segmentation format.
        if ~exist(outputDir, 'dir')
            mkdir(outputDir);
        end

        % Generate NIfTI file and save.
        niftiFile = fullfile(outputDir, FileName);
        nii = make_nii(binaryGrid, [1 1 1], [0 0 0], 2);  % Ensuring datatype is int16.
        save_nii(nii, niftiFile);  % Assuming save_nii is defined elsewhere.

        % Count the number of 1's in the binary grid matrix.
        count = countOnesInMatrix(binaryGrid);
        disp(['Number of 1s in the Binary Grid matrix: ', num2str(count)]);
    end

    toc;  % Stop timing.

    pause(.25)
end


