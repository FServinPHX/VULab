 
%%%                                                 2.45 GHZ TUMOR ANALYSIS
 

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\245GhzModels\WithTumor\'
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%[2,3,4,1]
%[4,2,3,1]
order = [1,2,3,4];

allVolumes = array2table( zeros(70,4) );
alliameters = array2table( zeros(70,4*3) );
for i = 1:4 
    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name)
    [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiameters(filePath);
%
    [filepath,name,ext] = fileparts(filePath);    
    
    liverDiameters = string(liverDiameters{:,1:3});
    liverVolumes = string(liverVolumes{:,1});
    
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];
    
    
    
end 
    volName = 'allVolumeA98and2450MHZLinearAppx.csv';
    diamName = 'allDiametersA98and2450MHZLinearAppx.csv';
    resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\245GhzModels\WithTumor\ProcessedData\'
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);

    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    
    
    %%



clear
%%%                          Multiprobe 


%%cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSpecificSampling'
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\Multiprobe'
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\Multiprobe\Results'

%[2,3,4,1]
order = [1,2,3,4,5,6,7,8,9];


allVolumes = [] ;
all_diameters = [] ;
all_diameters2 = [] ;
for i = 2:7     %1:length(names)
    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name);
    
    [BoundaryPointsALL , liverVolumes,liverDiameters] = calculateArrhVolDiamEllipBound(filePath,"T","F");

    [filepath,name,ext] = fileparts(filePath);    

    %creating a function to export all the liver volumes and liver
    %diameters 
    liverDiameters = string(liverDiameters{:,1:3});
    liverVolumes = string(liverVolumes{:,1});
    
    %creating a function to export all the liver volumes and liver
    %diameters
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];  
    %all_diameters2(1:height(liverDiameters2), (i-1)*3+1:(i-1)*3+3) =  liverDiameters2;
    
    exportBoundaryTitle = fullfile(resultsDir, join(["Boundary", names(CI).name]) );
    writematrix( BoundaryPointsALL,...
        exportBoundaryTitle)
    
end

    volName = 'ALLVolumeA98Multiprobe.csv';
    diamName = 'ALLDiameterA98Multiprobe.csv';
    
  exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);

%EXPORT
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);

    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    
    %%

%%%                                   Single Alblation Tissue Phantom Box | 
clear
tic 


cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\TrueBeef'
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%
order = [1,2,3,4,5,6,7,8];


allVolumes = [];

all_diameters = [];

for i = 1:length(names) 
    
    
    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name);
%     [liverVolumes,liverDiameters,liverDiameters2,VolumesLeft, VolumeRight] ...
%         = calculateArrheniusVolumeDiametersEllipseSymmetry(filePath,"F","T");
   [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiametersEllipse(filePath,"T","F");    
%
    [filepath,name,ext] = fileparts(filePath);    
     volName = 'VolumeA98WholeCube.csv';
    diamName = 'DiametersA98WholeCube.csv';

    
    %creating a function to export all the liver volumes and liver
    %diameters 
    
    liverDiameters = string(liverDiameters{:,1:3});
    liverVolumes = string(liverVolumes{:,1});
    
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];
    
    
end 
    volName = 'ALLVolumeA98TrueBeef.csv';
    diamName = 'ALLDiameterA98TrueBeef.csv';
    resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\TrueBeef\Results\'
    
    
    %Export Title Names
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    
    %Write Table Data
    %Diameter
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);
    %Title
    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    

toc 

    






%%%                      HETEROGENOUS ANALYSIS |  WHOLE / HETEROGENOUS CUBE

clear
tic 


cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\FatSpheres'
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%[2,3,4,1]
order = [4,1,2,3];


allVolumes = array2table( zeros(70,4) );
allVolumesLeft = array2table( zeros(70,4) );
allVolumesRight = array2table( zeros(70,4) );
all_diameters = array2table( zeros(70,4*3) );
all_diameters2 = array2table( zeros(70,4*3) );

