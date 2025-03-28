%Load Data
clear 
close all
%Load in the tumor data
tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Vanderbilt_017_Tumor_remeshed.stl";
TumorData = stlread(tumorfile);
TumorPoints.Points = TumorData.Points;
%Create a PDE Mesh Model
TumorPoints.model = createpde;
importGeometry( TumorPoints.model  , tumorfile);
TumorPoints.mesh = generateMesh( TumorPoints.model );



%Split the tumor into two sections along the x axis. 
trueCenter = [221, 260, 182];
TumorPoints.Points  = rotateZalongPoint(TumorPoints.Points , 90 , trueCenter ) ; 
 

TumorPoints.centerOne = mean(TumorPoints.Points);

TumorDataTri = delaunayTriangulation( TumorPoints.Points(:,1)  , TumorPoints.Points(:,2)...
                          , TumorPoints.Points(:,3));



%Load in the ablation volume 

Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"];    
colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];
    
selectfile = convertStringsToChars(Patient(4)); 
fileName = SelectAblationBoundaryPoints( 4 , selectfile ) ;
BoundaryPoints.og = readtable(fileName);
BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:));
i = 15*4;
X = BoundaryPointsMatrix(2:end, ((i-1)*3 + 1) );
X(X == 0) = [];
Y = BoundaryPointsMatrix(2:end, ((i-1)*3 + 2) );
Y(Y == 0) = [];
Z = BoundaryPointsMatrix(2:end, ((i-1)*3 + 3) );
Z(Z == 0) = [];
Y = Y +3;
BoundaryPoints.pts= [X,Y,Z];

BoundaryPointsTri = delaunayTriangulation( X,Y,Z)  ; 

%%
itime = 60;



%Trinagulation
BoundaryPointsTri = delaunayTriangulation( BoundaryPoints.pts(:,1) ,...
    BoundaryPoints.pts(:,2) ,BoundaryPoints.pts(:,3))  ; 
TumorDataTri = delaunayTriangulation( TumorPoints.Points(:,1),...
    TumorPoints.Points(:,2) , TumorPoints.Points(:,3));
                      
%%%
%in Polyhedron: Find Tumor Points in Ablation                      
[Sablation.faces, Sablation.vertices] = freeBoundary(BoundaryPointsTri);
points = TumorPoints.Points ;
tic
in1 = in_polyhedron(Sablation, points);
fprintf('Number of points inside is %i, outside is %i. Calculation time: %f sec\n', ...
  nnz(in1), nnz(in1==0), toc);
Sablation.shp = alphaShape(BoundaryPoints.pts, 30 );

%%%%
%in Polyhedron: Find Ablation Points in tumor
[STumor.faces, STumor.vertices] = freeBoundary(TumorDataTri);
points2 = BoundaryPoints.pts;
tic
in2 = in_polyhedron(STumor, points2);
fprintf('Number of points inside is %i, outside is %i. Calculation time: %f sec\n', ...
  nnz(in2), nnz(in2==0), toc);

% STumor.Ogshp  = alphaShape( points , 10 );
% figure()
% pdemesh(TumorPoints.model, 'FaceColor','g' ,'FaceAlpha', 0.25  ,'EdgeColor', 'g') 
TumorPoints.mVol = volume(TumorPoints.mesh)/1000; 
% title( join(["Vol =", num2str(TumorPoints.mVol) ])) 


%Find the ablated tissue 
AblatedTissue.pts  =[  [points( in1,1), points( in1,2), points( in1,3)];...
   [points2( in2,1),points2( in2,2),points2( in2,3)]  ] ; 
AblatedTissue.shp = alphaShape(AblatedTissue.pts , 30 );

%Tumor that is not ablated
STumor.remainderpts = [ points(~in1,1),points(~in1,2),points(~in1,3) ]  ; 
STumor.remainderShp = alphaShape( STumor.remainderpts , 8);
STumor.remainderTri = delaunayTriangulation( points(~in1,1),points(~in1,2),points(~in1,3) );
[STumor2.faces, STumor2.vertices] = freeBoundary( STumor.remainderTri );




%       Plot the results
figure()
set(gcf,'color','w');
axis vis3d equal;
axis off
grid off
lighting phong;
hold on, view(3)        %                                                   Display the result
set(gcf, 'Position', get(gcf, 'Position').*[0 0 1.5 1.5])

%                                                                           Plot the delauny tri of tumor not ablated
% patch(STumor2,'FaceColor','g','FaceAlpha',0.2)
p1 = plot(STumor.remainderShp   ,'FaceColor', rgb('Maroon')  ,'FaceAlpha', 0.25  ,'EdgeAlpha', .15 );
p1.Annotation.LegendInformation.IconDisplayStyle = 'off';

