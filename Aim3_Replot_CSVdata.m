











clear
clc
close all


    % Specify the directory you want to search in
    directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1 Resampled II'; % Change this to your directory
    % Create a pattern to match .mph files
    filePattern = fullfile(directoryPath, '*.csv');
    % Get a list of all files in the directory with .mph extension
    FilesCSV = dir(filePattern);
    %
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




    
idx = 2 : 1 : (15*4)+1 ;
minutes =  floor( (idx(j)*15-15)/60)  +1 ; 
seconds  = mod( (idx(j)*15-15), 60)    ;




distances(distances > 0) = nan;
distances(distances < -20) = nan;
    
[fltrd_cords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, distancesIn);


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
                %         title(hc,'mm', 'FontSize', 20);
                title( join(["Vol = ", Volume, 'cm^{3}', ...
                              newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
                                ]), 'Fontsize', 18)

                %  newline, num2str(minutes), "Min", num2str(seconds), "s", newline,...
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


end 

