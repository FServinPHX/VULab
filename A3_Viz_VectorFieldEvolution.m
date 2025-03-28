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
PlotTumorSDA = "TRUE";

%Make a Video
% writerObj = VideoWriter('VectorField.avi'); %// initialize the VideoWriter object
% writerObj.FrameRate = 8;
% open(writerObj) ;


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
AllAngles =[  repmat(0, N, 1) , linspace(0, 30, N)';...
              repmat(90, N, 1) , linspace(0, 30, N)';...
              repmat(180, N, 1) , linspace(0, 30, N)';... 
              repmat(270, N, 1) , linspace(0, 30, N)';];    

AllAngles = [0, 0, 180, 0;
             0, 0, 180, 15;
             0, 0, 180, 30;
             0, 15, 180, 15;
             0, 15, 180, 30;
             0, 30, 180, 30;
             0, 0, 270, 0;
             0, 0, 270, 15;
             0, 0, 270, 30;
             0, 15, 270, 15;
             0, 15, 270, 30;
             0, 30, 270, 30];
 AllTumorSlct = [1,3; 1,3; 1,3; 1,3; 1,3; 1,3;
                 1,4; 1,4; 1,4; 1,4; 1,4; 1,4];
ViewAdd = [  repmat(0, 6, 1);  repmat(-100, 6, 1)]; 


AllAngles = [0, 0, 180, 0;
             0, 5, 180, 5;
             0, 10, 180, 10;
             0, 15, 180, 15;
             0, 20, 180, 20;
             0, 25, 180, 25];            

             

colorAblation = hsv( 6 );

%Either use: exprmt or N for selection
AblAP_All_Single = zeros(1000, 3*20);
AblAP_All_Multi = zeros(1000, 3*20);    



for exprmt = 1:1 %6 %12 or 6
    
AblAP = [];     
% for targetTum = 1:4
    AllCenters = [1,0,0; 
                  0,1,0; 
                  -1,0,0; 
                   0,-1,0]*.50;                       
for cmpr = 1:1
    
figure( 1 )
%%% OR
%subplot (3 ,4, exprmt  )  
% subplot (2 , 3, exprmt  )   

    switch cmpr 
        case 1
            plotAblation = "TRUE";
            plotMultiAblation = "TRUE";
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
    

BoundaryPoints.og = readtable(fileName);
BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:));
idx = 2 : 1 : 15*4 ;
%idx = [2, 10, 20, 30, 40, 15*4];

VectorsALL = zeros( 1000, length(idx)*3);
%get the vectorData


%----------------------------------------------------------------------------------------%
% IMPORT AND READ THE ABLATION BOUNDARY DATA
%----------------------------------------------------------------------------------------%

for j = 1:length(idx)-1

     
        itime = idx(j);
        X = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 1) );
        X(X == 0) = [];
        Y = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 2) );
        Y(Y == 0) = [];
        Z = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 3) );
        Z(Z == 0) = [];
        Y = Y;
        
        %rotate along the x-axis
        P = [ X ,  Y,  Z];
        R = rotx( -90  );
        %R = rotx( 0  );
        C = [R*P']' ; 
        P = C -  mean(C);

        %AblationCenter = mean([X,Y,Z]); 
        newCenter =  mean(P) - [0 , 0 , 0] ;
        X1 = P(:,1) + newCenter(1);
        Y1 = P(:,2) + newCenter(2);
        Z1 = P(:,3) + newCenter(3) ;       
        
        BoundaryPoints.new = [X1,Y1,Z1];
        %--------------------------------------------------%UPSAMPLE ABLATION POINTS
        [ BoundaryPoints.new ] = UpsampleAblation( BoundaryPoints.new , 4 , "BOUNDARY" );
        
        
        
        if j < length(idx)
            
            %disp("TRUE")
            itime2 = idx(j+1);
            X2 = BoundaryPointsMatrix(2:end, ((itime2-1)*3 + 1) );
            X2(X2 == 0) = [];
            Y2 = BoundaryPointsMatrix(2:end, ((itime2-1)*3 + 2) );
            Y2(Y2 == 0) = [];
            Z2 = BoundaryPointsMatrix(2:end, ((itime2-1)*3 + 3) );
            Z2(Z2 == 0) = [];
            Y2 = Y2;
            
            %rotate along the x-axis
            P = [ X2 ,  Y2,  Z2];
            R = rotx( -90  );
            %R = rotx( 0  );
            C = [R*P']' ; 
            P = C -  mean(C);

            %AblationCenter = mean([X,Y,Z]); 
            newCenter =  mean(P) - [0 , 0 , 0] ;
            X2 = P(:,1) + newCenter(1);
            Y2 = P(:,2) + newCenter(2);
            Z2 = P(:,3) + newCenter(3) ;              
            
            
            BoundaryPoints2.new = [X2,Y2,Z2];   
            %--------------------------------------------------%UPSAMPLE ABLATION POINTS
            [ BoundaryPoints2.new ] = UpsampleAblation( BoundaryPoints2.new , 4 , "BOUNDARY" );
            
            QuerryPointsOG =  BoundaryPoints.new;
            TargetPoint = BoundaryPoints2.new;
            
            
            VectorsBnd = AIM3AblationVectorField( QuerryPointsOG, TargetPoint );   
            %VectorsBnd(:,3) = VectorsBnd(:,3)*10 ;
            a = (j-1)*3 + 1;
            b = (j-1)*3 + 3;
            VectorsALL( 1:length(VectorsBnd), a:b) = VectorsBnd;
        end 
  

  
    
    if plotMultiAblation == "TRUE"
            
        
            X1 = BoundaryPoints.new(:,1);   Y1 =  BoundaryPoints.new(:,2);
            Z1 = BoundaryPoints.new(:,3);
            
            [k, vol] = boundary([X1,Y1,Z1], 0 );
            
            
            set(gcf,'color','w');
            axis equal;
            title( join(["Probe Placement Atlas",exprmt]), 'Fontsize', 14 )   
            
           
          
            %USE angleIdx or exprmt
            t1 = trisurf(k, X1, Y1 , Z1 ,'Facecolor', colorAblation(exprmt,:)  ,'FaceAlpha', .05 ,...
                'EdgeColor', 'none' );
           
            %Plot the next
            %p1 = plot3( X2, Y2 , Z2 , '.', 'Color', 'k', 'MarkerSize', 5); 
            
            %plot the direction of growth of the ablation volume
            p2 = plot3( X1, Y1 , Z1  , '.', 'Color', 'k', 'MarkerSize', 1);
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
%             Frame = getframe(gcf) ;                
%             writeVideo(writerObj,Frame)  
           
            pause(.1)
           
            %delete Previous Plots
            if j < length(idx)-1
                
                delete(p2)
                delete(q)
                delete(t1)
            end 
               
    end 
    

    
 end 
    
    %------------------------------------------------------------------------------------%

    
 
end

    
               
               
end    

% close(writerObj);      

%%


