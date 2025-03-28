clear
close all 
clc


for fi = 1:2:9




type = ["Necrosis", "EField", "EField Single" ];
file_path = SelectElectAblationBoundary(   type(2),   fi   );


[filepath,name,ext] = fileparts(file_path);    
OGdata = readtable(file_path);
data = table2array(OGdata);
% Extract the coordinates, temperature, arrhenius, and electric field values
%
% Separate the temperature, arrhenius, and electric field values for each time point
numTimePoints = 61;  % Calculate the number of time points
timePoints = cell(numTimePoints, 1);

for i = 1:numTimePoints
    startIndex = 1 + (i - 1) * 5;
    endIndex = startIndex + 4;
    timePoints{i} = data(:, startIndex:endIndex);
end
%











plot_Ablation = "FALSE";
    if plot_Ablation == "TRUE"
        for i = 2:numTimePoints

            Cords = timePoints{i}(:, 1:3)  ;
            % Find rows where the first column is  zero
            ZeroFirstColumn = Cords(:,1) == 0;
            % Erase entire rows where the first column is non-zero
            Cords(ZeroFirstColumn, :) = [];
            arrheniusValues = timePoints{i}(:, 4);
            arrheniusValues(ZeroFirstColumn, :) = [];    
            ElecsValues = timePoints{i}(:, 5);    
            ElecsValues(ZeroFirstColumn, :) = [];


            scalarValues = ElecsValues;
            % Plot the points using the 'jet' colormap    
            colormap(flipud(jet));
            scatter3( Cords(:,1), Cords(:,2), Cords(:,3),...
                        scalarValues, scalarValues, 'filled', 'MarkerEdgeColor', 'k',...
                        'LineWidth',1);
            colorbar
            hold on        
            axis equal
            plotColor  = rgb("Gray");
            set(gcf,'position',[ 850, 150, 950, 800])
            set(gcf,'color',plotColor );
            set(gca,'color',plotColor );    
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            axis equal ;
            view( 0 , 90)
            pause(.5)
            hold off
        end
    end 




















plotContour =  "FALSE";
iCreateVideo = "FALSE";
spacing = [114.25, 119.75;  114.25, 124.7;     114.25, 129.65;     114.25, 134.6;...
           114.25, 139.55;  104.25, 134.5;     99.25, 134.45;      99.25, 134.45;...  
           94.50,  144.0;   94.50,  149.0;     ];       

if plotContour == "TRUE"


    figure;   
    if iCreateVideo == "TRUE"
        Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\ElecField\";
        Video_FileName = join([  "A3-1__", num2str(fi), " ", "FusionBetweenProbes", ...
                                      name(end-15:end)  ,'.mp4']);
        Video_FileName = convertStringsToChars(Video_FileName);
        
        Video_fullfile = fullfile(Video_Dir, Video_FileName);
        videoWriter = VideoWriter(Video_fullfile,  'MPEG-4'); %// initialize the VideoWriter object
        videoWriter.FrameRate = 4.5;
        videoWriter.Quality = 100; % High quality video
        open(videoWriter);
    end


      for i = 2:numTimePoints   
          
            currentData = timePoints{i} ;
            currentData(currentData == 0) = nan;
            %
            Arrhnus = currentData(:, 4);
            Arrhnus( isnan(Arrhnus) ) = [];
            Efield = currentData(:, 5);
            Efield( isnan(Efield) ) = [];              
            Coords = currentData(:, 1:3);
            Coords( isnan(Coords(:,1)), : ) = [];
            % Step 1: Generate 1000 random x, y, z points and intensity values
            x = Coords(:,1); % 1000 random values between -10 and 10
            y = Coords(:,2);
            z = Coords(:,3);
            intensity = Arrhnus; %rand(1000,1); % 1000 random intensity values
            % Step 2: Find the center of the points
            centerX = mean(x);
            centerY = mean(y);
            centerZ = mean(z);
            % Step 3: Find points with z-values within 5 mm of the center
            zRange = 1;
            selectedPoints = abs(z - centerZ) <= zRange;
            % Collect x, y, and intensity for points within z-range
            xWithin = x(selectedPoints);
            yWithin = y(selectedPoints);
            intensityWithin = intensity(selectedPoints);
            intensityWithin2 = Efield(selectedPoints);
            % Step 4: Create a contour plot of x, y, and intensity for identified points
            % To create a contour plot, use a regular grid and interpolate intensity values
            % Create grid        
            [Xq, Yq] = meshgrid(linspace(min(xWithin), max(xWithin), 150),...
                                linspace(min(yWithin), max(yWithin), 150));   

