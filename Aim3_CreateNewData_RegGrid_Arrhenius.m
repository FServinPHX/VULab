


clc
clear
close all

% Example value for theta_d
theta_d = 0.98;
% Calculate alpha
alpha = -log(1 - theta_d);
% Display the result
disp(['The value of alpha is: ', num2str(alpha)]);

%%
clc
clear
close all



        
    VoxSize = [120, 120, 120 ] ;
    intensitySpc = 2;
    [ QuerryPointsOG, Points_To_Volume]  = CreateRegularGrid( VoxSize, intensitySpc  );
        
        
        Show_True_Results = 1;
        iCreateVideo = "F";
        NumberRuns = 1; 
        shiftExp = 7.5;
        %     FALSE     TRUE
        plot_Results = "FALSE";
        CreateData = "TRUE"   ;
  
    % Specify the directory you want to search in
    %
    %   D:\ML COMSOL Models\COMSOL Files
    %   D:\ML COMSOL Models\COMSOL Files\Completed Pt II
    %   D:\ML COMSOL Models\COMSOL Files II\COMPLETED
    %
    directoryPath = 'D:\ML COMSOL Models\COMSOL Files II\COMPLETED'; % Change this to your directory
    % Create a pattern to match .mph files
    filePattern = fullfile(directoryPath, '*.csv');
    % Get a list of all files in the directory with .mph extension
    FilesCSV = dir(filePattern);
    %
    exportDIR = 'D:\Import To Matlab\COMSOL__Structured Grid__Electric_Field';

%%
% Suppress all warnings
warning('off', 'all');


%figure() 

for fi = 52: size(  FilesCSV, 1)

    tic



        file_path = fullfile(directoryPath, FilesCSV(fi).name);
        [filepath, fname, fext]  = fileparts(file_path); 
        % Read data from the CSV file
        
        xtname  =   file_path;
        X_train_Data = readmatrix(xtname);
        % Assume 'X_train_Data' is the original X_train_Dataset. It can be loaded or defined here.
        % Here is an example definition for demonstration:
        % X_train_Data = rand(100, 20);  % 100 rows and 20 columns of random numbers
        % Step 1: Select the first 3 columns from the X_train_Dataset
        firstThreeCols = X_train_Data(:, 1:3);
        % Step 2: Select columns from 5th until the end, skipping one each time (5, 7, 9, ...)
        % Determine the columns to select, starting from 5 
        % and skipping every other column until the end of the array dimension size
        
        
        %colsToSelect = 5:2:size(X_train_Data, 2);
        colsToSelect = 4:2:size(X_train_Data, 2);
        % Select the identified columns
        selectedCols = X_train_Data(:, colsToSelect);
        % Combine the selected columns into a new X_train_Dataset
        newX_train_Dataset = [firstThreeCols, selectedCols];
        % Display the new X_train_Dataset
        %disp('Newly formed X_train_Dataset based on specified column selection:');



%

    DataExport = [];
 for j =    1: ( size(newX_train_Dataset,2) -3)  % 4
    



    P = newX_train_Dataset(:, 1:3);
    filtered_intensities = newX_train_Dataset(:, j+3);
    B_intensities = interpolatePointCloudIntensity( [P, filtered_intensities]  , QuerryPointsOG);




    if plot_Results == "TRUE"
         figure(1)
         set(gcf,'color','w');                
            %Find the triangulation of the Interogation Boundary Points 
           subplot(1,2,1)
           % filtered_intensities = distances;
            scatter3( P(:,1) , P(:,2) ,P(:,3), 10,  filtered_intensities, 'filled' ) 
                cb=colorbar;
                cb.FontSize = 18;
                title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
                    currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [currentPosition(1)*1.3 newBottom currentPosition(3) newHeight];
                %         title(hc,'mm', 'FontSize', 20);
                %title( join(["Vol = ", Volume, 'cm^{3}']), 'Fontsize', 18)
                %C=caxis;
        axis equal
        %grid off
        %axis off
        hold off
        % xlim([-35 35])
        % ylim([-35 35])
        % zlim([-50 50])



        subplot(1,2,2)
           % filtered_intensities = distances;
            scatter3( QuerryPointsOG(:,1) , QuerryPointsOG(:,2) ,QuerryPointsOG(:,3), ...
                      10,  B_intensities, 'filled' ) 
                cb=colorbar;
                cb.FontSize = 18;
                title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
                    currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [.90 newBottom currentPosition(3) newHeight];
                %         title(hc,'mm', 'FontSize', 20);
                % title( join(["Vol = ", Volume2, 'cm^{3}']), 'Fontsize', 18)
                % C=caxis;
            axis equal
            grid off
            axis off
            hold off
            % xlim([-40 40])
            % ylim([-40 40])
            % zlim([-50 50])
    
            pause(.25)
   



        set(gcf,'position',[ 250, 100, 1450, 650])    
    end 

    DataExport = [ DataExport,   round( B_intensities, 1) ];
    pause(10)
end 





    DataExport = [QuerryPointsOG,  DataExport]; 
    % Output file path
    if CreateData == "TRUE"
        [~, name, ext] = fileparts(file_path);
        outputFileName = fullfile(exportDIR, sprintf('Electric Field Mask_%s%s', name, ext));
        % outputFileName = fullfile(exportDIR, sprintf('%ddegree_%s%s', angleDegrees, name, ext));
        % Write the results to a new CSV file
        csvwrite(outputFileName, DataExport);
    end 
    %
    %
    pause(100)





    toc
end 




% Turn warnings back on
warning('on', 'all');


