for i = 1:length(names)
    
    
    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name);
    [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiametersEllipse(filePath,"T","F");
     
%     [liverVolumes,liverDiameters,liverDiameters2,VolumesLeft, VolumeRight] ...
%         = calculateArrheniusVolumeDiametersEllipseSymmetry(filePath,"F","T");
%
    [filepath,name,ext] = fileparts(filePath);    
    %volumeDirectory = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\Volume\";
    %diameterDirectory = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\Diameters\";
    volName = 'VolumeA98WholeCube.csv';
    diamName = 'DiametersA98WholeCube.csv';


%     exportAllLiverTitleDiam = join([diameterDirectory,name,diamName]);
%     exportAllLiverTitleVol = join([volumeDirectory,name,volName]);

    %writetable( liverDiameters, exportAllLiverTitleDiam);
    %writetable( liverVolumes, exportAllLiverTitleVol);
    
    %creating a function to export all the liver volumes and liver
    %diameters 
    allVolumes(1:height(liverVolumes),i) =  liverVolumes;
%     allVolumesLeft(1:height(VolumesLeft),i) =  VolumesLeft;
%     allVolumesRight(1:height(VolumeRight),i) =  VolumeRight;
    
    all_diameters(1:height(liverDiameters), (i-1)*3+1:(i-1)*3+3) =  liverDiameters;   
%     all_diameters2(1:height(liverDiameters2), (i-1)*3+1:(i-1)*3+3) =  liverDiameters2;   
    
    
end 
    volName = 'ALLVolumeSparseFatSphere.csv';
    volNameRight = 'RightVolumeA98SparseFatSphere.csv';
    volNameLeft = 'LeftVolumeA98SparseFatSphere.csv';
    diamName = 'ALLDiameterA98SparseFatSphere.csv';
    diamName2 = 'ALLDiameterLeftA98SparseFatSphere.csv';
    resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\FatSpheres\Results'
  
    %Export Title Names
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleDiam2 = fullfile(resultsDir,diamName2);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    exportAllLiverTitleVolLeft = fullfile(resultsDir,volNameLeft);    
    exportAllLiverTitleVolRight = fullfile(resultsDir,volNameRight);

    
    %Write Table Data
    %Diameter
    writetable( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);
%     writetable( all_diameters2(1:height(liverDiameters2),:) ,...
%         exportAllLiverTitleDiam2);
    %Title
    writetable( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
%     writetable( allVolumesLeft(1:height(VolumesLeft),:),...
%         exportAllLiverTitleVolLeft);    
%     writetable( allVolumesRight(1:height(VolumeRight),:),...
%         exportAllLiverTitleVolRight);    

toc 


%%

%%%               HETEROGENOUS ANALYSIS |  AXISYMMETRIC / HETEROGENOUS CUBE
clear

tic 

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'

cd 'COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\COMSOL Geometry Half Cube'
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%[2,3,4,1]
order = [4,3,2,1];


allVolumes = array2table( zeros(70,4) );
allVolumesLeft = array2table( zeros(70,4) );
allVolumesRight = array2table( zeros(70,4) );
all_diameters = array2table( zeros(70,4*3) );
all_diameters2 = array2table( zeros(70,4*3) );
for i = 1:4
    
    
    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name);
    [liverVolumes,liverDiameters,liverDiameters2,VolumesLeft, VolumeRight] ...
        = calculateArrheniusVolumeDiametersEllipseSymmetry(filePath,"F","T");
%
    [filepath,name,ext] = fileparts(filePath);    
    %volumeDirectory = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\Volume\";
    %diameterDirectory = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\Diameters\";
    volName = 'VolumeA98HalfCube.csv';
    diamName = 'DiametersA98HalfCube.csv';


%     exportAllLiverTitleDiam = join([diameterDirectory,name,diamName]);
%     exportAllLiverTitleVol = join([volumeDirectory,name,volName]);

    %writetable( liverDiameters, exportAllLiverTitleDiam);
    %writetable( liverVolumes, exportAllLiverTitleVol);
    
    %creating a function to export all the liver volumes and liver
    %diameters 
    allVolumes(1:height(liverVolumes),i) =  liverVolumes;
    allVolumesLeft(1:height(VolumesLeft),i) =  VolumesLeft;
    allVolumesRight(1:height(VolumeRight),i) =  VolumeRight;
    
    all_diameters(1:height(liverDiameters), (i-1)*3+1:(i-1)*3+3) =  liverDiameters;   
    all_diameters2(1:height(liverDiameters2), (i-1)*3+1:(i-1)*3+3) =  liverDiameters2;   
    
    
end 
    volName = 'ALLVolumeA98HalfCube.csv';
    volNameRight = 'RightVolumeA98HalfCubeBoundary.csv';
    volNameLeft = 'LeftVolumeA98HalfCubeBoundary.csv';
    diamName = 'ALLDiameterA98HalfCube.csv';
    diamName2 = 'ALLDiameterLeftA98HalfCube.csv';
    resultsDir = 'COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\COMSOL Geometry Half Cube\Processed Data'
  
    %Export Title Names
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleDiam2 = fullfile(resultsDir,diamName2);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    exportAllLiverTitleVolLeft = fullfile(resultsDir,volNameLeft);    
    exportAllLiverTitleVolRight = fullfile(resultsDir,volNameRight);

    
    %Write Table Data
    %Diameter
    writetable( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);
    writetable( all_diameters2(1:height(liverDiameters2),:) ,...
        exportAllLiverTitleDiam2);
    %Title
    writetable( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    writetable( allVolumesLeft(1:height(VolumesLeft),:),...
        exportAllLiverTitleVolLeft);    
    writetable( allVolumesRight(1:height(VolumeRight),:),...
        exportAllLiverTitleVolRight);    

   
toc 
clear

tic 

%%
clear
%%%                          HETEROGENOUS ANALYSIS  | PATIENT 4 | Multiprobe 


%%cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSpecificSampling'
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Patient 4 MultiPlacement'
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%[2,3,4,1]
order = [1,2,3,4];

allVolumes = array2table( zeros(70,4) );
all_diameters = array2table( zeros(70,4*3) );
all_diameters2 = array2table( zeros(70,4*3) );
for i = 1:4
    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name);
    [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiametersEllipse(filePath,"T","F");

    [filepath,name,ext] = fileparts(filePath);    

    %creating a function to export all the liver volumes and liver
    %diameters 
    allVolumes(1:height(liverVolumes),i) =  liverVolumes;
    all_diameters(1:height(liverDiameters), (i-1)*3+1:(i-1)*3+3) =  liverDiameters;   
    %all_diameters2(1:height(liverDiameters2), (i-1)*3+1:(i-1)*3+3) =  liverDiameters2;   
end 
    volName = 'ALLVolumeA98TumorSpecificSampling.csv';
    diamName = 'ALLDiameterA98TumorSpecificSampling.csv';
    
    resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Patient 4 MultiPlacement\ProcessedData'
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);

%EXPORT
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);

    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    
    
    
    %%


