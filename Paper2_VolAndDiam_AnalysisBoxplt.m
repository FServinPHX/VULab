
clear

modelNum = 6;
% ModelRunAll = ["915 Mhz Tumor Naive", "915 Mhz Digital Twin",...
%             "2450 Mhz Tumor Naive", "2450 Mhz Digital Twin", "2450 Mhz Digital Twin V2"  ] ;
        
ModelRunAll = ["915 Mhz Tumor Naive", "915 Mhz Digital Twin",...
"2450 Mhz Tumor Naive", "2450 Mhz Digital Twin", ...
"2450 Mhz Digital Twin V2", "2.45 GHz Tumor Naive V2"  ] ;   

ModelRun = ModelRunAll(modelNum); 
switch ModelRun
    
    %%% 915 Mhz Tumor Naive Models
    case  "915 Mhz Tumor Naive"
        cd 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive\Diam'

            
    %%% 915 Mhz Digital Twin Models    
    case "915 Mhz Digital Twin"
        cd 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin\Diam';

        
    %%% 2450 Mhz Tumor Naive Models
    case "2450 Mhz Tumor Naive"   
        cd 'D:\Import To MatlabVolume and Diameter\2.45 GHz Tumor Naive\Diam';
       
        
    %%% 2450 Mhz Digital Twin Models
    case "2.45 GHz Tumor Naive V2"
        %cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2\Diam'
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2\DiamV2'
        
        
    case "2450 Mhz Digital Twin V2"
        %cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2\Diam'
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2\DiamV2'

end 




Diameter.lowFatLongDiameter = [];
Diameter.mildFatLongDiamter = [];
Diameter.moderateLongFatDiameter = [];
Diameter.highFatLongDiameter = [];
Diameter.healthyLongLiverDiameter = [];
Diameter.healthyShortXLiverDiameter = [];
Diameter.lowFatShortXDiameter = [];
Diameter.mildFatShortXDiamter = [];
Diameter.moderateShortXFatDiameter = [];
Diameter.highFatShortXDiameter = [];
names = dir('*.csv');

for allFilenames = 1:length(names)
    currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
    volumeData = readtable(currentFileName);
    volumeDataMod = volumeData{:,:};

    f = @(i) (i-1)*(3) +1 ;
    f2 = @(i) (i-1)*(3) +2 ;
    
    Diameter.healthyLongLiverDiameter = [Diameter.healthyLongLiverDiameter, volumeDataMod(:, f(1) ) ];
    Diameter.lowFatLongDiameter = [Diameter.lowFatLongDiameter, volumeDataMod(:, f(2)  ) ];
    Diameter.mildFatLongDiamter = [Diameter.mildFatLongDiamter, volumeDataMod(:,  f(3) ) ];
    Diameter.moderateLongFatDiameter = [Diameter.moderateLongFatDiameter, volumeDataMod(:,  f(4) ) ];
    Diameter.highFatLongDiameter = [Diameter.highFatLongDiameter, volumeDataMod(:, f(5) ) ];
    
    Diameter.healthyShortXLiverDiameter = [Diameter.healthyShortXLiverDiameter, volumeDataMod(:, f2(1) ) ];
    Diameter.lowFatShortXDiameter = [Diameter.lowFatShortXDiameter, volumeDataMod(:, f2(2)  ) ];
    Diameter.mildFatShortXDiamter = [Diameter.mildFatShortXDiamter, volumeDataMod(:,  f2(3) ) ];
    Diameter.moderateShortXFatDiameter = [Diameter.moderateShortXFatDiameter, volumeDataMod(:,  f2(4) ) ];
    Diameter.highFatShortXDiameter = [Diameter.highFatShortXDiameter, volumeDataMod(:, f2(5) ) ];
    
    
    

end 



%Find the mean and stadard deviation of all of the runs
meanMat.LongDiameterMatrix = [ mean(Diameter.healthyLongLiverDiameter,2) , mean(Diameter.lowFatLongDiameter,2),...
        mean(Diameter.mildFatLongDiamter,2), mean(Diameter.moderateLongFatDiameter,2), mean(Diameter.highFatLongDiameter,2)];
    
