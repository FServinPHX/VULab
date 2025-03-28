clear
close all
clc
% Specify the folder containing the point cloud files
folder = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2';
% Get a list of all files in the folder
files = dir(fullfile(folder, '*.csv')); % Change the file extension as per your file format

% Perform PCA analysis on each file
% Read the point cloud data from the file
filePath = "D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2\Pointcloud_Information\pca_information_30pt.csv";
pointCloudData = readtable(filePath);
% Extract the first 9 columns as a matrix
ImportedCoefficents = table2array( pointCloudData(:, 1:9) );
% Extract the 10th column as a separate matrix
ImportedVariances = table2array(  pointCloudData(:, 10:12)  );
ImportedCenters = table2array(  pointCloudData(:, 13:15)  );


% ImportedHighestX1 =  table2array(  pointCloudData(:, 16:18)  );
% ImportedHighestX2 =  table2array(  pointCloudData(:, 19:21)  );
% ImportedLowestX1 =  table2array(  pointCloudData(:, 22:24)  );
% ImportedLowestX2 =  table2array(  pointCloudData(:, 25:27)  );
% ImportedHighestY1 =  table2array(  pointCloudData(:, 28:30)  );
% ImportedHighestY2 =  table2array(  pointCloudData(:, 31:33)  );
% ImportedLowestY1 =  table2array(  pointCloudData(:, 34:36)  );
% ImportedLowestY2 =  table2array(  pointCloudData(:, 37:39)  );
% ImportedHighestZ1 =  table2array(  pointCloudData(:, 40:42)  );
% ImportedHighestZ2 =  table2array(  pointCloudData(:, 43:45)  );
% ImportedLowestZ1 =  table2array(  pointCloudData(:, 46:48)  );
% ImportedLowestZ2 =  table2array(  pointCloudData(:, 49:51)  ); 


ImportedFingerPrints = table2array(  pointCloudData(:, 16:51)  );

%%
close all
iCreateVideo = "FALSE" ;  
Plot_Histogram = "FALSE";
find_correspond = "TRUE";
Plot_Correspondance = "TRUE"; 




