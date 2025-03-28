function maxValue = maxOfLowest20Percent(x)
    % Ensure x is a vector
    if ~isvector(x)
        error('Input must be a vector.');
    end
    
    % Sort the dataset in ascending order
    sorted_x = sort(x);
    
    % Find the number of elements corresponding to the lowest 20%
    n = length(x);
    num_lowest_20_percent = round(n * 0.20);
    
    % Handle case where the dataset might have very few elements
    if num_lowest_20_percent < 1
        error('Dataset is too small to extract 20%% of values.');
    end
    
    % Extract the lowest 20% of values
    lowest_20_percent = sorted_x(1:num_lowest_20_percent);
    
    % Find the maximum value among the lowest 20% of values
    maxValue = max(lowest_20_percent);
end