stdev.LongDiameter = [std(Diameter.healthyLongLiverDiameter,0,2), std(Diameter.lowFatLongDiameter,0,2),...
        std(Diameter.mildFatLongDiamter,0,2), std(Diameter.moderateLongFatDiameter,0,2), std(Diameter.highFatLongDiameter,0,2)];
%     
    
meanMat.ShortXDiameterMatrix = [ mean(Diameter.healthyShortXLiverDiameter,2) , mean(Diameter.lowFatShortXDiameter,2),...
        mean(Diameter.mildFatShortXDiamter,2), mean(Diameter.moderateShortXFatDiameter,2), mean(Diameter.highFatShortXDiameter,2)];
    
stdev.ShortXDiameter = [std(Diameter.healthyShortXLiverDiameter,0,2), std(Diameter.lowFatShortXDiameter,0,2),...
        std(Diameter.mildFatShortXDiamter,0,2), std(Diameter.moderateShortXFatDiameter,0,2), std(Diameter.highFatShortXDiameter,0,2)];    
    
    
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
 


%Analysis of the Long Axis Diameter
str1 = strcat( string( round( meanMat.LongDiameterMatrix/10 , 2) ), '±') ;
str2 = string( round( stdev.LongDiameter/10,2 ) ); 

meanMat.StringLongDiameterMatrix = strcat( str1, str2);
meanMat.TableLongDiameterMatrix = table(meanMat.StringLongDiameterMatrix );

%Analysis of the Short Axis Diameter
str3 = strcat( string( round( meanMat.ShortXDiameterMatrix/10 , 2) ), '±') ;
str4 = string( round( stdev.ShortXDiameter/10,2 ) ); 

meanMat.StringShortXDiameterMatrix = strcat( str3, str4);
meanMat.TableShortXDiameterMatrix = table(meanMat.StringShortXDiameterMatrix  );



    
%%   


clear
close all

for modelNum = 5:6
    
    
% 
% ModelRunAll = ["915 Mhz Tumor Naive", "915 Mhz Digital Twin",...
%             "2450 Mhz Tumor Naive", "2450 Mhz Digital Twin", "2450 Mhz Digital Twin V2" ] ;
        
        
 ModelRunAll = ["915 Mhz Tumor Naive", "915 Mhz Digital Twin",...
            "2450 Mhz Tumor Naive", "2450 Mhz Digital Twin", ...
            "2.45 GHz Tumor Naive V2",  "2450 Mhz Digital Twin V2" ] ;       
ModelRun = ModelRunAll(modelNum); 
switch ModelRun
    
    %%% 915 Mhz Tumor Naive Models
    case  "915 Mhz Tumor Naive"
        cd 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive\Vol'
        meanVol = [8.81, 9.57, 9.96, 10.82, 12.58];
        sdVol = [.25, .54, .59, .69, .52];
            
    %%% 915 Mhz Digital Twin Models    
    case "915 Mhz Digital Twin"
        cd 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin\Vol';
        meanVol = [8.26, 9.19, 10.47, 11.39, 13.23];
        sdVol = [0.19, 0.36, 0.36, 0.86, 0.51]; 
        
    %%% 2450 Mhz Tumor Naive Models
    case "2450 Mhz Tumor Naive"   
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2\2.45 GHz Tumor Naive\Vol';
        meanVol = [4.3, 5.54, 6.85, 8.21, 10.29 ];
        sdVol = [0.97, 0.38, 0.51, 0.84, 0.65];        
        
    %%% 2450 Mhz Digital Twin Models
    case "2450 Mhz Digital Twin"
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2\2.45 GHz Digital Twin\Vol'
 
        
    case "2.45 GHz Tumor Naive V2"
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2\Volume'
        meanVol = [ 11.62, 12.07, 13.25, 14.12, 15.07  ];
        sdVol = [ 0.24, 0.17, 0.33, 0.18, 0.45   ];  
        
        
    case "2450 Mhz Digital Twin V2"
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2\Vol'
        meanVol = [11.27, 11.86, 14.22, 16.33, 17.48   ];
        sdVol = [ 0.22, 0.37, 0.22, 0.40, 0.66  ];  
