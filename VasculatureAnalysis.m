clear

data = readtable("D:\Import To Matlab\FullVascularTree\Liver05_915_WTumor_A_HealthyFullVascularTree_Refined.csv");
%data = readtable( "D:\Import To Matlab\FullVascularTree\Liver05_915_WTumor_A_HealthyFullVascularTree_TD.csv" );
% Extract coordinate data
coordinate_data = table2array( data(:, 1:3) );
% Extract temperature data
temperature_data = table2array( data(:, 4:2:end) );
% Extract alpha values
alpha_values = table2array(data(:, 5:2:end));

%%
% videoName = join([ " Full Vasc Temp ", "Ablation.avi" ]);
% writerObj = VideoWriter(videoName); %// initialize the VideoWriter object
% writerObj.FrameRate = 8;
% open(writerObj) ;

gif('Ablation Temp Vasc OG 2.gif')
gif('DelayTime', 1/8) 
for i = 1:61
       
temperature = temperature_data(:, i);
% Specify the value to replace NaN
replacement_value = 40;
% Find indices of NaN values
nan_indices = isnan(temperature);
% Replace NaN values with the specified value
temperature(nan_indices) = replacement_value;

groups = linspace(min(temperature), max(temperature), 20);
labels = cell(1, numel(groups)-1);
for j = 1:numel(groups)-1
    labels{j} = sprintf('%.2f - %.2f', groups(j), groups(j+1));
end
[~, group_indices] = histc(temperature, groups);
scale = temperature/20; 

% Plot the data using scatter plot
f = figure(1);
fig=gcf;
fig.Position=[100 100 1200 800];
scatter3(coordinate_data(:, 1), coordinate_data(:, 2), coordinate_data(:, 3), scale, temperature, 'filled');


minutes =  floor( (i*15-15)/60) ; 
seconds  = mod( (i*15-15), 60)    ;
title( join([  num2str(minutes),  "m","  ", num2str(seconds), "s" ]), 'Fontsize', 14 )    
colorbar;
caxis([37, 100])
colormap jet
axis equal
xlabel('X');
ylabel('Y');
zlabel('Z');
view(0, 5)
gif 
gif('frame',gcf)
pause(.1)


% Frame = getframe(gcf) ;                
% writeVideo(writerObj,Frame)  

end 
% close(writerObj) ;

%%

clear




%data = readtable("D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined.csv");

for Experiment = 2:6
    
    
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

for k = 1:2
    
    
     switch k
         case 1
            % Extract coordinate data
            coordinate_data = table2array( data(:, 1:3) );
            % Extract temperature data
            temperature_data = table2array( data(:, 4:2:end) );
            % Extract alpha values
            alpha_values = table2array(data(:, 5:2:end));
            type = "Refined";
         case 2
            % Extract coordinate data
            coordinate_data = table2array( data2(:, 1:3) );
            % Extract temperature data
            temperature_data = table2array( data2(:, 4:2:end) );
            % Extract alpha values
            alpha_values = table2array(data2(:, 5:2:end));
            type = "Unrefined";
     end 
         

    
% % Extract coordinate data
% coordinate_data = table2array( data(:, 1:3) );
% % Extract temperature data
% temperature_data = table2array( data(:, 4:2:end) );
% % Extract alpha values
% alpha_values = table2array(data(:, 5:2:end));
% %

% videoName = join([ " Box Phantom ", "Ablation.avi" ]);
% writerObj = VideoWriter(videoName); %// initialize the VideoWriter object
% writerObj.FrameRate = 8;
% open(writerObj) ;
plotColor  = rgb("Snow");

    
    
GIftitle = char(join([ "Box Phantom Ablation",Experiment,type, ".gif" ])  );
gif( GIftitle ,'overwrite',true)
gif('DelayTime', 1/8)     
    
    
for i = 5:61
    
    

hold off
%temperature = temperature_data(:, i);
temperature = alpha_values(:, i);
temperature(temperature < .9) = nan;
groups = linspace(min(temperature), max(temperature), 5);
labels = cell(1, numel(groups)-1);
for j = 1:numel(groups)-1
    labels{j} = sprintf('%.2f - %.2f', groups(j), groups(j+1));
end
[~, group_indices] = histc(temperature, groups);

%scale = (group_indices)*5 + 1; 
% scale = temperature/10 + 4;
scale = temperature*1 + 7;

% Plot the data using scatter plot
f = figure(1);
fig=gcf;
fig.Position=[100 100 1200 800];
set(gcf,'color',plotColor );
set(gca,'color',plotColor );    
% temperature(temperature > 50) = 100;

%scatter3(coordinate_data(:, 1), coordinate_data(:, 2), coordinate_data(:, 3), scale, temperature, 'filled');

scatter3(coordinate_data(:, 1), coordinate_data(:, 2), coordinate_data(:, 3), ...
         scale, temperature, 'filled');
%     
%   
hold on   
data0  = [coordinate_data, alpha_values(:, i)];   
filtered_data = data0(data0(:, 4) > 0.9, :); 
x = filtered_data(:, 1);  y = filtered_data(:, 2);   z =  filtered_data(:, 3);  alpha = filtered_data(:, 4); 
filtered_data =  find_unique_boundary(x,y,z, .5); 
x2 = filtered_data(:, 1);
y2 = filtered_data(:, 2);
z2 =  filtered_data(:, 3); 
% scatter3( x2, y2, z2 , 'filled'); 
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [x2, y2, z2] , '' );
Ablation.p =  PlotEllispe( x2, y2, z2 );
set( Ablation.p , 'FaceColor', 'r','FaceAlpha',.1, 'EdgeColor', 'none' );         
% hold on 


minutes =  floor( (i*15-15)/60) ; 
seconds  = mod( (i*15-15), 60)    ;
%title( join([  num2str(minutes),  "m","  ", num2str(seconds), "s" ]), 'Fontsize', 14 )  

title( join([  num2str(minutes),  "m","  ", num2str(seconds), "s" , newline...
  "X_d = ",num2str( round(radii(3)*2,0)) ,...
  "mm   |   ","Y_d = ", num2str(round(radii(1)*2,0) ),...
  "mm   |   ", "Z_d = ", num2str(round(radii(2)*2,0) ),"mm" ]) )
colormap jet 
colorbar
% caxis([0, 100])
axis equal
xlabel('X');
ylabel('Y');
zlabel('Z');
grid off

xlim([80 160])
ylim([125 190])
view(0, 90)
set(gcf,'color',plotColor );
set(gca,'color',plotColor );  

gif 
gif('frame',gcf)

hold off
pause(.10)
hold off

% Frame = getframe(gcf) ;                
% writeVideo(writerObj,Frame)  
end 




end 
end 

% close(writerObj) ;
