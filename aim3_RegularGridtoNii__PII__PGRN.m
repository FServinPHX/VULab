


clear
clc
close all


    % Specify the directory you want to search in
    directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1'; % Change this to your directory
    % Create a pattern to match .mph files
    filePattern = fullfile(directoryPath, '*.csv');
    % Get a list of all files in the directory with .mph extension
    FilesCSV = dir(filePattern);
    %
    %exportDIR = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2 Resampled';
    exportDIR = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1 Resampled II';
    %  FALSE   TRUE
    CreateData = "TRUE";

%
for fi = 1:10 % size(  FilesCSV, 1)


    tic
        
    file_path = fullfile(directoryPath, FilesCSV(fi).name);
    [filepath, fname, fext]  = fileparts(file_path); 
    % Read data from the CSV file
    data = csvread(file_path);
    % Number of chunks
    chunkSize = 4;
    numChunks = size(data, 2) / chunkSize;




All_Intensities = [];
for i = 1: (size(data,2)-3) 


    
    %
    
    Control_Plot = ["FALSE", "FALSE", "FALSE", "FALSE"];
    
    
    
    % Assuming QuerryPointsOG and distances are given as input
    % Step 1: Create a search parameter that finds the x, y, z minimum and maximum values that include all points with distances <= 0

    QuerryPointsOG  = data( :, 1:3);
    distances = data( :, i+3);    
    x1 = QuerryPointsOG(:, 1);
    y1 = QuerryPointsOG(:, 2);
    z1 = QuerryPointsOG(:, 3);
    
    % Find the bounding box of the points with distances <= 0
    min_x = min(x1(distances <= 0));
    max_x = max(x1(distances <= 0));
    min_y = min(y1(distances <= 0));
    max_y = max(y1(distances <= 0));
    min_z = min(z1(distances <= 0));
    max_z = max(z1(distances <= 0));
    
    % Crop the data
    croppedIndices = (x1 >= min_x) & (x1 <= max_x) & (y1 >= min_y) & (y1 <= max_y) & (z1 >= min_z) & (z1 <= max_z);
    cropped_x = x1(croppedIndices);
    cropped_y = y1(croppedIndices);
    cropped_z = z1(croppedIndices);
    cropped_distances = distances(croppedIndices);
    
    % Step 2: Visualize the new cropped dataset
    
    plot1 = Control_Plot(1);
    if plot1 == "TRUE"
        figure(1);
        scatter3(cropped_x, cropped_y, cropped_z, 36, cropped_distances, 'filled');
        colormap(jet);
        colorbar;
        axis equal;
        title('Cropped Dataset');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
    end 
    
    % Step 3: Find the 'lower third center' 
    % Lower third center is the center of the lower third of z values
    
    sorted_z = sort(cropped_z);
    num_points = numel(sorted_z);
    lower_third_z = sorted_z(1:floor(num_points/3));
    
    center_x = mean(cropped_x(cropped_z <= max(lower_third_z)));
    center_y = mean(cropped_y(cropped_z <= max(lower_third_z)));
    center_z = mean(lower_third_z);
    
    
    %
    NumberChangeCount = 0;
    cppv_pt_All = [];



    for k = 1:5
    
    % Step 4.0: Find the value that represents the x% lowest value in the negative distances
    negative_distances = cropped_distances(cropped_distances < 0);
    threshold_value = prctile(negative_distances, 5);
    
    % Step 4.1: Find all points with a value equal to or lower than this value
    low_value_indices = find(cropped_distances <= threshold_value);

    center  = 
    
    % Step 4.2: Loop through all points, for each point, find the nearest 10 points
    for i = 1:length(low_value_indices)
        pi = low_value_indices(i);
        current_point = [cropped_x(pi), cropped_y(pi), cropped_z(pi)];
        current_distance = cropped_distances(pi);
        
        % Compute distances to all points
        distances_to_all_points = sqrt((cropped_x - current_point(1)).^2 + ...
                                       (cropped_y - current_point(2)).^2 + ...
                                       (cropped_z - current_point(3)).^2);

        center_to_all_points = 
        
        % Sort by distance and get the nearest 10 points
        [~, sorted_indices] = sort(distances_to_all_points);
        nearest_10_indices = sorted_indices(2:11);  % Exclude the point itself
        
        % Step 4.3: Check if any of these points have a positive distance value
        for j = 1:length(nearest_10_indices)
            cppv = nearest_10_indices(j);
    
            cppv_pt = [ cropped_x(cppv),   cropped_y(cppv),  cropped_z(cppv) ];

            distance_from_center = sqrt( (cropped_x(cppv) -   center_x).^2 + ... 
                                    (cropped_y(cppv) -   center_y ).^2 + ...
                                    (cropped_z(cppv) -   center_z ).^2 );
    
            if cropped_distances(cppv) > 0 && current_distance < -4  && distance_from_center < 10
                % Step 4.4: Calculate the new distance value
                distance_between = distances_to_all_points(cppv);
                new_distance_value = current_distance - distance_between;
                
                % Update the distance value of the current positive point
                cropped_distances(cppv) = new_distance_value;
    
                NumberChangeCount = NumberChangeCount + 1;
    
                cppv_pt_All = [cppv_pt_All; [cppv_pt, new_distance_value]];
            end
        end
    end
    disp("Total Numbers Changed")
    disp(NumberChangeCount)
    end 
    
    
    
    cropped_data = [cropped_x, cropped_y, cropped_z, cropped_distances];
    original_data = [ x1, y1, z1, distances] ;
    
    
    % Assuming the following structure for the data matrices:
    % cropped_data: [cropped_x, cropped_y, cropped_z, cropped_distances]
    % original_data: [x1, y1, z1, distances]
    
    % Sample data for demonstration purposes (replace with actual data)
    % cropped_data = [x, y, z, intensity];
    % original_data = [x1, y1, z1, distances];
    
    % Extract the coordinates and intensity values from cropped_data
    cropped_x = cropped_data(:, 1);
    cropped_y = cropped_data(:, 2);
    cropped_z = cropped_data(:, 3);
    cropped_distances = cropped_data(:, 4);
    
    % Extract the coordinates and intensity values from original_data
    x1 = original_data(:, 1);
    y1 = original_data(:, 2);
    z1 = original_data(:, 3);
    distances2 = original_data(:, 4);
    
    % Iterate over each point in cropped_data
    for i = 1:size(cropped_data, 1)
        % Get the current cropped point coordinates and intensity
        cx = cropped_x(i);
        cy = cropped_y(i);
        cz = cropped_z(i);
        cd = cropped_distances(i);
        
        % Find the corresponding point in original_data
        index = find(x1 == cx & y1 == cy & z1 == cz);
        
        if ~isempty(index)
            % Replace the intensity value in original_data
            distances2(index) = cd;
        else
            % If exact point is not found, display the unmatched point coordinates and intensity
            fprintf('Unmatched Point: (x: %f, y: %f, z: %f, intensity: %f)\n', cx, cy, cz, cd);
        end
    end
    
    % Update the original_data matrix with the new distances
    original_data(:, 4) = distances2;
    
    
    
    
    
    
    
        plot2 = Control_Plot(2);
        if plot2 == "TRUE"
            % Visualize the final results using a 3D scatter plot with colorbar
            figure(2);
            scatter3( x1, y1, z1, 36, original_data(:, 4), 'filled');
            colormap(jet);
            colorbar;
            axis equal;
            title('Points Changed');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
            
        end 
    
    
        % Save the plotted figure for reference if required
        % saveas(gcf, 'final_results.png');
        
        plot3 = Control_Plot(3);
        if plot3 == "TRUE"
            figure(3);
            scatter3(cropped_x, cropped_y, cropped_z, 36, cropped_distances, 'filled');
            colormap(jet);
            colorbar;
            axis equal;
            title('Cropped Dataset');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
        end 
        
        plot4 = Control_Plot(4);
        if plot4 == "TRUE"
            figure(4)
            % center_x = mean(cropped_x(cropped_z <= max(lower_third_z)));
            % center_y = mean(cropped_y(cropped_z <= max(lower_third_z)));
            % center_z = mean(lower_third_z);
            scatter3( center_x,  center_y,  center_z, 80, 'k', 'filled')
            
            
            hold on
            %cppv_pt_All
            scatter3(   cppv_pt_All(:, 1),   cppv_pt_All(:, 2),   cppv_pt_All(:, 3), ...
                        36, cppv_pt_All(:, 4), 'filled')
            colormap(jet);
            colorbar;
            axis equal;
            title('Cropped Dataset');
            xlabel('X');
            ylabel('Y');
            zlabel('Z');
        
        end 


All_Intensities = [ All_Intensities, original_data(:, 4) ];
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
