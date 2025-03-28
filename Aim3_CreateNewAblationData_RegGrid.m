clc
clear
close all


disp("TASKS")
disp("Use the Abla0tion Volumes from the COMSOL Models")
disp("Use the given ablation probes to create the masks")
disp("Save the output 3d points, use 1mm spacing")





intensity.spc = 2;
%Create the Box Phantom Model
% Step 1: Generate a 3D spherical point cloud shell
num_points = 1000;
theta = 2 * pi * rand(num_points, 1);
phi = acos(2 * rand(num_points, 1) - 1);
radius = 30;
x = radius * sin(phi) .* cos(theta);
y = radius * sin(phi) .* sin(theta);
z = radius * cos(phi);
points = [x y z];


    intensity.spc = 2;
    %Create the Box Phantom Model
    pVox.VoxSize = [100, 100, 100 ] ;
    center = [0,0,0]- (pVox.VoxSize/2) ;
    %Choose where to start and end 
    strt = [0, 0, 0];
    endd = [0,0,0];
    
    
    pVox.points = [0 0 0; 0 0 0];
    pVox.Volxelx = [ center(1) +  pVox.VoxSize(1)*strt(1) :pVox.VoxSize(1): pVox.VoxSize(1)*endd(1)  +  center(1)  ] ;
    pVox.Volxely = [ center(2) +  pVox.VoxSize(2)*strt(2) :pVox.VoxSize(2): pVox.VoxSize(2)*endd(2)  +  center(2)  ] ;
    pVox.Volxelz = [ center(3) +  pVox.VoxSize(3)*strt(3) :pVox.VoxSize(3): pVox.VoxSize(3)*endd(3)  +  center(3)  ] ;
    
    
    
    [intensity.X,intensity.Y,intensity.Z] = meshgrid( pVox.Volxelx : intensity.spc : abs(pVox.Volxelx),...
        pVox.Volxely : intensity.spc :abs(pVox.Volxely), ...
        pVox.Volxelz : intensity.spc :abs(pVox.Volxelz) ) ;
    intensity.X = reshape(intensity.X, [],1);
    intensity.Y = reshape(intensity.Y, [],1);
    intensity.Z = reshape(intensity.Z, [],1);
    intensity.a = 1;
    intensity.b = 50;
    intensity.I = (intensity.b-intensity.a).*rand(length(intensity.X),1) + intensity.a;
    
    dimension = length(pVox.Volxelx : intensity.spc : abs(pVox.Volxelx));




    %
        QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
        TargetPoints = points ;

        
        center = [0,0,0];
        [ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  center ) ; 
        %
        %
        distancesIn = distances;
        distancesIn(distancesIn > 0) = nan;
        [filtered_coords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, distancesIn);
        %
        %
        distances(distances >0) = 1;
        distances(distances <0) = -1;
    
    
        Volume = (4/3) * pi * radius^3; 
        Points_To_Volume = Volume/ length(filtered_coords);
        Volume = round( (Volume/1000), 2);


    figure()
    set(gcf,'color','w');                
    %Find the triangulation of the Interogation Boundary Points 
    scatter3( QuerryPointsOG(:,1) , QuerryPointsOG(:,2), QuerryPointsOG(:,3), ...
                '.', 'Color', rgb('RoyalBlue'),...
        'SizeData', 30)  
     
    
    axis equal
    hold off


    %





    figure() 
    set(gcf,'color','w');                
    %Find the triangulation of the Interogation Boundary Points 
    plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3), ...
                '.', 'Color', rgb('Black'),...
        'MarkerSize', 10)  
    hold on 
    

    P = filtered_coords;
    scatter3( P(:,1) , P(:,2) ,P(:,3), 2,  filtered_intensities ) 
    
    colormap jet
    cb=colorbar;
    cb.FontSize = 18;
    title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
        currentPosition = cb.Position;
        % Modify the height to be half of the original by changing the 4th element
        % of the position vector. Also, adjust the bottom position to center the colorbar.
        newHeight = currentPosition(4) / 1.5; % New height is half of the original
        newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
        cb.Position = [currentPosition(1) newBottom currentPosition(3) newHeight];
    %         title(hc,'mm', 'FontSize', 20);
    title( join(['Volume: ', num2str(Volume), "cm^{3}" ]), 'Fontsize', 20)
    C=caxis;
axis equal
hold off

%%
clc
close all


    % Specify the directory you want to search in
    directoryPath = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data\AllData'; % Change this to your directory
    % Create a pattern to match .mph files
    filePattern = fullfile(directoryPath, '*.csv');
    % Get a list of all files in the directory with .mph extension
    FilesCSV = dir(filePattern);
    %
    exportDIR = 'D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIII';

    %  FALSE   TRUE
    CreateData = "TRUE";

%


%
for fi = 3: size(  FilesCSV, 1)/2
    tic
