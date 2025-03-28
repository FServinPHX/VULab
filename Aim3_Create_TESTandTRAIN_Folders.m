
clc
clear

% Define the main directory containing the relevant files
mainDirectory = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___15Minute'

% Create testing and training directories if they do not exist]
testingDirectory = fullfile(mainDirectory, 'testing');
trainingDirectory = fullfile(mainDirectory, 'training');
if ~exist(testingDirectory, 'dir')
    mkdir(testingDirectory);
end
if ~exist(trainingDirectory, 'dir')
    mkdir(trainingDirectory);
end

% Get list of all files in the main directory
files = dir(fullfile(mainDirectory, '*.csv')); % assuming the files are .mat, modify if needed

% Initialize containers for Experiment numbers and filenames
experimentFiles = containers.Map();
%
for i = 1:length(files)
    filename = files(i).name;
    
    % Parse Experiment number from the filename
    % The filename format will need to be known for precise parsing
    tokens = regexp(filename, '[-+]?\d*\.?\d+', 'match');
    
    if length(tokens) >= 2
        experimentNumber = tokens{2};
        
        if isKey(experimentFiles, experimentNumber)
            experimentFiles(experimentNumber) = [experimentFiles(experimentNumber), {filename}];
        else
            experimentFiles(experimentNumber) = {filename};
        end
    end
end
%
% Get unique experiment numbers
experimentNumbers = keys(experimentFiles);

% Randomly shuffle the experiment numbers
shuffledExperimentNumbers = experimentNumbers(randperm(length(experimentNumbers)));

% Split into two sets roughly equal in size
splitIndex = ceil(length(shuffledExperimentNumbers) / (1/.7));
trainingExperimentNumbers = shuffledExperimentNumbers(1:splitIndex);
testingExperimentNumbers = shuffledExperimentNumbers(splitIndex+1:end);

% Move files into the testing and training directories
moveFilesToDirectory(experimentFiles, trainingExperimentNumbers, mainDirectory, trainingDirectory);
moveFilesToDirectory(experimentFiles, testingExperimentNumbers, mainDirectory, testingDirectory);

function moveFilesToDirectory(experimentFiles, experimentNumbers, mainDirectory, targetDirectory)
    for j = 1:length(experimentNumbers)
        experimentNumber = experimentNumbers{j};
        filenames = experimentFiles(experimentNumber);
        
        for k = 1:length(filenames)
            filename = filenames{k};
            movefile(fullfile(mainDirectory, filename), fullfile(targetDirectory, filename));
        end
    end
end