subplot(1,2,1)
                % Interpolate intensity values on the grid
                Zq = griddata(xWithin, yWithin, intensityWithin, Xq, Yq, 'linear');
                %contourf(Xq, Yq, Zq, 'LineStyle', 'none');
                scatter( reshape(Xq, [], 1)  ,...
                         reshape(Yq, [], 1)  ,   25,...
                         reshape(Zq, [], 1)  , 'filled')            
                colormap(jet);
                c = colorbar;
                c.Color = rgb('Silver');
                caxis([0 .9])
                set(gca,'color',rgb("Navy") );             
                xlabel('\color{white} X (mm)');
                ylabel('\color{white} Y (mm)');
                set(gca,'XColor','w');
                set(gca,'YColor','w');  
                xlim([ (-34.25 + spacing(fi,1))  (30.75 + spacing(fi,2)) ])
                ylim([125 190])           
                hold on
                [complete1 ] = AddAntennae2D( 122,  170, spacing(fi,1) );
                [complete2 ] = AddAntennae2D( 122,  170, spacing(fi,2) );
             
    
                Zq2 = griddata(xWithin, yWithin, intensityWithin2, Xq, Yq, 'linear');  
                [C,h] = contour(Xq, Yq, Zq2, 8, 'ShowText','on', "LabelFormat","%0.1f m");
                h.LineWidth = 2;
                h.LabelColor = 'w';
                h.LineWidth = 1;
                h.LabelSpacing = 200;
                h.EdgeColor = 'w';
                idx = 1 : 1 : (15*4)+1 ;
                minutes =  floor( (idx(i)*15-15)/60) ; 
                seconds  = mod( (idx(i)*15-15), 60)    ;
                titleName = join([ '\color{white} Necrosis', num2str(minutes), "Min", num2str(seconds), "s" ]);       
                title(titleName)
                set(gca, 'FontSize', 15)
                hold off
   
            
subplot(1,2,2)
                scatter( reshape(Xq, [], 1)  ,...
                         reshape(Yq, [], 1)  ,   25,...
                         reshape(Zq2, [], 1), 'filled' , 'MarkerFaceAlpha', .155)  
                hold on
                [C,h] = contour(Xq, Yq, Zq2, 8, 'ShowText','on', "LabelFormat","%0.1f m");
                h.LineWidth = 2;
                h.LabelColor = 'w';
                h.LineWidth = 1;
                h.LabelSpacing = 200;
                c = colorbar;
                c.Color = rgb('Silver');
                caxis([2.4  4.6])
                xlabel('\color{white} X (mm)');
                ylabel('\color{white} Y (mm)');
                %xlim([ (-34.25 + spacing(fi,1))  (30.75 + spacing(fi,2)) ])
                xlim([ (-20.25 + spacing(fi,1))  (20.75 + spacing(fi,2)) ])
                ylim([125 190])
                hold on
                [complete1 ] = AddAntennae2D( 122,  170, spacing(fi,1)  );
                [complete2 ] = AddAntennae2D( 122,  170, spacing(fi,2)  );
                hold off                        
                set(gca,'color',rgb("Navy") ); 
                set(gca,'XColor','w');
                set(gca,'YColor','w');                    
                titleName = join([ '\color{white} Elec Field', num2str(minutes), "Min", num2str(seconds), "s" ]); 
                title(titleName)
                set(gca, 'FontSize', 15)
                hold off
                

