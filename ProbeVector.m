
function [ points, Vector ] = ProbeVector( psiAngle ,  thetaAngle,  radius, Target, TCenter ) 



angles = [0,6.28318530717959];
psi = deg2rad( psiAngle);    % yaw rotation angle
theta = deg2rad( thetaAngle ); % pitch rotation angle (negative rotation is up)

% Define vectors and Calculate the YAW-PITCH transformation matrix
YAW = [cos(psi), -sin(psi), 0; sin(psi), cos(psi), 0; 0, 0, 1]; % Planar YAW rotation
PITCH = [cos(theta), 0, sin(theta); 0,1,0; -sin(theta), 0, cos(theta)]; % Planar PITCH rotation
YP = YAW*PITCH; % YAW-PITCH rotation matrix


% radius = radiusSrt; 
CenterX = 0;
CenterY = 0;
Nz = 100000; 


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
Vector = ( [Target(:,1) , Target(:,2) , Target(:,2)] - [x, y, z]  );
%Move the Targets and scale the vectors again. 
Nz = Nz/10/5.5;
x = x/Nz + TCenter(1)*radius;   
y = y/Nz + TCenter(2)*radius;     
z = z/Nz-20;    



Vector = Vector/Nz;

points = [x,y,z]; 




end 