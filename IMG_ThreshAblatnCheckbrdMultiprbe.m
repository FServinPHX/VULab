%%
clear
clc
%%% Checkerboard Image 

                % Image Load and Checkerboard Detection
%I = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Multiprobe 3 Segmentation System.PNG");
%I = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Grayscale with SegmentationWtIntBlackSquare.png");
%I = imread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Ablation Phantom Study\Ablation No 1 __ 2% Agar\AgarAblationVanillaFilter #2.png");
%I = imread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Ablation Phantom Study\Beef Ablation Study\CheckerBoard 6 with Level Cropped ReColored.jpeg");

Ifile = join(['C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\',...
    'Liver Ablation Phantom Study\Nov 8 Multiprobe 25 Degree Box\Cropped\Ablation 2 White Cropped.jpeg']);
I = imread( Ifile );
I = rgb2gray(I);
% I = histeq(I);


%%%%        Segmentaion Image

%I2 = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Multiprobe (2).PNG");
%I2 = imread("C:\Users\servinf\Pictures\Ablation Experiment Images\Grayscale with Segmentation.png");
%I2 = imread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Ablation Phantom Study\Ablation No 1 __ 2% Agar\Ablation Ablation Side 1 with image.png");

Ifile = join(['C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Ablation Phantom Study\'...
    'Nov 8 Multiprobe 25 Degree Box\Cropped\Ablation 2 White Cropped_Segmentation.png']);

I2 = imread(Ifile);
I2 = rgb2gray(I2);
% I2 = histeq(I2);



%%
figure()
[imagePoints,boardSize] = detectCheckerboardPoints(I);

set(gcf,'color','w');
J = insertText(I,imagePoints,1:size(imagePoints,1), 'FontSize', 25);
J = insertMarker(J,imagePoints,'o','Color','red','Size', 25);
imshow(J);
hold on
Distance = [];
%Checkerboard Dimension in Milimeters; 
%Dim 4-Square = 7.11    6-Square = 4.69
CheckerboardDim = 4.69  ;

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
%
set(gcf,'position',[280,280, 600, 700])




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
    
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'

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
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\fitellipse'



for jj = 1:2
    
    
    if jj == 2
      figure()
      subplot(3 ,2,1)
      kmeansThresh = 4;
%       I2 =  histeq(I2);
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
%     plot(pointcloud.columns(k), pointcloud.rows(k), 'LineWidth', 4 );
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


cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'

toc

%%

%ThreshSelect = [ threshold for square, threshold for ablation];
ThreshSelect = [2,2];
% Scale = 1*32.15 ; % 1*x cm
% Scale = 1*30.3;

% xyMatrix(xyMatrix == 0 ) = NaN; 
% cubeX = rmmissing(xyMatrix(:, (ThreshSelect(1)*2)-1 )); 
% cubeY = rmmissing(xyMatrix(:, (ThreshSelect(1)*2) )); 
xyMatrixEqualized(xyMatrixEqualized == 0 ) = NaN; 
cubeX = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2-1)) ; 
cubeY  = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2)) ; 


[k, area] = boundary(cubeX, cubeY,.9);
%Cubuic Dimension = 1stDimention.^3/(repCM)
SingleDim = PixelToDim;           %PixelToDim; %Scale/sqrt(area);
CubicDimension = SingleDim^3;
figure()
plot(cubeX, cubeY, '.b')
hold on 
plot(cubeX(k), cubeY(k))
set(gcf,'color','w');
title(join([ "Measurement Space", newline, "Area =", ...
    num2str(area/2*(SingleDim^2)), "cm^{2}" ]) )
axis equal


%
n1 = 300;            % circle points
n2 = 200;            % number of circles
% [x,y] = pol2cart(linspace(0,2*pi,n1),9);    % data for a circle
xyMatrixEqualized(xyMatrixEqualized == 0 ) = NaN; 
x = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2-1)) ; 
y = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2)) ; 

