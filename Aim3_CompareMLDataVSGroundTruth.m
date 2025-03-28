

clear
clc 



%    FALSE    TRUE
PlotProbes = "TRUE";
SavePlot = "F";


% Specify the directory you want to search in
GroundTruthDir = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIV\0 Degree'
% Create a pattern to match .mph files
GroundTruthfilePattern = fullfile(GroundTruthDir, '*.csv');
% Get a list of all files in the directory with .mph extension
GroundTruthFilesCSV = dir(GroundTruthfilePattern);
%SyntheticDataDir = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1 Resampled\Predictions'
SyntheticDataDir = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\Final_Predictions_0Degree'
% Create a pattern to match .mph files
SyntheticDatafilePattern = fullfile(SyntheticDataDir, '*.csv');
% Get a list of all files in the directory with .mph extension
SyntheticFilesCSV = dir(SyntheticDatafilePattern);



VideoName = "0_FinalRun_MachineLearning_Vs_GroundTruth Volume_pct_Diff RUNS-  5";



% Initialize an empty cell array to store the filenames
fileNameMatrix = cell(1, length(SyntheticFilesCSV));
% Extract all filenames
for i = 1:length(SyntheticFilesCSV)
    fileNameMatrix{i} = SyntheticFilesCSV(i).name;
end
Volume_Difference_all = [];
Node_Difference_all = [];




count = 1;


find_signed_distance =  "TRUE";

%%

for CaseSelect =  1:1     %210:216


   
  currentFileName = fullfile(GroundTruthDir, GroundTruthFilesCSV( CaseSelect ).name)
  [best_filename, best_file_index, experimentNumber]= Aim3_SynthVsGT_findMatchingFile(  GroundTruthFilesCSV( CaseSelect ).name, ...
                                                     fileNameMatrix);
    bestFileName_full = fullfile(SyntheticDataDir, SyntheticFilesCSV( best_file_index ).name);
    [filepath, fname, fext]  = fileparts(bestFileName_full); 
    %
    % Read data from the CSV file
    GroundTruthData = csvread(currentFileName);
    SyntheticData = readtable(  bestFileName_full );
    SyntheticData = table2array(SyntheticData)  ;
    SyntheticData = [SyntheticData; SyntheticData(end, :)];
    QuerryPointsOG = GroundTruthData( :, 1:3);




    if PlotProbes == "TRUE"
     ProbeFilePath = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
     file_path  = GroundTruthFilesCSV( CaseSelect ).name;
     [ProbePointExport, plotedLine1, plotedLine2 ] =  A3_FindPlotPoints(file_path);  
     % plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3),   'k.', 'MarkerSize', 10)  
     % hold on 
   end 





 Spacing = 2;
 [ Points_To_Volume ]   = Aim3_RegGridVolume(  Spacing );
%_________________________________________________________________________________%
%_________________________________________________________________________________%
%_________________________________________________________________________________%
%_________________________________________________________________________________%
%_________________________________________________________________________________%








MaskType  = ["Distance"];
chunk_size = length(GroundTruthData);
 %   Case: 1  or 2 
 %   case 1: (ALL)              DataSimulate = maxchunk      
 %   case 2: (SELECT FEW)       DataSimulate = hunk_size*NumberRuns 
Data_Run = 1;
Data_Output = 6;
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
                Video_Dir = "D:\VideoFiles\3rd Paper All Videos\";
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
        %chunk_size = length(QuerryPointsOG);
        % Volume_Difference_all = [];
        % Node_Difference_all = [];
        % Processing in increments of 2600 rows
        %   maxchunk = chunk_size*NumberRuns
        %   maxchunk = total_rows
        maxchunk = floor(  total_rows/chunk_size  )*chunk_size;
        switch Data_Run
            case 1
                DataSimulate = maxchunk ;
            case 2
                DataSimulate = chunk_size*NumberRuns ;
        end 
        All_Unique_Runs =  CaseSelect;  %  floor( DataSimulate/ chunk_size);