%                                                                           Plot the ablation volume
p2 = plot(Sablation.shp  ,'FaceColor','r' ,'FaceAlpha', 0.25  ,'EdgeAlpha', .01 );
% p2.Annotation.LegendInformation.IconDisplayStyle = 'off';

% plot3(points( in1,1),points( in1,2),points( in1,3),'bo','MarkerFaceColor','b')
% plot3(points2( in2,1),points2( in2,2),points2( in2,3),'bo','MarkerFaceColor','b')

plot3(BoundaryPoints.pts(:,1),BoundaryPoints.pts(:,2), BoundaryPoints.pts(:,3),'k.','MarkerSize',5)   

%                                                                           Plot the tissure that was ablated
% plot3( AblatedTissue.pts(:,1) , AblatedTissue.pts(:,2) , AblatedTissue.pts(:,3)...
%     , 'o' ,'MarkerFaceColor', rgb('Maroon'), 'MarkerSize', 3)
% p3 = plot(AblatedTissue.shp ,'FaceColor','r' ,'FaceAlpha', 0.25  ,'EdgeAlpha', .15 );
% p3.Annotation.LegendInformation.IconDisplayStyle = 'off';

plot3(points(~in1,1),points(~in1,2),points(~in1,3),'k.','MarkerSize',5), axis image
% legend({'volume', 'Ablated Tumor', 'Tumor Remainder'}, 'Location', 'southoutside')

%                                                                           Calculate all the ablation volume
%                                                                           Calculate the Time
abTime.total = itime*1 ;
abTime.sec = mod(abTime.total,1)*(60/100)*100 ; 
abTime.min = floor(itime/4);  %abTime.total - mod(abTime.total,4);


Vol1 = ( TumorPoints.mVol );
Vol2 = volume( AblatedTissue.shp  )/1000; 
Vol3 = Vol1 - Vol2;


title( join([ "Time = ",num2str(abTime.min), 'm  ', num2str(abTime.sec), "s",...
    newline,  "OG Vol = ",num2str( round( Vol1 ,2) )  ,"  |New Vol = ", round( Vol3,2) ,...
    " Ablated Vol = ", num2str( round( Vol2 ,2) )  ])) 
set(gcf,'Position',[200 200 600 800])


%%

figure(1)
% [tumor.x1, tumor.y1,  tumor.z1] = sphere(50);
r = 20;


tumor.x1 = TumorPoints.Points(:, 1); 
tumor.y1 = TumorPoints.Points(:, 2); 
tumor.z1 = TumorPoints.Points(:, 3); 
P = [tumor.x1 tumor.y1 tumor.z1];

Tadd = [0 0 0];
query.qx = BoundaryPoints.pts(:,1) + Tadd(1);
query.qy = BoundaryPoints.pts(:,2) + Tadd(2);
query.qz = BoundaryPoints.pts(:,3) + Tadd(3);
Pablation = [query.qx query.qy query.qz ] ;

x = Pablation(:,1);
y = Pablation(:,2);
z = Pablation(:,3); 
%Establish the center of the tumor
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );



%P = unique(P,'rows');
% P = P + center' + [0 +10 0];



    plot3(P(:,1),P(:,2),P(:,3),'.')
    axis equal
    grid on

    set(gcf,'color','w');
    %
    shpAlph.shp = alphaShape(P(:,1),P(:,2),P(:,3),r);
    % plot(shp)
    axis equal
    %
    hold on 
%figure(2)
%Displacememtn matrix to position the ablation margin

%plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'.')
%
% shp = alphaShape(Pablation(:,1),Pablation(:,2),Pablation(:,3),20);
% plot(shp)
indx.in = inShape(shpAlph.shp,query.qx,query.qy,query.qz);

hold on
plot3(query.qx(indx.in),query.qy(indx.in),query.qz(indx.in),'r.','MarkerSize',20)
plot3(query.qx(~indx.in),query.qy(~indx.in),query.qz(~indx.in),'b.','MarkerSize',20)
title( join(["Tumor (Light Blue)", newline, "Intersection (Red)",...
    newline "Remainder Ablation Margin (Dark Blue)"]))
grid off
view( -40, 20 );
%


figure(2)
set(gcf,'color','w');
%%create alpha point
shpAlph.shp2 = alphaShape(Pablation(:,1),Pablation(:,2),Pablation(:,3),10); 
%plot(shp2)
%create query points 
query.qx2 = P(:,1);
query.qy2 = P(:,2);
query.qz2 = P(:,3);
%find the intersection 
indx.in2 = inShape(shpAlph.shp2, query.qx2, query.qy2, query.qz2 );

