
createAndExportMesh('C:\Users\servinf\Documents\7.0 For Labmates\For Bowen');

%%

clc
clear





% Load and Prepare Data
All_ProbeDataFile = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
ProbeData = readtable(All_ProbeDataFile);
All_ProbeData = ProbeData(:, :);
arrayData = [];
variableNames = All_ProbeData.Properties.VariableNames;

% Convert and concatenate each column separately
for i = 1:length(variableNames)
    currentColumn = All_ProbeData.(variableNames{i});
    if iscell(currentColumn)
        currentColumn = string(currentColumn);
    end
    arrayData = [arrayData, currentColumn];
end
AllNum_ProbeData = str2double(arrayData(:, 2:end));
BoundaryPointsFile = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxGeomSymmetricModel_Case1.csv";
BoundaryPointsMatrix = table2array(readtable(BoundaryPointsFile));

AllBoundaryPts = [];
numpoints = 2600;  % Number of points for upsampling

% Main Unified Processing Loop
for CurrentRun = 1:1  % or adjust as per your actual requirements
    file_path = arrayData(CurrentRun, 1);
    [ProbePointExport, ~, ~] = A3_FindPlotPoints(file_path);
    
    theta1 = AllNum_ProbeData(CurrentRun, 1);
    psi1 = AllNum_ProbeData(CurrentRun, 2);
    centralPoint1 = AllNum_ProbeData(CurrentRun, 3:5);
    
    % Transformation and Visualisation Loop
    for i = 1:4:59  % Adjust as needed, e.g., minutes or other criteria
        % Extract plot points
        X = BoundaryPointsMatrix(2:end, ((i-1)*3 + 7));
        Y = BoundaryPointsMatrix(2:end, ((i-1)*3 + 8));
        Z = BoundaryPointsMatrix(2:end, ((i-1)*3 + 9));
        pointCloud = [X, Y, Z];

        % Find the indices of points that are not (0, 0, 0)
        non_zero_indices = any(pointCloud, 2);  % any(points, 2) checks if any element in the row is non-zero
        
        % Filter out the (0, 0, 0) points
        filtered_points = pointCloud(non_zero_indices, :);

        
        % Transform and Smooth Points
        transformed_Ablation1 = transformPointCloud_Aim3(pointCloud, theta1, psi1, centralPoint1);
        scale = 0.95 + 0.4 * (i / 61);
        [~, pointsExport] = A3_SmoothAblationComplete(transformed_Ablation1, ProbePointExport, 3, 5, scale);
        
        % Upsample the point cloud if necessary
        NewPoints = pointsExport;
        if size(NewPoints, 1) < numpoints
            [NewPoints] = UpsampledAblationSpec(NewPoints, numpoints);
        elseif size(NewPoints, 1) > numpoints
            NewPoints = NewPoints(1:numpoints, :);
        end
        
        pointCloud = [ filtered_points];

        % Convert 15-second interval to minutes and seconds
        total_seconds = ( (i-1)* 15 + 60);          % Calculate total seconds
        minutes = floor(total_seconds / 60); % Calculate minutes
        seconds = mod(total_seconds, 60);    % Calculate remaining seconds

        
        % Visualization of the ablation volume
        convHull = convhull(pointCloud);
        trisurf(convHull, pointCloud(:, 1), pointCloud(:, 2), pointCloud(:, 3));
        hold on
        plot3(  pointCloud(:, 1), pointCloud(:, 2), pointCloud(:, 3), 'MarkerSize',  20);
        title(sprintf('Ablation Volume at %02d:%02d minutes', minutes, seconds));
        xlabel('X-axis'); ylabel('Y-axis'); zlabel('Z-axis');
        axis equal; grid on;
        pause(1);  % Pause allows observation of each frame
        
        % Export the ablation volume as OBJ
        objFileName = sprintf('AblationVolume_%02d_%02d.obj', minutes, seconds);
        objExportPath = fullfile('C:\Users\servinf\Documents\7.0 For Labmates\For Bowen', objFileName);
        trimesh2obj(objExportPath, convHull, pointCloud);

        pause(3)   
    end
end




