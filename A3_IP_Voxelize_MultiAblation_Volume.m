 
clear
clc
close all

% Step 1: Generate a 3D spherical point cloud shell
num_points = 1000;
theta = 2 * pi * rand(num_points, 1);
phi = acos(2 * rand(num_points, 1) - 1);
radius = 30;
x = radius * sin(phi) .* cos(theta);
y = radius * sin(phi) .* sin(theta);
z = radius * cos(phi);
points = [x y z];



colorAblation = hsv( 6 );

%Either use: exprmt or N for selection
AblAP_All_Single = zeros(1000, 3*20);
AblAP_All_Multi = zeros(1000, 3*20);    

%Create the Box Phantom Model
pVox.VoxSize = [80, 80, 80 ] ;
center = [0,0,0]- (pVox.VoxSize/2) ;
%Choose where to start and end 
strt = [0, 0, 0];
endd = [0,0,0];


pVox.points = [0 0 0; 0 0 0];
pVox.Volxelx = [ center(1) +  pVox.VoxSize(1)*strt(1) :pVox.VoxSize(1): pVox.VoxSize(1)*endd(1)  +  center(1)  ] ;
pVox.Volxely = [ center(2) +  pVox.VoxSize(2)*strt(2) :pVox.VoxSize(2): pVox.VoxSize(2)*endd(2)  +  center(2)  ] ;
pVox.Volxelz = [ center(3) +  pVox.VoxSize(3)*strt(3) :pVox.VoxSize(3): pVox.VoxSize(3)*endd(3)  +  center(3)  ] ;

intensity.spc = 1.5;

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
     
    TargetPoints = points ;
    QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
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




patient = ["Healthy", "Low", "Mild", "Moderate"];

ProbePosition = 1;
Patient = patient(1);
[file_path ] = SelectAblationBoundary915Multiprobe( ProbePosition, Patient);
disp(file_path)

    
%
    [filepath,name,ext] = fileparts(file_path);    
    OGdata = readtable(file_path);
    data = table2array(OGdata);
% Extract the coordinates, temperature, arrhenius, and electric field values
%
% Separate the temperature, arrhenius, and electric field values for each time point
    numTimePoints = 61;  % Calculate the number of time points
    timePoints = cell(numTimePoints, 1);
    
    for i = 2:numTimePoints
        startIndex = 1 + (i - 1) * 3;
        endIndex = startIndex + 2;
        SaveData = data(2:end, startIndex:endIndex);
        SaveData(SaveData == 0) = nan;
        timePoints{i} = SaveData;
    end
%
startPoint = 3;
                                      disp("       DATA   LOADING   FINISHED       "  )

%

Types = ["A","D";  
         "B","C";  
         "B","D";   
         "A","C"];
Centers = [224, 260, 190,          221, 260, 172;
           221-2, 260, 190,        221-3.75, 260, 172;
           221-3.75, 260, 190,     221-3.75, 260, 172;
           224, 260, 190,      221, 260, 172];
TargetCenter = [221,	260	,  182];


for j = 1:2

 a = (j-1)*3 +1;
 b = (j-1)*3 +3;
 

 Placement =    Types(1, j)
 TargetCenter = Centers(1, a:b )
 switch  Placement
    case "A"
         psiAngle = [180+20 , 0 ];
         thetaAngle = [90-35 , 0 ];
         patient = 1;
         
    case "B"   
         psiAngle = [ (75+90 + 10+3) , 0 ];
         thetaAngle = [90 , 0 ];  
         patient = 2;

   case "C" 
        psiAngle = [ (112.5+90 - 8 - 5 ) , 0 ];
        thetaAngle = [90-4 , 0 ];  
        patient = 3;
        
    case "D"
        psiAngle = [100+90 , 0 ];
        thetaAngle = [90+10 , 0 ]; 
        patient = 4;
 end 



lengthLine = 50; 
switch j
    case 1
    [Probe1] = plot3DLineFromSpherical( psiAngle(1), thetaAngle(1) , ...
                                                            TargetCenter, lengthLine);
    case 2
    [Probe2] = plot3DLineFromSpherical( psiAngle(1), thetaAngle(1) , ...
                                                            TargetCenter, lengthLine);
end 



end

figure() 
currPts = timePoints{3, 1}  ;
plot3( currPts(:,1),  currPts(:,2), currPts(:,3), ...
       'r.', 'MarkerSize', 5)  
hold on 
plot3( Probe1(:,1), Probe1(:,2), Probe1(:,3), ...
        'k.', 'MarkerSize', 10)  
plot3( Probe2(:,1), Probe2(:,2), Probe2(:,3), ...
        'k.', 'MarkerSize', 10 )
title('Original Point Cloud');
axis equal;

xlabel("X")
ylabel("Y")
zlabel("Z")
hold off

%



