

function [PHI_THETA_LABEL] =  fn_ThetaPhi_ptcld_TargetRelation(pointCloud, target1, target2)
    % Input:
    % pointCloud - Nx3 matrix of points (x, y, z)
    % target1, target2 - 1x3 vector representing target points (x, y, z)

    numPoints = size(pointCloud, 1);
    labels = zeros(numPoints, 1);
    angles = zeros(numPoints, 2); % First column for phi, second for theta

    for i = 1:numPoints
        point = pointCloud(i, :);

        % Calculate distances to the two target points
        dist1 = norm(point - target1);
        dist2 = norm(point - target2);

        % Assign labels based on closest target point
        if dist1 < dist2
            labels(i) = 1;
            closestTarget = target1;
        else
            labels(i) = 2;
            closestTarget = target2;
        end

        % Calculate phi (azimuthal angle) and theta (polar angle)
        [azimuth, elevation, r] = cart2sph(closestTarget(1) - point(1), closestTarget(2) - point(2), closestTarget(3) - point(3));

        angles(i, 1) = rad2deg(azimuth);
        angles(i, 2) = rad2deg(elevation);
    end


    PHI_THETA_LABEL = [angles, labels];


    PLOTFIG = "FALSE";
    if PLOTFIG == "TRUE"
        % Plotting the results
        figure;
        hold on;
        grid on;
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
    
        for i = 1:numPoints
            point = pointCloud(i, :);
            plot3(point(1) , point(2), point(3) , 'k.', MarkerSize= 10);
            if labels(i) == 1
                % Connect to target 1
                plot3([point(1) target1(1)], [point(2) target1(2)], [point(3) target1(3)], 'b');
            else
                % Connect to target 2
                plot3([point(1) target2(1)], [point(2) target2(2)], [point(3) target2(3)], 'r');
            end
        end
        
        % Optionally add target points to the plot
        plot3(target1(1), target1(2), target1(3), 'ko');
        plot3(target2(1), target2(2), target2(3), 'ko');
    
        hold off;
        axis equal 
    end 
end
