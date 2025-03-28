
clc
clear

% Specify the directories
input_directory = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v1 Rotate All';
output_directory = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2 Rotate All';

% Ensure the output directory exists
if ~exist(output_directory, 'dir')
    mkdir(output_directory);
end

% List all CSV files in the input directory
csv_files = dir(fullfile(input_directory, '*.csv'));  % Changed file extension from '.prove' to '.csv'

% Loop through each file in the directory
for k = 1: length(csv_files)  % Changed back to length(csv_files) to process all files
    input_filename = fullfile(csv_files(k).folder, csv_files(k).name);
    output_filename = fullfile(output_directory, csv_files(k).name); % output file with the same name in a different directory
    fprintf('Processing file: %s\n', input_filename);

    % Load data from the CSV file
    data = readtable(input_filename);

    % Calculate the index of the last column
    last_col = width(data);

    % Identify the relevant column indices
    last_three_cols = (last_col-2):last_col;
    middle_three_cols = [334, 335, 336];
    B_cols = [328, 329, 330];  % Fixed the syntax error from "B_cols = (last_col-15):( , last_col-13);"

%

    % Extract values from columns designated as B
    B = data{2:end, B_cols}; % Ignoring the first row as specified

    

    % Replace values in the first two sets of identified columns with B values (excluding the first row)
    data{2:end, middle_three_cols} = B;
    data{2:end, last_three_cols} = B;

    



    % Save the modified table back to the output directory under the same filename
    writetable(data, output_filename);
    fprintf('Modified data saved: %s\n', output_filename);
end