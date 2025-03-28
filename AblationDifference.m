%See https://tasks.illustrativemathematics.org/content-standards/tasks/569
clear
set(gcf,'color','w');
tumor = "TRUE" ;

choice_int = 1

lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
%%% 
choice = ["TRUE","FALSE"];
linestyle = ["-","--"];
lineChoice = linestyle(choice_int);
tumor = choice( choice_int );
disp(tumor)
%

if tumor == "TRUE"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No Tumor Volume'
else
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Tumor-Volume'
end 
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
meanVolumeMatrix = [mean(healthyLiverVolume,2), mean(lowFatVolume,2),...
        mean(mildFatVolume,2), mean(moderateFatVolume,2), mean(highFatVolume,2)];
stdev_vol_matrix = [std(healthyLiverVolume,0,2), std(lowFatVolume,0,2),...
        std(mildFatVolume,0,2), std(moderateFatVolume,0,2), std(highFatVolume,0,2)];
 %
%If you want touse a file to create a 

% fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allVolumeTempThreshold100.csv";
% %fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allVolumeEllipse.csv";
% volumeData = readtable(fileName);
% MVM =  table2array(volumeData(3:end,1:5));
% 
% meanVolumeMatrix = MVM;
%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold];

legend_base = ["Low Fat Difference", "Mild Fat Difference","Moderate Fat Difference", "High Fat Difference"];
set(gcf,'color','w');
legend_string = [];

allVals = [];
Percent_Difference_export = []; 
for i =      1: width(meanVolumeMatrix)-1     %width(meanVolumeMatrix)-1:-1:1
    time = ([0:.25:15]).*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        VolumeBaseline = meanVolumeMatrix(1:end,1);
        x = time; 
        %y = (meanVolumeMatrix(2:end,i+1)-VolumeBaseline );
        y = (meanVolumeMatrix(1:end,i+1)-VolumeBaseline )*10;%/VolumeBaseline;
        y = y( (length(y) - length(x)+1) :end);
        p = plot( x, y )  ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        legend_string = [legend_string, join([legend_base(i)])]; 
          
%         x = time; y = (meanVolumeMatrix(2:end,i));
%         %f = @(a,b,x) a*exp(b*x);
%         %f = @(L,k,x0,x) L./(1+ exp((-k)*(x-x0)) )
%         %f = @(L,R,k,x) L - R*exp(-k*x)
%         obj_fun = @(params) norm(f(params(1), params(2), params(3), x)-y);
%         sol = fminsearch(obj_fun, [17,10,.05])
%         a_sol = sol(1);
%         b_sol = sol(2);
%         c_sol = sol(3);

%         xdata = time; ydata = (Mean_Volume_Matrix(2:end,i))';
%         fun = @(x,xdata)x(1)*exp(x(2)*xdata);
%         x0 = [100,-1];
%         x1 = lsqcurvefit(fun,x0,xdata,ydata);
%         hold on
%         p2 = plot(x, f(a_sol, b_sol,c_sol, x), '--');
%         p2.Color = colors(i,:);
%         leg = legend(p2);
%         %plot(x, fun(x, time),'-')
%         set(leg,'AutoUpdate','off');
%         
%         allVals = [allVals; a_sol, b_sol, c_sol];

export_diff = (meanVolumeMatrix(1:end,i+1)-VolumeBaseline )./ VolumeBaseline; 
Percent_Difference_export = [ Percent_Difference_export,   [i; export_diff]];
end 
        x_points = [20, 20, 35, 35];  
        y_points = [0, y(end) + 1, y(end) + 1, 0];
        color = gold; %[.84, .8, .2];
        hold on;
        %a = fill(x_points, y_points, color);
        %a.FaceAlpha = 0.1;       
        set(gcf,'position',[80,80,800,600])     
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
    if tumor == "TRUE" ||   tumor == "JARROD_DESHAZER-TUMOR" 
        title_name = ["ALL Patients Necrotic_Volume_915_A_995_Tumor"];
        %title("Necrotic Volume (cm^3) vs Dose (J) Models with 20 mm Diameter Tumor")
    else 
        title_name = ["ALL Patients Necrotic_Volume_915_A_995_No_Tumor"];
        %title("Necrotic Volume (cm^3) vs Dose (J) Models without Tumor")
    end 
    legend(legend_string, 'Location', 'best')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    ylabel("Volume Difference mm^3")
    xlabel("Thermal Dose (kJ)")
    title("Ablation Trajectory Difference Based on Fat Percent")
    set(gca,'FontSize',14)
    plot_figure_name = join([title_name,'.png' ]);
    
