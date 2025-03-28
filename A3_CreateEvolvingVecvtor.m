

function [AllVectors_exprt, ProbePointExport] =  A3_CreateEvolvingVecvtor(points, points2,  ...
                                                      file_path)


    % 
    % i = 50;
    % %
    % num.AllPts = NewSampledData{i - StartAdj, 1} ; 
    % %
    % X1 = num.AllPts(:, 1 ); 
    % Y1 = num.AllPts(:, 2 ); 
    % Z1 = num.AllPts(:, 3 ); 
    % %
    % j = i- StartAdj +1;
    % num.AllPts2 = NewSampledData{j, 1} ; 
    % X2 = num.AllPts2( :, 1 ); 
    % Y2 = num.AllPts2( :, 2 ); 
    % Z2 = num.AllPts2( :, 3 );
    % pointcloud_A = [X1, Y1, Z1];
    % pointcloud_B = [X2, Y2, Z2];
%



    MphName = file_path;


    input_str = MphName;
    experiment_num = extract_experiment_number(input_str);
    disp(['The experiment number is: ', num2str(experiment_num)]);
    ProbeFilePath = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
    [filepath2,name2,ext] = fileparts(ProbeFilePath);    
    OGdata = readtable(ProbeFilePath);
    AntnaNames = ( OGdata(:, 1) );
    data2 = table2array(OGdata(:, 2:end));
            % Example table creation with a single column of names
            T = AntnaNames;
            % Assuming all names are stored in the first column, convert to string matrix
            if istable(T) && width(T) >= 1
                % Preallocate string array based on the number of rows in the table
                stringMatrix = strings(height(T), 1);
                % Iterate through the table and fill the string matrix
                for i = 1:height(T)
                    % Assign each name to the string array
                    stringMatrix(i) = string(T.Name(i));
                end
            end
            AntnaNames = stringMatrix;
    %
        experiment_num_Ant_All = [];
        for i = 1: size(AntnaNames,1)
            experiment_num_Ant = extract_experiment_number(AntnaNames(i));
            experiment_num_Ant_All = [experiment_num_Ant_All ,experiment_num_Ant];
        end
    % Find the indices of the specific number
    [rowIndices, colIndices] = find(experiment_num_Ant_All == experiment_num);
    % Combine row and column indices to have pairs of indices
    indices = [colIndices];
    %
    %
                        disp( join(['The FOUND experiment number is: ' , ...
                                        num2str( experiment_num_Ant_All(indices) ) ]) )
    %startPoint = 3;
    disp("       DATA   LOADING   FINISHED       "  )



    lineSize = 50;
    % Given parameters
        theta = data2( indices(1) , 1); % degrees
        phi   = data2(indices(1), 2); % degrees
        center = [data2(indices(1), 3) , data2(indices(1), 4) , data2(indices(1), 5) ]; % Starting point
        lengthLine = lineSize; % Length of the line   
        % Plotting the 3D line
    [plotedLine1] =  plot3DLineFromSpherical(phi, theta, center, lengthLine);
            % plot3( plotedLine1(:,1), plotedLine1(:,2), plotedLine1(:,3), ...
            %         'k.', 'MarkerSize', 10
        theta2 = data2(indices(1), 6); % degrees
        phi2   = data2(indices(1), 7); % degrees
        center2 = [data2(indices(1), 8) , data2(indices(1), 9) , data2(indices(1), 10) ]; % Starting point
        lengthLine = lineSize; % Length of the line   
        % Plotting the 3D line
    [plotedLine2] =plot3DLineFromSpherical(phi2, theta2, center2, lengthLine);
            % plot3( plotedLine2(:,1), plotedLine2(:,2), plotedLine2(:,3), ...
            %         'k.', 'MarkerSize', 10 )




A = [plotedLine1; plotedLine2] ;
% Step 1: Find the maximum and minimum z values in B
maxZ = max(points(:,3))* .95 ;
minZ = min(points(:,3));
% Step 2: Remove points in A that have z values outside the range [minZ, maxZ]
ProbePts_filtered = A(A(:,3) <= maxZ & A(:,3) >= minZ, :);
% Step 3: Plot the results
num_points = length(points);
centerType = "PROBE";      
%distMat = [1; repmat(.1, 29, 1 ) ] ;
distMat = linspace( .25, 10, 50) ;
AllVectors_exprt = [];
%
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
        

 

        C = zeros(30, 3); % Initialize matrix for projected points C
        magnitude = norm(vector_to_center);
        for j = 1:30
            %C(i, :) = pointA + (i*distMat(i)).*vector;
            C(j, :) = points(i,:) + (distMat(j)).* vector_to_center/magnitude ;
        end
        


        % Step 4: Find the 5 closest points in B to pointA
        distances = vecnorm(points2 - points(i,:), 2, 2); % Euclidean distances to pointA
        [~, idx] = mink(distances, 5); % Indices of the 5 closest points
        closestBPoints = points2(idx, :); % Extract the 5 closest points
        midB = mean(closestBPoints); % Compute midB
        
        % Step 5: Find the point in C closest to midB
        distancesC = vecnorm(C - midB, 2, 2); % Euclidean distances to midB
        [~, idxC] = min(distancesC); % Index of the closest point in C
        foundC = C(idxC, :); % Extract the closest point in C
        
        plot3( foundC(1), foundC(2),  foundC(3), 'g.','MarkerSize', 10)
        hold on
        
        % Step 6: Compute the vector between pointA and foundC
        vectorAtoFoundC = foundC - points(i,:);


        % Adjust the current point based on comparison with average distance
        % SubtractVector = vector_to_center * (dist_to_center - avg_neighbor_dist) / dist_to_center;
        % AddVector = vector_to_center * (avg_neighbor_dist - dist_to_center) / dist_to_center;
%
        % if dist_to_center > avg_neighbor_dist
        %     points(i,:) = points(i,:) -  SubtractVector.* scale;
        % elseif dist_to_center < avg_neighbor_dist
        %     points(i,:) = points(i,:) +  AddVector .* scale;
        % end
    AllVectors_exprt = [AllVectors_exprt; vectorAtoFoundC.*5];

end

ProbePointExport = A;


    AllVectorMag =[]; 
    for k = 1:length(AllVectors_exprt)
        AllVectorMag =[AllVectorMag, norm(AllVectors_exprt(i,:)) ] ;
    end 


quiver3(points(:, 1), points(:, 2), points(:, 3), ...
        AllVectors_exprt(:, 1), AllVectors_exprt(:, 2), AllVectors_exprt(:, 3), 0);
hold on 
plot3( points(:, 1), points(:, 2), points(:, 3), '.k', 'MarkerSize', 10)
plot3( points2(:, 1), points2(:, 2), points2(:, 3), '.r', 'MarkerSize', 10)
axis equal


pointsExport = points;

% end 




