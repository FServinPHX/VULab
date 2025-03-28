
clear
clc
close all


% 14 to 20
%CaseLoad = 15;

shift = -1.5;
mult = 1.75;%1.75;


% case 4  |     shift = 11.5        |      mult = 1.75
% case 2  |     shift = -1.5        |      mult = 1.75


for CaseLoad = 4

GeneratedLabels = []; 

    %cd 'D:\ML COMSOL Models\0.0 Linked Ablation Vector\Results'
    switch CaseLoad
        case 1
            fileName ="D:\ML COMSOL Models\0.0 Linked Ablation Vector\Results\ Linked Ablation Ground Truth vs ML pred Volume_pct_Diff RUNS- 219 .csv" ;
            LabelType = 4;  
            initialTime = 2;
            timeSpacing = 60;   

        case 2
            fileName = "D:\ML COMSOL Models\0.0 Linked Ablation Vector\Results\ Linked Ablation Ground Truth vs ML pred Volume_pct_Diff RUNS- 219 alpha_p15.csv"
            LabelType = 4;  
            initialTime = 3;
            timeSpacing = 60; 


        case 3
            fileName =  "D:\Import To Matlab\01. Machine Learning Models Data\predict\ 0A_Synthetic_Vs_GroundTruth Volume_pct_Diff RUNS- 166 .csv";
            LabelType = 4;  
            initialTime = 1;
            timeSpacing = 60;   


         case 4
            fileName =  "D:\Import To Matlab\01. Machine Learning Models Data\predict\ 0B_MachineLearning_Vs_GroundTruth Volume_pct_Diff RUNS- 166 .csv";
            LabelType = 4;  
            initialTime = 3;
            timeSpacing = 60;    
            shift = -1.5;
            mult = 1.75;




    end 

% Combine the directory path with the filename to make the full filepath
%fileName = fullfile( pwd  , fileName);
%
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
pause(.25)





PctDiff = readmatrix(fileName);
PctDiff = -PctDiff';
PctDiff = PctDiff(:, 4:end)
PctDiff = (PctDiff + shift) .* mult;


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
data = PctDiff./1.5;
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
        spacing = 7.5; 






    idx = 2 : 1 : (15*4)+1 ;
    time = 1: spacing: numBoxes*spacing ;
    % Plotting individual data points
    figure('DefaultAxesFontSize',14)
        



        % Define the range for x values
        % Plot a line at y = 0 with a specific line thickness
        yline( 0, 'Color', 'r','LineWidth', 3);
        hold on 

        %%yArr = [-40, -30, -20, -10, 0, 10, 20, 30, 40];
        yArr = [ 20, 15, 10, 5, 0, -5, -10, -15, -20];
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
        caxis([-30, 5]);
        colormap jet
        hold on
        %pause(.25)

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

lower = meanValue - std( data(:) )    ;
upper = meanValue + std( data(:) )    ;

clim( [lower upper] )
clim( [   -20     10    ])
%axis equal
ylim([ (-20)  (20) ])
set(gcf,'position',[ 250, 150, 1400, 550]) 


hold off;
end 





