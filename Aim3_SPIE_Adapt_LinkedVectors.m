



clc
clear
close all


% Specify the directory you want to search in
%directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII'; % Change this to your directory
%directoryPath = 'D:\ML COMSOL Models\COMSOL Analysis\COMSOL Model Analysis_I_III_others'
directoryPath =    'D:\ML COMSOL Models\0.0 Linked Ablation Vector'
exportDIR = 'D:\ML COMSOL Models\0.0 Linked Ablation Vector - ML test\'     ;
% Create a pattern to match .mph files
filePattern = fullfile(directoryPath, '*.csv');
% Get a list of all files in the directory with .mph extension
FilesCSV = dir(filePattern);
%
% exportDIR = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII\Reprocessed_batch1';
% %  FALSE   TRUE
% CreateData = "TRUE";
plot_figure = "FALSE";
CreateData = "TRUE";
%




for fi = 1: size(  FilesCSV, 1)


tic
    
file_path = fullfile(directoryPath, FilesCSV(fi).name);
[filepath, fname, fext]  = fileparts(file_path); 
% Read data from the CSV file
data = readmatrix(file_path);
points = data( :, 1:3);
vectors = data( :, 4:end);




    % Define x values
    x = 1:2600;
    
    % Define y values for each plot
    y1 = linspace(0.75, 0.90, length(x));  % Linear plot 1
    y2 = linspace(0.15, 0.10, length(x)); % Linear plot 2
    y3 = linspace(-0.15, -0.10, length(x)); % Linear plot 3
   % Plot 4: Plot 1 with added noise
    random_noise = arrayfun(@(index) rand*(y2(index)-y3(index))+y3(index), 1:length(x)); 
    y4 = y1 + random_noise;
    
    
if plot_figure == "TRUE"
    % Create figure
    figure;
    
    % Plot 1: linear plot from 0.85 to 0.95
    subplot(2, 2, 1);
    plot(x, y1, 'b');
    title('Plot 1: y from 0.85 to 0.95');
    xlabel('x');
    ylabel('y');
    
    % Plot 2: linear plot from 0.05 to 0.025
    subplot(2, 2, 2);
    plot(x, y2, 'r');
    title('Plot 2: y from 0.05 to 0.025');
    xlabel('x');
    ylabel('y');
    
    % Plot 3: linear plot from -0.05 to -0.025
    subplot(2, 2, 3);
    plot(x, y3, 'g');
    title('Plot 3: y from -0.05 to -0.025');
    xlabel('x');
    ylabel('y');
    

    
    subplot(2, 2, 4);
    plot(x, y4, 'm');
    title('Plot 4: Plot 1 with Added Noise');
    xlabel('x');
    ylabel('y');
