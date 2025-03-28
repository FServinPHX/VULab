

clear 
close all
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'

%colors = [rgb("RoyalBlue"); rgb("ForestGreen") ; rgb("DarkGoldenrod") ; rgb("Indigo")];
colors = [ rgb("LightCoral") ; rgb("ForestGreen") ; rgb("DarkGoldenrod") ; rgb("RoyalBlue") ];
legend_string = ["A ", "B", "C", "D"];

probePos = [1,2,3,4];
maxBin = [];
mindist = [];
maxdist = [];

DistAllRuns.i = zeros(5000,4); 
DistAllRuns.ii = zeros(5000,4); 
for select = 4:-1:3
    

    
    %%% 915 MHz Tumor Naive  
    switch select 
        
        case 1 
    
            cd 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive\SignDist'
            titleName = "915 MHz Antenna";
            textSpace = [-6.5, 2.0 ]  ;
   
    %%% *915 MHz Digital Twin        
        case  2
      
            cd 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin\SignDist'
            titleName = "915 MHz Antenna";
            textSpace = [-6.5, 2.0 ]  ;
        
    %%% 2.45 GHz Tumor Naive     
% %         case  3
% %             %colors = [rgb("DarkGoldenrod"); rgb("ForestGreen") ; rgb("RoyalBlue") ; rgb("Indigo")];  
% %             legend_string = ["A ", "B", "C", "D"];   
% %             
% %             cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive\SignDIst'
% %             titleName = "2450 MHz Antenna";
% % 
% %     %%% 2.45 GHz Digital Twin    
% %         case  4
% %             legend_string = ["A ", "B", "C", "D"]; 
% %             
% % 
% %             %colors = [rgb("DarkGoldenrod"); rgb("ForestGreen") ; rgb("RoyalBlue") ; rgb("Indigo")];        
% %             cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin\SignDist'
% %             titleName = "2450 MHz Antenna";
        
        case 3
            
            cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2\SignDist'
            titleName = "2450 MHz Antenna";
            textSpace = [-4.0, 1.5 ]  ;
            
        case 4
            
            
            cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2\SignedDist'
            titleName = "2450 MHz Antenna";
            textSpace = [-4.0, 1.5 ]  ;
    
    end
    

lowFatSigned = [];
mildFatSigned = [];
moderateFatSigned = [];
highFatSigned = [];
healthyLiverSigned = [];
Table=  [];
names = dir('*.csv');

% fi = @(i) 3*(i-1) + 3;

fi = @(i) i+0;

for allFilenames = 1:length(names)
    
    currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
    volumeData = readtable(currentFileName);
    volDataMod = volumeData{:,:};

    healthyLiverSigned = [healthyLiverSigned, volDataMod(:, fi(1) )  ];
    lowFatSigned = [lowFatSigned, volDataMod(:, fi(2) ) ];
    mildFatSigned = [mildFatSigned, volDataMod(:, fi(3)) ];
    moderateFatSigned = [moderateFatSigned, volDataMod(:,  fi(4)  ) ];
    highFatSigned = [highFatSigned, volDataMod(:,  fi(5)  ) ];
    
    
    
%     Table = [ Table; mean(healthyLiverSigned(:)), mean(lowFatSigned(:)), mean(mildFatSigned(:)),...
%         mean(moderateFatSigned(:)), mean(highFatSigned(:)), mean(volDataMod(:)) ]; 

Table = [Table, volDataMod(:, fi(1) )  ,volDataMod(:, fi(2) ) , volDataMod(:, fi(3)) ,...
    volDataMod(:,  fi(4)  ) , volDataMod(:,  fi(5)  ) ];

end 

%  Table  = round( Table , 2);
%  
%  Table = Table./ max(Table);


 % Plot the results on a histogram


cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'


linestyle = ["-","-.", "-", "-.", "-.", "-"];
lineChoice = linestyle(select);
% maxBin = [];
% mindist = [];
% maxdist = [];
% probePos = [1,3,4, 2];
% probePos = [1,2,3,4];

for k = 4:4
    
    pos = probePos(k); 
    distancesAll = [];
    for i = 1:5

        fa = @(i) 5*(pos-1) + i;  

        distances = Table(4:end,fa(i));
        distances(distances == 0) = [];


       distancesAll = [distancesAll; distances];
   if i == 5
       
     if mod(select,2) == 1
        DistAllRuns.i(1:length(distancesAll), k) = distancesAll; 
     elseif mod(select,2) == 0
        DistAllRuns.ii(1:length(distancesAll), k) = distancesAll;
     end 

    figure(1);
    set(gcf,'color','w');
    set(gca,'FontSize',18)
    g = histogram(distancesAll, 'Normalization','pdf', 'BinWidth', 1, ...
        'FaceColor', colors(pos ,:) ,'FaceAlpha', .25 , 'EdgeAlpha', 1 );
    title('Signed Distance to Agreement of Two 3D Objects');
    xlabel('Distance (mmm)');
    ylabel("Probability Density");
    hold on 

    Bin_Counts = g.BinCounts;
    Bin_Counts = Bin_Counts./(sum(Bin_Counts));
    Bin_Width = g.BinWidth;
    Bin_Centres = g.BinEdges(2:end) - Bin_Width;
    
    
    figure(2)
    set(gcf,'color','w');
    p = plot(Bin_Centres,Bin_Counts, 'Color',colors(pos ,:), 'LineWidth', 3 );
    p.LineStyle = lineChoice;
    title( titleName  , 'FontSize', 18);
    xlabel('Signed Distance to Agreement (SDA_{A-T})   [mm]');
    ylabel("Probability Density");  
