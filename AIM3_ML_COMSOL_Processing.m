


clear 
clc
close all


% Specify the directory you want to search in
%directoryPath = 'D:\ML COMSOL Models\COMSOL ZHighFat\ProcessedData'; % Change this to your directory
directoryPath = 'D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\915 MHZ Collins Probe - 3D\Box Phantom\MultiProbe\Paper 3 All Runs\ProcessedData'
% Create a pattern to match .mph files
filePattern = fullfile(directoryPath, '*.csv');
% Get a list of all files in the directory with .mph extension
mphFiles = dir(filePattern);
% Loop through each file in the list
tStart = tic ;
T = [];

%

%resultsDir_All = 'D:\ML COMSOL Models\COMSOL ZHighFat\Ablation Cloud 970';
resultsDir_All  ='D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\915 MHZ Collins Probe - 3D\Box Phantom\MultiProbe\Paper 3 All Runs\AblationCloud';
% ----------------------------------------------------------------------------% 


REPROCESSING = "TRUE";
SmoothedData = "TRUE";

EXPORT_DATA = "TRUE";
EXPORT_SINGLE = "TRUE";
%%

for fi = 14:14  %  length(mphFiles)
    tic 
    % type = ["Necrosis", "EField", "EField Single" ];
    % file_path = SelectElectAblationBoundary(   type(2),   fi   );
    file_path = fullfile(directoryPath, mphFiles(fi).name);
%
%
%
    [filepath,name,ext] = fileparts(file_path);    
    OGdata = readtable(file_path);
    data = table2array(OGdata);
% Extract the coordinates, temperature, arrhenius, and electric field values
%
% Separate the temperature, arrhenius, and electric field values for each time point
numTimePoints = 61;  % Calculate the number of time points
timePoints = cell(numTimePoints, 1);

for i = 2:numTimePoints
    startIndex = 1 + (i - 1) * 5;
    endIndex = startIndex + 4;
    timePoints{i} = data(:, startIndex:endIndex);
end

%
startPoint = 3;
                                      disp("       DATA   LOADING   FINISHED       "  )





pause(1)


%
% ----------------------------------------------------------------------------% 
% ----------------------------------------------------------------------------%
% SmoothedData = "TRUE";
if SmoothedData == "TRUE"

     ProbeFilePath = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
     ProbeFilePath = "D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\915 MHZ Collins Probe - 3D\Box Phantom\MultiProbe\Paper 3 All Runs\ALL Experiment Dual Probe Placement Information_matlab.csv"

     MphName = file_path;
     disp(MphName)
     
    [SmoothedAblationTimePoints, ProbepointsExport] = SmoothAblationPointsWithProbe( ProbeFilePath, MphName, ...
                                    timePoints, startPoint, numTimePoints) ;  

                                    disp("       DATA   SMOOTHING   FINISHED       "  )

end 



%
pause(1)

% ----------------------------------------------------------------------------% 
% ----------------------------------------------------------------------------%
figure(2)

NewSampledData = cell(numTimePoints, 1);
StartAdj = startPoint - 1; 
for i = startPoint: numTimePoints
    %
        if SmoothedData == "TRUE" 
            currentData = timePoints{i} ;
            Coords = SmoothedAblationTimePoints{i} ;
            Arrhnus = currentData(:, 4);  
            ProbePoints = ProbepointsExport{i};
    
    
        else 
            currentData = timePoints{i} ;
            Arrhnus = currentData(:, 4);    
            Coords = currentData(:, 1:3);
            Coords = Coords((Arrhnus> .985), :);
            Coords( isnan(Coords(:,1)), : ) = [];
        
            k = boundary(Coords,.75);
            %BoundaryPoints.k = reshape(k,[],1);
            k = reshape(k,[],1);
            kSort = unique(k);
            Coords = Coords(kSort,:);
        end 
        %
        %
        AllData1 =  Coords;
        NewPoints = AllData1;     
        Upsample = "TRUE";
        numpoints = 2600;
        %
        %
    %----------------------------------------------------------------------------------%     
    if Upsample == "TRUE"      
        if size(AllData1,1) < numpoints
            [ AllData1 ] = UpsampledAblationSpec( NewPoints, numpoints ) ;
            disp("Upsampled") 
            
            %--------------------------------------------------------------%
            if size(AllData1,1) < numpoints
                while size(AllData1,1) < numpoints
                    [ AllData1 ] = UpsampledAblationSpec( AllData1, numpoints ) ;
                    disp("Upsampled II") 
                end 
            end 
        end 
            
        if  size(AllData1,1) > numpoints
            [ AllData1 ] = DownsampleAblationSpec( NewPoints, numpoints ) ;
             disp("Downsample") 
        else
            disp("Best Sample")   
        end 
    end      
    %----------------------------------------------------------------------------------%  

