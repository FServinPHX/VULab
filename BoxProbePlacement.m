%Create a plot that shows the 
clear
close all

plot_Scatter = "False";
plotAblation = "TRUE";
camlight 

gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
%red = [0.6	0.239215686	0.105882353];
red = [1	0.0239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
cyan =	[0 1 1];
magenta	= [1 0 1];
yellow = [1 1 0];

colorsA = [gold; blue; green; red; orange; purple; black; cyan; magenta; yellow;  ...
    gold; blue; green; red; orange; purple; black];

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

intensity.spc = 5;

[intensity.X,intensity.Y,intensity.Z] = meshgrid( pVox.Volxelx : intensity.spc : abs(pVox.Volxelx),...
    pVox.Volxely : intensity.spc :abs(pVox.Volxely), ...
    pVox.Volxelz : intensity.spc :abs(pVox.Volxelz) ) ;
intensity.X = reshape(intensity.X, [],1);
intensity.Y = reshape(intensity.Y, [],1);
intensity.Z = reshape(intensity.Z, [],1);
intensity.a = 1;
intensity.b = 50;
intensity.I = (intensity.b-intensity.a).*rand(length(intensity.X),1) + intensity.a;

%Plot 3D Scatter of Raw Image Data
if plot_Scatter == "TRUE"
    figure()
    set(gcf,'color','w');
    %scatter3(PlotiNewText(:,2), PlotiNewText(:,3), PlotiNewText(:,4), .5 ,PlotiNewText(:,1)  )
    scatter3(intensity.X , intensity.Y , intensity.Z , 40 ,intensity.I, 'Filled' )
    %colormap('parula'); 
    colormap('jet')
    colorbar
    hold on 
    title( join(["Hypothetical Hetergenous", newline, "Liver Phantom Fat Quant"]), 'Fontsize', 14)
end 

%
%plotcube( EDGES , ORIGIN , ALPHA  , COLOR 
%e.g.  plotcube([5 5 5],[ 2 2 2],.8,[1 0 0]);
for zi = 1:length(pVox.Volxelz)
    for j = 1:length(pVox.Volxely)
        for i = 1:length(pVox.Volxelx)
            
            pVox.xc = pVox.Volxelx(i);
            pVox.yc = pVox.Volxely(j);
            pVox.zc = pVox.Volxelz(zi);
            
            plotcube( pVox.VoxSize ,[ pVox.xc pVox.yc pVox.zc] , .1, yellow );
            hold on
            
        end 
    end
end 

set(gcf,'color','w');
set(gca,'FontSize',14)

%plot3(pVox.points(:,1), pVox.points(:,2), pVox.points(:,3), '.', 'MarkerSize',30 )




%Angles Determine the number of potential target you want to model
angles = linspace(0, 2*pi, 3);

%
spacing = 3;
colorNew = hsv(spacing);
colorNew =[ 0,0,1; 0,0,1;0,0,1];
TargetColor = lines(length(angles));
radiusSrt = 28*sqrt(2)/4;

CenterX = 0;
CenterY = 0;
Target.x = [radiusSrt * cos(angles) + CenterX]';
Target.y = [radiusSrt * sin(angles) + CenterY]';
Target.z = [repmat(-25, 1, length(angles) )]';

Arrange.VectorAngles = [];
Arrange.ProbeDepth =[];
Arrange.DistanceFromCenter=  [];

radiusManual = [10, 17, 24, 31, 39, 47]; 
radiusManual = [10,  24,  39]; 


plot3( CenterX , CenterY , Target.z(1) , '.r', 'MarkerSize', 20);
hold on


%%Create the tumor
[tumor.x1, tumor.y1,  tumor.z1] = sphere(25);
r = 28*sqrt(2)/2;

tumor.x1 = tumor.x1(:)*r + CenterX;
tumor.y1 = tumor.y1(:)*r + CenterY;
tumor.z1 = tumor.z1(:)*r + Target.z(1) ;
P = [tumor.x1 tumor.y1 tumor.z1];

[tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
    = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
set( tumorNew.p1 , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );
    hold on 
  
% radI = 1:1:spacing;   
   
for i = 1:spacing

    
    
    figure()
    hold off
    set(gcf,'color','w');
    xlabel('X', 'FontSize', 14);
    ylabel('Y', 'FontSize', 14);
    zlabel('Z', 'FontSize', 14);
    title("Multiprobe Placement Strategy",'FontSize', 25)
    view(25,10) 
    axis equal;
    
    
    plotcube( pVox.VoxSize ,[ pVox.xc pVox.yc pVox.zc] , .1, yellow );
    hold on   
    
    plot3( CenterX , CenterY , Target.z(1) , '.r', 'MarkerSize', 20);
   
    [tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
    = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
    set( tumorNew.p1 , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );
        
    
    Vector = [];
    %Adapt the radius
    %   
%     radius = radI(i)
     radius = radiusManual(i);
    %radius = radiusSrt + radiusSrt*.45*(i-1)/5; %+ radiusSrt*mlt*i;

    if radius > 20
        mlt = .15;
    else 
        mlt = 0;
    end 


    %
    CenterX = 0;
    CenterY = 0;
    x = [radius * cos(angles) + CenterX]';
    y = [radius * sin(angles) + CenterY]';
    z = [repmat(50+5, 1, length(angles) )]';
    
    
    
    
    Vector = ( [Target.x, Target.y, Target.z] - [x, y, z]  );
    
    %  ax = atan2(sqrt(y^2+z^2),x);
    Arrange.VectorAngles =[Arrange.VectorAngles; ...
        round( rad2deg(atan2(sqrt(Vector(1,2)^2 + Vector(1,3)^2), Vector(1,1) ) )- 90, 0) ];
    
    Arrange.ProbeDepth = [Arrange.ProbeDepth;...
        round( sqrt( Vector(1,1)^2 +  Vector(1,2)^2 +  Vector(1,3)^2), 1)  ];
    
    Arrange.DistanceFromCenter = [Arrange.DistanceFromCenter;...
        round( sqrt( x(1)^2 +  y(1)^2 ) , 1) ];
    
%     for j = 1:length(x)
%         
%         if x(j) < 0
%             Vector = [Vector;  ([-7,0,0] - [x(j), y(j) , z(j) ]) ];
%         else
%             Vector = [Vector;  ([7,0 ,0] - [x(j),  y(j), z(j) ]) ];
%         end  
%     
%     end 
    
    plot3(x, y, z, '.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', colorNew( i, :) )

    text(  x(1)-4 , y(1)-3 , z(1)- i*2.5, ...
    join([ num2str( round(Arrange.VectorAngles(i),0) ), char(176) ]),'FontSize', 12)

    
%     quiver3(x, y, z, Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
%      0, 'Color', colorNew(i, : ), 'LineWidth', 2 )


   
    Vx = Vector(:,1);       Vy =  Vector(:,2);      Vz =  Vector(:,3);
    
%     for qi = 1:3
%     quiver3(x(qi) , y(qi) , z(qi) , Vx(qi) , Vy(qi) , Vz(qi) , ...
%          0, 'Color', colorNew(i, : ), 'LineWidth', 2 )
    
         quiver3(x, y, z, Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
     0, 'Color', colorNew(i, : ), 'LineWidth', 2 )
 
 if plotAblation == "TRUE"
    for ki = 1:2
     %Create the ablation volume
        radius = 40 /2;
        long_axis = 55 /2; 
        %
        shift = [-radiusSrt,+radiusSrt  ];
            
        [X,Y,Z] = ellipsoid(CenterX+shift(ki) , CenterY , 30 ,...
        radius ,radius,  long_axis );
        X = reshape(X,[],1);
        Y = reshape(Y,[],1);
        Z = reshape(Z,[],1);
        
        if ki == 2
            psiAngle =  [0,180 - 10*(i-1) ];
            thetaAngle = [0, 180- 10*(i-1)];  
        else
            psiAngle =  [0,180 + 10*(i-1) ];
            thetaAngle = [0, 180+ 10*(i-1)];  
        end 
        
        %rearrange the points
        YP =  YawPitch(psiAngle, thetaAngle); 
        P = [X,  Y, Z ];
        C = [YP*P']' ; 
        P = C -  mean(C);
    
        %AblationCenter = mean([X,Y,Z]); 
        newCenter =  mean(P) - [CenterX+shift(ki) , CenterY , 25] ;
        
        X2 = P(:,1) + newCenter(1);
        Y2 = P(:,2) ;
        Z2 = P(:,3) + newCenter(3);
        

        [k, vol] = boundary([X2,Y2,Z2], 0 );
        hold on

        trisurf(k, X2 , Y2 , Z2 ,'Facecolor', colorNew(i, : )  ,'FaceAlpha',.5 ,...
            'EdgeColor', 'none' )
        hold off
        
    end

        
        
    end 
     
  
     pause(1)
%     end 






    %Create vectors along the points
%     quiver3( 0 , 0  , 0,   x,  z ,  y  ,  'linewidth', 2) 
camlight
end
% plot3(0 , -7, 0, 'k+', 'LineWidth', 3, 'MarkerSize', 14);
% plot3(0 , 7, 0, 'k+', 'LineWidth', 3, 'MarkerSize', 14);
% plot3(7 , 0, 0, 'k+', 'LineWidth', 3, 'MarkerSize', 14);
% plot3(-7 , 0, 0, 'k+', 'LineWidth', 3, 'MarkerSize', 14);

% 
% slct  = 1; 
% for i = 1:length(angles)
%     
%     plot3( Target.x(i) , Target.y(i), Target.z(i), '+', 'Color',TargetColor(slct, :)  ,'LineWidth', 3, 'MarkerSize', 14)
%     hold on
%     
%     slct = slct +1;
%     if slct >= length(angles)/2
%         slct = 1;
%     end 
%     
% end 


%%




%FAILED CODE

 
%  maxRad = pi/3 ; 
%  VectorAll = [];
% %Plot vector 
% figure()
% for zi = 1:5
%     zz = zi*4;
%     for i = 1:5
%         for j = 1:5
% 
%         PlaceX = 10 + i ; 
%         PlaceY = j;
%         PlaceZ = i;
% 
% 
%         theta = 90+ maxRad*((i-1)/(10-1)) ;
%         [x, y] = pol2cart(theta, 1) ; 
%         x = x*(1+ i/10);
%         y = y*(1+ i/10);
%         v = sqrt( x.^2 + y.^2);
%         %Plot Data
%         quiver3( 0 , 0  , 0,   x,  zz ,  y  ,  'linewidth', 2) 
%         hold on
%         VectorAll = [ VectorAll; x , y , 0 ] ;
%         end 
%     end 
% end 
% ylabel("Y")
% xlabel("X")
% zlabel("Z")
% set(gcf,'color','w');
% 
% title("Probe Placement Phantom Strategy")
% 
% %%
% 
% for zi = 1:10
%     zz = i;
%     for i = 1:5
%         for j = 1:5
% 
%         PlaceX = 10 - i ; 
%         PlaceY = j;
%         PlaceZ = i;
% 
% 
%         theta = 90+  maxRad*((i-1)/(10-1)) ;
%         [x, y] = pol2cart(theta, 1) ; 
%         x = x*(1+ i/10);
%         y = y*(1+ i/10);
%         v = sqrt( x.^2 + y.^2);
%         %Plot Data
%         quiver3( 0,  0 , 0,   -x,  -zz ,  -y  ,  'linewidth', 2) 
%         hold on
%         VectorAll = [ VectorAll; x , y , 0 ] ;
%         end 
%     end 
% end 
% 
% grid on;
% axis equal;
% ylabel("Y")
% xlabel("X")
% zlabel("Z")
% set(gcf,'color','w');