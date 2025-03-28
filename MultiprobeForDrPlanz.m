% Specify the user inputs
Rmag= 10;   % Sphere radius
radius = 3; % circle radius



psi = 30*pi/180;    % yaw rotation angle
theta = -45*pi/180; % pitch rotation angle (negative rotation is up)
% Define vectors and Calculate the YAW-PITCH transformation matrix
alpha = asin(radius/Rmag);  
YAW = [cos(psi), -sin(psi), 0; sin(psi), cos(psi), 0; 0, 0, 1]; % Planar YAW rotation
PITCH = [cos(theta), 0, sin(theta); 0,1,0; -sin(theta), 0, cos(theta)]; % Planar PITCH rotation
YP = YAW*PITCH; % YAW-PITCH rotation matrix
% Rc = Column Vector pointing to circle on X-Axis (start point)
Rc = [Rmag*cos(alpha); 0; radius];  
R = YP*[Rmag; 0; 0]; % Vector pointing to Circle center 
% Now sweep the Rc vector around the X-axis to generate the circle 
% This is done by adding a planar ROLL rotation to YP
clear C
C = [];  % C is the vector containing the circle X-Y-Z cordinates
for phi = 0:pi/50:2*pi
    ROLL = [1, 0, 0;  0, cos(phi), -sin(phi); 0, sin(phi), cos(phi) ]; 
    YPR = YP*ROLL;  % 3-dimentional transform
    Rnew = YPR*Rc;
    C = [C, Rnew];
end
% plot the result
[Sx,Sy,Sz]=sphere(50);
figure;
% mesh(Rmag.*Sx, Rmag.*Sy, Rmag.*Sz);  % draw the sphere
hold on;
plot3([0, R(1)], [0, R(2)], [0,R(3)], 'r'); % Vector to Circle center
hold on 
plot3(C(1,:), C(2,:),C(3,:), 'b'); % Circle 
axis equal
hold off
%%
%Random Selection of points 
% pick plenty of random points
x = -1 + (1+1)*rand(1,500); %x-coordinate of a point
y = -0.6 + (0.6+0.6)*rand(1,500); %y-coordinate of a point
z = -0.8 + (1.2+0.8)*rand(1,500); %z-coordinate of a point
%function defining a heart
F1=(((x.^2) + (9/4).*(y.^2) + z.^2-1).^3+(-x.^2 .* z.^3 -(9/80).*y.^2.*z.^3));
ind = F1<0;                   % index for points inside the isosurface
x = x(ind);  x = x(1:100);    % pick 100 of those points
y = y(ind);  y = y(1:100);
z = z(ind);  z = z(1:100);
scatter3(x, y, z, 'MarkerFaceColor','b','MarkerEdgeColor','b');
hold off

%%
names = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1007_Vanderbilt_Slicer\1007_Vanderbilt_Slicer\1007 cropped.nii.gz";
tool = niftiinfo(names) ;
%
clear
close all

figure()


grayColor = [.7 .7 .7];
% plotColor  = rgb("LightBlue");
plotColor = [211 , 255 , 207 ]./256 ;


%stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1007_Vanderbilt_Slicer\1007_Vanderbilt_Slicer\Segmentation_Liver.stl");
stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Liver Mesh.stl");
LiverMeshpoints = stlData.Points;
LiverCenter = mean(LiverMeshpoints,1) ;
trimesh(stlData,'FaceColor','none','EdgeColor',rgb("Brown"),'EdgeAlpha', .10 )
% plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3),.1 ,'.k' )
title(join(['Surgical Plan Example']), 'FontSize', 14)
%axis square;
hold on

%HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1007_Vanderbilt_Slicer\1007_Vanderbilt_Slicer\Segmentation_hepatic.stl");
HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_hepatic.stl");
VasculatureMeshData.HepaticVeinPoints = HepaticVeinData.Points; 
trimesh(HepaticVeinData,'FaceColor','none','EdgeColor', rgb("Navy") ,'EdgeAlpha', .85 )



%PortalVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1007_Vanderbilt_Slicer\1007_Vanderbilt_Slicer\Segmentation_portal.stl" );
PortalVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_portal.stl");
VasculatureMeshData.PortalVeinPoints = PortalVeinData.Points; 
trimesh(PortalVeinData,'FaceColor','none','EdgeColor',rgb("DarkRed") ,'EdgeAlpha', .85 )



tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Vanderbilt_017_Tumor_remeshed_60pReduced.stl";
TumorData = stlread(tumorfile);
TumorPoints.Points = TumorData.Points;
VasculatureMeshData.TumorData = TumorPoints.Points; 
 
trueCenter = [221, 270, 182];
TumorPoints.Points  = rotateZalongPoint(TumorPoints.Points , 90 , trueCenter ) ; 
TumorPoints.PointsOG = TumorPoints.Points; 
TumorPoints.centerOne = mean(TumorPoints.Points);

TumorMeshBin = "TRUE"; 
% TumorData = delaunayTriangulation( TumorPoints.Points(:,1)  , TumorPoints.Points(:,2)...
%                           , TumorPoints.Points(:,3));
% 
% tetramesh(TumorData,'FaceColor','none','EdgeColor', TumorColors(i,:) ,'EdgeAlpha', .5 )




VasculatureMeshData.AllPoints = [VasculatureMeshData.HepaticVeinPoints ;...
    VasculatureMeshData.PortalVeinPoints];

%Plot the tumors

%%Create the tumor
set(gcf,'color',plotColor );
set(gca,'color',plotColor );
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
axis vis3d equal;
axis off
grid off
hold on
view(-80,20)

%Add the tumors and the probe placement strategies   rgb("Fuchsia")
TumorCenterTrue = [];
for i = 2:5

    
TumorColors = [ rgb("RosyBrown"); rgb("Moccasin"); rgb("Goldenrod"); rgb("Fuchsia");...
    rgb("Green")  ] ;

% TumorColors = [ rgb("RosyBrown"); rgb("Moccasin"); rgb("Moccasin"); rgb("Moccasin");...
%    rgb("Moccasin")  ] ;

% offset = [ -35, +25, -15; ... 
%     -20, -25, -15;...
%     %Ablation for tumor
%     -20, -25, -15;...
%     40, 0, 10; ...
%     80, -20, 20];

%Ablation for tumor
offset =  [ 221, 270, 182; ... 
            190, 250, 198;...   
            175, 210, 165;...
            235, 185, 170 ; ...
            275, 185, 190];

