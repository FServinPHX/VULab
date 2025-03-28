%%
%RCOESSING AIM3 GRADIENT FIELD
clear
close all

% Specify the folder containing the point cloud files
folder = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2';

% Get a list of all files in the folder
files = dir(fullfile(folder, '*.csv')); % Change the file extension as per your file format

% Create an empty table to store the PCA information and file information
pcaTable = table();



% Perform PCA analysis on each file
for i = 1: length(files)
    
    
    % Read the point cloud data from the file
    filePath = fullfile(folder, files(i).name);
    pointCloudData = load(filePath);
    
    %[1:3, 7:10];
    
    pointCloud = pointCloudData(2:end, (13:15) );
    scatter3( pointCloud(:,1), pointCloud(:,2), pointCloud(:,3), 10,...
                 pointCloud(:,3), 'filled');
    colormap(jet);
    title( join(["Ablation Evolution", num2str(i) ]), 'Fontsize', 14 )         
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal 
    
    
    % Perform PCA analysis on the point cloud data
    [coeff, score, explained] = pca( pointCloud );   
    coeff_RSHP = reshape( coeff, 1, 9); 
    center = mean(pointCloud); 

    [ HighestX1, HighestX2, LowestX1, LowestX2, HighestY1, HighestY2, LowestY1,...
    LowestY2, HighestZ1, HighestZ2, LowestZ1, LowestZ2  ]  = AblationCloudFingerprint( pointCloud, 30);
        
    
    % Store the PCA information and file information in the table
    
    True_Explained = explained';
    fileName = string(filePath) ;
    pcaTable = [pcaTable; table(coeff_RSHP,   True_Explained,  center,...
                HighestX1, HighestX2, LowestX1, LowestX2, HighestY1, HighestY2, LowestY1,...
                LowestY2, HighestZ1, HighestZ2, LowestZ1, LowestZ2...
                ,fileName  ) ];
     hold off       
     pause(.1)
end

%
% Write the table to a specific directory as a CSV file
outputFolder = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2\Pointcloud_Information';
outputFile = fullfile(outputFolder, 'pca_information_25pt.csv');
writetable(pcaTable, outputFile);



%%


clear

% Specify the folder containing the point cloud files
folder = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors';
% Get a list of all files in the folder
files = dir(fullfile(folder, '*.csv')); % Change the file extension as per your file format

% Perform PCA analysis on each file
% Read the point cloud data from the file
filePath = "D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors\Pointcloud_Information\pca_information.csv";
pointCloudData = readtable(filePath);
% Extract the first 9 columns as a matrix
ImportedCoefficents = table2array( pointCloudData(:, 1:9) );
% Extract the 10th column as a separate matrix
ImportedVariances = table2array(  pointCloudData(:, 10)  );


AllIndexes = []; 
for i = 1:1 % length(files)

    % Read the point cloud data from the file
    Compared_File = fullfile(folder, files(i).name);
    TargetpointCloudData = load(Compared_File);
    TargetPointCloud = TargetpointCloudData(2:end, 1:3); 
    % PCA Analysis
    [coeff, score, explained] = pca( TargetPointCloud );
    explainedVariances = sum(explained);
    coeff_RSHP = reshape( coeff, 1, 9); 


    %
    %Perform the Analysis
    CoefficentsSum =  (abs( ImportedCoefficents - coeff_RSHP)) ;
    AllCoefficents = sum(  CoefficentsSum, 2).^2  ; 
    AllVariances = abs(ImportedVariances  -explainedVariances).^2; 
    %
    % Find the index of the smallest value
    BestFitData = sqrt( AllVariances + AllCoefficents);
    [~, index] = min(BestFitData);
    
    
    AllIndexes = [AllIndexes, index];
end



%%




% Create 10 3D point clouds
numPointClouds = 4;
pointClouds = cell(numPointClouds, 1);

for i = 1:numPointClouds
    % Generate random 3D points
    numPoints = 2600;
    points = rand(numPoints, 3);

    % Store the point cloud in a cell array
    pointClouds{i} = points;
end

% Perform PCA analysis on all the point clouds
coefficients = cell(numPointClouds, 1);
scores = cell(numPointClouds, 1);
explainedVariances = zeros(numPointClouds, 1);

for i = 1:numPointClouds
    % Perform PCA on each point cloud
    [coeff, score, explained] = pca(pointClouds{i});
    
    % Store the PCA analysis results
    coefficients{i} = coeff;
    scores{i} = score;
    explainedVariances(i) = sum(explained);
end

% Find the best pair for each point cloud based on PCA analysis
bestPairs = zeros(numPointClouds, 1);
for i = 1:numPointClouds
    % Compute the similarity between the current point cloud and all others
    similarityScores = zeros(numPointClouds, 1);
    
    for j = 1:numPointClouds
        % Compute the similarity between point clouds using explained variance
        similarityScores(j) = abs(explainedVariances(i) - explainedVariances(j));
    end
    
    % Find the index of the point cloud with maximum similarity
    [~, bestIndex] = max(similarityScores);
    bestPairs(i) = bestIndex;
end

% Plot all the point cloud pairs in a figure with subfigures
figure();