% figure() 

 
        
            file_path = fullfile(directoryPath, FilesCSV(fi).name);
            [filepath, fname, fext]  = fileparts(file_path); 
         % Read data from the CSV file
            data = csvread(file_path);
            % Number of chunks
            chunkSize = 4;
            numChunks = size(data, 2) / chunkSize;
            % Initialize array to store all points and vectors after rotation
            % Handle each chunk of 6 columns
            %figure;


%all_angles = [0, 90, 150, 270];  %1
%all_angles = [60, 120, 300];  %2
all_angles = [0];

for j = 1: length(all_angles)





DataExport = [];    
for i = 2:  numChunks



    % Extract points and vectors
    startIndex = (i - 1) * chunkSize + 1;
    endIndex = startIndex + chunkSize - 1;
    chunkData = data(:, startIndex:endIndex);
    points = chunkData(:, 1:3);
    vectors = chunkData(:, 4);
    
    

    
    
    points = points(2:end, :);
    




        UpsamplingData = "TRUE";
        %

        sampleI = 1;
        if UpsamplingData == "TRUE"

              

                    AllData1 =  points;
                    NewPoints = AllData1;     
                    Upsample = "TRUE";
                    numpoints = 3000;
                    %

                    %-----------------------------------------------------------------------%   

                    
                    if Upsample == "TRUE"      

                        

                        if size(AllData1,1) < numpoints && sampleI< 10
                            [ AllData1 ] = UpsampledAblationSpec( NewPoints, numpoints ) ;
                            disp("Upsampled") 

                            sampleI = sampleI +1; 

                            %--------------------------------------------------------------%
                            if size(AllData1,1) < numpoints
                                while size(AllData1,1) < numpoints  && sampleI< 10
                                    [ AllData1 ] = UpsampledAblationSpec( AllData1, numpoints ) ;
                                    disp("Upsampled II") 

                                    sampleI = sampleI +1; 
                                end 
                            end 
                        end 

                        if  size(AllData1,1) > numpoints    &&  sampleI< 10
                            [ AllData1 ] = DownsampleAblationSpec( NewPoints, numpoints ) ;
                             disp("Downsample") 

                             sampleI = sampleI +1; 
                        else
                            disp("Best Sample")   
                        end 



                    end    

                    disp("SAMPLING COMPLETTE")   

        %points =  AllData1;           
        end 


    points = chunkData(:, 1:3);
    points = points(2:end, :);    
    

    [ProbePointExport, plotedLine1, plotedLine2 ] =  A3_FindPlotPoints(file_path);
     % scatter3(ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3), ...
     %                            150, '.', 'k');
     % axis equal
    % 
    %
    QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
        %TargetPoints = SmoothedAblationTimePoints{i} ;
        TargetPoints = points ;
        TargetCenter = mean(TargetPoints);
        %TargetPoints = TargetPoints; %+ (mean(QuerryPointsOG ) - TargetCenter);
        %
        %
        AllProbes = ProbePointExport; % + (mean(QuerryPointsOG ) - TargetCenter);
        TargetCenterIn = mean(TargetPoints);
        %
        ProbeMidpoints =  ProbeTargetsLineUp(  plotedLine1, plotedLine2 ) ;
        %
        %
        filtered_probe_midpoints = filter_probePoints(   TargetPoints,   ProbeMidpoints  );
        filtered_probe =  filter_probePoints(   TargetPoints,   ProbePointExport  );
        AllProbesIN =  [ filtered_probe  ];


        
     if UpsamplingData == "TRUE"   
        TargetPoints = AllData1 ;
     end 




        rotate_Points = "TRUE";
             %
        if rotate_Points == "TRUE"

         center =   mean(  AllProbesIN  ); 
         angleDegrees = all_angles(j);
         %
         rotatedPoints_Probe = rotatePointsZ( AllProbesIN, center, angleDegrees);
         rotatedPoints_Ablation  = rotatePointsZ( points, center, angleDegrees);
         %
         %
             AllProbesIN = rotatedPoints_Probe;
             TargetPoints = rotatedPoints_Ablation;
        end 



            
                    
                    % Visualize the results
                    plot_Filtered_Probe = "FALSE";

                    if plot_Filtered_Probe == "TRUE"
                        figure(1);
                        %
                        scatter3(filtered_probe(:,1), filtered_probe(:,2), filtered_probe(:,3), 'bo');
                        hold on 
                        scatter3(ProbeMidpoints(:,1), ProbeMidpoints(:,2), ProbeMidpoints(:,3), 'ro');
    
                         Probe1in = ProbePointExport( 1:100, :);
                        Probe2in = ProbePointExport( 101:200, :);
                        %
                        plot3( Probe1in(:,1), Probe1in(:,2), Probe1in(:,3), ...
                                'k.', 'MarkerSize', 10)  
                        plot3( Probe2in(:,1), Probe2in(:,2), Probe2in(:,3), ...
                                'k.', 'MarkerSize', 10 )
                        legend(' Filtered Probe ');
                        xlabel('X');
                        ylabel('Y');
                        zlabel('Z');
                        title( join(['Pointcloud Filtering Based on A', newline, num2str(i)]) );
                        grid on;
                        axis equal
                        hold off
                    end 

         
        [ distances ] = SDAVectorTargetFusedAblation_CombinedProbe( TargetPoints , QuerryPointsOG,...
                                                        AllProbesIN ) ;
        
                 % Call the function
        midpoint = [mean(  AllProbesIN  )]  +  [0, 0,  max( AllProbesIN(:, 3)).* 75   ] ; 
        new_intensities = A3_Filter_NewIntensities( [QuerryPointsOG, distances']  , midpoint)  ;
        distances = new_intensities;



%



%LAST FILTERS 


    
    B = [QuerryPointsOG, distances];
    Ablation = chunkData(:, 1:3);
    Ablation = points(2:end, :);    
    %
    negative_distances = distances(distances < 0);
    Lower_threshold_value = prctile(negative_distances, 10)
    InsideLimit = -1 * Lower_threshold_value;
    OutsideLimit = -0.5;        
    %
    [filtered_point_exp] = filter_AblationFixedGridPoints(Ablation, B, InsideLimit, OutsideLimit);
    %distances = filtered_point_exp(:,4);


    
%FINAL FILTER


    % %data: 3D points and their intensity values
    % % A matrix where each row is a point [x, y, z, intensity]
    % pointsFinal = filtered_point_exp;
    % % Calculate the median intensity
    % medianIntensity = median(negative_distances) - std(negative_distances);
    % % Logical indexing to find points with intensity greater than median and z-value greater than 10
    % z_Threshold = 10 + 42*(i/59)   ;
    % indices = pointsFinal(:, 4) < medianIntensity & pointsFinal(:, 3) > z_Threshold;
    % % Multiply the intensity of filtered points by -1
    % pointsFinal(indices, 4) = pointsFinal(indices, 4) * -1;


    Ablation_Center = mean(chunkData(:, 1:3));
    z_Threshold = 20 + 50*(i/59)   ;
    specificPoint = [ Ablation_Center(1), Ablation_Center(2), z_Threshold] ;
    intensityThreshold = mean(negative_distances) ;
    radius = 8;
    pointsFinal = filterIntensityPoints(filtered_point_exp, specificPoint, intensityThreshold, radius);





distances = pointsFinal(:,4);





    %
    plot_Results = "FALSE";
    
    if plot_Results == "TRUE"
    
        distancesIn = distances;
        distancesIn(distancesIn > 0) = nan;
        %distancesIn(distancesIn < -10) = nan;

    
        [filtered_coords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, distancesIn);
        Volume = round( (Points_To_Volume*length(filtered_coords))/1000, 2); 
    
    
        figure(2);
        set(gcf,'color','w');                
            %Find the triangulation of the Interogation Boundary Points 
            plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3), ...
                        '.', 'Color', rgb('Black'),...
                'MarkerSize', 10)  
            hold on 
    
                    % Probe1in = ProbePointExport( 1:100, :);
                    % Probe2in = ProbePointExport( 101:200, :);
                    % %
                    % plot3( Probe1in(:,1), Probe1in(:,2), Probe1in(:,3), ...
                    %         'k.', 'MarkerSize', 10)  
                    % plot3( Probe2in(:,1), Probe2in(:,2), Probe2in(:,3), ...
                    %         'k.', 'MarkerSize', 10 )
            
                     plot3( AllProbesIN(:,1), AllProbesIN(:,2), AllProbesIN(:,3), ...
                             'k.', 'MarkerSize', 25 )        
           P = filtered_coords;
           % filtered_intensities = distances;
            scatter3( P(:,1) , P(:,2) ,P(:,3), 10,  filtered_intensities, 'filled' ) 
                colormap jet
                cb=colorbar;
                cb.FontSize = 18;
                title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
                    currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [currentPosition(1) newBottom currentPosition(3) newHeight];
                %         title(hc,'mm', 'FontSize', 20);
                title( join(["Vol = ", Volume, 'cm^{3}']), 'Fontsize', 30)
                C=caxis;




               scatter3( specificPoint(1), specificPoint(2), specificPoint(3), 100, 'k' )


        axis equal
        grid on
        hold off
        set(gcf,'position',[ 250, 100, 650, 650])    
    end 



    pause(.25)


    DataExport = [ DataExport,   round( distances, 2) ];
end 


DataExport = [QuerryPointsOG,  DataExport]; 




    % Output file path
    if CreateData == "TRUE"
    
        [~, name, ext] = fileparts(file_path);
        %outputFileName = fullfile(exportDIR, sprintf('Distance Mask_%s%s', name, ext));
        outputFileName = fullfile(exportDIR, sprintf('%ddegree_%s%s', angleDegrees, name, ext));
        % Write the results to a new CSV file
        csvwrite(outputFileName, DataExport);
    end 



toc
end 

end 
