
clear
clc 


%CaseSelect = 23 % to 29

for CaseSelect = 33


%for  CaseSelect = 5:10



[xtname, Ytname, yPred_Name, pVoxVoxSize, QuerryPointsOG_Import, ...
    chunk_size, maskTypeNum, VideoName, export_DIR] =  Aim3MachineLearningCaseSelection(CaseSelect) ;


%     FALSE     TRUE
export_DIR = "FALSE" ;

    %X_train_Data = readmatrix(xtname);
    y_train_Data = readmatrix(Ytname);
    [ypred_filepath, ypred_fname,ypred_fext]  = fileparts(yPred_Name);
    y_pred_Data = readmatrix(yPred_Name);







        intensity.spc = 2;
        %Create the Box Phantom Model
        %pVox.VoxSize = [80, 80, 80 ] ;
        %pVox.VoxSize = [100, 100, 100 ] ;
        num_points = 1000;
        theta = 2 * pi * rand(num_points, 1);
        phi = acos(2 * rand(num_points, 1) - 1);
        radius = 30;
        x = radius * sin(phi) .* cos(theta);
        y = radius * sin(phi) .* sin(theta);
        z = radius * cos(phi);
        points = [x y z];
    %
    pVox.VoxSize = pVoxVoxSize
    center = [0,0,0]- (pVox.VoxSize/2) ;
    %Choose where to start and end 
    strt = [0, 0, 0];
    endd = [0,0,0];
    %      
    %
    pVox.points = [0 0 0; 0 0 0];
    pVox.Volxelx = [ center(1) +  pVox.VoxSize(1)*strt(1) :pVox.VoxSize(1): pVox.VoxSize(1)*endd(1)  +  center(1)  ] ;
    pVox.Volxely = [ center(2) +  pVox.VoxSize(2)*strt(2) :pVox.VoxSize(2): pVox.VoxSize(2)*endd(2)  +  center(2)  ] ;
    pVox.Volxelz = [ center(3) +  pVox.VoxSize(3)*strt(3) :pVox.VoxSize(3): pVox.VoxSize(3)*endd(3)  +  center(3)  ] ;
    %  
        [intensity.X,intensity.Y,intensity.Z] = ...
            meshgrid( pVox.Volxelx : intensity.spc : abs(pVox.Volxelx),...
            pVox.Volxely : intensity.spc :abs(pVox.Volxely), ...
            pVox.Volxelz : intensity.spc :abs(pVox.Volxelz) ) ;
        %
        intensity.X = reshape(intensity.X, [],1);
        intensity.Y = reshape(intensity.Y, [],1);
        intensity.Z = reshape(intensity.Z, [],1);
        intensity.a = 1;
        intensity.b = 50;
        intensity.I = (intensity.b-intensity.a).*rand(length(intensity.X),1) + intensity.a;
        %      
            dimension = length(pVox.Volxelx : intensity.spc : abs(pVox.Volxelx)); 
            TargetPoints = points ;
            QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
            center = [0,0,0];
            [ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  center ) ; 
        %
            distancesIn = distances;
            distancesIn(distancesIn > 0) = nan;
            [fltrd_cords, filtered_intensities] = ...
                    Global_remove_nan_intensity(QuerryPointsOG, distancesIn);
        %
        distances(distances >0) = 1;
        distances(distances <0) = -1;
        Volume = (4/3) * pi * radius^3; 
        Points_To_Volume = Volume/ length(fltrd_cords);
        Volume = round( (Volume/1000), 2);
    %
%QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
QuerryPointsOG = [];

    % Check if the variable "QuerryPointsOG_Import" exists
    if exist('QuerryPointsOG_Import', 'var')
        % Check if "QuerryPointsOG_Import" is not empty
        if ~isempty(QuerryPointsOG_Import)
            % Assign "QuerryPointsOG" the same data as "QuerryPointsOG_Import"
            QuerryPointsOG = QuerryPointsOG_Import;
            fprintf('Variable "QuerryPointsOG_Import" exists.\n');
        else
            fprintf('Variable "QuerryPointsOG_Import" is empty.\n');
        end
    else
        fprintf('Variable "QuerryPointsOG_Import" does not exist.\n');
    end
    
    
    
    % Check if the variable "QuerryPointsOG_Import" exists
    if exist('scaleData', 'var')
        % Check if "QuerryPointsOG_Import" is not empty
        if ~isempty(QuerryPointsOG_Import)
            % Assign "QuerryPointsOG" the same data as "QuerryPointsOG_Import"
            
            y_pred_Data = y_pred_Data.*scaleData; 
            fprintf('Variable scaleData" exists.\n');
        else
            fprintf('Variable "scaleData" is empty.\n');
        end
    else
        fprintf('Variable "scaleData" does not exist.\n');
    end


        


    
%_________________________________________________________________________________%
%_________________________________________________________________________________%
%_________________________________________________________________________________%
%_________________________________________________________________________________%
%_________________________________________________________________________________%

