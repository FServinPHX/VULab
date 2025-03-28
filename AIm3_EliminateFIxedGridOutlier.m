





clear
clc
close all


    % Specify the directory you want to search in
    directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII'; % Change this to your directory
    % Create a pattern to match .mph files
    filePattern = fullfile(directoryPath, '*.csv');
    % Get a list of all files in the directory with .mph extension
    FilesCSV = dir(filePattern);
    %
    exportDIR = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII\Reprocessed_batch1';
    %  FALSE   TRUE
    CreateData = "TRUE";

%

for fi = 35 %: size(  FilesCSV, 1)


    tic
        
    file_path = fullfile(directoryPath, FilesCSV(fi).name);
    [filepath, fname, fext]  = fileparts(file_path); 
    % Read data from the CSV file
    data = csvread(file_path);
    % Number of chunks
    chunkSize = 4;
    numChunks = size(data, 2) / chunkSize;


All_Intensities = [];
QuerryPointsOG = data(:, 1:3);

for i = 1: (size(data,2)-3) 




    idx = 2 : 1 : (15*4)+1 ;
    minutes =  floor( (idx(i)*15-15)/60)  +1 ; 
    seconds  = mod( (idx(i)*15-15), 60)    ;



    
     % Assume 'data' is given in the form [x1, y1, z1, intensities]
    % Example of initializing 'data'
    % data = [randn(100, 3) * 10, randn(100, 1) * 5];
    
    % Step 1: Identification of Negative Intensity Points
    intensity = data(:, i+3);  % Extract intensity values
    negative_indices = find(intensity < 0);  % Indices of negative intensity values
    
    % Step 2: Selection of Specific Negative Intensity Range
    specific_negative_indices = negative_indices(intensity(negative_indices) >= -2.5);
    
    % Step 3: Center Calculation
    if ~isempty(specific_negative_indices)
        % Extract the points
        x_points = data(specific_negative_indices, 1);
        y_points = data(specific_negative_indices, 2);
        z_points = data(specific_negative_indices, 3);
    
        % Calculate the centroid
        centroid_x = mean(x_points);
        centroid_y = mean(y_points);
        centroid_z = mean(z_points);
    
        centroid = [centroid_x, centroid_y, centroid_z];
        %fprintf('Centroid: [%.2f, %.2f, %.2f]\n', centroid_x, centroid_y, centroid_z);
    else
        centroid = [NaN, NaN, NaN];
        fprintf('No points found in the specified negative intensity range.\n');
    end
    


    % Step 4: Reassessment of Intensity Values of all negative indicies

    distance_threshold = 15 + 10*(i/58)   ; 
    if ~isempty(negative_indices)


        % Calculate the mean intensity of negative values
        negative_values = intensity(negative_indices);
        mean_negative_intensity = median(intensity(negative_indices));
    

        % Find points from step 2 that are less than the median intensity
        low_intensity_indices = negative_indices(intensity(negative_indices) < mean_negative_intensity);


        x_points2 = data(low_intensity_indices, 1);
        y_points2 = data(low_intensity_indices, 2);
        z_points2 = data(low_intensity_indices, 3);


    
        % Calculate distances from the centroid
        distances = sqrt((x_points2 - centroid_x).^2 + (y_points2 - centroid_y).^2 + (z_points2 - centroid_z).^2);
    
        % Find points that are further than 15 units from the centroid
        far_points_indices = low_intensity_indices(distances > distance_threshold);
    
        % Update their intensities to positive if both conditions are met
        intensity(far_points_indices) = abs(intensity(far_points_indices));
    
        % Update the original data with the new intensity values
        %data(:, 4) = intensity;
        %fprintf('Intensities of points %s have been made positive.\n', mat2str(far_points_indices));
    else
        %fprintf('No adjustments made to intensity values.\n');
    end




    
    % Define your threshold
    threshold = -4 - 15*(i/50);
    if threshold < -18
        thresshold = -18;
    end 
    % Identify indices where intensity is less than the threshold
    below_threshold_indices = find(intensity < threshold);
    % Change these intensity values to positive
    intensity(below_threshold_indices) = abs(intensity(below_threshold_indices));



    
    createPlotOne = "TRUE";
    if createPlotOne == "TRUE"

        figure(1)
        set(gcf,'position',[ 50, 50, 1850, 650])    
        intensityPlot = intensity; 
        intensityPlot(intensityPlot > 0) = nan;
        %distances(distances < -20) = nan;
            
        [fltrd_cords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, intensityPlot);
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
                %         title(hc,'mm', 'FontSize', 20);
                title( join([ num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                ]), 'Fontsize', 18)


        hold on
        scatter3( centroid_x,  centroid_y,  centroid_z, 80, 'k', 'filled')
        %cppv_pt_All
        colormap(jet);
        colorbar;
        axis equal;
        title('Cropped Dataset');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        xlim([-60 60])
        ylim([-60 60])
        zlim([-60 60])


        hold off
    end 
    
    
        
        All_Intensities = [ All_Intensities, intensity ];
    
    
    
    end 



        DataExport = [ QuerryPointsOG, All_Intensities];

    % Output file path
    
    if CreateData == "TRUE"
    
        [~, name, ext] = fileparts(file_path);
        %outputFileName = fullfile(exportDIR, sprintf('Distance Mask_%s%s', name, ext));
        name = join([fname, '__ReFilled.csv' ])    ;
        outputFileName = fullfile(exportDIR,  name);
        % Write the results to a new CSV file
        csvwrite(outputFileName, DataExport);
    end 




end 



