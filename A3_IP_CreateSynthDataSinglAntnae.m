
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
Make_Image = "FALSE";

%Make a Video
% writerObj = VideoWriter('VoxelField_Test_EarlyTime.avi'); %// initialize the VideoWriter object
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

N = 4;
%AllAngles = [0 + (360-0).* rand(N,1), 0 + (45-0).* rand(N,1) ]; 
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
                 1,4; 1,4; 1,4; 1,4; 1,4; 1,4]  ;
AllTumorSlct = repmat(AllTumorSlct,4,1) ;  


ViewAdd = [  repmat(0, 6, 1);  repmat(-100, 6, 1)]; 

         
colorAblation = hsv(    size(AllAngles,1)    );
VectorData.Vectors = [];
VectorData.Coordinates = [];

 %Either use: exprmt or N for selection
Abl.AP_All_Single = zeros(1000, 3*20);
Abl.AP_All_Multi = zeros(1000, 3*20);    


%Create the Box Phantom Model
pVox.VoxSize = [100, 100, 100 ] ;
center = [0,0,0]- (pVox.VoxSize/2) ;
%Choose where to start and end 
strt = [0, 0, 0];
endd = [0,0,0];

%----------------------------------------------------------------------------------------%
pVox.points = [0 0 0; 0 0 0];
pVox.Volxelx = [ center(1) +  pVox.VoxSize(1)*strt(1) :pVox.VoxSize(1): pVox.VoxSize(1)*endd(1)  +  center(1)  ] ;
pVox.Volxely = [ center(2) +  pVox.VoxSize(2)*strt(2) :pVox.VoxSize(2): pVox.VoxSize(2)*endd(2)  +  center(2)  ] ;
pVox.Volxelz = [ center(3) +  pVox.VoxSize(3)*strt(3) :pVox.VoxSize(3): pVox.VoxSize(3)*endd(3)  +  center(3)  ] ;
%
intensity.spc = 3;
%
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
%----------------------------------------------------------------------------------------%

num.All = [];
num.VolumeAll  = []; 

exprmtColor = hsv(length(AllAngles)  ); 
for exprmt = 1:2 %length(AllAngles)        %6 %12 or 6  
    
    
    
num.Pts = [];
num.Volume  = []; 


% for targetTum = 1:4
    AllCenters = [1,0,0; 
                  0,1,0; 
                  -1,0,0; 
                   0,-1,0]*.75;  
               
            
for cmpr = 2:2 

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
    

    switch ModelRun
        case "Single Ablation"
            
             %fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxGeomPhantom_TrueBeefAblation_SingleAblation60W.csv";
             %fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxPhantom__SingleAblation60W_HighFat.csv";
             %fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary ExVivo__SingleAblation60W_HighFat.csv";
             fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxGeomSymmetricModel_Case1.csv";
             
        case "Multiprobe"
    end 
   

idx = 4*1+1 : 2 : (15*4)+1 ;  
%idx = [60];

for j = 1 : length(idx)


figure(1)
subplot( 1, 2, 1)
set(gcf,'position',[ 250, 250, 1050, 700])
Abl.AP = [];    
Abl.center = [] ;


    
    VectorData.Vectors = [];
    VectorData.Coordinates = [];  

    
    for angleIdx = 1:2  %1:N

        targetTum =  AllTumorSlct(exprmt, angleIdx); 
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


        radiusSrt = 15; %7*sqrt(2);
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

        %



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


            %Move the Targets and scale the vectors again. 
            Nz = Nz/10/3.5;
            x = x/Nz + AllCenters(targetTum ,1)*radiusSrt;   
            y = y/Nz + AllCenters(targetTum ,2)*radiusSrt;     
            z = z/Nz-20;
            %%%
            %pm = plot3( x,y,z  ,'.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', 'r' );

            textadd.x = 5*x(1)/abs(x(1)+.0001) ;
            textadd.y = 5*y(1)/abs(y(1)+.0001) ; 
            textadd.z = 2*z(1)/abs(z(1)+.0001) + 10 ; 
            text(  x(1)+ textadd.x  , y(1) + textadd.y , z(1) + textadd.z, ...
            join([ num2str( round(psiAngle ,0) ), char(176),...
            ",", num2str( round(thetaAngle ,0) ), char(176) ]),'FontSize', 8)
            hold on;

            %Plot the vectors
            Vector = Vector/Nz;

    %         q1 = quiver3( x,y,z , Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
    %              0, 'Color', 'black' , 'LineWidth', 2 );
            grid on;
        end

        %---------------------------------------------------%%PLOT TARGET
        slct  = 1; 
    %     for i = 1:length(angles)
    % 
    %         p0 = plot3( Target.x(i) , Target.y(i), Target.z(i), '+', 'Color', 'k'  ,'LineWidth', 3, 'MarkerSize', 14); 
    %         hold on
    %         slct = slct +1;
    %         if slct >= length(angles)/2
    %             slct = 1;
    %         end 
    % 
    %     end 


    VectorData.Vectors = [VectorData.Vectors; Vector   ];
    VectorData.Coordinates = [VectorData.Coordinates; x,y,z ];


    %----------------------------------------------------------------------------------------%
    BoundaryPoints.og = readtable(fileName);
    BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:)) ;


    
        itime = idx(j);
        X = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 1) );
        X(X == 0) = [];
        Y = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 2) );
        Y(Y == 0) = [];
        Z = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 3) );
        Z(Z == 0) = [];
        Y = Y;   
        BoundaryPoints.new = [X,Y,Z];
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
            X2 = P(:,1) + newCenter(1)+ AllCenters(targetTum ,1)*radiusSrt;
            Y2 = P(:,2) + newCenter(2)+ AllCenters(targetTum ,2)*radiusSrt;   
            Z2 = P(:,3) + newCenter(3);
            
                

            
            
            switch angleIdx
                case 1
                    Abl.AP_Probe1 = [  X2, Y2 , Z2 ];
