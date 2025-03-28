
clear 
close all

% Read the CSV file
% Experiment  = 6;

for Experiment = 1:6
    
switch Experiment
    case 1
        data2 = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef0Degrees_UN_Refined.csv");
        data = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined.csv");
    case 2
        data2 = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef5Degrees_UN_Refined.csv");
        data = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef5Degrees_Refined.csv");        
    case 3
        data2 = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef10Degrees_UN_Refined.csv");
        data = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef10Degrees_Refined.csv");             
    case 4
        data2 = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef15Degrees_UN_Refined.csv");
        data = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef15Degrees_Refined.csv");             
    case 5 
        data2 = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef20Degrees_UN_Refined.csv");
        data = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef20Degrees_Refined.csv");             
    case 6
        data2 = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef25Degrees_UN_Refined.csv");
        data = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef25Degrees_Refined.csv");            
end 
%
% Extract coordinate data
coordinate_data = table2array( data(:, 1:3) );
coordinate_data2 = table2array( data2(:, 1:3) );

% Extract temperature data
temperature_data = table2array( data(:, 4:2:end) );
temperature_data2 = table2array( data2(:, 4:2:end) );

% Extract alpha values
alpha_values = table2array(data(:, 5:2:end));
alpha_values2 = table2array(data2(:, 5:2:end));
% % Display the matrices
% disp('Coordinate data:');
% disp(coordinate_data);
% 
% disp('Temperature data:');
% disp(temperature_data);
% 
% disp('Alpha values:');
% disp(alpha_values);
%
% Create a logical matrix to store the indices of alpha values greater than 0.85
plot_scatter1 = "TRUE";
i = 10;
all_Alpha = zeros( 100000 ,61);
All_Coords = zeros( 100000 ,61*3);
All_Distances = zeros( 100000 ,61);
true_length = []; 
for i = 1:61
    
alpha_valuesc =  temperature_data(:,i);
alpha_valuesc2 =  temperature_data2(:,i);
%
indices = alpha_valuesc > 40;
indices2 = alpha_valuesc2 > 40;
%
% Find the indices of non-zero values in the logical matrix
[row_indices, col_indices] = find(indices);
[row_indices2, col_indices2] = find(indices2);
%
% Extract the x, y, z data at the corresponding indices
xyz_data = [ coordinate_data(row_indices, :), alpha_valuesc(row_indices, :) ];
xyz_data2 = [ coordinate_data2(row_indices2, :), alpha_valuesc2(row_indices2, :) ];
%
BoundP.P = xyz_data(:, 1:3);
BoundP.Arr = xyz_data( : , 4);

BoundP.k = boundary(BoundP.P, 1);
BoundP.k_reshape = reshape(BoundP.k,[],1);
BoundP.kSort = unique(BoundP.k_reshape);

BoundP.kSortPoint = BoundP.P(BoundP.kSort,:);
BoundP.ArrSort = BoundP.Arr(BoundP.kSort,:);
BoundP.xyz_data = [BoundP.kSortPoint, BoundP.ArrSort];
% Initialize variables for storing the closest point and its properties
closest_points = [];
diff_alpha_values = [];
distances = [];
all_pts = [];

% Iterate over each point in xyz_data
for j = 1:size(BoundP.xyz_data , 1)
    % Get the x, y, z coordinates and alpha value of the current point
    curr_xyz = BoundP.xyz_data (j, 1:3);
    curr_alpha = BoundP.xyz_data (j, 4);
    
    % Compute the Euclidean distance between the current point and all points in xyz_data2
    all_distances = sqrt(sum((xyz_data2(:, 1:3) - curr_xyz).^2, 2));
    
    % Find the index of the closest point in xyz_data2
    [~, min_index] = min(all_distances);
    
    % Get the properties of the closest point
    closest_xyz = xyz_data2(min_index, 1:3);
    closest_alpha = xyz_data2(min_index, 4);
    
    % Compute the difference between alpha values and the distance between points
    alpha_diff = curr_alpha - closest_alpha;
    point_distance = all_distances(min_index);
    
    % Store the differences and distances
    closest_points = [closest_points; closest_xyz];
    diff_alpha_values = [diff_alpha_values; alpha_diff];
    distances = [distances; point_distance];
    all_pts = [  all_pts  ;curr_xyz];
