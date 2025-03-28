
clear 
clc

% Step 1: Read in CSV data
exportDIR = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v1 _EPL\';

% Specify the directory you want to search in
% D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v1 _EPL
directoryPath = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2 Rotate All_normalized'; % Change this to your directory
% Create a pattern to match .mph files
filePattern = fullfile(directoryPath, '*.csv');
% Get a list of all files in the directory with .mph extension
FilesCSV = dir(filePattern);


export_Data = "TRUE";
export_labels = "F";
%
for fi = 1: size(  FilesCSV, 1)


    file_path = fullfile(directoryPath, FilesCSV(fi).name);
    [filepath, fname, fext]  = fileparts(file_path); 
    data = csvread(  file_path  );
    
    % Get the size of the data
    [rows, cols] = size(data);
    
    % Initialize a variable to keep all processed data
    processed_data = [];
    
    % Initialize a counter for labeling
    label_count = 1;
    
    for i = 2:rows
        % Step 2 & 3: Extract the first row and then process it
        current_row = data(i, :);
        
        % Initialize a temporary container for the current row's data blocks
        temp_data = [];
        
        for j = 1:6:length(current_row)
            if j+5 <= length(current_row)
                % Take blocks of 6 data points and stack them
                block = current_row(j:j+5);
                temp_data = [temp_data; block];
            end
        end
        
        % Step 4: Save the current n*6 dataset, place it side by side
        if isempty(processed_data)
            processed_data = temp_data;
        else
            % Match the number of rows and columns when combining
            if size(temp_data, 1) > size(processed_data, 1)
                % If new data block has more rows, pad existing data
                processed_data(size(processed_datas, 1)+1:size(temp_data, 1), :) = 0;
            elseif size(temp_data, 1) < size(processed_data, 1)
                % If existing data has more rows, pad new data block
                temp_data(size(temp_data, 1)+1:size(processed_data, 1), :) = 0;
            end
            % Concatenate side by side
            processed_data = [processed_data, temp_data];
        end
        
        % Update label count per iteration
        label_count = label_count + 1;
    
    end
    label_count = label_count -1;
    
    
    % Step 6: Create labels
    labels = {};
    for i = 1:label_count
        new_labels = {strcat('x_', num2str(i)), strcat('y_', num2str(i)), ...
                      strcat('z_', num2str(i)), strcat('dx_', num2str(i)), ...
                      strcat('dy_', num2str(i)), strcat('dz_', num2str(i))};
        labels = [labels, new_labels];
    end
    
    if export_Data == "TRUE"
        exportName = join([exportDIR, 'Each_Point_Label    ', fname, '.csv']);
        writematrix(processed_data, exportName);
    end 
% % Save labels and data to .mat file
% save('processed_data.mat', 'processed_data', 'labels');

end 


%%
if export_labels == "TRUE"


    % Convert cell array to string array
    labelsString = string(labels);
    % Display the converted string array
    disp(labelsString);
    % Define the CSV filename
    exportDIR = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v4\labels\';
    csvFilename = join([exportDIR, 'Each_Point_Labels', '.csv']);
    

    % Export the string array to CSV
    writematrix(labelsString, csvFilename); 
    disp(['Labels have been written to ', csvFilename]); 
end 