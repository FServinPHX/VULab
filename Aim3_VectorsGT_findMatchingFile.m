



function [best_filename, best_file_index, experimentNumber] = Aim3_VectorsGT_findMatchingFile(GroundTruthFileCSV, SyntheticFilesCSV)
    % Function to match filenames based on experiment number
    % Inputs:
    % - GroundTruthFilesCSV: A filename string in the specified format
    % - SyntheticFilesCSV: A string matrix containing multiple filenames
    % Outputs:
    % - best_filename: The best matching filename from SyntheticFilesCSV
    % - best_file_index: Index of the matching filename in SyntheticFilesCSV

    % Extract experiment number from GroundTruthFilesCSV
    experimentNumber = extractExperimentNumber(GroundTruthFileCSV);

    % Initialize matching index
    best_file_index = [];

    % Iterate over filenames in SyntheticFilesCSV to find a match
    for i = 1:length(SyntheticFilesCSV)
        current_filename = SyntheticFilesCSV{i};
        
        % Extract experiment number from current filename
        current_experiment_number = extractExperimentNumber(current_filename);

        % Check for matching experiment number
        if current_experiment_number == experimentNumber
            best_file_index = i;
            break; % Break the loop if a match is found
        end
    end

    % Handle case where there is no match
    if isempty(best_file_index)
        error('No matching filename found.');
    else
        best_filename = SyntheticFilesCSV{best_file_index};
    end
end

function experimentNumber = extractExperimentNumber(filename)
    % Extracts 'experiment number' from the filename
    experimentPattern = 'Experiment\s*(\d+)';
    tokens = regexp(filename, experimentPattern, 'tokens');
    
    if ~isempty(tokens) && ~isempty(tokens{1})
        experimentNumber = str2double(tokens{1}{1});
    else
        error('Experiment number not found in filename.');
    end
end