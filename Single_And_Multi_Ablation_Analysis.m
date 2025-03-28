clear
close all
clc
pause(5)

for ArrhVolDiamEllipBound = 1:1 

liverVolumes = [];
liverDiameters = [];
allVolumes = []; 
all_diameters = [];

% writetable( all_liver_diameters, export_All_liver_title_diam); 
% writetable( all_liver_volumes, export_All_liver_title_vol);
file_path = "D:\Import To Matlab\Perfusion Data\Liver05_915mhz_WTumor_P_PosAHealthy_HetPerfADJ.csv";
resultsDir = 'D:\Import To Matlab\Perfusion Data\Results'


[BoundaryPointsALL , liverVolumes,liverDiameters] = calculateArrhVolDiamEllipBound(file_path,"F","T");
    
%     [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiametersEllipse(filePath,"T","F");    
    %[liverVolumes,liverDiameters] = calculateArrheniusVolumeDiameters(filePath);
%
    [filepath,name,ext] = fileparts(file_path);    
    
    liverDiameters = string(liverDiameters{:,1:3});
    liverVolumes = string(liverVolumes{:,1});
    
    %creating a function to export all the liver volumes and liver
    %diameters
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];
    %
    exportBoundaryTitle = fullfile(resultsDir, join(["Boundary pts", "HetPerf_OG"]) );
    writematrix( BoundaryPointsALL,...
        exportBoundaryTitle)
    
    

    volName = 'ALLVolumeA98NewPrb_HetPerf_ADJ.csv';
    diamName = 'ALLDiameterA98NewPrb_HetPer_ADJ.csv';
    %
    %resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\Probe 4D\Results'
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    %
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);
    %
    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    
end 


%%
clear
close all
clc
pause(5)

for calculateArrhVolDiamEllipBound  = 1:1
%%%                                   Patient 017 Vanderbilt 
cd 'D:\Import To Matlab\Box Phantom\MultiprobeRefined\Patient 05 Multiprobe'
%resultsDir = 'D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results'    ;
resultsDir = 'D:\Import To Matlab\Box Phantom\MultiprobeRefined\Patient 05 Multiprobe\Results';
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
%

% allVolumes = array2table( zeros(90,4) );
% all_diameters = array2table( zeros(90,4*3) );
% all_diameters2 = array2table( zeros(90,4*3) );
allVolumes = [] ;
all_diameters = [] ;
all_diameters2 = [] ;

%order = [1,2,3,4,5,6,7,8,9];
% order = [1,3,4,5,6,2];
order = [1,2,3,4,5,6,7,8,9,10,11,12, 13 ,14 15, 16, 17, 18, 19];
%
for i = 1:length(names)

    CI = find(order == (i));
    file_path = fullfile(names(CI).folder , names(CI).name);
    
    [BoundaryPointsALL , liverVolumes,liverDiameters] = calculateArrhVolDiamEllipBound(file_path,"F","T", .98);
    
%     [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiametersEllipse(filePath,"T","F");    
    %[liverVolumes,liverDiameters] = calculateArrheniusVolumeDiameters(filePath);
    [filepath,name,ext] = fileparts(file_path);    
    liverDiameters = string(liverDiameters{:,1:3});
    liverVolumes = string(liverVolumes{:,1});
    
    %creating a function to export all the liver volumes and liver
    %diameters
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];
    exportBoundaryTitle = fullfile(resultsDir, join(["Boundary", names(CI).name]) );
    writematrix( BoundaryPointsALL,...
        exportBoundaryTitle)
    
    pause(10)
end   

    volName = 'ALLVolume_FullVascularTree.csv';
    diamName = 'ALLDiameter_FullVascularTree.csv';
    %
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    %
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);
    %
    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);

end   
    
%%


clear
close all
clc
pause(1)


for ProcessArrTempBoxModel = 1:1 

    %%CUREENT MODEL RUNS
   cd  'D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\915 MHZ Collins Probe - 3D\Box Phantom\MultiProbe\Paper 3 All Runs\RawData'
   resultsDir = 'D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\915 MHZ Collins Probe - 3D\Box Phantom\MultiProbe\Paper 3 All Runs\ProcessedData'

 %RETURN TO THIS!!   
%cd 'D:\ML COMSOL Models\COMSOL ZHighFat\'
%resultsDir = 'D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results'    ;
%resultsDir = 'D:\ML COMSOL Models\COMSOL ZHighFat\ProcessedData''D:\ML COMSOL Models\COMSOL ZHighFat\ProcessedData';



names = dir('*.csv');
pause(1)
%
%
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'




order = 1:1:100; 
%ElectricField_thresh = .98;
ArrheniusThresh = .970;
%
for i = 3:length(names)


    CI = find(order == (i));
    file_path = fullfile(names(CI).folder , names(CI).name);
    %
    %
    %[export] = FC_ProcessArrTempElectricField(filePath, arrhenius_thresh );
    [export] = FC_ProcessArrTPowerDD(file_path, ArrheniusThresh );
    [filepath,name,ext] = fileparts(file_path);    
    %
    %
    %creating a function to export all the liver volumes and liver
    %diameters
    exportBoundaryTitle = fullfile(resultsDir, join(["All ArrPoints", names(CI).name]) );
    writetable( export, exportBoundaryTitle)
    
    
    pause(10)
end   
end 




   
    
%%
clear
for AXISYMETRIC = 1:1
%%%                 AXISYMMETRIC


tic 


cd 'D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\Axisymmetric Model\Data'
resultsDir = 'D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\Axisymmetric Model\Data\Results'; 
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%[2,3,4,1]
order = [1, 10, 11, 12, 13, 2, 3, 4, 5, 6, 7, 8, 9];

allVolumes = [] ;
all_diameters = [] ;


for i = 1:length(order)
    
    
    CI = find(order == (i));
    file_path = fullfile(names(CI).folder , names(CI).name);
     [BoundaryPointsALL , liverVolumes, liverDiameters] ...
        = calculateArrheniusVolumeDiametersEllipseSymmetry(file_path);
%
    [filepath,name,ext] = fileparts(file_path);    
    
    liverDiameters = string(liverDiameters{:,1:2});
    liverVolumes = string(liverVolumes{:,1});
    
    %creating a function to export all the liver volumes and liver
    %diameters
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];
    
    
    exportBoundaryTitle = fullfile(resultsDir, join(["Boundary", names(CI).name]) );
    writematrix( BoundaryPointsALL,...
        exportBoundaryTitle)
    

    
    
end 

    volName = 'ALLVolumeA98NewPrb.csv';
    diamName = 'ALLDiameterA98NewPrb.csv';
 
    %resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\Probe 4D\Results'

    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);

    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    


   
toc 

end 





