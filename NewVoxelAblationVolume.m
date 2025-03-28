






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
plotVectors = "TRUE";
plotVoxelMask = "TRUE";
WriteData = "TRUE";
Upsample = "TRUE" ;

%
%Make a Video
% writerObj = VideoWriter('VoxelField_and Pointcloud_Test_3.avi'); %// initialize the VideoWriter object
% writerObj.FrameRate = 8;
% open(writerObj) ;


radiusSrt = 7*sqrt(2);

%Angles Determine the number of potential target you want to model
angles = linspace(0, 2*pi, 1 + 1);

%
psiAngleArr =  linspace(0 , 360, 16 + 1)-radiusSrt;
thetaAngleArr = linspace(0, 360, 17 + 1);
AllAngles = [ [repmat(0, 1, length(psiAngleArr) ) ; psiAngleArr ],   ...
[ thetaAngleArr ; repmat(80, 1, length(thetaAngleArr) ) ] ]';
%

N = 80;
%AllAngles = [0 + (360-0).* rand(N,1), 0 + (45-0).* rand(N,1) ]; 
% AllAngles =[  repmat(10, N, 1)   , linspace(0, 90, N)',   
%               repmat(40, N, 1)  , linspace(0, 90, N)', 
%               repmat(75, N, 1)  , linspace(0, 90, N)', 
%               repmat(145, N, 1) , linspace(0, 90, N)', 
%               repmat(200, N, 1) , linspace(0, 90, N)', 
%               repmat(245, N, 1) , linspace(0, 90, N)', 
%               repmat(330, N, 1) , linspace(0, 90, N)' ];

AllAngles =[  repmat(0, N, 1) , linspace(0, 75, N)',   
              repmat(45, N, 1) , linspace(0, 75, N)', 
              repmat(90, N, 1) , linspace(0, 75, N)', 
              repmat(180, N, 1) , linspace(0, 75, N)', 
              repmat(225, N, 1) , linspace(0, 75, N)', 
              repmat(270, N, 1) , linspace(0, 75, N)', 
              repmat(315, N, 1) , linspace(0, 75, N)' ];


          
out1 = randperm( length(AllAngles)  ) ;
AllAngles2  = AllAngles(out1,:)  ;
AllAngles = [AllAngles, AllAngles2]; 
%
VectorData.Vectors = [];
VectorData.Coordinates = [];
%
%        
%Either use: exprmt or N for selection
Abl.AP_All_Single = zeros(1000, 3*20);
Abl.AP_All_Multi = zeros(1000, 3*20); 


%---------------------------------------------------------------------------------------%

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


%---------------------------------------------------------------------------------------%

numAll = [];
AllTumorSlct = [1,3; 1,3; 1,3; 1,3; 1,3; 1,3;
                 1,4; 1,4; 1,4; 1,4; 1,4; 1,4]  ;
AllTumorSlct = repmat(AllTumorSlct,70,1) ;
%
numpoints =  2600; 
%
num.All = [];
num.VolumeAll  = []; 


plotColor  = rgb("Gray");
fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxGeomSymmetricModel_Case1.csv";
BoundaryPoints.og = readtable(fileName);






for exprmt = 1:6 %6 %12 or 6
AblAP = [];     

% for targetTum = 1:4
    AllCenters = [1,0,0; 
                  0,1,0; 
                  -1,0,0; 
                  0,-1,0]*.50;
              
            
for cmpr = 1:1
    
    

figure( )



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
disp(fileName)
BoundaryPoints.og = readtable(fileName);
BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:));


idx = 15*4:15*4;
 for j = 1:length(idx)

        itime = idx(j);
        X = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 1) );
        X(X == 0) = [];
        Y = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 2) );
        Y(Y == 0) = [];
        Z = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 3) );
        Z(Z == 0) = [];
        BoundaryPoints.new = [X,Y,Z];
 end 
  
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


spacing = 1;
colorNew = hsv(spacing);
TargetColor = lines(length(angles));



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


