



clc
close all
clear


for fi = 1:1:1 %10

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





plotelectricField3D = "TRUE";
iCreateVideo = "TRUE";

spacing = [114.25, 119.75;  114.25, 124.7;     114.25, 129.65;     114.25, 134.6;...
           114.25, 139.55;  104.25, 134.5;     99.25, 134.45;      99.25, 134.45;...  
           94.50,  144.0;   94.50,  149.0;     ] + [.7, .3];            

if plotelectricField3D == "TRUE"

figure;   
fontSizeVal = 16;   

    if iCreateVideo == "TRUE"
            Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\3D Electric Field\";
            Video_FileName = join([  "3D__Field_", num2str(fi), " ", "FusionBetweenProbes", ...
                                      name(end-15:end)  ,'.mp4']);
            Video_FileName = convertStringsToChars(Video_FileName);
            
            Video_fullfile = fullfile(Video_Dir, Video_FileName);
            videoWriter = VideoWriter(Video_fullfile,  'MPEG-4'); %// initialize the VideoWriter object
            videoWriter.FrameRate = 4.5;
            videoWriter.Quality = 100; % High quality video
            open(videoWriter);
    end

    

  for i = 5:1:numTimePoints 
      
        currentData = timePoints{i} ;
        currentData(currentData <= 0) = nan;
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
        intensity = Efield; %rand(1000,1); % 1000 random intensity values
        % Step 2: Find the center of the points
        centerX = mean(x);
        centerY = mean(y);
        centerZ = mean(z);
       
        scaleUp = 1;
        scaleDown = 1;
        Pspacing = 2;
        min_x = min(Coords(:,1)) *scaleDown ;
        max_x = max(Coords(:,1)) *scaleUp ;
        
        min_y = min(Coords(:,2)) *scaleDown ;
        max_y = max(Coords(:,2)) *scaleUp ;
        
        min_z = min(Coords(:,3)) *scaleDown ;
        max_z = max(Coords(:,3)) *scaleUp ;


        min_x =     95;     min_y =   135;         min_z =     110;
        max_x  =    135;    max_y =   182.5;       max_z =     165;
        % 2. a pointcloud B curve with dimensions 8*8*8 with a point every 2mm
        [x, y, z] = meshgrid(  min_x: Pspacing :max_x,      min_y: Pspacing :max_y, ...
                               min_z: Pspacing :max_z);
        B_coord = [x(:), y(:), z(:)];
        % 3. interpolate intensity values from A to get intensity values in pointcloud B
        B_intensity = griddata(Coords(:,1), Coords(:,2), Coords(:,3), intensity, ...
                               B_coord(:,1), B_coord(:,2), B_coord(:,3));
        %%-Nearest_Neighboor 
        BcordNan = B_coord(isnan(B_intensity), :);
        [minDist,I] = min(pdist2(BcordNan, Coords),[], 2);
        NewB_Intense = intensity(I);
        B_intensity(find(isnan(B_intensity)) ) = NewB_Intense;
        

        


  HA(1) = subplot(1,2,1);
            %contourf(Xq, Yq, Zq, 'LineStyle', 'none');
            scaleA  = ceil(  1 + ((intensity - min(intensity)) * (20 - 1)) /...
                     (max(intensity) - min(intensity))   );
            opacity = (scaleA/max(scaleA))/2.5;
            %
            %
            %
            s1 = scatter3( Coords(:,1), Coords(:,2), Coords(:,3),  scaleA, intensity , 'filled') ; 
            s1.AlphaData = opacity;
            s1.MarkerFaceAlpha = 'flat';

            %
            %
            %
            colorbar;
            colormap('jet');
            caxis([2.7 4.1])
            set(gca,'color',rgb("RoyalBlue") );             
            xlabel('\color{white} X (mm)');
            ylabel('\color{white} Y (mm)');
            xlim([ (-34.25 + spacing(fi,1))  (30.75 + spacing(fi,2)) ])
            ylim([125 190])           
            hold on
            [complete1 ] = AddAntennae3D( 122,  170, spacing(fi,1), centerZ, .5 );
            [complete2 ] = AddAntennae3D( 122,  170, spacing(fi,2), centerZ, .5);
            axis equal
            %
            %
            %
            idx = 1 : 1 : (15*4)+1 ;
            minutes =  floor( (idx(i)*15-15)/60) ; 
            seconds  = mod( (idx(i)*15-15), 60)    ;
            titleName = join([ '\color{white} Necrosis', num2str(minutes), "Min", num2str(seconds), "s" ]);       
            title(titleName)
            set(gca, 'FontSize', fontSizeVal)    
            set(gca,'XColor','w');
            set(gca,'YColor','w');
            set(gca,'ZColor','w');
            
            
            %%%
            %%%
            %%%
            %%%
            %%%
            %%%            
        % visualize all the results with colormap 'jet'
            %%%
            %%%
       subplot(1,2,2);
            %
            scaleB = ceil(  1 + ((B_intensity - min(B_intensity)) * (20 - 1)) /...
                    (max(B_intensity) - min(B_intensity))   );
            opacityB = (scaleB/max(scaleB))/2.5;
            %
            %
            s2 = scatter3(B_coord(:,1), B_coord(:,2), B_coord(:,3), scaleB , B_intensity, 'filled');
            s2.AlphaData = opacityB;
            s2.MarkerFaceAlpha = 'flat';            
            %
            %
            colorbar
            colormap('jet');
            caxis([2.7 4.1])
            set(gca,'color',rgb("RoyalBlue") );             
            xlabel('\color{white} X (mm)');
            ylabel('\color{white} Y (mm)');
            xlim([ (-34.25 + spacing(fi,1))  (30.75 + spacing(fi,2)) ])
            ylim([125 190])           
            hold on
            [complete1 ] = AddAntennae3D( 122,  170, spacing(fi,1), centerZ );
            [complete2 ] = AddAntennae3D( 122,  170, spacing(fi,2), centerZ );
            %
            %
            %
            axis equal
            set(gca, 'FontSize', fontSizeVal)    
            set(gca,'XColor','w');
            set(gca,'YColor','w');
            set(gca,'ZColor','w');
            title('PointCloud B, Interpolated');            
 
hold off
fig = gcf;  % get current figure
findall(fig, '-property', 'Color', 'Type', 'text', 'HandleVisibility', 'off');
set(ans, 'Color', 'white');
set(gcf,'color', 'k' ); 
set(gcf,'position',[ 150, 150, 1650, 800])       


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



end 