%                     [k, vol] = boundary([ Abl.AP_Probe1(:,1) ,Abl.AP_Probe1(:,2) ,Abl.AP_Probe1(:,3)], .6 );
%                     BoundaryPoints.k = reshape(k,[],1);
%                     BoundaryPoints.kSort = unique(BoundaryPoints.k);
%                     Abl.AP_Probe1 = Abl.AP_Probe1(BoundaryPoints.kSort,:); 
                    
                    
                    %----------------------------------------%  RESAMPLE
                    %ABLATION VOLUME                    
                    Abl.AP_Probe1 = UpsampleAblationMidpoint(  Abl.AP_Probe1  ); 
                    if itime > 20
                        
                        Abl.AP_Probe1 = UpsampleAblationMidpointEdges(  Abl.AP_Probe1 ); 
                        Abl.AP_Probe1 = UpsampleAblationMidpoint(  Abl.AP_Probe1 );
                        
                        disp("Upsample AP_Probe1")
                    end                     
                    %Abl.AP_Probe1 = UpsampleAblationMidpointEdges(  Abl.AP_Probe1 ); 
                    
                    
                    Abl.AP = [ Abl.AP     ; Abl.AP_Probe1 ];
                    Abl.center = [Abl.center; mean([Abl.AP_Probe1]) ] ;                    
                    
                case 2
                    Abl.AP_Probe2 = [  X2, Y2 , Z2 ];  
%                     [k, vol] = boundary([ Abl.AP_Probe2(:,1) ,Abl.AP_Probe2(:,2) ,Abl.AP_Probe2(:,3)], .6 );
%                     BoundaryPoints.k = reshape(k,[],1);
%                     BoundaryPoints.kSort = unique(BoundaryPoints.k);
%                     Abl.AP_Probe2 = Abl.AP_Probe2(BoundaryPoints.kSort,:); 
%                     
                    
                    %----------------------------------------%  RESAMPLE
                    %ABLATION VOLUME
                    Abl.AP_Probe2 = UpsampleAblationMidpoint(  Abl.AP_Probe2  ); 
                    if itime > 20
                        
                        Abl.AP_Probe2 = UpsampleAblationMidpointEdges(  Abl.AP_Probe2 ); 
                        Abl.AP_Probe2 = UpsampleAblationMidpoint(  Abl.AP_Probe2 );
                        disp("Upsample AP_Probe2")
                    end 
                    %Abl.AP_Probe2 = UpsampleAblationMidpointEdges(  Abl.AP_Probe2 ); 
                    
                    
                    Abl.AP = [ Abl.AP     ; Abl.AP_Probe2 ];
                    Abl.center = [Abl.center; mean([Abl.AP_Probe2]) ] ;                         
            end
            
                 
        end  
    end   

    
              Abl.APc = Abl.AP;
            %--------------------------------------------% Resample the volume data
