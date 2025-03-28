%Create an atlas
close all
clear


Vandy_map2 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Orange"); rgb("OrangeRed"); ...
            rgb("FireBrick");  rgb("Maroon")]; 
Vandy_map5  = [  repmat(rgb("RoyalBlue"), 5,1) ;...
            repmat( rgb("BurlyWood"), 5,1) ;repmat( rgb("Peru"), 5,1) ;...
            repmat( rgb("Orange"), 5,1) ;repmat( rgb("DarkOrange"), 5,1);...
            repmat( rgb("OrangeRed"), 4, 1) ; repmat( rgb("FireBrick"), 5,1) ;...
            repmat( rgb("Maroon"), 5,1) ];        
        
SdtMap = Vandy_map2;
SDATAMap = Vandy_map5;



plotAblation = "TRUE";
plotMultiAblation = "FALSE";
MultiAblationCheck = "FALSE"; 
PlotTumorSDA = "FALSE";
plotVectors = "FALSE";
plotVoxelMask = "TRUE";

%Make a Video
writerObj = VideoWriter('VoxelField_Test.avi'); %// initialize the VideoWriter object
writerObj.FrameRate = 2;
open(writerObj) ;


figure()
radiusSrt = 7*sqrt(2);

%Angles Determine the number of potential target you want to model
angles = linspace(0, 2*pi, 1 + 1);

%
psiAngleArr =  linspace(0 , 360, 16 + 1)-radiusSrt;
thetaAngleArr = linspace(0, 360, 17 + 1);
AllAngles = [ [repmat(0, 1, length(psiAngleArr) ) ; psiAngleArr ],   ...
[ thetaAngleArr ; repmat(80, 1, length(thetaAngleArr) ) ] ]';
%

N = 3;
%AllAngles = [0 + (360-0).* rand(N,1), 0 + (45-0).* rand(N,1) ]; 
AllAngles =[  repmat(0, N, 1) , linspace(0, 30, N)',   repmat(0, N, 1) , linspace(0, 30, N)';...
              repmat(45, N, 1) , linspace(0, 30, N)',  repmat(45, N, 1) , linspace(0, 30, N)';...
              repmat(90, N, 1) , linspace(0, 30, N)',  repmat(90, N, 1) , linspace(0, 30, N)';...
              repmat(135, N, 1) , linspace(0, 30, N)', repmat(135, N, 1) , linspace(0, 30, N)';...
              repmat(180, N, 1) , linspace(0, 30, N)', repmat(180, N, 1) , linspace(0, 30, N)';... 
              repmat(225, N, 1) , linspace(0, 30, N)', repmat(225, N, 1) , linspace(0, 30, N)';... 
              repmat(270, N, 1) , linspace(0, 30, N)', repmat(270, N, 1) , linspace(0, 30, N)';...
              repmat(315, N, 1) , linspace(0, 30, N)', repmat(315, N, 1) , linspace(0, 30, N)'; ];    

% AllAngles = [0, 0, 180, 0;
%              0, 0, 180, 15;
%              0, 0, 180, 30;
%              0, 15, 180, 15;
%              0, 15, 180, 30;
%              0, 30, 180, 30;
%              0, 0, 270, 0;
%              0, 0, 270, 15;
%              0, 0, 270, 30;
%              0, 15, 270, 15;
%              0, 15, 270, 30;
%              0, 30, 270, 30];

% AllAngles = [0, 0, 180, 0;
%              0, 5, 180, 5;
%              0, 10, 180, 10;
%              0, 15, 180, 15;
%              0, 20, 180, 20;
%              0, 25, 180, 25];   


AllTumorSlct = [1,3; 1,3; 1,3; 1,3; 1,3; 1,3;
                 1,4; 1,4; 1,4; 1,4; 1,4; 1,4];
ViewAdd = [  repmat(0, 6, 1);  repmat(-100, 6, 1)]; 

         
colorAblation = hsv(    size(AllAngles,1)    );
VectorData.Vectors = [];
VectorData.Coordinates = [];

             
%Either use: exprmt or N for selection
AblAP_All_Single = zeros(1000, 3*20);
AblAP_All_Multi = zeros(1000, 3*20);    


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



for exprmt = 1:length(AllAngles) %6 %12 or 6  
AblAP = [];     
% for targetTum = 1:4
    AllCenters = [1,0,0; 
                  0,1,0; 
                  -1,0,0; 
                   0,-1,0]*.50;                       
for cmpr = 2:2
    
