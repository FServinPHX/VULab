clear
clc
close all

Ifile = join(['C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\',...
    'Liver Ablation Phantom Study\Nov 8 Multiprobe 25 Degree Box\Cropped\Ablation 2 White Cropped.jpeg']);
I = imread( Ifile );
I = rgb2gray(I);
Ifile = join(['C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Ablation Phantom Study\'...
    'Nov 8 Multiprobe 25 Degree Box\Cropped\Ablation 2 White Cropped_Segmentation.png']);
I2 = imread(Ifile);
I2 = rgb2gray(I2);


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
    %     plot( imagePoints(i,1), imagePoints(i,2), 'r.', 'MarkerSize', 20)
    %      %     pause(.2)
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


%
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



for jj = 2:2
    
    
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
    

n1 = 300;            % circle points
n2 = 200;            % number of circles
% [x,y] = pol2cart(linspace(0,2*pi,n1),9);    % data for a circle
xyMatrixEqualized(xyMatrixEqualized == 0 ) = NaN; 
x = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2-1)) ; 
y = rmmissing(xyMatrixEqualized(:,ThreshSelect(2)*2)) ; 
% figure()
plot(x, y, '.r')
xlabel('X')
ylabel('Y')
centerOG = [mean(x) , mean(y)];


%%
close all
clc 
% clear
% clc
% close all
% Step 1: Create ellipse boundary points
% a = 2; % Semi-major axis
% b = 1; % Semi-minor axis
% num_points = 100;
% theta = linspace(0, 2*pi, num_points);
% x = a * cos(theta);
% y = b * sin(theta);


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
data = [x, y];
num_points =length(data);

% %     % Step 2: Randomly rotate the ellipse
% %     rotation_angle = rand(1) * 2 * pi;
% %     % rotation_angle = 0;
% %     R = [cos(rotation_angle) -sin(rotation_angle); sin(rotation_angle) cos(rotation_angle)];
% %     data = data * R;

    % Step 3: For every point, find the furthest away point
    dist_matrix = squareform(pdist(data));
    [furthest_distances, furthest_indices] = max(dist_matrix, [], 2);

    % Collect all furthest pairs and their distances
    all_furthest_pairs = [data, data(furthest_indices,:)];
    % Step 4: Plot all points and their respective furthest points
    f0= figure;
    scatter(data(:,1), data(:,2), 'filled');
    hold on;
    for i = 1:num_points
        line = [data(i,:); data(furthest_indices(i),:)];
        plot(line(:,1), line(:,2), 'k');
    end
    title('All Points and Their Furthest Points');

    % Step 5: Find the 20 point pairs that maximize their distance
    [sorted_distances, sort_idx] = sort(furthest_distances, 'descend');
    top_index_pairs = [sort_idx(1:20), furthest_indices(sort_idx(1:20))];

    % Get coordinates of the top 20 point pairs
    top_points = [data(top_index_pairs(:,1), :); data(top_index_pairs(:,2), :)];

    % Step 6: Separate the point pairs into two groups using kmeans clustering
    [cluster_idx, ~] = kmeans(top_points, 2);

    % Divide the points based on cluster index
    group_1_points = top_points(cluster_idx == 1, :);
    group_2_points = top_points(cluster_idx == 2, :);

    % Step 7: Calculate the 2D vector passing through the approximate centers
    center_1 = mean(group_1_points);
    center_2 = mean(group_2_points);
    vector =  (center_2 - center_1);
    largest_vector = [ (vector./(norm(vector))) , 0].*1;
    largest_vector = [ vector , 0].*1;
    
 
    % Plot the two groups and the vector between their centers
    scatter(group_1_points(:,1), group_1_points(:,2),...
        'filled', 'MarkerEdgeColor','k', 'MarkerFaceColor','r');
    hold on;
    scatter(group_2_points(:,1), group_2_points(:,2), ...
        'filled', 'MarkerEdgeColor','k', 'MarkerFaceColor','b');
    quiver(center_1(1), center_1(2), vector(1), vector(2),...
        'MaxHeadSize', 2, 'Color', 'red', 'LineWidth', 1.5);
    title('Clustered Points and Vector Between Centers');
    legend('Group 1', 'Group 2', 'Vector');
    axis equal;






    % Plot the PCA vectors
    origin = mean(data);
    scale = max(abs(data(:))) * 1.5;
    %quiver(origin(1), origin(2), coeff(1,1)*scale, coeff(1,2)*scale);
    plot([center_1(1), center_2(1)], [center_1(2), center_2(2)], 'r');
    % Revolve all the points around the vector
        f1 = figure();
        hplot.X =  [];
        hplot.Y = [];
        hplot.Z = [];
        n1 = 300;            % circle points
        n2 = 200;            % number of circles
    %
        x = data(:,1);
        y = data(:,2);
        center = [mean(x) , mean(y)];
        h = zeros(1,n2);                            % objects for each circle
        ax = axes;
        h(1) = plot(x,y);                           % plot circle

        for i = 2:n2
            h(i) = copyobj(h(i-1),ax);              
            % copy previous object
            rotate(h(i), largest_vector, 2 ,[center(1) center(2) 0]);      
            % rotate object about [1 0.5 0] vector 15 degree (degree/rotations) 5/40
        end
        hplot.Xtemp = cell2mat(get(h(2:end),'xdata'));
        hplot.Ytemp = cell2mat(get(h(2:end),'ydata'));
        hplot.Ztemp = cell2mat(get(h(2:end),'zdata'));
        hplot.X = [hplot.X ; hplot.Xtemp(:) ];
        hplot.Y = [hplot.Y ; hplot.Ytemp(:) ];
        hplot.Z = [hplot.Z  ; hplot.Ztemp(:) ];



    f2 = figure();
    plot3( hplot.X , hplot.Y, hplot.Z , '.b', 'MarkerSize', .1 )
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


pause(1)
if hi == 1
    export.cloud1 = [hplot.X , hplot.Y, hplot.Z];
elseif hi == 2
    export.cloud2 = [hplot.X , hplot.Y, hplot.Z];
end 
end 

%%
close all

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
    %     plot( imagePoints(i,1), imagePoints(i,2), 'r.', 'MarkerSize', 20)
    %      %     pause(.2)
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
    
    
    
figure()
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


figure()

plot3( export.cloud1(:,1), export.cloud1(:,2), export.cloud1(:,3), 'r.' )
hold on
plot3( export.cloud2(:,1), export.cloud2(:,2), export.cloud2(:,3), 'b.' )

ylabel("Y")
xlabel("X")
zlabel("Z")
title("Revolved Shape of the Ablation Zone")
set(gcf,'color','w');
axis vis3d equal;
grid on
camlight;
lighting phong;










