




function sortedStruct = aim3_SPIEfn_sortFilesByExperiment(structArray)
    % Extract experiment numbers and sort the struct
    
    % Initialize array to store experiment numbers
    numFiles = length(structArray);
    experimentNumbers = zeros(numFiles, 1);
    
    % Extract the 'Experiment' number from each filename
    for i = 1:numFiles
        fileName = structArray(i).name;
        exprMatch = regexp(fileName, 'Experiment\s*(\d+)', 'tokens');
        if ~isempty(exprMatch)
            experimentNumbers(i) = str2double(exprMatch{1}{1});
        else
            error('Invalid filename format for file: %s', fileName);
        end
    end

    % Sort the experiment numbers and get sort index
    [~, sortIndex] = sort(experimentNumbers);
    
    % Reorganize the struct based on the sorted index
    sortedStruct = structArray(sortIndex);

    % Save the reorganized structure
    save('sortedStruct.mat', 'sortedStruct');
end

