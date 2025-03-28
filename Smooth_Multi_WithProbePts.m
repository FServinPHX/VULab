

function   [SmoothedAblationPoints, ExportProbePoints] = Smooth_Multi_WithProbePts( ...
    Probe1, Probe2,  timePoints, startPoint, numTimePoints)   





    %startPoint = 3;
    % disp("       DATA   LOADING   FINISHED       "  )



    AllBoundaryPoints = cell(numTimePoints, 1);
    NewSampledData = cell(numTimePoints, 1);
    StartAdj = startPoint - 1; 
    for i = startPoint: numTimePoints
    
    
        currentData = timePoints{i} ;
        Coords = currentData(:, 1:3);
        Coords( isnan(Coords(:,1)), : ) = [];
    
        % k = boundary(Coords,.75);
        % %BoundaryPoints.k = reshape(k,[],1);
        % k = reshape(k,[],1);
        % kSort = unique(k);
        % Coords = Coords(kSort,:);
        %
        %
        AllData1 =  Coords;
        NewPoints = AllData1;     


        AllBoundaryPoints{i} = NewPoints ;
    end 


  disp("       DATA   LOADING   FINISHED       "  )

%
figure()
for j = startPoint: numTimePoints 

    NewPoints = AllBoundaryPoints{j , 1}  ;

    
    
        
    num_iterations = 3; % Number of adjustment iterations
    num_neighbors = 5; % Number of closest neighbors to find
    original_points = NewPoints;
    ProbePts = [Probe1; Probe2];
    scale = 0.95 +  0.05*( j/40) ;
%



    % [ProbePts_filtered, pointsExport] =  A3_SmoothAblationComplete( ...
    %                     original_points, ProbePts, num_iterations, num_neighbors, scale);

    
    points = original_points;

        A = ProbePts;
        % Step 1: Find the maximum and minimum z values in B
        % maxZ = max(points(:,3))* .95 ;
        % minZ = min(points(:,3));
        max_vals = max(points);
        min_vals = min(points);

        % max_vals = max_vals.*0.99;
        % min_vals = min_vals.*1.01;
        max_vals = max_vals - [3,3,3];
        min_vals = min_vals + [3,3,3];
        % Check each target point
        inside_mask = all(A >= min_vals & A <= max_vals, 2);


        % Step 2: Remove points in A that have z values outside the range [minZ, maxZ]
        %ProbePts_filtered = A; 
        ProbePts_filtered = [ A(inside_mask,1), A(inside_mask,2), A(inside_mask,3) ];
        %ProbePts_filtered = A(A(:,3) <= maxZ & A(:,3) >= minZ, :);
        % Step 3: Plot the results
        
        
        num_points = length(points);
        centerType = "PROBE";
        for iter = 1:num_iterations
            for i = 1:num_points
                % Vector and distance from current point to center
        
                if centerType == "PROBE"
                    distances = pdist2(ProbePts_filtered, points(i,:), 'euclidean');
                    % Find the smallest distance and corresponding index
                    [minDistance, indexNearest] = min(distances);
                    % Get the nearest point
                    center = ProbePts_filtered(indexNearest, :);
                end 
        
                vector_to_center = points(i,:) - center;
                dist_to_center = norm(vector_to_center);
                
                % Calculate distances to all other points
                distances = sqrt(sum((points(i,:) - points).^2, 2));
                
                % Find the five closest neighbors (excluding self)
                [~, idx] = mink(distances, num_neighbors+1);
                idx = idx(idx~=i); % Remove self from neighbors
                
                % Average distance of neighbors from center
                avg_neighbor_dist = mean(sqrt(sum((points(idx,:) - center).^2, 2)));
                
        
        
                % Adjust the current point based on comparison with average distance
                SubtractVector = vector_to_center * (dist_to_center - avg_neighbor_dist) / dist_to_center;
                AddVector = vector_to_center * (avg_neighbor_dist - dist_to_center) / dist_to_center;
        
                if dist_to_center > avg_neighbor_dist
                    points(i,:) = points(i,:) -  SubtractVector.* scale;
                elseif dist_to_center < avg_neighbor_dist
                    points(i,:) = points(i,:) +  AddVector .* scale;
                end
            end
        end
        
        pointsExport = points;



% Plot the original and smoothed/adjusted point clouds
%figure;
    subplot(1,2,1);
    scatter3(original_points(:,1), original_points(:,2), ...
                original_points(:,3), '.', 'r');
    hold on 
    plot3( Probe1(:,1), Probe1(:,2), Probe1(:,3), ...
            'k.', 'MarkerSize', 10)  
    plot3( Probe2(:,1), Probe2(:,2), Probe2(:,3), ...
            'k.', 'MarkerSize', 10 )
    title('Original Point Cloud');
    axis equal;
    hold off


    subplot(1,2,2);
    scatter3(original_points(:,1), original_points(:,2), ...
                original_points(:,3), '.', 'r');    
    scatter3(pointsExport(:,1), pointsExport(:,2), pointsExport(:,3), '.', 'g');
    axis equal;
    hold on
        % Plot filtered points from A in blue
        plot3(ProbePts_filtered(:,1), ProbePts_filtered(:,2), ...
                    ProbePts_filtered(:,3),  'k.', 'MarkerSize', 10);

    idx = 1 : 1 : (15*4)+1 ; 
    minutes =  floor( (idx(j)*15-15)/60) ; 
    seconds  = mod( (idx(j)*15-15), 60)    ;
    PlotTitle = join([ 'Adjusted Point Cloud', newline, ...
                        num2str(minutes), 'm','  ', num2str(seconds), 's'  ]) ;
    title( PlotTitle )

    hold off

    pause(.25)
set(gcf,'position',[ 250, 100, 650, 650])    



SmoothedAblationPoints{j} = pointsExport;
ExportProbePoints{j} = [ProbePts_filtered ];
end 

hold off 


end 