end

all_Alpha( 1:length(diff_alpha_values) ,i) = diff_alpha_values;
All_Distances( 1:length(distances) ,i) = distances;
a = (i-1)*3+1;
b = (i-1)*3 + 3;
All_Coords( 1:length(all_pts), a:b) = all_pts;
true_length = [true_length;  length(diff_alpha_values) ]; 
end 




%


% for i = 10:61
%     hold on 
%     plot( all_Alpha(:, i), All_Distances(:, 1) )
%     pause(.1)
%     
%     ylim([0 .35])
% end 

%
%
close all
figure(1)
PlotChoice = "Arr";
%
%
All_Coords(All_Coords ==0) = nan;
plotColor  = rgb("Gray");

% videoName = join([ " Experiment ", Experiment, "AblationMeshResolution.avi" ]);
% writerObj = VideoWriter(videoName); %// initialize the VideoWriter object
% writerObj.FrameRate = 8;
% open(writerObj) ;

GIftitle = char(join([ "Box Phantom Ablation",Experiment, ".gif" ])  );
gif( GIftitle ,'overwrite',true)
gif('DelayTime', 1/8)  


for i = 10:61
    


set(gcf,'color',plotColor );
set(gca,'color',plotColor );   
a = (i-1)*3+1;
b = (i-1)*3 + 3;  


switch PlotChoice
    
    case "Arr"
        hold off 
        x = All_Coords( 1:true_length(i), a);
        y = All_Coords(1:true_length(i),a+1);
        %
        k = boundary(x,y, .50);
        hold on;
        plot(x(k),y(k));  
        %
        fill(x(k), y(k), 'blue');     

        scale =  abs( all_Alpha(1:true_length(i), i)  /...
                  abs( min(  all_Alpha(1:true_length(i), i) ) )*45 + 2  );

%         scatter( All_Coords( 1:true_length(i), a), All_Coords(1:true_length(i),a+1),...
%               scale, all_Alpha(1:true_length(i), i ), 'Filled' )
  
          
        scatter3( All_Coords( 1:true_length(i), a), ...
            All_Coords(1:true_length(i),a+1), All_Coords(1:true_length(i),b),...
            scale, all_Alpha(1:true_length(i), i ), 'Filled' )
        caxis([0, 15])
        xlim([ 85 155])
        ylim([ 130 190 ])
        hold off
        
    case "Dist"
         x = All_Coords( 1:true_length(i), a);
         y = All_Coords(1:true_length(i),a+1);
         %
         boundary  = boundary(x,y);
         hold on;
         fill(x(boundary, 1), y(boundary, 2), 'blue');


         scale2 = abs( All_Distances(1:true_length(i), i)*2  + 4 );       
         scatter( x,y ,...
                  scale2, All_Distances(1:true_length(i), i ), 'Filled' )
         caxis([0,5]);
end 

colormap jet
c = colorbar ;
c.FontSize = 20;
axis equal


minutes =  floor( (i*15-15)/60) ; 
seconds  = mod( (i*15-15), 60)    ;
title( join(["Probe Placement ",Experiment,...
        newline,  num2str(minutes),  "m","  ", num2str(seconds), "s" ]), 'Fontsize', 14 )   
set(gcf,'color',plotColor );
set(gca,'color',plotColor );  

gif 
gif('frame',gcf)


pause(.25)    
set(gcf,'color',plotColor );
set(gca,'color',plotColor );


% Frame = getframe(gcf) ;                
% writeVideo(writerObj,Frame)   
end 

end 
% close(writerObj) ;


