%Angles Determine the number of potential target you want to model

%All Modifiable VArables 
function [Arrange ] = CreatePlacementStrategy(angles, psiAngleArr, ...
    thetaAngleArr, spacing, TargetCentr, radiusSrt, VesselData, safetyMargin )



% angles = NumTargets;    psiAngleArr = psiAngle(iSlct);     thetaAngleArr = thetaAngle(iSlct); 
% spacing = AngleSpacing;         TargetCentr = TargetCentr;     radiusSrt = radiusSrt;
% VesselData = VasculatureMeshData.AllPoints; safetyMargin = safetyMargin;
    

% NumTargets = linspace(0, 2*pi, 3 +1 );
% psiAngleArr =  30 ; 
% thetaAngleArr = 30;
% AngleSpacing = 3;
% TargetCentr = [0, 0, 0];

%Angles Determine the number of potential target you want to model
% angles = linspace(0, 2*pi, 5);


AllAngles = [psiAngleArr, thetaAngleArr];

    
  
        
psiAngle = AllAngles(1, 1 ); %rad2deg( 30*pi/180 ) ;
psi = deg2rad( psiAngle);    % yaw rotation angle

thetaAngle = AllAngles(1, 2 );  %rad2deg( -45*pi/180) ;
theta = deg2rad( thetaAngle ); % pitch rotation angle (negative rotation is up)


% Define vectors and Calculate the YAW-PITCH transformation matrix
YAW = [cos(psi), -sin(psi), 0; sin(psi), cos(psi), 0; 0, 0, 1]; % Planar YAW rotation
PITCH = [cos(theta), 0, sin(theta); 0,1,0; -sin(theta), 0, cos(theta)]; % Planar PITCH rotation
YP = YAW*PITCH; % YAW-PITCH rotation matrix
% Rc = Column Vector pointing to circle on X-Axis (start point)
% Now sweep the Rc vector around the X-axis to generate the circle 
% This is done by adding a planar ROLL rotation to YP


% spacing = 15;
colorNew = hsv(spacing);
TargetColor = lines(length(angles));



ProbeAngleSpacing = radiusSrt  + 2; 
% plot3(0, 0, 0, '.r', 'MarkerSize', 20);
% hold on


% CenterX = 20;
% CenterY = 20;
CenterX = TargetCentr(1);
CenterY =  TargetCentr(2);
CenterZ =  TargetCentr(3);

Target.x = [radiusSrt * cos(angles) ]';
Target.y = [radiusSrt * sin(angles) ]';
Target.z = [repmat(0, 1, length(angles) )]';

%Rotate the targets

Rc = [Target.x  ,Target.y  ,Target.z ]';
C = [YP*Rc]' ; 

Target.x  = C(:,1) + CenterX;
Target.y = C(:,2) + CenterY;
Target.z = C(:,3) + CenterZ;

clear C
%

Arrange.VectorAngles = [];
Arrange.VectorAnglesX = [];
Arrange.VectorAnglesY = [];
Arrange.VectorAnglesZ = [];
Arrange.ProbeDepth =[];
Arrange.DistanceFromCenter=  [];
Arrange.YP = [];
Arrange.YPAngle = [];
Arrange.Call = []; 


spaceEnd = spacing;

for i = 1:spaceEnd
    Vector = [];
    radius = radiusSrt + ProbeAngleSpacing*(i-1);
    x = [radius * cos(angles) ]';
    y = [radius * sin(angles) ]';
    z = [repmat(70 , 1, length(angles) )]';
    
    
    %Rotate the Placement points
    Rc = [x,y,z]';
    C = [YP*Rc]' ; 

    

    
    x = C(:,1)+ CenterX;
    y = C(:,2) + CenterY;
    z = C(:,3) + CenterZ;
    %
    
    %Check if the probe is close to a vessel
%     zprobecheck = [4:100]; 
    zprobecheck = [80:-2:4]; 
