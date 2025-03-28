clear
clc



% Specify the directory you want to search in
directoryPath = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2'; % Change this to your directory
% Create a pattern to match .mph files
filePattern = fullfile(directoryPath, '*.csv');
% Get a list of all files in the directory with .mph extension
FilesCSV = dir(filePattern);
%
exportDIR = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2 Rotate All';


for fi = 1: size(  FilesCSV, 1)
    
    file_path = fullfile(directoryPath, FilesCSV(fi).name);
    [filepath, fname, fext]  = fileparts(file_path); 



    %angles = [0, 60, 120, 220];
    angles = [ 20, 80, 300];

    for j = 1:3

        CurrentAngle = angles(j);
        rotate_and_visualize_csv(file_path,   exportDIR,    CurrentAngle);
    end 

end 



function rotate_and_visualize_csv(inputFileName, outputDirectory, degreeRotation)
    % Read data from the CSV file
    data = csvread(inputFileName);
    
    % Number of chunks
    chunkSize = 6;
    numChunks = size(data, 2) / chunkSize;

    % Rotation angle in degrees and convert to radians
    theta = degreeRotation * pi / 180;
    
    % Rotation matrix around the z-axis
    Rz = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
    
    % Initialize array to store all points and vectors after rotation
    allPoints = [];

    % Handle each chunk of 6 columns
    %figure;
    viewA = 45;
    viewB = 20;
    for i = 1:numChunks
        % Extract points and vectors
        startIndex = (i - 1) * chunkSize + 1;
        endIndex = startIndex + chunkSize - 1;
        chunkData = data(:, startIndex:endIndex);
        points = chunkData(:, 1:3);
        vectors = chunkData(:, 4:6);
        
        % Find the center of the points to establish the origin
        origin = mean(points);
        
        % Translate points to the origin
        translatedPoints = points - origin;
        
        % Rotate points and vectors
        rotatedPoints = (Rz * translatedPoints')';
        rotatedVectors = (Rz * translatedPoints')';
        
        % Translate points back from the origin
        rotatedPoints = rotatedPoints + origin;
        rotatedVectors = rotatedVectors + origin;

        
        % Append results
        allPoints = [allPoints, round(rotatedPoints, 3) , round( rotatedVectors, 3)];
        


        plot_Vectors = "FALSE";
        if plot_Vectors == "TRUE"
            % Visualization
            nVs = zeros(size(rotatedVectors));
            minMag = 1.5;
            maxMag = 2.25;
            minOriginalMag = min(vecnorm(rotatedVectors, 2, 2));
            maxOriginalMag = max(vecnorm(rotatedVectors, 2, 2));
            for jj = 1:size(nVs)
                oldMag = norm(rotatedVectors(jj, :));
                % Scale magnitude from [minOriginalMag, maxOriginalMag] to [minMag, maxMag]
                newMag = minMag + (maxMag - minMag) * ((oldMag - minOriginalMag) / (maxOriginalMag - minOriginalMag));
                %
                % Generate a random number between 0.1 and 0.4
                randomNumber = 0.1 + (0.8-0.1).*rand(1,1);
                nVs(jj, :) = (rotatedVectors(jj, :) / oldMag) * (newMag+ randomNumber);
            end
    
           
                quiver3(points(:,1), points(:,2), points(:,3), ...
                        vectors(:,1), vectors(:,2), vectors(:,3), 'Color', 'b');
                hold on
                quiver3(rotatedPoints(:,1), rotatedPoints(:,2), rotatedPoints(:,3), ...
                        nVs(:,1), nVs(:,2), nVs(:,3), 'Color', 'r');
                hold off;
                title(sprintf('Chunk %d: Original and Rotated Points and Vectors', i));
                xlabel('X'); ylabel('Y'); zlabel('Z');
                legend('Original', 'Rotated');
                axis equal
        
    
            hold off
            view(viewA, viewB)
            pause(.25)
        end 


    end

    % Output file path
    [~, name, ext] = fileparts(inputFileName);
    outputFileName = fullfile(outputDirectory, sprintf('%ddegree_%s%s', degreeRotation, name, ext));
    
    % Write the results to a new CSV file
    csvwrite(outputFileName, allPoints);
end



