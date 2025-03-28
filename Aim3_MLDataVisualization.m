

clear 
clc 
close all

for fi = 2:10 %:10
close all
% type = ["Necrosis", "EField", "EField Single" ];
% % file_path = SelectElectAblationBoundary(   type(2),   fi   );

%file_path = "D:\Import To Matlab\COMSOL Pointcloud Parallel\AllData\All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_UN_Refined_4.95mmSpace    All.csv";
% file_path = "D:\Import To Matlab\COMSOL Pointcloud ML\AllData\All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv";  


% Specify the directory you want to search in
directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data\AllData'; % Change this to your directory
% Create a pattern to match .mph files
filePattern = fullfile(directoryPath, '*.csv');
% Get a list of all files in the directory with .mph extension
mphFilesCSV = dir(filePattern);
file_path = fullfile(directoryPath, mphFilesCSV(fi).name);
%
[filepath,name,ext] = fileparts(file_path); 
OGdata = readtable(file_path);
data = table2array(OGdata);

%


file_path2 = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
OGdata = readtable(file_path2);
ProbeArrangement = table2array(OGdata(:, 2:end ));
% Extract the coordinates, temperature, arrhenius, and electric field values
%
    % Separate the temperature, arrhenius, and electric field values for each time point
    numTimePoints = 58;  % Calculate the number of time points
    timePoints = cell(numTimePoints, 1);

    for i = 1:numTimePoints
        startIndex = 1 + (i - 1) * 4;
        endIndex = startIndex + 3;
        timePoints{i} = data(:, startIndex:endIndex);
    end

%

startPoint = 3;
disp("       DATA   LOADING   FINISHED       "  )


Plotfield = "FALSE";
PlotVectors1 = "FALSE";
PlotVectors2 = "TRUE";




%----------------------------------------------%
iCreateVideo = "TRUE";
if Plotfield == "TRUE"
for PlotEfieldSeclection  = 1:1
figure;   
%

spacing = [114.25, 119.75;  114.25, 124.7;     114.25, 129.65;     114.25, 134.6;...
           114.25, 139.55;  104.25, 134.5;     99.25, 134.45;      99.25, 134.45;...  
           94.50,  144.0;   94.50,  149.0;     ];     
%
if iCreateVideo == "TRUE"
    Video_Dir = "D:\VideoFiles\Power Dissipation Density\";
    name = char( name) ;
    Video_FileName = join([  "A3-1__", num2str(fi), " ", "ML Elec Field", ...
                                  name(end-15:end)  ,'.avi']);
    Video_FileName = convertStringsToChars(Video_FileName);
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
    videoWriter.FrameRate = 4.5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end