clear
%%%                                   HETEROGENOUS ANALYSIS  | PATIENT DATA


%cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSpecificSampling'

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\5minPowerOff'
%cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\5minPowerOff'

%cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSamplingwPerf'
%cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\HetPerf'


names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%[2,3,4,1]
order = [1,2,3,4];

allVolumes = array2table( zeros(90,4) );
all_diameters = array2table( zeros(90,4*3) );
all_diameters2 = array2table( zeros(90,4*3) );
for i = 1:4

    pause(300)


    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name);
    
    [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiametersEllipse(filePath,"T","F");    
    %[liverVolumes,liverDiameters] = calculateArrheniusVolumeDiameters(filePath);
%
    [filepath,name,ext] = fileparts(filePath);    
    %creating a function to export all the liver volumes and liver
    
    liverDiameters = string(liverDiameters{:,1:3});
    liverVolumes = string(liverVolumes{:,1});
    
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];
    
    %all_diameters2(1:height(liverDiameters2), (i-1)*3+1:(i-1)*3+3) =  liverDiameters2;   
end 
    volName = 'ALLVolumeA98PatientDataHeterogenous5minPowerOffv3.csv';
    diamName = 'ALLDiameterA98PatientDataHeterogenous5minPowerOffv3.csv';
%     diamName2 = 'ALLDiameterLeftA98TumorSpecificSampling.csv';
%     resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Temp Dependent\ProcessedData'
    resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\5minPowerOff\ProcessedData'

    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
