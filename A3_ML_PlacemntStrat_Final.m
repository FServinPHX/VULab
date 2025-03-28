

clear
close all
clc


tic

StartingPlacement = readtable( "D:\Import To Matlab\Aim 3_ProbePlacements\Start Pacements.csv");
AdditionalPlacementPoints = readtable("D:\Import To Matlab\Aim 3_ProbePlacements\Additional Placements.csv");
radiusSrtArr = [9.9, 14.95 , 19.8, 24.75, 29.7, 34.65];
plotPoints = "TRUE";
iCreateVideo = "TRUE";
%
   
    if iCreateVideo == "TRUE"    
        figure;   
        Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\ML Placement";
        Video_FileName = join([  "Viable Probe Strategies Part II"  ,'.avi']);
        Video_FileName = convertStringsToChars(Video_FileName);
        Video_fullfile = fullfile(Video_Dir, Video_FileName);
        videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
        videoWriter.FrameRate = 3;
        videoWriter.Quality = 100; % High quality video
        open(videoWriter);
    end


% Define the points as a matrix
OGpoints = table2array(StartingPlacement(:, 3:end));
DualPairPts  = table2array(AdditionalPlacementPoints(:, 3:end)); 
% Initialize an empty cell array to store indices
indicesOverDist = cell(size(OGpoints, 1), 1);
indicesOverDistTip = cell(size(OGpoints, 1), 1);
BestIndicies = cell(size(OGpoints, 1), 1);
% Loop through each row of points
%
for i = 1:size(OGpoints,1)
    % Extract the second set of points from the current row
    point1 = OGpoints(i, 4:6);
    points1Tip = OGpoints(i, 1:3);
    % Initialize an empty array to store distances
    distances = zeros(size(OGpoints, 1), 1);
    distances1Tip = zeros(size(OGpoints, 1), 1);
    % Loop through all other rows 
    for j = 1:size(DualPairPts,1)
        if i ~= j
            % Extract the second set of points from the other row
            point2 = DualPairPts(j, 4:6);
            point2tTip = DualPairPts(j, 1:3);
            % Calculate the Euclidean distance
            distances(j) = sqrt(sum((point1 - point2).^2));
            distances1Tip(j) = sqrt(sum((points1Tip - point2tTip).^2));
        end
    end
    % Find indices where distance is greater than 10 units
    indicesOverDist{i} = find(distances > 8 & distances < 30 );
    indicesOverDistTip{i} = find(distances1Tip > 5 );
    BestIndicies{i} = intersect( indicesOverDist{ i, 1} , indicesOverDistTip{i, 1} );
end







