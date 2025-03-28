


function [plotedLine] =  plot3DLineFromSpherical(phi, theta, center, length)
    % Convert angles from degrees to radians
    phi_rad = deg2rad(phi);
    theta_rad = deg2rad(theta);
    
    % Spherical to Cartesian conversion
    dx = length * sin(theta_rad) * cos(phi_rad);
    dy = length * sin(theta_rad) * sin(phi_rad);
    dz = length * cos(theta_rad);
    
    % Determine the end point of the line
    endPoint = center + [dx, dy, dz];
    
    % Plotting
    
    % plot3([center(1), endPoint(1)], [center(2), endPoint(2)], [center(3), endPoint(3)], 'LineWidth', 2);
    % grid on;
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % axis equal;
    % hold on;


    numPoints = 100;
    startPoint = center;

    % Generate linearly spaced vectors for each coordinate
    x = linspace(startPoint(1), endPoint(1), numPoints);
    y = linspace(startPoint(2), endPoint(2), numPoints);
    z = linspace(startPoint(3), endPoint(3), numPoints);

    plotedLine = [x',y',z']; 
end