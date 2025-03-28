%Create an atlas
close all
clear


Vandy_map  = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Orange"); rgb("OrangeRed"); ...
            rgb("FireBrick");  rgb("Maroon")];   

Vandy_map2 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Orange"); rgb("OrangeRed"); ...
            rgb("FireBrick");  rgb("Maroon")]; 

Vandy_map3 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Peru");  rgb("Orange"); rgb("Orange"); rgb("OrangeRed");  rgb("OrangeRed"); ...
            rgb("FireBrick"); rgb("FireBrick"); rgb("Maroon"); rgb("Maroon")]; 
        
Vandy_map4 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Peru"); rgb("Orange"); rgb("Orange");...
             rgb("OrangeRed");  rgb("OrangeRed"); ...
            rgb("FireBrick"); rgb("FireBrick"); rgb("Maroon"); rgb("Maroon")]; 
        
Vandy_map5  = [  repmat(rgb("RoyalBlue"), 5,1) ;...
            repmat( rgb("BurlyWood"), 5,1) ;repmat( rgb("Peru"), 5,1) ;...
            repmat( rgb("Orange"), 5,1) ;repmat( rgb("DarkOrange"), 5,1);...
            repmat( rgb("OrangeRed"), 4, 1) ; repmat( rgb("FireBrick"), 5,1) ;...
            repmat( rgb("Maroon"), 5,1) ];        
        
SdtMap = Vandy_map2;
SDATAMap = Vandy_map5;



plotAblation = "FALSE";
plotMultiAblation = "FALSE";
MultiAblationCheck = "FALSE"; 
PlotTumorSDA = "TRUE";

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
% 
%AllAngles = [0,0;0,0]; 

%Either use: exprmt or N for selection

AblAP_All = zeros(1000, 3*20);
    

for exprmt = 1:6 %6 %12 or 6
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
subplot (2 , 3, exprmt  )   



    switch cmpr 
        case 1
            plotAblation = "FALSE";
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
        Y = Y +3;
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


    if plotAblation == "TRUE"
            
%        for ki = 1:2
            %rearrange the points
