


% Create Probe Reference Names

StartingPlacement = readtable("D:\Import To Matlab\Aim 3_ProbePlacements\Matlab_ML_COMSOL_Placement.csv");
ImportData = table2array(StartingPlacement); 




%%
% Step 1: Reading all '.csv' filenames in the directory
folder = 'D:\COMSOL Models\ML_Test\COMSOL Model Analysis II'; % Change this to your directory path
files = dir(fullfile(folder, '*.csv'));

% Preallocate array to store extracted information
extractedInfo = struct('ExperimentNumber', {}, 'Theta1', {}, 'Psi1', {}, 'Theta2', {}, 'Psi2', {});
extractedInfoMat  = [] ; 
% Step 3: Loop through all files to parse and extract info
for file = files'
    filename = file.name;
    % Step 2: Parse filename to extract relevant numerical information
    % Pattern breaks down as follows:
    % - Experiment number follows "Experiment"
    % - Theta1 is followd by "__Theta1"
    % - Psi1 follows "Psi1"
    % - Theta2 is followd by "__Theta2"
    % - Psi2 follows "Psi2"
    
    % Update the pattern to capture negative numbers and decimal points
    pattern = 'Experiment\s+(\d+)\s+__Theta1\s+(-?\d+\.?\d*)\s+Psi1\s+(-?\d+\.?\d*)\s+__Theta2\s+(-?\d+\.?\d*)\s+Psi2\s+(-?\d+\.?\d*)\.csv';
    tokens = regexp(filename, pattern, 'tokens');
    
    if ~isempty(tokens)
        % Convert strings to numbers
        experimentNumber = str2double(tokens{1}{1});
        theta1 = str2double(tokens{1}{2});
        psi1 = str2double(tokens{1}{3});
        theta2 = str2double(tokens{1}{4});
        psi2 = str2double(tokens{1}{5});
        
        % Store extracted info in array
        extractedInfo(end+1) = struct('ExperimentNumber', experimentNumber, ...
                                      'Theta1', theta1, ...
                                      'Psi1', psi1, ...
                                      'Theta2', theta2, ...
                                      'Psi2', psi2);

        extractedInfoMat  = [extractedInfoMat; 
                                                experimentNumber, theta1, psi1, theta2, psi2]; 

    end
end

% Display extracted information
%disp(extractedInfo);

extractedInfo = cell2mat(extractedInfo);

%%



% Assuming data1 and data2 are already defined and populated
% data1 = {...}; % 5 columns
% data2 = {...}; % 10 columns
data1 = extractedInfoMat;
data2 = ImportData;
% Initialize a variable to store the indices of matching rows from data2
matchingRowsData1 = []; % Initialize an array to keep track of matching rows in data1

% Loop through each row in data1
for idx1 = 1:size(data1, 1)

    % Find all indices in data2 that match the criteria for each column comparison
    indices1 = find(data2(:, 1) == data1(idx1, 2));
    indices2 = find(data2(:, 2) == data1(idx1, 3));
    indices3 = find(data2(:, 6) == data1(idx1, 4));
    indices4 = find(data2(:, 7) == data1(idx1, 5));
    
    % Determine the common indices across indices1, indices2, indices3, and indices4
    % Using intersect to find common elements
    commonIndices = intersect(intersect(intersect(indices1, indices2), indices3), indices4);
    
    % Handling the case where there is a common index
    if ~isempty(commonIndices)
        TrueIndex = commonIndices; % Assuming there could be more than one
    else
        TrueIndex = []; % No common index exists
    end
    
    % Display the TrueIndex (if exists) for the current row in data1
    fprintf('Row %d in data1 has TrueIndex in data2: ', idx1);
    disp(TrueIndex);
end