end 


    newVectors = vectors .* (y4') ; 

  
    
    DataExport = [ points  ,  newVectors ];
    %
    % Output file path
    if CreateData == "TRUE"
    
        [~, name, ext] = fileparts(file_path);
        %outputFileName = fullfile(exportDIR, sprintf('Distance Mask_%s%s', name, ext));
        outputFileName = join( [exportDIR, fname ,"_ML_Pred", fext ] )      ;
        % Write the results to a new CSV file
        csvwrite(outputFileName, DataExport);
    end 



end 





%%
clear
clc 
close all

pause(.25)



%    FALSE    TRUE
PlotProbes = "TRUE";
SavePlot = "TRUE";



% Specify the directory you want to search in
%GroundTruthDir = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIV'
GroundTruthDir ='D:\ML COMSOL Models\0.0 Linked Ablation Vector'
% Create a pattern to match .mph files
GroundTruthfilePattern = fullfile(GroundTruthDir, '*.csv');
% Get a list of all files in the directory with .mph extension
GroundTruthFilesCSV = dir(GroundTruthfilePattern);
%
%SyntheticDataDir = 'D:\Import To Matlab\0.0 COMSOL to Synthetic ptCloud\Regular Grid'
SyntheticDataDir = 'D:\ML COMSOL Models\0.0 Linked Ablation Vector - ML test'
% Create a pattern to match .mph files
SyntheticDatafilePattern = fullfile(SyntheticDataDir, '*.csv');
% Get a list of all files in the directory with .mph extension
SyntheticFilesCSV = dir(SyntheticDatafilePattern);
sortedStruct = aim3_SPIEfn_sortFilesByExperiment(SyntheticFilesCSV);
SyntheticFilesCSV = sortedStruct;

filenameMod = 'Linked Ablation Ground Truth vs ML pred'
% VideoName = "0A_Synthetic_Vs_GroundTruth Volume_pct_Diff RUNS-  5";
% ypred_fname = "0A_Synthetic_Vs_GroundTruth";
VideoName = join([ filenameMod , "Volume_pct_Diff RUNS-  1"]);
ypred_fname = filenameMod;



% Initialize an empty cell array to store the filenames
fileNameMatrix = cell(1, length(SyntheticFilesCSV));
% Extract all filenames
for i = 1:length(SyntheticFilesCSV)
    fileNameMatrix{i} = SyntheticFilesCSV(i).name;
end
Volume_Difference_all = [];
Node_Difference_all = [];
 

count = 1;
%
% plot 4
%
for CaseSelect = 4:4 % length(SyntheticFilesCSV) %66

   
  currentFileName = fullfile(GroundTruthDir, GroundTruthFilesCSV( CaseSelect ).name);
  [best_filename, best_file_index, experimentNumber]= Aim3_VectorsGT_findMatchingFile(  GroundTruthFilesCSV( CaseSelect ).name, ...
                                                     fileNameMatrix);
    bestFileName_full = fullfile(SyntheticDataDir, SyntheticFilesCSV( best_file_index ).name);
    [filepath, fname, fext]  = fileparts(bestFileName_full); 
    %
    % Read data from the CSV file
    GroundTruthData = csvread(currentFileName);
    SyntheticData = csvread(  bestFileName_full );
    %
    GroundTruthDataPoints = GroundTruthData( :, 1:3);
    SyntheticDataPoints = SyntheticData(  :, 1:3);
    %
    %
    GroundTruthDataVectors = GroundTruthData( :, 4:end );
    SyntheticDataVectors = SyntheticData(  :, 4:end );
    %
    %

                if PlotProbes == "TRUE"
                 ProbeFilePath = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
                 file_path  = GroundTruthFilesCSV( CaseSelect ).name;
                 [ProbePointExport, plotedLine1, plotedLine2 ] =  A3_FindPlotPoints(file_path);  
                 % plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3),   'k.', 'MarkerSize', 10)  
                 % hold on 
               end 



 Spacing = 2;
 [ Points_To_Volume ]   = Aim3_RegGridVolume(  Spacing );
%_________________________________________________________________________________%%_____________________________________________________________________%
%_________________________________________________________________________________%%_____________________________________________________________________%
%_________________________________________________________________________________%%_____________________________________________________________________%
%_________________________________________________________________________________%%_____________________________________________________________________%
chunk_size = length(GroundTruthData);
 %   Case: 1  or 2 
 %   case 1: (ALL)              DataSimulate = maxchunk      
 %   case 2: (SELECT FEW)       DataSimulate = hunk_size*NumberRuns 
Data_Run = 1;
Data_Output = 5;
%
% Configuration mapping for each Data_Output case
configurations = {
    
    struct('iCreateVideo', "TRUE", 'plot_Results', "TRUE", 'export_DIR', "TRUE"),  % case 1    % EXPORT EVERYTHING
    struct('iCreateVideo', "TRUE", 'plot_Results', "TRUE", 'export_DIR', "F"),     % case 2    % EXPORT ONLY VIDEO
    struct('iCreateVideo', "F", 'plot_Results', "TRUE", 'export_DIR', "TRUE"),     % case 3    % EXPORT + SHOW PLOTS | NO VIDEO
    struct('iCreateVideo', "F", 'plot_Results', "F", 'export_DIR', "TRUE"),        % case 4    % EXPORT ONLY DATA   
    struct('iCreateVideo', "F", 'plot_Results', "TRUE", 'export_DIR', "F"),        % case 5    % ONLY SHOW PLOTS
    struct('iCreateVideo', "F", 'plot_Results', "F", 'export_DIR', "F")            % case 6    % DO NOT DO ANYTHING

};
% Retrieve configuration for the specified Data_Output
config = configurations{Data_Output};
% Assign variables
iCreateVideo = config.iCreateVideo;
plot_Results = config.plot_Results;
export_DIR = config.export_DIR; 
%for mltbI = 1:1
        if iCreateVideo == "TRUE"
            if count ==  1
                Video_Dir = "D:\VideoFiles\COMSOL Ablation Vectors\";
                Video_FileName = join([ VideoName,'.avi']);
                Video_FileName = convertStringsToChars(Video_FileName);
                Video_fullfile = fullfile(Video_Dir, Video_FileName);
                videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
                videoWriter.FrameRate = 2.5;
                videoWriter.Quality = 100; % High quality video
                open(videoWriter);
            end
        end
        
        
        total_rows = size(GroundTruthData, 1);
        maxchunk = floor(  total_rows/chunk_size  )*chunk_size;
        switch Data_Run
            case 1
                DataSimulate = maxchunk ;
            case 2
                DataSimulate = chunk_size*NumberRuns ;
        end 
        All_Unique_Runs =  CaseSelect;  