%     x2 = [radius * cos(angles) ]';
%     y2 = [radius * sin(angles) ]';
    Arrange.PassCount= [];
    
    for pc = 1:length(zprobecheck)
        %radius = radiusSrt + ProbeAngleSpacing*(i-1);
        x2 = [radius * cos(angles) ]' ;
        y2 = [radius * sin(angles) ]' ;
        %disp(":Length x2")
        %disp(length(x2))
        if length(x2) > 0

            z2 = [ repmat( zprobecheck(pc) , 1, length(x2) )]';
            
            %FIX FIX FIX :  MAKE SURE TO SAMPLE POINTS ALONG THE TRAGECTORY
            %radius = radiusSrt + ProbeAngleSpacing*(i-1);
            %radiusNew = radiusSrt + ProbeAngleSpacing*(i-1)*.1*sqrt(zprobecheck(pc)/2);
            radiusNew = radiusSrt + ProbeAngleSpacing*(i-1)*.0287*(zprobecheck(pc))/2;
            x2 = [radiusNew * cos(angles) ]' ;
            y2 = [radiusNew * sin(angles) ]' ;

            
            
            Rc2 = [x2, y2, z2]';
            C2 = [YP*Rc2]' ; 

            x2 = C2(:,1)+ CenterX;
            y2 = C2(:,2) + CenterY;
            z2 = C2(:,3) + CenterZ;
            
            %Only check the paths that clear the margin after the first
            %iteration
            if pc > 1
                if isempty(Arrange.PassCount)
%                     Arrange.PassCount = 1;
                    disp("ALL FAILED")
                    break 
                end 
                x2 = x2(Arrange.PassCount);
                y2 = y2(Arrange.PassCount);
                z2 = z2(Arrange.PassCount);
            end
            %FIX FIX FIX :  PLOT THE SAMPLE POINTS
%             plot3(x2 , y2, z2, '.b' ) 
            


            Arrange.points2 = [x2, y2, z2];
            
            [Arrange.k, Arrange.dist] = dsearchn( VesselData , Arrange.points2);
%             disp(Arrange.k)
%             disp(Arrange.dist)

            Arrange.ProbePass = round( Arrange.dist, 2) ; 
            
%             Arrange.ProbePass2 = Arrange.ProbePass;
            Arrange.ProbePass( Arrange.ProbePass < safetyMargin ) = -10; 
            
%             %A(A(:) > 0  & A(:) <= 2) = -1
%             %%UNCOMMENT IF YOU WANT TO SEE DIFFERENT PROBE SAFETY MARGINS 
%             Arrange.ProbePass2( Arrange.ProbePass2(:) >= 0  &  Arrange.ProbePass2(:) <= 2) = -1;
%             Arrange.ProbePass2( Arrange.ProbePass2(:) > 0  &  Arrange.ProbePass2(:) <= 4) = -2;
%             Arrange.ProbePass2( Arrange.ProbePass2(:) > 0  &  Arrange.ProbePass2(:) <= 6) = -3;
%             Arrange.ProbePass2( Arrange.ProbePass2(:) > 0  &  Arrange.ProbePass2(:) <= 8) = -4;
%             Arrange.ProbePass2( Arrange.ProbePass2(:) > 0  &  Arrange.ProbePass2(:) <= 10) = -5;
%             %

            Vector = ( [Target.x, Target.y, Target.z] - [x, y, z]  );

            CenterVector = ( [CenterX, CenterY , Target.z(1)] - [0, 0, 0]  );

            Arrange.ProbeDepth = [Arrange.ProbeDepth;...
                round( sqrt( Vector(1,1)^2 +  Vector(1,2)^2 +  Vector(1,3)^2), 1)  ];

            Arrange.DistanceFromCenter = [Arrange.DistanceFromCenter;...
                round( sqrt( x(1)^2 +  y(1)^2 ) , 1) ];



            hold on;
            
            %Clear the Passcount before the next iteration
            Arrange.PassCount = [];
            
%             disp(length(Arrange.ProbePass))
%             disp(length(Arrange.points2))
%             disp(length( Arrange.dist ))
            
            for k = 1:length(Arrange.ProbePass)
%                 disp(k)

            %%UNCOMMENT IF YOU WANT TO SPECIFY PROBE SAFETY MARGIN

                if Arrange.ProbePass(k) > 0 
                    
                    Arrange.PassCount= [Arrange.PassCount,k ];  
                    
%                     plot3(x(k) , y(k) , z(k) , '.', 'LineWidth', 1, 'MarkerSize', 10, 'Color',  'black' )
                    q1 = quiver3(x(k) , y(k) , z(k) , Vector(k,1) , Vector(k,2) , Vector(k,3) , ...
                         0, 'Color',  'k' , 'LineWidth', 1 );
                         
                    if zprobecheck(pc) < 8
                        %colorNew(i, : )
%                         delete(q1)
                        plot3(x(k) , y(k) , z(k) , '.', 'LineWidth', 2, 'MarkerSize', 20, 'Color',  rgb('Lime') )
                        quiver3(x(k) , y(k) , z(k) , Vector(k,1) , Vector(k,2) , Vector(k,3) , ...
                             0, 'Color',  rgb('Black'), 'LineWidth', 5 )
                         
