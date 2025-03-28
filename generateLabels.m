function labels = generateLabels(initialTime, timeSpacing, data)
    % generateLabels generates a set of labels for a given dataset to be used with a boxplot.
    % initialTime - The starting time point (numerical value).
    % timeSpacing - The time increment between consecutive points (numerical value).
    % data - The dataset (numerical array) whose number of rows will determine the end time point.
    
    % Get the number of rows in the dataset
    numRows = size(data, 1);
    
    % Calculate the end time point
    endTime = initialTime + (numRows - 1) * timeSpacing;
    
    % Generate the labels
    labels = cell(numRows, 1);
    currentTime = initialTime;
    for i = 1:numRows
        labels{i} = num2str(currentTime);
        currentTime = currentTime + timeSpacing;
    end
end

% Example usage:
% data = rand(10, 1); % Example data with 10 rows
% initialTime = 0;
% timeSpacing = 5;
% labels = generateLabels(initialTime, timeSpacing, data)
% boxplot(data, 'Labels', labels) % Use the generated labels in a boxplot