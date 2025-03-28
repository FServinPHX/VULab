clear
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%fileName = "COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\HalfDataCube\ProcessedData\ALLDiameterLeftA98HalfCube.csv";
fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\COMSOL Geometry Half Cube\Processed Data\LeftVolumeA98HalfCubeBoundary.csv";
volumeData = readtable(fileName);
MVM =  table2array(volumeData(2:end,:));
DiameterMatrix = MVM;
err = .035;

%fileName2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\HalfDataCube\ProcessedData\ALLDiameterA98HalfCube.csv";
fileName2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\COMSOL Geometry Half Cube\Processed Data\RightVolumeA98HalfCubeBoundary.csv";
volumeData2 = readtable(fileName2);
MVM2 =  table2array(volumeData2(2:end,:));
DiameterMatrix2 = MVM2;
err = .035;

%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold];
legend_base = [ "Low Fat (3.9%)", "Mild Fat (14.7%)","Moderate Fat (21.2%)", "High Fat (29.9%)"];
set(gcf,'color','w');
legend_string = [];

allIntercept = []; allSlope = [];
axisInt = 2;
figure(1)
for i = 4:-1:1
    time = ([0:.25:15]);%.*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        VolumeBaseline = DiameterMatrix( 6:end-4 ,axisInt);
        x = time( 7:end-4 ); 
        y = DiameterMatrix( 6:end-4 ,((i-1)*3 + axisInt) )./DiameterMatrix2( 6:end-4 ,((i-1)*3 + axisInt) ) ;%./VolumeBaseline;
%         x = time;
%         y = DiameterMatrix( 1:end ,( (i-1)*3 + axisInt))*10;
        p = plot( x, y,'DefaultLegendAutoUpdate','off'  )  ;
        p.Color = colors(i,:);
        hold on
        mdl = fitlm(x,y)
          f = @(intercept,slope,x) intercept + slope*x;
          hold on          
          intercept = table2array(mdl.Coefficients  (1,1)); 
          slope = table2array(mdl.Coefficients  (2,1)); 
 
%           p2 = plot(x, f(intercept, slope, x), '--','HandleVisibility','off');
%           p2.Color = colors(i,:);
          
          legend_string = [legend_string, join([legend_base(i) ])]; %,'  ',intercept,' +  ',slope,'*x' ])]; 
          allIntercept = [allIntercept, intercept];
          allSlope = [allSlope, slope]; 
   
end     
        set(gcf,'position',[80,80,800,600])          
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    legend(legend_string, 'Location', 'best')
    legend('AutoUpdate', 'off')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    %ylabel("Diameter Difference (mm)")
    ylabel("Radius Ratio (Left/Right)")
    xlabel("Time (min)")
    %ylim([.5 1.5])
%     title(join(["Linear Fit Ratio in Long-Axis Diameter (Fat%_m_o_d_e_l - Baseline_m_o_d_e_l)",...
%         newline ,"err >", num2str(err) ]))
    title("Fit Ratio in X-axis")
    set(gca,'FontSize',14) 
    ylim([.6 1.3])
    yline(1, 'LineWidth', 2)
%hold off
%
set(gcf,'color','w');
fatContent = [29.9, 21.2, 14.7, 3.9];
legend_string = [];
%

set(gcf,'color','w');
tumor = "TRUE" ;
choice_int = 1;
choice = ["TRUE","FALSE"];
linestyle = ["-","--"];
lineChoice = linestyle(choice_int);

%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold];


figure(2)
%legend_base = [  "Low Fat Difference", "Mild Fat Difference","Moderate Fat Difference", "High Fat Difference"];
legend_base = [ "Low Fat (3.9%)", "Mild Fat (14.7%)","Moderate Fat (21.2%)", "High Fat (29.9%)"];
set(gcf,'color','w');
legend_string = [];
allIntercept = [];
allSlope = [];
axisInt = 3;
for i = 4:-1:1
    time = ([0:.25:15]);%.*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        VolumeBaseline = DiameterMatrix( 6:end-4 , axisInt);
        
        x = time( 7:end-4 ); 
        y = DiameterMatrix( 6:end-4 ,((i-1)*3 + axisInt) )./DiameterMatrix2( 6:end-4 ,((i-1)*3 + axisInt) );%./VolumeBaseline;
        
%         x = time( 10:end-4 ); 
%         y = DiameterMatrix(  10:end-4,( (i-1)*3 + axisInt))*10;
        
        p = plot( x, y  )  ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        mdl = fitlm(x,y)
          f = @(intercept,slope,x) intercept + slope*x;
          hold on          
          intercept = table2array(mdl.Coefficients  (1,1)); 
          slope = table2array(mdl.Coefficients  (2,1)); 
 
