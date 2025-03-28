



% Example usage
% Generate two hypothetical lines
% t = linspace(0, 10, 100)';
% line1 = [t, 2*t, 3*t];
% line2 = [t, 2*t + 2, 3*t + 2];
% [angleDegrees, angleRadians, avgDistance] = analyze3DLines(line1, line2);



function [angleDegrees, angleRadians, avgDistance] = Aim3_fn_analyze3DLines(line1, line2)
    % analyze3DLines calculates the angle and average distance between two 3D lines
    % Input:
    %   line1 - Nx3 array representing a series of 3D points forming the first line
    %   line2 - Nx3 array representing a series of 3D points forming the second line
    % Output:
    %   angleDegrees - Angle between the two lines in degrees
    %   angleRadians - Angle between the two lines in radians
    %   avgDistance - Average distance between the two lines

    % Calculate direction vectors of the lines
    dir1 = line1(end,:) - line1(1,:);
    dir2 = line2(end,:) - line2(1,:);
    
    % Normalize the direction vectors
    dir1 = dir1 / norm(dir1);
    dir2 = dir2 / norm(dir2);
    
    % Calculate the angle between the two lines
    cosTheta = dot(dir1, dir2);
    angleRadians = acos(cosTheta);
    angleDegrees = rad2deg(angleRadians);
    
    % Calculate the perpendicular distance from each point on line1 to line2
    distances = zeros(size(line1, 1), 1);
    for i = 1:size(line1, 1)
        p1 = line1(i,:);
        
        % Find closest point on line2 to p1
        diff = line2 - p1;
        projections = dot(diff, repmat(dir2, size(line2, 1), 1), 2);
        closestPoints = line2 - projections * dir2;
        
        % Compute the distance from p1 to this closest point
        distances(i) = min(sqrt(sum((closestPoints - p1).^2, 2)));
    end
    
    % Average distance calculation
    avgDistance = mean(distances);
    
    plot_resutls = "FALSE";

    if  plot_resutls == "TRUE"
        % Plot the lines
        figure;
        plot3(line1(:,1), line1(:,2), line1(:,3), 'r', 'LineWidth', 2); hold on;
        plot3(line2(:,1), line2(:,2), line2(:,3), 'b', 'LineWidth', 2);
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        title('3D Line Analysis');
        legend({'Line 1', 'Line 2'}, 'Location', 'Best');
        grid on;
        axis equal;
    end 
    
    % Display results
    fprintf('Angle between lines: %.2f degrees / %.4f radians\n', angleDegrees, angleRadians);
    fprintf('Average distance between lines: %.4f units\n', avgDistance);
end