NewSampledData{i-StartAdj} = AllData1;



scatter3(  AllData1(:,1), AllData1(:,2), AllData1(:,3), 10, 'filled' )
hold on 
scatter3(  ProbePoints(:,1), ProbePoints(:,2), ProbePoints(:,3), 10, 'k', 'filled' )
axis equal 
pause(.25)
hold off


if i == startPoint

    FigureDir = 'D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\915 MHZ Collins Probe - 3D\Box Phantom\MultiProbe\Paper 3 All Runs\Matlab Figures';
    % Construct the full path for the output file
    fullFigurePath = fullfile(FigureDir, name);
    fullFigurePath = join([  fullFigurePath, '.jpg'] )
    % Save the current figure as an image
    saveas(gcf, fullFigurePath);
end 


end 
                                            disp("       SAMPLING   FINISHED       "  )




%REPROCESSING = "FALSE";
% ----------------------------------------------------------------------------% 
% ----------------------------------------------------------------------------%
if  REPROCESSING == "TRUE"


    close all
    figure(3); 
    
    set(gca,'color', 'w' );
    set(gcf,'color', 'w' );  
    view( -5 ,5)
    % xlim([-50, 50])
    % ylim([-50, 50])
    % zlim([-50, 50]) 
    
    num.AllPtsReorganized  = [];
    tol = 3; 
    Original_Distances_All = []; 
    distances_to_Z_All = []; 
    AllPtsReorganized_mat = [];
    AllPtsReorganized = cell(numTimePoints, 1);
    distances_to_Z_All = cell(numTimePoints, 1);


    for i = startPoint: numTimePoints -1 %length(idx)-1
    
    
        % % num.AllPts = NewSampledData{i - StartAdj, 1} ; 
        % % if i == startPoint
        % %     X1 = num.AllPts(:, 1 ); 
        % %     Y1 = num.AllPts(:, 2 ); 
        % %     Z1 = num.AllPts(:, 3 ); 
        % % 
        % % else 
        % %     X1 = pointcloud_Z(:,1); 
        % %     Y1 = pointcloud_Z(:,2); 
        % %     Z1 = pointcloud_Z(:,3);         
        % % end
        % % 
        % % 
        % % j = i- StartAdj +1;
        % % num.AllPts2 = NewSampledData{j, 1} ; 
        % % X2 = num.AllPts2( :, 1 ); 
        % % Y2 = num.AllPts2( :, 2 ); 
        % % Z2 = num.AllPts2( :, 3 );
        % % pointcloud_A = [X1, Y1, Z1];
        % % pointcloud_B = [X2, Y2, Z2];


        num.AllPts = NewSampledData{i - StartAdj, 1} ; 
        X1 = num.AllPts(:, 1 ); 
        Y1 = num.AllPts(:, 2 ); 
        Z1 = num.AllPts(:, 3 ); 

        plot3( X1, Y1, Z1, 'r.')
        axis equal
        %plot3( X2, Y2, Z2, '.')
        pause(.5)


        %   
        %
        %
        % numpoints = 4000;
        % [ pointcloud_B ] = UpsampledAblationSpec( pointcloud_B, numpoints ) ;
        %
        %[pointcloud_Z] = Aim3MatchPCMultSampl(pointcloud_A, pointcloud_B, tol ) ;
        %[pointcloud_Z] = Aim3MatchPCSimple(pointcloud_A, pointcloud_B, tol ) ;
        %Aim3MatchPCSimple
        %
        %
        %pointcloud_Z = pointcloud_Z';
        %distances_to_Z = sqrt(sum((pointcloud_Z - pointcloud_A).^2, 2));

        %%%_------------------------------------------------------------------------%%%
        currentData = timePoints{i} ;
        Arrhnus = currentData(:, 4);
        Arrhnus( isnan(Arrhnus) ) = [];
        Efield = currentData(:, 5);
        Efield( isnan(Efield) ) = [];   
        Coords = currentData(:, 1:3);
        Coords( isnan(Coords(:,1)), : ) = [];
   
        intensity = Efield;
        ptsC = [X1, Y1, Z1];
        Efield_intensity = griddata(Coords(:,1), Coords(:,2), Coords(:,3), intensity, ...
                           ptsC(:,1), ptsC(:,2), ptsC(:,3));
        %%-Nearest_Neighboor 
        ZcordNan = ptsC(isnan(Efield_intensity), :);
        [minDist,I] = min(pdist2(ZcordNan, Coords),[], 2);
        NewB_Intense = intensity(I);
        Efield_intensity(find(isnan(Efield_intensity)) ) = NewB_Intense;
        %%%_------------------------------------------------------------------------%%%
    
    
    
        

    
    
    
        %num.AllPtsReorganized = [num.AllPtsReorganized , X1, Y1 , Z1  ]; 
        idx = 1 : 1 : (15*4)+1 ; 
        minutes =  floor( (idx(i)*15-15)/60) ; 
        seconds  = mod( (idx(i)*15-15), 60)    ;
        Stored_Data = [ minutes, seconds, 0, 0;
                                 X1, Y1 , Z1, Efield_intensity];
        AllPtsReorganized{i} = [ Stored_Data ] ;
        AllPtsReorganized_mat = [AllPtsReorganized_mat, Stored_Data ];      
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
    %distances_to_Z_All = [distances_to_Z_All, distances_to_Z]; 
    %distances_to_Z_All{i} = distances_to_Z;
    %Original_Distances_All = [Original_Distances_All, Original_Distances];     
    % Frame = getframe(gcf) ;                
    % writeVideo(writerObj,Frame)
    axis equal
    hold off
    end 
            axis equal
            plot3( X1, Y1, Z1, '.')
            axis equal
        
        
            minutes =  floor( (idx(i+1)*15-15)/60) ; 
            seconds  = mod( (idx(i+1)*15-15), 60)    ;
            Stored_Data = [ minutes, seconds, 0, 0;
                                 X1, Y1 , Z1, Efield_intensity];
            AllPtsReorganized{i+1} = [Stored_Data];
            %
            %
            hold off
