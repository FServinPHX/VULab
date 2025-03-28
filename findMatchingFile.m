function matchedFileName = findMatchingFile(degreeInput, experimentNumberInput, SyntheticFilesCSV)
    % Initialize the output
    matchedFileName = '';
    
    % Regular expression patterns for extracting degree and experiment number
    degreePattern = '(\d+)degree';
    experimentPattern = 'Experiment\s*(\d+)';
    
    % Iterate over each file name in the cell array
    for i = 1:length(SyntheticFilesCSV)
        fileName = SyntheticFilesCSV{i};
        
        % Extract degree using regular expression
        degreeMatch = regexp(fileName, degreePattern, 'tokens');
        degree = str2double(degreeMatch{1}{1});
        
        % Extract experiment number using regular expression
        experimentMatch = regexp(fileName, experimentPattern, 'tokens');
        experimentNumber = str2double(experimentMatch{1}{1});
        
        % Check if both degree and experiment number match the inputs
        if degree == degreeInput && experimentNumber == experimentNumberInput
            matchedFileName = fileName;
            return; % Return immediately once match is found
        end
    end
    
    % If no match is found, inform the user
    if isempty(matchedFileName)
        warning('No matching file found for degree %d and experiment number %d.', degreeInput, experimentNumberInput);
    end
end