%                          disp("SUCCESS")
                         Arrange.YP = [Arrange.YP ; YP];
                         
                    end 
                end
                %Goal: Retrieve the successful angles
                Arrange.YPAngle = [Arrange.YPAngle  ; psiAngle, thetaAngle];     

                if Arrange.ProbePass(k) < 0  
                    
%                     quiver3(x(k) , y(k) , z(k) , Vector(k,1) , Vector(k,2) , Vector(k,3) , ...
%                      0, 'Color', 'black' , 'LineWidth', 3 ) 
%                     plot3(x(k) , y(k) , z(k) , '.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', 'black' )
                    
%                     disp("No Pass")
                    disp(Arrange.dist(k));
                    
                    %indexList = Arrange.k
                    %currentindex = k
                    Arrange.pointC = Arrange.k(k);
                    %data want to access = VesselData
                    plot3(VesselData(Arrange. pointC, 1) ,VesselData( Arrange.pointC, 2), ...
                         VesselData( Arrange.pointC, 3), '.y', 'MarkerSize', 20 ) 
                    
                    
                end 
                
                
                
              %%UNCOMMENT IF YOU WANT TO SEE DIFFERENT PROBE SAFETY MARGINS 
                
%                 if Arrange.ProbePass2(k) > 0
% 
%                     plot3(x(k) , y(k) , z(k) , '.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', colorNew( i, :) )
%                     quiver3(x(k) , y(k) , z(k) , Vector(k,1) , Vector(k,2) , Vector(k,3) , ...
%                          0, 'Color', rgb('Lime'), 'LineWidth', 2 )
%                      
%                      PassCount= [PassCount,k ];
%                 else 
%                     abs(Arrange.ProbePass2(k))
%                     
%                     colors = [ rgb('DarkRed'); rgb('Red'); rgb('Orange');...
%                         rgb('Navy'); rgb('DodgerBlue') ] ;
%                     
%                     quiver3(x(k) , y(k) , z(k) , Vector(k,1) , Vector(k,2) , Vector(k,3) , ...
%                      0, 'Color', colors( abs(Arrange.ProbePass2(k)), :) , 'LineWidth', 2 ) 
%                     plot3(x(k) , y(k) , z(k) , '.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', colors( abs(Arrange.ProbePass2(k)),:) )
%                     disp("No Pass")
% 
%                     
%                 end 
                

            end 
             
        else 
%            disp("done")
        end 
       
        

        
%         if min(min(Arrange.ProbePass(Arrange.ProbePass > 0 ) )) > safetyMargin
%             if zprobecheck(pc) > 60 
%             	break
%             end 
%         end 
    
% 
%        if zprobecheck(pc) > 70 
%           if min(min(Arrange.ProbePass(Arrange.ProbePass > 0 ) )) > safetyMargin 
%             	break
%             end 
%         end 
%         

    grid on;
       

    end 
end 

%Print the angle of the rest of the probes
CenterX = 0;
CenterY = 0;

Target.OGx = [radiusSrt * cos(angles) + CenterX]';
Target.OGy = [radiusSrt * sin(angles) + CenterY]';
Target.OGz = [repmat(0, 1, length(angles) )]';
for i = 1:spaceEnd
    
    radius = radiusSrt + ProbeAngleSpacing*(i-1);
    CenterX = 0;
    CenterY = 0;
    x = [radius * cos(angles) + CenterX]';
    y = [radius * sin(angles) + CenterY]';
    z = [repmat(0 +  50, 1, length(angles) )]';
    
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


    CenterX = TargetCentr(1);
    CenterY =  TargetCentr(2);
    CenterZ =  TargetCentr(3);

    x = [radius * cos(angles) ]';
    y = [radius * sin(angles) ]';
    z = [repmat(70 , 1, length(angles) )]';
    
    %Rotate the Placement points
    Rc = [x,y,z]';
    C = [YP*Rc]' ; 
    
    
    
    x = C(:,1)+ CenterX;
    y = C(:,2) + CenterY;
    z = C(:,3) + CenterZ;
    
  
    
    text(  x(1)*1.035, y(1)*1.035 , z(1)*1.035, ...
    join([ num2str( round(Arrange.VectorAnglesX(i),0) ), char(176) ]),'FontSize', 10)
end 
Arrange.text = [x, y, z]; 

hold on

slct  = 1; 
for i = 1:length(angles)
    
    plot3( Target.x(i) , Target.y(i), Target.z(i), '+', 'Color',TargetColor(slct, :)  ,'LineWidth', 3, 'MarkerSize', 8)
    hold on
    
    slct = slct +1;
    if slct >= length(angles)/2
        slct = 1;
    end 
end 


end 

    