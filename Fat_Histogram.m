%%
%Fat Histogram
%   ROI    ITK    Whole 
clear 
% close all

type = "ROI";


if type == "ROI"
    dirName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\ROI Analysis";
    dirName2 = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt\';
    
file_name = fullfile( dirName, "Patient_001_Masked Volume.nii.gz" ) ;

file_name2 = fullfile( dirName, "Patient_002_Masked Volume_1.nii.gz" );
%file_name2 = fullfile( dirName2, "1017_FF masked.nii.gz" );

file_name3 = fullfile( dirName, "Patient_003_Masked Volume.nii.gz" );
file_name4 = fullfile( dirName, "Patient_004_Masked Volume_2.nii.gz" ) ;
specialNum = 1; 
FaceAlphaN = .85;

elseif type == "Whole"
    dirName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\";
file_name = fullfile( dirName, "001_401 No series description_1 masked.nii.gz" );
file_name2 = fullfile( dirName, "002_401 No series description masked.nii.gz" );
file_name3 = fullfile( dirName, "003_whole_image_segmentation.nii.gz" );
file_name4 = fullfile( dirName, "004_whole_image_segmented_mask.nii.gz") ;
specialNum = 4; 
FaceAlphaN = .25;

elseif type == "ITK"
    dirName =  'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\ITK Threshold Masking\';
    dirName2 = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt\';
    
file_name = fullfile( dirName, "Patient 01\Patient_001_FatSegmentMaskVolume.nii.gz") ;

%file_name2 = fullfile( dirName,"Patient 02\Patient_002_FatSegmentMaskVolume.nii.gz") ;
file_name2 = fullfile( dirName2,"Liver_mased_Volume.nii.gz" ) ;

file_name3 = fullfile( dirName, "Patient 03\Ptient_003_FatSegmentMaskVolume.nii.gz") ;
file_name4 = fullfile( dirName, "Patient 04\Patient 004 Volume.nii.gz" ) ;
specialNum = 3; 
FaceAlphaN = .65;

elseif type == "PreSurgeryPlan"
    
    dirName = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt\';
    
file_name = fullfile( dirName, "Liver_mased_Volume.nii.gz") ;
file_name2 = [];
file_name3 = [];
file_name4 = [];
specialNum = 1;
FaceAlphaN = .45;

elseif type == "ADCMaps"
    
    dirName = 'D:\Slicer Models\1017_Vanderbilt\Perfusion Data';
    
file_name  = fullfile( dirName, "SegmentedLiver_v2.nii.gz") ;
file_name2 = fullfile( dirName, "SegmentedLiver_v2.nii.gz") ;
file_name3 = fullfile( dirName, "SegmentedLiver_v2.nii.gz") ;
file_name4 = fullfile( dirName, "SegmentedLiver_v2.nii.gz") ;
specialNum = 1;
FaceAlphaN = .45;


end 

SliceBySlice = "F";


gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [ blue; orange; gold; purple];
% colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];
colors2 = [ rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];


files = [file_name, file_name2, file_name3, file_name4];
Intensity_scale = [1,1,10,10];
%
set(gcf,'color','w');
set(gca,'FontSize',14)
mean_data = [];
sd_data = [];



for i = 1:4
    
    
[X] = niftiread(files(i));
dicom_hist_new_text = [];
dicom_hist_new = reshape(X, [],1);



X(X <= 0) = 0;
% dX = double(X);
% [glcm,SI] = graycomatrix(dX,'NumLevels',20,'GrayLimits',[min(min(dX(:))) , max(max(dX(:))) ]);
% stats = graycoprops(glcm);


X(X <= 0) = 0;
% dX = double(X);
% [glcm,SI] = graycomatrix(dX);
% stats = graycoprops(glcm);

stats.all = [];

% for j = 1:size(X,3)
%     Xc =  X(:,:,j);
%     Xc = double(Xc);
%     
%     
%     Xc = cropborder(Xc,[NaN NaN NaN NaN],'automode','deltavar','threshold',0.001);
% %     stats = graycoprops(Xc, 'homogeneity')
%     [glcm,SI] = graycomatrix(Xc,'NumLevels',20,'GrayLimits',[ (min(Xc(:)) +1) , (max(Xc(:)) + 2) ] );
%     statsG = graycoprops(glcm);
%     
%     stats.all = [stats.all, statsG.Homogeneity ]; 
%     imshow(Xc)
% end 