end 

disp(ModelRun)
%   
type = "PPV";

gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];
Fillcolors = [ green; orange; blue; gold]; 

lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
names = dir('*.csv');

%  fi = @(i) 3*(i-1) + 3;
fi = @(i) i+0;

for allFilenames = 1:length(names)
    currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
    volumeData = readtable(currentFileName);
    volumeDataMod = volumeData{:,:};

    healthyLiverVolume = [healthyLiverVolume, volumeDataMod(:, fi(1) )  ];
    lowFatVolume = [lowFatVolume, volumeDataMod(:, fi(2) ) ];
    mildFatVolume = [mildFatVolume, volumeDataMod(:, fi(3)) ];
    moderateFatVolume = [moderateFatVolume, volumeDataMod(:,  fi(4)  ) ];
    highFatVolume = [highFatVolume, volumeDataMod(:,  fi(5)  ) ];

end 

ogLiverVolume = volumeDataMod(2,1); 

if type == "PPV"
    roundData.healthyLiverVolume = round( healthyLiverVolume./ ogLiverVolume , 2) ;
    roundData.lowFatVolume = round( lowFatVolume./ ogLiverVolume, 2) ;
    roundData.mildFatVolume = round( mildFatVolume./ ogLiverVolume, 2) ;
    roundData.moderateFatVolume = round( moderateFatVolume./ ogLiverVolume, 2) ;
    roundData.highFatVolume = round( highFatVolume./ ogLiverVolume, 2) ;
else 
    roundData.healthyLiverVolume = round( healthyLiverVolume, 2) ;
    roundData.lowFatVolume = round( lowFatVolume, 2) ;
    roundData.mildFatVolume = round( mildFatVolume, 2) ;
    roundData.moderateFatVolume = round( moderateFatVolume, 2) ;
    roundData.highFatVolume = round( highFatVolume, 2) ;   
end 


%Find the mean and stadard deviation of all of the runs
meanVolumeMatrix = [ mean(healthyLiverVolume,2) , mean(lowFatVolume,2),...
        mean(mildFatVolume,2), mean(moderateFatVolume,2), mean(highFatVolume,2)];
stdev_vol_matrix = [std(healthyLiverVolume,0,2), std(lowFatVolume,0,2),...
        std(mildFatVolume,0,2), std(moderateFatVolume,0,2), std(highFatVolume,0,2)];
    
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'

%
%Analysis of the Long Axis Diameter
str5 = strcat( string( round( meanVolumeMatrix  , 2) ), '±') ;
str6 = string( round( stdev_vol_matrix ,2 ) ); 

meanMat.StringVolumeMatrix = strcat( str5, str6);
meanMat.TableVolumeMatrix  = table(meanMat.StringVolumeMatrix );

	if mod(modelNum,2) == 1
       
        meanVolumeMatrix2 = meanVol;
        stdev_vol_matrix2 = sdVol; 
        ModelRun2 = ModelRun; 
        
    end 

end 

%%

tTestChoice = "Between Models";

meanVolumeMatrix = meanVol;
stdev_vol_matrix = sdVol;
switch tTestChoice 
    case "Same"
    %Assigning the x and y vectors 
        x = meanVolumeMatrix(end, :) ;
        x_sd = stdev_vol_matrix(end, :);
        
        y =  meanVolumeMatrix(end, :) ;  
        y_sd = stdev_vol_matrix(end, :);
        ModelRun2 = ModelRun;
        
    case "Between Models"
        x = meanVolumeMatrix(end, :) ;
        x_sd = stdev_vol_matrix(end, :);
        
        y =  meanVolumeMatrix2(end, :) ;
        y_sd = stdev_vol_matrix2(end, :); 