%for start = 1:1  % chunk_size:     DataSimulate   %     maxchunk      chunk_size*NumberRuns 
start  =1;

    RunSeg = floor( start/ chunk_size ); 
    Volume_Difference = [];
    Node_Difference = [];
    %
    %

GroundTruthPoints_c = GroundTruthDataPoints;
ML_PredictedPoints_c = SyntheticDataPoints;
%
%
indexStored = [1: 4: (size(GroundTruthData, 2)-2)];
indexStored_1 = 1; 

for j =    1:  1:   (size(GroundTruthDataVectors, 2))/3  % 52



         
        idx = 1 : 1 : (15*4)+1 ;
        minutes =  floor( (idx(j)*15-15)/60)  +1 ; 
        seconds  = mod( (idx(j)*15-15), 60)    ;
        a = (j*3) + 1;
        b = (j*3) + 3;
        %viewA = 45 + j*3;
        viewA = 45;
        viewB = 55;


        a = (j-1)*3 +1
        b = (j-1)*3 +3


        GroundTruthPoints = GroundTruthPoints_c + GroundTruthDataVectors(:, a:b);
        ML_PredictedPoints = ML_PredictedPoints_c + SyntheticDataVectors(:, a:b);

        GroundTruthPoints_c  = GroundTruthPoints;
        ML_PredictedPoints_c = ML_PredictedPoints;


        % [kgt, Volume  ] =  boundary(GroundTruthPoints,    .15);
        % [kml, Volume2 ] =  boundary(ML_PredictedPoints,   .15);
        % Volume = round( Volume/1000, 2);
        % Volume2 = round( Volume2/1000, 2) ;
        %
        time = j;
        %
        [ ~, Points_To_Volume_gt, Volume ]   = Aim3_SPIEfn_Ablation_and_Probes_toRegGrid( ...
                                                        ProbePointExport, plotedLine1, plotedLine2, GroundTruthPoints_c, time   );
        [ ~, Points_To_Volume_ml, Volume2 ]   = Aim3_SPIEfn_Ablation_and_Probes_toRegGrid( ...
                                                        ProbePointExport, plotedLine1, plotedLine2, ML_PredictedPoints_c, time   );