stats.keep = stats.all ;
stats.keep(stats.keep == 1) = [];

% 
% if SliceBySlice == "T"
%     %Plot a histogram of each slice 
%     for j = 1:size(X,3)
%         dicom_hist_new = double(X(:,:,j)); 
%         dicom_hist_new_text = dicom_hist_new;
%         %dicom_hist_new_text =[dicom_hist_new_text; dicom_hist_new]; 
%         dicom_hist_new_text(dicom_hist_new_text <= 0) = [];
% 
% 
% 
%             if ~isempty(dicom_hist_new_text)
%                 dicom_hist_new_text = dicom_hist_new_text/(Intensity_scale(i)) ;
%                 [N,edges] = histcounts(dicom_hist_new_text,20);
%                 mean_data = [mean_data, mean(double(dicom_hist_new_text))];
%                 sd_data = [sd_data, std(double(dicom_hist_new_text))];
%                 %dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
%                 %
% 
%                 %subplot(2,2,i)
%                 if  type == "Whole" || type == "ITK"
%                     colors = colors2;
%                 end 
% 
%                 figure(1)
%                 histogram(dicom_hist_new_text,10,'Normalization','pdf','BinWidth',1, ...
%                 'FaceColor',colors(i,:) ,'FaceAlpha', FaceAlphaN, 'EdgeAlpha', 1 )
%                 disp("Not Empty")
% 
% 
% 
%                 %%% Add standard deviation. Make Legend Larger 
% 
%                 % legend_string = ["3.9% fat", "14.7% fat", "22.0% fat", "29.9% fat"];
%                 % legend(legend_string,'AutoUpdate','off')
%                 txt = ["Low","Mild","Moderate","High"];
% 
%                 hold off
%                 xlim([0 45])
%                 ylim([0 .22])
%                 title(join(["Sampled Fat Distrbution", "   ", txt(i),"Fat",...
%                     newline, "Slice = ", num2str(j)]))
%                 xlabel("Fat %")
%                 ylabel("Probability Density")
% 
%                 %
%                 % the following line skip the name of the previous plot from the legend
%                 %h.Annotation.LegendInformation.IconDisplayStyle = 'off';
%                 % xline(0, '-', {'Low'}, 'LabelOrientation', 'horizontal')
%                 % xline(6,'-', {'Mild'},'LabelOrientation', 'horizontal')
%                 % xline(17,'-', {'Moderate'},'LabelOrientation', 'horizontal')
%                 % xline(23,'-', {'High'},'LabelOrientation',  'horizontal')
%                 xline(0, '-') %{'Low'}, 'LabelOrientation', 'horizontal')
%                 xline(6,'-')  %{'Mild'},'LabelOrientation', 'horizontal')
%                 xline(17,'-') %{'Moderate'},'LabelOrientation', 'horizontal')
%                 xline(23,'-') %{'High'},'LabelOrientation',  'horizontal')
%                 txt = ["Low","Mild","Moderate","High"];
% 
%                 text([0+6/2-1,6+(17-6)/2-1,17,23+(35-23)/2-2],[.21,.21,.21,.21],txt)
% 
% 
%                 figure(2)
%                     set(gcf,'color','w');
%                     set(gca,'FontSize',14)
%                     imagesc( X(:,:,j)./(Intensity_scale(i)) )
%                     title(join(["Sampled Fat Distrbution","   ", txt(i),"Fat",...
%                     newline, "Slice = ", num2str(j)]))
%                     colorbar
%                     colormap( jet )
% 
%                 pause(.20)
% 
%             else
%                 disp("empty")
%             end 
%        
% 
%     end 
% end 


dicom_hist_new_text =[dicom_hist_new_text; dicom_hist_new]; 
dicom_hist_new_text(dicom_hist_new_text <= 0) = [];
dicom_hist_new_text = dicom_hist_new_text/(Intensity_scale(i)) ;


[N,edges] = histcounts(dicom_hist_new_text,20);
mean_data = [mean_data, mean(double(dicom_hist_new_text))];
sd_data = [sd_data, std(double(dicom_hist_new_text))];
%dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
%subplot(2,2,i)
if  type == "Whole" || type == "ITK"
    colors = colors;
end 



