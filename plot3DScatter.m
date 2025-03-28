function plot3DScatter(points, markerSize, color)
    % plot3DScatter - Plots a 3D scatter plot of points with specified marker size and color.
    % 
    % Syntax: plot3DScatter(points, markerSize, color)
    %
    % Inputs:
    %    points - An Nx3 matrix where each row represents a 3D point [x, y, z].
    %    markerSize - A scalar representing the size of the markers in the plot.
    %    color - A 1x3 vector representing the RGB color of the markers (values between 0 and 1).
    %
    % Example: 
    %    points = rand(100, 3); % 100 random 3D points
    %    plot3DScatter(points, 8, [1, 0, 0]); % Red markers

    % Check if the input points are provided in the correct format
    if size(points, 2) ~= 3
        error('Input points must be an Nx3 matrix where N is the number of points.');
    end

    % Check if the color is a valid RGB vector
    if numel(color) ~= 3 || any(color < 0) || any(color > 1)
        error('Color must be a 1x3 vector with values between 0 and 1.');
    end

    % Create the 3D scatter plot
    scatter3(points(:, 1), points(:, 2), points(:, 3), markerSize, 'filled', 'MarkerFaceColor', color);
    
    % Set labels for axes
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Z-axis');
    
    % Set title
    title('3D Scatter Plot');
    
    % Enable grid for better visualization
    grid on;
end