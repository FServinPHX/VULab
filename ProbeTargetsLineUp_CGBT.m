




function [ midpoints ] = ProbeTargetsLineUp_CGBT( e1, e2 )
    % This function calculates midpoints between the closest points of two given 3D lines.
    % Each input (e1, e2) is expected to be a matrix where each row represents a point in 3D space (x, y, z).
    % The function first calculates the distances between each point on the first line (line1) 
    % and all points on the second line (line2). It then identifies pairs of points that are 
    % closest to each other and computes the midpoints of these pairs.
    
    midpoints = []; % Initialize an empty array to store midpoints

    for start = 1:2 % Loop to switch between two starting lines
        switch start
            case 1
                line1 = e1; % Assign e1 as line1
                line2 = e2; % Assign e2 as line2
            case 2
                line1 = e2; % Assign e2 as line1
                line2 = e1; % Assign e1 as line2
        end
        
        % Extract coordinates of both lines for easier manipulation
        x1 = line1(:,1); y1 = line1(:,2); z1 = line1(:,3);
        x2 = line2(:,1); y2 = line2(:,2); z2 = line2(:,3);

        distances = []; % List to store distances and their indices
        
        % Calculate distances between each point in line1 and all points in line2
        for i = 1:length(x1)
            [dist, Index] = min(sqrt((x1(i) - x2).^2 + (y1(i) - y2).^2 + (z1(i) - z2).^2));
            distances = [distances; dist, i, Index]; % Store distance and corresponding indices
        end

        % Sort distances to find the closest points
        [distancesort, I] = sort(distances(:,1));
        Is = distances(:,2); % Indices of points on line1
        Indexes = distances(:,3); % Indices of corresponding closest points on line2
        distancesNew = [distancesort, Indexes(I), Is(I)]; % Create a new sorted index list

        % Calculate midpoints for selected pairs of closest points
        arr = 1:5:200; % Pre-defined spacing to select points
        for k = 1:10
            j = arr(k);
            I1 = distancesNew(j,2); % Index from line1
            I2 = distancesNew(j,3); % Index from line2
            A = [x1(I1), y1(I1), z1(I1)]; % Point on line1
            B = [x2(I2), y2(I2), z2(I2)]; % Closest point on line2
            n = 3; % Number of segments
            X = [A; B]; % Create segment between points A and B
            t = linspace(0, 1, n+1); % Generate parameter t for interpolation
            points = interp1([0 1], X, t); % Interpolate to find midpoints
            midpoints = [midpoints; points]; % Append interpolated points to midpoints list
        end
    end
    
    % Optional visualization part (commented out)
    % scatter3(x1, y1, z1, 'g', 'filled');
    % hold on;
    % scatter3(x2, y2, z2, 'b', 'filled');
    % scatter3(midpoints(:,1), midpoints(:,2), midpoints(:,3), 'r', 'filled');
    % axis equal;
    % colormap jet;
    % colorbar;
end