figure(1)
set(gcf,'color','w');
set(gca,'FontSize',14)
histogram(dicom_hist_new_text,10,'Normalization','pdf','BinWidth',1, ...
'FaceColor', colors(i ,:) ,'FaceAlpha', FaceAlphaN , 'EdgeAlpha', 1 )
% legend_string = ["4.7% fat", "14.7% fat", "21.2% fat", "29.9% fat"];
legend_string = ["3.9% fat", "14.7% fat", "21.2% fat", "29.9% fat"];
legend(legend_string,'AutoUpdate','off')

% xline(0, '-')
% xline(6,'-')  
% xline(17,'-')
% xline(23,'-') 
txt = ["Low","Mild","Moderate","High"];

text([0+6/2-1,6+(17-6)/2-1,17,23+(35-23)/2-2],[.24,.24,.24,.24],txt, 'fontsize', 12)
xlim([0 45])
ylim([0 .25])
%title(join(["Sampled Fat Distrbution", "   ", txt(i),"Fat"]) )
title(join(["Sampled Fat Distrbution of the Whole Liver"]), 'fontweight','bold')
xlabel("Voxel Fat %",'fontweight','bold')
ylabel("Probability Density",'fontweight','bold')   

hold on

end

ax = gca;
ax.FontSize = 18;  % Font Size of 15
ax.FontWeight = 'bold'; 

% xline(0, '-', 'LineWidth', 1.5 )
xline(6,'-',  'LineWidth', 1 )  
xline(17,'-', 'LineWidth', 1 )
xline(23,'-', 'LineWidth', 1 )


% line([4.7 4.7],[0 .2], 'LineStyle',  '-.', 'Color', rgb('Snow') ,  'LineWidth', 3);
% line([14.7 14.7],[0 .22], 'LineStyle', '-.', 'Color',  rgb('Snow') ,  'LineWidth', 3);
% line([21.2 21.2],[0 .17], 'LineStyle', '-.', 'Color',  rgb('Snow')  , 'LineWidth', 3);
% line([29.9 29.9],[0 .12], 'LineStyle', '-.', 'Color',  rgb('Snow')  , 'LineWidth', 3);


% xline(3.9, '--', 'LineWidth', 2  , 'Color', 'g' )
% xline(12.7, '--',  'LineWidth', 2  , 'Color', 'g' )
% xline(21.2, '--',  'LineWidth', 2 , 'Color', 'g' )
% xline(29.9, '--',  'LineWidth', 2 , 'Color', 'g' )
% saveas(gcf,join(["Fat Histogram",'.png']) )

%%
clear 
tic 

type = "Whole";

if type == "COMSOL"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\MaterialParam'
file_name = "liver_001_915MHzPatientDataMaterialParams.csv";
file_name2 = "liver_002_915MHzPatientDataMaterialParams.csv";
file_name3 = "liver_003_915MHzPatientDataMaterialParams.csv";
file_name4 = "liver_004_915MHzPatientDataMaterialParams.csv";

elseif type == "Whole"
file_name = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\001_401 No series description_1 masked.nii.gz";
file_name2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\002_401 No series description masked.nii.gz";
file_name3 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\003_whole_image_segmentation.nii.gz";
file_name4 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\004_whole_image_segmented_mask.nii.gz";

end 
files = [file_name, file_name2, file_name3, file_name4];
Intensity_scale = [1,1,10,10];
%
set(gcf,'color','w');
set(gca,'FontSize',14)
mean_data = [];
sd_data = [];
pdfAll = [];

gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [ blue; orange; gold; purple];


if type == "COMSOL"
    for i = 1:4
    dicom_hist_new_text = table2array(readtable(files(i)));
    
    %thermal conductivity 
    %dicom_hist_new_text = log( (dicom_hist_new_text(:,6) -.21)./((.52-.21)) )./-0.0547;
   
    %Relative Permittivity    
    %dicom_hist_new_text = log( (dicom_hist_new_text(:,5) - 11.3 )./((46.8-11.3)) )./-0.01144;
    
    %electrical conductivity 
    dicom_hist_new_text = log( (dicom_hist_new_text(:,4) -.11)./((.861-.11)) )./-0.0117;
    
    %Functional Equations 
