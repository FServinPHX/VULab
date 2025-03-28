


function [returnData] = AblationIntersection(TumorPointsOG , BoundaryPointsOG,r, itime, Color  ) 



% TumorPointsOG =  TumorPoints.Points ;
% BoundaryPointsOG = BoundaryPoints.new;
% r = 20;

tic 

tumor.x1 = TumorPointsOG(:, 1); 
tumor.y1 = TumorPointsOG(:, 2); 
tumor.z1 = TumorPointsOG(:, 3); 
P = [tumor.x1 tumor.y1 tumor.z1];


query.qx = BoundaryPointsOG(:,1) ;
query.qy = BoundaryPointsOG(:,2) ;
query.qz = BoundaryPointsOG(:,3) ;
Pablation = [query.qx query.qy query.qz ] ;

x = Pablation(:,1);
y = Pablation(:,2);
z = Pablation(:,3); 
%Establish the center of the tumor
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );



%P = unique(P,'rows');
% P = P + center' + [0 +10 0];



%     plot3(P(:,1),P(:,2),P(:,3),'.')
%     axis equal
%     grid on
% 
%     set(gcf,'color','w');
    %
    shpAlph.shp = alphaShape(P(:,1),P(:,2),P(:,3),r);
    % plot(shp)
%     axis equal
%     %
%     hold on 
%figure(2)
%Displacememtn matrix to position the ablation margin

%plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'.')
%
% shp = alphaShape(Pablation(:,1),Pablation(:,2),Pablation(:,3),20);
% plot(shp)
indx.in = inShape(shpAlph.shp,query.qx,query.qy,query.qz);

% hold on
% plot3(query.qx(indx.in),query.qy(indx.in),query.qz(indx.in),'r.','MarkerSize',20)
% plot3(query.qx(~indx.in),query.qy(~indx.in),query.qz(~indx.in),'b.','MarkerSize',20)
% title( join(["Tumor (Light Blue)", newline, "Intersection (Red)",...
%     newline "Remainder Ablation Margin (Dark Blue)"]))
% grid off
% view( -40, 20 );
%

% 
% figure(2)
% set(gcf,'color','w');
%%create alpha point
shpAlph.shp2 = alphaShape(Pablation(:,1),Pablation(:,2),Pablation(:,3), 20 ); 
%plot(shp2)
%create query points 
query.qx2 = P(:,1);
query.qy2 = P(:,2);
query.qz2 = P(:,3);
%find the intersection 
indx.in2 = inShape(shpAlph.shp2, query.qx2, query.qy2, query.qz2 );

%plot the results
% hold on
%PLOT whole ablation Margin 
% plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'k.','MarkerSize',8)
%PLOT Exterior intersection of TUMOR MARGIN AND ABLATION VOLUME
%plot3(query.qx2(indx.in2),query.qy2(indx.in2),query.qz2(indx.in2),'r.','MarkerSize',20)
%plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
% axis equal
% view( -40, 20 );

chompedVolume = [ [query.qx2(~indx.in2), query.qy2(~indx.in2), query.qz2(~indx.in2)] ; ...
    [query.qx(indx.in), query.qy(indx.in), query.qz(indx.in)] ] ;
%
%CREATE A CHOMPED VOLUME
%Exterior and Interior of the Chomped Tumor  
%plot3(chompedVolume(:,1),chompedVolume(:,2),chompedVolume(:,3),'.')
%Alpha shape of the Chomped Tumor 
shp3 = alphaShape(chompedVolume(:,1),chompedVolume(:,2),chompedVolume(:,3),6); 

% plot(shp3)
% hold on 

%Interior Intersection between the Ablation Margins and the tumor
% plot3(query.qx(indx.in),query.qy(indx.in),query.qz(indx.in),'r.','MarkerSize',20)
% ylabel("Y")
% xlabel("X")
% zlabel("Z")
% set(gcf,'color','w');
% title( join(["Chomped Volume (Alpha Shape)", newline, "Ablation Volume (Black)"]) )
% lighting phong;
%
%IF THE ABLATION MARGINS are too sparse, resample the margins. 
% close all 
% tic 


