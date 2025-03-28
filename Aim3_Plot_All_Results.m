clear
clc
close all


    % Specify the directory you want to search in
    %directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII'; % Change this to your directory
    %directoryPath = 'D:\ML COMSOL Models\COMSOL Analysis\COMSOL Model Analysis_I_III_others'
    directoryPath =    'D:\ML COMSOL Models\COMSOL ModerateFat\Ablation Grid'
    ypred_fname =      'D:\ML COMSOL Models\COMSOL ModerateFat\'   
    % Create a pattern to match .mph files
    filePattern = fullfile(directoryPath, '*.csv');
    % Get a list of all files in the directory with .mph extension
    FilesCSV = dir(filePattern);
    %
    % exportDIR = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII\Reprocessed_batch1';
    % %  FALSE   TRUE
    % CreateData = "TRUE";

%


createPlotOne = "F";
createPlot_BoundaryOnly = "TRUE";

Spacing = 2;
[ Points_To_Volume ]   = Aim3_RegGridVolume(  Spacing );

Volume_All = [];

for fi = 1: size(  FilesCSV, 1)


    tic
        
    file_path = fullfile(directoryPath, FilesCSV(fi).name);
    [filepath, fname, fext]  = fileparts(file_path); 
    % Read data from the CSV file
    data = csvread(file_path);
    % Number of chunks
    chunkSize = 4;
    numChunks = size(data, 2) / chunkSize;


All_Intensities = [];
Volume_mat = [];
QuerryPointsOG = data(:, 1:3);

for i = 1: (size(data,2)-3) 




    idx = 2 : 1 : (15*4)+1 ;
    minutes =  floor( (idx(i)*15-15)/60)  +1 ; 
    seconds  = mod( (idx(i)*15-15), 60)    ;

    
    % Step 1: Identification of Negative Intensity Points
    intensity = data(:, i+3);  % Extract intensity values

    

  

    
    createPlotOne = "TRUE";
    if createPlotOne == "TRUE"

        figure(1)
        set(gcf,'position',[ 50, 50, 1850, 650])    
        intensityPlot = intensity; 
        intensityPlot(intensityPlot > 0) = nan;
        %distances(distances < -20) = nan;
            
        [fltrd_cords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, intensityPlot);
        P = fltrd_cords;

        Volume = round( (Points_To_Volume*length(fltrd_cords))/1000, 2); 


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
                %         title(hc,'mm', 'FontSize', 20);
                title( join([ num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                "VOl:",  Volume, 'cm^{3}'  ]), 'Fontsize', 18)


        hold on
        %scatter3( centroid_x,  centroid_y,  centroid_z, 80, 'k', 'filled')
        %cppv_pt_All
        colormap(jet);
        colorbar;
        axis equal;
        %title('Cropped Dataset');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        xlim([-60 60])
        ylim([-60 60])
        zlim([-60 60])


        hold off
        pause(.1)
    end 



    createPlot_BoundaryOnly = "FALSE";
    if createPlot_BoundaryOnly == "TRUE"

        figure(1)
        set(gcf,'position',[ 50, 50, 1850, 650])    
        intensityPlot = intensity; 
        intensityPlot(intensityPlot > 0) = nan;
        %distances(distances < -20) = nan;
            
        [fltrd_cords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, intensityPlot);
         P = fltrd_cords;
         Volume = round( (Points_To_Volume*length(fltrd_cords))/1000, 2); 
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
                %         title(hc,'mm', 'FontSize', 20);
                title( join([ num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                ]), 'Fontsize', 18)


        hold on
        %scatter3( centroid_x,  centroid_y,  centroid_z, 80, 'k', 'filled')
        %cppv_pt_All
        colormap(jet);
        colorbar;
        axis equal;
        title('Cropped Dataset Bound Only');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        xlim([-60 60])
        ylim([-60 60])
        zlim([-60 60])


        hold off
    end 
        
      
 
    
    Volume_mat  =  [Volume_mat; Volume];
    
    
    end 



        


Volume_All  =  [Volume_All, Volume_mat];
end 



export_DIR = "TRUE";
if export_DIR == "TRUE"
   
    %adjust = [.1, ones(1, 13) ] ; 
    export_data = Volume_All ;%.* adjust';
    
    csvExportName = join([ypred_fname, "All_Volume",...
                          "RUNS-", num2str(fi), ".csv"]);
    writematrix(  export_data,  csvExportName);
    disp("Data Exported")
    disp( csvExportName )
end 


