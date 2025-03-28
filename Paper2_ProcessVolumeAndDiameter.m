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
linestyle = ["-","-."];
lineChoice = linestyle(choiceInt);
tumor = choice( choiceInt );
disp(tumor)

if tumor == "TRUE"

    

    

fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Vandy_Scout_017\Homog Tissue\Results\ALLVolumeA98PatientDataHomogenous.csv";
volumeData = readtable(fileName);
MVM =  table2array(volumeData(2:end,1:4));
% 
% %%meanVolumeMatrix(:,1:2) = MVM(:,1:2);
meanVolumeMatrix = MVM;
Iselect = [1,2,3,4]; 

else

        %%%Heterogenous Data 
    %good to go

        %%%Homoogenous Data 
        
    fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Vandy_Scout_017\Het. Tissue\Results\ALLVolumeA98PatientDataHeterogenous.csv";
    volumeData = readtable(fileName);
    meanVolumeMatrix =  table2array(volumeData(2:end,1:4));
    Iselect = [1,2,3,4]; 

end 
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];

%legend_base = ["No Fat", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
legendBase = [ "E", "F","G", "H"];
set(gcf,'color','w');
legendString = [];
for i =  1:length(Iselect) %1:2:width(meanVolumeMatrix)  %width(meanVolumeMatrix):-1:1
    
    ci = i; 
    i = Iselect(ci);
    
    %time = ([0:.25:15]); %.*45.*60./1000;   
    time = ([0:.25:15]);
    selectColor = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 4 );
        %%Add Standard Deviation
        
        p = plot(time, (meanVolumeMatrix(1:end,i)) ) ;
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
        titleName = ["Patient_017 Homog"];
        %title("Necrotic Volume (cm^3) vs Dose (J) Models with 20 mm Diameter Tumor")
    else 
        titleName = ["Patient_017 All"];
        %title("Necrotic Volume (cm^3) vs Dose (J) Models without Tumor")
    end 
    
    %PLOT information
    legend(legendString, 'Location', 'best')
    ylim([0 meanVolumeMatrix(end,4) + 1])
    ylabel("Ablation Volume cm^3")
    xlabel("Time (min)")
    title("Ablation Trajectory Heterogenous Models")
        legend('AutoUpdate', 'off')
 
    %title("Ablation Trajectory in Homogenous vs Heterogenous")
    set(gca,'FontSize',16)
    plotFigureName = join([titleName,'.png' ]);
    
    i = ci;
end
hold off
% plotFigureName = 'Combined_Ablation_Volume_plot_heterogenous.png';
% saveas(gcf,plotFigureName)
