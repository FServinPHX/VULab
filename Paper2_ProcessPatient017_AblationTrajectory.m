    
%clear



cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\Volume and Diameter\Volume'

lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
names = dir('*.csv');

for allFilenames = 1:length(names)
    currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
    volumeData = readtable(currentFileName);
    volumeDataMod = volumeData{:,:};

    healthyLiverVolume = [healthyLiverVolume, volumeDataMod(:,1)  ];
    lowFatVolume = [lowFatVolume, volumeDataMod(:,2) ];
    mildFatVolume = [mildFatVolume, volumeDataMod(:,3) ];
    moderateFatVolume = [moderateFatVolume, volumeDataMod(:,4) ];
    highFatVolume = [highFatVolume, volumeDataMod(:,5) ];

end 
%Find the mean and stadard deviation of all of the runs
meanVolumeMatrix = [ mean(healthyLiverVolume,2) , mean(lowFatVolume,2),...
        mean(mildFatVolume,2), mean(moderateFatVolume,2), mean(highFatVolume,2)];
stdev_vol_matrix = [std(healthyLiverVolume,0,2), std(lowFatVolume,0,2),...
        std(mildFatVolume,0,2), std(moderateFatVolume,0,2), std(highFatVolume,0,2)];
    
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
   
    
%   
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];
Fillcolors = [ green; orange; blue; gold]; 



%legend_base = ["No Fat", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
titleName = join([ "Ablation Trajectory in Patient 017",newline "Temperature Dependent Models", newline, "915 MHz Silva"]);
legendBase = [ "Healthy", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
set(gcf,'color','w');
legendString = [];
trapz_matrix=  [];
choiceInt = 1
linestyle = ["-","-."];
lineChoice = linestyle(choiceInt);


for i = width(meanVolumeMatrix):-1:1
    %time = ([0:.25:15]); %.*45.*60./1000;   
    time = ([0:.25:15]);
    selectColor = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2.5);
        
        
        p = plot(time, (meanVolumeMatrix(2:end,i)) ) ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        
        %%Add Standard Deviation to the plot
        set(gcf,'defaultLegendAutoUpdate','off')
        p2 = plot( time, ( meanVolumeMatrix(2:end,i) + stdev_vol_matrix(2:end,i) ) );
        p2.LineStyle = "--";
        p2.Color = 'k';
        p2.LineWidth = .5;
        p2.Annotation.LegendInformation.IconDisplayStyle = 'off';
        
        
        set(groot,'defaultLegendAutoUpdate','off')
        p3 = plot( time, ( meanVolumeMatrix(2:end,i) - stdev_vol_matrix(2:end,i) ) );
        p3.LineStyle = "--";
        p3.Color = 'k';
        p3.LineWidth = .5;
        p3.Annotation.LegendInformation.IconDisplayStyle = 'off';
        
        
        legendString = [legendString, join([legendBase(i)])]; 
        
        
        
%         if i  == width(meanVolumeMatrix)
%             top_curve = (meanVolumeMatrix(2:end,i))';
%         end 
%         if i  == 1
%             bottom_curve = (meanVolumeMatrix(2:end,i))';
%         end 
end 
%         finalVolume = [finalVolume, meanVolumeMatrix(end,:)];
        %final_sd = [final_sd, stdev_vol_matrix(end,:)];
        
        xPoints = [20, 20, 35, 35]/ ( 45.*60./1000 );  
        yPoints = [0, meanVolumeMatrix(end,4) + 1,...
            meanVolumeMatrix(end, 4) + 1, 0];
        color = [.84, .8, .2];
        hold on;
%         if choiceInt < 2
%             a = fill(xPoints, yPoints, color);
%             a.FaceAlpha = 0.1; 
%         end 
        set(gcf,'position',[80,80,800,600])  
   
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%     if tumor == "TRUE" ||   tumor == "JARROD_DESHAZER-TUMOR" 
%         titleName = ["ALL Patients Necrotic_Volume_915_A_995_Tumor"];
%         %title("Necrotic Volume (cm^3) vs Dose (J) Models with 20 mm Diameter Tumor")
%     else 
%         titleName = ["ALL Patients Necrotic_Volume_915_A_995_No_Tumor"];
%         %title("Necrotic Volume (cm^3) vs Dose (J) Models without Tumor")
%     end 
%     



%%% Fill in between Data     
%     curve1 = bottom_curve; 
%     curve2 = top_curve;
%     x2 = [(time) , fliplr(time) ] ; %[time, fliplr(time) ];
%     inBetween =  [(curve1) , fliplr(curve2)];
%     h = fill(x2, inBetween,  Fillcolors(choiceInt,:) ); 
%     set(h,'facealpha',.5)
%     trap_val = trapz(time ,curve1- curve2);
%     hold on
%     
%     trapz_matrix = [trapz_matrix, trapz(x,curve1-curve2)];


    %PLOT information
    legend(legendString, 'Location', 'best')
    ylim([0 meanVolumeMatrix(end,4) + 1.5 ])
    ylabel("Ablation Volume cm^3")
    xlabel("Time (min)")
    %title("Ablation Trajectory in All Dense Fat Sphere Models")
    title(titleName)
        legend('AutoUpdate', 'off')
%         yline(9)
%         text(2,9.25,'9')
%         yline(10)
%         text(2,10.25,'10')       
%         yline(11)
%         text(2,11.25,'11')
%         xlim([0 40])
%         text(2,12.25,'12')
%         xlim([0 40])
    %title("Ablation Trajectory in Homogenous vs Heterogenous")
    set(gca,'FontSize',16)
    plotFigureName = join([titleName,'.png' ]);



% hold off
% plotFigureName = 'Combined_Ablation_Volume_plot_heterogenous.png';
% saveas(gcf,plotFigureName)
%%


lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
names = dir('*.csv');

for allFilenames = 1:length(names)
    currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
    volumeData = readtable(currentFileName);
    volumeDataMod = volumeData{:,:};

    healthyLiverVolume = [healthyLiverVolume, volumeDataMod(:,5)  ];
    lowFatVolume = [lowFatVolume, volumeDataMod(:,2) ];
    mildFatVolume = [mildFatVolume, volumeDataMod(:,3) ];
    moderateFatVolume = [moderateFatVolume, volumeDataMod(:,4) ];
    highFatVolume = [highFatVolume, volumeDataMod(:,1) ];

end 
%Find the mean and stadard deviation of all of the runs
meanVolumeMatrix = [ mean(healthyLiverVolume,2) , mean(lowFatVolume,2),...
        mean(mildFatVolume,2), mean(moderateFatVolume,2), mean(highFatVolume,2)];
stdev_vol_matrix = [std(healthyLiverVolume,0,2), std(lowFatVolume,0,2),...
        std(mildFatVolume,0,2), std(moderateFatVolume,0,2), std(highFatVolume,0,2)];
    
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
   
    
%   
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];
Fillcolors = [ green; orange; blue; gold]; 
%%





