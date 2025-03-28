





function [numAllPts, e1, e2] = Aim3_CreateRandomAblation( AllAngles,startIteration )


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


%Angles Determine the number of potential target you want to model
% radiusSrt = 7*sqrt(2);
 radiusSrt = 10 ;% 8*sqrt(2);

%
psiAngleArr =  linspace(0 , 360, 16 + 1)-radiusSrt;
thetaAngleArr = linspace(0, 360, 17 + 1);
angles = linspace(0, 2*pi, 1 + 1);     


% AllAngles = [ [repmat(0, 1, length(psiAngleArr) ) ; psiAngleArr ],   ...
% [ thetaAngleArr ; repmat(80, 1, length(thetaAngleArr) ) ] ]';
% out1 = randperm( length(AllAngles)  ) ;
% AllAngles2  = AllAngles(out1,:)  ;
%AllAngles = [AllAngles, AllAngles2];

% AllAngles = [  ];


disp(AllAngles)



%Either use: exprmt or N for selection
VectorData.Vectors = [];
VectorData.Coordinates = [];
Abl.AP_All_Single = zeros(1000, 3*20);
Abl.AP_All_Multi = zeros(1000, 3*20); 

%
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


for exprmt = 1:1  % length(AllAngles)        %6 %12 or 6  

  
    num.Pts = [];
    num.Volume  = []; 
    num.AllPts = [];
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
            
        case 2
            plotAblation = "TRUE";
            plotMultiAblation = "FALSE";
            ModelRun = [ "Single Ablation" ] ;    
    end
    
    
    
% idx = 5 : 1 : (15*4)+1 ; 
idx = startIteration :1: (startIteration+1);