for i =   1 : numTimePoints-1

    currentPoints = timePoints{i, 1}  ;
    currentPoints = currentPoints(2:end, :);
    Intensity = currentPoints(:,4);

    points = currentPoints; % Random point cloud [x, y, z]
    intensities = Intensity; % Random intensity for each point
    Z = points(:, 3); % Extract the z-values
    [sortedZ, sortIndex] = sort(Z, 'descend'); % Sort z-values in descending order
    numPoints = length(points);
    numTopPoints = ceil(numPoints * 0.0225); % Top 10% of points, rounded up
    topPointsIndex = sortIndex(1:numTopPoints); % Indices of the top 10% of points
    % Step 2: Remove these points from the point cloud
    remainingPoints = points;
    remainingPoints(topPointsIndex, :) = []; % Remove the points
    % Step 3: Remove their associated intensity values
    remainingIntensities = intensities;
    remainingIntensities(topPointsIndex) = []; % Remove the intensity values



    X = remainingPoints(:,1);
    Y = remainingPoints(:,2);
    Z = remainingPoints(:,3);
    Intensity = remainingIntensities;


    
    subplot(1,2,1)
        %
        scatter3( X , Y, Z, 20, Intensity, 'filled');
        hold on
        alphaVal = .75;
        % [complete1 ] = AddAntennae3D( 122,  170, spacing(fi,1), centerZ, alphaVal);
        % [complete2 ] = AddAntennae3D( 122,  170, spacing(fi,2), centerZ, alphaVal);
        colormap jet
        c = colorbar;
        %c.Label.String = "Log_{10}(normEfield)";
        c.Label.String = "Total Power DD (w/m^3)";
        c.FontSize = 18; 
        caxis([2e5, 14e5])
        

        [ProbePointExport] =  A3_FindPlotPoints(file_path);
         scatter3(ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3), ...
                                    150, '.', 'k');

        axis equal
        % xlabel('X')
        % ylabel('Y')
        % zlabel('Z')
        grid off
    
        idx = 3 : 1 : (15*4)+1 ;
        minutes =  floor( (idx(i)*15-15)/60) ; 
        seconds  = mod( (idx(i)*15-15), 60)    ;
        titleName = join([ '\color{white} Ablation', num2str(minutes), "Min", num2str(seconds), "s" ]);       
        title(titleName, 'FontSize', 22)

        set(gca,'color',  rgb("Gray")  ); 
        plotColor  = rgb("Gray");
        set(gcf,'color', plotColor ); 


        hold off
       
   subplot(1,2,2)
       testData = Intensity; %# test data
       % [counts,bins] = hist(testData); %# get counts and bin locations
       % barh(bins,counts)

        [counts, bins] = hist(Intensity); % Get counts and bin locations
        barWidthI = bins(2) - bins(1); % Calculate bar width based on bin spacing
        % Create a horizontal bar graph where each bar is colored individually
        %colormap jet; % Use the 'jet' colormap
        All_Colors =  jet( length( bins ));
        for ki = 1:length(bins)
            barh(bins(ki), counts(ki), 'BarWidth', barWidthI ,'FaceColor', All_Colors(ki,:) );
            hold on; % Keep the figure open to plot the next bar
        end
        hold off; % Release the figure
        
        colorbar; % Optionally, add a colorbar to understand the color mapping
        title('Histogram of Total Power DD (w/m^3)');
       

%
set(gca,'color',  rgb("Gray")  ); 
plotColor  = rgb("Gray");
set(gcf,'color', plotColor );    
set(gcf,'position',[ 250, 100, 1250, 650])    
% Set figure and axes properties
% Set global font to bold
set(groot, 'DefaultAxesFontWeight', 'bold', 'DefaultTextFontWeight', 'bold');
set(groot, 'defaultFigureColor', 'k', ...  % Set default figure background to black
    'defaultAxesXColor', 'w', ...          % Set x-axis properties to white
    'defaultAxesYColor', 'w', ...          % Set y-axis properties to white
    'defaultAxesZColor', 'w', ...          % Set z-axis properties to white
    'defaultTextColor', 'w', ...           % Set text color to white
    'defaultAxesColor', 'none');           % Makes background of axes transparent
%
%
%
pause(.25)
                if iCreateVideo == "TRUE"
                    Frame = getframe(gcf) ;                
                    writeVideo(videoWriter,Frame)  
                end 
%  
end 
                if iCreateVideo == "TRUE" 
                    close(videoWriter); 
                    disp("Video Complete")
                    disp(videoWriter.Filename  )
                end 
%               
% Reset to default settings after plotting to avoid affecting future plots
set(groot, 'defaultFigureColor', 'remove', ...
    'defaultAxesXColor', 'remove', ...
    'defaultAxesYColor', 'remove', ...
    'defaultAxesZColor', 'remove', ...
    'defaultTextColor', 'remove', ...
    'defaultAxesColor', 'remove');
% Revert back to default font weight
set(groot, 'DefaultAxesFontWeight', 'normal', 'DefaultTextFontWeight', 'normal');

end 

end 





%----------------------------------------------%
iCreateVideo = "FALSE";
if PlotVectors1 == "TRUE"
for PlotVectorsSelection = 1:1