end 


%[significance_matrix] = t_test_between_data_sets(x,x_sd,y,y_sd,num_subjects)
[significance_matrix] = t_test_between_data_sets(x,x_sd,y,y_sd,4);

cdata = reshape(significance_matrix(:,5),[],5);
xvalues = [];
yvalues  = [];
xvalues_names = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
yvalues_names = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
for i = 1:5
     xvalues = [xvalues, join([xvalues_names(i),'-', round(x(i),2) ])]; 
     yvalues = [yvalues, join([yvalues_names(i),'-', round(y(i),2) ])]; 
end     
    
%
Vandy_map = [green; blue; blue; blue; blue; ...
            orange; orange; orange; orange; orange;
            gold; gold; gold; gold; gold;
            purple;  purple; purple; purple;  purple;];
        
newmap = brighten(Vandy_map,.7);
figure()
set(gcf,'color','w');

h = heatmap(xvalues,yvalues, cdata,'Colormap',newmap);
C=caxis;
caxis([0 , 1 ])
% h.ColorScaling = 'scaledcolumns';
h.Title = "Two-Paired Test P-Val For Ablation Volume";
h.XLabel = join([ModelRun, "Ablation Volume (cm^3)"]);
h.YLabel = join([ModelRun2, "Ablation Volume (cm^3)"]);
saveas(gcf,join(["Ablation Volume P_val Matrix",'.png']) )



%%
clear
close all

set(0,'defaultAxesFontSize',14)
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
gray = [119, 119, 199]./256; 

Markercolors = [green; blue; orange; gold; purple];

colorTumor = [ rgb("LightCoral") ; rgb("PaleGreen") ; ...
    rgb("CornSilk") ; rgb("PowderBlue") ;
    rgb("LightCoral") ; rgb("PaleGreen") ; ...
    rgb("CornSilk") ; rgb("PowderBlue") ; ] ;

 ModelRunAll = ["915 MHz", "2450 MHz" ];
 ModelData =  "915 MHz";   
 
 
Calc.TumorAblatedTumorNaive915 = [ 8.81; 9.57; 9.96; 10.82; 12.58  ]; 
Calc.TumorAblatedTumorInformed915 = [ 8.26; 9.19; 10.47; 11.39; 13.23  ]; 
Simulation915MHz = [5.96	6.16	6.38	7.03	7.56;
5.47	5.57	5.76	5.92	6.29;
5.68	5.79	6.00	6.23	6.42;
5.25	5.27	5.42	5.73	5.90;
5.57	6.01	6.67	7.49	7.70;
5.22	5.58	6.13	5.91	7.13;
5.10	5.62	6.08	6.58	7.51;
4.82	5.10	5.41	6.30	6.80;
]';

Calc.Collateral_TN_915 = Calc.TumorAblatedTumorNaive915 - Simulation915MHz(:,1:4);  
% Calc.MeanCollateral_TN_915 = mean(Calc.Collateral_TN_915, 2); 
Calc.Collateral_TI_915 = Calc.TumorAblatedTumorInformed915 - Simulation915MHz(:,5:8); 
% Calc.MeanCollateral_TI_915 = mean(Calc.Collateral_TI_915, 2); 

Calc.TumorAblatedTumorNaive2450 = [ 11.62; 12.07; 13.25; 14.12; 15.07  ]; 
Calc.TumorAblatedTumorInformed2450 = [ 11.27; 11.86; 14.22; 16.33; 17.48  ]; 
Simulation2450MHz = [9.20	9.37	9.67	10.66	10.72;
8.68	8.99	9.85	10.18	10.31;
8.72	8.92	9.17	9.94	10.01;
8.85	8.91	9.34	10.19	10.40;
8.98	9.31	10.33	10.82	11.27;
8.54	8.80	10.02	10.98	11.24;
8.50	8.80	9.76	10.68	10.97;
8.61	8.83	9.54	10.82	11.27;
]';

