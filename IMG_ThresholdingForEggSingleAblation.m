
clear
%I = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Multiprobe 3 Segmentation System.PNG");
%I = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Grayscale with SegmentationWtIntBlackSquare.png");
%I = imread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Ablation Phantom Study\Ablation No 1 __ 2% Agar\AgarAblationVanillaFilter #2.png");
I = imread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Ablation Phantom Study\Beef Ablation Study\Image Segmetation.png");
I = rgb2gray(I);
% I = histeq(I);


%I2 = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Multiprobe (2).PNG");
%I2 = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Grayscale with Segmentation.png");
%I2 = imread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Ablation Phantom Study\Ablation No 1 __ 2% Agar\Ablation Ablation Side 1 with image.png");
I2 = imread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Ablation Phantom Study\Beef Ablation Study\Image Segmetation.png");
I2 = rgb2gray(I2);
I2 = histeq(I2);

%%
[imagePoints,boardSize] = detectCheckerboardPoints(I);

set(gcf,'color','w');
J = insertText(I,imagePoints,1:size(imagePoints,1), 'FontSize', 15);
J = insertMarker(J,imagePoints,'o','Color','red','Size', 15);
imshow(J);


hold on
Distance = [];
%Checkerboard Dimension in Milimeters; 
%Dim 4-Square = 7.11    6-Square = 4.69
CheckerboardDim = 7.11  ;

for i = 1:length(imagePoints)-1
% 
%     plot( imagePoints(i,1), imagePoints(i,2), 'r.', 'MarkerSize', 20)
%     
%     pause(.2)
    Distance = [Distance,  sqrt( (imagePoints(i,1) - imagePoints(i+1,1))^2 ...
                + (imagePoints(i,2) - imagePoints(i+1,2))^2) ] ;

end 
Distance(Distance > Distance(1)*1.2) = [];
AvgPixelDist  = mean(Distance);
PixelToDim = CheckerboardDim/ mean(Distance); 
hold off;

title(join([ sprintf('Detected a %d x %d Checkerboard',boardSize),...
    newline, "Each Pixel =", num2str(PixelToDim), "mm"]), 'FontSize', 18 );
%%
% imwrite(I, "C:\Users\servinf\Pictures\Ablation Experiment Images\GrayScale Image.jpg", 'jpg');
figure()
subplot(2,2,1)
imshow(I2)
title("Orignal Image")


subplot(2,2,2)
imhist(I)
% ylim([ 0  600] )
title("Image Histogram")


subplot(2,2,3)
imshow(I)
title("Segment Images With Mask")


% I2 = histeq(I);
% figure
% imshow(I2)
% 
% 
% figure()
% BW = im2bw(I2,0.75);
% imshow(BW)

thresh = multithresh(I,4);
seg_I = imquantize(I,thresh);
RGB = label2rgb(seg_I);


subplot(2,2,4)
imshow(RGB)
axis off
title('RGB Segmented Image')


seg_I2 = imquantize(I,thresh(3));
RGB2 = label2rgb(seg_I2);


subplot(2,2,4)
imshow(RGB)
axis off
title(join(["RGB Segmented Image", newline ,"What We Want to Keep"]))
set(gcf,'color','w');

% I = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Grayscale with SegmentationWtInt.png");
% I = rgb2gray(I);
figure()

subplot(2,2,1)
imshow(I)
title("Original Image")
axis on

subplot(2,2,2)
imhist(I)
title("Original Image Histogram")

subplot(2,2,3)
% I = histeq(I);
imhist(I)
title("Original Image Equal Histogram")

subplot(2,2,4)
[m,n] = size(I)
% I = imcrop(I,[ round(m*.1, 0), round(m*.9, 0),...
%     round(n*.1, 0),   round(n*.9, 0)]);
% I = imcrop(I, [ round(m*.05, 0),  round(n*.05, 0), ...
%       round(n*1.0, 0), round(m*.85, 0)])

[L,Centers] = imsegkmeans(I,5);
B = labeloverlay(I,L);
imshow(B)
title("Labeled Image")
axis on

%%

%                                                              THRESHOLDING

tic 
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0]; 

colors = [green; red;  blue; orange; purple; gold;  black];
    
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'

figure()
subplot(3 ,2,1)