%         iNewKIso = ( (.52-.21)*exp(-0.0547*iVal) + .21 ) ;
%         iNewEr = ( (46.8-11.3)*exp(-0.01144*iVal) + 11.3 ) ;
%         iNewEc =  ( (.861-.11)*exp(-0.0116*iVal) + .11 ) ;
    dicom_hist_new_text(dicom_hist_new_text <= 0) = [];
    dicom_hist_new_text(dicom_hist_new_text >= 49) = [];
    [N,edges] = histcounts(dicom_hist_new_text,20);
    mean_data = [mean_data, mean(double(dicom_hist_new_text))];
    sd_data = [sd_data, std(double(dicom_hist_new_text))];
    %dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
    %capture the distribution of the fat data
    pdfX= 0:1:50;
    
    pd = fitdist( (dicom_hist_new_text),'tLocationScale');
    pdfY = pdf(pd, pdfX);
    pdfAll = [pdfAll, pdfY'];
    pDfplot = plot(pdfX, pdfY,'MarkerEdgeColor', colors(i,:));
    pDfplot.Annotation.LegendInformation.IconDisplayStyle = 'off'; % make the legend for step plot off
    %dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
    
    %
    hold on
    %subplot(2,2,i)
    %histogram(dicom_hist_new_text,10,'Normalization','pdf','BinWidth',1,'FaceColor',colors(i,:) )
    histogram(dicom_hist_new_text,10,'Normalization','pdf','BinWidth',1,'FaceColor', colors(i,:))
    end  
else 
    for i = 1:4
    [X] = niftiread(files(i));
    dicom_hist_new_text = [];
    dicom_hist_new = reshape(X, [],1);
    dicom_hist_new_text =[dicom_hist_new_text; dicom_hist_new]; 
    
    dicom_hist_new_text = double(dicom_hist_new_text);
    dicom_hist_new_text(dicom_hist_new_text <= 0) = [];
    dicom_hist_new_text = dicom_hist_new_text/(Intensity_scale(i)) ;
    [N,edges] = histcounts(dicom_hist_new_text,20);
    mean_data = [mean_data, mean(double(dicom_hist_new_text))];
    sd_data = [sd_data, std(double(dicom_hist_new_text))];
    
    %capture the distribution of the 
    pdfX= 0:1:50;
    pd = fitdist( (dicom_hist_new_text),'tLocationScale');
    pdfY = pdf(pd, pdfX);
    pdfAll = [pdfAll, pdfY'];
    pDfplot = plot(pdfX, pdfY,'MarkerEdgeColor', colors(i,:));
    pDfplot.Annotation.LegendInformation.IconDisplayStyle = 'off'; % make the legend for step plot off
    %dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
    %
    hold on
    %subplot(2,2,i)
    histogram(dicom_hist_new_text,10,'Normalization','pdf','BinWidth',1,'FaceColor',colors(i,:) )
    end 
end 
%%% Add standard deviation. Make Legend Larger 
legend_string = ["3.9% fat", "14.7% fat", "22.0% fat", "29.9% fat"];
legend(legend_string,'AutoUpdate','off')
% hold off
xlim([0 45])
ylim([0 .22])
title( join(["Sampled Fat Distrbution From COMSOL", newline,...
    "With Distribution functions"]) )
xlabel("Fat %")
ylabel("Probability Density")

%
% the following line skip the name of the previous plot from the legend
%h.Annotation.LegendInformation.IconDisplayStyle = 'off';
% xline(0, '-', {'Low'}, 'LabelOrientation', 'horizontal')
% xline(6,'-', {'Mild'},'LabelOrientation', 'horizontal')
% xline(17,'-', {'Moderate'},'LabelOrientation', 'horizontal')
% xline(23,'-', {'High'},'LabelOrientation',  'horizontal')

xline(0, '-') %{'Low'}, 'LabelOrientation', 'horizontal')
xline(6,'-')  %{'Mild'},'LabelOrientation', 'horizontal')
xline(17,'-') %{'Moderate'},'LabelOrientation', 'horizontal')
xline(23,'-') %{'High'},'LabelOrientation',  'horizontal')
txt = ["Low","Mild","Moderate","High"];

text([0+6/2-1,6+(17-6)/2-1,17,23+(35-23)/2-2],[.21,.21,.21,.21],txt)
saveas(gcf,join(["Fat Histogram",'.png']) )

toc

%%
clear

type = "PreSurgeryPlan";

if type == "PreSurgeryPlan"
    
    dirName = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt\';
    
    file_name = fullfile( dirName, "Liver_mased_Volume.nii.gz") ;
    file_name2 = fullfile( dirName, "Tumor Volume.nii.gz") ;
    file_name3 = fullfile( dirName, "Liver_mased_Volume.nii.gz") ;
    file_name4 = fullfile( dirName, "Liver_mased_Volume.nii.gz") ;
    specialNum = 1;

    %%%                 Liver
    fileslc = 1; 
    fatScale = [-10, 0, 8, 15];
    %%%                Tumor 
    

