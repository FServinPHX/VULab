clear 
clc


% Specify the directory you want to search in
directoryPath = 'D:\COMSOL Models\ML_Test\COMSOL Model Analysis II'; % Change this to your directory
% Create a pattern to match .mph files
filePattern = fullfile(directoryPath, '*.csv');
% Get a list of all files in the directory with .mph extension
mphFiles = dir(filePattern);
% Loop through each file in the list
tStart = tic ;
T = [];


for fi = 1:1 %64
    % type = ["Necrosis", "EField", "EField Single" ];
    % file_path = SelectElectAblationBoundary(   type(2),   fi   );
    file_path = fullfile(directoryPath, mphFiles(fi).name);
    [filepath,name,ext] = fileparts(file_path);    
    OGdata = readtable(file_path);
    data = table2array(OGdata);
    % Extract the coordinates, temperature, arrhenius, and electric field values
    % Separate the temperature, arrhenius, and electric field values for each time point
    numTimePoints = 61;  % Calculate the number of time points
    timePoints = cell(numTimePoints, 1);



for i = 1:numTimePoints
    startIndex = 1 + (i - 1) * 5;
    endIndex = startIndex + 4;
    timePoints{i} = data(:, startIndex:endIndex);
end
%
%
%
input_str = name;
experiment_num = extract_experiment_number(input_str);
disp(['The experiment number is: ', num2str(experiment_num)]);


file_path2 = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
[filepath2,name2,ext] = fileparts(file_path2);    
OGdata = readtable(file_path2);
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
indices = [rowIndices, colIndices];



    startPoint = 3;
    disp("       DATA   LOADING   FINISHED       "  )



    AllBoundaryPoints = cell(numTimePoints, 1);
    NewSampledData = cell(numTimePoints, 1);
    StartAdj = startPoint - 1; 
    for i = startPoint: numTimePoints
    
    
        currentData = timePoints{i} ;
        Arrhnus = currentData(:, 4);    
        Coords = currentData(:, 1:3);
        Coords = Coords((Arrhnus> .985), :);
        Coords( isnan(Coords(:,1)), : ) = [];
    
        k = boundary(Coords,.75);
        %BoundaryPoints.k = reshape(k,[],1);
        k = reshape(k,[],1);
        kSort = unique(k);
        Coords = Coords(kSort,:);
        %
        %
        AllData1 =  Coords;
        NewPoints = AllData1;     


        AllBoundaryPoints{i} = NewPoints ;
    end 
end 



%%
clc


iCreateVideo = "TRUE";


if iCreateVideo == "TRUE"
    Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\ElecField\";
    name = char( name) ;
    Video_FileName = join([  "A3-X__", num2str(fi), " ", "SmoothField", ...
                                  name(end-15:end)  ,'.mp4']);
    Video_FileName = convertStringsToChars(Video_FileName);
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile,  'MPEG-4'); %// initialize the VideoWriter object
    videoWriter.FrameRate = 3.5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end





figure()
for j = startPoint: numTimePoints %:4: numTimePoints

    NewPoints = AllBoundaryPoints{j , 1}  ;



% subplot(1,3,1);
%
    % scatter3(  NewPoints(:,1), NewPoints(:,2), NewPoints(:,3), 10, 'r.', 'filled' )
    % axis equal 
    % pause(.25)
    % hold on 

    lineSize = 50;
    % Given parameters
        theta = data2( indices(1) , 1); % degrees
        phi   = data2(indices(1), 2); % degrees
        center = [data2(indices(1), 3) , data2(indices(1), 4) , data2(indices(1), 5) ]; % Starting point
        lengthLine = lineSize; % Length of the line   
        % Plotting the 3D line
    [plotedLine1] =  plot3DLineFromSpherical(phi, theta, center, lengthLine);
            % plot3( plotedLine1(:,1), plotedLine1(:,2), plotedLine1(:,3), ...
            %         'k.', 'MarkerSize', 10)
pause(.25)
    
        theta2 = data2(indices(1), 6); % degrees
        phi2   = data2(indices(1), 7); % degrees
        center2 = [data2(indices(1), 8) , data2(indices(1), 9) , data2(indices(1), 10) ]; % Starting point
        lengthLine = lineSize; % Length of the line   
        % Plotting the 3D line
    [plotedLine2] =plot3DLineFromSpherical(phi2, theta2, center2, lengthLine);
            % plot3( plotedLine2(:,1), plotedLine2(:,2), plotedLine2(:,3), ...
            %         'k.', 'MarkerSize', 10 )


        idx = 1 : 1 : (15*4)+1 ; 
        minutes =  floor( (idx(j)*15-15)/60) ; 
        seconds  = mod( (idx(j)*15-15), 60)    ;
        PlotTitle = join([  num2str(minutes), 'm','  ', num2str(seconds), 's'  ]) ;
        title( PlotTitle )


    % Making sure the plot stays after the function execution
    hold off;

    

num_iterations = 3; % Number of adjustment iterations
num_neighbors = 5; % Number of closest neighbors to find
original_points = NewPoints;
ProbePts = [plotedLine1; plotedLine2];
scale = 0.95 +  0.5*( j/61) ;
%
[ProbePts_filtered, pointsExport] =  A3_SmoothAblationComplete(original_points, ProbePts, ...
                                                        num_iterations, num_neighbors, scale);




% Plot the original and smoothed/adjusted point clouds
%figure;
    subplot(1,2,1);
    scatter3(original_points(:,1), original_points(:,2), ...
                original_points(:,3), '.', 'r');
    hold on 
    plot3( plotedLine1(:,1), plotedLine1(:,2), plotedLine1(:,3), ...
            'k.', 'MarkerSize', 10)  
    plot3( plotedLine2(:,1), plotedLine2(:,2), plotedLine2(:,3), ...
            'k.', 'MarkerSize', 10 )
    title('Original Point Cloud');
    axis equal;
    hold off


    
    subplot(1,2,2);
    scatter3(original_points(:,1), original_points(:,2), ...
                original_points(:,3), '.', 'r');    
    scatter3(pointsExport(:,1), pointsExport(:,2), pointsExport(:,3), '.', 'g');
    title('Adjusted Point Cloud');
    axis equal;
    hold on
        % Plot filtered points from A in blue
        plot3(ProbePts_filtered(:,1), ProbePts_filtered(:,2), ...
                    ProbePts_filtered(:,3),  'k.', 'MarkerSize', 10);
    hold off


    pause(.25)


set(gcf,'position',[ 250, 100, 850, 650])     

        
        if iCreateVideo == "TRUE" 
            Frame = getframe(gcf) ;                
            writeVideo(videoWriter,Frame)  
        end 
end 
        if iCreateVideo == "TRUE" 
            close(videoWriter); 
            disp("Video Complete")
            disp(videoWriter.Filename  )
        end 