N = 40;
AllAngles =[  repmat(0, N, 1) , linspace(0, 40, N)',   
              repmat(45, N, 1) , linspace(0, 40, N)', 
              repmat(90, N, 1) , linspace(0, 40, N)', 
              repmat(180, N, 1) , linspace(0, 40, N)', 
              repmat(225, N, 1) , linspace(0, 40, N)',  ]  ;
 % Generate a random number between 2 and 13
 


Average_Distances = [ ];
STD_Distances = [ ];
All_BestFitCriteria = [];

if iCreateVideo == "TRUE"
    videoWriter = VideoWriter('AblationCloudCorrespondance.mp4',  'MPEG-4'); %// initialize the VideoWriter object
    videoWriter.FrameRate = .5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end 



for ki = 1:1
    
     
random_number1 = randi([2, (length(AllAngles)/2 -1) ]);  
random_number2 = randi([length(AllAngles)/2 , (length(AllAngles) -1) ]);  
%
AngleSelection1  = AllAngles(random_number1,:);
AngleSelection2 = AllAngles(random_number2,:);


AngleSelection = [ AngleSelection1(1,:),  AngleSelection2(1,:) ] ; %.* [1,-1,-1,1 ]; 
%
figure(1)
[TargetPointCloud, e1, e2] = Aim3_CreateRandomAblation( AngleSelection , 6 );
hold off

%

    % Read the point cloud data from the file
    % PCA Analysis
    [coeff, score, explained] = pca( TargetPointCloud );
    center = mean(TargetPointCloud);          
    maxValues = max(TargetPointCloud);
    minValues = min(TargetPointCloud);    
    BestFitAlg = "OldFit";
    
    
    figure(2)
    clf(2)
    pause(.5)     
   
        
        explainedVariances = sum(explained);
        coeff_RSHP = reshape( coeff, 1, 9); 

        
        %Perform the Analysis
        AllCoefficents = sqrt( sum( abs( ImportedCoefficents - coeff_RSHP).^2  ,2) );
        AllVariances = sqrt( sum( abs( ImportedVariances  - explained'  ).^2   ,2) ); 
        AllCenters = sqrt( sum( abs( ImportedCenters  - center   ).^2       ,2) );
        pause(.5)
        
        
for zi = 1:1
figure(zi + 1 )

       
        [ HighestX1, HighestX2, LowestX1, LowestX2, HighestY1, HighestY2, LowestY1,...
        LowestY2, HighestZ1, HighestZ2, LowestZ1, LowestZ2  ]  = AblationCloudFingerprint( TargetPointCloud, 40);       
        %
        FingerPrint = [ HighestX1, HighestX2, LowestX1, LowestX2, HighestY1, HighestY2,...
                        LowestY1, LowestY2, HighestZ1, HighestZ2, LowestZ1, LowestZ2  ] ;
        %            
        AllFingerPrint = sqrt( sum(  abs( ImportedFingerPrints - FingerPrint  )  ,2));            
        
        % Find the index of the smallest value
        BestFitData = ( normalize(AllVariances, 'range') + normalize(AllCoefficents, 'range') + ...
                         normalize(AllCenters, 'range') + normalize(AllFingerPrint, 'range') );
        [~, SortedIndex] = sort(BestFitData, 'ascend') ;
        [BestFitNum , index] = min(BestFitData);
        
%
index = SortedIndex(zi);
BestFitNum = BestFitData(index); 
% Specify the file path
filePath = fullfile(folder, files(index).name); % Replace with the path to your file
% Import the data from the file
AllData =  csvread(filePath);
data = csvread(filePath);
data = data(2:end, :);
% Define the preset point cloud
% Define the number of intervals
numIntervals = 57;
% Define the number of points in the point cloud
numPoints = size(data, 1);
% Reshape the vector data into a 3D matrix
vectorData = reshape(  data(: , :), length(data),   6, []);
% Displace the point cloud using the vector information
displacedPointCloud = TargetPointCloud; % Initialize with the preset point cloud



% Plot the initial point cloud


%     figure(zi + 1 )
    plotColor  = rgb("Gray");
    set(gcf,'position',[ 850, 250, 650, 600])
    set(gcf,'color',plotColor );
    set(gca,'color',plotColor );
    plot3(TargetPointCloud(:, 1), TargetPointCloud(:, 2), TargetPointCloud(:, 3), '.' ,...
          'MarkerSize', 4, 'Color', 'blue');
    hold on
    vecplot1 = plot3(e1(:,1),e1(:,2),e1(:,3), 'LineWidth', 7,'Color', 'r');
    %
    vecplot2 = plot3(e2(:,1),e2(:,2),e2(:,3), 'LineWidth', 10,'Color', 'b');

    intervalVectorData = vectorData(:, :, 3);
    plot3( intervalVectorData(:,1), intervalVectorData(:,2), intervalVectorData(:,3), '.',...
          'MarkerSize', 4, 'Color', 'red');    


    % title('Displacement Iteration: 0');
    title( join( ["Matched Point Cloud",  num2str(index), newline,...
                  "Random Number", num2str(random_number1), newline,...
                  "Iteration",  num2str(ki), "    Fit =", num2str(BestFitNum)   ]))
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    axis equal ;
    view( -35 , 25)
    xlim([-50/2, 50/2])
    ylim([-50/2, 50/2])
    zlim([-50/2, 50/2]) 
    hold off


pause(1)
end 





if iCreateVideo == "TRUE"
    Frame = getframe(gcf) ;                
    writeVideo(videoWriter,Frame)  
end 





%{
To find the nearest corresponding point in point cloud A to each point in point cloud B, 
we use the knnsearch function. The knnsearch function takes the target points 
(pointCloudB) and the reference points (pointCloudA) as input and returns the indices 
(nearestIdx) of the nearest points in A for each point in B.
%}
pointCloudB  = [intervalVectorData(:,1), intervalVectorData(:,2), intervalVectorData(:,3)];
% Find the nearest points and calculate the distances
[nearestIdx, distances] = knnsearch(TargetPointCloud, pointCloudB);
Average_Distances = [ Average_Distances    , mean(distances)];
STD_Distances = [  STD_Distances    , std(distances) ];
All_BestFitCriteria = [All_BestFitCriteria,  BestFitNum];

 
 if find_correspond == "TRUE"
    
    %
    A = TargetPointCloud;
    B = [intervalVectorData(:,1), intervalVectorData(:,2), intervalVectorData(:,3)];    
    [tform, registered_points] = Aim3_RegisterAblationAtlas( A, B);


    % Apply the transformation to the points
    homogeneousPoints = [B, ones(size(B, 1), 1)];
    B_registered = homogeneousPoints * tform.T;
    B = B_registered(:, 1:3);


    % Created Point Cloud , Atlas Pointcloud, Minimum Distance 
    [MatrixPairSorted] = Aim3_LinkedPointCorrespond(A, B);
    
    
end 



 % Visualize the point pairs by drawing lines
if Plot_Correspondance == "TRUE"
    figure;
    % Plot original point clouds A and B
    scatter3(A(:,1), A(:,2), A(:,3), 'b', 'filled');
    hold on;
    scatter3(B(:,1), B(:,2), B(:,3), 'r', 'filled');
    title('Original Point Clouds A and B');

    % Draw lines between the point pairs
    for i = 1:length(MatrixPairSorted)
        line([A(MatrixPairSorted(i,1), 1)  B(MatrixPairSorted(i,2), 1)], ...
             [A(MatrixPairSorted(i,1), 2)  B(MatrixPairSorted(i,2), 2)], ...
             [A(MatrixPairSorted(i,1), 3)  B(MatrixPairSorted(i,2), 3)], 'Color', 'g');
    end

    % Adjust subplot spacing
    plotColor  = rgb("Gray");
    set(gcf,'position',[ 850, 150, 950, 800])
    set(gcf,'color',plotColor );
    set(gca,'color',plotColor );
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    axis equal ;
    view( -35 , 25)
    xlim([-20, 20])
    ylim([-20, 20])
    zlim([-20, 20]) 
    hold off

    % vars = {'A','B'};
    % clear(vars{:})
end 
end 


if iCreateVideo == "TRUE" 
    close(videoWriter); 
    disp("Video Complete")
    disp(videoWriter.Filename  )
end 

if Plot_Histogram == "TRUE"

    figure()
    %Threshold is 3.5
    plotBestFit = All_BestFitCriteria- 3.5;
    plot3(  plotBestFit , Average_Distances, STD_Distances, '.', 'MarkerSize', 15);
    % Add the annotations
    annotations = (1:ki)';
    % Create the annotations
    BestFitDistances = round( sqrt( plotBestFit.^2 + Average_Distances.^2 + STD_Distances.^2), 2);
    % Create two string vectors of size 25x1
    vector1 = cellstr(string( annotations   )); % Random lowercase alphabets
    vector2 = cellstr(string( BestFitDistances'  )); % Random lowercase alphabets
    % Join the strings with the second vector as the subscript of the first vector
    joinedVector = strcat('--',vector1, '_{', vector2, '}');
   
    text( plotBestFit , Average_Distances, STD_Distances,...
            joinedVector  , 'FontSize', 8);
    title('Fitting Pointclouds');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal

    
    figure()
    plotColor  = rgb("White");
    set(gcf,'color',plotColor );
    set(gca,'color',plotColor );
    Bwidth = .2; 
    histogram( plotBestFit, 'BinWidth',Bwidth)
    hold on 
    histogram( BestFitDistances, 'BinWidth',Bwidth)
    legend( " BestFitCriteria ", " BestFitDistances")
end 





%%

figure()
iCreateVideo = "FLASE" ;  
presetPointCloud = TargetPointCloud;
all_min_index = [];
% Displace the point cloud for each interval and plot the results
% Displace the point cloud for each interval and plot the results




if iCreateVideo == "TRUE"
    VideoName = join([ 'AblationCloudEvolutione', num2str(random_number ) ,'.mp4']); 
    videoWriter = VideoWriter(VideoName,  'MPEG-4'); %// initialize the VideoWriter object
    videoWriter.FrameRate = 2;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end 



for interval = 1: numIntervals-3
   
    %Assign the current vector data
%     intervalVectorData = [ vectorData(:, :, interval);  vectorData(:, :, interval+1);...
%                            vectorData(:, :, interval+2) ];

    intervalVectorData = [ vectorData(:, :, interval) ];


    %find the points of the vector data
    B =  intervalVectorData( :,  1:3);
    % Apply the transformation to the points
    homogeneousPoints = [B, ones(size(B, 1), 1)];
    B_registered = homogeneousPoints * tform.T;
    vectorPoint = B_registered(:, 1:3);


    FindVector = "Assigned";
    % Displace each point in the point cloud
    if FindVector == "interpolate"

            % Calculate the magnitudes of all vectors
            magnitudes = vecnorm(intervalVectorData, 2, 2);
            % Sort the magnitudes in descending order
            [sorted_magnitudes, indices] = sort(magnitudes, 'ascend');
            % Find the average magnitude of the greatest 50 vectors
            num_greatest = 1000;
            average_magnitude = mean(sorted_magnitudes(1:num_greatest));



            for pointIndex = 1:numPoints
                %
                point = presetPointCloud(pointIndex, :);
                %FIND THE MINIMUM VECTOR
               
                % Find the closest vector to each point in the point cloud
                distances = sqrt((point(1) - vectorPoint(:,1)).^2 + ...
                            (point(2) - vectorPoint(:,2)).^2  + (point(3) - vectorPoint(:,3)).^2) ;
                % Find the index of the nearest point with unique match
                [min_dist, min_index] = min(distances);        


                if min_dist < 10
                    closestVectorIndex = min_index; 
                    vector = intervalVectorData(pointIndex, 4:6);

                    magnitude = norm(vector);  % Calculate the magnitude of the vector
                    % If the magnitude exceeds 5, set the magnitude to 5
                    if magnitude > average_magnitude
                        vector = (vector / magnitude) * average_magnitude;
                    end

                    %if norm(vector) > threshold
                    displacedPointCloud(pointIndex, :) = point + -1*vector*.98;
                    %end
                end 
            end
    end      
      
        AllVectors = []; 
        if FindVector == "Assigned"
            
            
            % Calculate the magnitudes of all vectors
            magnitudes = vecnorm(intervalVectorData, 2, 2);
            % Sort the magnitudes in descending order
            [sorted_magnitudes, indices] = sort(magnitudes, 'ascend');
            % Find the average magnitude of the greatest 50 vectors
            num_greatest = 50;
            average_magnitude = mean(sorted_magnitudes(1:num_greatest));
                
             for pointIndex = 1:numPoints
                 
                point = presetPointCloud(pointIndex, :);
                closestVectorIndex = MatrixPairSorted(pointIndex,2);
                vector = intervalVectorData(closestVectorIndex, 4:6);
                magnitude = norm(vector);  % Calculate the magnitude of the vector

                % If the magnitude exceeds 5, set the magnitude to 5
                if magnitude > average_magnitude
                    vector = (vector / magnitude) * average_magnitude;
                end

                %if norm(vector) > threshold
                displacedPointCloud(pointIndex, :) = point + -1*vector;

                magntude = norm(displacedPointCloud(pointIndex, :));  % Calculate the magnitude of the vector
                AllVectors = [AllVectors, magntude];
             end 


        end 
        

    
    
%     plot3(TargetPointCloud(:, 1), TargetPointCloud(:, 2), TargetPointCloud(:, 3),...
%         '.', 'MarkerFaceColor', 'black');
%     hold on   
%     
%     Plot the displaced point cloud for the interval
%     plot3(displacedPointCloud(:, 1), displacedPointCloud(:, 2), displacedPointCloud(:, 3),...
%         '.', 'Color', 'black');

    % Generate scalar values for each point

    scalarValues = AllVectors;
    % Plot the points using the 'jet' colormap
    colormap('jet');
    scatter3(displacedPointCloud(:, 1), displacedPointCloud(:, 2), displacedPointCloud(:, 3),...
                20, scalarValues, 'filled', 'MarkerEdgeColor', 'k', 'LineWidth',1);
    colorbar;
	caxis([0, 30]);
    hold on
    quiver3( intervalVectorData (:,1) , intervalVectorData (:,2), intervalVectorData (:,3),...
             intervalVectorData (:,4) , intervalVectorData (:,5), intervalVectorData (:,6),...
             'color', 'green');

    vecplot1 = plot3(e1(:,1),e1(:,2),e1(:,3), 'LineWidth', 7,'Color', 'r');
    %
    vecplot2 = plot3(e2(:,1),e2(:,2),e2(:,3), 'LineWidth', 10,'Color', 'b');



hold off
    
         
       
    %title(['Displacement Iteration: ', num2str(interval)]);
    
    idx = 5 : 1 : (15*4)+1 ; 
    minutes =  floor( (idx(interval)*15-15)/60) ; 
    seconds  = mod( (idx(interval)*15-15), 60)    ;
    title( join(["Ablation Evolution",...
    newline,  num2str(minutes),  "m","  ", num2str(seconds), "s" ]), 'Fontsize', 14 )     
    % Adjust subplot spacing
    plotColor  = rgb("Gray");
    set(gcf,'position',[ 850, 150, 950, 800])
    set(gcf,'color',plotColor );
    set(gca,'color',plotColor );
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    axis equal ;
    view( -35 , 25)
    xlim([-45, 45])
    ylim([-50, 50])
    zlim([-50, 50]) 
    hold off

    pause(.25)
    
    
    if iCreateVideo == "TRUE"
        Frame = getframe(gcf) ;                
        writeVideo(videoWriter,Frame)  
    end 

    presetPointCloud = displacedPointCloud;
end



if iCreateVideo == "TRUE" 
    close(videoWriter); 
    disp("Video Complete")
    disp(videoWriter.Filename  )
end 


