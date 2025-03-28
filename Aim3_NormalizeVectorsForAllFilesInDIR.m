clc
clear



% Directory with the original CSV fill iles
srcDir ='D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v3 Rotate All_Normalized';
% Destination directory
destDir = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v3 Rotate All_Normalized';

% Get a list of all CSV files
files = dir(fullfile(srcDir, '*.csv'));

% Process each file
for k = 1: length(files)  % Fixed loop to process all files
    % Read the file
    filename = fullfile(srcDir, files(k).name);
    data = readtable(filename, 'ReadVariableNames', true);
    
    % Determine the number of full XYZ-DXDYDZ sets
    nSets = (width(data) - 3) / 6;
    
    % Initialize processed data with the first 3 columns
    processedData = [];
    
    % Process each set of six columns
    for i = 0:nSets-1
        baseCol = i * 6 ;
        points = data(:, baseCol + (1:3));
        vectors = data{2:end, baseCol + (4:6)};
        
        % Compute magnitudes
        magnitudes = sqrt(sum(vectors.^2, 2));
        medianMagnitude = median(magnitudes);
        
        % Normalize vectors
        for j = 1:size(vectors, 1)
            if magnitudes(j) > 4 * medianMagnitude
                vectors(j, :) = vectors(j, :) / magnitudes(j) * medianMagnitude;
            end
        end
        
        vectors = [  data{1, baseCol + (4:6)}  ; vectors];
        vectors =  (vectors);
        points = table2array(points);
        % Convert and append the processed data
        processedData = [processedData, [points, vectors  ]  ];  % Ensure names are aligned
    end
    
    % Save the processed data
    newFilename = fullfile(destDir, ['normalized_', files(k).name]);
    writematrix(processedData, newFilename);
end