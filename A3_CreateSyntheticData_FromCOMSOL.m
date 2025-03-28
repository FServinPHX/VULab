
% This File is an adaptation from   A3_IP_CreateSynthDataSinglAntae.m


% Create an atlas
close all
clear
clc

All_ProbeDataFile = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
ProbeData = readtable(All_ProbeDataFile);
    
    % Select the first row
    All_ProbeData = ProbeData(:,:);
    
    % Convert each column separately and concatenate them
    arrayData = [];
    variableNames = All_ProbeData.Properties.VariableNames;
    
    for i = 1:length(variableNames)
        currentColumn = All_ProbeData.(variableNames{i});
        if iscell(currentColumn)
            % Handle cell array by converting to string or number as needed
            currentColumn = string(currentColumn); % or convert using another appropriate method
        end
        % Concatenate columns
        arrayData = [arrayData, currentColumn];
    end
     
% [ Theta1,  Psi1,   X_Tip1,   Y_Tip1,   Z_Tip1,   
%   Theta2,  Psi2,   X_Tip2,   Y_Tip1,   Z_Tip1 ]; 
AllNum_ProbeData = str2double( arrayData(:, 2:end) );



fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxGeomSymmetricModel_Case1.csv";   
BoundaryPoints.og = readtable(fileName);
BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:)) ;

%%

for CurrentRun = 100:182


  
  file_path = arrayData(CurrentRun, 1 )
  [ProbePointExport, plotedLine1, plotedLine2 ] =  A3_FindPlotPoints(file_path);


  theta1 =  AllNum_ProbeData(   CurrentRun, 1) ;
  psi1 =    AllNum_ProbeData(   CurrentRun, 2) ;
  centralPoint1 =   AllNum_ProbeData( CurrentRun, 3:5 ) ;
  theta2 =   AllNum_ProbeData(  CurrentRun,  6) ;
  psi2 =     AllNum_ProbeData( CurrentRun,  7) ;
  centralPoint2 =    AllNum_ProbeData( CurrentRun,  8:10) ;



  AllBoundaryPts = [];
  for i = 1:59



    
    X = BoundaryPointsMatrix(2:end, ((i-1)*3   +7 ));
    X(X == 0) = [];
    Y = BoundaryPointsMatrix(2:end, ((i-1)*3   +8 ));
    Y(Y == 0) = [];
    Z = BoundaryPointsMatrix(2:end, ((i-1)*3   +9 ));
    Z(Z == 0) = [];

    pointCloud = [X, Y, Z];
    %Create Ablation 1 around Probe 1
    [transformed_Ablation1] = transformPointCloud_Aim3(pointCloud, theta1, psi1, centralPoint1);
    
    %transformed_Ablation1 = transformPointCloud(pointCloud, theta1, psi1, centralPoint1);
    %Create Ablation 2 around probe 2
    [transformed_Ablation2] = transformPointCloud_Aim3(pointCloud, theta2, psi2, centralPoint2);
    
    %transformed_Ablation2 = transformPointCloud(pointCloud, theta2, psi2, centralPoint2);
   



    [ AllData1 ] = DualAblationCombine ( transformed_Ablation1 , transformed_Ablation2,...
                                         plotedLine1,  plotedLine2 ) ;


       
   filtered_probe =  filter_probePoints(   [transformed_Ablation1; transformed_Ablation2],   ProbePointExport  );
             
   NewPoints = AllData1(:, 1:3); 









    num_iterations = 3; % Number of adjustment iterations
    num_neighbors = 5; % Number of closest neighbors to find
    original_points = NewPoints;
    ProbePts =ProbePointExport;
    scale = 0.95 +  0.4*( i/61) ;
    %
    [ProbePts_filtered, pointsExport] =  A3_SmoothAblationComplete(original_points, ProbePts, ...
                                                            num_iterations, num_neighbors, scale);
           
   NewPoints = pointsExport;
   filtered_probe = ProbePts_filtered;



   numpoints = 2600;
   Upsample = "TRUE"  ;    
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
                    %[ AllData1 ] = DownsampleAblationSpec( NewPoints, numpoints ) ;
                        [AllData1] = NewPoints(1:numpoints, :); 
                     disp("Downsample") 
                else
                    disp("Best Sample")   
                end 
       end 
   %
   %
   NewPoints = AllData1;
    



    plotResults = "FALSE";
    %
    if plotResults == "TRUE"
        plot3DScatter(filtered_probe, 50, rgb("Purple")) 
        hold on
        %plot3DScatter(plotedLine1, 50, rgb("Black"))  
        %plot3DScatter(plotedLine2, 50, rgb("Black"))  
        %plot3DScatter(transformed_Ablation1, 50, rgb("Blue"))
        %plot3DScatter(transformed_Ablation2, 50, rgb("Red"))
        plot3DScatter( NewPoints, 50,  rgb("Blue") )
        axis equal
        set(gcf,'color','w');  
        hold off
    
        pause(.10)
    end 

   

    AllBoundaryPts = [AllBoundaryPts, NewPoints];

  end 


    
    % Find the position of the last occurrence of '.' in the filename
    fileNameNew = char(file_path)  ;
    %
    resultsDir = 'D:\Import To Matlab\0.0 COMSOL to Synthetic ptCloud'; 
            ExportFileName = join([fileNameNew(1:end-5), '_Synthetic.csv']) 
            exportBoundaryTitle = fullfile(resultsDir, ExportFileName);
            writematrix( AllBoundaryPts, exportBoundaryTitle);
end 









 