x = Pablation(:,1);
y = Pablation(:,2);
z = Pablation(:,3); 

%Create a 3D sample grid
for i = 1:2
    
    

    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

    sample.x = [(radii(1)*-1.4):1.5:(radii(1)*1.4) ] + center(1);
    sample.y = [(radii(3)*-1.4):1.5:(radii(3)*1.4)] + center(2);
    sample.z = [(radii(2)*-1.4):1.5:(radii(2)*1.4)] + center(3);

    [X,Y,Z] = meshgrid(sample.x,sample.y,sample.z);
    X = reshape(X, [],1);
    Y = reshape(Y, [],1);
    Z = reshape(Z, [],1);
    currentc = [];
    currentc = [X,Y,Z];
    
    %create query points 
    query.qx3 = currentc(:,1);
    query.qy3 = currentc(:,2);
    query.qz3 = currentc(:,3);
    %find the intersection 
    indx.in3 = inShape(shpAlph.shp2, query.qx3, query.qy3, query.qz3 );

    BoundaryPoints.reasampleAblation = [Pablation(:,1),Pablation(:,2),Pablation(:,3);...
        query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3)];
    k = boundary(BoundaryPoints.reasampleAblation, .5  );
    BoundaryPoints.k = reshape(k,[],1);
    BoundaryPoints.kSort = unique(BoundaryPoints.k);
    BoundaryPoints.kSortPoint = BoundaryPoints.reasampleAblation(BoundaryPoints.kSort,:); 

    %Create New Points, Create New Alpha Shape
    x =  BoundaryPoints.kSortPoint(:,1);
    y =  BoundaryPoints.kSortPoint(:,2);
    z =  BoundaryPoints.kSortPoint(:,3);
    shpAlph.shp2 = alphaShape(x,y, z, 15); 
    
end 
    
    
    

% plot3(currentc(:,1),currentc(:,2),currentc(:,3),'.')
% hold on
% plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'r.','MarkerSize',8)
% 
% ylabel("Y")
% xlabel("X")
% zlabel("Z")
% set(gcf,'color','w');
% title("Sampling Cube")
% lighting phong;


% figure(2)
% set(gcf,'color','w');
%plot(shp2)
%create query points 
query.qx3 = currentc(:,1);
query.qy3 = currentc(:,2);
query.qz3 = currentc(:,3);
%find the intersection 
indx.in3 = inShape(shpAlph.shp2, query.qx3, query.qy3, query.qz3 );

% %plot the results
% hold on
% plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'k.','MarkerSize',8)
% plot3(query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3),'r.','MarkerSize',20)
% % plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
% axis equal
% ylabel("Y")
% xlabel("X")
% zlabel("Z")
% hold off
% title("Intersection of the Sampling Cube and the Ablation Margins")
% view( -40, 20 );
%
%IF THE BOUNDARY POINTS ARE SPARSE, HERE IS A CODE TO RESAMPLE THE DATA
%POINTS 
 %
    BoundaryPoints.reasampleAblation = [Pablation(:,1),Pablation(:,2),Pablation(:,3);...
        query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3)];
    k = boundary(BoundaryPoints.reasampleAblation, .5  );
    BoundaryPoints.k = reshape(k,[],1);
    BoundaryPoints.kSort = unique(BoundaryPoints.k);
    BoundaryPoints.kSortPoint = BoundaryPoints.reasampleAblation(BoundaryPoints.kSort,:); 

    %
    %%Plotting Function
%     figure()
%     set(gcf,'color','w');
%     %subplot(1,2,1)
%     %PLOT the intersection of the ablation margins and the Sampling Cube. 
%     scatter3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
%        BoundaryPoints.kSortPoint(:,3),10, 'filled', 'k')
%     axis equal
    
    %%create alpha point
    shpAlph.shp3 = alphaShape(BoundaryPoints.kSortPoint(:,1),...
        BoundaryPoints.kSortPoint(:,2),BoundaryPoints.kSortPoint(:,3), 20 ); 
