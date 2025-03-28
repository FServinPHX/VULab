clear
clc 



%    FALSE    TRUE
PlotProbes = "TRUE";
SavePlot = "TRUE";
export_DIR = "TRUE";


% Specify the directory you want to search in
GroundTruthDir = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIV\0 Degree'
% Create a pattern to match .mph files
GroundTruthfilePattern = fullfile(GroundTruthDir, '*.csv');
% Get a list of all files in the directory with .mph extension
GroundTruthFilesCSV = dir(GroundTruthfilePattern);
%SyntheticDataDir = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1 Resampled\Predictions'
SyntheticDataDir = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\Final_Predictions_0Degree'
% Create a pattern to match .mph files
SyntheticDatafilePattern = fullfile(SyntheticDataDir, '*.csv');
% Get a list of all files in the directory with .mph extension
SyntheticFilesCSV = dir(SyntheticDatafilePattern);



VideoName = "0_FinalRun_MachineLearning_Vs_GroundTruth Volume_pct_Diff RUNS-  5";



% Initialize an empty cell array to store the filenames
fileNameMatrix = cell(1, length(SyntheticFilesCSV));
% Extract all filenames
for i = 1:length(SyntheticFilesCSV)
    fileNameMatrix{i} = SyntheticFilesCSV(i).name;
end
Volume_Difference_all = [];
Node_Difference_all = [];




count = 1;


for CaseSelect = 1: 218


   
  currentFileName = fullfile(GroundTruthDir, GroundTruthFilesCSV( CaseSelect ).name)
  [best_filename, best_file_index, experimentNumber]= Aim3_SynthVsGT_findMatchingFile(  GroundTruthFilesCSV( CaseSelect ).name, ...
                                                     fileNameMatrix);
    bestFileName_full = fullfile(SyntheticDataDir, SyntheticFilesCSV( best_file_index ).name);
    [filepath, fname, fext]  = fileparts(bestFileName_full); 
    %
    % Read data from the CSV file
    GroundTruthData = csvread(currentFileName);
    SyntheticData = readtable(  bestFileName_full );
    SyntheticData = table2array(SyntheticData)  ;
    SyntheticData = [SyntheticData; SyntheticData(end, :)];
    QuerryPointsOG = GroundTruthData( :, 1:3);




    if PlotProbes == "TRUE"
     ProbeFilePath = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
     file_path  = GroundTruthFilesCSV( CaseSelect ).name;
     [ProbePointExport, plotedLine1, plotedLine2 ] =  A3_FindPlotPoints(file_path);  
     % plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3),   'k.', 'MarkerSize', 10)  
     % hold on 
   end 



[center_distance, angle_deg] = ProbelineMetrics(plotedLine1, plotedLine2) ;


% Node_Difference_all = [Node_Difference_all, [string( bestFileName_full ) ; string( currentFileName) ; 
%                                             experimentNumber; center_distance; angle_deg ]];



Node_Difference_all = [Node_Difference_all, [experimentNumber; center_distance; angle_deg ]];

end 


Node_Difference_all = Node_Difference_all';

    if export_DIR == "TRUE"
        ypred_fname = "0_ProbeInformation__MachineLearning_Vs_GroundTruth";
        %adjust = [.1, ones(1, 13) ] ; 
        Node_Difference_all = Node_Difference_all ;%.* adjust';
        exportDir = 'D:\Import To Matlab\01. Machine Learning Models Data\predict\Probe Information\';
        csvExportName = join([exportDir, ypred_fname, "Angle_and_MeanDist",...
                              "RUNS-", num2str(CaseSelect), ".csv"]);
        writematrix(  Node_Difference_all,  csvExportName);
        disp("Data Exported")
        disp( csvExportName )
    end 


%%




% Part II





clc
clear



probe_Data_Information = readtable( "D:\Import To Matlab\01. Machine Learning Models Data\predict\Probe Information\ 0_ProbeInformation__MachineLearning_Vs_GroundTruth Angle_and_MeanDist RUNS- 218 .csv" )
Volume_percent_error = readtable( "D:\Import To Matlab\01. Machine Learning Models Data\predict\ 0_FinalRun__MachineLearning_Vs_GroundTruth Volume_pct_Diff RUNS- 218 .csv" )


mat_probe_Data_Information = table2array(probe_Data_Information);
mat_Volume_percent_error = table2array(Volume_percent_error);

selected_error_data = mat_Volume_percent_error(4:end, :);
mean_mat_error = mean( selected_error_data, 1);

%%


% Sample data
% Distance From Center
x = mat_probe_Data_Information( :, 2 );
y = mat_probe_Data_Information( :, 3 );
intensity = mean_mat_error';
intensity =  filter_and_assign_nan(intensity);



% Filter out NaN values
validIndices = ~isnan(intensity);
x_valid = x(validIndices);
y_valid = y(validIndices);
intensity_valid = intensity(validIndices);

% Create a figure with a white background
figure('Color', 'w'); % Set the figure background to white

% Create a scatter plot with enhanced aesthetics
scatter(x_valid, y_valid, 150, intensity_valid, 'filled', 'LineWidth',  1.5, 'MarkerEdgeColor', 'k');






% Apply the 'jet' colormap

%colormap('jet')

    currentColormap = colormap('hot');
    % Reverse the colormap
    reversedColormap = flipud(currentColormap);
    % Apply the reversed colormap
    colormap(reversedColormap);


% % Define the desired color range
% color_min = -.5;   % Minimum value of the color range
% color_max = 4; % Maximum value of the color range
% 
% % Set the color axis limits
% caxis([color_min color_max]);


% Add a colorbar to indicate intensity values
cbar = colorbar; % Get the colorbar handle
cbar.Title.String = join(['Average', newline, 'Volume (%)', newline, 'error']); % Set the title of the colorbar
cbar.FontWeight = 'Bold';
cbar.FontSize = 14;

% Set the font and size for labels and title
font_size_val = 16;
set(gca, 'FontName', 'Arial', 'FontSize', font_size_val);
xlabel( join([newline, 'Distance From Center', newline, '(mm)', newline ]), 'FontWeight', 'Bold');
ylabel( join([newline, 'Angle Between Probes', newline, '(Degree/°)', newline ]), 'FontWeight', 'Bold');
title( join(['Probe Placement Prediction Metrics', newline]), 'FontSize', (font_size_val + 4) , 'FontWeight', 'Bold');

% Set grid for better visualization with a lighter and dotted grid line style
grid on;
set(gca, 'GridLineStyle', '--', 'GridColor', [0.1, 0.1, 0.1], 'GridAlpha', 0.2);

% Adjust axis limits if needed to improve visualization
xlim([min(x) - 0.5, max(x) + 0.5]);
ylim([min(y) - 0.5, max(y) + 0.5]);





function modified_intensity = filter_and_assign_nan(intensity)
    % Validate the input
    if length(intensity) < 72
        error('The intensity vector must have at least 72 elements.');
    end
    
    % Sort the intensity values in descending order and get their indices
    [~, indices] = sort(intensity, 'descend');
    
    % Initialize the output as NaN
    modified_intensity = nan(size(intensity));
    
    % Assign the top 72 values to their original positions
    modified_intensity(indices(1:72)) = intensity(indices(1:72));
end