if TumorMeshBin == "FALSE"
    
    %3rd value is Ablation for tumor
    radius = [5, 6.5, 7.5, 8 ];


    [tumor.x1, tumor.y1,  tumor.z1] = sphere(25);
    r = radius(i)*sqrt(2);

    tumor.x1 = tumor.x1(:)*r + LiverCenter(1)+offset(i,1);
    tumor.y1 = tumor.y1(:)*r + LiverCenter(2)+offset(i,2);
    tumor.z1 = tumor.z1(:)*r + LiverCenter(3)+offset(i,3);
    P = [tumor.x1 tumor.y1 tumor.z1];

    TumorCenterTrue = [TumorCenterTrue; (LiverCenter(1)+offset(i,1)-313)/1.22 ...
        (LiverCenter(2)+offset(i,2)-332)/1.22 , (LiverCenter(3)+offset(i,3)-268)/1.22 ];

    faceAlpha = [.1, .1, .1 ,1, 1];
    faceAlpha(i) 
    [tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
        = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
    set( tumorNew.p1 , 'FaceColor', TumorColors(i,:) ,'FaceAlpha', faceAlpha(i) , 'EdgeColor', TumorColors(i,:),'EdgeAlpha',  faceAlpha(i)  );

    
elseif TumorMeshBin == "TRUE"
    
    
    TumorPoints.Points = TumorPoints.PointsOG + (offset(i,:)  -  [221, 270, 182]) ;
    
    TumorData = delaunayTriangulation( TumorPoints.Points(:,1)  , TumorPoints.Points(:,2)...
                              , TumorPoints.Points(:,3));
    tetramesh(TumorData,'FaceColor','none','EdgeColor', TumorColors(i,:) ,'EdgeAlpha', 1 )
    
    
end 





NumTargets = linspace(0, 2*pi, 10 + 1 );
%psi, theta
% psiAngle = [0 , 25, 320, 339];
% thetaAngle = [270 , 270, 50, 68];
psiAngle = [0 , 25, 300, 339];
thetaAngle = [320 , 300, 70, 68];
 
AngleSpacing = 15 ;
TargetCentr = TumorPoints.centerOne;
%Radius is the targeting radius of the placement strategy
radiusSrt = 1 ; 
%Safety margin is how far away the probe should be from the vasculature
safetyMargin = 5;

% if i < 3
%     [Arrange ] = CreatePlacementStrategy(NumTargets , psiAngle(i) , thetaAngle(i),...
%         AngleSpacing,  TargetCentr , radiusSrt, VasculatureMeshData.AllPoints, safetyMargin)
% end 


pause(1)
end 


% [process] = addAtlasToPlacementStrategy( 1 , TargetCentr );
% xlabel('X', 'FontSize', 14);
% ylabel('Y', 'FontSize', 14);
% zlabel('Z', 'FontSize', 14);

%%
figure()
[ Arrange.k , Arrange.dist] = dsearchn(VasculatureMeshData.AllPoints , Arrange.points2  );  


plot3( VasculatureMeshData.AllPoints(:,1), VasculatureMeshData.AllPoints(:,2),...
    VasculatureMeshData.AllPoints(:,3), '.b')
hold on
plot3( Arrange.points2(:,1), Arrange.points2(:,2), Arrange.points2(:,3), '.g')
plot3( VasculatureMeshData.AllPoints(Arrange.k, 1) , ...
    VasculatureMeshData.AllPoints(Arrange.k, 2), ...
    VasculatureMeshData.AllPoints(Arrange.k, 3), '.r','MarkerSize', 20  )

set(gcf,'color',plotColor );
set(gca,'color',plotColor );
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
axis vis3d equal;

Arrange.ProbePass = Arrange.dist ; 
Arrange.ProbePass ( Arrange.ProbePass > 5 ) = -1; 

%%
%Create an atlas


figure()
radiusSrt = 7*sqrt(2);

%Angles Determine the number of potential target you want to model
angles = linspace(0, 2*pi, 1 + 1);

%
% psiAngleArr =  linspace(0 , 360, 16 + 1)-radiusSrt;
% thetaAngleArr = linspace(0, 360, 17 + 1);

psiAngleArr =  linspace(0 , 360, 4 + 1)-radiusSrt;
thetaAngleArr = linspace(0, 360, 4 + 1);



AllAngles = [ [repmat(0, 1, length(psiAngleArr) ) ; psiAngleArr ],   ...
[ thetaAngleArr ; repmat(80, 1, length(thetaAngleArr) ) ] ]';


for angleIdx = 1:length(AllAngles)-1

    
    
  
        
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


spacing = 1;
colorNew = hsv(spacing);
TargetColor = lines(length(angles));



radiusSrt = 7*sqrt(2);
ProbeAngleSpacing = radiusSrt*.46 ; 
plot3(0, 0, 0, '.r', 'MarkerSize', 20);
hold on


CenterX = 0;
CenterY = 0;

Target.x = [radiusSrt * cos(angles) + CenterX]' *0;
Target.y = [radiusSrt * sin(angles) + CenterY]' *0;
Target.z = [repmat(0, 1, length(angles) )]' *0;

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
    Vector = [];
    radius = radiusSrt + ProbeAngleSpacing*(i-1);
    CenterX = 0;
    CenterY = 0;
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

    textadd.x = 5*x(1)/abs(x(1)+.0001) ;
    textadd.y = 5*y(1)/abs(y(1)+.0001) ; 
    textadd.z = 2*z(1)/abs(z(1)+.0001) ; 
    
    text(  x(1)+ textadd.x  , y(1) + textadd.y , z(1) + textadd.z, ...
    join([ num2str( round(AllAngles(angleIdx, 1 ),0) ), char(176),...
    ",", num2str( round(AllAngles(angleIdx, 2 ),0) ), char(176) ]),'FontSize', 8)



    hold on;
    quiver3(x, y, z, Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
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
tumor.z1 = tumor.z1(:)*r;
P = [tumor.x1 tumor.y1 tumor.z1];

[tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
    = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
set( tumorNew.p1 , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );


set(gcf,'color','w');
axis equal;
% grid off
% axis off
% xlabel('X', 'FontSize', 14);
% ylabel('Y', 'FontSize', 14);
% zlabel('Z', 'FontSize', 14);
title("Probe Placement Atlas",'FontSize', 30)
pause(.05)

end 
view(-80,20)
grid off



%%

clear
    
%Angles Determine the number of potential target you want to model
angles = linspace(0, 2*pi, 5);

%
psiAngleArr =  linspace(0 , 360, 2);
thetaAngleArr = linspace(0, 360, 2);

AllAngles = [ [repmat(0, 1, length(psiAngleArr) ) ; psiAngleArr ],    ...
    [thetaAngleArr;  repmat( psiAngleArr(end) , 1, length(thetaAngleArr) ) ] ]';

%
for angleIdx = 1:length(AllAngles)

    
    
  
        
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


spacing = 15;
colorNew = hsv(spacing);
TargetColor = lines(length(angles));



radiusSrt = 7*sqrt(2);
ProbeAngleSpacing = radiusSrt*.46 ; 
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
%

Arrange.VectorAngles = [];
Arrange.VectorAnglesX = [];
Arrange.VectorAnglesY = [];
Arrange.VectorAnglesZ = [];
Arrange.ProbeDepth =[];
Arrange.DistanceFromCenter=  [];


spaceEnd = spacing;

for i = 1:spaceEnd
    Vector = [];
    radius = radiusSrt + ProbeAngleSpacing*(i-1);
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
    quiver3(x, y, z, Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
         0, 'Color', colorNew(i, : ), 'LineWidth', 2 )

    grid on;
    

    %Create vectors along the points
%     quiver3( 0 , 0  , 0,   x,  z ,  y  ,  'linewidth', 2) 
    
end



%Print the angle of the rest of the probes
CenterX = 0;
CenterY = 0;

Target.OGx = [radiusSrt * cos(angles) + CenterX]';
Target.OGy = [radiusSrt * sin(angles) + CenterY]';
Target.OGz = [repmat(0, 1, length(angles) )]';
for i = 1:spaceEnd
    
    radius = radiusSrt + radiusSrt*.46*(i-1);
    CenterX = 0;
    CenterY = 0;
    x = [radius * cos(angles) + CenterX]';
    y = [radius * sin(angles) + CenterY]';
    z = [repmat(50, 1, length(angles) )]';
    
    Vector = ( [Target.OGx, Target.OGy, Target.OGz] - [x, y, z]  );
    
    CenterVector = ( [CenterX, CenterY , Target.OGz(1)] - [0, 0, 0]  );    
    
    %Find the angle of the center point to the X-axis
    Arrange.VectorAnglesCenter = ...
        abs( round( rad2deg(atan2( sqrt(CenterVector(1, 1 )^2 + CenterVector(1, 2 )^2),...
        CenterVector(1, 3) ) ), 2) ) ;
    
    %  ax = atan2(sqrt(y^2+z^2),x);
    Arrange.VectorAnglesX =[Arrange.VectorAnglesX ; ...
        abs( round( rad2deg(atan2(sqrt(Vector(1, 2 )^2 + ...
        Vector(1, 3 )^2), Vector(1, 1) ) ), 2) )-90  ];
    
    Arrange.VectorAnglesY =[ Arrange.VectorAnglesY; ...
        abs( round( rad2deg(atan2(sqrt(Vector(1, 1 )^2 + ...
        Vector(1, 3 )^2), Vector(1, 2) ) ), 2) ) -90 ];
    
    Arrange.VectorAnglesZ =[Arrange.VectorAnglesZ; ...
        abs( round( rad2deg(atan2(sqrt(Vector(1, 1 )^2 + ...
        Vector(1, 2 )^2), Vector(1, 3) ) ) , 2) ) - 90 ];
%         round( acos( ( Target.y - y))/norm( Vector), 0) ];

    
    %Rotate the points
    Rc = [x,y,z]';
    C = [YP*Rc]' ; 
    
    x = C(:,1);
    y = C(:,2);
    z = C(:,3);
    
    text(  x(1)*1.025, y(1)*1.025 , z(1)*1.025, ...
    join([ num2str( round(Arrange.VectorAnglesX(i),0) ), char(176) ]),'FontSize', 12)
end 
% plot3(0 , -7, 0, 'k+', 'LineWidth', 3, 'MarkerSize', 14);
% plot3(0 , 7, 0, 'k+', 'LineWidth', 3, 'MarkerSize', 14);
% plot3(7 , 0, 0, 'k+', 'LineWidth', 3, 'MarkerSize', 14);
% plot3(-7 , 0, 0, 'k+', 'LineWidth', 3, 'MarkerSize', 14);

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
tumor.z1 = tumor.z1(:)*r;
P = [tumor.x1 tumor.y1 tumor.z1];

[tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
    = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
set( tumorNew.p1 , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );


set(gcf,'color','w');
axis equal;
grid off
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
title("Probe Placement Phantom Strategy",'FontSize', 30)

hold off
pause(.05)

    
end 

%%

%find the best angle calculation 
% 
% Arrange.maxAngle = max(max( mod( [ Arrange.VectorAnglesX(end), ...
%     Arrange.VectorAnglesY(end), Arrange.VectorAnglesZ(end)], 90)  ));
% 
% if (Arrange.VectorAnglesX(end)) >= Arrange.maxAngle  && abs(Arrange.VectorAnglesX(1)) == 0
%     Arrange.VectorAngles = Arrange.VectorAnglesX;
% 
% elseif (Arrange.VectorAnglesY(end)) >= Arrange.maxAngle && abs(Arrange.VectorAnglesY(1)) == 0
%     Arrange.VectorAngles = Arrange.VectorAnglesY;
% 
% elseif  (Arrange.VectorAnglesZ(end)) >= Arrange.maxAngle  && abs(Arrange.VectorAnglesZ(1)) == 0
%         Arrange.VectorAngles = Arrange.VectorAnglesZ;
% else 
%     Arrange.VectorAngles = Arrange.VectorAnglesZ;
% end 
% %The first placement is always going to be parallel to the target so the
% %angle should be 0. knowing this you can adjust the remaining angles.
% Arrange.parallel = Arrange.VectorAngles(1);
% Arrange.VectorAngles = abs( Arrange.VectorAngles - Arrange.parallel  );

% if thetaAngle > 120 && thetaAngle < 190
%     Arrange.VectorAngles(2:end) = abs( Arrange.VectorAngles(2:end) + Arrange.parallel*2);
%     disp("Compensated")
% end 





%%
clear
close all

figure(1)
plotLiver = "TRUE";

grayColor = [.7 .7 .7];
plotColor  = rgb("Gray");

stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\Patient_009_Vanderbilt\Segmentation_liver and vena cava smooth.stl");
LiverMeshpoints = stlData.Points;
LiverCenter = mean(LiverMeshpoints,1) ;

if plotLiver == "TRUE"
    trimesh(stlData,'FaceColor','none','EdgeColor',rgb("Sienna"),'EdgeAlpha', .10 )
    % plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3),.1 ,'.k' )
    title(join(['Surgical Plan Example']), 'FontSize', 14)
    %axis square;
    hold on
end 
HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\Patient_009_Vanderbilt\Segmentation_hepatic.stl");
VasculatureMeshData.HepaticVeinPoints = HepaticVeinData.Points; 
if plotLiver == "TRUE"
    trimesh(HepaticVeinData,'FaceColor','none','EdgeColor','b','EdgeAlpha', .5 )
end 



PortalVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\Patient_009_Vanderbilt\Segmentation_portal.stl");
VasculatureMeshData.PortalVeinPoints = PortalVeinData.Points; 
if plotLiver == "TRUE"
    trimesh(PortalVeinData,'FaceColor','none','EdgeColor','r','EdgeAlpha', .5 )
end 


VasculatureMeshData.AllPoints = [VasculatureMeshData.HepaticVeinPoints ;...
    VasculatureMeshData.PortalVeinPoints];



%
set(gcf,'color',plotColor );
set(gca,'color',plotColor );
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
axis vis3d equal;
axis off
grid off
hold on
 view(-250,20)
 
 
%%Create the tumor
ProbeNum = 2;
TumorNum = 2;

% TumorColors = [ rgb("Tan"); rgb("SlateGray"); rgb("Salmon"); rgb("Fuchsia")  ] ;
TumorColors = [ rgb("Tan"); rgb("Peru"); rgb("Salmon"); rgb("Fuchsia") ];
for i = 1:TumorNum

% X,Y,Z - Split | 1,2,3
    switch i
        case 1
            Split = 3;
            tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\Patient_009_Vanderbilt\Segmentation_Tumor 1 .stl";
        case 2
            Split = 3;
            tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\Patient_009_Vanderbilt\Segmentation_Tumor 2.stl";
    end 
    
    
TumorData = stlread(tumorfile);
VasculatureMeshData.TumorData = TumorData.Points; 
trimesh(TumorData,'FaceColor','none','EdgeColor', TumorColors(i,:) ,'EdgeAlpha', .5 )

%Split the tumor into two sections along the x axis. 
TumorPoints.centerOne = mean(TumorData.Points);
TumorPoints.Lower  = [];
TumorPoints.Upper = [];
TumorPoints.LowerX = [];
TumorPoints.UpperX = [];
TumorPoints.LowerY = [];
TumorPoints.UpperY = [];
TumorPoints.LowerZ = [];
TumorPoints.UpperZ = [];





TumorPoints.idx = kmeans(TumorData.Points, ProbeNum);


figure(2) 

    X = TumorData.Points;
    idx = TumorPoints.idx;
    scatter3(X(:,1), X(:,2), X(:,3), 15, idx, 'filled', 'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);% 3 number of classes
    set(gcf,'color',plotColor );
    set(gca,'color',plotColor );
    xlabel('X', 'FontSize', 14);
    ylabel('Y', 'FontSize', 14);
    zlabel('Z', 'FontSize', 14);
    title("Kmeans Cluster")
    axis vis3d equal;
    axis off
    grid off
    hold on
    view(-250,20)


figure(3) 

    X = TumorData.Points;
    TumorPoints.idxCluster = kmedoids(TumorData.Points, ProbeNum, 'Distance','cityblock');
    idx2 = TumorPoints.idxCluster;
    scatter3(X(:,1), X(:,2), X(:,3), 15, idx2, 'filled', 'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);% 3 number of classes
    set(gcf,'color',plotColor );
    set(gca,'color',plotColor );
    xlabel('X', 'FontSize', 14);
    ylabel('Y', 'FontSize', 14);
    zlabel('Z', 'FontSize', 14);
    title("ClusterAlg Cluster")
    axis vis3d equal;
    axis off
    grid off
    hold on
    view(-250,20)


% TumorPoints.idx = TumorPoints.idxCluster;

figure(1) 

    TumorPoints.LowerIdx = find( TumorPoints.idx ==1) ;
    TumorPoints.Lower = mean( TumorData.Points(TumorPoints.LowerIdx, :) );

    TumorPoints.MiddleIdx = find( TumorPoints.idx ==2) ;
    TumorPoints.Middle = mean( TumorData.Points(TumorPoints.MiddleIdx, :) );

    TumorPoints.UpperIdx = find( TumorPoints.idx == 3) ;
    TumorPoints.Upper = mean( TumorData.Points(TumorPoints.UpperIdx, :) );

    TumorPoints.Upper2Idx = find( TumorPoints.idx == 4) ;
    TumorPoints.Upper2 = mean( TumorData.Points(TumorPoints.Upper2Idx, :) );


if ProbeNum == 2

    for ipts = 1:length(TumorData.Points(:,1))

        scale = std(TumorData.Points) ;  
    %Process X mean
        if TumorData.Points(ipts,1) < TumorPoints.centerOne(1) - scale(1)
           TumorPoints.LowerX = [TumorPoints.LowerX; TumorData.Points(ipts,:) ] ; 

        elseif  TumorData.Points(ipts,1) > TumorPoints.centerOne(1) + scale(1)
           TumorPoints.UpperX = [TumorPoints.UpperX; TumorData.Points(ipts,:) ] ; 
        else 
            successRate.X = "Excluded"; 
        end 

    %Process Y mean
        if TumorData.Points(ipts,2) < TumorPoints.centerOne(2) - scale(2)
           TumorPoints.LowerY = [TumorPoints.LowerY; TumorData.Points(ipts,:) ] ; 

        elseif  TumorData.Points(ipts,2) > TumorPoints.centerOne(2)  + scale(2)
           TumorPoints.UpperY = [TumorPoints.UpperY; TumorData.Points(ipts,:) ] ; 
        else 
           successRate.Y = "Excluded";
        end 

    %Process Z mean    
        if TumorData.Points(ipts,3) < TumorPoints.centerOne(3) -  scale(3)
           TumorPoints.LowerZ = [TumorPoints.LowerZ; TumorData.Points(ipts,:) ] ; 

        elseif TumorData.Points(ipts,3) > TumorPoints.centerOne(3)  + scale(3)
           TumorPoints.UpperZ = [TumorPoints.UpperZ; TumorData.Points(ipts,:) ] ; 
        else 
           successRate.Y = "Excluded";
        end 

    %Process X,Y,Z means      
        TumorPoints.Lower = (mean(TumorPoints.LowerX) +...
                            mean(TumorPoints.LowerY) + mean(TumorPoints.LowerZ))/3 ;
        TumorPoints.Upper = ( mean(TumorPoints.UpperX) +  ...
                            mean(TumorPoints.UpperY) +  mean(TumorPoints.UpperZ))/3 ;
    end 



    %%For Kmeans Algorithm
%     TumorPoints.LowerIdx = find( TumorPoints.idx == 1) ;
%     TumorPoints.Lower = mean( TumorData.Points(TumorPoints.LowerIdx, :) );
% 
%     TumorPoints.UpperIdx = find( TumorPoints.idx == 2) ;
%     TumorPoints.Upper = mean( TumorData.Points(TumorPoints.UpperIdx, :) );


end 

%Create a placement strategy for the two halves of the tumor
for iSplit = 1:ProbeNum
    switch iSplit 
        case 1
            TargetCentr = (TumorPoints.Lower) ; 
             
        case 2 
            TargetCentr = (TumorPoints.Upper) ;
            if ProbeNum ==3 || ProbeNum == 4
                TargetCentr = (TumorPoints.Middle) ;
            end 

        case 3
            TargetCentr = (TumorPoints.Upper) ;

        case 4
            TargetCentr = (TumorPoints.Upper2) ;
    end 

    NumTargets = linspace(0, 2*pi, 1 + 1 );
    %psi, theta
    % psiAngle = [0 , 25, 320, 339];
    % thetaAngle = [270 , 270, 50, 68];
    if ProbeNum == 2
        psiAngle = [15 , 15,  15, 15];
        thetaAngle = [90 , 90, 90, 90];

	elseif ProbeNum == 3
        psiAngle = [15 , 15, 15, -25, -25,  -25];
        thetaAngle = [90 , 90, 90, 90, 90,  90];

	elseif ProbeNum == 4
        psiAngle = [15 , 15, 15, 15,  0, 0, -15,  -15];
        thetaAngle = [90 , 90, 90, 90,  90, 90, 90,  90];
    end  


    AngleSpacing = 1 ;

    %Radius is the targeting radius of the placement strategy
    radiusSrt = 1 ; 
    %Safety margin is how far away the probe should be from the vasculature
    safetyMargin = 5;

    % if i < 3
    iSlct = (i-1)*2 + iSplit;
    psiAngle(iSlct) 
    thetaAngle(iSlct)

        [Arrange ] = CreatePlacementStrategySingle(NumTargets , psiAngle(iSlct) , thetaAngle(iSlct),...
            AngleSpacing,  TargetCentr , radiusSrt, VasculatureMeshData.AllPoints, safetyMargin);
     
    YPAngle = Arrange.YPAngle(end, 1:2);
    YP = YawPitch( YPAngle(1),  0 ); 

    
    %Visualize Ablation Margins
    %3rd value is Ablation for tumor
%     if ProbeNum == 2
%         radius = 35 /2;
%         long_axis = 40 /2;
% 
% 	elseif ProbeNum == 3
%         radius = 30 /2;
%         long_axis = 33 /2 ; 
% 
% 	elseif ProbeNum == 4
%         radius = 30 /2;
%         long_axis = 33 /2; 
%     end 

    radius = 40 /2;
    long_axis = 48 /2; 
%Create an Ellipsoid Tumor    
    [X,Y,Z] = ellipsoid(TargetCentr(1) ,TargetCentr(2) ,TargetCentr(3) ,...
         long_axis ,radius,  long_axis );
    X = reshape(X,[],1);
    Y = reshape(Y,[],1);
    Z = reshape(Z,[],1);
    P = [X,  Y, Z ];
    
    
    C = [YP*P']' ; 
    P = C + TargetCentr - mean(C);

%%Plot the tumors
    faceAlpha = [.1, .1, .1 ,1, 1];
    [ablationNew.p1, ablationPoints.centerOne, ablationPoints.radiiOne, ablationNew.v]...
        = PlotEllispeNew( P(:,1) ,  P(:,2)   ,  P(:,3)  );
    set( ablationNew.p1 , 'FaceColor', 'r' ,'FaceAlpha', faceAlpha(i) , 'EdgeColor', 'r','EdgeAlpha',  faceAlpha(i)  );


    pause(1)
end 

end 

   


