function [process] = addAtlasToPlacementStrategy(radiusSrt, center ) 

% radiusSrt = 7*sqrt(2);

%Angles Determine the number of potential target you want to model
angles = linspace(0, 2*pi, 1 + 1);

%
psiAngleArr =  linspace(0 , 360, 8 + 1)- radiusSrt;
thetaAngleArr = linspace(0, 360, 9 + 1) ;

AllAngles = [ [repmat(0, 1, length(psiAngleArr) ) ; psiAngleArr ],   ...
[ thetaAngleArr ; repmat(80, 1, length(thetaAngleArr) ) ] ]';


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


spacing = 1;
colorNew = hsv(spacing);
TargetColor = lines(length(angles));



% radiusSrt = 7*sqrt(2);
ProbeAngleSpacing = radiusSrt*.46 ; 
plot3(0, 0, 0, '.r', 'MarkerSize', 20);
hold on




Target.x = [radiusSrt * cos(angles) + (center(1)) ]'  ;
Target.y = [radiusSrt * sin(angles) + (center(2)) ]'  ;
Target.z = [repmat(0, 1, length(angles) )+ center(3)  ]'  ;

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
    z = [repmat( 5 , 1, length(angles) ) ]';
    
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


% set(gcf,'color','w');
% axis equal;
% grid off
% axis off
% xlabel('X', 'FontSize', 14);
% ylabel('Y', 'FontSize', 14);
% zlabel('Z', 'FontSize', 14);
% title("Probe Placement Atlas",'FontSize', 30)
pause(.05)

end 
% view(-80,20)
process = ["DONE"];

end 