kmeansThresh = 4;
[L,Centers] = imsegkmeans(I,kmeansThresh);
B = labeloverlay(I,L);
imshow(B)
title("Labeled Image for Ablation Square")
axis equal

set(gcf,'color','w');
set(gca,'FontSize',14)
set(gcf,'position',[100,100,800,900])

xyMatrix = zeros(1000,( kmeansThresh+1)*2);
xyMatrixEqualized = zeros(1000,( kmeansThresh+1)*2);
%%Iteratively plot to find the best threshold for the image
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\fitellipse'



for jj = 1:2
    
    
    if jj == 2
      figure()
      subplot(3 ,2,1)
      kmeansThresh = 4;
      I2 =  histeq(I2);
      [L,Centers] = imsegkmeans(I2 ,kmeansThresh);      
      B = labeloverlay(I2,L);
      imshow(B)

      title("Equal Histogram IMG  for Ablation Shape")
      axis equal
      set(gcf,'color','w');
      set(gca,'FontSize',14)
      set(gcf,'position',[200,100,800,900])
    end 
    
for i = 1:kmeansThresh + 1
    
    
    subplot(3, 2, i +1 )
    thresh = i;
    m= double(L) ; % Sample data
    linearIndexes = find(m == thresh) ; % Find elements with value more than 8
    [pointcloud.rows, pointcloud.columns] = ind2sub(size(m), linearIndexes) ;
    plot(pointcloud.columns, pointcloud.rows , '.') 
    title( join(["Thresh = ", num2str(thresh) ]) )
    axis equal
   
    hold on
    k = boundary( pointcloud.columns, pointcloud.rows, 1);
    hold on;
    plot(pointcloud.columns(k), pointcloud.rows(k), 'LineWidth', 4 );
    axis equal
    if jj == 1
    xyMatrix(1:length(pointcloud.columns(k)), ( ((i-1)*2+1):((i-1)*2+2)) ) ...
        = [pointcloud.columns(k), pointcloud.rows(k)];
    elseif jj == 2
      xyMatrixEqualized(1:length(pointcloud.columns(k)), ( ((i-1)*2+1):((i-1)*2+2)) ) ...
        = [pointcloud.columns(k), pointcloud.rows(k)];
    end 


    
end
end 


cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'

toc

%%

%ThreshSelect = [ threshold for square, threshold for ablation];
ThreshSelect = [2,2];
% Scale = 1*32.15 ; % 1*x cm
Scale = 1*30.3;

xyMatrix(xyMatrix == 0 ) = NaN; 
cubeX = rmmissing(xyMatrix(:, (ThreshSelect(1)*2)-1 )); 
cubeY = rmmissing(xyMatrix(:, (ThreshSelect(1)*2) )); 
[k, area] = boundary(cubeX, cubeY);
%Cubuic Dimension = 1stDimention.^3/(repCM)
SingleDim = Scale/sqrt(area);           %PixelToDim; %Scale/sqrt(area);
CubicDimension = SingleDim^3;
figure()
plot(cubeX, cubeY, '.b')
hold on 
plot(cubeX(k), cubeY(k))
set(gcf,'color','w');
title(join([ "Measurement Cube", newline, "Area =", ...
    num2str(area*(SingleDim^2)), "cm^{2}" ]) )
axis equal
%%

n1 = 300;            % circle points
n2 = 200;            % number of circles
% [x,y] = pol2cart(linspace(0,2*pi,n1),9);    % data for a circle
xyMatrixEqualized(xyMatrixEqualized == 0 ) = NaN; 
x = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2-1)) ; 
y = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2)) ; 

% figure()
% plot(x, y)

centerOG = [mean(x) , mean(y)*1.05];


figure()
hplot.X =  [];
hplot.Y = [];
hplot.Z = [];

for hi = 1:1
    x = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2-1)) ; 
    y = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2)) ; 
    mult = 1.0;
%     if hi ==1
%         
%        k = find(x > centerOG(1) );
%        x = x(k);
%        y = y(k);
%        mult = .9;
%        
%     elseif hi == 2
%        k = find(x < centerOG(1) );
%        x = x(k);
%        y = y(k);
%        mult = 1.2;
%         
%     end 
    
    center = [mean(x)*mult , mean(y)];
    

