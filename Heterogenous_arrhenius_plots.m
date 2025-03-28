clear
close all
set(gcf,'color','w');
% tumor = "False" ;
finalVolume=  [];
final_sd = [];
% figure()
for choiceInt = 2:-1:1%-1:1 %2:2  % 
    


lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
%%% 
choice = ["TRUE","FALSE"];
linestyle = ["-.","-"];
lineChoice = linestyle(choiceInt);
tumor = choice( choiceInt );
disp(tumor)

if tumor == "TRUE"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No Tumor Volume'

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
    % Mean_Volume_Matrix = [mean(Healthy_liver_volume,2), mean(low_fat_volume,2),...
    %         mean(mild_fat_volume,2), mean(moderate_fat_volume,2), mean(High_fat_volume,2)];
    meanVolumeMatrix = [ mean(healthyLiverVolume,2) , mean(lowFatVolume,2),...
            mean(mildFatVolume,2), mean(moderateFatVolume,2), mean(highFatVolume,2)];
    stdev_vol_matrix = [std(healthyLiverVolume,0,2), std(lowFatVolume,0,2),...
            std(mildFatVolume,0,2), std(moderateFatVolume,0,2), std(highFatVolume,0,2)];
%


% %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALL_Volume_A_98_Homg_No_tumor.csv";
% %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALLVolumeA98HomogenousAnalysisNoTumor.csv";
% %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSpecificSampling\ProcessedData\ALLVolumeA98TumorSpecificSamplingEllipseNewData.csv";
% %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\5minPowerOff\ProcessedData\ALLVolumeA98PatientDataHeterogenous5minPowerOff.csv";
% 
% 
% fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALLVolumeA98HomogenousAnalysisNoTumorEllipseNewData.csv";
% 
% %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALLVolumeA98HomogenousAnalysisNoTumorEllipseNewData.csv";
% 
% %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allVolumeEllipsewithBaseline.csv"
% 
% volumeData = readtable(fileName);
% MVM =  table2array(volumeData(2:end,1:end));
% % 
% % %%meanVolumeMatrix(:,1:2) = MVM(:,1:2);
% meanVolumeMatrix = MVM;

fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Temp Dependent\ProcessedData\ALLVolumeA98TissueSpecificSamplingEllipseTempDependent.csv"; 
volumeData = readtable(fileName);
meanVolumeMatrix =  table2array(volumeData(3:end,1:end));
addI = 0;

else
    %cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1'
    
    
    %%%%good to go!
        %%%Heterogenous Data 
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSpecificSampling\ProcessedData\ALLVolumeA98TissueSpecificSampling.csv";
    
                     %%% Half cube Het Model
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\WholeCubeData\ProcessedData\ALLVolumeA98WholeCube.csv"
    
                    %%%With Tissue Sampling Heterogenous + Temp Dependent     
%     fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Temp Dependent\ProcessedData\ALLVolumeA98TissueSpecificSamplingEllipseTempDependent.csv";
%     
                    %%%With Tissue Sampling Heterogenous + Temp Dependent +
                    %%% power off
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Temp Dependent\5minPowerOff\ProcessedData\ALLVolumeA98PatientDataHeterogenousTempDependent5minPowerOff.csv";
    
                    %%%With Tissue Sampling Heterogenous 
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSamplingwPerf\ProcessedData\ALLVolumeA98TumorSpecificSampling.csv";
 


        %%%Homoogenous Data 
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\FatSpheres\Results\ALLVolumeFatSphere.csv";
                    %%% Deshazer + Homogenous
    fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allVolumeEllipsewithBaseline.csv";
%                   %%% Silva  + Homogenous
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Silva\Processed Data\allVolumeEllipseSilva.csv";
    
    
%     fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Silva 2.45 GHz\Results\allVolumeEllipseSilva2450.csv";
%     
%     fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Vandy_Scout_017\Silva Models\Results\ALLVolumeA98PatientDataHomogenousSilva.csv";
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\FatSpheres\Sparse\Results\ALLVolumeSparseFatSphere.csv";
    volumeData = readtable(fileName);
    meanVolumeMatrix =  table2array(volumeData(3:end,1:end));
    addI = 1;

end 




gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
% colors = [green; blue; orange; gold; purple];
colors = [blue; orange; gold; purple];
Fillcolors = [ green; orange; blue; gold]; 



%legend_base = ["No Fat", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
%titleName = join([ "Ablation Trajectory in Patient 017",newline "Temperature Dependent Models", newline, "915 MHz Silva"]);
titleName = join([ "Ablation Trajectory in All Models" ]); 
legendBase = [ "Healthy", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
set(gcf,'color','w');
legendString = [];
trapz_matrix=  [];



for i = 4:-1:1 %width(meanVolumeMatrix):-1:1
    
    
    %time = ([0:.25:15]); %.*45.*60./1000;   
    time = ([0:.25:15]);
    selectColor = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2.5);
        %%Add Standard Deviation
        
        p = plot(time, (meanVolumeMatrix(1:end, i + addI )) ) ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        legendString = [legendString, join([legendBase( i+1 )])]; 
        
        
        if i  == width(meanVolumeMatrix)
            top_curve = (meanVolumeMatrix(2:end,i))';
        end 
        if i  == 1
            bottom_curve = (meanVolumeMatrix(2:end,i))';
        end 
end 
        finalVolume = [finalVolume, meanVolumeMatrix(end,:)];
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
   
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
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
    ylabel("Ablation Volume cm^3",'fontweight','bold')
    xlabel("Time (min)",'fontweight','bold')
    %title("Ablation Trajectory in All Dense Fat Sphere Models")
    title(titleName, 'fontweight','bold')
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
end

ax = gca;
ax.FontSize = 22;  % Font Size of 15
ax.FontWeight = 'bold'; 

% hold off
% plotFigureName = 'Combined_Ablation_Volume_plot_heterogenous.png';
% saveas(gcf,plotFigureName)
