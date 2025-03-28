function maxValue = maxOfLowestXPercent(x, X)
    % Ensure x is a vector
    if ~isvector(x)
        error('Input data must be a vector.');
    end
    
    % Ensure X is a valid percentage
    if X <= 0 || X > 100
        error('Percentage X must be in the range (0, 100].');
    end

    % Sort the dataset in ascending order
    sorted_x = sort(x);

    % Find the number of elements corresponding to the lowest X%
    n = length(x);
    num_lowest_X_percent = round(n * (X / 100));

    % Handle case where the dataset might have very few elements
    if num_lowest_X_percent < 1
        error('Dataset is too small to extract the requested percentage of values.');
    end

    % Extract the lowest X% of values
    lowest_X_percent = sorted_x(1:num_lowest_X_percent);

    % Find the maximum value among the lowest X% of values
    maxValue = max(lowest_X_percent);
end