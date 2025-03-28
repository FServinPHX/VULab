



function [markerSizes] =  scaledScatterData( intensity, minSize, maxSize)
    % Ensure the input vectors are of the same length
    % if length(x) ~= length(y) || length(x) ~= length(intensity)
    %     error('Input vectors x, y, and intensity must have the same length.');
    % end
    % 
    % Ensure minSize and maxSize are valid
    if minSize <= 0 || maxSize <= 0 || minSize >= maxSize
        error('minSize and maxSize must be positive numbers, and minSize < maxSize.');
    end

    % Normalize the intensity values to the range [0, 1]
    normIntensity = (intensity - min(intensity)) / (max(intensity) - min(intensity));
    
    % Scale the normalized intensity values to the desired marker size range
    markerSizes = minSize + normIntensity * (maxSize - minSize);
    
    % % Create the scatter plot with scaled marker sizes
    % scatter(x, y, markerSizes, 'filled');
    % 
    % % Add labels and title for clarity
    % xlabel('X-axis');
    % ylabel('Y-axis');
    % title('Scatter Plot with Intensity-Based Marker Sizes');
end