%           p2 = plot(x, f(intercept, slope, x), '--','HandleVisibility','off');
%           p2.Color = colors(i,:);
          
%           legend_string = [legend_string, join([legend_base(i),'  ',intercept,' +  ',slope,'*x' ])];
        legend_string = [legend_string, join([legend_base(i) ])];
          
          allIntercept = [allIntercept, intercept];
          allSlope = [allSlope, slope]; 
   
end     
    set(gcf,'position',[880,80,800,600])          
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    legend(legend_string, 'Location', 'best')
    legend('AutoUpdate', 'off')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    %ylabel("Radius Ratio ")
    ylabel("Radius Ratio (Left/Right)")
    xlabel("Time (min)")
    ylim([.6 1.3])
%     title(join(["Linear Fit Ratio in Short-Axis Diameter",...
%         newline ,"err >", num2str(err) ]))
    title("Fit Ratio in Z-axis")
    set(gca,'FontSize',14)
    yline(1, 'LineWidth', 2)
%hold off


%%
%ImportRadii
time = ([.25:.25:15]);
figure(1)
shrinkNumber = 0:.1:1 ; 

colors = [ 0, 0, 0; 75,0,130; 0,0,225; 0, 128, 128;  0,130,200;...  
    0,255,0; 210, 245, 60;  255,255,0;  255,127,0;
    255,0,0 ]./255;


legendArr = [];
set(gcf,'color','w');
for i = 1:10
    strt = (i-1)*60+1;
    fin = (i-1)*60 + 60;
    
    p1 = plot( ImportRadii(strt:fin,1),ImportRadii(strt:fin,3)  )  ;
    p1.Color = colors(i,:)  ;
    legendArr = [legendArr, join(["s =",shrinkNumber(i)])   ]; 

    hold on
end 
    legend(legendArr, 'Location','best')
    title("Y-axis Radius Trajectory")
    ylabel("Radius (mm")
    xlabel("Time (min)") 

figure(2)
set(gcf,'color','w');
for i = 1:10
    strt = (i-1)*60+1;
    fin = (i-1)*60 + 60;
    
    p2 = plot( ImportRadii(strt:fin,1),ImportRadii(strt:fin,4)  )    ;
    p2.Color = colors(i,:)  ;
    legendArr = [legendArr, join(["s =",shrinkNumber(i)])   ]; 

    hold on
end 
    legend(legendArr, 'Location','best')
    title("X-axis Radius Trajectory")
    ylabel("Radius (mm")
    xlabel("Time (min)") 
    
    
figure(3)  
set(gcf,'color','w');
for i = 1:10
    strt = (i-1)*60+1;
    fin = (i-1)*60 + 60;
    
    p3 = plot( ImportRadii(strt:fin,1),ImportRadii(strt:fin,5)  )   ;
    p3.Color = colors(i,:)  ;
    legendArr = [legendArr, join(["s =",shrinkNumber(i)])   ]; 

    hold on
end 
    legend(legendArr, 'Location','best')
    title("Z-axis Radius Trajectory")
    ylabel("Radius (mm")
    xlabel("Time (min)") 
    
    %%
    
clear
halfcube = "T"
if strcmp(halfcube,"T") 
    
%cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\HalfDataCube\ProcessedData'
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\COMSOL Geometry Half Cube\Processed Data'
%fileName = "LeftVolumeA98HalfCube.csv";
fileName = "LeftVolumeA98HalfCubeBoundary.csv";
volumeData = readtable(fileName);
VolumeMatrix = table2array(volumeData(3:end, :) );

%fileName2 = "RightVolumeA98HalfCube.csv";
fileName2 = "RightVolumeA98HalfCubeBoundary.csv";
volumeData2 = readtable(fileName2);
VolumeMatrix2 =  table2array(volumeData2(3:end, :) );


cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'

else 
   %cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\HalfDataCube\ProcessedData'
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Heterogenous Data\Het - Cube Cloud- Paper 1\COMSOL Geometry Half Cube\Processed Data'
    %fileName = "LeftVolumeA98HalfCube.csv";
    fileName = "LeftVolumeA98HalfCubeBoundary.csv";
    volumeData = readtable(fileName);
    VolumeMatrix = table2array(volumeData(3:end, :) );

    %fileName2 = "RightVolumeA98HalfCube.csv";
    fileName2 = "RightVolumeA98HalfCubeBoundary.csv";
    volumeData2 = readtable(fileName2);
    VolumeMatrix2 =  table2array(volumeData2(3:end, :) );


    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021' 
    
    
end 
%%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold];
legend_base = [ "Low Fat (3.9%)", "Mild Fat (14.7%)","Moderate Fat (21.2%)", "High Fat (29.9%)"];
set(gcf,'color','w');
legend_string = [];

