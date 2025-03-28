
clc
clear
close all


xtname = "D:\Import To Matlab\COMSOL__Structured Grid__Electric_Field___Mid\Mid_Electric Field Mask_Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6.csv";
chunk_size = 132651;
pVox.VoxSize = [100, 100, 100 ] ;
maskTypeNum = 2; 
VideName = "Distances  __ptII";
export_DIR = "FALSE"   ;   


X_train_Data = readmatrix(xtname);




%%
clc
clear
close all


% Define the directory with CSV files
inputDir = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1';
outputDirEarly = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2__Early';
outputDirMid = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___Mid';
outputDirLate = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___Late';


outputDir1Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___1Minute';
outputDir2Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___2Minute';
outputDir3Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___3Minute';
outputDir4Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___4Minute';
outputDir5Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___5Minute';
outputDir6Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___6Minute';
outputDir7Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___7Minute';
outputDir8Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___8Minute';
outputDir9Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___9Minute';
outputDir10Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___10Minute';
outputDir11Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___11Minute';
outputDir12Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___12Minute';
outputDir13Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___13Minute';
outputDir14Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___14Minute';

outputDir15Minute = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_2___15Minute';

% Create output directories if they don't exist
if ~exist(outputDirEarly, 'dir')
    mkdir(outputDirEarly);
end
if ~exist(outputDirMid, 'dir')
    mkdir(outputDirMid);
end
if ~exist(outputDirLate, 'dir')
    mkdir(outputDirLate);
end






if ~exist(outputDir1Minute, 'dir')
    mkdir(outputDir1Minute);
end

if ~exist(outputDir2Minute, 'dir')
    mkdir(outputDir2Minute);
end

if ~exist(  outputDir3Minute , 'dir')
    mkdir(outputDir3Minute);
end

if ~exist(  outputDir4Minute  , 'dir')
    mkdir(  outputDir4Minute );
end

if ~exist(  outputDir5Minute  , 'dir')
    mkdir( outputDir5Minute  );
end

if ~exist(  outputDir6Minute  , 'dir')
    mkdir(  outputDir6Minute );
end

if ~exist(   outputDir7Minute , 'dir')
    mkdir(   outputDir7Minute );
end
if ~exist(  outputDir8Minute  , 'dir')
    mkdir(   outputDir8Minute);
end

if ~exist(  outputDir9Minute  , 'dir')
    mkdir(  outputDir9Minute );
end
if ~exist( outputDir10Minute   , 'dir')
    mkdir( outputDir10Minute  );
end

if ~exist( outputDir11Minute   , 'dir')
    mkdir( outputDir11Minute  );
end 
if ~exist(  outputDir12Minute  , 'dir')
    mkdir(  outputDir12Minute );
end

if ~exist(   outputDir13Minute , 'dir')
    mkdir(   outputDir13Minute);
end 
if ~exist(  outputDir14Minute , 'dir')
    mkdir(  outputDir14Minute );
end

if ~exist(outputDir15Minute, 'dir')
    mkdir(outputDir15Minute);
end

% Get a list of all CSV files in the directory
csvFiles = dir(fullfile(inputDir, '*.csv'));