%             psi2 =   [ 0  ];
%             theta2 = [ 0 ];  %88
%             YP =  YawPitch(psi2, theta2); 
%             P = [ BoundaryPoints.new(:,1) ,  BoundaryPoints.new(:,2), BoundaryPoints.new(:,3)];
%             C = [YP*P']' ; 
%             P = C -  mean(C);
            
            %rotate along the x-axis
            P = [ BoundaryPoints.new(:,1) ,  BoundaryPoints.new(:,2), BoundaryPoints.new(:,3)];
            R = rotx( -90  );
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
            Z2 = P(:,3) + newCenter(3);
            X = X2;
            Y = Y2;
            Z = Z2;
            
         %Create the ablation volume
            radius = 20 /2;
            long_axis = 40 /2; 
%             [X,Y,Z] = ellipsoid(CenterX+shift(ki) , CenterY , 0 ,...
%             radius ,radius,  long_axis );
%             X = reshape(X,[],1);
%             Y = reshape(Y,[],1);
%             Z = reshape(Z,[],1);
            psi2 =   [ psiAngle  ];
            theta2 = [ thetaAngle ]; 
%             if ki == 2
%                 psiAngle =  [0,180 - 10*(i-1) ];
%                 thetaAngle = [0, 180- 10*(i-1)];  
%             else
%                 psiAngle =  [0,180 + 10*(i-1) ];
%                 thetaAngle = [0, 180+ 10*(i-1)];  
%             end 
            %rearrange the points
            YP =  YawPitch(psi2, theta2); 
            P = [X,  Y, Z ];
            C = [YP*P']' ; 
            P = C -  mean(C);
            %AblationCenter = mean([X,Y,Z]); 
            newCenter =  mean(P) - [ 0 , 0 , 0] ;
            X2 = P(:,1) + newCenter(1) + AllCenters(targetTum ,1)*radiusSrt*radmult(exprmt) ;
            Y2 = P(:,2) + newCenter(2)+ AllCenters(targetTum ,2)*radiusSrt*radmult(exprmt)  ;   
            Z2 = P(:,3) + newCenter(3) + shiftZ;

            [k, vol] = boundary([X2,Y2,Z2], 0 );
            hold on
            %USE angleIdx or exprmt
            trisurf(k, X2, Y2 , Z2 ,'Facecolor', colorAblation(exprmt,:)  ,'FaceAlpha',.5 ,...
                'EdgeColor', 'none' )      
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            camlight
            view( ViewAdd(exprmt) ,20)
            
            
            AblAP = [ AblAP     ; X2, Y2 , Z2 ];
            ptsSingle = [ X2, Y2 , Z2]; 
        end 
          

    end 
    
    if plotMultiAblation == "TRUE"
            MultiAblationCheck = "TRUE"; 
            %rotate along the x-axis
            P = [ BoundaryPoints.new(:,1) ,  BoundaryPoints.new(:,2), BoundaryPoints.new(:,3)];
            R = rotx( -90  );
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
    end 
    
    xlim([-30, 30])
    ylim([-30, 30])
    zlim([-40, 40])

    
    if plotAblation == "TRUE"  && MultiAblationCheck == "TRUE"
        %Find the signed Distance to Agreement
        % TumorPointsOG  ,   BoundaryPointsOG,  itime, ColorAbl, ColorTum  
        [returnData, BndPtsin, BndPtsout, Expt, STumor ] = ...
            AblationIntersectionTarget( ptsMulti  ,  ...
            ptsSingle , itime , 'b' , rgb('Sienna') ); 

         % Calculate the signed distance to agreement between the two point clouds
                %signed distance to agreement between All Ablation points
                %inside the tumor
                x1 = BndPtsin(:,1);
                y1 = BndPtsin(:,2);
                z1 = BndPtsin(:,3);

                x2 = ptsMulti(:,1);
                y2 = ptsMulti(:,2);
                z2 = ptsMulti(:,3);
    %           %outde the tumor
                distances = [];

                for i=1:length(x1)
                    [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2)).*-1;
                    distances=[ distances,dist] ;
                end

                x1 = BndPtsout(:,1);
                y1 = BndPtsout(:,2);
                z1 = BndPtsout(:,3);            
                for i=1:length(x1)
                    [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2));
                     distances=[ distances,dist] ;
                end
                
                %%SDA TUMOR!!!
                % Calculate the signed distance to agreement between the two point clouds
                %signed distance to agreement between All Ablation points
                %inside the tumor
                x1 = Expt.TumPointsIn(:,1);
                y1 = Expt.TumPointsIn(:,2);
                z1 = Expt.TumPointsIn(:,3);

                x2 = X;
                y2 = Y;
                z2 = Z;
    %           %outde the tumor

                distancesTumor = [];
                for i=1:length(x1)
                    [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2)).*-1;
                    distancesTumor=[ distancesTumor,dist] ;
                end

                x1 =  Expt.TumPointOut(:,1);
                y1 =  Expt.TumPointOut(:,2);
                z1 =  Expt.TumPointOut(:,3);            

                for i=1:length(x1)
                    [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2));
                     distancesTumor=[ distancesTumor,dist] ;
                end         


            if PlotTumorSDA == "TRUE"
                figure( 2 )
                subplot (2 , 3, exprmt  )   
                
                % PLOT THE RESULTS
                %figure( (pj)*2  )
                set(gcf,'color','w');                
                newmap = brighten(SdtMap,.15);
                Xsct = [ Expt.TumPointsIn(:,1) ; Expt.TumPointOut(:,1) ] ; 
                Ysct = [ Expt.TumPointsIn(:,2) ; Expt.TumPointOut(:,2) ] ;
                Zsct = [ Expt.TumPointsIn(:,3) ; Expt.TumPointOut(:,3) ] ;
                S = 100;
                C2 = distancesTumor;
                disp( [min(C2),max(C2)] )  
                %Find the triangulation of the Interogation Boundary Points 
                    P = [Xsct,Ysct,Zsct];
                    %P2 = TumorData.Points;
                    k = boundary(P, .25);
                    %k2 = boundary(P2, .8);                
        %         k = boundary(P, .8);
        %         DT1 = delaunayTriangulation(P);
        %         [k,v] = convexHull(DT1) ;     
                C2New = [];
                for triK  = 1:length(k)
                    C2c   = [ C2(k(triK,1)), C2(k(triK,2)), C2(k(triK,3)) ];
                    C2New = [C2New; mean(C2c) ];
                end        
        %         scatter3(Xsct,Ysct,Zsct,S,C2, 'filled') 
                pt = trisurf( k ,Xsct,Ysct,Zsct, C2New, 'EdgeColor',...
                              rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha', .85 );                          
                colormap(newmap)
                hc=colorbar;
                hc.FontSize = 18;
        %         title(hc,'mm', 'FontSize', 20);
                title( 'SDA_{T-A}', 'Fontsize', 20)
                C=caxis;
                %caxis([maxColorBar , minColorBar ])
                axis equal
                grid off
                axis off 
                view( ViewAdd(exprmt) ,20)
                hold on
                 
                X2 = ptsSingle(:,1);   Y2 = ptsSingle(:,2);     Z2 = ptsSingle(:,3);
                [k, vol] = boundary([X2,Y2,Z2], 0 );
                hold on
                %USE angleIdx or exprmt
%                 trisurf(k, X2, Y2 , Z2 ,'Facecolor', colorAblation(exprmt,:)  ,'FaceAlpha',.5 ,...
%                     'EdgeColor', 'none' )  
                plot3( X2, Y2 , Z2, '.', 'Color',  colorAblation(exprmt,:)   )
                
                                text(  x(1)+ textadd.x  , y(1) + textadd.y , z(1) + textadd.z, ...
                join([ num2str( round(psiAngle ,0) ), char(176),...
                ",", num2str( round(thetaAngle ,0) ), char(176) ]),'FontSize', 8)
                hold on;

                %Plot the vectors
                quiver3( x,y,z , Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
                     0, 'Color', 'black' , 'LineWidth', 2 )
                for i = 1:length(angles)
                    plot3( Target.x(i) , Target.y(i), Target.z(i), '+', ...
                        'Color',TargetColor(slct, :)  ,'LineWidth', 3, 'MarkerSize', 14)
                    hold on
                    slct = slct +1;
                    if slct >= length(angles)/2
                        slct = 1;
                    end 
                end 
                
                hold off
            
            figure( 1 )
            end 
        
    end 
    
               
               
end            

    if plotAblation == "TRUE" && cmpr == 2
        set(gcf,'color','w');   
        figure( 3 )
        subplot (2 , 3, exprmt  )           
        
        disp("TRUE")
        %Colors for ablattion volume:  colorAblation(exprmt,:)   
        [k2, vol] = boundary([ AblAP(:,1) ,AblAP(:,2) ,AblAP(:,3)], .25 );
        trisurf(k2, AblAP(:,1) ,AblAP(:,2) ,AblAP(:,3) ,...
                'Facecolor', colorAblation(exprmt,:)  ,'FaceAlpha', .25  ,...
                'EdgeColor', colorAblation(exprmt,:)  )
            hold on
        plot3( AblAP(:,1) ,AblAP(:,2) ,AblAP(:,3), '.', 'Color', colorAblation(exprmt,:) )
        text(  x(1)+ textadd.x  , y(1) + textadd.y , z(1) + textadd.z-5, ...
        join([  "Volume = ", round(vol/1000, 2) ]),'FontSize', 8)
        axis equal
        grid off
        axis off 
        view( ViewAdd(exprmt) ,20)
        hold on
        

        %BoundaryPoints.k = reshape(k,[],1);
        Kreshape = reshape(k2,[],1);
        kSort = unique(Kreshape);
        kSortAblAP = AblAP(kSort,:);   

                    
        pause(.1)
        
        a = (exprmt-1)*3 + 1;
        b = (exprmt-1)*3 + 3;
        AblAP_All( 1:length(kSortAblAP), a:b  ) =  kSortAblAP ;
        figure( 1 )
    end
    
    
% AblAP = [];
end


%%
%ADD AND ATLAS

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
%PLOT ABLATIONS 


close all
% FALSE   TRUE
PlotTumorSDA = "TRUE" ; 
MultiAblationCheck = "TRUE" ; 



for exprmt = 1:6
    
figure( 1 )
subplot (2 , 3, exprmt  )    

a = (exprmt-1)*3 + 1;
b = (exprmt-1)*3 + 3;
ptsSingle  = AblAP_All( : ,  a:b);   
ptsSingle( ptsSingle == 0) = [];
ptsSingle = reshape( ptsSingle ,   [], 3 ) ; 

%subplot (3 ,4, exprmt  )  


plotAblation = "FALSE";
plotMultiAblation = "TRUE";
ModelRun = [ "Multiprobe" ] ;  
shiftZ = 0;


targetTum =  AllTumorSlct(exprmt, angleIdx); 
Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"]; 
Angles = ["0"; "5"; "10"; "15"; "20"; "25"];
pj = 1;   
position = 1;     
selectfile = convertStringsToChars(Patient(pj)); 
Angle = Angles(exprmt);
%ModelRun = [ "Multiprobe" ] ;    

    switch ModelRun  
%         case "Single Ablation"
%              fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxGeomPhantom_TrueBeefAblation_SingleAblation60W.csv";
%              
        case "Multiprobe"
             fileName = SelectMultiAblationBoundaryPoints915mhz( position, Angle);
    end 

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
        Y = Y +3;
        BoundaryPoints.new = [X,Y,Z];
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


    if plotMultiAblation == "TRUE"
            %MultiAblationCheck = "TRUE"; 
            %rotate along the x-axis
            P = [ BoundaryPoints.new(:,1) ,  BoundaryPoints.new(:,2), BoundaryPoints.new(:,3)];
            R = rotx( -90  );
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
            
%             trisurf(k, X2, Y2 , Z2 ,'Facecolor', colorAblation(exprmt,:)  ,'FaceAlpha', .15 ,...
%                 'EdgeColor', 'none' )
            hold on
            plot3( X2, Y2 , Z2 , '.', 'Color', colorAblation(exprmt,:) )
            
          
            plot3(  ptsSingle(:,1), ptsSingle(:,2), ptsSingle(:,3),...
                    '.', 'Color',  'k' , 'Markersize', 4    ) 
            
            
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            axis equal
            camlight
            view( ViewAdd(exprmt) ,20)
            
            ptsMulti = [ X2, Y2 , Z2];             
    end 
    
    xlim([-30, 30])
    ylim([-30, 30])
    zlim([-40, 40])

    
    if  MultiAblationCheck == "TRUE"

            %Calculating the distances of the new 
            TargetPoints = ptsMulti;        BoundaryPointsOG = ptsSingle;
            center = [0,0,0];
            [ distances ] = SDAVectorTarget( TargetPoints ,   BoundaryPointsOG,  center ) ; 
            
            [ Spectraldistances ] = SpectralDistance(    BoundaryPointsOG ) ;
                 

            if PlotTumorSDA == "TRUE"  
               
                Xsct = BoundaryPointsOG(:,1);       Ysct =  BoundaryPointsOG(:,2); 
                Zsct = BoundaryPointsOG(:,3); 
                
                
                % PLOT THE RESULTS
                %figure( (pj)*2  )
                set(gcf,'color','w');                
                newmap = brighten(SdtMap,.15);
                S = 100;
                
                
                %C2 = distances;
                C2 = Spectraldistances;
                
                
                disp( [min(C2),max(C2)] )  
                %Find the triangulation of the Interogation Boundary Points 
                    P = [Xsct,Ysct,Zsct];
                    %P2 = TumorData.Points;
                    k = boundary(P, .4);
                    %k2 = boundary(P2, .8);                
        %         k = boundary(P, .8);
        %         DT1 = delaunayTriangulation(P);
        %         [k,v] = convexHull(DT1) ;     
                C2New = [];
                for triK  = 1:length(k)
                    C2c   = [ C2(k(triK,1)), C2(k(triK,2)), C2(k(triK,3)) ];
                    C2New = [C2New; mean(C2c) ];
                end      
                
                
                
                
        %         scatter3(Xsct,Ysct,Zsct,S,C2, 'filled') 
                pt = trisurf( k ,Xsct,Ysct,Zsct, C2New, 'EdgeColor',...
                              rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha', .75 );   
                          
                          
                          
                          
               plot3( Xsct,Ysct,Zsct, '.', 'Color', colorAblation(exprmt,:), 'Markersize', 2  )          
                          
                colormap(newmap)
                hc=colorbar;
                hc.FontSize = 18;
        %         title(hc,'mm', 'FontSize', 20);
                title( 'SDA_{T-A}', 'Fontsize', 20)
                C=caxis;
                %caxis([maxColorBar , minColorBar ])
                axis equal
                %grid off
                %axis off 
                view( ViewAdd(exprmt) ,20)
                hold on
                 
                X2 = ptsSingle(:,1);   Y2 = ptsSingle(:,2);     Z2 = ptsSingle(:,3);
                [k, vol] = boundary([X2,Y2,Z2], 0 );
                hold on
                %USE angleIdx or exprmt
%                 trisurf(k, X2, Y2 , Z2 ,'Facecolor', colorAblation(exprmt,:)  ,'FaceAlpha',.5 ,...
%                     'EdgeColor', 'none' )  
               
                plot3( X2, Y2 , Z2, '.', 'Color',  colorAblation(exprmt,:), 'Markersize', 2    )
                
                
           for angleIdx = 1:2 
               
               targetTum =  AllTumorSlct(exprmt, angleIdx); 
               
                center = [Target.x, Target.y, Target.z];
                TCenter = [ AllCenters( targetTum ,1), AllCenters( targetTum ,2), ...
                            AllCenters( targetTum ,3) ];
                psiAngle = AllAngles(  exprmt, (angleIdx-1)*2 +1 ); %rad2deg( 30*pi/180 ) ;
                thetaAngle = AllAngles( exprmt , (angleIdx-1)*2 +2  );  %rad2deg( -45*pi/180) ;

                [ points, Vector ] = ProbeVector( psiAngle ,  thetaAngle,  radius, center, TCenter ) ;
                %%%
                x = points(:,1);   y =   points(:,2);        z = points(:,3);                

                
                text(  x(1)+ textadd.x  , y(1) + textadd.y , z(1) + textadd.z, ...
                join([ num2str( round(psiAngle ,0) ), char(176),...
                ",", num2str( round(thetaAngle ,0) ), char(176) ]),'FontSize', 8)
                hold on;

                %Plot the vectors
                quiver3( x,y,z , Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
                     0, 'Color', 'black' , 'LineWidth', 2 )
                for i = 1:length(angles)
                    plot3( Target.x(i) , Target.y(i), Target.z(i), '+', ...
                        'Color',TargetColor(slct, :)  ,'LineWidth', 3, 'MarkerSize', 14)
                    hold on
                    slct = slct +1;
                    if slct >= length(angles)/2
                        slct = 1;
                    end 
                end 
                
           end 
                
                
                
                
                hold off
            
            
            end
            
            
    end

end
    
    

    
    
    
    











