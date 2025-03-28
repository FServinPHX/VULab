


clc
clear
close all




  % Specify the directory you want to search in
    %directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII'; % Change this to your directory
    %directoryPath = 'D:\ML COMSOL Models\COMSOL Analysis\COMSOL Model Analysis_I_III_others'
    directoryPath =    'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data\AllData\'
    resultsDir1 = 'D:\ML COMSOL Models\0.0 Linked Ablation Points Test'     ; 
    resultsDir2 = 'D:\ML COMSOL Models\0.0 Linked Ablation Vector Test'     ;
    % Create a pattern to match .mph files
    filePattern = fullfile(directoryPath, '*.csv');
    % Get a list of all files in the directory with .mph extension
    FilesCSV = dir(filePattern);
    %
    % exportDIR = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII\Reprocessed_batch1';
    % %  FALSE   TRUE
    % CreateData = "TRUE";
    WriteData = "TRUE";

%




for fi = 4:10 % size(  FilesCSV, 1)


tic
    
file_path = fullfile(directoryPath, FilesCSV(fi).name);
[filepath, fname, fext]  = fileparts(file_path); 
% Read data from the CSV file
data = readmatrix(file_path);
% Number of chunks
chunkSize = 4;
numChunks = size(data, 2) / chunkSize;
%
%
% Find indices of columns to exclude (every 4th column)
colsToExclude = 4:4:size(data, 2);
% Exclude the specified columns
processedData = data;
processedData(:, colsToExclude) = [];
processedData(1,:) = [];
%num.AllPts = processedData;
%
%
[sortedPoints, indices] = processPointCloud( processedData(:, 1:3)  )  ;
sortedData = processedData(indices, :);
num.AllPts  =  sortedData;

    %
    %
    %
    figure(1) 
    set(gca,'color', 'w' );
    set(gcf,'color', 'w' );
    % subplot( 2, 1,1)     
    view( -5 ,5)
    % xlim([-50, 50])
    % ylim([-50, 50])
    % zlim([-50, 50]) 
    num.AllPtsReorganized  = [];
    tol = 3; 
    % start = min(idx);
    % endpoint = max(idx);
    
    Original_Distances_All = []; 
    distances_to_Z_All = []; 
    All_Vectors = [];
    
    for i = 1 : (( size(num.AllPts, 2)/3 )  -2) %length(idx)-1
        
        if i == 1
            X1 = num.AllPts(:, (i-1)*3+1 ); 
            Y1 = num.AllPts(:, (i-1)*3+2 ); 
            Z1 = num.AllPts(:, (i-1)*3+3 ); 
        else 
            X1 = pointcloud_Z(:,1); 
            Y1 = pointcloud_Z(:,2); 
            Z1 = pointcloud_Z(:,3);         
        end
        j = i+1;
        X2 = num.AllPts(:, (j-1)*3+1 ); 
        Y2 = num.AllPts(:, (j-1)*3+2 ); 
        Z2 = num.AllPts(:, (j-1)*3+3 );
        pointcloud_A = [X1, Y1, Z1];
        pointcloud_B = [X2, Y2, Z2];
            


        % subplot( 2,1,1)  
        
       


        %[pointcloud_Z] = Aim3MatchPCMultSampl(pointcloud_A, pointcloud_B, tol ) ;
        pointcloud_Z = pointcloud_B;
        %[pointcloud_Z] = Aim3MatchPCMultSampl_GBT(pointcloud_A, pointcloud_B, tol)
        
        distances_to_Z = sqrt(sum((pointcloud_Z - pointcloud_A).^2, 2));
        Original_Distances = sqrt(sum((pointcloud_B - pointcloud_A).^2, 2));


        Vector_to_z  = (pointcloud_Z - pointcloud_A);
        All_Vectors = [  All_Vectors,   Vector_to_z    ]    ;
        
        

        % num.AllPtsReorganized = [num.AllPtsReorganized , X1, Y1 , Z1  ]; 
        
        
        %     subplot( 2,1,2)  
        %     view( -5 ,5)
        %     hold on
        %     X3 = num.AllPts(:, (i-1)*3+1 ); 
        %     Y3 = num.AllPts(:, (i-1)*3+2 ); 
        %     Z3 = num.AllPts(:, (i-1)*3+3 );    
        %     plot3( X3, Y3, Z3, '.')
        %     axis equal
        %     pause(.5)
            
        %     xlim([-50, 50])
        %     ylim([-50, 50])
        %     zlim([-50, 50]) 
        distances_to_Z_All = [distances_to_Z_All, distances_to_Z]; 
        Original_Distances_All = [Original_Distances_All, Original_Distances]; 
        
        % Frame = getframe(gcf) ;                
        % writeVideo(writerObj,Frame)   
    
        
        
        
        %plot3( X2, Y2, Z2, '.')
       
        X1 = pointcloud_Z(:,1); 
        Y1 = pointcloud_Z(:,2); 
        Z1 = pointcloud_Z(:,3);   
       % Plotting the quiver3 plot with true vector lengths
        plot3( pointcloud_A(:, 1), pointcloud_A(:, 2), pointcloud_A(:, 3), 'k.')
        hold on
        plot3( pointcloud_B(:, 1), pointcloud_B(:, 2), pointcloud_B(:, 3), 'b.')
        hold on      
        quiver3( pointcloud_A(:, 1), pointcloud_A(:, 2), pointcloud_A(:, 3), ...
                 Vector_to_z(:, 1), Vector_to_z(:, 2), Vector_to_z(:, 3), 0); % Notice the scaling factor is set to 0
        hold on
        plot3( pointcloud_Z(:,1) , pointcloud_Z(:,2) , pointcloud_Z(:,3), 'r.')
        
        axis equal


        num.AllPtsReorganized = [ num.AllPtsReorganized , pointcloud_Z(:,1) , pointcloud_Z(:,2) , pointcloud_Z(:,3) ]; 
        hold off
        pause(.5)
    end 


    num.AllVectors = [ num.AllPtsReorganized(:, 1:3) ,  All_Vectors  ];







    if WriteData == "TRUE"
    

    
        ExportFileName = join([  fname,  'Points.csv' ])  ;
        exportBoundaryTitle = fullfile(resultsDir1, ExportFileName);
        %-----------------------------------------%             Write the filename              
        writematrix( num.AllPtsReorganized , exportBoundaryTitle);  
    


    
        ExportFileName = join([  fname,  'Vector.csv' ])  ;
        exportBoundaryTitle = fullfile(resultsDir2, ExportFileName);
        %-----------------------------------------%             Write the filename              
        writematrix( num.AllVectors, exportBoundaryTitle);  
    
    
    end


    toc

    pause(10)
end 