hold off
%plot_figure_name = 'CombinedAblationVolumePlotTemperatureEstimation.png';
%saveas(gcf,plot_figure_name)
%%

%%%%                                                    LONG-AXIS DIAMETER
clear
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
set(gcf,'color','w');
tumor = "TRUE" ;
choice_int = 1;
choice = ["TRUE","FALSE"];
linestyle = ["-","--"];
lineChoice = linestyle(choice_int);
tumor = choice( choice_int );
disp(tumor)



%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersTempThreshold100.csv";
fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersEllipsewithBAseline.csv";
DiameterData = readtable(fileName);
MVM =  table2array(DiameterData(: ,:));
DiameterMatrix = MVM;
% %
% fileName2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersEllipse.csv";
% DiameterData2 = readtable(fileName2);
% MVM2 =  table2array(DiameterData2(2:end,:));
% DiameterMatrix2 = MVM2;
% %
%

allIntercept = []; allSlope = [];
%axisInt1 = [2, 1, 3];
axisInt = 1;
%axisInt2 = [1, 2, 3];
axisInt2 = 1;
figure(1)
%
StartData = 10; 
endData = 10;
for i = 4:-1:1
    %ezclude data from model 3 (Further Investigate)
%     if i == 3
%         i = 4;
%     end 
    
    
    time = ([0:.25:15]);%.*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        
        %What are You Subtracting: The Baseline Diameter or another
        %Diameter Entirely
        DiameterBaseline = DiameterMatrix( StartData:end-endData ,axisInt);
        %DiameterBaseline = DiameterMatrix2( 6:end-4 , ((i-1)*3 + axisInt2) );
        
        x = time( StartData:end-endData); 
        %y = (meanVolumeMatrix(2:end,i+1)-VolumeBaseline );
        y = (DiameterMatrix( StartData:end-endData, ((i)*3 + axisInt) )- DiameterBaseline );%./VolumeBaseline;
        p = plot( x, y,'DefaultLegendAutoUpdate','off'  )  ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        mdl = fitlm(x,y)
          f = @(intercept,slope,x) intercept + slope*x;
          hold on          
          intercept = table2array(mdl.Coefficients  (1,1)); 
          slope = table2array(mdl.Coefficients  (2,1)); 
 
          p2 = plot(x, f(intercept, slope, x), '--','HandleVisibility','off');
          p2.Color = colors(i,:);
          
          legend_string = [legend_string, join([legend_base(i) ])]; %,'  ',intercept,' +  ',slope,'*x' ])]; 
          allIntercept = [allIntercept, intercept];
          allSlope = [allSlope, slope]; 
   
end     
        set(gcf,'position',[80,80,800,600])          
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
    legend(legend_string, 'Location', 'best')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    ylabel("Diameter Difference (mm)")
    xlabel("Time (min)")
    title("Difference in Long-Axis Diameter (Fat%_m_o_d_e_l - Baseline_m_o_d_e_l)")
    set(gca,'FontSize',14) 
hold off
%
set(gcf,'color','w');
fatContent = [29.9, 21.2, 14.7, 3.9];
legend_string = [];


figure(2)
xFat = 1:.5:30;
set(gcf,'color','w');
subplot(2,1,1)
plot(fatContent, allIntercept, '-b')
mdl = fitlm(fatContent,allIntercept)
f = @(intercept,slope,x) intercept + slope*x;
hold on          
intercept = table2array(mdl.Coefficients  (1,1)); 
slope = table2array(mdl.Coefficients  (2,1)); 
p2 = plot(xFat, f(intercept, slope, xFat), '--','HandleVisibility','off');
p2.Color = colors(i,:);

legend(join(["Intercept",intercept,' +  ',slope,'*x' ]),'Location', 'best')
ylabel("Intercept Value")
xlabel("fat content Value")
title("Estimate the intercept")

LongAxisModel.InterceptEq = [intercept, slope];

subplot(2,1,2)
plot(fatContent, allSlope, '-b')
mdl = fitlm(fatContent,allSlope)
f = @(intercept,slope,x) intercept + slope*x;
hold on          
intercept = table2array(mdl.Coefficients  (1,1)); 
slope = table2array(mdl.Coefficients  (2,1)); 
p2 = plot(xFat, f(intercept, slope, xFat), '--','HandleVisibility','off');
p2.Color = colors(i,:);

