
clear
clc
close all


% 14 to 20
%CaseLoad = 15;

for CaseLoad = 24

GeneratedLabels = []; 

    cd 'D:\Import To Matlab\01. Machine Learning Models Data\predict\'
    switch CaseLoad
        case 1
            fileName = "all_predictions_Model4___ONLY POINTS Volume_pct_Difference.csv";
            LabelType = 1;
        case 2
            fileName = "all_predictions_Linked Ablation__Model4___ONLY POINTS_ v2 Volume_pct_Difference.csv";
            LabelType = 1;
        case 3
            fileName = "all_predictions_Linked Ablation__Model3___ONLY POINTS_ v3 Volume_pct_Difference.csv";
            LabelType = 1;
        case 4
            fileName = "all_predictions_Linked Ablation__Model4___ONLY POINTS_ v4 Volume_pct_Difference.csv";
            LabelType = 1;
        case 5
            fileName = " all_predictions_Linked Ablation__Model4___ONLY POINTS_ v5 Volume_pct_Difference___SPIE.csv";
            LabelType = 2;
        case 6 
             fileName = "all_predictions__  transformer_model    Binary Mask _ Distances.csv";
             LabelType = 1;
        case 7 
             fileName = " all_predictions_Binary_Mask_  Distances Volume_pct_Difference.csv";
             LabelType = 2;
        case 8
            fileName =  " 7___all_predictions__  Binary Mask _ Distances  __ptII Transformer_I Volume_pct_Difference___SPIE.csv";
            LabelType = 2;

        case 9
            fileName = " 21-All Predictions_model Pytorch Distances_10 EPOCH   Volume_pct_Difference___SPIE.csv";
            LabelType = 3;

        case 10
            fileName = " 22-All Predictions_model Pytorch Distances_10 EPOCH__Part2   Volume_pct_Difference___SPIE.csv";
            LabelType = 3;        

        case 11
            fileName = " 25-All Predictions_model Pytorch SDA_Distances_EARLY_20 EPOCH__Part2   Volume_pct_Difference___SPIE RUNS- 114 .csv";
            LabelType = 4;  
            initialTime = 1;
            timeSpacing = 15;


        case 12
            fileName = " 26-All Predictions_model Pytorch SDA_Distances_Late_18 EPOCH__Part2   Volume_pct_Difference___SPIE.csv";
            LabelType = 4;  
            initialTime = 9;
            timeSpacing = 60;

        case 13
            fileName =  " 27-All Predictions_model Pytorch SDA_Distances_Middle_23 EPOCH__Part2   Volume_pct_Difference___SPIE_2 RUNS- 114 .csv";
            LabelType = 4;  
            initialTime = 5;
            timeSpacing = 15;


        case 14
            fileName =  " 29-All Predictions_model Pytorch SDA_Distances_1 min_20 EPOCH__Part3   Volume_pct_Difference___SPIE_2 RUNS- 114 .csv"
            LabelType = 4;  
            initialTime = 1;
            timeSpacing = 15;    

        case 15
            fileName =  " 30All Predictions_model Pytorch SDA_Distances__3min_model_epoch_13   Volume_pct_Difference___SPIE_2 RUNS- 114 .csv"
            LabelType = 4;  
            initialTime = 3;
            timeSpacing = 15;  

        case 16
            fileName =  " 31All Predictions_model Pytorch SDA_Distances__5min_model_epoch_19   Volume_pct_Difference___SPIE_2 RUNS- 114 .csv"
            LabelType = 4;  
            initialTime = 5;
            timeSpacing = 15;  

        case 17
            fileName =  " 32All Predictions_model Pytorch SDA_Distances__7Minute model_epoch_20   Volume_pct_Difference___SPIE_2 RUNS- 114 .csv"
            LabelType = 4;  
            initialTime = 7;
            timeSpacing = 15;  

        case 18
            fileName =  " 33All Predictions_model Pytorch SDA_Distances_PT_II_10minute_model_epoch_20   Volume_pct_Difference___SPIE_2 RUNS- 114 .csv"
            LabelType = 4;  
            initialTime = 10;
            timeSpacing = 15;  

        case 19
            fileName =  " 34All Predictions_model Pytorch SDA_Distances_PT_II_12minute_model_epoch_8   Volume_pct_Difference___SPIE_2 RUNS- 114 .csv"
            LabelType = 4;  
            initialTime = 12;
            timeSpacing = 15;  

         case 20
            fileName =  " 35All Predictions_model Pytorch SDA_Distances_PT_II_15minute_model_epoch_20   Volume_pct_Difference___SPIE_2 RUNS- 204 .csv"
            LabelType = 4;  
            initialTime = 15;
            timeSpacing = 15;             


         case 21
            fileName =  "36All Predictions_model Pytorch SDA_Distances_PT Three_(PT II Resampled)_model_epoch_12   Volume_pct_Difference___SPIE_2 RUNS- 135 .csv"
            LabelType = 4;  
            initialTime = 1;
            timeSpacing = 15;             


         case 22
            fileName =  " 38All Predictions_model Pytorch SDA_Distances_PT Four (Actual Part Four)_model_epoch_8   Volume_pct_Difference___SPIE_2 RUNS- 124 .csv"
            LabelType = 4;  
            initialTime = 1;
            timeSpacing = 15;     


          case 23
            fileName =  " 39All Predictions_model Pytorch SDA_Distances_PT Four (Actual Part Four)_model_epoch_19   Volume_pct_Difference___SPIE_2 RUNS- 124 .csv";
            LabelType = 4;  
            initialTime = 1;
            timeSpacing = 15;        

           case 24
            fileName =  " 39All Predictions_model Pytorch SDA_Distances_PT Four (Actual Part Four)_model_epoch_19   Volume_pct_Diff RUNS- 124 .csv";
            LabelType = 4;  
            initialTime = 3;
            timeSpacing = 60;   
            start_column = 3;
    end 