Calc.Collateral_TN_2450 = Calc.TumorAblatedTumorNaive2450 - Simulation2450MHz(:,1:4); 
% Calc.MeanCollateral_TN_2450  = mean(Calc.Collateral_TN_2450, 2); 
Calc.Collateral_TI_2450 = Calc.TumorAblatedTumorInformed2450 - Simulation2450MHz(:,5:8);  
% Calc.MeanCollateral_TI_2450 = mean(Calc.Collateral_TI_2450, 2); 


Calc.MeanCollateral_TN_915 = mean(Calc.Collateral_TN_915, 2); 
Calc.MeanCollateral_TI_915 = mean(Calc.Collateral_TI_915, 2); 
Calc.MeanAll_915 = (Calc.MeanCollateral_TN_915 + Calc.MeanCollateral_TI_915)/2;

Calc.MeanCollateral_TN_2450  = mean(Calc.Collateral_TN_2450, 2); 
Calc.MeanCollateral_TI_2450 = mean(Calc.Collateral_TI_2450, 2); 

group = [   "TN-A" "TN-A" "TN-A" "TN-A" "TN-A",...
            "TN-B" "TN-B" "TN-B" "TN-B" "TN-B",...
            "TN-C" "TN-C" "TN-C" "TN-C" "TN-C",...
            "TN-D" "TN-D" "TN-D" "TN-D" "TN-D",...
            "TI-A" "TI-A" "TI-A" "TI-A" "TI-A",...
            "TI-B" "TI-B" "TI-B" "TI-B" "TI-B",...
            "TI-C" "TI-C" "TI-C" "TI-C" "TI-C",...
            "TI-D" "TI-D" "TI-D" "TI-D" "TI-D"  ];
 
        
switch  ModelData   
    
    case "915 MHz"
        allData = Simulation915MHz;
        titleName = "Ablated Tissue in 915 MHz Models";


    
    case "2450 MHz"
        allData = Simulation2450MHz;
        titleName = "Ablated Tissue in 2450 MHz Models";    
end 



h = boxplot(allData,group, 'Color', 'k' ); % old version: h = boxplot([allData{:}],group);

title(titleName, 'FontSize', 17,'fontweight','bold')
hold on
% yline(4, 'color', gray)
% yline(5, 'color', gray)
% yline(6, 'color', gray)
% yline(7, 'color', gray)
% yline(8, 'color', gray)

set(h, 'linewidth' ,2)
set(gcf,'color','w');
ylabel("Tumor Ablated   [cm^{3}]", 'fontweight','bold')


h = findobj(gca,'Tag','Box');
jk = length(h):-1:1 ;
for j=1:length(h)
    index = jk(j);
    patch(get(h(j),'XData'),get(h(j),'YData'),colorTumor(index,:),'FaceAlpha',.15);
end


xCenter = 1:numel(allData); 


spread = 0.005; % 0=no spread; 0.5=random spread within box bounds (can be any value)
%
% pause(1)
allData = allData'; 

for i = 1:8
    for j = 1:5
     plot(rand(size(allData(i,j)))*spread -(spread/2) + xCenter(i),...
         allData(i,j),'.',  'MarkerSize', 30,'Color',Markercolors(j,:))
    end 
%     pause(.25)
end


switch  ModelData  
    
        case "915 MHz"
        ylim([ (min(min(allData)-1))  max(max((allData)+2)) ])
            
            
        yl = yline( 11.7*.75 ,'-','LineWidth',1);
        yl.LabelHorizontalAlignment = 'center';
        yl.Color = rgb('Snow');


        hold on 
        ax = gca;
        yyaxis right
        ax.YAxis(2).Color = rgb('SlateGray') ;
        xs = [1,1,1,1,1].*1.5; 
        ys = [4,5,6,7,9.5]/11.7*100;
        plot( xs,ys, 'w')
        ylabel('% Tumor Ablated','fontweight','bold')
    
    case "2450 MHz"
        
        ylim([ (min(min(allData)-1.5)) 11.7 ])
        
        
        yl = yline(11.7,'-','LineWidth',1);
        yl.LabelHorizontalAlignment = 'center';
        yl.Color = rgb('Snow');


        hold on 
        ax = gca;
        yyaxis right
        ax.YAxis(2).Color = rgb('SlateGray') ;
        xs = [1,1,1,1,1].*1.5; 
        ys = [8,9,10,11,11.7]/11.7*100 ;
        plot( xs,ys, 'w')
        ylabel('% Tumor Ablated', 'fontweight','bold')

        
