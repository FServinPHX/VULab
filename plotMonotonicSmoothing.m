


function [smoothedData] = plotMonotonicSmoothing(data)
    % Function to smooth data so that it increases monotonically
    % and plot the original and smoothed data.
    
    % Ensure data is a column vector
    data = data(:);
    
    % Initialize smoothed data
    smoothedData = zeros(size(data));
    
    % Set the first value of the smoothed data
    smoothedData(1) = data(1);
    
    % Loop through data and ensure monotonicity
    for i = 2:length(data)
        smoothedData(i) = max(smoothedData(i-1), data(i));
    end
    
    % Plot original and smoothed data
    figure;
    plot(data, '-o', 'DisplayName', 'Original Data');
    hold on;
    plot(smoothedData, '-x', 'DisplayName', 'Smoothed Data');
    xlabel('Index');
    ylabel('Value');
    title('Monotonic Smoothing of 1D Data');
    legend;
    grid on;
    hold off;
end