spaceEnd = spacing;

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
    Nz = Nz/10/5.5;
    x = x/Nz + AllCenters(targetTum ,1)*radiusSrt;   
    y = y/Nz + AllCenters(targetTum ,2)*radiusSrt;     
    z = z/Nz-20;
    %%%
    plot3( x,y,z  ,'.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', colorNew( i, :) )

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
%
slct  = 1; 
for i = 1:length(angles)
    
    plot3( Target.x(i) , Target.y(i), Target.z(i), '+', 'Color',TargetColor(slct, :)  ,'LineWidth', 3, 'MarkerSize', 14)
    hold on
    
    slct = slct +1;
    if slct >= length(angles)/2
        slct = 1;
    end 
end 



%%Create the tumor
[tumor.x1, tumor.y1,  tumor.z1] = sphere(25);
r = 14*sqrt(2);

tumor.x1 = tumor.x1(:)*r;
tumor.y1 = tumor.y1(:)*r;
tumor.z1 = tumor.z1(:)*r-10;
P = [tumor.x1 tumor.y1 tumor.z1];


% [tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
%     = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );

%set( tumorNew.p1 , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );
%%%


set(gcf,'color','w');
axis equal;

% grid off
% axis off
% xlabel('X', 'FontSize', 14);
% ylabel('Y', 'FontSize', 14);
% zlabel('Z', 'FontSize', 14);
% title("Probe Placement Atlas",'FontSize', 30)
title( join(["Probe Placement Atlas",exprmt]), 'Fontsize', 14 )
pause(.05)    
    end 
    
    if plotMultiAblation == "TRUE"
           
            %rotate along the x-axis
            P = [ BoundaryPoints.new(:,1) ,  BoundaryPoints.new(:,2), BoundaryPoints.new(:,3)];
            R = rotx( -90  );
            %R = rotx( 0  );
            C = [R*P']' ; 
            P = C -  mean(C);
            
            %rotate along the y-axis
            R2 = roty( 0 );
            C = [R2*P']' ; 
            P = C -  mean(C);
            
            %AblationCenter = mean([X,Y,Z]); 
            newCenter =  mean(P) - [0 , 0 , 0] ;
            X2 = P(:,1) + newCenter(1);
            Y2 = P(:,2) + newCenter(2);
            Z2 = P(:,3) + newCenter(3) ;

            [k, vol] = boundary([X2,Y2,Z2], .25 );
            hold on
            %USE angleIdx or exprmt
            trisurf(k, X2, Y2 , Z2 ,'Facecolor', colorAblation(exprmt,:)  ,'FaceAlpha', .15 ,...
                'EdgeColor', 'none' )
            plot3( X2, Y2 , Z2 , '.', 'Color', colorAblation(exprmt,:) )
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            camlight
            view( ViewAdd(exprmt) ,20)
            
            ptsMulti = [ X2, Y2 , Z2]; 
            
            a = (exprmt-1)*3 + 1;
            b = (exprmt-1)*3 + 3;
            AblAP_All_Multi( 1:length(ptsMulti), a:b  ) =  ptsMulti ;
            pause(.1)
    end 
    
    xlim([-30, 30])
    ylim([-30, 30])
    zlim([-40, 40])
    
                %AblationCenter = mean([X,Y,Z]);  
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
    %------------------------------------------------------------------------------------%

    TargetPoints = [X2,Y2,Z2];        QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
    center = [0,0,0];
    [ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  center ) ; 
    
    distancesIn = distances;
    distancesIn(distancesIn > 0) = nan;
    
    distances(distances >0) = 1;
    distances(distances <0) = -1;


        
end

    if plotAblation == "TRUE"
        
        figure(2)
        subplot (2 , 3, exprmt  )   
        set(gcf,'color','w');                
        %Find the triangulation of the Interogation Boundary Points 
        P = QuerryPointsOG;

        plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3), '.', 'Color', rgb('Black'),...
            'MarkerSize', 10)  
        hold on 

        s = repmat(.5, length(P(:,1)), 1); 
        scatter3( P(:,1) , P(:,2) ,P(:,3), s,  distancesIn )          
        colormap jet
        hc=colorbar;
        hc.FontSize = 18;
        %         title(hc,'mm', 'FontSize', 20);
        title( 'SDA_{T-A}', 'Fontsize', 20)
        C=caxis;
        axis equal
        hold on
    
    end 
    
               
intensity = distances;
C = unique(z) ; 
dimensionx = dimension;
dimensiony = dimension;
dimensionz = dimension; 

I = StructuredPointcloud2Image( intensity, dimensionx, dimensiony, dimensionz );   


end            
