allIntercept = []; allSlope = [];
axisInt = 2;
figure(1)
for i = 4:-1:1
    time = ([0:.25:15]);%.*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        x = time( 1:end-2 ); 
        y = VolumeMatrix(:,i) - VolumeMatrix2(:,i) ;%./VolumeBaseline;
%         x = time;
%         y = DiameterMatrix( 1:end ,( (i-1)*3 + axisInt))*10;
        p = plot( x, y,'DefaultLegendAutoUpdate','off'  )  ;
        p.Color = colors(i,:);
        hold on
        mdl = fitlm(x,y)
          f = @(intercept,slope,x) intercept + slope*x;
          hold on          
          intercept = table2array(mdl.Coefficients  (1,1)); 
          slope = table2array(mdl.Coefficients  (2,1)); 
 
%           p2 = plot(x, f(intercept, slope, x), '--','HandleVisibility','off');
%           p2.Color = colors(i,:);
          
          legend_string = [legend_string, join([legend_base(i) ])]; %,'  ',intercept,' +  ',slope,'*x' ])]; 
          allIntercept = [allIntercept, intercept];
          allSlope = [allSlope, slope]; 
          
          pause(.25)
   
end     
         set(gcf,'position',[80,80,800,600])          
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    legend(legend_string, 'Location', 'best')
    legend('AutoUpdate', 'off')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    %ylabel("Diameter Difference (mm)")
  
    %ylh = ylabel( join( [ "Volume", newline," Difference", newline, " (cm^3)"] ));
    ylh = ylabel( join( [ "R", newline, "(cm^3) "] ));
    set(ylh,'rotation',0,'VerticalAlignment','bottom')
    ylh.Position(1) = ylh.Position(1)-.8;
    
    
    xlabel("Time (min)")
%     title(join(["Linear Fit Ratio in Long-Axis Diameter (Fat%_m_o_d_e_l - Baseline_m_o_d_e_l)",...
%         newline ,"err >", num2str(err) ]))
    set(gca,'FontSize',14) 
    yline(0, 'LineWidth', 2)
    ylim([-.3 .8])
    
    if strcmp(halfcube,"T") 
        
        title("Fat_V_o_L -  No-Fat_V_o_l  ")
        text(.2, -.2, "No Fat Dominant", 'FontSize',14)
        text(.2,  .2, "Fat Dominant", 'FontSize',14)
    else 
        title("Fat_V_o_L -  No-Fat_V_o_l  ")
        text(.2, -.2, "Left Dominant", 'FontSize',14)
        text(.2,  .2, "Right Dominant", 'FontSize',14)
    end 

  %%
set(gcf,'color','w');
left = "TRUE" ;
finalVolume=  [];
final_sd = [];
for choiceInt = 2:-1:1 % %

lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
%%% 
choice = ["TRUE","FALSE"];
linestyle = ["-","--"];
lineChoice = linestyle(choiceInt);
left = choice( choiceInt );
disp(left)

if left == "TRUE"
    meanVolumeMatrix = VolumeMatrix;

else
    meanVolumeMatrix = VolumeMatrix2;

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
legendBase = [ "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
set(gcf,'color','w');
legendString = [];
for i = width(meanVolumeMatrix):-1:1
    time = ([.5:.25:15]); %.*45.*60./1000;   
    selectColor = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        
        p = plot(time, (meanVolumeMatrix(:,i)) ) ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        legendString = [legendString, join([legendBase(i)])]; 

end 
        finalVolume = [finalVolume, meanVolumeMatrix(end,:)];
        %final_sd = [final_sd, stdev_vol_matrix(end,:)];
        
        xPoints = [20, 20, 35, 35] ./(45*60/1000) ;  
        yPoints = [0, meanVolumeMatrix(end,4) + 1,...
            meanVolumeMatrix(end, 4) + 1, 0];
        color = [.84, .8, .2];
        hold on;
        if choiceInt < 2
            a = fill(xPoints, yPoints, color);
            a.FaceAlpha = 0.1; 
        end 
        set(gcf,'position',[80,80,800,600])  
   
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    if left == "TRUE" ||   left == "JARROD_DESHAZER-TUMOR" 
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
    title( join(["Ablation Trajectory of Half Cube Model",newline,...
        "-Fat    --No Fat"]))
%         legend('AutoUpdate', 'off')
%         yline(9)
%         text(2,9.25,'9')
%         yline(10)
%         text(2,10.25,'10')       
%         yline(11)
%         text(2,11.25,'11')
%         xlim([0 40])
    %title("Ablation Trajectory in Homogenous vs Heterogenous")
    set(gca,'FontSize',14)
    plotFigureName = join([titleName,'.png' ]);
end
hold off

    