%     exportAllLiverTitleDiam2 = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
 
   
%write out
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);

    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    
    
   %% 
       
%%%                                            TEMPERATURE DEPENDENT ANALYSIS

clear
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Silva 2.45 GHz'
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%[2,3,4,1]
%[4,2,3,1]
order = [2,1, 3, 4,5];



allVolumes = [];
all_diameters = [];
for i = 1:5
    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name);
    %[liverVolumes,liverDiameters] = calculateArrheniusVolumeAndDiametersTemp(filePath);
    [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiametersEllipse(filePath,"T","F");
%
    [filepath,name,ext] = fileparts(filePath);    
    
    liverDiameters = string(liverDiameters{:,1:3});
    liverVolumes = string(liverVolumes{:,1});
    
    %creating a function to export all the liver volumes and liver
    %diameters
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];
    
    
    
    
end 
    volName = 'allVolumeEllipseSilva2450.csv';
    diamName = 'allDiametersEllipseSilva2450.csv';
    resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Silva 2.45 GHz\Results'
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    
    
    
%write out
    writematrix( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);

    writematrix( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    
%%
clear
close all
%%%                                          HOMOGENOUS ANALYSIS | NO TUMOR 

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data'
names = dir('*.csv');
pause(1)
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%[2,3,4,1]
order = [1,2,3,4];

allVolumes = array2table( zeros(70,4) );
all_diameters = array2table( zeros(70,4*3) );
all_diameters2 = array2table( zeros(70,4*3) );
for i = 1:4
    CI = find(order == (i));
    filePath = fullfile(names(CI).folder , names(CI).name);
    [liverVolumes,liverDiameters] = calculateArrheniusVolumeDiametersEllipse(filePath,"T","F");
    %[liverVolumes,liverDiameters] = calculateArrheniusVolumeDiameters(filePath);
%
    [filepath,name,ext] = fileparts(filePath);    

    %creating a function to export all the liver volumes and liver
    %diameters
    liverDiameters = string(liverDiameters{:,1:3});
    liverVolumes = string(liverVolumes{:,1});
    allVolumes = [allVolumes, liverVolumes ];
    all_diameters = [all_diameters,     liverDiameters];
    
    
end 
    volName = 'ALLVolumeA98HomogenousAnalysisNoTumorEllipseNewData.csv';
    diamName = 'ALLDiameterA98HomogenousAnalysisNoTumorEllipseNewData.csv';
%     diamName2 = 'ALLDiameterLeftA98TumorSpecificSampling.csv';
    resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data'
    exportAllLiverTitleDiam = fullfile(resultsDir,diamName);
%     exportAllLiverTitleDiam2 = fullfile(resultsDir,diamName);
    exportAllLiverTitleVol = fullfile(resultsDir,volName);
    
    writetable( all_diameters(1:height(liverDiameters),:) ,...
        exportAllLiverTitleDiam);
%     writetable( all_diameters2(1:height(liverDiameters2),:) ,...
%         exportAllLiverTitleDiam2);
    writetable( allVolumes(1:height(liverVolumes),:),...
        exportAllLiverTitleVol);
    
    
    
    