%%
% Loop through each file
for i =   1:   length(csvFiles)
    % Load the file
    file = csvFiles(i);
    data = readtable(fullfile(inputDir, file.name));
    
    % Identify the first 3 columns and save them as 'coordinates'
    coordinates = data{:, 1:3};
    
    % Store columns 4-64 as 'intensity data'
    intensityData = data{:, 4:end};
    
    % Divide the intensity data into 'early', 'mid', and 'late' data
    earlyData = intensityData(:, 1:23);
    midData = intensityData(:, 22:43);
    lateData = intensityData(:, 43:end);


    o1Min_Data =  [ intensityData(:, 1),  intensityData(:, 3:4) ] ;
    o2Min_Data =  [ intensityData(:, 1),  intensityData(:, 7:8) ] ;
    o3Min_Data =  [ intensityData(:, 1),  intensityData(:, 11:12) ] ;
    o4Min_Data =  [ intensityData(:, 1),  intensityData(:, 15:16) ] ;
    o5Min_Data =  [ intensityData(:, 1),  intensityData(:, 19:20) ] ;
    o6Min_Data =  [ intensityData(:, 1),  intensityData(:, 23:24) ] ;
    o7Min_Data =  [ intensityData(:, 1),  intensityData(:, 27:28) ] ;
    o8Min_Data =  [ intensityData(:, 1),  intensityData(:, 31:32) ] ;
    o9Min_Data =  [ intensityData(:, 1),  intensityData(:, 25:36) ] ;
    o10Min_Data =  [ intensityData(:, 1),  intensityData(:, 39:40) ] ;
    o11Min_Data =  [ intensityData(:, 1),  intensityData(:, 43:44) ] ;
    o12Min_Data =  [ intensityData(:, 1),  intensityData(:, 47:48) ] ;
    o13Min_Data =  [ intensityData(:, 1),  intensityData(:, 51:52) ] ;
    o14Min_Data =  [ intensityData(:, 1),  intensityData(:, 56:56) ] ;
    o15Min_Data =  [ intensityData(:, 1),  intensityData(:, end-1:end) ] ;
    
    % Combine all the individual data with the coordinate data
    earlyDataCombined = [coordinates, earlyData];
    midDataCombined = [coordinates, midData(:, 2:end)]; % Handle overlap
    lateDataCombined = [coordinates, lateData(:, 2:end)]; % Handle overlap


    o1Min_Data_DataCombined = [coordinates,   o1Min_Data(:, : )];
    o2Min_Data_DataCombined = [coordinates,    o2Min_Data(:, : )];    
    o3Min_Data_DataCombined = [coordinates,    o3Min_Data(:, : )];
    o4Min_Data_DataCombined = [coordinates,    o4Min_Data(:, : )];
    o5Min_Data_DataCombined = [coordinates,    o5Min_Data(:, : )];
    o6Min_Data_DataCombined = [coordinates,   o6Min_Data(:, : )];
    o7Min_Data_DataCombined = [coordinates,    o7Min_Data(:, : )];
    o8Min_Data_DataCombined = [coordinates,    o8Min_Data(:, : )];
    o9Min_Data_DataCombined = [coordinates,    o9Min_Data(:, : )];
    o10Min_Data_DataCombined = [coordinates,    o10Min_Data(:, : )];
    o11Min_Data_DataCombined = [coordinates,    o11Min_Data(:, : )];
    o12Min_Data_DataCombined = [coordinates,    o12Min_Data(:, : )];
    o13Min_Data_DataCombined = [coordinates,    o13Min_Data(:, : )];
    o14Min_Data_DataCombined = [coordinates,    o14Min_Data(:, : )];
    o15Min_Data_DataCombined = [coordinates, o15Min_Data(:, : )];
    
   
    % Generate new filenames with prefix
    [~, baseFileName, ext] = fileparts(file.name);
    newFileNameEarly = ['Early_', baseFileName, ext];
    newFileNameMid = ['Mid_', baseFileName, ext];
    newFileNameLate = ['Late_', baseFileName, ext];


    newFileName_1Minute = ['1Minute_', baseFileName, ext];
    newFileName_2Minute = ['2Minute_', baseFileName, ext];
    newFileName_3Minute = ['3Minute_', baseFileName, ext];
    newFileName_4Minute = ['4Minute_', baseFileName, ext];
    newFileName_5Minute = ['5Minute_', baseFileName, ext];
    newFileName_6Minute = ['6Minute_', baseFileName, ext];
    newFileName_7Minute = ['7Minute_', baseFileName, ext];
    newFileName_8Minute = ['8Minute_', baseFileName, ext];
    newFileName_9Minute = ['9Minute_', baseFileName, ext];
    newFileName_10Minute = ['10Minute_', baseFileName, ext];
    newFileName_11Minute = ['11Minute_', baseFileName, ext];
    newFileName_12Minute = ['12Minute_', baseFileName, ext];
    newFileName_13Minute = ['13Minute_', baseFileName, ext];
    newFileName_14Minute = ['14Minute_', baseFileName, ext];
    newFileName_15Minute = ['15Minute_', baseFileName, ext];
    


    % Export each dataset to the respective directories
    % writematrix(earlyDataCombined, fullfile(outputDirEarly, newFileNameEarly));
    % writematrix(midDataCombined, fullfile(outputDirMid, newFileNameMid));
    % writematrix(lateDataCombined, fullfile(outputDirLate, newFileNameLate));

    writematrix(    o1Min_Data_DataCombined    ,fullfile( outputDir1Minute  , newFileName_1Minute  ) );
    writematrix(    o2Min_Data_DataCombined    ,fullfile( outputDir2Minute , newFileName_2Minute   ) );
    writematrix(    o3Min_Data_DataCombined    ,fullfile( outputDir3Minute , newFileName_3Minute   ) );
    writematrix(    o4Min_Data_DataCombined    ,fullfile( outputDir4Minute , newFileName_4Minute   ) );
    writematrix(    o5Min_Data_DataCombined    ,fullfile( outputDir5Minute , newFileName_5Minute   ) );
    writematrix(    o6Min_Data_DataCombined    ,fullfile( outputDir6Minute , newFileName_6Minute   ) );
    writematrix(    o7Min_Data_DataCombined    ,fullfile( outputDir7Minute , newFileName_7Minute   ) );
    writematrix(    o8Min_Data_DataCombined    ,fullfile( outputDir8Minute , newFileName_8Minute   ) );
    writematrix(    o9Min_Data_DataCombined    ,fullfile( outputDir9Minute , newFileName_9Minute   ) );
    writematrix(    o10Min_Data_DataCombined    ,fullfile( outputDir10Minute , newFileName_10Minute   ) );
    writematrix(    o11Min_Data_DataCombined    ,fullfile( outputDir11Minute , newFileName_11Minute   ) );
    writematrix(    o12Min_Data_DataCombined    ,fullfile( outputDir12Minute , newFileName_12Minute   ) );
    writematrix(    o13Min_Data_DataCombined    ,fullfile( outputDir13Minute , newFileName_13Minute   ) );
    writematrix(    o14Min_Data_DataCombined   ,fullfile( outputDir14Minute , newFileName_14Minute   ) ); 
    writematrix(    o15Min_Data_DataCombined   ,fullfile(outputDir15Minute, newFileName_15Minute));

end



disp('Processing complete.');