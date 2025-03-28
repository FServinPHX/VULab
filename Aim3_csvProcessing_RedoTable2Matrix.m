


clear
clc




% Directory where the CSV files are located
srcDir = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v4';

% Directory where the modified CSV files will be saved
% This can be the same as srcDir if you want to overwrite the original files
destDir = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v4';

% Get a list of all CSV files
files = dir(fullfile(srcDir, '*.csv'));

% Loop over each file
for k = 1:length(files)
    % Full path to the current file
    filename = fullfile(srcDir, files(k).name)

    % Read the data skipping the first row
    data = readtable(filename, 'ReadVariableNames', false);

    % Remove the first row which contains headers
    %data(:, :) = [];

    % Create new filename or use the original to overwrite
    newFilename = fullfile(destDir, files(k).name);

    % Write the updated data to new file location
    % Option 'WriteVariableNames', false will prevent MATLAB from adding header row
    writetable(data, newFilename, 'WriteVariableNames', false);
end