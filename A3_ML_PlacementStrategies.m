clear
clc
close all
    

iCreateVideo = "FALSE";


A__All_ProbePoints = [];
A__CompleteProbeInformation = []; 
A__Radius_n_Angle =[];

%radiusSrt = 20*sqrt(2);
radiusSrtArr = [9.9, 14.95 , 19.8, 24.75, 29.7, 34.65];

figure;   
if iCreateVideo == "TRUE"
    Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\ML Placement";
    Video_FileName = join([  "Multiple Radii"  ,'.avi']);
    Video_FileName = convertStringsToChars(Video_FileName);
    
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter.FrameRate = .5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end









for angleIdx = 1:1  %length(radiusSrtArr)

   
%Angles Determine the number of potential target you want to model
TargetNums = 8  ;
angles = linspace(        (angleIdx-1)*pi/(TargetNums-1), ...
                          2*pi+ (angleIdx-1)*pi/(TargetNums-1),...
                          TargetNums + 1   );
anglesDegree = rad2deg(angles);
%
psiAngleArr =  linspace(0 , 360, 2);
thetaAngleArr = linspace(0, 360, 2);
AllAngles = [ [repmat(0, 1, length(psiAngleArr) ) ; psiAngleArr ],    ...
    [thetaAngleArr;  repmat( psiAngleArr(end) , 1, length(thetaAngleArr) ) ] ]';




        psiAngle = AllAngles(angleIdx, 1 ); %rad2deg( 30*pi/180 ) ;
        psi = deg2rad( psiAngle);    % yaw rotation angle
        thetaAngle = AllAngles(angleIdx, 2 );  %rad2deg( -45*pi/180) ;
        theta = deg2rad( thetaAngle ); % pitch rotation angle (negative rotation is up)
        % Define vectors and Calculate the YAW-PITCH transformation matrix
        YAW = [cos(psi), -sin(psi), 0; sin(psi), cos(psi), 0; 0, 0, 1]; % Planar YAW rotation
        PITCH = [cos(theta), 0, sin(theta); 0,1,0; -sin(theta), 0, cos(theta)]; % Planar PITCH rotation
        YP = YAW*PITCH; % YAW-PITCH rotation matrix
        % Rc = Column Vector pointing to circle on X-Axis (start point)
        % Now sweep the Rc vector around the X-axis to generate the circle 
        % This is done by adding a planar ROLL rotation to YP


        spacing = 4 + 1;
        colorNew = hsv(spacing);
        TargetColor = lines(length(angles));
        radiusSrt = radiusSrtArr(angleIdx);

        %ProbeAngleSpacing = radiusSrt*.46     ; 
        coeffs = [2.75699811522693e-06	-5.97080539360025e-05	0.00278434792947981	0.854458589437563	radiusSrtArr(angleIdx)];
        degreeSeparation = 7.5 ;
        X_want  =   (0: degreeSeparation : degreeSeparation*spacing)  ;
        ProbeAngleSpacing = polyval(coeffs, X_want) ; 



        plot3(0, 0, 0, '.r', 'MarkerSize', 20);
        hold on
        CenterX = 0;
        CenterY = 0;
        Target.x = [radiusSrt * cos(angles) + CenterX]';
        Target.y = [radiusSrt * sin(angles) + CenterY]';
        Target.z = [repmat(0, 1, length(angles) )]';
        %Rotate the targets
        Rc = [Target.x  ,Target.y  ,Target.z ]';
        C = [YP*Rc]' ; 
        Target.x  = C(:,1);
        Target.y = C(:,2);
        Target.z = C(:,3);
        clear C


        %%Create the tumor
        [tumor.x1, tumor.y1,  tumor.z1] = sphere(25);
        % r = 14*sqrt(2);
        r = radiusSrt;
        tumor.x1 = tumor.x1(:)*r;
        tumor.y1 = tumor.y1(:)*r;
        tumor.z1 = tumor.z1(:)*r;
        P = [tumor.x1 tumor.y1 tumor.z1];
        %
        [tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
            = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
        set( tumorNew.p1 ,'FaceAlpha',.2, 'EdgeColor', 'none' );
        set(gcf,'color','w');
        axis equal;
        grid off
        xlabel('X', 'FontSize', 14);
        ylabel('Y', 'FontSize', 14);
        zlabel('Z', 'FontSize', 14);
        title("Probe Placement ML Strategy",'FontSize', 30)
        set(gcf,'position',[ 250, 150, 950, 800])  

slct  = 1; 
for i = 1:length(angles) 
    plot3( Target.x(i) , Target.y(i), Target.z(i), '+', 'Color',TargetColor(slct, :)  ,'LineWidth', 3, 'MarkerSize', 14)
    hold on
    slct = slct +1;
    if slct >= length(angles)/2
        slct = 1;
    end 
end 

Arrange.VectorAngles = [];
Arrange.VectorAnglesX = [];
Arrange.VectorAnglesY = [];
Arrange.VectorAnglesZ = [];
Arrange.ProbeDepth =[];
Arrange.DistanceFromCenter=  [];
spaceEnd = spacing;
for i = 1:spaceEnd
            Vector = [];

            %radius = radiusSrt + ProbeAngleSpacing*(i-1);
            radius = ProbeAngleSpacing(i) ;

            
            x = [radius * cos(angles) + CenterX]';
            y = [radius * sin(angles) + CenterY]';
            z = [repmat(50, 1, length(angles) )]';   
            %Rotate the points
            Rc = [x,y,z]';
            C = [YP*Rc]' ; 
            x = C(:,1);
            y = C(:,2);
            z = C(:,3);
                Vector = ( [Target.x, Target.y, Target.z] - [x, y, z]  );
                CenterVector = ( [CenterX, CenterY , Target.z(1)] - [0, 0, 0]  );
                Arrange.ProbeDepth = [Arrange.ProbeDepth;...
                    round( sqrt( Vector(1,1)^2 +  Vector(1,2)^2 +  Vector(1,3)^2), 1)  ];
                Arrange.DistanceFromCenter = [Arrange.DistanceFromCenter;...
                    round( sqrt( x(1)^2 +  y(1)^2 ) , 1) ];
            plot3(x, y, z, '.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', colorNew( i, :) )
            hold on;
            % quiver3(x, y, z, Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
            %      0, 'Color', colorNew(i, : ), 'LineWidth', 2 )
            quiver3(x, y, z, Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
                 0, 'Color', 'k' , 'LineWidth', 2 )

        %Find the angle of the center point to the X-axis
        Arrange.VectorAnglesCenter = ...
            abs( round( rad2deg(atan2( sqrt(CenterVector(1, 1 )^2 + CenterVector(1, 2 )^2),...
            CenterVector(1, 3) ) ), 2) ) ;    
        





        Array1 = [];
        %
        for i_ex = 1:(length(x)-1)
            % Step 1: Create two 3D points A and B
            Av = [ x(i_ex) , y(i_ex), z(i_ex)];
            Bv = [ Target.x(i_ex)  , Target.y(i_ex)  , Target.z(i_ex)  ]; % Ensure they are more than 20 units apart

            % Step 4: Create 100 points in between A and B
            t = linspace(0, 1, 100); 
            Array1 = [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';

                % Step 2: Calculate the vector between two points
                % Step 1 & 2: Create two 3D points
                P1 = Array1(end,:) ;% Point 1
                P2 = Array1(1,:)   ;% Point 2 at least 10 units away
                % Step 3: Calculate the vector between two points
                vector = P2 - P1; 
                % Step 3: Converting Cartesian Coordinates to Spherical Coordinates
                r = norm(vector);                    % Scalar Distance
                theta = atan2(norm(vector(1:2)), vector(3));     % Inclination angle
                psi = atan2(vector(2), vector(1));           % Azimuth Angle
                % Convert from radian to degree
                theta = theta*180/pi; 
                psi = psi*180/pi; 
                %
                % Find the axis of rotation
                axisOfRotation = cross([0 0 1], vector);
                axisOfRotation = axisOfRotation/norm(axisOfRotation); % Normalize to unit vector

            plot1.X = Array1(:,1);           plot1.Y = Array1(:,2);            plot1.Z = Array1(:,3);   
            % scatter3(plot1.X , plot1.Y , plot1.Z, 80,  "square",  'k', "filled" )

            hold on
           
            scatter3(  plot1.X(80),  plot1.Y(80),  plot1.Z(80), 'SizeData', 40, 'MarkerEdgeColor', 'c' ,'LineWidth', 4 )
            textArr = [  plot1.X(80)+ (plot1.X(80)/abs(plot1.X(80)))*2 ,...
                         plot1.Y(80)+ (plot1.Y(80)/abs(plot1.Y(80)))*2 ,...
                         plot1.Z(80)];
            %text(  textArr(1),  textArr(2),  textArr(3), num2str(i_ex), 'FontSize', 25 )



            if i_ex ==1
                text(  x(1)*1.025, y(1)*1.025 , z(1)*1.025 + 5, ...
                join([ num2str( round(theta,0) ), char(176) ]),'FontSize', 12)
            end


        A__CompleteProbeInformation = [ A__CompleteProbeInformation;...
                                        round(theta,1) , round(psi,1),  ...
                                        round(Array1(100,:),1) , round(Array1(80,:),1) , ...
                                        round(Array1(1,:), 1) ]; 
        A__All_ProbePoints = [A__All_ProbePoints;  round(Array1(100,:),1) , ...
                              round(Array1(80,:),1) , round(Array1(1,:), 1)  ]    ;
        end 

        A__Radius_n_Angle = [A__Radius_n_Angle; radius , round(theta,1) ];


    pause(.05)   


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

   






%%


iCreateVideo2 = "TRUE"


if iCreateVideo2 == "TRUE"
    Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\ML Placement";
    Video_FileName = join([  "Single Radius Angle Spin"  ,'.avi']);
    Video_FileName = convertStringsToChars(Video_FileName);
    
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);

    % Number of frames (360 degrees)
    numFrames = 360; 
    
    % Loop over each angle degree to capture frames
    for angle = 1:numFrames
        % View point cloud from the current angle
        view(angle, 60);
        %view(angle, 88); % Second parameter is the elevation angle
        drawnow; % Update fig before capturing
        
        % Capture current frame
        frame = getframe(gcf);
        
        % pause(.25)
        % Write frame to video
        writeVideo(videoWriter, frame);
    end


        close(videoWriter); 
        disp("Video Complete")
        disp(videoWriter.Filename  )
end








hold off








%%

exportData = "TRUE";
if exportData == "TRUE"

       resultsDir= 'D:\Import To Matlab\Aim 3_ProbePlacements';
       resultsDir2 = join([resultsDir ]) ;  
       ExportFileName = join([ 'Additional Pacements','.csv' ])  ;

        exportBoundaryTitle = fullfile(resultsDir2, ExportFileName);
                % Step 2: Convert the matrix to a table
        dataTable = array2table(A__CompleteProbeInformation);
        
        % Step 3: Name each column of the table
        columnNames = {'Theta', 'Psi', 'X_Tip', 'Y_Tip', 'Z_Tip', ...
                       'X_Window', 'Y_Window', 'Z_Window', 'X_Port', 'Y_port', 'Z_port'};
        dataTable.Properties.VariableNames = columnNames;
        
        % Display the first few rows of the table to verify
        disp(dataTable(1:5, :));
    
        %-----------------------------------------%         Write the filename
        writetable( dataTable  , exportBoundaryTitle);         

end 


%% 



figure;   
iCreateVideo = "FALSE";
if iCreateVideo == "TRUE"
    Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\ML Placement";
    Video_FileName = join([  "Viable Probe Strategies"  ,'.mp4']);
    Video_FileName = convertStringsToChars(Video_FileName);
    
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile,  'MPEG-4'); %// initialize the VideoWriter object
    videoWriter.FrameRate = .5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end






