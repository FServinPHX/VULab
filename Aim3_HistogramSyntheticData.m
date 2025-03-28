


clear 
clc



SyntheticData_name = "D:\Import To Matlab\01. Machine Learning Models Data\predict\ 0A_Synthetic_Vs_GroundTruth Volume_pct_Diff RUNS- 166 .csv";
%SyntheticData_name = "D:\Import To Matlab\01. Machine Learning Models Data\predict\ 0B_MachineLearning_Vs_GroundTruth Volume_pct_Diff RUNS- 166 .csv";
%SyntheticData_name ="D:\Import To Matlab\01. Machine Learning Models Data\predict\0A_Synthetic_Vs_GroundTruth Volume_pct_Diff RUNS- 166_IDbottom.csv" ;
% Create a pattern to match .mph files
%SyntheticData = readtable(  SyntheticData_name );
SyntheticData = readtable(SyntheticData_name, 'TextType', 'string');

SyntheticData_mat = table2array( SyntheticData( 2:end,:) );
experiment_number = table2array( SyntheticData( 1,:) );

% Load your data here. Assuming 'data' is a matrix where each column is an experiment's data.
% Replace this line with actual data loading if necessary
%data = rand(100, 15);  % Example: 100 observations for 5 models (columns)
% Calculate the mean for each experiment (column)
Plot_type = "All"



% Generate a boxplot for the calculated means
figure('DefaultAxesFontSize',14)
 




switch Plot_type 
    case "Means"
        means = mean(SyntheticData_mat);
        means = means';

        initialTime = 1;
        timeSpacing = 60;   
        labels = generateTimeLabels(initialTime, timeSpacing, means); 

        boxplot(means, 'Labels', labels );
        title('Boxplot of Model Performance Means');
        xlabel('Models');
        ylabel('Mean Performance');

    case "All"
        means = SyntheticData_mat'*-1;

        initialTime = 1;
        timeSpacing = 60;   
        labels = generateTimeLabels(initialTime, timeSpacing, means); 

        boxplot(means, 'Labels', labels );
        ylabel('% Vol Difference');
        xlabel('Time (min)');
end 
%







hold on 
numBoxes = size(means,2)  ; % Number of boxplots
numPoints = size(means,1)  ; % Number of data points for each boxplot
data = means;
%
for i = 1: numBoxes
    
    
        timec =   i; 
        x = repmat(timec, numPoints, 1); 
        c = data(:,i);
        s= scatter( x , data(:,i) , [], c , 'filled') ;
        s.SizeData = 10;
        c = colorbar;
        caxis([-80, 10]);
        ylim([-90 10])
        colormap jet
        hold on

end 
set(gcf,'color','w');   

yline( 0, 'Color', 'r','LineWidth', 3);



%%

% Determine the quartiles for the means
quartiles = quantile(means, [0.25, 0.5, 0.75]);

% Assign quartile index (i.e., 1st, 2nd, 3rd, 4th) to each column mean
quartile_indices = zeros(size(means));
for i = 1:length(means)
    if means(i) <= quartiles(1)
        quartile_indices(i) = 1; % 1st quartile
    elseif means(i) <= quartiles(2)
        quartile_indices(i) = 2; % 2nd quartile
    elseif means(i) <= quartiles(3)
        quartile_indices(i) = 3; % 3rd quartile
    else
        quartile_indices(i) = 4; % 4th quartile
    end
end

% Prepend the quartile index to each column of data
enhanced_data = [ quartile_indices'; experiment_number ; mean(SyntheticData_mat); SyntheticData_mat];

% Export the modified dataset to a CSV file
%csvName = 'D:\Import To Matlab\01. Machine Learning Models Data\predict\ 0A_Synthetic_Vs_GroundTruth_model_performance.csv'
%writematrix(  enhanced_data    ,    csvName);

disp('Analysis complete. Results saved to enhanced_model_performance.csv');



%%