pause(1)



  Show_True_Results = 1;
  NumberRuns = 10; 
  MaskType_All = ["Distance", "Binary", "ElectricField"];
  MaskType = MaskType_All(   maskTypeNum   );
  shiftExp = 0;  







 %   Case: 1  or 2 
 %   case 1: (ALL)              DataSimulate = maxchunk      
 %   case 2: (SELECT FEW)       DataSimulate = hunk_size*NumberRuns 
Data_Run = 2;
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









for mltbI = 1:Show_True_Results


        if iCreateVideo == "TRUE"
            Video_Dir = "D:\VideoFiles\COMSOL Ablation Vectors\";
            Video_FileName = join([ VideoName,'.avi']);
            Video_FileName = convertStringsToChars(Video_FileName);
            Video_fullfile = fullfile(Video_Dir, Video_FileName);
            videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
            videoWriter.FrameRate = 2.5;
            videoWriter.Quality = 100; % High quality video
            open(videoWriter);
        end
        
        
        total_rows = size(y_train_Data, 1);
        %chunk_size = length(QuerryPointsOG);
        Volume_Difference_all = [];
        Node_Difference_all = [];
        

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
        All_Unique_Runs =   floor( DataSimulate/ chunk_size);





for start = 1:   chunk_size:     DataSimulate   %     maxchunk      chunk_size*NumberRuns 



    RunSeg = floor( start/ chunk_size ); 
    Volume_Difference = [];
    Node_Difference = [];
    %
for j =    1:  4:  (size(y_train_Data, 2)-1)  % 52



         
        idx = 2 : 1 : (15*4)+1 ;
        minutes =  floor( (idx(j)*15-15)/60)  +1 ; 
        seconds  = mod( (idx(j)*15-15), 60)    ;

        a = (j*3) + 1;
        b = (j*3) + 3;
        viewA = 45 + j*3;
        viewB = 55;
        finish = start + chunk_size -1;



        distancesIn = y_train_Data(start:finish, j);
        PredictionMask = y_pred_Data(start:finish, j);




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
                        ExportBinary = y_pred_Data(start:finish, j);
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


            z_threshold_lower = -15;
            z_Threshold_upper = 47.25;
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
        %
    if plot_Results == "TRUE"
    figure(1)
    
        set(gcf,'color','w');                
            %Find the triangulation of the Interogation Boundary Points 



           subplot(1,3,1)
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




                title( join(["Vol = ", Volume, 'cm^{3}', ...
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
           P = fltrd_cords2;
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



                title( join(["Vol = ", Volume2, 'cm^{3}', ...
                              newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                ]), 'Fontsize', 18)

    
                % title( join(["# Pts",    length(fltrd_cords2)   , ...
                %               newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                %                 ]), 'Fontsize', 18)
                % 

                C=caxis;
                axis equal
                %grid off
                %axis off
                hold off
                xlim([-60 60])
                ylim([-60 60])
                zlim([-60 60])


        %               fltrd_cords__C,   fltrd__intnsty__C
        subplot(1,3,3)
           P = fltrd_cords__C;
           % filtered_intensities = distances;
            
           % [markerSizes] =  scaledScatterData( fltrd__intnsty__C, 1, 10);


            scatter3( P(:,1) , P(:,2) ,P(:,3), 10,  fltrd__intnsty__C, 'filled' ) 
                
                cb=colorbar;
                cb.FontSize = 18;
                title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
                    currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [ 0.90   newBottom currentPosition(3) 0.5];
                %         title(hc,'mm', 'FontSize', 20);


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



        pause(3)
        set(gcf,'position',[ 50, 50, 1850, 650])    


        SavePlot = "TRUE";
        if SavePlot == "TRUE"
            %D:\VideoFiles\VISEsymp2024\ML Model
            SavePlotDir = 'D:\VideoFiles\VISEsymp2024\ML Model';
            SavePlotName = join([  "Position  ", RunSeg,...
                                  num2str(minutes), "Min", num2str(seconds), "s", ".png"  ])
            saveCurrentPlot(SavePlotDir, SavePlotName)
        end 

    end 
        
pause(.25)
            if iCreateVideo == "TRUE"
                Frame = getframe(gcf) ;                
                writeVideo(videoWriter,Frame)  
            end 
%  

Volume_Difference = [Volume_Difference;  ((Volume-Volume2)/Volume *100) ];

Node_Difference = [Node_Difference  ; ( length(fltrd_cords) - length(fltrd_cords2)  )/(length(fltrd_cords))*100 ];
end 

Volume_Difference_all = [Volume_Difference_all, Volume_Difference];
Node_Difference_all = [Node_Difference_all, Node_Difference];
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
    
    if export_DIR == "TRUE"
        %adjust = [.1, ones(1, 13) ] ; 
        Node_Difference_all = Node_Difference_all ;%.* adjust';
        exportDir = 'D:\Import To Matlab\01. Machine Learning Models Data\predict\';
        csvExportName = join([exportDir, ypred_fname, "Volume_pct_Diff",...
                              "RUNS-", num2str(All_Unique_Runs), ".csv"]);
        csvwrite( csvExportName, Node_Difference_all);
        disp("Data Exported")
        disp( csvExportName )
    end 




end 



end 





%end 