end 

                            disp("       RE-PROCESSING   POINTCLOUD   FINISHED       "  )


pause(10)
%
% ----------------------------------------------------------------------------%  
% ----------------------------------------------------------------------------%
resultsDir_single = 'D:\Import To Matlab\COMSOL Pointcloud ML\'; 
% EXPORT_DATA = "FALSE";
if EXPORT_DATA == "TRUE"

    

    for j = startPoint : 61

            minutes =  floor( (idx(j)*15-15)/60) ; 
            seconds  = mod( (idx(j)*15-15), 60)    ;
            resultsDir2 = join([ resultsDir_single, num2str(minutes), ...
                                'm','  ', num2str(seconds), 's'  ]) ;
            [status, msg, msgID] = mkdir(resultsDir2);
            ExportFileName = join([ name, num2str(minutes),  'm','  ', ...
                                    num2str(seconds), 's', '.csv' ])  ;
    
            exportTitle = fullfile(resultsDir2, ExportFileName);
            %-----------------------------------------%             Write the filename   
            exportData = AllPtsReorganized{j, 1}  ; 

            if EXPORT_SINGLE == "TRUE"
                writematrix( exportData, exportTitle)    ;  
            end 
    end 




    exportDataAll = []; 
    %resultsDir_All = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data\';
    [status, msg, msgID] = mkdir(resultsDir_All);
    %
        for j = startPoint : 61
            exportData = AllPtsReorganized{j, 1}  ; 
            exportDataAll = [exportDataAll, exportData] ; 
        end 
    % dataMatrix now contains the horizontally rearranged data
    ExportFileName = join([ name, '    All', '.csv' ])  ;
    exportTitle = fullfile(resultsDir_All, ExportFileName);
    writematrix( exportDataAll ,exportTitle )  ;



                    Message = join(["    FILE   " , num2str(fi), "    EXPORTED"    ]); 
                                                                    disp(   Message   )  
                                                                    
pause(10)                                                                    

end 




toc
% close all
% clc
pause(.5)

end 