% Note: If there are too few points within the specified Z-range,
% interpolation and consequently the contour plot might not look ideal.
% Adjust the Z-range or data generation parameters if necessary.  


set(gca,'color',  rgb("Navy")  ); 
plotColor  = rgb("Navy");
plotColor = [102 102 102]/255;
set(gcf,'color', plotColor );    
set(gcf,'position',[ 250, 150, 950, 500])    
pause(.15)

            
                if iCreateVideo == "TRUE"
                    Frame = getframe(gcf) ;                
                    writeVideo(videoWriter,Frame)  
                end 
end   
end 
                if iCreateVideo == "TRUE" 
                    close(videoWriter); 
                    disp("Video Complete")
                    disp(videoWriter.Filename  )
                end 





































plotelectricField = "FALSE";
iCreateVideo = "FALSE";

spacing = [114.25, 119.75;  114.25, 124.7;     114.25, 129.65;     114.25, 134.6;...
           114.25, 139.55;  104.25, 134.5;     99.25, 134.45;      99.25, 134.45;...  
           94.50,  144.0;   94.50,  149.0;     ];            

if plotelectricField == "TRUE"

figure;   
fontSizeVal = 16;   

    if iCreateVideo == "TRUE"
            Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\ElecField\";
            Video_FileName = join([  "A3-2__", num2str(fi), " ", "FusionBetweenProbes", ...
                                      name(end-15:end)  ,'.mp4']);
            Video_FileName = convertStringsToChars(Video_FileName);
            
            Video_fullfile = fullfile(Video_Dir, Video_FileName);
            videoWriter = VideoWriter(Video_fullfile,  'MPEG-4'); %// initialize the VideoWriter object
            videoWriter.FrameRate = 4.5;
            videoWriter.Quality = 100; % High quality video
            open(videoWriter);
    end


  for i = 2:numTimePoints   
      
        currentData = timePoints{i} ;
        currentData(currentData == 0) = nan;
        Arrhnus = currentData(:, 4);
        Arrhnus( isnan(Arrhnus) ) = [];
        Efield = currentData(:, 5);
        Efield( isnan(Efield) ) = [];  

        
        Coords = currentData(:, 1:3);
        Coords( isnan(Coords(:,1)), : ) = [];
        % Step 1: Generate 1000 random x, y, z points and intensity values
        x = Coords(:,1); % 1000 random values between -10 and 10
        y = Coords(:,2);
        z = Coords(:,3);
        intensity = Arrhnus; %rand(1000,1); % 1000 random intensity values
        % Step 2: Find the center of the points
        centerX = mean(x);
        centerY = mean(y);
        centerZ = mean(z);
        % Step 3: Find points with z-values within 5 mm of the center
        zRange = 1;
        selectedPoints = abs(z - centerZ) <= zRange;
        % Collect x, y, and intensity for points within z-range
        xWithin = x(selectedPoints);
        yWithin = y(selectedPoints);
        intensityWithin = intensity(selectedPoints);
        intensityWithin2 = Efield(selectedPoints);
        % Step 4: Create a contour plot of x, y, and intensity for identified points
        % To create a contour plot, use a regular grid and interpolate intensity values
        % Create grid        
        [Xq, Yq] = meshgrid(linspace(min(xWithin), max(xWithin), 150),...
                            linspace(min(yWithin), max(yWithin), 150)); 
      
  HA(1) = subplot(1,2,1);
            % Interpolate intensity values on the grid
            Zq = griddata(xWithin, yWithin, intensityWithin, Xq, Yq, 'linear');
            %contourf(Xq, Yq, Zq, 'LineStyle', 'none');
            scatter( reshape(Xq, [], 1)  ,...
                     reshape(Yq, [], 1)  ,   25,...
                     reshape(Zq, [], 1)  , 'filled')            
            colormap(jet);
            % colorbar;
            caxis([0 .9])
            set(gca,'color',rgb("Navy") );             
            xlabel('\color{white} X (mm)');
            ylabel('\color{white} Y (mm)');
            xlim([ (-34.25 + spacing(fi,1))  (30.75 + spacing(fi,2)) ])
            ylim([125 190])           
            hold on
            [complete1 ] = AddAntennae2D( 122,  170, spacing(fi,1) );
            [complete2 ] = AddAntennae2D( 122,  170, spacing(fi,2) );


            Zq2 = griddata(xWithin, yWithin, intensityWithin2, Xq, Yq, 'linear');  
            [C,h] = contour(Xq, Yq, Zq2, 5, 'ShowText','on', "LabelFormat","%0.1f m");
            h.LineWidth = 2;
            h.LabelColor = 'w';
            h.LineWidth = 1;
            h.LabelSpacing = 200;
            h.EdgeColor = 'w';
            idx = 1 : 1 : (15*4)+1 ;
            minutes =  floor( (idx(i)*15-15)/60) ; 
            seconds  = mod( (idx(i)*15-15), 60)    ;
            titleName = join([ '\color{white} Necrosis', num2str(minutes), "Min", num2str(seconds), "s" ]);       
            title(titleName)
            set(gca, 'FontSize', fontSizeVal)    
            set(gca,'XColor','w');
            set(gca,'YColor','w');
            hold off




 hold off

        
 HA(2) = subplot(1,2,2);
        x_cloud = reshape(Xq, [], 1);
        y_cloud = reshape(Yq, [], 1);
        alpha_values = reshape(Zq, [], 1);
        beta_values = reshape(Zq2, [], 1);
        % Step 5: Determine which points in the point cloud are between the two "lines"
        indices_between = x_cloud > spacing(fi,1) & x_cloud < spacing(fi,2);
        % Step 6: Of the points between the two "lines", determine which
        % ones have alpha values greater than .98
        indices_alpha = alpha_values > 0.9;
        final_indices = indices_between & indices_alpha; % Combine the conditions
        
        % Step 6: Plot the identified points with alpha values greater than .5
        % figure; % Creating a new figure
        % scatter(x_cloud(final_indices), y_cloud(final_indices), 25, 'g', 'filled');
        % xlabel('X');
        % ylabel('Y');
        % title('Points Between x=2 and x=5 with Alpha > 0.5');
        
        % Step 7: Create a histogram that plots the beta values associated with the points
        % that are in between the two "lines" and have an alpha value greater than .5
        % figure; % Creating a new figure

        ColorHistogram = jet(61);
        histogram(beta_values(final_indices), 'FaceColor', ColorHistogram(i,:), ...
            'FaceAlpha', .5, 'EdgeColor','k', 'EdgeAlpha', .25, 'Normalization','percentage',...
            'BinWidth', .10 );
        xlabel('\color{white} Electric Field log(10)');
        xlim([ 2.0 , 6])
        ylabel('\color{white} % ');
        xticks([0 1 2 3 4 5 6])
        xticklabels({'0','1','2','3','4','5', '6'})
        titleName = join([ '\color{white} EField of Fusion Zone', newline ...
            'Necrosis', num2str(minutes), "Min", num2str(seconds), "s" ]);       
        title(titleName)  
        hold on
        set(gca, 'FontSize', fontSizeVal)  
        set(gca,'XColor','w');
        set(gca,'YColor','w');