%             [k, vol] = boundary([ Abl.APc(:,1) ,Abl.APc(:,2) ,Abl.APc(:,3)], .5 );
%             BoundaryPoints.k = reshape(k,[],1);
%             BoundaryPoints.kSort = unique(BoundaryPoints.k);
%             Abl.APc = Abl.APc(BoundaryPoints.kSort,:);
%             [ Abl.APc ] = UpsampleAblationMidpoint( Abl.APc  ); 
            

            %get the vectorData and plot them
            %-----------------------------------------------%Vector
          
            if itime > 20
                t = linspace(0, 1 ,100);     
            elseif itime > 4
                t = linspace(0, .6 ,100); 
            else 
                t = linspace(0, .5 ,100); 
            end 
            
            
           
            e1 = (VectorData.Vectors(1, :)'*t)' +...
                  [VectorData.Coordinates(1,1) , VectorData.Coordinates(1,2), VectorData.Coordinates(1,3)] ;
            e1 = e1 + Abl.center(1,:) - mean(e1); 
  
            vecplot1 = plot3(e1(:,1),e1(:,2),e1(:,3), 'LineWidth', 7,'Color', 'r');

           
           %dist_e1 = sqrt(  ( e1(1,1) - e1(end,1) )^2 + ( e1(1,2) - e1(end,2) )^2 + ( e1(1,3) - e1(end,3) )^2  )  ;
            %
            hold on
            e2 = (VectorData.Vectors( 3, :)'*t)' +...
                 [VectorData.Coordinates(3,1) , VectorData.Coordinates(3,2), VectorData.Coordinates(3,3)] ;
            e2 = e2 + Abl.center(2,:) - mean(e2); 
            
            vecplot2 = plot3(e2(:,1),e2(:,2),e2(:,3), 'LineWidth', 10,'Color', 'b');
            
            
            
            
            if j == 1
                center_e1 = [e1(90,1),e1(90,2),e1(90,3)]; 
                center_e2 = [e2(90,1),e2(90,2),e2(90,3)]; 
            end      
                centerPlotE1 =  plot3(center_e1(1) ,center_e1(2) ,center_e1(3) , '+',...
                                      'MarkerSize', 20, 'LineWidth', 3,'Color', rgb('Olive') );  
                centerPlotE2 =  plot3(center_e2(1) ,center_e2(2) ,center_e2(3) , '+',...
                                      'MarkerSize',20,'LineWidth', 3,  'Color', rgb('Chocolate') );  
                      
             
             
             
            axis equal
            xlim([-50 50])
            ylim([-50 50])
            zlim([-50 50])
            

    
            %----------------------------------------------------------------------------%
            TargetPoints = Abl.APc ;        
            QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
            %center = [0,0,0];
            %CenterQ = [e1; e2; 0 0 0; 0 0 5; 0 0 -5];
            
%             [ CenterQ ] = ProbeTargetsLineUp(  e1, e2 ) ; 
            
            
%             [ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  CenterQ ) ;

            [ distances ] = SDAVectorTargetDualAblation( Abl.AP_Probe1 , Abl.AP_Probe2,...
                         QuerryPointsOG,  e1,  e2 ) ;
                     
            %
            distancesIn = distances;
            distancesIn(distancesIn > 0) = nan;
            

        if plotVoxelMask == "TRUE"        

    %         if j < length(idx)-1 && j > start
    %             delete(p1)
    %             delete(s1) 
    % 
    %             if plotVectors == "TRUE" 
    %                 delete(q)
    %             end 
    %         end   

            set(gcf,'color','w');                
            %Find the triangulation of the Interogation Boundary Points 
            P = QuerryPointsOG;

            p1 = plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3),...
                '.', 'Color', rgb('Black'), 'MarkerSize', 4)  ;
            hold on 

            s = repmat(.5, length(P(:,1)), 1); 
            s1 = scatter3( P(:,1) , P(:,2) ,P(:,3), s,  distancesIn )   ;    
            s1.SizeData = 2;
%             colormap jet
%             hc=colorbar;
%             hc.FontSize = 18;
%             caxis([-20 1]);
            minutes =  floor( (idx(j)*15-15)/60) ; 
            seconds  = mod( (idx(j)*15-15), 60)    ;
    
            title( join(["Probe Placement Atlas",exprmt,...
                    newline,  num2str(minutes),  "m","  ", num2str(seconds), "s" ]), 'Fontsize', 14 )
                axis equal
            hold on
            
            
            subplot( 1, 2, 2)
            
            [k,v] = boundary(TargetPoints, .2);
%             p1 = plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3),...
%                 '.', 'Color', rgb('Black'), 'MarkerSize', 4)  ;
%             hold on
%             trisurf(k,TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3),...
%                 'FaceColor','red','FaceAlpha',0.1)
            V = v/1000;
            hold on
            plot( idx(j), V, '.', 'Color', exprmtColor( exprmt, : ),  'MarkerSize', 20 )  
            hold on
            VQ = V/ length(QuerryPointsOG) * 1e5 ;
            VQs = (  V/ length(QuerryPointsOG) )*.95;