legend( join(["Slope" ,intercept,' +  ',slope,'*x' ]), 'Location', 'best' )
ylabel("Slope Value")
xlabel("Fat Content Value")
title("Estimate the Slope")

LongAxisModel.SlopeEq = [intercept, slope];

sgtitle("Modeling the Trajectory Coefficients")
%%
%%%EXAMPLE
figure(1)
example.FatContentSamples = [29.9, 21.2, 14.7, 3.9] %[31, 26, 18, 9]% [29.9, 21.2, 14.7, 3.9]  ;
example.NewFatData= [];

for i = length(example.FatContentSamples):-1:1
    
example.FatContent = example.FatContentSamples(i);
example.findIntercept = LongAxisModel.InterceptEq(1) + ...
    example.FatContent*LongAxisModel.InterceptEq(2);
example.findSlope = LongAxisModel.SlopeEq(1) + ...
    example.FatContent*LongAxisModel.SlopeEq(2);
hold on
f = @(intercept,slope,x) intercept + slope*x;
p2 = plot(x, f(example.findIntercept, example.findSlope, x), '-','HandleVisibility','off');
p2.Color = red;
textVal = join([ string(example.FatContent), '% Fat' ]);
text(38.5,f(example.findIntercept, example.findSlope, 40), textVal,'FontSize',14)