for i = 1:9
   
    if i > numPointClouds/2
        k = 2;
        ki = i -  numPointClouds/2;
    else 
        k = 1;
        ki = i; 
    end 
    
    points1 = pointClouds{i};
    points2 = pointClouds{bestPairs(i)};
    
    nsq = floor( sqrt(numPointClouds) );
    subplot( ceil( numPointClouds/nsq )  , floor( numPointClouds/nsq),  i);
    scatter3(points1(:, 1), points1(:, 2), points1(:, 3), 'filled', 'MarkerFaceColor', 'blue');
    hold on;
    scatter3(points2(:, 1), points2(:, 2), points2(:, 3), 'filled', 'MarkerFaceColor', 'red');
    
    title(['Point Cloud ', num2str(i), ' and its Best Pair', num2str( bestPairs(i) ) ]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    legend('Point Cloud', 'Best Pair');
end


%%

clear
close all




% Specify the file path
filePath = "D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v3\ PsiTheta1_ 0 - 0     PsiTheta2_ 0 - 0 AblPoints_a_Vectors.csv" ;

% Import the data from the file
AllData =  csvread(filePath);
data = csvread(filePath);
data = data(2:end, :);
% Define the preset point cloud
presetPointCloud = data(:, 31:33); % Replace with your own point cloud data
% Define the number of intervals
numIntervals = 52;
% Define the number of points in the point cloud
numPoints = size(data, 1);

% Reshape the vector data into a 3D matrix
vectorData = reshape(  data(: , :), length(data),   6, []);

% Displace the point cloud using the vector information
displacedPointCloud = presetPointCloud; % Initialize with the preset point cloud
threshold = .20; % Define a threshold for displacement

% Plot the initial point cloud
figure;
scatter3(presetPointCloud(:, 1), presetPointCloud(:, 2), presetPointCloud(:, 3), 'filled', 'MarkerFaceColor', 'blue');
title('Displacement Iteration: 0');
xlabel('X');
ylabel('Y');
zlabel('Z');
drawnow;
axis equal 


%
% Displace the point cloud for each interval and plot the results
KeepTrack = [data(:, 1:3)];
MinDist = []; 
for interval = 5:  numIntervals
   
    figure(2)
    intervalVectorData = vectorData(:, :, interval);

    
    MatrixPairSorted= []; 
    % Displace each point in the point cloud
    for pointIndex = 1:numPoints
        %
        point = presetPointCloud(pointIndex, :);
        
        
        %FIND THE MINIMUM VECTOR
        vectorPoint = intervalVectorData( :,  1:3);
        % Find the closest vector to each point in the point cloud
        distances = sqrt((point(1) - vectorPoint(:,1)).^2 + ...
                    (point(2) - vectorPoint(:,2)).^2  + (point(3) - vectorPoint(:,3)).^2) ;
        % Find the index of the nearest point with unique match
        [minimumDistance, min_index] = min(distances);        
        closestVectorIndex = min_index;
        
        
        vector = intervalVectorData(closestVectorIndex, 4:6);
        %if norm(vector) > threshold
        displacedPointCloud(pointIndex, :) = point + -1*vector;
        %end

        MatrixPairSorted = [ MatrixPairSorted; pointIndex, min_index ];
        MinDist = [MinDist; pointIndex min_index, minimumDistance, vector,  norm(vector)];
    end
    
    
    
    
%     OGPointCloud = data(:, 1:3); % Replace with your own point cloud data
%     plot3(OGPointCloud(:, 1), OGPointCloud(:, 2), OGPointCloud(:, 3),...
%     '.', 'MarkerFaceColor', 'black');
%     hold on  
    
    
    
%     A = presetPointCloud;
%     B = vectorPoint;
%     scatter3(A(:,1), A(:,2), A(:,3), 'r', 'filled');
%     hold on;
%     scatter3(B(:,1), B(:,2), B(:,3), 'b', 'filled');
%     title('Original Point Clouds A and B');
% 
%     % Draw lines between the point pairs
%     for i = 1:length(MatrixPairSorted)
%         line([A(MatrixPairSorted(i,1), 1)  B(MatrixPairSorted(i,2), 1)], ...
%              [A(MatrixPairSorted(i,1), 2)  B(MatrixPairSorted(i,2), 2)], ...
%              [A(MatrixPairSorted(i,1), 3)  B(MatrixPairSorted(i,2), 3)], 'Color', 'g');
%     end
    
    
    
    % Plot the displaced point cloud for the interval
    plot3(displacedPointCloud(:, 1), displacedPointCloud(:, 2), displacedPointCloud(:, 3),...
        '.', 'MarkerFaceColor', 'black');
    hold on
    quiver3( intervalVectorData (:,1) , intervalVectorData (:,2), intervalVectorData (:,3),...
             intervalVectorData (:,4) , intervalVectorData (:,5), intervalVectorData (:,6),...
             'color', 'red');
    
         
%     A = presetPointCloud;
%     B = displacedPointCloud;
%     % Draw lines between the point pairs
%     for i = 1:length(MatrixPairSorted)
%         line([A(i, 1)  B(i, 1)], ...
%              [A(i, 2)  B(i, 2)], ...
%              [A(i, 3)  B(i, 3)], 'Color', 'g');
%     end         
       

    %title(['Displacement Iteration: ', num2str(interval)]);
    
    idx = 5 : 1 : (15*4)+1 ; 
    minutes =  floor( (idx(interval)*15-15)/60) ; 
    seconds  = mod( (idx(interval)*15-15), 60)    ;
    title( join(["Ablation Evolution",...
    newline,  num2str(minutes),  "m","  ", num2str(seconds), "s" ]), 'Fontsize', 14 )     
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal;
    hold off
    

    pause(1)
    
    Vectors = intervalVectorData(:, 4:6);
    VPS  = Vectors( MatrixPairSorted(:,2), :);
    KeepTrack = [ KeepTrack, VPS, displacedPointCloud]; 
    %presetPointCloud = displacedPointCloud;
end















