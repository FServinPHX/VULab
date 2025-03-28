% Load the data matrix
%clear


% file_path = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\T_ThetaD_Electric Field\BoxPhantomMultiprobe_TrueBeef0Degrees_Refined_9.9mmSpc.csv";
% arrhenius_thresh = .98;

function [export] = FC_ProcessArrTempElectricField(file_path, arrhenius_thresh )


[filepath,name,ext] = fileparts(file_path);    
OGdata = readtable(file_path);
data = table2array(OGdata);

% Extract the coordinates, temperature, arrhenius, and electric field values
coords = data(:, 1:3);
temperature = data(:, 4);
arrhenius = data(:, 5);
electricField = data(:, 6);
%
% Separate the temperature, arrhenius, and electric field values for each time point
numTimePoints = (size(data, 2) - 3) / 3;  % Calculate the number of time points
timePoints = cell(numTimePoints, 1);

for i = 1:numTimePoints
    startIndex = 4 + (i - 1) * 3;
    endIndex = startIndex + 2;
    timePoints{i} = data(:, startIndex:endIndex);
end

%
% Iterate over each time point and find points with arrhenius values > 0.98
pointsWithArrheniusAbove98 = zeros( 60000, endIndex-3);
%pointsWithArrheniusAbove98 = array2table(pointsWithArrheniusAbove98);


for i = 1: numTimePoints
    
    a = ( (i-1)*5 +1);
    b = ( (i-1)*5 +5);
    
    arrheniusValues = timePoints{i}(:, 2);
    electricFieldValues =  timePoints{i}(:, 3);
    
    indices = arrheniusValues > arrhenius_thresh;
    numentries = length(arrheniusValues(indices));
    
    
    pointsWithArrheniusAbove98( 1:numentries, a:b ) = ...
         [coords(indices, :), arrheniusValues(indices), electricFieldValues(indices)] ;
    
end

%

AllTitle = [];
for i = 1:numTimePoints
    
    Title = ["X","Y","Z","Arr","ElecField"]; 
    idx = 1 : 1 : (15*4)+1 ; 
    minutes =  floor( (idx(i)*15-15)/60) ; 
    seconds  = mod( (idx(i)*15-15), 60)    ;
    
    for j = 1:5
        Title(j) = join( [Title{j}, " ", num2str(minutes), "m", num2str(seconds), "s"]);
    end 
    
    AllTitle = [AllTitle, Title];
end 
    
 %

export= table([ AllTitle; pointsWithArrheniusAbove98]);
 
 
% %  Save the data for the current time point as a CSV file
% % fileName = sprintf('time_point_%d.csv', i);
% % csvwrite(fileName, pointsWithArrheniusAbove98);


end 


