clear
set(gcf,'color','w');
tumor = "TRUE" ;
finalVolume=  [];
final_sd = [];
% figure()
for choiceInt = 2:2  %-1:1 %2:2  % 
    


lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
%%% 
choice = ["TRUE","FALSE"];
linestyle = ["-","--"];
lineChoice = linestyle(choiceInt);
tumor = choice( choiceInt );
disp(tumor)

if tumor == "TRUE"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No Tumor Volume'

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
meanVolumeMatrix = [mean(lowFatVolume,2),...
        mean(mildFatVolume,2), mean(moderateFatVolume,2), mean(highFatVolume,2)];
stdev_vol_matrix = [std(healthyLiverVolume,0,2), std(lowFatVolume,0,2),...
        std(mildFatVolume,0,2), std(moderateFatVolume,0,2), std(highFatVolume,0,2)];
%


% %%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALL_Volume_A_98_Homg_No_tumor.csv";
%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALLVolumeA98HomogenousAnalysisNoTumor.csv";
%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSpecificSampling\ProcessedData\ALLVolumeA98TumorSpecificSamplingEllipseNewData.csv";
%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\5minPowerOff\ProcessedData\ALLVolumeA98PatientDataHeterogenous5minPowerOff.csv";


%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALLVolumeA98HomogenousAnalysisNoTumorEllipseNewData.csv";
%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALLVolumeA98HomogenousAnalysisNoTumorEllipseNewData.csv";

%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allVolumeEllipse.csv"

volumeData = readtable(fileName);
MVM =  table2array(volumeData(2:end,1:4));
% 
% %%meanVolumeMatrix(:,1:2) = MVM(:,1:2);
meanVolumeMatrix = MVM;

else
    %cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1'

        %%%Heterogenous Data 

    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSpecificSampling\ProcessedData\ALLVolumeA98TissueSpecificSampling.csv";
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSpecificSampling\ProcessedData\ALLVolumeA98TissueSpecificSamplingEllipseNewData.csv";
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\WholeCubeData\ProcessedData\ALLVolumeA98WholeCube.csv"
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Temp Dependent\ProcessedData\ALLVolumeA98TissueSpecificSamplingEllipseTempDependent.csv";
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Temp Dependent\5minPowerOff\ProcessedData\ALLVolumeA98PatientDataHeterogenousTempDependent5minPowerOff.csv";

    %good to go

        %%%Homoogenous Data 
        
    fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allVolumeEllipsewithBaseline.csv";
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\TumorSamplingwPerf\ProcessedData\ALLVolumeA98TumorSpecificSampling.csv";
    %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allVolumeEllipse.csv";



    volumeData = readtable(fileName);
    meanVolumeMatrix =  table2array(volumeData(2:end,:));

end 
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];

legendBase = ["No Fat", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
%legendBase = [ "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
set(gcf,'color','w');
legendString = [];
for i = width(meanVolumeMatrix):-1:1
    %time = ([0:.25:15]); %.*45.*60./1000;   
    time = ([0:.25:15]);
    selectColor = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2.5);
        %%Add Standard Deviation
        
        p = plot(time, (meanVolumeMatrix(2:end,i)) ) ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        legendString = [legendString, join([legendBase(i)])]; 

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
   
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    if tumor == "TRUE" ||   tumor == "JARROD_DESHAZER-TUMOR" 
        titleName = ["ALL Patients Necrotic_Volume_915_A_995_Tumor"];
        %title("Necrotic Volume (cm^3) vs Dose (J) Models with 20 mm Diameter Tumor")
    else 
        titleName = ["ALL Patients Necrotic_Volume_915_A_995_No_Tumor"];
        %title("Necrotic Volume (cm^3) vs Dose (J) Models without Tumor")
    end 
    
    %PLOT information
    legend(legendString, 'Location', 'best')
    ylim([0 meanVolumeMatrix(end,4) + 1])
    ylabel("Ablation Volume cm^3")
    xlabel("Time (min)")
    title("Ablation Trajectory in All Heterogenous Models")
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
hold off
% plotFigureName = 'Combined_Ablation_Volume_plot_heterogenous.png';
% saveas(gcf,plotFigureName)