%     plot(shpAlph.shp3)
    
    %Find the intersection between the Ablation and Sampling Cube
    indx.in4 = inShape(shpAlph.shp3, query.qx2, query.qy2, query.qz2 );
    %Find the intersection between the Sampling Cube and Ablation
    indx.in5 = inShape(shpAlph.shp, BoundaryPoints.kSortPoint(:,1),...
        BoundaryPoints.kSortPoint(:,2), BoundaryPoints.kSortPoint(:,3) );
    
    query.qx4 = BoundaryPoints.kSortPoint(:,1);
    query.qy4 = BoundaryPoints.kSortPoint(:,2);
    query.qz4 = BoundaryPoints.kSortPoint(:,3);

    %plot the results
%     hold on
%     plot3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
%         BoundaryPoints.kSortPoint(:,3),'k.','MarkerSize',8)
%     plot3(query.qx2(indx.in4),query.qy2(indx.in4),...
%         query.qz2(indx.in4),'r.','MarkerSize',20)
%     plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
%     title('Intersection of Ablation Volume and Tumor Exterior')
%     ylabel("Y")
%     xlabel("X")
%     zlabel("Z")
%     axis equal
%     hold off    
%     view( -40, 20 );
    

%Add the points that are sampled from the exterior CHOMPED tumor and
%interior CHOMPED TUMOR
chompedVolume2 = [ [query.qx2(~indx.in4), query.qy2(~indx.in4), query.qz2(~indx.in4)] ; ...
    [query.qx4(indx.in5), query.qy4(indx.in5), query.qz4(indx.in5)] ] ;
%
%CREATE A CHOMPED VOLUME
%New Figure 
%     figure()    
%     plot3(chompedVolume2 (:,1),chompedVolume2 (:,2),chompedVolume2 (:,3),'-b')
%     axis('equal')
%     title('Point Cloud of the chomped volume')
%     set(gcf,'color','w');

% figure()
sRadi = 8 - (2.5*itime)/60; 
% sRadi = 5;

shp3 = alphaShape(chompedVolume2 (:,1),chompedVolume2 (:,2),chompedVolume2 (:,3), sRadi ); 
plot(shp3,'FaceColor',Color ,'FaceAlpha', 0.25  ,'EdgeAlpha', .15 )


hold on 

plot(shpAlph.shp2,'FaceColor','r' ,'FaceAlpha', 0.15, 'EdgeAlpha', .15 )


plot3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
BoundaryPoints.kSortPoint(:,3),'k.','MarkerSize',4)   

hold on

plot3(query.qx4(indx.in5) , query.qy4(indx.in5),  query.qz4(indx.in5) ...
    ,'r.','MarkerSize', 8 )

hold on
plot3(chompedVolume2(:,1), chompedVolume2(:,2), chompedVolume2 (:,3), '.b','MarkerSize', 8 )


abTime.total = itime*1 ;
abTime.sec = mod(abTime.total,1)*(60/100)*100 ; 
abTime.min = floor(itime/4);  %abTime.total - mod(abTime.total,4);
     


%Plot the results
        
set(gcf,'color','w');
axis vis3d equal;
axis off
grid off
lighting phong;
set(gcf,'Position',[200 200 600 800])


Vol1 = volume(shpAlph.shp)/1000;
Vol2 = volume( shp3 )/1000; 
Vol3 = Vol1 - Vol2;

title( join([ "Time = ",num2str(abTime.min), 'm  ', num2str(abTime.sec), "s",...
    newline, " Ablated Vol = ", num2str( round( Vol3 ,2) )  ])) 
%     newline,"Alpha Shape of the Chomped Volume", newline,...   
%     "OG Vol = ",num2str( round( Vol1 ,2) )  ,"  |New Vol = ", round( Vol2,2) ,...



% hold off

toc

%Enter all the data that I want to return
returnData.shp = shp3;
returnData.BoundaryPoints = BoundaryPoints.kSortPoint;
returnData.NotInterect = [query.qx4(indx.in5) , query.qy4(indx.in5),  query.qz4(indx.in5)];
returnData.chompedVolumeP = chompedVolume2;

%reutrn Volume Data

returnData.TumorVolume = [ Vol1,  Vol2, Vol3 ] ;

end 