%             plot( idx(j),  length(QuerryPointsOG)*VQs  , 'r+' , 'MarkerSize', 20 )             
%             text( idx(j)- 3  , V-5 ,...
%             join([  "  VQ  ",newline, VQ  ]),'FontSize', 10)       
            ylim([0 60])
            xlim([0 70])

            
            
            
            
            %------------------------------------------------%                Make a Video
%             Frame = getframe(gcf) ;                
%             writeVideo(writerObj,Frame)  
%             pause(.1)
            
            
            %------------------------------------------------------------------------------------%
            
            
            if Make_Image == "TRUE"
                distancesIn2 = distances;
                distancesIn2(distancesIn2 >0) = 0;
                distancesIn2(distancesIn2 <0) = 1;  

                x = P(:,1);
                y = P(:,2);
                z =P(:,3);
                intensity.All = distancesIn2;
                C = unique(z) ; 
                dimensionx = dimension;
                dimensiony = dimension;
                dimensionz = dimension; 

                I = StructuredPointcloud2Image( intensity.All, dimensionx, dimensiony, dimensionz );  

                %--------------------------------------------------PLOT THE CENTERS
                shiftP = [ 0,0,0 ; 1,0,0 ; 0,1,0; 1,1,0; ...
                           0,0,1 ; 1,0,1 ; 0,1,1; 1,1,1;
                           0,0,2 ; 1,0,2 ; 0,1,2; 1,1,2] ;
                for ptc = 1:12
                    
                    e1_idx = round(center_e1./intensity.spc,0)+50;
                    e1_idx = e1_idx + shiftP(ptc,:) ; 
                    %
                    I( e1_idx(1), e1_idx(2), e1_idx(3)) = 2; 
                    e1_idx_check = I( e1_idx(1), e1_idx(2), e1_idx(3));

                    e2_idx = round(center_e2./intensity.spc,0)+50;
                    e2_idx = e2_idx + shiftP(ptc,:) ;
                    %
                    I( e2_idx(1), e2_idx(2), e2_idx(3)) = 3; 
                    e2_idx_check = I( e2_idx(1), e2_idx(2), e2_idx(3));
                end 


               %--------------------------------------------------%

                resultsDir = 'D:\Import To Matlab\SyntheticMuliAblationData_NewRadius'; 
                ExportFileName = join(['Psi1_',   num2str(AllAngles(exprmt, 1)) ,...
                                       ' Theta1_', num2str(AllAngles(exprmt, 2)) ,...
                                       ' Psi2_' ,   num2str(AllAngles(exprmt, 3)) ,...
                                       ' Theta2_', num2str(AllAngles(exprmt, 4)) ,...
                                       '   ', num2str(minutes),  'm','  ', num2str(seconds), 's', '.txt' ])  ;
                exportBoundaryTitle = fullfile(resultsDir, ExportFileName);
                writematrix( I, exportBoundaryTitle);
            end 


        end 



    pause(1)
    hold off
   

end


num.Pts = [num.Pts; length( TargetPoints(:,1) ) ]  ;
num.Volume  = [num.Volume;  V]; 
% delete(vecplot1)
% delete(vecplot2)
% delete(pm )
% delete(q1)
% delete(p0)
end  


num.All = [num.All , num.Pts ]  ;
num.VolumeAll  = [num.VolumeAll , num.Volume]; 


end

% 
% close(writerObj);   
%%


figure('DefaultAxesFontSize',13)
set(gcf,'color','w');
timeX = idx(1:end-1).*15./60  ;

for i = 1:exprmt
    
    h = plot(  timeX, num.All(:, i  ) )  ;
    set(h, 'Color', [h.Color, 0.75], 'LineWidth', 2 );
    hold on
    
    
end 
title(join(["Number of Points vs Time",...
             newline, "No. Runs", num2str(exprmt)  ]) )
ylabel(" Time (mins)")
xlabel("No. Points")
%ylim([ min(min(numAll)) max(max(numAll))+1 ])
ylim([ 2595 2605 ])
%2697

%%

% Make a Video
% writerObj = VideoWriter('ImageField_Test.gif'); %// initialize the VideoWriter object
% writerObj.FrameRate = 8;
% open(writerObj) ;


DimEn = size(I);
figure()
for zi = 1:DimEn(3)
   
    set(gcf,'color','w');        
    currentI = I(:,:, zi);              
    imagesc(currentI)
    colorbar
    colormap jet    
    hc=colorbar;
    hc.FontSize = 18;
    caxis([0 3]);
    title( join(['Image', num2str(zi) ]) )
   
%    Frame = getframe(gcf) ;                
%    writeVideo(writerObj,Frame)  

   
   pause(.15)
   
    
end 

% close(writerObj);   
 