h = zeros(1,n2);                            % objects for each circle
set(gcf,'color','w');
ax = axes;
h(1) = plot(x,y);                           % plot circle
for i = 2:n2
    h(i) = copyobj(h(i-1),ax);              % copy previous object
    rotate(h(i),[1 0 0], 2 ,[center(1) center(2) 0]);      % rotate object about [1 0.5 0] vector 15 degree (degree/rotations) 5/40
end
hplot.Xtemp = cell2mat(get(h(2:end),'xdata'));
hplot.Ytemp = cell2mat(get(h(2:end),'ydata'));
hplot.Ztemp = cell2mat(get(h(2:end),'zdata'));

if hi == 1
    hplot.X1 =  hplot.Xtemp(:); 
    hplot.Y1 =  hplot.Ytemp(:);
    hplot.Z1 =  hplot.Ztemp(:);
    
    k = boundary([ hplot.X1 ,hplot.Y1,hplot.Z1  ] ,0);
    BoundaryPoints.k = reshape(k,[],1);
    BoundaryPoints.kSort = unique(BoundaryPoints.k);
    
    hplot.X1 = hplot.X1(BoundaryPoints.kSort);
    hplot.Y1 = hplot.Y1(BoundaryPoints.kSort);
    hplot.Z1 = hplot.Z1(BoundaryPoints.kSort);
    
elseif hi == 2
    hplot.X2 =  hplot.Xtemp(:); 
    hplot.Y2 =  hplot.Ytemp(:);
    hplot.Z2 =  hplot.Ztemp(:);  
    
    
    k = boundary([ hplot.X2, hplot.Y2 ,hplot.Z2  ] ,1);
    BoundaryPoints.k = reshape(k,[],1);
    BoundaryPoints.kSort = unique(BoundaryPoints.k);
    
    hplot.X2 = hplot.X2(BoundaryPoints.kSort);
    hplot.Y2 = hplot.Y2(BoundaryPoints.kSort);
    hplot.Z2 = hplot.Z2(BoundaryPoints.kSort);
    
end 

hplot.X = [hplot.X ; hplot.Xtemp(:) ];
hplot.Y = [hplot.Y ; hplot.Ytemp(:) ];
hplot.Z = [hplot.Z  ; hplot.Ztemp(:) ];

end 

% hplot.X = [ hplot.X1 ; hplot.X2 ];
% hplot.Y = [ hplot.Y1 ; hplot.Y2 ];
% hplot.Z = [ hplot.Z1 ; hplot.Z2  ];


figure()
plot3( hplot.X , hplot.Y, hplot.Z , '.b', 'MarkerSize', .1 )
%
set(h(1),'color','black','linewidth',3)       % highlight original circle
hold on
% quiver(0,0,10,5,'linewidth',3)              % draw vector of rotation
ylabel("Y")
xlabel("X")
zlabel("Z")
title("Revolved Shape of the Ablation Zone")


set(gcf,'color','w');
axis vis3d equal;
grid on
camlight;
lighting phong;
view( 15, -2 )

pause(5) 
close()
close()

%%


shp1 = alphaShape(hplot.X1 , hplot.Y1 , hplot.Z1,inf, 'HoleThreshold',10  );       % inf - generate convex hull
figure()
plot(shp1)
% shp2 = alphaShape(hplot.X2 , hplot.Y2 , hplot.Z2,inf, 'HoleThreshold',10  );


% id1=inShape(shp2, hplot.X1 , hplot.Y1 , hplot.Z1);
% id2=inShape(shp1, hplot.X2 , hplot.Y2 , hplot.Z2);
% 
% shp3=alphaShape([hplot.X1(id1); hplot.X2(id2)], ...
%     [ hplot.Y1(id1) ; hplot.Y2(id2)],...
%     [ hplot.Z1(id1) ; hplot.Z2(id2)]);
set(gcf,'color','w');
Vol = volume(shp1)*(CubicDimension)/1000; %(volume(shp1) + volume(shp2) - volume(shp3))/(CubicDimension*10);
title("Alpha Shape Volume")


figure()

plot3(hplot.X1 , hplot.Y1 , hplot.Z1, '.k' , 'MarkerSize', .25 )
hold on
% plot3( hplot.X2 , hplot.Y2 , hplot.Z2, '.k' , 'MarkerSize', .25 )