%for start = 1:1  % chunk_size:     DataSimulate   %     maxchunk      chunk_size*NumberRuns 
start  =1;

    RunSeg = floor( start/ chunk_size ); 
    Volume_Difference = [];
    Node_Difference = [];
    % Initialize the array with 10,000 rows and 244 columns
    Saved_data = zeros(10000, 4*61);
    %
    %
for j =    1:  4:  (size(GroundTruthData, 2)-1)  % 52



         
        idx = 1 : 1 : (15*4) ;
        minutes =  floor( (idx(j)*15-15)/60)  +1 ; 
        seconds  = mod( (idx(j)*15-15), 60)    ;
        a = (j*3) + 1;
        b = (j*3) + 3;
        %viewA = 45 + j*3;
        viewA = 45;
        viewB = 55;
        finish = start + chunk_size -1;
        distancesIn = GroundTruthData( : , j+4);
        PredictionMask = SyntheticData( : , j);




pause(.25)

           switch MaskType 
        
                case "Distance"
                        mean_train = mean(distancesIn );
                        mean_stdev_train = std(distancesIn);
                        distancesIn(distancesIn > 0) = nan;
                        distancesIn(distancesIn < -20) = nan;
                        %
                        mean_pred = mean(PredictionMask);
                        mean_stdev_pred = std(PredictionMask);
                        %PredictionMask = PredictionMask - ( abs(mean_train- mean_pred) +  abs(mean_stdev_train - mean_stdev_pred)*1.3 ); 
                        PredictionMask = PredictionMask ;
                        PredictionMask(PredictionMask > 0) = nan;
                        PredictionMask(PredictionMask < -20) = nan;
                        %
                        ExportBinary = SyntheticData( :  , j);
                        ExportBinary(ExportBinary > 0) = 0;
                        %ExportBinary(ExportBinary < -20) = 0 ;    
                        ExportBinary(ExportBinary < 0) = 1 ;      

                        colormap jet

                    case "Binary"
                        mean_train = mean(distancesIn );
                        mean_stdev_train = std(distancesIn);
                        distancesIn(distancesIn > 0) = nan;
                        distancesIn(distancesIn == 0) = nan;
                        distancesIn(distancesIn < 0) = 1;
                        %
                        mean_pred = mean(PredictionMask);
                        mean_stdev_pred = std(PredictionMask);
                        %PredictionMask = PredictionMask - ( abs(mean_train- mean_pred) +  abs(mean_stdev_train - mean_stdev_pred)*1.3 ); 
                        PredictionMask(PredictionMask > 0) = nan;
                        PredictionMask(PredictionMask == 0) = nan;
                        PredictionMask(PredictionMask < 0) = 1;
                        %
                        caxis = [0, 1];
                        colormap abyss


                case "ElectricField"
                        mean_train = mean(distancesIn );
                        mean_stdev_train = std(distancesIn);
                        %
                        maxValueTrainData=   maxOfLowestXPercent(distancesIn, 95)  ;
                        filterTrain = maxValueTrainData ;
                        distancesIn(distancesIn > filterTrain) = nan;
                        distancesIn(distancesIn < 0) = nan;


                        mean_pred = mean(PredictionMask);
                        mean_stdev_pred = std(PredictionMask);
                        % Call the function
                        maxValuePredictionMask = maxOfLowestXPercent(PredictionMask, 93.5);
                        FilterExport = maxValuePredictionMask ;
                        %PredictionMask = PredictionMask - shiftExp ;
                        PredictionMask(PredictionMask > FilterExport) = nan;
                        PredictionMask(PredictionMask < 0) = nan;

                        colormap jet
            end 
    % 








        %                   TRUE     FALSE
        ExportSegmentation = "FALSE";
            if ExportSegmentation == "TRUE"


                % outputDir = join( [ 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data\',...
                %                     ypred_fname]); 

                outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data\ 22-All Predictions_model Pytorch Distances_10 EPOCH__Part2'
                dataPoints = QuerryPointsOG;
                newCenter = [0,0,0] ;
                gridSize = nthroot(length(QuerryPointsOG), 3 );
                binaryIntensities = ExportBinary;
                FileName =  join(  [ "RUN_num_", num2str(RunSeg) ,num2str(minutes), ...
                                    "Min", num2str(seconds), "s", ".nii"]  )  ;
                xyzData = dataPoints; 
                intensityData = binaryIntensities;
                %How many Ones Appear
                % Call the function to count the number of 1's
                count = countOnesInMatrix(intensityData);
                % Display the result
                disp(['Number of 1s in the Original matrix: ', num2str(count)]);
                intensityspc = 2;
                %Create the Box Phantom Model
                pVoxVoxSize = [100, 100, 100 ] ;
                center = [0,0,0]- (pVoxVoxSize/2) ;
                %Choose where to start and end 
                strt = [0, 0, 0];
                endd = [0,0,0];
                pVoxVolxelx = [ center(1) +  pVoxVoxSize(1)*strt(1) :pVoxVoxSize(1): pVoxVoxSize(1)*endd(1)  +  center(1)  ] ;
                pVoxVolxely = [ center(2) +  pVoxVoxSize(2)*strt(2) :pVoxVoxSize(2): pVoxVoxSize(2)*endd(2)  +  center(2)  ] ;
                pVoxVolxelz = [ center(3) +  pVoxVoxSize(3)*strt(3) :pVoxVoxSize(3): pVoxVoxSize(3)*endd(3)  +  center(3)  ] ;
                %
                QuerryPointsOG = dataPoints; 
                intensityI  = binaryIntensities;
                [intensity_X, intensity_Y, intensity_Z, intensity_I] = transformQuerryPointsToMeshgrid(QuerryPointsOG, intensityI, ...
                    pVoxVolxelx, pVoxVolxely, pVoxVolxelz, intensityspc);
                binaryGrid  =  intensity_I; 
                % Convert the binary grid into a 3D segmentation format
                if ~exist(outputDir, 'dir')
                    mkdir(outputDir);
                end
                % 'adjusted_sphere_segmentation.nii'
                niftiFile = fullfile(outputDir, FileName);
                % Create NIFTI structure using the make_nii function
                nii = make_nii(binaryGrid, [1 1 1], [0 0 0], 2); % Ensuring datatype is int16
                niftiFile = fullfile(outputDir, FileName)
                niftiFile = convertStringsToChars( niftiFile)
                save_nii(nii, niftiFile)
                  % Call the function to count the number of 1's
                count = countOnesInMatrix(binaryGrid);
                % Display the result
                disp(['Number of 1s in the Binary Grid matrix: ', num2str(count)]);              
            end




        

    [fltrd_cords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, distancesIn);
    %
    z_threshold_lower = -22;
    z_Threshold_upper = 38 + (j/ 50)*5 ;
    intensity_data_filtered = [QuerryPointsOG, PredictionMask]; % Copy the original data
    intensity_data_filtered(QuerryPointsOG(:, 3) < z_threshold_lower, 4) = NaN;
    intensity_data_filtered(QuerryPointsOG(:, 3) > z_Threshold_upper, 4) = NaN;            
    PredictionMask = intensity_data_filtered(:,4);
    [fltrd_cords2, filtered_intensities2] = Global_remove_nan_intensity(QuerryPointsOG, PredictionMask);
    %
    %
    C = compareIntensityMatrices(distancesIn, PredictionMask);
    C( C == 0) = nan;
    [fltrd_cords__C,   fltrd__intnsty__C] = Global_remove_nan_intensity(QuerryPointsOG, C);
    %
    %
    Volume = round( (Points_To_Volume*length(fltrd_cords))/1000, 2); 
    Volume2 = round( (Points_To_Volume*length(fltrd_cords2))/1000, 2); 




    if plot_Results == "TRUE"
    figure(1)
    
        set(gcf,'color','w');                
            %Find the triangulation of the Interogation Boundary Points 


        subplot(1,3,1)
           if PlotProbes == "TRUE"
                plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3),   'k.', 'MarkerSize', 10)  
                hold on
           end 
           P = fltrd_cords;
           % filtered_intensities = distances;
            [markerSizesP1] =  scaledScatterData( filtered_intensities, .1 , 10);
            scatter3( P(:,1) , P(:,2) ,P(:,3), markerSizesP1,  filtered_intensities, 'filled' ) 
                cb=colorbar;
                cb.FontSize = 18;
                title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
                    currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [ 0.35   newBottom currentPosition(3) .5];

                title( join(["Ground Truth Vol = ", Volume, 'cm^{3}', ...
                              newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                ]), 'Fontsize', 18)
                % title( join(["# Pts", length(fltrd_cords), ...
                %               newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                %                 ]), 'Fontsize', 18)
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
           P = fltrd_cords2 + [0  0  0];
           % filtered_intensities = distances;
           [markerSizesP2] =  scaledScatterData( filtered_intensities2, .1, 10);
           scatter3( P(:,1) , P(:,2) ,P(:,3), markerSizesP2,  filtered_intensities2, 'filled' ) 
                cb=colorbar;
                cb.FontSize = 18;
                title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
                    currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [ 0.625  newBottom currentPosition(3) 0.5 ];

                title( join(["Ml Prediction Vol = ", Volume2, 'cm^{3}', ...
                              newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                ]), 'Fontsize', 18)
                % title( join(["# Pts",    length(fltrd_cords2)   , ...
                %               newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                %                 ]), 'Fontsize', 18)
                C=caxis;
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
           P = fltrd_cords__C;
           opacities = normalizeToRangeOpacities( (fltrd__intnsty__C) )  ;
           % filtered_intensities = distances;
           % [markerSizes] =  scaledScatterData( fltrd__intnsty__C, 1, 10);

           P2 = fltrd_cords2 + [0  0  0];
           % filtered_intensities = distances;
           [markerSizesP2] =  scaledScatterData( filtered_intensities2, .1, 10);
           scatter3( P2(:,1) , P2(:,2) ,P2(:,3), 5, 'filled', 'MarkerFaceColor',   rgb("DarkGreen")) 
           hold on


            scatter3( P(:,1) , P(:,2) ,P(:,3), 10,  fltrd__intnsty__C, 'filled',  'MarkerFaceAlpha', 0.15) 
                cb=colorbar;
                cb.FontSize = 18;
                title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
                    currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [ 0.90   newBottom currentPosition(3) 0.5];
                        % title(hc,'mm', 'FontSize', 20);
                title( join(["Vol Diff= ", (Volume2-Volume), 'cm^{3}', ...
                              newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                ]), 'Fontsize', 18)

                % title( join(["# Pts Diff",  -1.*( length(fltrd_cords) - length(fltrd_cords2)  ) , ...
                %               newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                %                 ]), 'Fontsize', 18)
                % newline,  num2str(minutes), "Min", num2str(seconds), "s", newline,...
                %                ]), 'Fontsize', 18)
                % newline, "Time:", num2str(j)]), 'Fontsize', 18)
                C=caxis;
        axis equal
        %grid off
        %axis off
        hold off
        xlim([-60 60])
        ylim([-60 60])
        zlim([-60 60])

    
        pause(.5)
        set(gcf,'position',[ 50, 50, 1850, 650])    
    
            if SavePlot == "TRUE"
                SavePlotDir = 'D:\VideoFiles\VISEsymp2024\0_FinalRun_ML Model _SPIE';
                SavePlotName = join([ GroundTruthFilesCSV( CaseSelect ).name,"  ", ...
                                      num2str(minutes), "Min", num2str(seconds), "s", ".png"  ])
                saveCurrentPlot(SavePlotDir, SavePlotName)
            end 

    end 
     


    

        

        if strcmp(find_signed_distance, "TRUE")

            % Assume fltrd_cords2 and ground_truth_data are already defined in the workspace
            % Assume find_signed_distance is a parameter in the workspace, which can be "TRUE" or "FALSE"
            % Initialize current index to store results
            current_index = 1; % Start storing from the first row
            A_predicted_data = [fltrd_cords2, filtered_intensities2];
            A_ground_truth_data = [fltrd_cords, filtered_intensities] ;
            %
            [A_predicted_data_sda] = analyzePointClouds(  A_predicted_data, A_ground_truth_data);
            
            % Determine number of rows in predicted_data_sda
            num_rows = size(A_predicted_data_sda, 1);
            
            % Save the output data into Saved_data
            % Ensure there is enough space to store the data in Saved_data
            if current_index + num_rows - 1 <= size(Saved_data, 1)
                Saved_data(current_index:current_index + num_rows - 1, 1:4) = A_predicted_data_sda;
                
                % Update the current_index to reflect the newly added data
                current_index = current_index + num_rows;
            else
                error('Not enough space in Saved_data to store the predicted_data_sda.');
            end
        end




