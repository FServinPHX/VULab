%


% Specify the parent directory containing the folders
parentDirectory = 'D:\Import To Matlab\SyntheticPointCloud_v5';

% Specify the destination directory to create new folders
destinationDirectory = 'D:\Import To Matlab\SyntheticPointCloud_v6';

% Get a list of all the folders in the parent directory
folders = dir(parentDirectory);
folders = folders([folders.isdir]);

% Remove the '.' and '..' folders from the list
folders = folders(3:end);

% Loop through each folder
for i = 1:numel(folders)
    folderName = folders(i).name;
    folderPath = fullfile(parentDirectory, folderName);
    
    % Get a list of all the files in the current folder
    files = dir(fullfile(folderPath, '*.csv')); % Specify the file extension as required
    files = {files.name};
    
    % Loop through each file and extract the last 10 letters
    for j = 1:numel(files)
        fileName = files{j};
        filePath = fullfile(folderPath, fileName);
  
        
        % Extract the last 10 letters and save them as a string
        extractedString = filePath(end-11:end-4)   
        
        % Create a new folder in the destination directory
        newFolderName = strcat(extractedString);
        newFolderPath = fullfile(destinationDirectory, newFolderName);
        mkdir(newFolderPath);

%         % Save a copy of the file in the new folder
        newFilePath = fullfile(newFolderPath, fileName);
        copyfile(filePath, newFilePath);
        
        
        % Save the extracted string as a new text file in the new folder
%         newFilePath = fullfile(newFolderPath, strcat(fileName, '.txt'));
%         fid = fopen(newFilePath, 'w');
%         fprintf(fid, '%s', extractedString);
%         fclose(fid);
    end
end