% Define the points as a matrix
points = A__All_ProbePoints;
% Initialize an empty cell array to store indices
indicesOverDist = cell(size(points, 1), 1);
indicesOverDistTip = cell(size(points, 1), 1);
BestIndicies = cell(size(points, 1), 1);
% Loop through each row of points

for i = 1:size(points,1)
    % Extract the second set of points from the current row
    point1 = points(i, 4:6);
    points1Tip = points(i, 1:3);
    % Initialize an empty array to store distances
    distances = zeros(size(points, 1), 1);
    distances1Tip = zeros(size(points, 1), 1);
    % Loop through all other rows 
    for j = 1:size(points,1)
        if i ~= j
            % Extract the second set of points from the other row
            point2 = points(j, 4:6);
            point2tTip = points(j, 1:3);
            % Calculate the Euclidean distance
            distances(j) = sqrt(sum((point1 - point2).^2));
            distances1Tip(j) = sqrt(sum((points1Tip - point2tTip).^2));
        end
    end
    % Find indices where distance is greater than 10 units
    indicesOverDist{i} = find(distances > 10 & distances < 30 );
    indicesOverDistTip{i} = find(distances1Tip > 5 );
    BestIndicies{i} = intersect( indicesOverDist{ i, 1} , indicesOverDistTip{i, 1} );