elseif type == "ADCMaps"
    
    dirName = 'D:\Slicer Models\1017_Vanderbilt\Perfusion Data';
    
file_name  = fullfile( dirName, "1017_ADC masked.nii.gz") ;
file_name2 = fullfile( dirName, "1017_ADC masked.nii.gz") ;
file_name3 = fullfile( dirName, "1017_ADC masked.nii.gz") ;
file_name4 = fullfile( dirName, "1017_ADC masked.nii.gz") ;
specialNum = 1;
FaceAlphaN = .45;
fileslc = 1; 
fatScale = [-2 , -1, 0, 1];


end 

SliceBySlice = "F";
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [ blue; orange; gold; purple];
colors2 = [rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];

files = [file_name, file_name2, file_name3, file_name4];
Intensity_scale = [1,1,10,10];
%
set(gcf,'color','w');
set(gca,'FontSize',14)
mean_data = [];
sd_data = [];



for i = 1:4
    
    
[X] = niftiread(files(fileslc));
dicom_hist_new_text = [];
dicom_hist_new = reshape(X, [],1);



    dicom_hist_new_text =[dicom_hist_new_text; dicom_hist_new]; 
    dicom_hist_new_text(dicom_hist_new_text <= 0) = [];
    dicom_hist_new_text = dicom_hist_new_text/(Intensity_scale(1)) ;
   
    [N,edges] = histcounts(dicom_hist_new_text,20);
    mean_data = [mean_data, mean(double(dicom_hist_new_text))];
    sd_data = [sd_data, std(double(dicom_hist_new_text))];
    %dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
    %subplot(2,2,i)

    colors = colors2;
    
    figure(1)
    set(gcf,'color','w');
    set(gca,'FontSize',14)


if type == "PreSurgeryPlan"
    %scale the fat paterns by a specific value
    dicom_hist_new_text = dicom_hist_new_text+ fatScale(i); 
    
    histogram(dicom_hist_new_text,10,'Normalization','pdf','BinWidth',1, ...
    'FaceColor', colors(i ,:) ,'FaceAlpha', .5 , 'EdgeAlpha', 1 )  
    legend_string = ["3.7% fat", "14.7% fat", "21.2% fat", "29.9% fat"];
    legend(legend_string,'AutoUpdate','off') 
    
    if i == 4
        
        xline(0, '-')
        xline(6,'-')  
        xline(17,'-')
        xline(23,'-') 
        txt = ["Low","Mild","Moderate","High"];
        text([0+6/2-1,6+(17-6)/2-1,17,23+(35-23)/2-2],[.21,.21,.21,.21],txt)
    end 
    
    xlim([0 45])
    ylim([0 .22])
    xlabel("Fat %")
    ylabel("Probability Density")       
    title(join([" Synthetic Fat Distrbution of Liver Fat ",...
        newline, "Using Patient Fat Distribution Pattern"]) )
    
elseif type == "ADCMaps"
    
    dicom_hist_new_text = double(dicom_hist_new_text);
%     dicom_hist_new_text  = dicom_hist_new_text/1000;
%     %scale the fat paterns by a specific value
    dicom_hist_new_text(dicom_hist_new_text > 2500) = [];
    dicom_hist_new_text = dicom_hist_new_text+ fatScale(i)*-350; 
    dicom_hist_new_text(dicom_hist_new_text <= 0) = [];
    
    histogram( dicom_hist_new_text ,10,'Normalization','pdf','BinWidth',70, ...
    'FaceColor', colors(i ,:) ,'FaceAlpha', .5 , 'EdgeAlpha', 1 )      
    xline(1600, '-')
    xline(1200,'-')  
    xline(900,'-')
    xline(550,'-') 
    txt = ["Low","Mild","Moderate","High"];

    text([ 1700, 1300 , 910 , 650 ],[.2,.2,.2,.2].*1e-2, txt, "FontSize", 10)
    xlim([0 2500])
    ylim([0 2.5].*1e-3)    
%     xlabel("10-3 mm^{2}/s.")
    xlabel("10-6 mm^{2}/s")
    ylabel("Probability Density")   
    title(join([" Synthetic ADC Distrbution",...
        newline, "Using Mild Fat Patient Data"]) )   
end 




    hold on
    


end
saveas(gcf,join(["Fat Histogram",'.png']) )