clear
close all
set(gcf,'color','w');
% tumor = "False" ;
finalVolume=  [];
final_sd = [];
%   TRUE    FALSE
FillIN = "TRUE";

% figure()
for choiceInt = 1:2 %-1:1 %2:2  % 
    

    lowFatVolume = [];
    mildFatVolume = [];
    moderateFatVolume = [];
    highFatVolume = [];
    healthyLiverVolume = [];
    %%% 
    choice = ["TRUE","FALSE"];
    linestyle = ["-","-."];
    lineChoice = linestyle(choiceInt);
    tumor = choice( choiceInt );
    disp(tumor)

if tumor == "TRUE"



fileName = "D:\Import To Matlab\Probe B\Results\ALLVolumeA98PatientDataPosB.csv"; 
volumeData = readtable(fileName);
meanVolumeMatrix =  table2array(volumeData(2:end,1:end));

else

fileName = "D:\Import To Matlab\Probe B NT\Results\ALLVolumeA98PatientDataPosB_NT.csv";
volumeData = readtable(fileName);
meanVolumeMatrix =  table2array(volumeData(2:end,1:end));

end 



    gold = [0.847058824	0.670588235	0.298039216];
    blue = [0 0.4470 0.7410];
    green = [0.4660 0.6740 0.1880];
    red = [0.6	0.239215686	0.105882353];
    orange = [0.8500 0.3250 0.0980];
    purple = [0.4940 0.1840 0.5560];
    black = [0	0	0];
    colors = [green; blue; orange; gold; purple];
    Fillcolors = [ green; orange; blue; gold]; 


%legend_base = ["No Fat", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
titleName = join([ "Ablation Trajectory in Patient 017",newline "Temperature Dependent Models"]);
legendBase = [ "Healthy", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
set(gcf,'color','w');
legendString = [];
trapz_matrix=  [];
Show_PLot = [1,5]; 


for i = width(meanVolumeMatrix):-1:1
    %time = ([0:.25:15]); %.*45.*60./1000;   
    time = ([0:.25:15]);
    selectColor = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2.5);
        %%Add Standard Deviation
        
        if ismember( i, Show_PLot) 
        p = plot(time, (meanVolumeMatrix(1:end,i)) ) ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        legendString = [legendString, join([legendBase(i)])]; 
        end 
        
        
        if i  == width(meanVolumeMatrix)
            top_curve = (meanVolumeMatrix(1:end,i))';
        end 
        if i  == 1
            bottom_curve = (meanVolumeMatrix(1:end,i))';
        end 
end 
        finalVolume = [finalVolume, meanVolumeMatrix(end,:)];
        %final_sd = [final_sd, stdev_vol_matrix(end,:)];
        
        xPoints = [20, 20, 35, 35]/ ( 45.*60./1000 );  
        yPoints = [0, meanVolumeMatrix(end,4) + 1,...
            meanVolumeMatrix(end, 4) + 1, 0];
        color = [.84, .8, .2];
        hold on;

        set(gcf,'position',[80,80,800,600])  
   
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'

%%% Fill in between Data   

    if FillIN == "TRUE"
        curve1 = bottom_curve; 
        curve2 = top_curve;
        x2 = [(time) , fliplr(time) ] ; %[time, fliplr(time) ];
        inBetween =  [(curve1) , fliplr(curve2)];
        h = fill(x2, inBetween,  Fillcolors(choiceInt,:) ); 
        set(h,'facealpha',.5)
        trap_val = trapz(time ,curve1- curve2);
        hold on
    end 

    
    
    
    %PLOT information
    legend(legendString, 'Location', 'best')
    ylim([0 meanVolumeMatrix(end,4) + 1.5 ])
    ylabel("Ablation Volume cm^3")
    xlabel("Time (min)")
    %title("Ablation Trajectory in All Dense Fat Sphere Models")
    title(titleName)
        legend('AutoUpdate', 'off')

    set(gca,'FontSize',16)
    plotFigureName = join([titleName,'.png' ]);
end