end 

ax = gca;
ax.FontSize = 14;  % Font Size of 15
ax.FontWeight = 'bold'; 

% 
% switch  ModelData   
%     
%     case "915 MHz"
% 
%         yline(4/11.7*100, 'color', gray)
%         yline(5/11.7*100, 'color', gray)
%         yline(6/11.7*100, 'color', gray)
%         yline(7/11.7*100, 'color', gray)
%         yline(8/11.7*100, 'color', gray)
% 
% 
%     
%     case "2450 MHz"
%        
%         yline(8/11.7*100, 'color', gray)
%         yline(9/11.7*100, 'color', gray)
%         yline(10/11.7*100, 'color', gray)
%         yline(11/11.7*100, 'color', gray)
%         yline(12/11.7*100, 'color', gray)
% 
% end 



grid on

x0=250;
y0=250;
width=1050;
height=600;
set(gcf,'position',[x0,y0,width,height])

f = gcf;
exportgraphics(f,join([ModelData, "Ablation Volume P_val Matrix",'.png']),'Resolution',1400)





%%
close all

gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];  


%                                                                           Diameter

all_runs = [ "915 MHz Short Diameter", "915 MHz Long Diameter"...
    "2450 MHz Short Diameter" , "2450 MHZ Long Diameter",...
    "TN-DT 915 MHz Short Diameter", "TI-DT 915 MHz Short Diameter",...
    "TN-DT 915 MHz Long Diameter", "TI-DT 915 MHz Long Diameter" ,...
    "TN-DT 2450 MHz Short Diameter", "TI-DT 2450 MHz Short Diameter",...
    "TN-DT 2450 MHZ Long Diameter", "TI-DT 2450 MHZ Long Diameter"];

ModelRun = "915 MHz Long Diameter"; 