for j = 1:length(idx)

    
figure(1)
set(gcf,'color',plotColor );
set(gca,'color',plotColor );
set(gcf,'position',[ 250, 250, 650, 600])
Abl.AP = [];    
Abl.center = [] ;

    if j == length(idx)
        a = 2;
    else 
        a = 1;
    end 
        VectorData.Vectors = [];
        VectorData.Coordinates = [];  


        for angleIdx = 1:2  %1:N

            %------------------------------------------------------------------------------% 
            targetTum =  AllTumorSlct(exprmt, angleIdx); 
            %
            psiAngle = AllAngles(  exprmt, (angleIdx-1)*2 +1 ); %rad2deg( 30*pi/180 ) ;
            psi = deg2rad( psiAngle);    % yaw rotation angle
            disp(psi)
            %
            thetaAngle = AllAngles( exprmt , (angleIdx-1)*2 +2  );  %rad2deg( -45*pi/180) ;
            theta = deg2rad( thetaAngle ); % pitch rotation angle (negative rotation is up)
            disp(theta)
            % Define vectors and Calculate the YAW-PITCH transformation matrix
            YAW = [cos(psi), -sin(psi), 0; sin(psi), cos(psi), 0; 0, 0, 1]; % Planar YAW rotation
            PITCH = [cos(theta), 0, sin(theta); 0,1,0; -sin(theta), 0, cos(theta)]; % Planar PITCH rotation
            YP = YAW*PITCH; % YAW-PITCH rotation matrix
            % Rc = Column Vector pointing to circle on X-Axis (start point)
            % Now sweep the Rc vector around the X-axis to generate the circle 
            % This is done by adding a planar ROLL rotation to YP
            %radiusSrt = 10;
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
            %------------------------------------------------------------------------------%   


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

                textadd.x = 4.5*x(1)/abs(x(1)+.0001) ;
                textadd.y = 4.5*y(1)/abs(y(1)+.0001) ; 
                textadd.z = 2*z(1)/abs(z(1)+.0001) + 15 ; 
                text(  x(1)+ textadd.x  , y(1) + textadd.y , z(1) + textadd.z, ...
                join([ num2str( round(psiAngle ,0) ), char(176),...
                ",", num2str( round(thetaAngle ,0) ), char(176) ]),'FontSize', 14)
                hold on;
                Vector = Vector/Nz;


                grid on;
            end

            %---------------------------------------------------%%PLOT TARGET
            slct  = 1; 


        VectorData.Vectors = [VectorData.Vectors; Vector   ];
        VectorData.Coordinates = [VectorData.Coordinates; x,y,z ];
        %----------------------------------------------------------------------------------%
        % BoundaryPoints.og = readtable(fileName);
        BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:)) ;

            for plus = a:2 

                    switch plus
                        case 1
                            itime = idx(j);
                        case 2 
                             itime = idx(j)+1;
                    end 

                    X = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 1) );
                    X(X == 0) = [];
                    Y = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 2) );
                    Y(Y == 0) = [];
                    Z = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 3) );
                    Z(Z == 0) = [];           
                
               switch plus
                    case 1
                        BoundaryPoints.new = [X,Y,Z];
                    case 2 
                        
                        if j > 1
                            
                        else 
                            BoundaryPoints.new2 = [X,Y,Z];
                        end 
                end 
            end 


        if plotVoxelMask == "TRUE"

            for plus = a:2 
                switch plus
                    case 1
                        P = [ BoundaryPoints.new(:,1) ,  BoundaryPoints.new(:,2), BoundaryPoints.new(:,3)];
                    case 2 
                        P = [ BoundaryPoints.new2(:,1) ,  BoundaryPoints.new2(:,2), BoundaryPoints.new2(:,3)];
                end   

                R = rotx( -90  );
                %R = rotx( 0  );
                C = [R*P']' ; 
                P = C -  mean(C);

                %rotate along the y-axis
                R2 = roty( 0 );
                C = [R2*P']' ; 
                P = C -  mean(C);
                %
                newCenter =  [0 , 0 , 0] - mean(P);
                X2 = P(:,1) + newCenter(1);
                Y2 = P(:,2) + newCenter(2);
                Z2 = P(:,3) + newCenter(3);
                X = X2;
                Y = Y2;
                Z = Z2;
                %            
                psi2 =   [ psiAngle  ];
                theta2 = [ thetaAngle ]; 
                %
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

                %----------------------------------------%
                switch plus
                    case 1
                         Abl.AP1 = [  X2, Y2 , Z2 ];
                    case 2 
                         Abl.AP2 = [  X2, Y2 , Z2 ];
                end  
                %----------------------------------------%

            end 


           switch angleIdx
                 case 1
                     
                      for plus = a:2 
                           switch plus
                                case 1
                                    Abl.AP_Probe1 =  Abl.AP1;
                                case 2 
                                    Abl.AP_Probe1 = Abl.AP2;
                            end   


                            %----------------------------------------%  RESAMPLE
    %                         if size(Abl.AP_Probe2,1) < numpoints
    %                             [ Abl.AP_Probe1 ] = UpsampledAblationSpec( Abl.AP_Probe1, numpoints ) ;
    %                             disp("Upsampled") 
    %                         end                    
                            %----------------------------------------%
                            switch plus
                                case 1
                                         Abl.AP1 = [ Abl.AP     ; Abl.AP_Probe1 ];
                                         Abl.AP_Probe1_1 = Abl.AP_Probe1 ; 
                                         Abl.center1 = [Abl.center; mean([Abl.AP_Probe1]) ] ; 
                                case 2 
                                         Abl.AP2 = [ Abl.AP2     ; Abl.AP_Probe1 ];
                                         Abl.AP_Probe1_2 = Abl.AP_Probe1 ; 
                                         Abl.center1 = [Abl.center; mean([Abl.AP_Probe1]) ] ; 
                            end  
                            %----------------------------------------%
                      end                   


                 case 2                   
                      for plus = a:2 

                            switch plus
                                case 1
                                    Abl.AP_Probe2 =  Abl.AP1;
                                case 2 
                                    Abl.AP_Probe2 = Abl.AP2;
                            end    

                            %----------------------------------------%  RESAMPLE
    %                         if size(Abl.AP_Probe2,1) < numpoints
    %                             [ Abl.AP_Probe2 ] = UpsampledAblationSpec( Abl.AP_Probe2, numpoints ) ;
    %                             disp("Upsampled") 
    %                         end                         


                            switch plus
                                case 1
                                         Abl.AP1 = [ Abl.AP     ; Abl.AP_Probe2 ];
                                         Abl.AP_Probe2_1 = Abl.AP_Probe2 ; 
                                         Abl.center2 = [Abl.center; mean([Abl.AP_Probe2]) ] ; 
                                case 2 
                                         Abl.AP2 = [ Abl.AP2     ; Abl.AP_Probe1 ];
                                         Abl.AP_Probe2_2 = Abl.AP_Probe2 ; 
                                         Abl.center2 = [Abl.center; mean([Abl.AP_Probe2]) ] ; 
                            end                      
                            %----------------------------------------%
                      end 
                 end    
        end  
end   

            %------------------------------------------------------------------------%
            itime = idx(j);
            
            
            
            if itime > 20
                t = linspace(0, 1 ,100);     
            elseif itime > 4
                t = linspace(0, .6 ,100); 
            elseif  itime > 2
                t = linspace(0, .5 ,100); 
            elseif  itime == 1
                t = linspace(0, .5 ,1300); 
            end 
            
            if itime == 57
                 t = linspace(0, 1 ,1300);   
            end 
            
            
            e1 = (VectorData.Vectors(1, :)'*t)' +...
                  [VectorData.Coordinates(1,1) , VectorData.Coordinates(1,2), VectorData.Coordinates(1,3)] ;
            e1 = e1 + Abl.center1 - mean(e1); 
            %
            vecplot1 = plot3(e1(:,1),e1(:,2),e1(:,3), 'LineWidth', 7,'Color', 'r');
            %
            %
            hold on
            e2 = (VectorData.Vectors( 3, :)'*t)' +...
                 [VectorData.Coordinates(3,1) , VectorData.Coordinates(3,2), VectorData.Coordinates(3,3)] ;
            e2 = e2 + Abl.center2 - mean(e2); 
            %
            vecplot2 = plot3(e2(:,1),e2(:,2),e2(:,3), 'LineWidth', 10,'Color', 'b');
            
            %------------------------------------%
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
            %Now that I am keeping track of ablation volume evolution, I
            %can reassign ALLDATA1 to the previously linked ablation
            [ AllData1 ] = DualAblationCombine ( Abl.AP_Probe1_1 , Abl.AP_Probe2_1,...
                             e1,  e2 ) ;

                         
            NewPoints = AllData1(:, 1:3); 



            t = linspace(0, 1 ,1800);   
            e1 = (VectorData.Vectors(1, :)'*t)' +...
                  [VectorData.Coordinates(1,1) , VectorData.Coordinates(1,2), VectorData.Coordinates(1,3)] ;
            e1 = e1 + Abl.center1 - mean(e1); 
            %
            e2 = (VectorData.Vectors( 3, :)'*t)' +...
                 [VectorData.Coordinates(3,1) , VectorData.Coordinates(3,2), VectorData.Coordinates(3,3)] ;
            e2 = e2 + Abl.center2 - mean(e2); 



            
            
       %----------------------------------------------------------------------------------%     
       if Upsample == "TRUE"      
            if size(AllData1,1) < numpoints
                [ AllData1 ] = UpsampledAblationSpec( NewPoints, numpoints ) ;
                disp("Upsampled") 
                
                %--------------------------------------------------------------%
                if size(AllData1,1) < numpoints
                    while size(AllData1,1) < numpoints
                        [ AllData1 ] = UpsampledAblationSpec( AllData1, numpoints ) ;
                        disp("Upsampled II") 
                    end 
                end 
            end 
                
            if  size(AllData1,1) > numpoints
                [ AllData1 ] = DownsampleAblationSpec( NewPoints, numpoints ) ;
                 disp("Downsample") 
            else
                disp("Best Sample")   
            end 
       end      
       %----------------------------------------------------------------------------------%  
       
       
       if plotVectors == "TRUE"
                if j == length(idx)
                        QuerryPoints   =  AllData1(:, 1:3); 
                        TargetPoint    =  AllData1(:, 1:3); 
                        VectorsBnd = AIM3AblationVectorField( QuerryPoints, TargetPoint );                  
                else 
                        [ AllData2 ] = DualAblationCombine ( Abl.AP_Probe1_2 ,...
                                       Abl.AP_Probe2_2,  e1,  e2 ) ;   
                                   
                        %----------------------------------------------------------------------------------%     
                       if Upsample == "TRUE"      
                            if size(AllData2,1) < numpoints
                                [ AllData2 ] = UpsampledAblationSpec( NewPoints, numpoints ) ;
                                disp("Upsampled") 

                                %--------------------------------------------------------------%
                                if size(AllData2,1) < numpoints
                                    while size(AllData2,1) < numpoints
                                        [ AllData2 ] = UpsampledAblationSpec( AllData2, numpoints ) ;
                                        disp("Upsampled II") 
                                    end 
                                end 
                            end 

                                if  size(AllData2,1) > numpoints
                                    [ AllData2 ] = DownsampleAblationSpec( NewPoints, numpoints ) ;
                                     disp("Downsample") 
                                else
                                    disp("Best Sample")   
                                end 
                       end      
                       %----------------------------------------------------------------------------------%                                           
                        QuerryPoints   =  AllData1(:, 1:3); 
                        TargetPoint    =  AllData2(:, 1:3);                 
  
                end    
       end 
       
       
            %------------------------------------%
            set(gcf,'color',plotColor );
            set(gca,'color',plotColor );
            axis equal;
            
            %Apply New Algorithm
            X1 = AllData2(:,1);         Y1 = AllData2(:,2);          Z1 = AllData2(:,3); 
            %
            X2 = AllData1(:,1);         Y2 = AllData1(:,2);          Z2 = AllData1(:,3); 
            
            
            if plotVectors == "TRUE"
                
                VectorsBnd = AIM3AblationVectorField( QuerryPoints, TargetPoint );        
              
                %plot the direction of growth of the ablation volume
                sData = sqrt(  VectorsBnd(:,1).^2  + VectorsBnd(:,2).^2 + VectorsBnd(:,3).^2); 
                s3 = repmat(5, 1, length(  sData  )  );
                s = scatter3( X1, Y1 , Z1 , s3, sData, 'filled'   )   ;
                s.SizeData = 2;

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
            
                minutes =  floor( (idx(j)*15-15)/60) ; 
                seconds  = mod( (idx(j)*15-15), 60)    ;
                title( join(["Probe Placement Atlas",exprmt,...
                        newline,  num2str(minutes),  "m","  ", num2str(seconds), "s" ]), 'Fontsize', 14 )                        
                xlabel('X')
                ylabel('Y')
                zlabel('Z')
                axis equal ;
                view( -5 , 5)
                xlim([-50, 50])
                ylim([-50, 50])
                zlim([-50, 50])  
                hold on
            %------------------------------------%                

      

num.Pts = [num.Pts; length( X1(:,1) ) ]  ;
numAllPts = [num.AllPts, X1, Y1 , Z1  ]; 
% num.Volume  = [num.Volume;  V]; 
hold off
end




end
end
end