set(gca,'color',  [102 102 102]/255 ); 
plotColor  = rgb("Navy");
plotColor = [102 102 102]/255;
set(gcf,'color', plotColor ); 
set(gcf,'position',[ 250, 150, 950, 500])       
        % Note: If there are too few points within the specified Z-range,
        % interpolation and consequently the contour plot might not look ideal.
        % Adjust the Z-range or data generation parameters if necessary.  

            if iCreateVideo == "TRUE"
                Frame = getframe(gcf) ;                
                writeVideo(videoWriter,Frame)  
            end         
pause(.15)

  end    
end

if iCreateVideo == "TRUE" 
    close(videoWriter); 
    disp("Video Complete")
    disp(videoWriter.Filename  )
end 































SingleElectricField = "TRUE";
PlotSingleElectricField = "TRUE";
iCreateVideo = "TRUE";
spacing = [114.25, 119.75;  114.25, 124.7;     114.25, 129.65;     114.25, 134.6;...
           114.25, 139.55;  104.25, 134.5;     99.25, 134.45;      99.25, 134.45;...  
           94.50,  144.0;   94.50,  149.0;     ];            



    if SingleElectricField == "TRUE"
            type = ["Necrosis", "EField", "EField Single" ];
            file_path = SelectElectAblationBoundary(   type(3),   1  );
            [filepath,name2,ext] = fileparts(file_path);    
            OGdata = readtable(file_path);
            data = table2array(OGdata);
            % Extract the coordinates, temperature, arrhenius, and electric field values
            %
            % Separate the temperature, arrhenius, and electric field values for each time point
            numTimePoints = 61;  % Calculate the number of time points
            timePoints_s = cell(numTimePoints, 1);
            for i = 1:numTimePoints
                startIndex = 1 + (i - 1) * 5;
                endIndex = startIndex + 4;
                timePoints_s{i} = data(:, startIndex:endIndex);
            end
    end

    
    if iCreateVideo == "TRUE"
            Video_Dir = ['C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\',...
                        'Video_Files\ElecField\2SingleVsMultiProbe'];
            Video_FileName = join([  "A3-3__", num2str(fi), " ", "SuperImposed_VS_Multiprobe", ...
                                      name(end-15:end)  ,'.mp4']);
            Video_FileName = convertStringsToChars(Video_FileName);
            
            Video_fullfile = fullfile(Video_Dir, Video_FileName);
            videoWriter = VideoWriter(Video_fullfile,  'MPEG-4'); %// initialize the VideoWriter object
            videoWriter.FrameRate = 4.5;
            videoWriter.Quality = 100; % High quality video
            open(videoWriter);
    end





