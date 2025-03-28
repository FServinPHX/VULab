clear
clc

% HARDCODED MATLAB SCRIPT FOR CSV FILE PROCESSING

% Define the input and output directories
inputDir = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v4';  % Update this to your input directory
outputDir = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v4_   ONLY POINTS_ v5';  % Update this to your output directory

% Create the output directory if it doesn't exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Get the list of CSV files in the directory
files = dir(fullfile(inputDir, '*.csv'));

%
% Loop through each file found
for i = 1:length(files)  % floor( length(files)/3)
    fileName = fullfile(inputDir, files(i).name);  % Full path to current file
    rawData = readmatrix(fileName, 'NumHeaderLines', 1);  % Read data, skip header

    % Initialize the new points array
    AllPoints = [];

    % Process each set of points
    for j = 1:6:size(rawData, 2)
        x = rawData(:, j);
        y = rawData(:, j+1);
        z = rawData(:, j+2);
        
        % Special behavior for the last set
        if j == size(rawData, 2) - 5
            extendedLastPoint = [x, y, z] * 1.05;
            %AllPoints = [AllPoints,  x, y, z ];
             AllPoints = [AllPoints,  x, y, z ];

        elseif j <= 4
            %AllPoints = [AllPoints, x, y, z,  x, y, z,   x, y, z,];
             AllPoints = [AllPoints,   x, y, z,];

        else  % Normal behavior
            AllPoints = [AllPoints, x, y, z, x, y, z];
        end
    end
    
    % Determine the new file name for output
    [~, baseName, ~] = fileparts(files(i).name);  % Extract base file name without extension
    newFileName = fullfile(outputDir, ['PointsOnly_' baseName '.csv']);  % Create new full path
    

    AllPoints = round(AllPoints, 2)
    % Write the processed data to the new file location
    writematrix(AllPoints, newFileName);
end