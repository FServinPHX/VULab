function timeLabels = generateTimeLabels(initialTime, timeSpacing, data)
    % Check if timeSpacing is valid (60 seconds or below)
    if timeSpacing > 60
        error('Time spacing should be 60 seconds or below.');
    end
    
    % Convert initialTime to seconds
    initialTimeInSeconds = initialTime * 60;
    
    % Number of data points (rows in the data)
    numDataPoints = size(data, 2);
    
    % Initialize the cell array for time labels
    timeLabels = cell(numDataPoints, 1);
    
    for i = 1:numDataPoints
        % Calculate the current time in seconds
        currentTimeInSeconds = initialTimeInSeconds + (i - 1) * timeSpacing;
        
        % Convert current time back to minutes and seconds
        minutes = floor(currentTimeInSeconds / 60);
        seconds = mod(currentTimeInSeconds, 60);
        
        % Create the time label in 'MM:SS' format
        timeLabels{i} = sprintf('%02d:%02d', minutes, seconds);
    end
end