%plot the results
hold on
%PLOT whole ablation Margin 
plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'k.','MarkerSize',8)
%PLOT Exterior intersection of TUMOR MARGIN AND ABLATION VOLUME
%plot3(query.qx2(indx.in2),query.qy2(indx.in2),query.qz2(indx.in2),'r.','MarkerSize',20)
%plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
axis equal
view( -40, 20 );

chompedVolume = [ [query.qx2(~indx.in2), query.qy2(~indx.in2), query.qz2(~indx.in2)] ; ...
    [query.qx(indx.in), query.qy(indx.in), query.qz(indx.in)] ] ;
%
%CREATE A CHOMPED VOLUME
%Exterior and Interior of the Chomped Tumor  
%plot3(chompedVolume(:,1),chompedVolume(:,2),chompedVolume(:,3),'.')
%Alpha shape of the Chomped Tumor 
shp3 = alphaShape(chompedVolume(:,1),chompedVolume(:,2),chompedVolume(:,3),6); 

plot(shp3)
hold on 

%Interior Intersection between the Ablation Margins and the tumor
plot3(query.qx(indx.in),query.qy(indx.in),query.qz(indx.in),'r.','MarkerSize',20)
ylabel("Y")
xlabel("X")
zlabel("Z")
set(gcf,'color','w');
title( join(["Chomped Volume (Alpha Shape)", newline, "Ablation Volume (Black)"]) )
lighting phong;
%
%IF THE ABLATION MARGINS are too sparse, resample the margins. 
close all 
tic 


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
    shpAlph.shp2 = alphaShape(x,y, z,10); 
    
end 
    
    
    

plot3(currentc(:,1),currentc(:,2),currentc(:,3),'.')
hold on
plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'r.','MarkerSize',8)

ylabel("Y")
xlabel("X")
zlabel("Z")
set(gcf,'color','w');
title("Sampling Cube")
lighting phong;


figure(2)
set(gcf,'color','w');
%plot(shp2)
%create query points 
query.qx3 = currentc(:,1);
query.qy3 = currentc(:,2);
query.qz3 = currentc(:,3);
%find the intersection 
indx.in3 = inShape(shpAlph.shp2, query.qx3, query.qy3, query.qz3 );

%plot the results
hold on
plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'k.','MarkerSize',8)
plot3(query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3),'r.','MarkerSize',20)
% plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
axis equal
ylabel("Y")
xlabel("X")
zlabel("Z")
hold off
title("Intersection of the Sampling Cube and the Ablation Margins")
view( -40, 20 );
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
    figure()
    set(gcf,'color','w');
    %subplot(1,2,1)
    %PLOT the intersection of the ablation margins and the Sampling Cube. 
    scatter3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
       BoundaryPoints.kSortPoint(:,3),10, 'filled', 'k')
    axis equal
    
    %%create alpha point
    shpAlph.shp3 = alphaShape(BoundaryPoints.kSortPoint(:,1),...
        BoundaryPoints.kSortPoint(:,2),BoundaryPoints.kSortPoint(:,3),15); 
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
    hold on
    plot3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
        BoundaryPoints.kSortPoint(:,3),'k.','MarkerSize',8)
    plot3(query.qx2(indx.in4),query.qy2(indx.in4),...
        query.qz2(indx.in4),'r.','MarkerSize',20)
    plot3(query.qx2(~indx.in2),query.qy2(~indx.in2),query.qz2(~indx.in2),'b.','MarkerSize',20)
    title('Intersection of Ablation Volume and Tumor Exterior')
    ylabel("Y")
    xlabel("X")
    zlabel("Z")
    axis equal
    hold off    
    view( -40, 20 );
    

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
    %%
    figure()
    shp3 = alphaShape(chompedVolume2 (:,1),chompedVolume2 (:,2),chompedVolume2 (:,3),5); 
    plot(shp3)
    hold on 
    
    plot3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
    BoundaryPoints.kSortPoint(:,3),'k.','MarkerSize',8)   

    hold on
   
    plot3(query.qx4(indx.in5) , query.qy4(indx.in5),  query.qz4(indx.in5) ...
        ,'r.','MarkerSize',20)
    
    hold on
    plot3(chompedVolume2(:,1), chompedVolume2(:,2), chompedVolume2 (:,3), '.b','MarkerSize',20)
    
    ylabel("Y")
    xlabel("X")
    zlabel("Z")
    set(gcf,'color','w');
    title("Alpha Shape of the Chomped Volume")
    lighting phong;
    hold off
    
    toc