pause(.25)
            if iCreateVideo == "TRUE"
                Frame = getframe(gcf) ;                
                writeVideo(videoWriter,Frame)  
            end
 

Volume_Difference = [Volume_Difference;  ((Volume-Volume2)/Volume *100) ];
Node_Difference = [Node_Difference  ;  ( length(fltrd_cords) - length(fltrd_cords2)  )/(length(fltrd_cords))*100 ];

end 

Volume_Difference_all = [Volume_Difference_all, Volume_Difference];
Node_Difference_all = [Node_Difference_all, [string( bestFileName_full ) ; string( currentFileName) ; 
                                            experimentNumber; Node_Difference]];

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
        ypred_fname = "0_FinalRun__MachineLearning_Vs_GroundTruth";
        %adjust = [.1, ones(1, 13) ] ; 
        Node_Difference_all = Node_Difference_all ;%.* adjust';
        exportDir = 'D:\Import To Matlab\01. Machine Learning Models Data\predict\';
        csvExportName = join([exportDir, ypred_fname, "Volume_pct_Diff",...
                              "RUNS-", num2str(All_Unique_Runs), ".csv"]);
        writematrix(  Node_Difference_all,  csvExportName);
        disp("Data Exported")
        disp( csvExportName )
    end 












    % if export_DIR == "TRUE"
    %     %adjust = [.1, ones(1, 13) ] ; 
    %     Volume_Difference_all = Volume_Difference_all ;%.* adjust';
    %     exportDir = 'D:\Import To Matlab\01. Machine Learning Models Data\predict\';
    %     csvExportName = join([exportDir, ypred_fname, "Volume_pct_Difference___SPIE_2",...
    %                           "RUNS-", num2str(All_Unique_Runs), ".csv"]);
    %     csvwrite( csvExportName, Volume_Difference_all);
    %     disp("Data Exported")
    %     disp( csvExportName )
    % end 



        % 
        % subplot(1,3,3)
        %    if PlotProbes == "TRUE"
        %         plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3),   'k.', 'MarkerSize', 10)  
        %         hold on
        %    end 
        %    P = fltrd_cords;
        %    % filtered_intensities = distances;
        %    scatter3( P(:,1) , P(:,2) ,P(:,3), markerSizesP1,  'b', 'filled', 'MarkerFaceAlpha', 0.5)
        %    hold on
        % 
        % 
        %    P2 = fltrd_cords2 + [0  0  5];
        %    % filtered_intensities = distances;
        %    [markerSizesP2] =  scaledScatterData( filtered_intensities2, .1, 10);
        %    scatter3( P2(:,1) , P2(:,2) ,P2(:,3), markerSizesP2,  'r', 'filled' ) 
        % 
        % 
        % 
        %     title( join(["# Pts Diff",  -1.*( length(fltrd_cords) - length(fltrd_cords2)  ) , ...
        %                   newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
        %                     ]), 'Fontsize', 18)
        %         % newline,  num2str(minutes), "Min", num2str(seconds), "s", newline,...
        %         %                ]), 'Fontsize', 18)
        %         % newline, "Time:", num2str(j)]), 'Fontsize', 18)
        %         C=caxis;
        % axis equal
        % %grid off
        % %axis off
        % hold off
        % xlim([-60 60])
        % ylim([-60 60])
        % zlim([-60 60])