if  PlotSingleElectricField == "TRUE";
  figure;   
  fontSizeVal = 16;   
        
  for i = 2:numTimePoints   

        currentData = timePoints_s{i} ;
        currentData(currentData == 0) = nan;
        %
        Arrhnus = currentData(:, 4);

        indices = ( isnan(Arrhnus) & Arrhnus>= 0); 
        Efield = currentData(:, 5);
        Efield( indices ) = [];              
        Coords = currentData(:, 1:3);
        Coords( indices, : ) = [];

        Arrhnus( indices ) = [];



        % Step 1: Generate 1000 random x, y, z points and intensity values
        x = Coords(:,1); % 1000 random values between -10 and 10
        y = Coords(:,2);
        z = Coords(:,3);
        % Step 2: Find the center of the points
        centerX = mean(x);
        centerY = mean(y);
        centerZ = mean(z);
        % Step 3: Find points with z-values within 5 mm of the center
        zRange = 1;
        selectedPoints = abs(z - centerZ) <= zRange;
        % Collect x, y, and intensity for points within z-range

        shift1 = spacing(fi,1) - centerX;
        shift2 = spacing(fi,2) - centerX;

        xWithin1 = x(selectedPoints)  + shift1;
        xWithin2 = x(selectedPoints)  + shift2;
        yWithin = y(selectedPoints);
        intensityWithin = Arrhnus(selectedPoints);
        intensityWithin2 = Efield(selectedPoints);
        % Step 4: Create a contour plot of x, y, and intensity for identified points
        % To create a contour plot, use a regular grid and interpolate intensity values
        % Create grid       

        [Xq, Yq] = meshgrid(linspace( 50, 220  , 180),...
                            linspace( min(yWithin), 200,  180));   


        [Xq_, Yq_] = meshgrid(linspace( min(xWithin2) , max(xWithin2)  , 180),...
                              linspace( min(yWithin), 200, 180));   

            % Interpolate intensity values on the grid
            Zq1 = griddata(xWithin1, yWithin, intensityWithin, Xq, Yq, 'linear');
            Zq1( isnan(Zq1)) = 0;
            Zq2 = griddata(xWithin2, yWithin, intensityWithin, Xq_, Yq_, 'linear');
            % Zq2( isnan(Zq2)) = 0;
            Zq_1 = Zq1; 

            Ze1 = griddata(xWithin1, yWithin, intensityWithin2, Xq, Yq, 'linear');  
            % Ze1( isnan(Ze1)) = 0;
            Ze2 = griddata(xWithin2, yWithin, intensityWithin2, Xq_, Yq_, 'linear'); 
            % Ze2( isnan(Ze2)) = 0;
            Ze_1 = Ze1; 
           
            changedValue = []; 
            for ki = 1:numel(Xq_)
                % Calculate the distances from current small grid point  to all large grid points
                distances = sqrt((Xq - Xq_(ki)).^2 + (Yq - Yq(ki)).^2);
                % Find the index of the closest point
                [~, index] = min(distances(:));
                % Replace the intensity value of the closest point in the large grid
                    if Zq_1(index) < Zq2(ki)
                        Zq_1(index) = Zq2(ki);
                    else
                        noChangeAr = 1;
                    end 

                    if Ze_1(index) < Ze2(ki)
                        Ze_1(index) = Ze2(ki);
                    else
                        noChangeEq = 1;
                    end 
            end




