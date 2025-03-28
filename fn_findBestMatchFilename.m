







  function bestFilePath = fn_findBestMatchFilename(givenFilename, searchDir)
    % Check if givenFilename is a full path or just a filename
    [~, givenFilename, ext] = fileparts(givenFilename); 
    givenFilename = strcat(givenFilename, ext);  % Handle case with extension

    % Read all files in the specified directory
    files = dir(fullfile(searchDir, '*'));
    
    % Initialize variables to track the best match
    maxMatchCount = -1;
    bestMatchedFile = '';

    % Convert the given filename to a character count map
    givenFileCharMap = characterCountMap(givenFilename);

    % Iterate over all files to find the best match
    for i = 1:length(files)
        % Skip directories
        if files(i).isdir
            continue;
        end

        currentFilename = files(i).name;
        currentCharMap = characterCountMap(currentFilename);

        % Calculate match count
        currentMatchCount = sum(min(givenFileCharMap, currentCharMap));

        % Update best match if current is better
        if currentMatchCount > maxMatchCount
            maxMatchCount = currentMatchCount;
            bestMatchedFile = currentFilename;
        end
    end
    
    % If nothing was found, return empty
    if isempty(bestMatchedFile)
        warning('No matching file found.');
        bestFilePath = '';
        return;
    end

    % Compose the best file path
    bestFilePath = fullfile(searchDir, bestMatchedFile);
    
    % Print the best match file name
    fprintf('Best matched file: %s\n', bestMatchedFile);
end

function charMap = characterCountMap(filename)
    % Create a map of character counts for a given filename
    uniqueChars = unique(filename);
    charMap = zeros(size(uniqueChars));

    for ch = filename
        charMap(uniqueChars == ch) = charMap(uniqueChars == ch) + 1;
    end
end