%     legend_string = ["A ", "B", "C", "D"];
    legend(legend_string,'AutoUpdate','off')
    hold on
   
    
    maxBin = [maxBin,  max(Bin_Counts)]; 
    
   end 
   
   mindist = [mindist ,min(distancesAll) ];
   maxdist = [maxdist, max(distancesAll) ];



    end 
end 



end 

widthImg = max(maxdist) - min(mindist);
height = max(maxBin)*1.1; 
txt = ["Inside Tumor","Outside Tumor"];

%915 MHZ
%text([-6.5, 2.0 ],[ height , height ],txt, 'FontSize', 14)
%2450 MHZ
% text([-4.0, 1.5 ],[ height , height ],txt, 'FontSize', 14)
text(textSpace,[ height , height ],txt, 'FontSize', 14)


ylim([0, (height*1.1) ])
xlim([ (min(mindist)-1) , (max(maxdist)+1) ])
xline(0)        

hold off

x0=550;
y0=250;
widthImg=1250;
height=600;
set(gcf,'position',[x0,y0,widthImg,height])



%%%                                                                       Mann-Whitney U test 
for select2 = 1:3

     switch select2
         case 1
             DistAllRuns.c1 = DistAllRuns.i;
             DistAllRuns.c2 = DistAllRuns.i;
             titleName =  "Mann-Whitney U Test SDT Histogram Tumor Naive";
         case 2
             DistAllRuns.c1 = DistAllRuns.ii;
             DistAllRuns.c2 = DistAllRuns.ii;
             titleName =  "Mann-Whitney U Test SDT Histogram Tumor Informed";
         case 3 
             DistAllRuns.c1 = DistAllRuns.i;
             DistAllRuns.c2 = DistAllRuns.ii;
             titleName =  "Mann-Whitney U Test SDT Histogram Tumor Naive vs. Tumor Informed";
     end 

     
    DistMW.pAll = [];
    DistMW.hAll = [];
    xvalues_names = ["A";"B";"C";"D"];
    yvalues_names = ["A";"B";"C";"D"];
    for mw1 = 1:width(DistAllRuns.c1)

        DistMW.p = [];
        DistMW.h = [];
        for mw2 = 1:width(DistAllRuns.c1)
            x = DistAllRuns.c1(:, mw1);
            x(x == 0) = [];
            y = DistAllRuns.c2(:, mw2);
            y(y == 0) = [];
            % Perform Mann-Whitney U test
            [p,h] = ranksum(x,y); 
            DistMW.p = [DistMW.p,  p];
            DistMW.h = [DistMW.h , h];
        end 

        DistMW.pAll = [DistMW.pAll; DistMW.p];
        DistMW.hAll = [DistMW.hAll; DistMW.h];
    end
    Vandy_map = [green; blue; blue; blue; blue; ...
            orange; orange; orange; orange; orange;
            gold; gold; gold; gold; gold;
            purple;  purple; purple; purple;  purple;];
        
    newmap = brighten(Vandy_map,.7);
    figure()
    set(gcf,'color','w');
    xvalues = [];
    yvalues  = []; 
        for i = 1:4
         xvalues = [xvalues, join([xvalues_names(i),'-', i ])]; 
         yvalues = [yvalues, join([yvalues_names(i),'-', i ])]; 
        end 
    h = heatmap(xvalues,yvalues, DistMW.pAll ,'Colormap',newmap);
    C=caxis;
    caxis([0 , 1 ])
    % h.ColorScaling = 'scaledcolumns';
    h.Title = titleName;

end 


%%

close all
%Illustrative infographic

% Code for creating and plotting a 3d cone and a plane that intersects the cone
set(gcf,'color','w');
% Create a 3D cone and plot it
[X,Y,Z] = cylinder(3,50);
% surf(X,Y,Z);
% title('3D Cone');
% xlabel('X-Axis');
% ylabel('Y-Axis');
% zlabel('Z-Axis');


% Create a horizontal plane and plot it 

[x,y] = meshgrid(-6:.25:6);  % Create x and y coordinates 
z = .5*ones(size(x));        % Set z values to 0 for all (x,y) coordinates 
% surf(x,y,z);                % Plot the plane  
% alpha 0.5
% title('Horizontal Plane'); 
% xlabel('X-Axis'); 
% ylabel('Y-Axis'); 
% zlabel('Z-Axis'); 


% Plot both the cone and the plane together in one figure  
figure;  % Open a new figure window  
set(gcf,'color','w');
s1 = surf(X,Y,Z);                % Plot the cone  
s1.EdgeColor = 'none';
alpha 0.25
hold on;                    % Keep the current graph so we can add more to it  
s2 = surf(x,y,z);                % Plot the plane  
s2.EdgeColor = 'none';
alpha 0.25
title('Plane Intersecting Cylinder');  % Give it a title  
xlabel('X-Axis');           % Label the axes  
ylabel('Y-Axis');   												      % Label the axes   	   	   	   	   	    	    	    	    	    	      % Label the axes   

zlabel('Z-Axis');           % Label the axes
grid off
axis off


hold on
% Create a circle radius 2, centered at 0,0 and plotted at z = .05
t = linspace(0,2*pi);  % Create a vector of theta values from 0 to 2pi 
x = 3*cos(t);          % Calculate x coordinates for the circle 
y = 3*sin(t);          % Calculate y coordinates for the circle 
z = .52*ones(size(x)); % Set z coordinates to .05 for all (x,y) coordinates  
fill3(x,y,z,'r');      % Plot and fill the circle with red color 
% title('Circle Radius 2 Centered at 0,0 Plotted at z=.05');   % Give it a title  
% xlabel('X-Axis');      % Label the axes  
% ylabel('Y-Axis');      % Label the axes   	   	   	   	   	    	    	    	    	    	      % Label the axes   
% zlabel('Z-Axis');      % Label the axes
% zlabel('Z-Axis');      % Label the axes