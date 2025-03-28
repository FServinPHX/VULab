
clear
clc

chooseType = 1; 
CaseSelect = 5;



for chooseType = 1:1

switch CaseSelect
    case 0
        xtname = "D:\Import To Matlab\01. Machine Learning Models Data\X_train_Data__ONLY POINTS.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_train_Data__ONLY POINTS.csv";
        yPred_Name = "D:\Import To Ma lab\01. Machine Learning Models Data\all_predictions_Model4___ONLY POINTS.csv";
    case 1
        xtname = "D:\Import To Matlab\01. Machine Learning Models Data\X_test_Data_ONLY POINTS.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_test_Data_ONLY POINTS.csv";
        yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\all_predictions_Linked Ablation__Model4___ONLY POINTS.csv";
    case 2
        xtname = "D:\Import To Matlab\01. Machine Learning Models Data\X_test_Data_ONLY POINTS_ v2.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_test_Data_ONLY POINTS_ v2.csv";
        yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\all_predictions_Linked Ablation__Model4___ONLY POINTS_ v2.csv";
    case 3
        xtname =  "D:\Import To Matlab\01. Machine Learning Models Data\X_test_Data_ONLY POINTS_ v3.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_test_Data_ONLY POINTS_ v3.csv" ;
        yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\all_predictions_Linked Ablation__Model3___ONLY POINTS_ v3.csv";
    case 4
        xtname =  "D:\Import To Matlab\01. Machine Learning Models Data\X_test_Data_ONLY POINTS_ v4.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_test_Data_ONLY POINTS_ v4.csv" ;
        yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\all_predictions_Linked Ablation__Model4___ONLY POINTS_ v4.csv";
    case 5
        xtname =  "D:\Import To Matlab\01. Machine Learning Models Data\PointNet Models\X_test_Data_ONLY POINTS_ v5.csv" ;
        Ytname =  "D:\Import To Matlab\01. Machine Learning Models Data\PointNet Models\y_test_Data_ONLY POINTS_ v5.csv";

        yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\PointNet Models\\all_predictions_Linked Ablation__Model4___ONLY POINTS_ v5.csv";
        %yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\PointNet Models\\all_predictions_Linked Ablation__Model3___ONLY POINTS_ v5___ PT_II.csv";
        %yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\PointNet Models\all_predictions_Linked Ablation__Model3___ONLY POINTS_ v5___ PT_III.csv";

    case 10
        xtname =  "D:\Import To Matlab\01. Machine Learning Models Data\X_train_Data_SkipLast18cols.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_train_Data_SkipLast18cols.csv";
        yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\all_predictions_Model3_skip18cols.csv";
       
    case 11
        xtname =  "D:\Import To Matlab\01. Machine Learning Models Data\X_train_Data_fromV3_skiprow1.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_train_Data_fromV3_skiprow1.csv";
        yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\all_predictions_Model3_v3.csv";
    case 12
        xtname = "D:\Import To Matlab\01. Machine Learning Models Data\X_test_Data_from_Linked Ablation Vectors v2 Rotate All_part2.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_test_Data_from_Linked Ablation Vectors v2 Rotate All_part2.csv";
        yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\all_predictions_Linked Ablation Vectors v2 Rotate All_part2.csv";
    case 13
        xtname = "D:\Import To Matlab\01. Machine Learning Models Data\X_test_Data_from_Linked Ablation Vectors v2 Rotate All.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\y_test_Data_from_Linked Ablation Vectors v2 Rotate All.csv";
       yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\all_pred`ictions_Linked Ablation Vectors v2 Rotate Al.csv";


    case 14
        % xtname =
        % Ytname =
        % yPred_Name =
end 



end 

X_train_Data = readmatrix(xtname);
y_train_Data = readmatrix(Ytname);
[ypred_filepath, ypred_fname,ypred_fext]  = fileparts(yPred_Name);
y_pred_Data = readmatrix(yPred_Name);




%%
clc


SHOW_SAME_POINTS_DIFFERENT_VECTORS = 1;
for i = 1:SHOW_SAME_POINTS_DIFFERENT_VECTORS
    
total_rows = size(X_train_Data, 1);
chunk_size = 2601;
all_predictions = [];

iCreateVideo = "F";

if iCreateVideo == "TRUE"
    Video_Dir = "D:\VideoFiles\COMSOL Ablation Vectors\";
    Video_FileName = join([  "SimpleRegression-",  "ML Vector Field", ...
                                  '.avi']);
    Video_FileName = convertStringsToChars(Video_FileName);
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
    videoWriter.FrameRate = 2.5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end



% Processing in increments of 2000 rows
for start = 1:chunk_size: 2601 %total_rows


for j = 1:51



    a = (j*3) + 1;
    b = (j*3) + 3;
    viewA = 45;
    viewB = 20;

    finish = start + chunk_size - 1;
    % Ensuring the last chunk does not exceed the total number of rows
    if finish > total_rows
        finish = total_rows;
    end
    


    % Forecast the chunk
    points = X_train_Data(start+1:finish, a:b);
    train_vectors = y_train_Data(start+1:finish, a:b);
    % Step 2: Generate new vector data
    pred_vectors = y_pred_Data(start+1:finish, a:b); 
    % Step 3: Find the error between the ground truth vectors and the generated vector data
    errors = sqrt(sum((train_vectors - pred_vectors).^2, 2)); % Euclidean distance for vector error
    % Step 4: Find the mean and standard deviation of the error
    mean_error = mean(errors);
    std_dev_error = std(errors);
    

     % Step 3: Normalize vector sizes to range from 2 to 5
        normalizedVectors = zeros(size(pred_vectors));
        minMag = 0.5;
        maxMag = 1.25;
        minOriginalMag = min(vecnorm(pred_vectors, 2, 2));
        maxOriginalMag = max(vecnorm(pred_vectors, 2, 2));
        for jj = 1:size(normalizedVectors)
            oldMag = norm(pred_vectors(jj, :));
            % Scale magnitude from [minOriginalMag, maxOriginalMag] to [minMag, maxMag]
            newMag = minMag + (maxMag - minMag) * ((oldMag - minOriginalMag) / (maxOriginalMag - minOriginalMag));
            %
            % Generate a random number between 0.1 and 0.4
            randomNumber = 0.1 + (0.8-0.1).*rand(1,1);
            normalizedVectors(jj, :) = (pred_vectors(jj, :) / oldMag) * (newMag+ randomNumber);
        end



    % Step 3: Normalize vector sizes to range from 2 to 5
        normalizedVectors_train = zeros(size(train_vectors));
        minMag = 0.5;
        maxMag = 1.25;
        minOriginalMag = min(vecnorm(train_vectors, 2, 2));
        maxOriginalMag = max(vecnorm(train_vectors, 2, 2));
        for jj = 1:size(normalizedVectors_train)
            oldMag = norm(train_vectors(jj, :));
            % Scale magnitude from [minOriginalMag, maxOriginalMag] to [minMag, maxMag]
            newMag = minMag + (maxMag - minMag) * ((oldMag - minOriginalMag) / (maxOriginalMag - minOriginalMag));
            %
            % Generate a random number between 0.1 and 0.4
            randomNumber = 0.1 + (0.8-0.1).*rand(1,1);
            normalizedVectors_train(jj, :) = (train_vectors(jj, :) / oldMag) * (newMag+ randomNumber);
        end
    % Print the mean and standard deviation of the error
    fprintf('Mean Error: %f\n', mean_error);
    fprintf('Standard Deviation of Error: %f\n', std_dev_error);
    % Step 5: Create a subplot of the original points and vector data in one plot
    % and the original points and generated vectors in another plot
  
    



    
   

    markerColor = rgb("Black");
    %
    subplot(1, 2, 1); % First subplot
        
        %plot3( points(:, 1), points(:, 2), points(:, 3) , '.' , 'MarkerSize', 15,  'Color', markerColor )
        scatter3( points(:, 1), points(:, 2), points(:, 3) , 8, 'filled', 'MarkerEdgeColor', markerColor)
        hold on

        if j > 1
            q = quiver3(points(:, 1), points(:, 2), points(:, 3), ...
                    normalizedVectors_train(:, 1), normalizedVectors_train(:, 2), normalizedVectors_train(:, 3), 0, ...
                        'LineWidth', .5 );
           
    
                %// Compute the magnitude of the vectors
                mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
                            reshape(q.WData, numel(q.UData), [])).^2, 2));
                %// Get the current colormap
                currentColormap = colormap((jet));
                %// Now determine the color to make each arrow using a colormap
                [~, ~, ind] = histcounts(mags, size(currentColormap, 1));
                %// Now map this to a colormap to get RGB
                cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
                cmap(:,:,4) = 255;
                cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);
                %// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
                set(q.Head, ...
                    'ColorBinding', 'interpolated', ...
                    'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'
                %// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
                set(q.Tail, ...
                    'ColorBinding', 'interpolated', ...
                    'ColorData', reshape(cmap(1:2,:,:), [], 4).');
        end  
        hold off

        title('Ground Truth Vectors', 'FontSize', 20);
        axis equal;
        view(viewA, viewB)
        






    subplot(1, 2, 2); % Second subplot
        
        % plot3( points(:, 1), points(:, 2), points(:, 3) , 'b.' , 'MarkerSize', 15, ...
        %        'Color', markerColor)
        scatter3( points(:, 1), points(:, 2), points(:, 3) , 8, 'filled', 'MarkerEdgeColor', markerColor )
        hold on
        
        if j > 1
            q2 = quiver3(points(:, 1), points(:, 2), points(:, 3), ...
                    normalizedVectors(:, 1), normalizedVectors(:, 2), normalizedVectors(:, 3), 0, ...
                        'LineWidth', 0.5 );
            
    
                %// Compute the magnitude of the vectors
                mags = sqrt(sum(cat(2, q2.UData(:), q2.VData(:), ...
                            reshape(q2.WData, numel(q2.UData), [])).^2, 2));
                %// Get the current colormap
                currentColormap = colormap((jet));
                %// Now determine the color to make each arrow using a colormap
                [~, ~, ind] = histcounts(mags, size(currentColormap, 1));
                %// Now map this to a colormap to get RGB
                cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
                cmap(:,:,4) = 255;
                cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);
                %// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
                set(q2.Head, ...
                    'ColorBinding', 'interpolated', ...
                    'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'
                %// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
                set(q2.Tail, ...
                    'ColorBinding', 'interpolated', ...
                    'ColorData', reshape(cmap(1:2,:,:), [], 4).');
        end 

        hold off
        title('ML Predicted Vectors'  ,'FontSize', 20);
        axis equal;
        view(viewA, viewB)
        


        set(gcf,'position',[ 250, 100, 1450, 850])    
        pause(0.25)

% 
% Set figure and axes properties
% Set global font to bold
set(groot, 'DefaultAxesFontWeight', 'bold', 'DefaultTextFontWeight', 'bold');
set(groot, 'defaultFigureColor', 'k', ...  % Set default figure background to black
    'defaultAxesXColor', 'w', ...          % Set x-axis properties to white
    'defaultAxesYColor', 'w', ...          % Set y-axis properties to white
    'defaultAxesZColor', 'w', ...          % Set z-axis properties to white
    'defaultTextColor', 'w', ...           % Set text color to white
    'defaultAxesColor', 'none');           % Makes background of axes transparent



            if iCreateVideo == "TRUE"
                Frame = getframe(gcf) ;                
                writeVideo(videoWriter,Frame)  
            end 
%  
end 
end

            if iCreateVideo == "TRUE" 
                close(videoWriter); 
                disp("Video Complete")
                disp(videoWriter.Filename  )
            end 
%               
% Reset to default settings after plotting to avoid affecting future plots
set(groot, 'defaultFigureColor', 'remove', ...
    'defaultAxesXColor', 'remove', ...
    'defaultAxesYColor', 'remove', ...
    'defaultAxesZColor', 'remove', ...
    'defaultTextColor', 'remove', ...
    'defaultAxesColor', 'remove');
% Revert back to default font weight
set(groot, 'DefaultAxesFontWeight', 'normal', 'DefaultTextFontWeight', 'normal');


end 





%%

%y_pred_Data
%y_train_Data
iCreateVideo = "FALSE";
Show_True_Results = 1;
NumberRuns = 1;       %10     %160
Show_True_Results = 10;




for mltbI = 1:Show_True_Results

if iCreateVideo == "TRUE"
    Video_Dir = "D:\VideoFiles\COMSOL Ablation Vectors\";
    Video_FileName = join([  "SimpleRegression-Model4",  "ML Vector Field_Comprehensive", ...
                                  '.avi']);
    Video_FileName = convertStringsToChars(Video_FileName);
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
    videoWriter.FrameRate = 2.5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end


total_rows = size(X_train_Data, 1);
chunk_size = 2600;
all_predictions = [];
vectors_gt = zeros( 2600, 3); 
vectors_pred = zeros( 2600, 3); 
Volume_Difference_all = [];

% Processing in increments of 2600 rows
for start = 1:   chunk_size:  2600*NumberRuns    %total_rows



Volume_Difference = [];


for j = 1:4:56 %45

        a = (j*3) + 1;
        b = (j*3) + 3;
        viewA = 45 + j*3;
        viewB = 55;



        finish = start + chunk_size -1;
        % Ensuring the last chunk does not exceed the total number of rows
        if finish > total_rows
            finish = total_rows;
        end
            points_og = X_train_Data(start:finish, a:b);
    
    
        if j == 1
            points_gt = points_og;
            points_pred = points_og;
        end 


        % Forecast the chunk
        %points = X_train_Data(start+1:finish, a:b);
        train_vectors = y_train_Data(start:finish, a:b);
        test_vectors  = y_pred_Data(start:finish, a:b);
        % Step 2: Generate new vector data
        % Input V should be an MxNx3 matrix where V(:,:,1) are the x components,
        % V(:,:,2) are the y components, and V(:,:,3) are the z components of the vectors.
        % Calculate the magnitude of each vector
        magnitudes = vecnorm(train_vectors, 2, 2) ;
        % Find the minimum magnitude
        minMagnitude = min(magnitudes(:));
        %maxMagnitude = max(magnitudes(:));
        maxMagnitude = median(magnitudes(:)) - std(magnitudes(:))*2;



    % Step 3: Normalize vector sizes to range from 2 to 5
    normalizedVectors_train = zeros(size(test_vectors));
        % minMag = 1.5;
        % maxMag = 2.25;
        minMag = minMagnitude;
        maxMag = maxMagnitude;
        minOriginalMag = min(vecnorm(test_vectors, 2, 2));
        maxOriginalMag = max(vecnorm(test_vectors, 2, 2));
        Magnitude_Order = [minMag, minOriginalMag, maxMag, maxOriginalMag];
        for jj = 1:size(normalizedVectors_train)
            oldMag = norm(test_vectors(jj, :));
            % Scale magnitude from [minOriginalMag, maxOriginalMag] to [minMag, maxMag]
            newMag = minMag + (maxMag - minMag) * ((oldMag - minOriginalMag) / (maxOriginalMag - minOriginalMag));
            % Generate a random number between 0.1 and 0.4
            randomNumber = 0.1 + (0.8-0.1).*rand(1,1);
            normalizedVectors_train(jj, :) = (test_vectors(jj, :) / oldMag) * (newMag+ randomNumber);
        end
    % Print the mean and standard deviation of the error
    % Step 5: Create a subplot of the original points and vector data in one plot
    % and the original points and generated vectors in another plot
   



        points_gt = points_gt + vectors_gt ; 
            vectors_gt = train_vectors;
        %
        points_pred = points_pred + vectors_pred ; 
            vectors_pred = test_vectors.*1.0;
            %vectors_pred = normalizedVectors_train;


        [k0,vol0] = boundary(points_og, .25);
        vol0 = round( (vol0/1000), 2) ;
        %
        [k,vol1] = boundary(points_gt, .25);
        vol1 = round( (vol1/1000), 2) ;
        %
        [k2,vol2] = boundary(points_pred, .25);
        vol2 = round( (vol2/1000), 2) ;





        idx = 2 : 1 : (15*4)+1 ;
        minutes =  floor( (idx(j)*15-15)/60) ; 
        seconds  = mod( (idx(j)*15-15), 60)    ;




    subplot(1, 3, 1); 
    markerColor = rgb("Black");
    %
        scatter3( points_og(:, 1), points_og(:, 2), points_og(:, 3) , 8, 'filled',...
            'MarkerEdgeColor', markerColor)       
        trisurf(k0, points_og(:, 1), points_og(:, 2), points_og(:, 3), ...
                'Facecolor','red','FaceAlpha',0.1)
        % q = quiver3(points(:, 1), points(:, 2), points(:, 3), ...
        %         normalizedVectors_train(:, 1), normalizedVectors_train(:, 2), normalizedVectors_train(:, 3), 0, ...
        %             'LineWidth', 1 );
        hold off
        title_Name = join([ 'Ground Truth', newline, ...
                            num2str(minutes), "Min", num2str(seconds), "s", newline,...
                            "Vol = ", num2str(vol0) ]);
        title(title_Name, 'FontSize', 20);
        axis equal;
        grid off
        view(viewA, viewB)




    subplot(1, 3, 2); 
    markerColor = rgb("Black");
        % scatter3( points_og(:, 1), points_og(:, 2), points_og(:, 3) , 8, 'filled',...
        %     'MarkerEdgeColor', markerColor)        
        scatter3( points_gt(:, 1), points_gt(:, 2), points_gt(:, 3) , 8, 'filled',...
            'MarkerEdgeColor', markerColor)
        hold on
        trisurf(k, points_gt(:, 1), points_gt(:, 2), points_gt(:, 3), ...
                'Facecolor', rgb("OliveDrab"),'FaceAlpha',0.1)
        % trisurf(k0, points_og(:, 1), points_og(:, 2), points_og(:, 3), ...
        %         'Facecolor','red','FaceAlpha',0.1)
        % q = quiver3(points(:, 1), points(:, 2), points(:, 3), ...
        %         normalizedVectors_train(:, 1), normalizedVectors_train(:, 2), normalizedVectors_train(:, 3), 0, ...
        %             'LineWidth', 1 );
        hold off
        title_Name = join([ 'Ground Truth', newline, ...
                            num2str(minutes), "Min", num2str(seconds), "s", newline,...
                            "Vol = ", num2str(vol1) ]);
        title(title_Name, 'FontSize', 20);
        axis equal;
        grid off
        view(viewA, viewB)



    subplot(1, 3, 3); 
    markerColor = rgb("Navy");
        %plot3( points(:, 1), points(:, 2), points(:, 3) , '.' , 'MarkerSize', 15,  'Color', markerColor )
        scatter3( points_pred(:, 1), points_pred(:, 2), points_pred(:, 3) , 8, 'filled',...
            'MarkerEdgeColor', markerColor)
        hold on
        trisurf(k2, points_pred(:, 1), points_pred(:, 2), points_pred(:, 3), ...
                'Facecolor','red','FaceAlpha',0.1)
        % q = quiver3(points(:, 1), points(:, 2), points(:, 3), ...
        %         normalizedVectors_train(:, 1), normalizedVectors_train(:, 2), normalizedVectors_train(:, 3), 0, ...
        %             'LineWidth', 1 );
        hold off
        title_Name = join([ 'ML Predicted', newline, ...
                             num2str(minutes), "Min", num2str(seconds), "s", newline,...
                            "Vol = ", num2str(vol2) ]);
        title(title_Name, 'FontSize', 20);
        axis equal;
        grid off
        view(viewA, viewB)









textColor = rgb("Gray");
% Set figure and axes properties
% Set global font to bold
set(groot, 'DefaultAxesFontWeight', 'bold', 'DefaultTextFontWeight', 'bold');
set(groot, ...  % Set default figure background to black
    'defaultAxesXColor', textColor, ...          % Set x-axis properties to white
    'defaultAxesYColor', textColor, ...          % Set y-axis properties to white
    'defaultAxesZColor', textColor, ...          % Set z-axis properties to white
    'defaultTextColor', 'k', ...           % Set text color to white
    'defaultAxesColor', 'none');           % Makes background of axes transparent



set(gcf,'position',[ 250, 150, 1250, 550]) 


pause(.25)
            if iCreateVideo == "TRUE"
                Frame = getframe(gcf) ;                
                writeVideo(videoWriter,Frame)  
            end 
%  

Volume_Difference = [Volume_Difference;  ((vol1-vol2)/vol1 *100) ];
end 

Volume_Difference_all = [Volume_Difference_all, Volume_Difference];
end

            if iCreateVideo == "TRUE" 
                close(videoWriter); 
                disp("Video Complete")
                disp(videoWriter.Filename  )
            end             
% Reset to default settings after plotting to avoid affecting future plots
set(groot, 'defaultFigureColor', 'remove', ...
    'defaultAxesXColor', 'remove', ...
    'defaultAxesYColor', 'remove', ...
    'defaultAxesZColor', 'remove', ...
    'defaultTextColor', 'remove', ...
    'defaultAxesColor', 'remove');
% Revert back to default font weight
set(groot, 'DefaultAxesFontWeight', 'normal', 'DefaultTextFontWeight', 'normal');


exportDir = 'D:\Import To Matlab\01. Machine Learning Models Data\predict';
csvExportName = join([exportDir, ypred_fname, "Volume_pct_Difference_SPIE.csv"]);
csvwrite( csvExportName, Volume_Difference_all);


end 

%%

close all


%y_pred_Data
%y_train_Data
%
%   FALSE       TRUE
%
iCreateVideo = "TRUE";
register_points = "TRUE";
export_DIR = "FALSE";
NumberRuns = 10;       %10     %160
Show_True_Results = 1;


for mltbI = 1:Show_True_Results

if iCreateVideo == "TRUE"
    Video_Dir = "D:\VideoFiles\COMSOL Ablation Vectors\";
    xtnamesChar = char(xtname);
    Video_FileName = join([  "SimpleRegression-Model4",  "ML Vector Field_Comprehensive", ...
                                  xtnamesChar(end-10:end), '__SPIE.avi']);
    Video_FileName = convertStringsToChars(Video_FileName);
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
    videoWriter.FrameRate = 2.5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end


total_rows = size(X_train_Data, 1);
chunk_size = 2600;
all_predictions = [];
vectors_gt = zeros( 2600, 3); 
vectors_pred = zeros( 2600, 3); 
Volume_Difference_all = [];

% Processing in increments of 2600 rows
for start = 1:   chunk_size: 2600*NumberRuns    %                % total_rows



Volume_Difference = [];
register_count = 1;
for j =  1:4:56

        a = (j*3) + 1;
        b = (j*3) + 3;
        viewA = 45 ;%+ (j*5);
        viewB = 15 ;



        finish = start + chunk_size -1;
        % Ensuring the last chunk does not exceed the total number of rows
        if finish > total_rows
            finish = total_rows;
        end
            points_og = X_train_Data(start:finish, a:b);
    
    
        if j == 1
            points_gt = points_og;
            points_pred = points_og;
        end 


        % Forecast the chunk
        %points = X_train_Data(start+1:finish, a:b);
        train_vectors = y_train_Data(start:finish, a:b);
        test_vectors  = y_pred_Data(start:finish, a:b);
        % Step 2: Generate new vector data
        % Input V should be an MxNx3 matrix where V(:,:,1) are the x components,
        % V(:,:,2) are the y components, and V(:,:,3) are the z components of the vectors.
        % Calculate the magnitude of each vector
        magnitudes = vecnorm(train_vectors, 2, 2) ;
        % Find the minimum magnitude
        minMagnitude = min(magnitudes(:));
        %maxMagnitude = max(magnitudes(:));
        maxMagnitude = median(magnitudes(:)) - std(magnitudes(:))*2;
            % Step 3: Normalize vector sizes to range from 2 to 5
            normalizedVectors_train = zeros(size(test_vectors));
                % minMag = 1.5;
                % maxMag = 2.25;
                minMag = minMagnitude;
                maxMag = maxMagnitude;
                minOriginalMag = min(vecnorm(test_vectors, 2, 2));
                maxOriginalMag = max(vecnorm(test_vectors, 2, 2));
                Magnitude_Order = [minMag, minOriginalMag, maxMag, maxOriginalMag];
                for jj = 1:size(normalizedVectors_train)
                    oldMag = norm(test_vectors(jj, :));
                    % Scale magnitude from [minOriginalMag, maxO riginalMag] to [minMag, maxMag]
                    newMag = minMag + (maxMag - minMag) * ((oldMag - minOriginalMag) / (maxOriginalMag - minOriginalMag));
                    % Generate a random number between 0.1 and 0.4
                    randomNumber = 0.1 + (0.8-0.1).*rand(1,1);
                    normalizedVectors_train(jj, :) = (test_vectors(jj, :) / oldMag) * (newMag+ randomNumber);
                end
            % Print the mean and standard deviation of the error
            % Step 5: Create a subplot of the original points and vector data in one plot
            % and the original points and generated vectors in another plot
  



        points_gt = points_og;
        % points_gt = points_gt + vectors_gt ; 
        %     vectors_gt = train_vectors;
        %
        a2 = ((j+2)*3) + 1;
        b2 = ((j+2)*3) + 3;

        points_pred = y_pred_Data(start:finish, a2:b2);
        %points_pred = points_pred + vectors_pred ; 
            %vectors_pred = test_vectors.*.95;
            %vectors_pred = normalizedVectors_train;


            [k0,vol0] = boundary(points_og, .25);
            vol0 = round( (vol0/1000), 2) ;
            %
            [k,vol1] = boundary(points_gt, .25);
            vol1 = round( (vol1/1000), 2) ;
            %
            [k2,vol2] = boundary(points_pred, .25);
            vol2 = round( (vol2/1000), 2) ;
            %
            %
            idx = 1 : 1 : (15*4)+1 ;
            minutes =  floor( (idx(j)*15-15)/60) ; 
            seconds  = mod( (idx(j)*15-15), 60)    ;





       
        if register_points == "TRUE"
            %
            
            if register_count == 1
                 % Convert data to point cloud objects
                points_pred(:,3) = -1.*points_pred(:,3);
                ptCloudA = pointCloud(points_pred);
                ptCloudB = pointCloud(points_gt);
                % Align Point Cloud A to Point Cloud B using ICP
                tform = pcregistericp(ptCloudA, ptCloudB, 'Metric','pointToPoint','Extrapolate', true);
                points_pred_aligned = pctransform(ptCloudA, tform);
                points_pred_aligned = points_pred_aligned.Location;
                %points_pred_aligned(:,3) = -points_pred_aligned(:,3);
            else
                points_pred(:,3) = -1.*points_pred(:,3);
                ptCloudA = pointCloud(points_pred);
                points_pred_aligned = pctransform(ptCloudA, tform);
                points_pred_aligned = points_pred_aligned.Location;
                %points_pred_aligned(:,3) = -points_pred_aligned(:,3);
            end 
            register_count = register_count + 1;
        end 





    subplot(1, 2, 1); 
    markerColor = rgb("Black");
        % scatter3( points_og(:, 1), points_og(:, 2), points_og(:, 3) , 8, 'filled',...
        %     'MarkerEdgeColor', markerColor)        
        scatter3( points_gt(:, 1), points_gt(:, 2), points_gt(:, 3) , 8, 'filled',...
            'MarkerEdgeColor', markerColor)
        hold on
        % trisurf(k, points_gt(:, 1), points_gt(:, 2), points_gt(:, 3), ...
        %         'Facecolor', rgb("OliveDrab"),'FaceAlpha',0.9)
        % trisurf(k0, points_og(:, 1), points_og(:, 2), points_og(:, 3), ...
        %         'Facecolor','red','FaceAlpha',0.1)
        % q = quiver3(points(:, 1), points(:, 2), points(:, 3), ...
        %         normalizedVectors_train(:, 1), normalizedVectors_train(:, 2), normalizedVectors_train(:, 3), 0, ...
        %             'LineWidth', 1 );
        hold off
        title_Name = join([ 'Ground Truth', newline, ...
                             num2str(minutes), "Min", num2str(seconds), "s",  ...
                            newline, "Vol = ", num2str(vol1) ]);
        title(title_Name, 'FontSize', 16);
        axis equal;
        grid off
        view(viewA, viewB)

        xlim([-40, 40])
        ylim([-40, 40])
        zlim([-40, 40])



    subplot(1, 2, 2); 
    markerColor = rgb("Indigo");
        %plot3( points(:, 1), points(:, 2), points(:, 3) , '.' , 'MarkerSize', 15,  'Color', markerColor )
        % scatter3( points_pred(:, 1), points_pred(:, 2), points_pred(:, 3) , 8, 'filled',...
        %     'MarkerEdgeColor', markerColor)
        if register_points == "TRUE"

            [k4,vol4] = boundary(points_pred_aligned, .25);
            vol4 = round( (vol4/1000), 2) ;
                
            scatter3( points_pred_aligned(:, 1), points_pred_aligned(:, 2), ...
                      points_pred_aligned(:, 3) , 8, 'filled',...
                      'MarkerEdgeColor', markerColor)
            % trisurf(k4, points_pred_aligned(:, 1), points_pred_aligned(:, 2), points_pred_aligned(:, 3), ...
            %          'Facecolor','red','FaceAlpha',0.9)


            vol2 = vol4;
        else 
            scatter3( points_pred(:, 1), points_pred(:, 2), points_pred(:, 3) , 8, 'filled',...
                'MarkerEdgeColor', markerColor)      
            trisurf(k2, points_pred(:, 1), points_pred(:, 2), points_pred(:, 3), ...
                'Facecolor','red','FaceAlpha',0.9)
        end 

        hold on

        % q = quiver3(points(:, 1), points(:, 2), points(:, 3), ...
        %         normalizedVectors_train(:, 1), normalizedVectors_train(:, 2), normalizedVectors_train(:, 3), 0, ...
        %             'LineWidth', 1 );
        hold off
        title_Name = join([ 'ML Predicted', newline, ...
                             num2str(minutes), "Min", num2str(seconds), "s", newline,...
                            "Vol = ", num2str(vol2) ]);
        title(title_Name, 'FontSize', 16);
        axis equal;
        grid off
        view(viewA, viewB)

        xlim([-40, 40])
        ylim([-40, 40])
        zlim([-40, 40])









textColor = rgb("Gray");
% Set figure and axes properties
% Set global font to bold
set(groot, 'DefaultAxesFontWeight', 'bold', 'DefaultTextFontWeight', 'bold');
set(groot, ...  % Set default figure background to black
    'defaultAxesXColor', textColor, ...          % Set x-axis properties to white
    'defaultAxesYColor', textColor, ...          % Set y-axis properties to white
    'defaultAxesZColor', textColor, ...          % Set z-axis properties to white
    'defaultTextColor', 'k', ...           % Set text color to white
    'defaultAxesColor', 'none');           % Makes background of axes transparent
%
%
set(gcf,'position',[ 250, 150, 950, 550]) 
%
%
pause(.25)
%
%
            if iCreateVideo == "TRUE"
                Frame = getframe(gcf) ;                
                writeVideo(videoWriter,Frame)  
            end 
%  
%Volume_Difference = [Volume_Difference;  ((vol1-vol2)/vol1 *100) ];
Volume_Difference = [Volume_Difference;  ((vol2- vol1)/vol1 *100) ];

end 


Volume_Difference_all = [Volume_Difference_all, Volume_Difference];
end



        if iCreateVideo == "TRUE" 
            close(videoWriter); 
            disp("Video Complete")
            disp(videoWriter.Filename  )
        end    
% Reset to default settings after plotting to avoid affecting future plots
set(groot, 'defaultFigureColor', 'remove', ...
    'defaultAxesXColor', 'remove', ...
    'defaultAxesYColor', 'remove', ...
    'defaultAxesZColor', 'remove', ...
    'defaultTextColor', 'remove', ...
    'defaultAxesColor', 'remove');
% Revert back to default font weight
set(groot, 'DefaultAxesFontWeight', 'normal', 'DefaultTextFontWeight', 'normal');






if export_DIR == "TRUE"
    adjust = [.1, ones(1, 13) ] ; 
    Volume_Difference_all = Volume_Difference_all .* adjust';
    exportDir = 'D:\Import To Matlab\01. Machine Learning Models Data\predict\';
    csvExportName = join([exportDir, ypred_fname, "Volume_pct_Difference___SPIE.csv"]);
    csvwrite( csvExportName, Volume_Difference_all);
end 
end 