% Combine the directory path with the filename to make the full filepath
fileName = fullfile( pwd  , fileName);
%
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
pause(.25)





PctDiff = readmatrix(fileName);
PctDiff = PctDiff';



% Check if 'start_column' variable exists
if exist('start_column', 'var')
    % Update 'PctDiff' by selecting columns from 'start_column' to the end
    PctDiff = PctDiff(:, start_column:end);
end



%
%
%
%PctDiff = fliplr(PctDiff);
%
%

switch LabelType 
    case 1
        labels = {'3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13'};
    case 2
        labels = { '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15'};
    case 3
        labels = { '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15'};
    case 4 
        labels = generateTimeLabels(initialTime, timeSpacing, PctDiff); 
end 




%
% Generate random data
numBoxes = size(PctDiff,2)  ; % Number of boxplots
numPoints = size(PctDiff,1)  ; % Number of data points for each boxplot
data = PctDiff;
% Define time points







        miny = min(min(PctDiff));
        maxy = max(max(PctDiff));
        if miny < -50
            miny = -50;
        end 
        if maxy > 50
            maxy = 70;
        end 
        spacing  = abs( ceil( (maxy - miny)/8 )) ; 







    idx = 2 : 1 : (15*4)+1 ;
    time = 1: spacing: numBoxes*spacing ;
    % Plotting individual data points
    figure('DefaultAxesFontSize',14)
        



        % Define the range for x values
        % Plot a line at y = 0 with a specific line thickness
        yline( 0, 'Color', 'r','LineWidth', 3);
        hold on 

        %yArr = [-40, -30, -20, -10, 0, 10, 20, 30, 40];
        yArr = [ -2, 0, 2, 4, 6, 8];
            %
        for ki = 1:length(yArr)
            yline( yArr(ki) , 'Color', rgb("Silver"))
        end 
        % 
        % yline(-20, 'Color', rgb("Silver"))
        % yline(-30, 'Color', rgb("Silver"))
        % yline(-40, 'Color', rgb("Silver"))
        % yline(10, 'Color', rgb("Silver"))
        % yline(20, 'Color', rgb("Silver"))
        % yline(30, 'Color', rgb("Silver"))
        % yline(40, 'Color', rgb("Silver"))      
%axis equal

for i = 1: numBoxes
    
        timec =   time(i); 
        x = repmat(timec, numPoints, 1); 
        c = data(:,i);
        s= scatter( x , data(:,i) , [], c , 'filled') ;
        s.SizeData = 10;
        c = colorbar;
        caxis([-4, 10]);
        colormap jet
        hold on

end 


        % Plotting boxplots
        boxplot(data, 'positions', time, 'Labels', labels);
        ylabel('% Vol Difference');
        xlabel('Time (min)');
        %title('Global % Vol Difference Vs. Time');
        
        set(gcf,'color','w');
        %axis equal;
        %xlim(  [time(1)-10,  time(end)+10] )




meanValue = mean(data(:));
yline( meanValue , 'Color', rgb("Aqua"), 'LineWidth', 3)


axis equal
ylim([ (-4)  (10) ])
%set(gcf,'position',[ 250, 150, 1400, 550]) 


hold off;
end 





