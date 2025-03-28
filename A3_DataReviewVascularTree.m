clear
close all
% Read the data from the text file
data = dlmread("D:\Import To Matlab\Perfusion Data\PerfusionMaps\Patient_00 5 _Blood_Perfusion 0.01508 ADJ.txt");
% Extract the columns
x = data(:, 1);
y = data(:, 2);
z = data(:, 3);
intensity = data(:, 4);

% Filter the data based on intensity values greater than or equal to 0.18
filteredIndices = intensity >= 0.018;
filteredX = x(filteredIndices);
filteredY = y(filteredIndices);
filteredZ = z(filteredIndices);
filteredIntensity = intensity(filteredIndices);
%
stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Liver Mesh.stl");
LiverMeshpoints = stlData.Points;
LiverCenter = mean(LiverMeshpoints,1) ;
LiverData.ConnectivityList = stlData.ConnectivityList ; 
LiverDataT =  triangulation(  LiverData.ConnectivityList, LiverMeshpoints );
 [LiverMeshpoints_New] = UpsampledAblationSpec( LiverMeshpoints, 8000 ) ;

%-------------------------------------------------------------%
TargetPoints = [filteredX , filteredY, filteredZ];
[ distances ] = SDAVectorTarget(  LiverMeshpoints, TargetPoints,  LiverCenter ); 
%
filteredIndices2 = distances <= 0.1;
filteredX2 = filteredX(filteredIndices2);
filteredY2 = filteredY(filteredIndices2);
filteredZ2 = filteredZ(filteredIndices2);
filteredIntensity2 = filteredIntensity(filteredIndices2);
%-------------------------------------------------------------%

trimesh(LiverDataT ,'FaceColor','none','EdgeColor',rgb("Sienna"),'EdgeAlpha', .25 )
hold on
scatter3( LiverMeshpoints_New(:,1), LiverMeshpoints_New(:,2), LiverMeshpoints_New(:,3))
% Create a 3D scatter plot
scatter3(filteredX2, filteredY2, filteredZ2, 4, filteredIntensity2, 'filled');
colorbar;
% Set labels and title
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Scatter Plot with Intensity Values >= 0.18');
axis equal