figure( 1 )
%%% OR
%subplot (3 ,4, exprmt  )  
% subplot (2 , 3, exprmt  )   

    switch cmpr 
        case 1
            plotAblation = "TRUE";
            plotMultiAblation = "FALSE";
            ModelRun = [ "Multiprobe" ] ;  
            shiftZ = 0;
            
        case 2
            plotAblation = "TRUE";
            plotMultiAblation = "FALSE";
            ModelRun = [ "Single Ablation" ] ;  
            shiftZ = -5;
            radmult = [1, 1.25, 1.5, 2, 2.25, 2.50, repmat(1,  1, 10)  ]; 
    end 
    
    
for angleIdx = 1:2  %1:N
    
    
targetTum =  AllTumorSlct(exprmt, angleIdx); 
Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"]; 
Angles = ["0"; "5"; "10"; "15"; "20"; "25"];
pj = 1;   
position = 1;     
selectfile = convertStringsToChars(Patient(pj)); 

%ModelRun = [ "Multiprobe" ] ;    

    switch ModelRun
        %%% 915 Mhz Tumor Naive Models
        case  "915 Mhz Tumor Naive"
            fileName = SelectAblationBoundaryPointsNoTumor( position , selectfile ) ;    
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive';


        %%% 915 Mhz Digital Twin Models    
        case "915 Mhz Digital Twin"
            fileName = SelectAblationBoundaryPoints( position , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin';


        %%% 2450 Mhz Tumor Naive Models
        case "2450 Mhz Tumor Naive"   
            %fileName = SelectAblationBoundaryPoints2450mhzNoTumor( position , selectfile ) ;
            fileName = SelectAblationBoundaryPts2450mhzNoTumorV2( position , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2';

        %%% 2450 Mhz Digital Twin Models
        case "2450 Mhz Digital Twin"
            fileName = SelectAblationBoundaryPoints2450mhzV2( position , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2';    
        
        case "Single Ablation"
             fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxGeomPhantom_TrueBeefAblation_SingleAblation60W.csv";
             
        case "Multiprobe"
             Angle = Angles(exprmt);
             fileName = SelectMultiAblationBoundaryPoints915mhz( position, Angle);
    end 
    
   

disp(fileName)

%angleIdx + (targetTum-1)*N  , 1        
psiAngle = AllAngles(  exprmt, (angleIdx-1)*2 +1 ); %rad2deg( 30*pi/180 ) ;
psi = deg2rad( psiAngle);    % yaw rotation angle

%angleIdx + (targetTum-1)*N , 2 
thetaAngle = AllAngles( exprmt , (angleIdx-1)*2 +2  );  %rad2deg( -45*pi/180) ;
theta = deg2rad( thetaAngle ); % pitch rotation angle (negative rotation is up)


% Define vectors and Calculate the YAW-PITCH transformation matrix
YAW = [cos(psi), -sin(psi), 0; sin(psi), cos(psi), 0; 0, 0, 1]; % Planar YAW rotation
PITCH = [cos(theta), 0, sin(theta); 0,1,0; -sin(theta), 0, cos(theta)]; % Planar PITCH rotation
YP = YAW*PITCH; % YAW-PITCH rotation matrix
% Rc = Column Vector pointing to circle on X-Axis (start point)
% Now sweep the Rc vector around the X-axis to generate the circle 
% This is done by adding a planar ROLL rotation to YP




radiusSrt = 10; %7*sqrt(2);
ProbeAngleSpacing = radiusSrt*.46 ; 
plot3(0, 0, 0, '.r', 'MarkerSize', 20);
hold on
CenterX = AllCenters( targetTum ,1) ;
CenterY = AllCenters( targetTum ,2) ;
Target.x = [radiusSrt * cos(angles) + CenterX]' *0;
Target.y = [radiusSrt * sin(angles) + CenterY]' *0;
Target.z = [repmat(0, 1, length(angles) )]' ;

%Rotate the targets
Rc = [Target.x  ,Target.y  ,Target.z ]';
C = [YP*Rc]' ; 

Target.x  = C(:,1);
Target.y = C(:,2);
Target.z = C(:,3);

clear C
%

Arrange.VectorAngles = [];
Arrange.VectorAnglesX = [];
Arrange.VectorAnglesY = [];
Arrange.VectorAnglesZ = [];
Arrange.ProbeDepth =[];
Arrange.DistanceFromCenter=  [];


spaceEnd = 1;

for i = 1:spaceEnd
    
    Nz = 100000; 
    Vector = [];
    radius = radiusSrt + ProbeAngleSpacing*(i-1);
    CenterX = 0;
    CenterY = 0;
    x = [radius * cos(angles) + CenterX]';
    y = [radius * sin(angles) + CenterY]';
    z = [repmat(Nz , 1, length(angles) )]';
    
    %Rotate the points
    Rc = [x,y,z]';
    C = [YP*Rc]' ; 
    %Assign the points 
    x = C(:,1)+100;
    y = C(:,2);
    z = C(:,3);
    
    %Caclulate the vectors 
    Vector = ( [Target.x , Target.y, Target.z] - [x, y, z]  );
    
%     Arrange.ProbeDepth = [Arrange.ProbeDepth;...
%         round( sqrt( Vector(1,1)^2 +  Vector(1,2)^2 +  Vector(1,3)^2), 1)  ];
%     
%     Arrange.DistanceFromCenter = [Arrange.DistanceFromCenter;...
%         round( sqrt( x(1)^2 +  y(1)^2 ) , 1) ];
%     
    
    %Move the Targets and scale the vectors again. 
    Nz = Nz/10/3.5;
    x = x/Nz + AllCenters(targetTum ,1)*radiusSrt;   
    y = y/Nz + AllCenters(targetTum ,2)*radiusSrt;     
    z = z/Nz-20;
    %%%
    plot3( x,y,z  ,'.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', 'r' )

    textadd.x = 5*x(1)/abs(x(1)+.0001) ;
    textadd.y = 5*y(1)/abs(y(1)+.0001) ; 
    textadd.z = 2*z(1)/abs(z(1)+.0001) ; 
    text(  x(1)+ textadd.x  , y(1) + textadd.y , z(1) + textadd.z, ...
    join([ num2str( round(psiAngle ,0) ), char(176),...
    ",", num2str( round(thetaAngle ,0) ), char(176) ]),'FontSize', 8)
    hold on;
    
    %Plot the vectors
    Vector = Vector/Nz;
    quiver3( x,y,z , Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
         0, 'Color', 'black' , 'LineWidth', 2 )
    grid on;
end



slct  = 1; 
for i = 1:length(angles)
    
    plot3( Target.x(i) , Target.y(i), Target.z(i), '+', 'Color', 'k'  ,'LineWidth', 3, 'MarkerSize', 14)
    hold on
    
    slct = slct +1;
    if slct >= length(angles)/2
        slct = 1;
    end 
end 



VectorData.Vectors = [VectorData.Vectors; Vector   ];
VectorData.Coordinates = [VectorData.Coordinates; x,y,z ];



%----------------------------------------------------------------------------------------%
BoundaryPoints.og = readtable(fileName);
BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:));
idx = 2 : 1 : 15*4 ;
%idx = [2, 10, 20, 30, 40, 15*4];

VectorsALL = zeros( 1000, length(idx)*3);
%get the vectorData
%-----------------------------------------------%Vector
t = linspace(0, 1 ,100);
e1 = (VectorData.Vectors(1, :)'*t)' +...
     [VectorData.Coordinates(1,1) , VectorData.Coordinates(1,2), VectorData.Coordinates(1,3)] ;
vecplot1 = plot3(e1(:,1),e1(:,2),e1(:,3), 'LineWidth', 10,'Color', 'r');
%
hold on
e2 = (VectorData.Vectors( 3, :)'*t)' +...
     [VectorData.Coordinates(3,1) , VectorData.Coordinates(3,2), VectorData.Coordinates(3,3)] ;
vecplot2 = plot3(e2(:,1),e2(:,2),e2(:,3), 'LineWidth', 10,'Color', 'r');



start = length(idx)-1; 
 for j = start:length(idx)-1
     
    
        itime = idx(j);
        X = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 1) );
        X(X == 0) = [];
        Y = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 2) );
        Y(Y == 0) = [];
        Z = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 3) );
        Z(Z == 0) = [];
        Y = Y;   
        BoundaryPoints.new = [X,Y,Z];
        [ BoundaryPoints.new ] = UpsampleAblationMidpoint( BoundaryPoints.new  ); 
        %[ BoundaryPoints.new ] = UpsampleAblationMidpointEdges( BoundaryPoints.new  ); 
        
    if plotVoxelMask == "TRUE"
            P = [ BoundaryPoints.new(:,1) ,  BoundaryPoints.new(:,2), BoundaryPoints.new(:,3)];
            R = rotx( -90  );
            %R = rotx( 0  );
            C = [R*P']' ; 
            P = C -  mean(C);

            %rotate along the y-axis
            R2 = roty( 0 );
            C = [R2*P']' ; 
            P = C -  mean(C);

            newCenter =  [0 , 0 , 0] - mean(P);
            X2 = P(:,1) + newCenter(1);
            Y2 = P(:,2) + newCenter(2);
            Z2 = P(:,3) + newCenter(3);
            X = X2;
            Y = Y2;
            Z = Z2;
                
            AblAP = [ AblAP     ; X2, Y2 , Z2 ];
            
    end  
    
    
 end   
    
            %----------------------------------------------------------------------------%
            TargetPoints = [X2,Y2,Z2];        
            QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
            %center = [0,0,0];
            %CenterQ = [e1; e2; 0 0 0; 0 0 5; 0 0 -5];
            [ CenterQ ] = ProbeTargetsLineUp(  e1, e2 ) ; 
            
            
            [ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  CenterQ ) ; 
            %
            distancesIn = distances;
            distancesIn(distancesIn > 0) = nan;
            distances(distances >0) = 1;
            distances(distances <0) = -1;        
    
    
    
    if plotVoxelMask == "TRUE"        
        
        if j < length(idx)-1 && j > start
            delete(p1)
            delete(s1) 

            if plotVectors == "TRUE" 
                delete(q)
            end 
        end   
        
        set(gcf,'color','w');                
        %Find the triangulation of the Interogation Boundary Points 
        P = QuerryPointsOG;

        p1 = plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3),...
            '.', 'Color', rgb('Black'), 'MarkerSize', 10)  ;
        hold on 

        s = repmat(.5, length(P(:,1)), 1); 
        s1 = scatter3( P(:,1) , P(:,2) ,P(:,3), s,  distancesIn )   ;       
        colormap jet
        hc=colorbar;
        hc.FontSize = 18;
        caxis([-20 1]);
        title( join(["Probe Placement Atlas",exprmt,...
                newline, "Time =", num2str(j) ]), 'Fontsize', 14 )
        
            axis equal
        hold on
        pause(1)
    end 
    
    
    
    %------------------------------------------------------------------------------------%
    if plotMultiAblation == "TRUE"
            X1 = BoundaryPoints.new(:,1);   Y1 =  BoundaryPoints.new(:,2);
            Z1 = BoundaryPoints.new(:,3);
            [k, vol] = boundary([X1,Y1,Z1], 0 );
            %
            set(gcf,'color','w');
            axis equal;
            title( join(["Probe Placement Atlas",exprmt]), 'Fontsize', 14 )   
            
          
            %USE angleIdx or exprmt
            t1 = trisurf(k, X1, Y1 , Z1 ,'Facecolor', colorAblation(exprmt,:)  ,'FaceAlpha', .05 ,...
                'EdgeColor', 'none' );
            %Plot the next
            %p1 = plot3( X2, Y2 , Z2 , '.', 'Color', 'k', 'MarkerSize', 5); 
            %plot the direction of growth of the ablation volume
            p2 = plot3( X1, Y1 , Z1  , '.', 'Color', 'k', 'MarkerSize', 3);
            
            if plotVectors == "TRUE" 
                hold on
                q = quiver3( X1, Y1 , Z1 , VectorsBnd(:,1)  ,VectorsBnd(:,2), VectorsBnd(:,3),...
                             'LineWidth', 1.5);
                         
                %// Compute the magnitude of the vectors
                mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
                            reshape(q.WData, numel(q.UData), [])).^2, 2));
                        
                %// Get the current colormap
                currentColormap = colormap(jet);

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
            
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            view( -40 ,20)
            xlim([-30, 30])
            ylim([-30, 30])
            zlim([-40, 40])  
            
            ptsMulti = [ X2, Y2 , Z2]; 
            a = (exprmt-1)*3 + 1;
            b = (exprmt-1)*3 + 3;
            AblAP_All_Multi( 1:length(ptsMulti), a:b  ) =  ptsMulti ;
            
            %%--------------------------------------------------%create a frame
            Frame = getframe(gcf) ;                
            %writeVideo(writerObj,Frame)  
           
            pause(.1)
           
        %delete Previous Plots
                   
            if j < length(idx)-1
                
                delete(p2)
                delete(t1) 
                
                if plotVectors == "TRUE" 
                    delete(q)
                end 
            end       
    end 
    
    

  
% delete(vecplot1)
% delete(vecplot2)
 end 
    


end           
end  


% x = P(:,1);
% y = P(:,2);
% z =P(:,3);
% intensity = distances;
% C = unique(z) ; 
% dimensionx = dimension;
% dimensiony = dimension;
% dimensionz = dimension; 
% 
% I = StructuredPointcloud2Image( intensity, dimensionx, dimensiony, dimensionz );  

%close(writerObj);      