plot(shp1,'FaceColor','green' ,'EdgeAlpha', .2 ,   'FaceAlpha',0.2)
% plot(shp2,'FaceColor','green' ,'EdgeAlpha', .2 , 'FaceAlpha',0.2)
% plot(shp3,'FaceColor','red' , 'EdgeAlpha', .1 , 'FaceAlpha',1 )
plot3(centerOG(1), centerOG(2), 0, '.r','MarkerSize', 20 )



%
% P = [X(:),Y(:),Z(:)];
% j = boundary(P,0);
% plot3(P(:,1),P(:,2),P(:,3),'.','MarkerSize',10)
% hold on
% trisurf(j,P(:,1),P(:,2),P(:,3),'FaceColor','red','FaceAlpha',0.1)
axis equal

set(gcf,'color','w');
set(gcf,'position',[480,280,600,600]) 
title( join(["3D Volume of Ablation Margin",...
    newline, "Volume =", num2str(round(Vol,3)) , "cm^3"    ])  )



axis vis3d equal;
grid on
camlight;
lighting phong;


BoundaryPointsALL = [hplot.X1 , hplot.Y1 , hplot.Z1];
resultsDir = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\Multiprobe\Results'
exportBoundaryTitle = fullfile(resultsDir, join(["Beef Ablation Boundary.csv" ]) ) ;
writematrix( BoundaryPointsALL, exportBoundaryTitle) ; 
    
%%
% figure()

% n1 = 300;            % circle points
% n2 = 50;            % number of circles
% xyMatrixEqualized(xyMatrixEqualized == 0 ) = NaN; 
% x = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2-1)) ; 
% y = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2)) ; 
% center = [mean(x) , mean(y)*1.05];
% 
% h = zeros(1,n2);                            % objects for each circle
% ax = axes;
% h(1) = plot(x,y);                           % plot circle
% for i = 2:n2
%     h(i) = copyobj(h(i-1),ax);              % copy previous object
%     rotate(h(i),[0 1 0], 5 ,[center(1) center(2) 0]);      % rotate object about [1 0.5 0] vector 15 degree (degree/rotations) 5/40
% end
% set(h(1),'color','black','linewidth',3)       % highlight original circle
% hold on
% X = cell2mat(get(h(2:end),'xdata'));
% Y = cell2mat(get(h(2:end),'ydata'));
% Z = cell2mat(get(h(2:end),'zdata'));
for i = 1:1
    
    if i == 1
        X = hplot.X1;
        Y = hplot.Y1;
        Z = hplot.Z1;
    elseif i == 2
        X = hplot.X2;
        Y = hplot.Y2;
        Z = hplot.Z2;        
    end 

    figure()
    shp = alphaShape(X(:),Y(:),Z(:), inf); 

    %
    x = shp.Points(:,1) ;
    y = shp.Points(:,2) ;
    z = shp.Points(:,3) ;
    plot3(x, y, z, '.k','MarkerSize', .1 )
    hold on 
%     scatter3( hplot.X , hplot.Y, hplot.Z , 'k','MarkerEdgeAlpha',.01)
    p = PlotEllispe(x, y, z);
    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
    radii = radii*SingleDim;

    set( p, 'FaceColor', 'g' ,'FaceAlpha',.5, 'EdgeColor', 'none' );
%     view( 0, 0 );

    
    title(join(["Ablation Segmentation", newline, " Fitted Ellipsoid ", newline, ...
        "Volume = ", round(Vol,3)  ,"cm^{3}", newline, ...
        "X_d = ", num2str(round(radii(1)*2,2)), "   |   ",...
        "Y_d = ", num2str(round(radii(2)*2,2)), "   |   ",...
        "Z_d = ", num2str(round(radii(2)*2,1)) ]) )
    
%     title(join(["Volume = ", num2str(round(Vol,3)) , newline, " Fitted Ellipsoid For Ellipse", newline, ...
%     "X_d = ", num2str(round(radii(1)*2,2)), "   |   ","Y_d = ", num2str(round(radii(2)*2,2)),...
%     "   |   ", "Z_d = ", num2str(round(radii(2)*2,1)) ]) )