set(gca,'color',  [102 102 102]/255 ); 
plotColor  = rgb("Navy");
plotColor = [102 102 102]/255;
set(gcf,'color', plotColor ); 
set(gcf,'position',[ 250, 150, 1650, 800])  


HA(1) = subplot(1,2,1)
        %contourf(Xq, Yq, Zq, 'LineStyle', 'none');
        scatter( reshape(Xq, [], 1)  ,...
                 reshape(Yq, [], 1)  ,   30,...
                 reshape(Zq_1, [], 1)  , 'filled')   
        colormap(jet);
        c = colorbar;     
        c.Color = rgb('Silver');
        caxis([0 .9])
        set(gca,'color',rgb("Navy") );             
        xlabel('\color{white} X (mm)');
        ylabel('\color{white} Y (mm)');
        set(gca,'XColor','w');
        set(gca,'YColor','w');  
        xlim([ (-34.25 + spacing(fi,1))  (30.75 + spacing(fi,2)) ])
        ylim([131 190])         
        hold on

        [complete1 ] = AddAntennae2D( 122,  170, spacing(fi,1) );
        scatter(  complete1(:,1) ,   complete1(:,2), 200,  's', 'MarkerEdgeColor', ...
                 'k', 'MarkerEdgeAlpha', .05, 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 1.0);
        [complete2 ] = AddAntennae2D( 122,  170, spacing(fi,2) );
        scatter(  complete2(:,1) ,   complete2(:,2), 200, 's', 'MarkerEdgeColor', ...
                 'k', 'MarkerEdgeAlpha', .05, 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 1.0);     
  

        [C,h] = contour(Xq, Yq, Ze_1,  [2.7, 2.9, 3.3, 3.7, 4.1 ], ...
                        'ShowText','on', "LabelFormat","%0.1f m");
        h.LineWidth = 2;
        h.LabelColor = 'w';
        h.LineWidth = 1;
        h.LabelSpacing = 200;
        h.EdgeColor = 'w';
        idx = 1 : 1 : (15*4)+1 ;
        minutes =  floor( (idx(i)*15-15)/60) ; 
        seconds  = mod( (idx(i)*15-15), 60)    ;
        titleName = join([ '\color{red} Superimposed Ablation', newline, ...
                        num2str(minutes), "Min", num2str(seconds), "s" ]);       
        title(titleName)
        set(gca, 'FontSize', 15)
        hold off
  



        %--------------------------------------------------------------------------%
        currentData = timePoints{i} ;
        currentData(currentData == 0) = nan;
        Arrhnus = currentData(:, 4);
        Arrhnus( isnan(Arrhnus) ) = [];
        Efield = currentData(:, 5);
        Efield( isnan(Efield) ) = [];  

        
        Coords = currentData(:, 1:3);
        Coords( isnan(Coords(:,1)), : ) = [];
        % Step 1: Generate 1000 random x, y, z points and intensity values
        x = Coords(:,1); % 1000 random values between -10 and 10
        y = Coords(:,2);
        z = Coords(:,3);
        intensity = Arrhnus; %rand(1000,1); % 1000 random intensity values
        % Step 2: Find the center of the points
        centerX = mean(x);
        centerY = mean(y);
        centerZ = mean(z);
        % Step 3: Find points with z-values within 5 mm of the center
        zRange = 1;
        selectedPoints = abs(z - centerZ) <= zRange;
        % Collect x, y, and intensity for points within z-range
        xWithin = x(selectedPoints);
        yWithin = y(selectedPoints);
        intensityWithin = intensity(selectedPoints);
        intensityWithin2 = Efield(selectedPoints);
        % Step 4: Create a contour plot of x, y, and intensity for identified points
        % To create a contour plot, use a regular grid and interpolate intensity values
        % Create grid        
        [Xq, Yq] = meshgrid(linspace(min(xWithin), max(xWithin), 150),...
                            linspace(min(yWithin), max(yWithin), 150)); 
        %--------------------------------------------------------------------------%
      

  HA(2) = subplot(1,2,2);
            % Interpolate intensity values on the grid
            Zq = griddata(xWithin, yWithin, intensityWithin, Xq, Yq, 'linear');
            %contourf(Xq, Yq, Zq, 'LineStyle', 'none');
            scatter( reshape(Xq, [], 1)  ,...
                     reshape(Yq, [], 1)  ,   25,...
                     reshape(Zq, [], 1)  , 'filled')            
            colormap(jet);
            % colorbar;
            caxis([0 .9])
            set(gca,'color',rgb("Navy") );             
            xlabel('\color{white} X (mm)');
            ylabel('\color{white} Y (mm)');
            xlim([ (-34.25 + spacing(fi,1))  (30.75 + spacing(fi,2)) ])
            ylim([131 190])           
            hold on

                [complete1 ] = AddAntennae2D( 122,  170, spacing(fi,1) );
                scatter(  complete1(:,1) ,   complete1(:,2), 200,  's', 'MarkerEdgeColor', ...
                         'k', 'MarkerEdgeAlpha', .05, 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 1.0);
                [complete2 ] = AddAntennae2D( 122,  170, spacing(fi,2) );
                scatter(  complete2(:,1) ,   complete2(:,2), 200, 's', 'MarkerEdgeColor', ...
                         'k', 'MarkerEdgeAlpha', .05, 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 1.0);     

            Zq2 = griddata(xWithin, yWithin, intensityWithin2, Xq, Yq, 'linear');  
            [C,h] = contour(Xq, Yq, Zq2, [2.7, 2.9, 3.3, 3.7, 4.1 ], ...
                            'ShowText','on', "LabelFormat","%0.1f m");
            h.LineWidth = 2;
            h.LabelColor = 'w';
            h.LineWidth = 1;
            h.LabelSpacing = 200;
            h.EdgeColor = 'w';
            idx = 1 : 1 : (15*4)+1 ;
            minutes =  floor( (idx(i)*15-15)/60) ; 
            seconds  = mod( (idx(i)*15-15), 60)    ;
            titleName = join([ '\color{green} Multiprobe ', newline,  ...
                                num2str(minutes), "Min", num2str(seconds), "s" ]);       
            title(titleName)
            set(gca, 'FontSize', fontSizeVal)    
            set(gca,'XColor','w');
            set(gca,'YColor','w');
            hold off





            if iCreateVideo == "TRUE"
                Frame = getframe(gcf) ;                
                writeVideo(videoWriter,Frame)  
            end         