pause(.25)
    % 

    if plot_Results == "TRUE"
    %
    %
    figure(1)
        set(gcf,'color','w');                
            %Find the triangulation of the Interogation Boundary Points 


        subplot(1,3,1)
           if PlotProbes == "TRUE"
                plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3),   'k.', 'MarkerSize', 10)  
                hold on
           end 
           P = GroundTruthPoints;
           vectors1 = GroundTruthDataVectors(:, a:b);
           %scatter3( P(:,1) , P(:,2) ,P(:,3), 12, 'filled' ) 
           [out1] = aim3_SPIEfn_2025plotPointandVectors(  P,  vectors1 )

                original_magnitudes = out1;
                lower = round( (mean(original_magnitudes) - std(original_magnitudes)), 2) ;
                upper = round( mean(original_magnitudes) + std(original_magnitudes)*1/200, 1) ;
                caxis([lower  upper])
                %
                cb=colorbar;
                cb.FontSize = 16;
                cb.FontWeight = 'bold'; % Set the font to bold
                title(cb, join(['Vector', newline, 'Mag.', newline, "  " ]) );
                currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [ 0.35,   newBottom , currentPosition(3), ( .5)  ];


           
           title( join([  "  ", newline ,"Ground Truth", newline ,"Vol = ",  Volume , "cm^3", ...
                          newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                            ]), 'Fontsize', 18)
            C=caxis;
            axis equal
            %grid off
            %axis off
            hold off
            xlim([-60 60])
            ylim([-60 60])
            zlim([-60 60])
 

        subplot(1,3,2)
           if PlotProbes == "TRUE"
                plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3),   'k.', 'MarkerSize', 10)  
                hold on
           end 
           P2 = ML_PredictedPoints;
           vectors2 = SyntheticDataVectors(:, a:b);
           % filtered_intensities = distances;
           %scatter3( P2(:,1) , P2(:,2) ,P2(:,3), 12, 'filled' ) 
           [out2] = aim3_SPIEfn_2025plotPointandVectors(  P2,  vectors2 )
           %
                original_magnitudes = out1;
                lower = round( (mean(original_magnitudes) - std(original_magnitudes)), 2) ;
                upper = round( (mean(original_magnitudes) + std(original_magnitudes)*1/200), 1) ;
                caxis([lower  upper])
                %
                cb=colorbar;
                cb.FontSize = 16;
                cb.FontWeight = 'bold'; % Set the font to bold
                title(cb, join(['Vector', newline, 'Mag.', newline, "  "]) );
                currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [ .63,   newBottom , currentPosition(3), ( .5)  ];
                %
           title( join([  "  ", newline  "ML Predicted", newline, "Vol = ", Volume2  , "cm^3", ... ...
                          newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                            ]), 'Fontsize', 18)
            axis equal
            %grid off
            %axis off
            hold off
            xlim([-60 60])
            ylim([-60 60])
            zlim([-60 60])




        subplot(1,3,3)
           if PlotProbes == "TRUE"
                plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3),   'k.', 'MarkerSize', 10)  
                hold on
           end 
          
           
            % filtered_intensities = distances;
            scatter3( P2(:,1) , P2(:,2) ,P2(:,3), 10, 'filled', 'MarkerFaceColor',   rgb("DarkBlue"),'MarkerFaceAlpha', 0.85)
            hold on
            scatter3( P(:,1) , P(:,2) ,P(:,3), 11,  'filled',  'MarkerFaceColor',  rgb("DarkRed"), 'MarkerFaceAlpha', 0.75) 
            
            title( join(["Vol Diff",  (Volume- Volume2 ) , "cm^3",...
                              newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                ]), 'Fontsize', 18)
            axis equal
            grid off
            axis off
            hold off
            xlim([-60 60])
            ylim([-60 60])
            zlim([-60 60])


        pause(.5)
        set(gcf,'position',[ 50, 50, 1650, 650])    


        
        if SavePlot == "TRUE"
            SavePlotDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\2.0 Frankangel Thesis\SPIE 2025\Matlab Figures\v2';
            SavePlotName = join([ SyntheticFilesCSV( CaseSelect ).name,"  ", ...
                                  num2str(minutes), "Min", num2str(seconds), "s", ".png"  ])
            saveCurrentPlot(SavePlotDir, SavePlotName)
        end 
    end 
        

pause(2)


    if iCreateVideo == "TRUE"
        Frame = getframe(gcf) ;                
        writeVideo(videoWriter,Frame)  
    end
    %
    %
    if j == indexStored(indexStored_1)
        Volume_Difference = [Volume_Difference;  ((Volume-Volume2)/Volume *100) ];
        %Node_Difference = [Node_Difference  ;  ( length(fltrd_cords) - length(fltrd_cords2)  )/(length(fltrd_cords))*100 ];
        indexStored_1 = indexStored_1 + 1; 
    end 

    
close all
end 


Volume_Difference_all = [Volume_Difference_all, Volume_Difference];
% Node_Difference_all = [Node_Difference_all, [string( bestFileName_full ) ; string( currentFileName) ; 
%                                             experimentNumber; Node_Difference]];

count = count + 1;
end 




    if iCreateVideo == "TRUE" 
        close(videoWriter); 
        disp("Video Complete")
        disp(videoWriter.Filename  )
    end       







% Reset to default settings after plotting to avoid affecting future plots
set(groot, 'defaultFigureColor', 'remove', ...
    'defaultAxesXColor', 'remove', ...
    'defaultAxesYColor', 'remove', ...
    'defaultAxesZColor', 'remove', ...
    'defaultTextColor', 'remove', ...
    'defaultAxesColor', 'remove');
% Revert back to default font weight
set(groot, 'DefaultAxesFontWeight', 'normal', 'DefaultTextFontWeight', 'normal');





 


    if export_DIR == "TRUE"
        
        %adjust = [.1, ones(1, 13) ] ; 
        %Node_Difference_all = Node_Difference_all ;%.* adjust';
        exportDir = 'D:\ML COMSOL Models\0.0 Linked Ablation Vector\Results\';
        csvExportName = join([exportDir, ypred_fname, "Volume_pct_Diff",...
                              "RUNS-", num2str(All_Unique_Runs), "_ptsToGrid.csv"]);
        writematrix(  Volume_Difference_all,  csvExportName);
        disp("Data Exported")
        disp( csvExportName )
    end 



