%     title(join([" Fitted Ellipsoid For Ellipse",num2str(i), newline, ...
%         "X_d = ", num2str(round(radii(1)*2,2)), "   |   ","Y_d = ", num2str(round(radii(2)*2,2)),...
%       "   |   ", "Z_d = ", num2str(round(radii(2)*2,1)) ]) )
  
    ylabel("Y")
    xlabel("X")
    zlabel("Z")

    set(gca,'FontSize',12)
    set(gcf,'color','w');
    axis equal ;
    grid on ;
    camlight;
    lighting phong;

end 

%%

% clear

SingleDim = 0.122921145368366;
fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\Multiprobe\Results\Boundary BoxGeomPhantom_TrueBeefAblation_SingleAblation.csv";
BoundaryPoints = readtable(fileName);
BoundaryPointsMatrix =  table2array(BoundaryPoints(:,:));

fileName2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\Multiprobe\Results\Beef Ablation Boundary.csv";
BoundaryPoints2 = readtable(fileName2);
BoundaryPointsMatrix2 =  table2array(BoundaryPoints2(:,:))*( SingleDim*1.05) ;


spacing = 15*4;  
timespacing = 1;
colors = turbo( (ceil(spacing/timespacing))  );

figure()
set(gcf,'color',rgb('White'));
set(gca,'FontSize',14)

   
for i = 15*4:15*4
    
    X = BoundaryPointsMatrix(2:end, ((i-1)*3 + 1) );
    X(X == 0) = [];
    Y = BoundaryPointsMatrix(2:end, ((i-1)*3 + 2) );
    Y(Y == 0) = [];
    Z = BoundaryPointsMatrix(2:end, ((i-1)*3 + 3) );
    Z(Z == 0) = [];
    
    [k, vol] = boundary([X,Y,Z], .1);
    trisurf(k, X , Y , Z ,'Facecolor',colors(i,:)  ,'FaceAlpha',.1 )
    hold on 
    plot3( X, Y, Z, '.', 'MarkerSize', 5, 'Color',  colors(i,:) )
    
    p2 = PlotEllispe(X, Y, Z);
    set( p2, 'FaceColor', 'g' ,'FaceAlpha',.2, 'EdgeColor', 'none' );
    
    center1 = [mean(X), mean(Y), mean(Z)];
    
    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ X Y Z ], '' );
    
    
    title(join(["COMSOL MODEL", newline, " Fitted Ellipsoid ", newline, ...
        "Volume = ", round( (vol/1000) , 3) ,"cm^{3}", newline, ...
        "X_d = ", num2str(round(radii(1)*2,2)), "   |   ",...
        "Y_d = ", num2str(round(radii(2)*2,2)), "   |   ",...
        "Z_d = ", num2str(round(radii(2)*2,1)) ]) )
  
%     title(join([ "Volume = ", num2str(vol/1000)]))
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    axis equal
%     title( join(["Time = ", num2str(i*15), "Sec"])) 

    xlim([100 140])
    ylim([120 200])
    zlim([125 155])   
    
    pause(.25)
    hold off
    
    
end


    X2 = BoundaryPointsMatrix2(: , 1 );
    X2(X2 == 0) = [];
    Y2 = BoundaryPointsMatrix2(: , 2 );
    Y2(Y2 == 0) = [];
    Z2 = BoundaryPointsMatrix2(: , 3 );
    Z2(Z2 == 0) = [];
    
    R = rotz(270);
    v = [X2,Y2,Z2]'; 
    y = R*v; 
    y = y';
    
    center2 = [mean(y(:,1)), mean(y(:,2)), mean(y(:,3))];
    
    centerDiff = center1 - center2;
    
    X2 = y(:,1) + centerDiff(1);
    Y2 = y(:,2) + centerDiff(2)+15;
    Z2 = y(:,3) + centerDiff(3);
    
    [k, vol] = boundary([X2,Y2,Z2], .5);
%     hold on 
%     trisurf(k, X2 , Y2 , Z2 ,'Facecolor','b','FaceAlpha',0.25)
    hold on 
    shp1 = alphaShape(X2 , Y2 , Z2 ,inf, 'HoleThreshold',10  );       % inf - generate convex hull
    plot(shp1, 'FaceAlpha', .1, 'EdgeAlpha', .2)
    vol = volume(shp1);
    plot3( X2, Y2, Z2, '.', 'MarkerSize', 5, 'Color',  colors(i,:) )
%     title(join([ "Volume = ", num2str(vol)]))
    title("Comparing COMSOL Model to Ablation Segmentation")