pause(.5)
  end    
end
            if iCreateVideo == "TRUE" 
                close(videoWriter); 
                disp("Video Complete")
                disp(videoWriter.Filename  )
            end 




pause(5)
close all
end 

















































%%


plotCorrelation = "FALSE";
if plotCorrelation == "TRUE"
    figure; % Create a new figure
 
    for i = 2:10 %numTimePoints

            currentData = timePoints{i} ;
            currentData(currentData == 0) = nan;
                Arrhnus = currentData(:, 4);
                Arrhnus( isnan(Arrhnus) ) = [];
                Efield = currentData(:, 5);
                Efield( isnan(Efield) ) = [];            


            x = Efield;     y = Arrhnus;
            
       
            % Step 2: Plot with the 'jet' colormap based on x value

            scatter(x, y, 36, x, 'filled'); % scatter plot with size and color based on 'x'
            colormap(jet); % Use the 'jet' colormap
            colorbar; % Show a color bar
            % Step 3: Calculate and display the correlation coefficient
            R = corrcoef(x, y);
            correlationText = sprintf(' Correlation Coefficient:\n %.2f', R(1,2));

            % Step 4: Calculate and display the equation of the line (y = mx + b)
            p = polyfit(x, y, 1); % Linear fit (1st degree polynomial)
            m = p(1); % Slope
            b = p(2); % Intercept
            equationText = sprintf('Equation of the line: \n y = %.2fx + (%.2f)', m, b);

            % Optionally, add the line of best fit to the plot
            hold on; % Keep the current scatter plot
            plot(x, polyval(p, x), 'k-', 'LineWidth', 2); % Draw the line of best fit