%
%FIGURES
ALL_OGProbes = [];
for i_ex = 1: size(OGpoints, 1)
    CurrProbePts =  OGpoints(i_ex ,:) ;
    % A = top point.. B = Bottom Point
    Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
    Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ]; 
    % Step 4: Create 100 points in between A and B
    t = linspace(0, 1, 100); 
    Array1 = [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';

    ALL_OGProbes = [ALL_OGProbes; Array1] ;
end 


ALL_SearchProbes = [];
for i_ex = 1: size(DualPairPts, 1)
    CurrProbePts =  DualPairPts(i_ex ,:) ;
    % A = top point.. B = Bottom Point
    Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
    Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ]; 
    % Step 4: Create 100 points in between A and B
    t = linspace(0, 1, 100); 
    Array1 = [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';

    ALL_SearchProbes = [ALL_SearchProbes; Array1] ;

end 




A___DifferenceData = cell(size(OGpoints, 1), 1);

if plotPoints == "TRUE"

    for icurrProbe = 1: size(OGpoints, 1)
    
    
    plot1.X = ALL_SearchProbes(:,1);           plot1.Y = ALL_SearchProbes(:,2); 
    plot1.Z = ALL_SearchProbes(:,3);   
    plot3( plot1.X , plot1.Y , plot1.Z, '.', 'Color', 'k', 'MarkerSize', 2    )
    hold on
    set(gcf,'color','w');
    axis equal;
    grid off
    axis off
    % xlabel('X', 'FontSize', 14);
    % ylabel('Y', 'FontSize', 14);
    % zlabel('Z', 'FontSize', 14);
    title( join(["Viable Placement Strategy",newline, "For Probe", num2str(icurrProbe)]) ,'FontSize', 18)
    set(gcf,'position',[ 250, 150, 650, 600])  
    view([ 30 80])
    
    
    
    AllDifferances = []    ;
    %PLLOT ALL THE PROBES THAT ARE SUFFICIENTLY FAR APART FROM THE SELECTED
    %PROBE STRATEGY
    currentProbeIndex = BestIndicies{ icurrProbe, 1}  ;
    Current_length = length(currentProbeIndex);
        for i_ex = 1: Current_length
         %***
            if i_ex == 1
                    CurrProbePts =  OGpoints(icurrProbe,:) ;
                    % A = top point.. B = Bottom Point
                    Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
                    Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ];
                    MarkrColr = 'r'; 
                    % Step 4: Create 100 points in between A and B
                    t = linspace(0, 1, 100); 
                    Array1 = [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';
                    plot1.X = Array1(:,1);           plot1.Y = Array1(:,2);            plot1.Z = Array1(:,3);                   
            else
                    
                    CurrProbePts =  DualPairPts( currentProbeIndex(i_ex-1) ,:) ;
                    % A = top point.. B = Bottom Point
                    Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
                    Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ];
                    MarkrColr = 'c'; 
                    % Step 4: Create 100 points in between A and B
                    t = linspace(0, 1, 100); 
                    Array2= [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';
                    plot1.X = Array2(:,1);           plot1.Y = Array2(:,2);            plot1.Z = Array2(:,3);     
    
    
    
                    difference = sqrt(sum((Array1 - Array2).^2, 2));
                    AllDifferances = [AllDifferances; ...
                                            icurrProbe, currentProbeIndex(i_ex-1)  difference']    ;
            end 
    
            plot3( plot1.X , plot1.Y , plot1.Z, '.', 'Color', 'k', 'MarkerSize', 8     )
            hold on
            scatter3(  plot1.X(80),  plot1.Y(80),  plot1.Z(80), 'SizeData', 30, 'MarkerEdgeColor', MarkrColr,'LineWidth', 4 )
    
                

        end


        if iCreateVideo == "TRUE"
            Frame = getframe(gcf) ;                
            writeVideo(videoWriter,Frame)  
        end     
        % pause(.1)
        hold off
        A___DifferenceData{icurrProbe} = AllDifferances; 
    end  
        if iCreateVideo == "TRUE" 
        close(videoWriter); 
        disp("Video Complete")
        disp(videoWriter.Filename  )
    end 




else

    for icurrProbe = 1: size(OGpoints, 1)
    AllDifferances = []    ;
    %PLLOT ALL THE PROBES THAT ARE SUFFICIENTLY FAR APART FROM THE SELECTED
    %PROBE STRATEGY
    currentProbeIndex = BestIndicies{ icurrProbe, 1}  ;
    Current_length = length(currentProbeIndex);
        for i_ex = 1: Current_length
            if i_ex == 1
                    CurrProbePts =  OGpoints(icurrProbe,:) ;
                    % A = top point.. B = Bottom Point
                    Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
                    Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ];
                    MarkrColr = 'r'; 
                    % Step 4: Create 100 points in between A and B
                    t = linspace(0, 1, 100); 
                    Array1 = [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';
                    plot1.X = Array1(:,1);           plot1.Y = Array1(:,2);            plot1.Z = Array1(:,3);                   
            else
                    
                    CurrProbePts =  DualPairPts( currentProbeIndex(i_ex-1) ,:) ;
                    % A = top point.. B = Bottom Point
                    Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
                    Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ];
                    MarkrColr = 'c'; 
                    % Step 4: Create 100 points in between A and B
                    t = linspace(0, 1, 100); 
                    Array2= [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';
                    plot1.X = Array2(:,1);           plot1.Y = Array2(:,2);            plot1.Z = Array2(:,3);     
                    difference = sqrt(sum((Array1 - Array2).^2, 2));
                    AllDifferances = [AllDifferances; ...
                                            icurrProbe, currentProbeIndex(i_ex-1)  difference']    ;
            end 
    
    
            A___DifferenceData{icurrProbe} = AllDifferances;
        end 
    end 

end
toc


%%

tic
A___AllDistances = []; 
for i = 1: size(A___DifferenceData, 1)
    A___AllDistances = [A___AllDistances;  A___DifferenceData{i} ];
end 

OtherDifferenceData =   A___AllDistances( : , 3:end);
A____ALLComparisons_WPos = [];
for i = 1:  size(A___AllDistances, 1)
    CurrentDifference = A___AllDistances(  i, 3:end) ;
    comparison = abs(OtherDifferenceData - CurrentDifference);
    Sumcomparison = sum(comparison, 2);
    A____ALLComparisons_WPos = [ A____ALLComparisons_WPos;  ...
                                A___AllDistances(i, 1:2), Sumcomparison' ];
end 

toc

%%

tic



%FIND WHICH PROBE PLACEMENTS ARE THE SAME


% Step 2: Find the indices (row and column) of the zeros
A____ALLComparisons = A____ALLComparisons_WPos(:, 3:end);
[m.rows, m.cols] = find(A____ALLComparisons == 0);
% Store the information of indices
zeroIndices = [m.rows, m.cols];
% Step 2: Create a cell array based on criteria
cellArray = cell( length(zeroIndices), 1); % Preallocate cell array for 10 groups
for i = 1:size( (A____ALLComparisons),1)
    % Step 3 & 4: Find and group rows based on the first column value
    % Extract rows where the first column equals i and store them in the cell
    cellArray{i} = zeroIndices(zeroIndices(:,1) == i, :);
end

UniqueGroupsCellArray = cell( length(zeroIndices), 1); % Preallocate cell array for 10 groups
KeepingTrack = [0];
groupcount = 1;
for i = 1:size( (A____ALLComparisons),1)

    c = unique(cellArray{i} );
    % Determine if any value of A exists in B
    isValueExist = any(ismember(c, KeepingTrack), 'all');
    
    % Display the result
    if isValueExist
        groupcount = groupcount; 
    else
        KeepingTrack = [KeepingTrack; c];
        UniqueGroupsCellArray{groupcount} = c;
        groupcount = groupcount +1;
    end
end


UniqueGroupsCellArray = UniqueGroupsCellArray(~cellfun('isempty', UniqueGroupsCellArray));


% Step 2: Reorder the cell array from most elements to least elements
% Calculate the number of elements in each cell
numElementsArray = cellfun(@numel, UniqueGroupsCellArray); % Use cellfun to apply numel to each cell

% Get the indices that would sort the cell array based on the number of elements
[~, sortedIndices] = sort(numElementsArray, 'descend');

% Apply the sorted indices to reorder the cell array
sortedUniqueGroups = UniqueGroupsCellArray(sortedIndices);



ProbeCombinations =  A____ALLComparisons_WPos(:, 1:2);
ProbeColors = [ rgb("DarkGreen");  rgb("Sienna");  rgb("DodgerBlue");   rgb("PaleVioletRed");  ...
                rgb("DarkSlateGray");   rgb("DarkOrange");   rgb("DarkViolet"); rgb("Navy") ] ;
plot0.X = ALL_SearchProbes(:,1);           plot0.Y = ALL_SearchProbes(:,2); 
plot0.Z = ALL_SearchProbes(:,3);  
plot02.X = ALL_OGProbes(:,1);           plot02.Y = ALL_OGProbes(:,2); 
plot02.Z = ALL_OGProbes(:,3);  



plotGroups = "TRUE";



if plotGroups == "TRUE"


    iCreateVideo = "TRUE";
    if iCreateVideo == "TRUE"    
        figure;   
        Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\ML Placement";
        Video_FileName = join([  "Identifying Similar Probe Placements"  ,'.avi']);
        Video_FileName = convertStringsToChars(Video_FileName);
        Video_fullfile = fullfile(Video_Dir, Video_FileName);
        videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
        videoWriter.FrameRate = .75;
        videoWriter.Quality = 100; % High quality video
        open(videoWriter);
    end
    
    
    
    
    
    MYcolormap = hsv( 22 );
    for i = 1:20 %size(UniqueGroupsCellArray,1)
                scatter1 = scatter3( plot0.X , plot0.Y , plot0.Z,  'MarkerFaceColor', 'b', ...
                    'MarkerEdgeColor', 'none');
                alpha(scatter1, .02)
                hold on
                % scatter2 = scatter3( plot02.X , plot02.Y , plot02.Z,  'MarkerFaceColor', 'b', ...
                %      'MarkerEdgeColor', 'none');
                % alpha(scatter2, .02)
                set(gcf,'color','w');
                axis equal;
                grid off
                axis off
                % xlabel('X', 'FontSize', 14);
                % ylabel('Y', 'FontSize', 14);
                % zlabel('Z', 'FontSize', 14);
                title( join(["Identifying Similar Placements",newline, ...
                    "Group", num2str(i)]) ,'FontSize', 20)
                set(gcf,'position',[ 250, 150, 650, 600])  
                view([ 30 80])
    
       group1 = sortedUniqueGroups{i};
       for j = 1:length(group1)
    
    
           prbNum = group1(j);
           probe1id = ProbeCombinations(prbNum, 1);
           probe2id = ProbeCombinations(prbNum, 2);
           %
           probepts1 = OGpoints(probe1id, :);
           probepts2 = DualPairPts(probe2id, :);
    
    
            Av = [ probepts1(end-2), probepts1(end-1), probepts1(end ) ];
            Bv = [ probepts1( 1 ), probepts1( 2 ), probepts1( 3 ) ];
            Cv = [ probepts2(end-2), probepts2(end-1), probepts2(end ) ];
            Dv = [ probepts2( 1 ), probepts2( 2 ), probepts2( 3 ) ];        
            MarkrColr = 'c'; 
    
            % Step 4: Create 100 points in between A and B
            t = linspace(0, 1, 100); 
            Array1= [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';
            Array2= [Cv(1) + (Dv(1)-Cv(1))*t; Cv(2) + (Dv(2)-Cv(2))*t; Cv(3) + (Dv(3)-Cv(3))*t]';
            plot1.X = Array1(:,1);           plot1.Y = Array1(:,2);            plot1.Z = Array1(:,3);     
            plot2.X = Array2(:,1);           plot2.Y = Array2(:,2);            plot2.Z = Array2(:,3); 
    
    
            
            p1 = scatter3( plot1.X , plot1.Y , plot1.Z, 'filled', ...
                            'MarkerFaceColor', MYcolormap( (mod(i,20)+1) ,:)    );
            hold on
            p2 = scatter3( plot2.X , plot2.Y , plot2.Z, 'filled', ...
                            'MarkerFaceColor', MYcolormap( (mod(i,20)+1) ,:)       );       
    
            line = [plot1.X(80),  plot1.Y(80),  plot1.Z(80); ...
                    plot2.X(80),  plot2.Y(80),  plot2.Z(80)];
            p3 = plot3( line(:,1), line(:,2), line(:,3), 'color', 'k', 'LineWidth', 2);
            
    
            % scatter3(  plot1.X(80),  plot1.Y(80),  plot1.Z(80), 'SizeData', 50,...
            %     'MarkerEdgeColor', ProbeColors( j ,:),'LineWidth', 4 )
            % scatter3(  plot2.X(80),  plot2.Y(80),  plot2.Z(80), 'SizeData', 50,...
            %     'MarkerEdgeColor', ProbeColors( j ,:),'LineWidth', 4 )
    
    
            pause(.2)
            if iCreateVideo == "TRUE"
                Frame = getframe(gcf) ;                
                writeVideo(videoWriter,Frame)  
            end 
    
    
            alpha(p1, .25)
            alpha(p2, .25)
            delete(p3)
       end 
       hold off
       pause(1)
    
    end
        
    
      
    if iCreateVideo == "TRUE" 
        close(videoWriter); 
        disp("Video Complete")
        disp(videoWriter.Filename  )
    end 

end 






exportData = "FALSE";
if exportData == "TRUE"


        % Define the points as a matrix
        OGpointsALL = table2array(StartingPlacement(:, :));
        DualPairPtsALL  = table2array(AdditionalPlacementPoints(:, :)); 
         A___ExportProbeInfoAll  = []; 
        for i = 1:size(UniqueGroupsCellArray,1)
        
        group1 = sortedUniqueGroups{i};
               for j = 1:1 %length(group1)
            
            
                   prbNum = group1(j);
                   probe1id = ProbeCombinations(prbNum, 1);
                   probe2id = ProbeCombinations(prbNum, 2);
                   %
                   probepts1export = OGpointsALL(probe1id, 1:5);
                   probepts2export = DualPairPtsALL(probe2id, 1:5);
        
                   A___ExportProbeInfoAll = [A___ExportProbeInfoAll; probepts1export, probepts2export];
               end 
        end 




       resultsDir= 'D:\Import To Matlab\Aim 3_ProbePlacements';
       resultsDir2 = join([resultsDir ]) ;  
       ExportFileName = join([ 'Matlab_ML_COMSOL_Placement','.csv' ])  ;

        exportTitle = fullfile(resultsDir2, ExportFileName);
                % Step 2: Convert the matrix to a table
        dataTable = array2table(A___ExportProbeInfoAll);
        
        % Step 3: Name each column of the table
        columnNames = {'Theta1', 'Psi1', 'X_Tip1', 'Y_Tip1', 'Z_Tip1', ...
                       'Theta2', 'Psi2', 'X_Tip2', 'Y_Tip2', 'Z_Tip2'};
        dataTable.Properties.VariableNames = columnNames;
        
        % Display the first few rows of the table to verify
        disp(dataTable(1:5, :));
    
        %-----------------------------------------%         Write the filename
        writetable( dataTable  , exportTitle);         

end 

toc