end



%FIGURES
plot3( A__All_ProbePoints(:,1), A__All_ProbePoints(:,2), A__All_ProbePoints(:,3), '.'   )

for i_ex = 1: size(A__All_ProbePoints, 1)
        CurrProbePts =  A__All_ProbePoints(i_ex ,:) ;
        % A = top point.. B = Bottom Point
        Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
        Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ]; 
        % Step 4: Create 100 points in between A and B
        t = linspace(0, 1, 100); 
        Array1 = [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';
        
       
        plot1.X = Array1(:,1);           plot1.Y = Array1(:,2);            plot1.Z = Array1(:,3);   
        plot3( plot1.X , plot1.Y , plot1.Z, '.', 'Color', 'k', 'MarkerSize', 8     )
        hold on
end 


set(gcf,'color','w');
axis equal;
grid off
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
title("Viable Placement Strategy",'FontSize', 15)
set(gcf,'position',[ 250, 150, 650, 600])  
view([ 30 50])

for icurrProbe = 1:1
%PLLOT ALL THE PROBES THAT ARE SUFFICIENTLY 
Current_length = length( BestIndicies{1, 1} ) +1;

    for i_ex = 1: Current_length
    
                if i_ex == 1
                        CurrProbePts =  A__All_ProbePoints(icurrProbe,:) ;
                        % A = top point.. B = Bottom Point
                        Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
                        Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ];
                        MarkrColr = 'r'; 
                else

                        currentProbeIndex = BestIndicies{ icurrProbe, 1}  ;
                        CurrProbePts =  A__All_ProbePoints(currentProbeIndex(i_ex-1) ,:) ;
                        % A = top point.. B = Bottom Point
                        Av = [ CurrProbePts(end-2), CurrProbePts(end-1), CurrProbePts(end ) ];
                        Bv = [ CurrProbePts( 1 ), CurrProbePts( 2 ), CurrProbePts( 3 ) ];
                        MarkrColr = 'c'; 
                
                end 
                % Step 4: Create 100 points in between A and B
                t = linspace(0, 1, 100); 
                Array1 = [Av(1) + (Bv(1)-Av(1))*t; Av(2) + (Bv(2)-Av(2))*t; Av(3) + (Bv(3)-Av(3))*t]';
                
    
                plot1.X = Array1(:,1);           plot1.Y = Array1(:,2);            plot1.Z = Array1(:,3);   
                plot3( plot1.X , plot1.Y , plot1.Z, '.', 'Color', 'k', 'MarkerSize', 8     )
                hold on
                scatter3(  plot1.X(80),  plot1.Y(80),  plot1.Z(80), 'SizeData', 50, 'MarkerEdgeColor', MarkrColr,'LineWidth', 4 )
                % textArr = [  plot1.X(80)+ (plot1.X(80)/abs(plot1.X(80)))*2 ,...
                %              plot1.Y(80)+ (plot1.Y(80)/abs(plot1.Y(80)))*2 ,...
                %              plot1.Z(80)];
                % text(  textArr(1),  textArr(2),  textArr(3), num2str(i_ex), 'FontSize', 25 )




    pause(.05)

    
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




Data2export = [];
exportData = "FALSE";
if exportData == "TRUE"
    for exprti = 1:size(BestIndicies,1)

        currentData = BestIndicies{ exprti, 1};
        FillData = zeros(1,size(BestIndicies,1));
        FillData(1: length(currentData)) = currentData;
        Data2export = [Data2export; FillData]; 
    end 

end 


