%             legend('Data Points', 'Line of Best Fit');

            % Display correlation coefficient and equation of line on the figure
            textLocationX = max(x) - 0.40 * range(x) ; % For horizontal location
            textLocationY = max(y) - 0.40 * range(y); % For vertical location, start at the top
            text(textLocationX, textLocationY, correlationText, 'FontSize', 10);
            text(textLocationX, textLocationY - 0.1 * range(y), equationText, 'FontSize', 10);

            hold off; % Release the plot        

            
            idx = 1 : 1 : (15*4)+1 ;
            minutes =  floor( (idx(i)*15-15)/60) ; 
            seconds  = mod( (idx(i)*15-15), 60)    ;
            
            titleName = join([ num2str(minutes), "Min", num2str(seconds), "s" ]);
            
            xlabel("Electric Field")
            ylabel("Arrhenius Val")
            ylim([ 0  1 ])
            pause(1)

    end

end







plotHistogram = "FALSE";
    if plotHistogram == "TRUE"

        % Step 1: Create a 500x15 matrix of random values
        dataMatrix = [];
        for i = 1:5      
            a = (i-1)*14 + 2;
            currentData = timePoints{a}(:, 5) ;
            currentData(currentData == 0) = nan;
            dataMatrix = [ dataMatrix,  currentData  ] ; 
        end 

        % Step 2: Plot the boxplot for each column and the individual points on the same figure.
        figure; % Create a new figure
        h = boxplot(dataMatrix, 'Colors', 'w'); % Plot boxplots of all columns with black color for the boxes
        set(h,{'linew'},{3})
        hold on; % Keep the boxplots, so points can be overlaid
        % MATLAB's 'jet' function generates a colormap, you can obtain the RGB values for 15 points within it.
        cm = jet(15);
        % Loop through each column of the dataMatrix to plot individual data points with the jet colormap

        for i = 1:5
            current_data = dataMatrix(:,i);
            current_data( isnan(current_data)) = []; 

            xData = repmat(i, size(current_data, 1), 1); % X-coordinates for the scatter plot, repeating the column index
            scatter(xData, current_data, 5, cm(i, :), 'o', 'filled'); % Plot points with the color
        end
        hold off; % Release hold to finish plotting
        title( name(end-15:end) );
        xlabel('Column Index');
        ylabel('Electric Field Log(10)');
        plotColor  = rgb("Gray");
        set(gcf,'position',[ 450, 150, 550, 500])
        set(gcf,'color',plotColor );
        set(gca,'color',plotColor );   
        set(gca, 'FontSize', 20)
        set(gca,'linew',2)

    end 