% figure()
% plot(x, y)

centerOG = [mean(x) , mean(y)];



%%

figure()
hplot.X =  [];
hplot.Y = [];
hplot.Z = [];

for hi = 1:2
    x = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2-1)) ; 
    y = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2)) ; 
    
    if hi ==1
        
       k = find(x > centerOG(1) );
       x = x(k);
       y = y(k);
       mult = .9;
       
    elseif hi == 2
       k = find(x < centerOG(1) );
       x = x(k);
       y = y(k);
       mult = 1.15;
        
    end 
    
    center = [mean(x)*mult , mean(y)];
    

h = zeros(1,n2);                            % objects for each circle
ax = axes;
h(1) = plot(x,y);                           % plot circle
for i = 2:n2
    h(i) = copyobj(h(i-1),ax);              % copy previous object
    rotate(h(i), [0 1 0], 2 ,[center(1) center(2) 0]);      % rotate object about [1 0.5 0] vector 15 degree (degree/rotations) 5/40
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
    
    
    k = boundary([ hplot.X2, hplot.Y2 ,hplot.Z2  ] ,0);
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


%%


shp1 = alphaShape(hplot.X1 , hplot.Y1 , hplot.Z1,inf, 'HoleThreshold',10  );       % inf - generate convex hull
shp2 = alphaShape(hplot.X2 , hplot.Y2 , hplot.Z2,inf, 'HoleThreshold',10  );


id1=inShape(shp2, hplot.X1 , hplot.Y1 , hplot.Z1);
id2=inShape(shp1, hplot.X2 , hplot.Y2 , hplot.Z2);

shp3=alphaShape([hplot.X1(id1); hplot.X2(id2)], ...
    [ hplot.Y1(id1) ; hplot.Y2(id2)],...
    [ hplot.Z1(id1) ; hplot.Z2(id2)]);

Vol = (volume(shp1) + volume(shp2) - volume(shp3))*(CubicDimension)/1000/2;
%

figure()

plot3(hplot.X1 , hplot.Y1 , hplot.Z1, '.k' , 'MarkerSize', .25 )
hold on
plot3( hplot.X2 , hplot.Y2 , hplot.Z2, '.k' , 'MarkerSize', .25 )

plot(shp1,'FaceColor','green' ,'EdgeAlpha', .2 ,   'FaceAlpha',0.2)
plot(shp2,'FaceColor','green' ,'EdgeAlpha', .2 , 'FaceAlpha',0.2)
plot(shp3,'FaceColor','red' , 'EdgeAlpha', .1 , 'FaceAlpha',1 )
plot3(centerOG(1), centerOG(2), 0, '.r','MarkerSize', 20 )




axis equal


set(gcf,'position',[880,280,1000,600]) 
title( join(["3D Volume of Ablation Margin",...
    newline, "Volume =", num2str(round(Vol,1)) , "cm^3"    ]), 'FontSize', 18  )
set(gcf,'position',[200,100, 900, 400])


set(gcf,'color','w');
axis vis3d equal;
grid on
camlight;
lighting phong;

%%

figure()


for i = 1:2
    
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

    p = PlotEllispe(x, y, z);
    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
    radii = radii*10/SingleDim;

    set( p, 'FaceColor', 'g' ,'FaceAlpha',.2, 'EdgeColor', 'none' );
    view( 0, 0 );
    title(join([" Fitted Ellipsoid For Ellipse",num2str(i), newline, ...
        "X_r = ", num2str(round(radii(3),1)), "   |   ","Y_r = ", num2str(round(radii(1),1)),...
      "   |   ", "Z_r = ", num2str(round(radii(2),1)) ]) )
    ylabel("Y")
    xlabel("X")
    zlabel("Z")

    set(gca,'FontSize',12)
    set(gcf,'color','w');
    axis vis3d equal;
    grid on
    camlight;
    lighting phong;

end 