example.addedData = [example.FatContent; ...
    ( f(example.findIntercept, example.findSlope, x)' + DiameterBaseline )];
example.NewFatData = [example.NewFatData, example.addedData ];

end 
%%
legend_string = [];
figure(3)
set(gcf,'color','w');
for i = 4:-1:1
    time = ([0:.25:15])%.*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        VolumeBaseline = DiameterMatrix( 6:end-4 ,axisInt);
        x = time( StartData:end-endData ); 
        %y = (meanVolumeMatrix(2:end,i+1)-VolumeBaseline );
        y = (DiameterMatrix( StartData:end-endData ,(i*3 + axisInt) ) )*10;%./VolumeBaseline;
        p1 = plot( x, y,'DefaultLegendAutoUpdate','off'  )  ;
        p1.Color = colors(i,:);
        legend_string = [legend_string, join([legend_base(i) ])];
        hold on
end         

for i = width(example.NewFatData ):-1:1
    y = example.NewFatData(2:end, i)*10;
    p2 = plot(x, y, '--')
    %p2.Color = colors(i,:);
    %legend_string = [legend_string, join([legend_base(i) ])];
    textVal = join([ string( example.NewFatData(1, i) ), '% Fat Intpl' ]);
    text(38.5,example.NewFatData(end, i) , textVal,'FontSize',14)
    legend_string = [legend_string, textVal ];
end 
hold off    

    set(gcf,'position',[80,80,800,600])          
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
    legend(legend_string, 'Location', 'best')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    ylabel("Diameter (mm)")
    xlabel("Time (min)")
    title("Long-Axis Diameter Trajectory")
    set(gca,'FontSize',14) 
%%
clear
set(gcf,'color','w');
tumor = "TRUE" ;
choice_int = 1;
choice = ["TRUE","FALSE"];
linestyle = ["-","--"];
lineChoice = linestyle(choice_int);
tumor = choice( choice_int );
disp(tumor)
%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold];
%

%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersTempThreshold100.csv";
fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersEllipsewithBAseline.csv";
DiameterData = readtable(fileName);
MVM =  table2array(DiameterData(: ,:));
DiameterMatrix = MVM;
%


fileName2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersEllipse.csv";
DiameterData2 = readtable(fileName2);
MVM2 =  table2array(DiameterData2(2:end,:));
DiameterMatrix2 = MVM2;



legend_base = [  "Low Fat Difference", "Mild Fat Difference","Moderate Fat Difference", "High Fat Difference"];
set(gcf,'color','w');
legend_string = [];
allIntercept = [];
allSlope = [];

%axisInt = 3;
%axisInt1 = [2, 1, 3];
axisInt = 2;
%axisInt2 = [1, 2, 3];
axisInt2 = 1;

figure(1)
for i = 4:-1:1
    time = ([0:.25:15]).*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        DiameterBaseline = DiameterMatrix( 6:end-4 , axisInt);
        %DiameterBaseline = DiameterMatrix2( 6:end-4 , ((i-1)*3 + axisInt2) );
        
        
        x = time( 6:end-4 ); 
        %y = (meanVolumeMatrix(2:end,i+1)-VolumeBaseline );
        y = (DiameterMatrix( 6:end-4 ,((i)*3 + axisInt) )- DiameterBaseline );%./VolumeBaseline;
        p = plot( x, y  )  ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        mdl = fitlm(x,y)
          f = @(intercept,slope,x) intercept + slope*x;
          hold on          
          intercept = table2array(mdl.Coefficients  (1,1)); 
          slope = table2array(mdl.Coefficients  (2,1)); 
 
          p2 = plot(x, f(intercept, slope, x), '--','HandleVisibility','off');
          p2.Color = colors(i,:);
          
          legend_string = [legend_string, join([legend_base(i),'  ',intercept,' +  ',slope,'*x' ])];    
          
          allIntercept = [allIntercept, intercept];
          allSlope = [allSlope, slope]; 
   
end     
        set(gcf,'position',[80,80,800,600])          
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
    legend(legend_string, 'Location', 'best')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    ylabel("Diameter Difference (mm)")
    xlabel("Thermal Dose (J)")
    title("Linear Fit The Difference in Short-Axis Diameter")
    set(gca,'FontSize',14)
hold off


set(gcf,'color','w');
fatContent = [29.9, 21.2, 14.7, 3.9];
legend_string = [];
figure(2)

subplot(2,1,1)
plot(fatContent, allIntercept, '-b')
mdl = fitlm(fatContent,allIntercept)
f = @(intercept,slope,x) intercept + slope*x;
hold on          
intercept = table2array(mdl.Coefficients  (1,1)); 
slope = table2array(mdl.Coefficients  (2,1)); 
p2 = plot(x, f(intercept, slope, x), '--','HandleVisibility','off');
p2.Color = colors(i,:);

legend(join(["Intercept",intercept,' +  ',slope,'*x' ]),'Location', 'best')
ylabel("Intercept Value")
xlabel("fat content Value")
title("Estimate the intercept")

ShortAxisModel.InterceptEq = [intercept, slope];

subplot(2,1,2)
plot(fatContent, allSlope, '-b')
mdl = fitlm(fatContent,allSlope)
f = @(intercept,slope,x) intercept + slope*x;
hold on          
intercept = table2array(mdl.Coefficients  (1,1)); 
slope = table2array(mdl.Coefficients  (2,1)); 
p2 = plot(x, f(intercept, slope, x), '--','HandleVisibility','off');
p2.Color = colors(i,:);

legend( join(["Slope" ,intercept,' +  ',slope,'*x' ]), 'Location', 'best' )
ylabel("Slope Value")
xlabel("Fat Content Value")
title("Estimate the Slope")

ShortAxisModel.SlopeEq = [intercept, slope];
%%
sgtitle("Modeling the Trajectory Coefficients")

%%%EXAMPLE
figure(1)
example.FatContentSamples = [6, 19, 25];
example.NewFatData= [];

for i = length(example.FatContentSamples):-1:1
    
example.FatContent = example.FatContentSamples(i);
example.findIntercept = ShortAxisModel.InterceptEq(1) + ...
    example.FatContent*ShortAxisModel.InterceptEq(2);
example.findSlope = ShortAxisModel.SlopeEq(1) + ...
    example.FatContent*ShortAxisModel.SlopeEq(2);
hold on
f = @(intercept,slope,x) intercept + slope*x;
p2 = plot(x, f(example.findIntercept, example.findSlope, x), '-','HandleVisibility','off');
p2.Color = red;
textVal = join([ string(example.FatContent), '% Fat' ]);
text(38.5,f(example.findIntercept, example.findSlope, 40), textVal,'FontSize',14)

example.addedData = [example.FatContent; ...
    ( f(example.findIntercept, example.findSlope, x)'/10 + DiameterBaseline )];
example.NewFatData = [example.NewFatData, example.addedData ];

end 
%%
legend_string = [];
figure(3)
for i = 4:-1:1
    time = ([0:.25:15]).*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        
        %%Add Standard Deviation
        VolumeBaseline = DiameterMatrix( 6:end-4 ,axisInt);
        x = time( 6:end-5 ); 
        %y = (meanVolumeMatrix(2:end,i+1)-VolumeBaseline );
        y = (DiameterMatrix( 6:end-4 ,(i*2 + axisInt) ) )*10;%./VolumeBaseline;
        p = plot( x, y,'DefaultLegendAutoUpdate','off'  )  ;
        legend_string = [legend_string, join([legend_base(i) ])];
        hold on
end         

for i = 1:width(example.NewFatData )
    y = example.NewFatData(2:end, i)*10;
    plot(x, y, '--')
    %legend_string = [legend_string, join([legend_base(i) ])];
    textVal = join([ string( example.NewFatData(1, i) ), '% Fat' ]);
    text(38.5,example.NewFatData(end, i) , textVal,'FontSize',14)
    legend_string = [legend_string, textVal ];
end 
hold off    
    set(gcf,'position',[80,80,800,600])          
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
    legend(legend_string, 'Location', 'best')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    ylabel("Diameter (mm)")
    xlabel("Thermal Dose (J)")
    title("Long-Axis Diameter Trajectory")
    set(gca,'FontSize',14) 
    
    
    
 %%
 %Now that we have our functions, it is time to make an
 %Interactible application
 
%%%%%Portion of this code finds the short-axis and the long axis to plot 
AblationApp.FatContent = example.FatContentSamples(i);

AblationApp.NewFatData= []; 

for i = length(example.FatContentSamples):-1:1

    AblationApp.findInterceptShortAxis = ShortAxisModel.InterceptEq(1) + ...
    example.FatContent*ShortAxisModel.InterceptEq(2);

    AblationApp.findSlopeShortAxis = ShortAxisModel.SlopeEq(1) + ...
    example.FatContent*ShortAxisModel.SlopeEq(2);

    AblationApp.FatContent = example.FatContentSamples(i);

    AblationApp.findInterceptLongAxis = LongAxisModel.InterceptEq(1) + ...
    example.FatContent*LongAxisModel.InterceptEq(2);

    AblationApp.findSlopeLongAxis = LongAxisModel.SlopeEq(1) + ...
    example.FatContent*LongAxisModel.SlopeEq(2);
    %%%FInd the New Fat Data


    example.FatContent = example.FatContentSamples(i);
    %The data is time 
    time = ([0:.25:15]).*45.*60./1000;   
    x = time( 6:end-4 ); 
    %%%
    %adding the data essentially is the difference + original baseline data
    %the equation is     y  = intercept(fat%) + slope(fat%)*fat% + baseline
    %data.
    AblationApp.LongAxisData = [example.FatContent; ...
    ( f(example.findInterceptLongAxis, example.findSlopeLongAxis, x)'/10 ...
        +  DiameterMatrix( 6:end-4 , (i*3 + 2)  ) )];

    AblationApp.ShortAxisData = [example.FatContent; ...
    ( f(example.findInterceptShortAxis, example.findSlopeShortAxis, x)'/10 ...
        +  DiameterMatrix( 6:end-4 , (i*3 + 2)  ) )];

    AblationApp.NewFatData = [AblationApp.NewFatData, AblationApp.addedData ];
end 

%%
set(gcf,'color','w');
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];

set(gca,'FontSize',14) % Creates an axes and sets its FontSize to 18
set(0,'DefaultLegendAutoUpdate','off');
hold on 
%legend_string = ["Ablation Plot (Necrosis)"];
legend_string = [];
baseline_string =  [];
for i  = 1:2
   
    a = 2;
    b = 1; 
    if i == 1
        baseline_string = ["No Fat"];
        color = 'g';
        legend_string = [legend_string, baseline_string];
    elseif i == 5
        baseline_string = ["High Fat"];
        color = [.84, .8, .2];    
        legend_string = [legend_string, baseline_string];
    else 
        disp('no plot')
    end 
    t = linspace(0,2*pi,40) ;

    x=cos(t)*a*.99; % width
    y=sin(t).*(b + x/6); %.*(b-x/7)+ 140 ; % height
    x = x +159;
    y = y + 140;

    x=cos(t)*a*1.02; % width
    y=sin(t).*(b*1.02 + x/6); %.*(b-x/7)+ 140 ; % height
    x = x +157.5;
    y = y + 140;

    
    if i == 1 
    p1 = plot(x,y,'k--', 'LineWidth', 2);
    elseif i == 5 
    p2 = plot(x,y, 'LineWidth', 2);
    p2.Color = purple;
    p2.LineStyle = '--';
    p2.Marker = 'o';
    p2.MarkerSize = 4;
    else 

    end 
    hold on 
    axis equal
    title_name = ["Visualizing Ablation Area (mm) without Tumor"];

end
% select which plots to plot
legend(legend_string)
title(title_name)
colorbar
colormap jet
xlabel("Long Axis (mm)")
ylabel("Short Axis (mm)")
set(gcf,'position',[80,80,800,800])  
hold off
saveas(gcf,join([title_name,'.png']) )