figure;   
%
% iCreateVideo = "TRUE";
spacing = [114.25, 119.75;  114.25, 124.7;     114.25, 129.65;     114.25, 134.6;...
           114.25, 139.55;  104.25, 134.5;     99.25, 134.45;      99.25, 134.45;...  
           94.50,  144.0;   94.50,  149.0;     ];     
%
if iCreateVideo == "TRUE"
    Video_Dir = "D:\VideoFiles\COMSOL Ablation Vectors\";
    name = char( name) ;
    Video_FileName = join([  "A3-", num2str(fi), " ", "ML Vector Field", ...
                                  name(end-15:end)  ,'.avi']);
    Video_FileName = convertStringsToChars(Video_FileName);
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
    videoWriter.FrameRate = 4.5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end


sampleIdx = 2;
for i =   4: 2:   numTimePoints- (sampleIdx + 1)

    currentPoints = timePoints{i, 1}  ;
    currentPoints = currentPoints(2:end, :);
    X = currentPoints(:,1);
    Y = currentPoints(:,2);
    Z = currentPoints(:,3);
    %
    %
    currentPoints2 = timePoints{i+ sampleIdx, 1}  ;
    currentPoints2 = currentPoints2(2:end, :);
    X2 = currentPoints2(:,1);
    Y2 = currentPoints2(:,2);
    Z2 = currentPoints2(:,3);
    %
    %
    rx =  (X2 - X);
    ry =  (Y2 - Y);
    rz =  (Z2 - Z);


    [phi, theta] = vecToSpherical( [rx, ry, rz]  ); 
    V = [rx, ry, rz];
    VecMagnitudes = vecnorm(V, 2, 2); % '2' for Euclidean norm, last '2' to operate along rows
    [new_vectors] =  CleanUpVectors( currentPoints, phi, theta, VecMagnitudes );
    centerZ = mean(Z);
    Intensity = currentPoints(:,4);
    
    set(gca,'color',  rgb("Gray")  ); 
    plotColor  = rgb("Gray");
    scatter3( X , Y, Z, 10, 'k', 'filled');
    hold on
    %q = quiver3(X , Y, Z, rx, ry, rz, 0,  'LineWidth', 1.5);
    q = quiver3(X , Y, Z, new_vectors(:,1), new_vectors(:,2), new_vectors(:,3), 0, ...
                    'LineWidth', 1.5)

                
            %// Compute the magnitude of the vectors
            mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
                        reshape(q.WData, numel(q.UData), [])).^2, 2));

            %// Get the current colormap
            currentColormap = colormap((jet));

            %// Now determine the color to make each arrow using a colormap
            [~, ~, ind] = histcounts(mags, size(currentColormap, 1));

            %// Now map this to a colormap to get RGB
            cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
            cmap(:,:,4) = 255;
            cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);

            %// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
            set(q.Head, ...
                'ColorBinding', 'interpolated', ...
                'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'

            %// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
            set(q.Tail, ...
                'ColorBinding', 'interpolated', ...
                'ColorData', reshape(cmap(1:2,:,:), [], 4).');

    alphaVal = .75;
    % [complete1 ] = AddAntennae3D( 122,  170, spacing(fi,1), centerZ, alphaVal);
    % [complete2 ] = AddAntennae3D( 122,  170, spacing(fi,2), centerZ, alphaVal);

    
    axis equal
    % xlabel('X')
    % ylabel('Y')
    % zlabel('Z')
    grid off
    
    idx = 3 : 1 : (15*4)+1 ;
    minutes =  floor( (idx(i)*15-15)/60) ; 
    seconds  = mod( (idx(i)*15-15), 60)    ;
    titleName = join([ '\color{white} Ablation', num2str(minutes), "Min", num2str(seconds), "s" ]);       
    title(titleName, 'FontSize', 22)
    hold off
%
set(gca,'color',  rgb("Gray")  ); 
plotColor  = rgb("Gray");
plotColor = [102 102 102]/255;
set(gcf,'color', plotColor );    
set(gcf,'position',[ 250, 100, 850, 650])    
% Set figure and axes properties
% Set global font to bold
set(groot, 'DefaultAxesFontWeight', 'bold', 'DefaultTextFontWeight', 'bold');
set(groot, 'defaultFigureColor', 'k', ...  % Set default figure background to black
    'defaultAxesXColor', 'w', ...          % Set x-axis properties to white
    'defaultAxesYColor', 'w', ...          % Set y-axis properties to white
    'defaultAxesZColor', 'w', ...          % Set z-axis properties to white
    'defaultTextColor', 'w', ...           % Set text color to white
    'defaultAxesColor', 'none');           % Makes background of axes transparent
%
%
%
pause(.25)
                if iCreateVideo == "TRUE"
                    Frame = getframe(gcf) ;                
                    writeVideo(videoWriter,Frame)  
                end 
%  
end 
                if iCreateVideo == "TRUE" 
                    close(videoWriter); 
                    disp("Video Complete")
                    disp(videoWriter.Filename  )
                end 
%               
% Reset to default settings after plotting to avoid affecting future plots
set(groot, 'defaultFigureColor', 'remove', ...
    'defaultAxesXColor', 'remove', ...
    'defaultAxesYColor', 'remove', ...
    'defaultAxesZColor', 'remove', ...
    'defaultTextColor', 'remove', ...
    'defaultAxesColor', 'remove');
% Revert back to default font weight
set(groot, 'DefaultAxesFontWeight', 'normal', 'DefaultTextFontWeight', 'normal');




end 

end 




%----------------------------------------------%

iCreateVideo = "FALSE";
if PlotVectors2 == "TRUE"
    close all
for PlotVectorsSelection2 = 1:1

figure;   
%

if iCreateVideo == "TRUE"
    Video_Dir = "D:\VideoFiles\COMSOL Ablation Vectors\";
    name = char( name) ;
    Video_FileName = join([  "A3-", num2str(fi), " ", "ML Vector Field", ...
                                  name(end-15:end)  ,'.avi']);
    Video_FileName = convertStringsToChars(Video_FileName);
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
    videoWriter.FrameRate = 4.5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end


sampleIdx = 1;
for i =   1: 1:  numTimePoints

    currentPoints = timePoints{i, 1}  ;
    currentPoints = currentPoints(2:end, :);
    X = currentPoints(:,1);
    Y = currentPoints(:,2);
    Z = currentPoints(:,3);
    %
    if i < numTimePoints
        currentPoints2 = timePoints{i+ sampleIdx, 1}  ;
        currentPoints2 = currentPoints2(2:end, :);
        X2 = currentPoints2(:,1);
        Y2 = currentPoints2(:,2);
        Z2 = currentPoints2(:,3);
    else
        X2 = X;
        Y2 = Y;
        Z2 = Z;
    end 
    %

    
    points = [X,Y,Z];
    points2 = [X2, Y2, Z2];
    [new_vectors, ProbePointExport] = A3_CreateEvolvingVector(points, points2,  ...
                                                      file_path);
    Intensity = currentPoints(:,4);
    %
    % Step 3: Normalize vector sizes to range from 2 to 5
    normalizedVectors = zeros(size(new_vectors));
    minMag = 1.5;
    maxMag = 2.25;
    minOriginalMag = min(vecnorm(new_vectors, 2, 2));
    maxOriginalMag = max(vecnorm(new_vectors, 2, 2));
    for jj = 1:size(normalizedVectors)
        oldMag = norm(new_vectors(jj, :));
        % Scale magnitude from [minOriginalMag, maxOriginalMag] to [minMag, maxMag]
        newMag = minMag + (maxMag - minMag) * ((oldMag - minOriginalMag) / (maxOriginalMag - minOriginalMag));
        %
        % Generate a random number between 0.1 and 0.4
        randomNumber = 0.1 + (0.8-0.1).*rand(1,1);
        normalizedVectors(jj, :) = (new_vectors(jj, :) / oldMag) * (newMag+ randomNumber);
    end





    scatter3( X , Y, Z, 10, 'k', 'filled');
    hold on
    scatter3(ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3), 40, '.', 'k');

    %q = quiver3(X , Y, Z, rx, ry, rz, 0,  'LineWidth', 1.5);
    q = quiver3(X , Y, Z, normalizedVectors(:,1), normalizedVectors(:,2), normalizedVectors(:,3), 0, ...
                    'LineWidth', 1.5);

                
            %// Compute the magnitude of the vectors
            mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
                        reshape(q.WData, numel(q.UData), [])).^2, 2));

            %// Get the current colormap
            currentColormap = colormap((jet));

            %// Now determine the color to make each arrow using a colormap
            [~, ~, ind] = histcounts(mags, size(currentColormap, 1));

            %// Now map this to a colormap to get RGB
            cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
            cmap(:,:,4) = 255;
            cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);

            %// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
            set(q.Head, ...
                'ColorBinding', 'interpolated', ...
                'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'

            %// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
            set(q.Tail, ...
                'ColorBinding', 'interpolated', ...
                'ColorData', reshape(cmap(1:2,:,:), [], 4).');

    alphaVal = .75;
    % [complete1 ] = AddAntennae3D( 122,  170, spacing(fi,1), centerZ, alphaVal);
    % [complete2 ] = AddAntennae3D( 122,  170, spacing(fi,2), centerZ, alphaVal);

    
    axis equal
    % xlabel('X')
    % ylabel('Y')
    % zlabel('Z')
    grid off
    
    idx = 2 : 1 : (15*4)+1 ;
    minutes =  floor( (idx(i)*15-15)/60) ; 
    seconds  = mod( (idx(i)*15-15), 60)    ;
    titleName = join([ '\color{white} Ablation', num2str(minutes), "Min", num2str(seconds), "s" ]);       
    title(titleName, 'FontSize', 22)
    hold off
%
set(gca,'color',  rgb("Gray")  ); 
plotColor  = rgb("Gray");
plotColor = [102 102 102]/255;
set(gcf,'color', plotColor );    
set(gcf,'position',[ 250, 100, 850, 650])    
% Set figure and axes properties
% Set global font to bold
set(groot, 'DefaultAxesFontWeight', 'bold', 'DefaultTextFontWeight', 'bold');
set(groot, 'defaultFigureColor', 'k', ...  % Set default figure background to black
    'defaultAxesXColor', 'w', ...          % Set x-axis properties to white
    'defaultAxesYColor', 'w', ...          % Set y-axis properties to white
    'defaultAxesZColor', 'w', ...          % Set z-axis properties to white
    'defaultTextColor', 'w', ...           % Set text color to white
    'defaultAxesColor', 'none');           % Makes background of axes transparent
%
%
%
pause(.25)
                if iCreateVideo == "TRUE"
                    Frame = getframe(gcf) ;                
                    writeVideo(videoWriter,Frame)  
                end 
%  
end 
                if iCreateVideo == "TRUE" 
                    close(videoWriter); 
                    disp("Video Complete")
                    disp(videoWriter.Filename  )
                end 
%               
% Reset to default settings after plotting to avoid affecting future plots
set(groot, 'defaultFigureColor', 'remove', ...
    'defaultAxesXColor', 'remove', ...
    'defaultAxesYColor', 'remove', ...
    'defaultAxesZColor', 'remove', ...
    'defaultTextColor', 'remove', ...
    'defaultAxesColor', 'remove');
% Revert back to default font weight
set(groot, 'DefaultAxesFontWeight', 'normal', 'DefaultTextFontWeight', 'normal');




end 

end 


end 