%plot the ablation
%Smooth the ablation
SmoothedData = "TRUE";
if SmoothedData == "TRUE"

     ProbeFilePath = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
     MphName = file_path;
     disp(MphName)
     
[SmoothedAblationTimePoints, ProbepointsExport] = Smooth_Multi_WithProbePts( ...
    Probe1, Probe2,  timePoints, startPoint, numTimePoints)  ; 

                                    disp("       DATA   SMOOTHING   FINISHED       "  )
end 


%



%upsample the ablation
UpsamplingData = "TRUE";
%
if UpsamplingData == "TRUE"
    NewSampledData = cell(numTimePoints, 1);
    StartAdj = startPoint - 1; 
    for i = startPoint: numTimePoints
        %
    
        currentData = timePoints{i} ;
        Coords = SmoothedAblationTimePoints{i} ;
        % Arrhnus = currentData(:, 4);  
        ProbePoints = ProbepointsExport{i};
        %
     
        AllData1 =  Coords;
        NewPoints = AllData1;     
        Upsample = "TRUE";
        numpoints = 2600;
        %
 
        %-------------------------------------------------------------------------------%     
        if Upsample == "TRUE"      
            if size(AllData1,1) < numpoints
                [ AllData1 ] = UpsampledAblationSpec( NewPoints, numpoints ) ;
                disp("Upsampled") 
                
                %--------------------------------------------------------------%
                if size(AllData1,1) < numpoints
                    while size(AllData1,1) < numpoints
                        [ AllData1 ] = UpsampledAblationSpec( AllData1, numpoints ) ;
                        disp("Upsampled II") 
                    end 
                end 
            end 
                
            if  size(AllData1,1) > numpoints
                [ AllData1 ] = DownsampleAblationSpec( NewPoints, numpoints ) ;
                 disp("Downsample") 
            else
                disp("Best Sample")   
            end 
        end      
        %-------------------------------------------------------------------------------%  
    
    NewSampledData{i} = AllData1;
    
    
    
    scatter3(  AllData1(:,1), AllData1(:,2), AllData1(:,3), 10, 'filled' )
    hold on 
    scatter3(  ProbePoints(:,1), ProbePoints(:,2), ProbePoints(:,3), 10, 'k', 'filled' )
    axis equal 
    pause(.25)
    hold off
    end 
                                               disp("       SAMPLING   FINISHED       "  )
end 

%%
%find the signed distance to agreement using probe points

QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
% Newcenter  = mean(QuerryPointsOG ) + TargetCenter;
% QuerryPointsOG = QuerryPointsOG + Newcenter;

for i = 40:40 % numTimePoints  %startPoint: numTimePoints


    %TargetPoints = SmoothedAblationTimePoints{i} ;
    TargetPoints = NewSampledData{i} ;
    TargetCenter = mean(NewSampledData{i});
    TargetPoints = TargetPoints + (mean(QuerryPointsOG ) - TargetCenter);
    %
    %
    AllProbes = ProbepointsExport{i}  + (mean(QuerryPointsOG ) - TargetCenter);
        TargetCenterIn = mean(TargetPoints);
        Probe1in = Probe1 + (mean(QuerryPointsOG ) - TargetCenter);
        Probe2in = Probe2 + (mean(QuerryPointsOG ) - TargetCenter);
        [ midpoints ] = PlotLineBetweenProbe(  Probe1in, Probe2in) ;
        AllProbes  = [AllProbes];

       AllProbesIN =  [AllProbes; midpoints];


      %[ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  TargetCenterIn ) ; 
     [ distances ] = SDAVectorTargetFusedAblation_CombinedProbe( TargetPoints , QuerryPointsOG,...
                                                    midpoints ) ;

end 

%%

    distancesIn = distances;
    distancesIn(distancesIn > 0) = nan;
    distancesIn(distancesIn < -10) = nan;
    [filtered_coords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, distancesIn);
    %
    % distances(distances >0) = 1;
    % distances(distances <0) = -1;
    %
    Volume = round( (Points_To_Volume*length(filtered_coords))/1000, 2); 

    %
    figure() 
    set(gcf,'color','w');                
        %Find the triangulation of the Interogation Boundary Points 
        plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3), ...
                    '.', 'Color', rgb('Black'),...
            'MarkerSize', 10)  
        hold on 

        plot3( Probe1in(:,1), Probe1in(:,2), Probe1in(:,3), ...
                'k.', 'MarkerSize', 10)  
        plot3( Probe2in(:,1), Probe2in(:,2), Probe2in(:,3), ...
                'k.', 'MarkerSize', 10 )

        % plot3( AllProbes(:,1), AllProbes(:,2), AllProbes(:,3), ...
        %         'k.', 'MarkerSize', 25 )        
    
        P = filtered_coords;
       %  P = QuerryPointsOG;
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
    axis equal
    grid off
    axis off
    hold off

    set(gcf,'position',[ 250, 100, 650, 650])    


%calculate the volume
%Tada! 