switch ModelRun
    
    %%%                                SHORT DIAMETER
    case "915 MHz Short Diameter"
        x =     [ 1.75, 1.77, 1.82, 1.83, 1.84 ];
        x_sd =  [ .1, .09, .1, .16, .13 ];
        y =     [ 1.69, 1.76, 1.86, 1.93, 2.12];
        y_sd =  [ .11, .11, .10, .18, .14 ];    
        axis = "Short-Axis"; 
        
    case "TN-DT 915 MHz Short Diameter"
        x =     [ 1.75, 1.77, 1.82, 1.83, 1.84 ];
        x_sd =  [ .1, .09, .1, .16, .13 ];
        y =     x;
        y_sd =  x_sd;    
        axis = "TN Short-Axis";    
        
    case "TI-DT 915 MHz Short Diameter"
        x =     [ 1.69, 1.76, 1.86, 1.93, 2.12];
        x_sd =  [ .11, .11, .10, .18, .14 ]; 
        y =     x;
        y_sd =  x_sd;    
        axis = "TI Short-Axis";           
        
        
    %%%                                LONG DIAMETER
    case "915 MHz Long Diameter"
        x =     [5.67, 6.00, 6.04, 6.64, 6.95  ];
        x_sd =  [.10, .16, .67, .80, .72 ];
        y =     [5.78, 5.98, 6.26, 6.84, 7.06 ];
        y_sd =  [.02, .11, .19, .23, .19  ];
        axis = "Long-Axis";
        
    case "TN-DT 915 MHz Long Diameter"   
        x =     [5.67, 6.00, 6.04, 6.64, 6.95  ];
        x_sd =  [.10, .16, .67, .80, .72 ];  
        y =     x;
        y_sd =  x_sd;
        axis = "TN Long-Axis";

    case "TI-DT 915 MHz Long Diameter"   
        x =     [5.78, 5.98, 6.26, 6.84, 7.06 ];
        x_sd =  [.10, .16, .67, .80, .72 ];  
        y =     x;
        y_sd =  x_sd; 
        axis = "TI Long-Axis";    
        
        
        
     %%%                                SHORT DIAMETER       
    case "2450 MHz Short Diameter"
        x =     [2.44, 2.51, 2.83, 3.03, 3.10];
        x_sd =  [.04, .06, .02, .02, .05];
        y =     [2.55, 2.59, 2.64, 2.65, 2.68];
        y_sd =  [.04, 0.04, 0.08, 0.05, 0.03];
        axis = "Short-Axis"; 

     case "TN-DT 2450 MHz Short Diameter"
        x =     [2.44, 2.51, 2.83, 3.03, 3.10];
        x_sd =  [.04, .06, .02, .02, .05];
        y =     x;
        y_sd =  x_sd;
        axis = "Short-Axis"; 
 
     case "TI-DT 2450 MHz Short Diameter"
        x =     [2.55, 2.59, 2.64, 2.65, 2.68];
        x_sd =  [.04, 0.04, 0.08, 0.05, 0.03];
        y =     x;
        y_sd =  x_sd;
        axis = "Short-Axis";
        
        
        
    %%%                                LONG DIAMETER    
    case "2450 MHZ Long Diameter"
        x =      [3.92, 4.00, 4.09, 4.10, 4.36];
        x_sd =   [.08, .09, 0.12, 0.05, 0.06];
        y =      [4.01, 4.01, 4.02, 4.03, 4.04];
        y_sd =   [.11, .12, .11, .09, .08];      
        axis = "Long-Axis"; 
        
    case "TN-DT 2450 MHZ Long Diameter"
        x =      [3.92, 4.00, 4.09, 4.10, 4.36];
        x_sd =   [.08, .09, 0.12, 0.05, 0.06];
        y =      x;
        y_sd =   y_sd;      
        axis = "Long-Axis"; 
        
    case "TI-DT 2450 MHZ Long Diameter"
        x =      [4.01, 4.01, 4.02, 4.03, 4.04];
        x_sd =   [.11, .12, .11, .09, .08];
        y =      x;
        y_sd =   y_sd;      
        axis = "Long-Axis"; 
        
end 



%[significance_matrix] = t_test_between_data_sets(x,x_sd,y,y_sd,num_subjects)
[significance_matrix] = t_test_between_data_sets(x,x_sd,y,y_sd,4);

cdata = reshape(significance_matrix(:,5),[],5);
xvalues = [];
yvalues  = [];
xvalues_names = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
yvalues_names = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
for i = 1:5
     xvalues = [xvalues, join([xvalues_names(i),'-', round(x(i),2) ])]; 
     yvalues = [yvalues, join([yvalues_names(i),'-', round(y(i),2) ])]; 
end     
    
%
Vandy_map = [green; blue; blue; blue; blue; ...
            orange; orange; orange; orange; orange;
            gold; gold; gold; gold; gold;
            purple;  purple; purple; purple;  purple;];
        
newmap = brighten(Vandy_map,.7);
figure()
set(gcf,'color','w');

h = heatmap(xvalues,yvalues, cdata,'Colormap',newmap);
C=caxis;
caxis([0 , 1 ])
% h.ColorScaling = 'scaledcolumns';
h.Title = join([ "Two-Paired Test P-Val For", axis ,"Diameter" ]);
h.XLabel = join([ModelRun, "TE Short Axis Diameter(cm)"]);
h.YLabel = join([ModelRun, "TI Short Axis Diameter (cm)"]);
saveas(gcf,join(["Ablation Volume P_val Matrix",'.png']) )










