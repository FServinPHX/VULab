clear
fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersEllipse.csv";
volumeData = readtable(fileName);
MVM =  table2array(volumeData(2:end,:));
DiameterMatrix = MVM;
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
axisInt = 1;
figure(1)
for i = 4:-1:1
    time = ([0:.25:15]);%.*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        VolumeBaseline = DiameterMatrix( 6:end-4 ,axisInt);
        x = time( 6:end-4 ); 
        %y = (DiameterMatrix( 6:end-4 ,(i*3 + axisInt) ) -VolumeBaseline)*10;%./VolumeBaseline;
        y = (DiameterMatrix( 6:end-4 ,(i-1)*3 + axisInt) );
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
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    %ylabel("Diameter Difference (mm)")
    ylabel("Radius (mm)")
    xlabel("Time (min)")
%     title(join(["Difference in Long-Axis Diameter (Fat%_m_o_d_e_l - Baseline_m_o_d_e_l)",...
%         newline ,"err >", num2str(err) ]))
    title("Long-Axis Radius Trajectory")
    set(gca,'FontSize',14) 
hold off
%%
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

%%
figure(2)
legend_base = [  "Low Fat Difference", "Mild Fat Difference","Moderate Fat Difference", "High Fat Difference"];
set(gcf,'color','w');
legend_string = [];
allIntercept = [];
allSlope = [];
axisInt = 1;
for i = 3:-1:1
    time = ([0:.25:15]);%.*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        VolumeBaseline = DiameterMatrix( 6:end-4 , axisInt);
        
        x = time( 6:end-4 ); 
        y = (DiameterMatrix( 6:end-4 ,(i*3 + axisInt) ) -VolumeBaseline)*10;%./VolumeBaseline;
        
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
 
          p2 = plot(x, f(intercept, slope, x), '--','HandleVisibility','off');
          p2.Color = colors(i,:);
          
          legend_string = [legend_string, join([legend_base(i),'  ',intercept,' +  ',slope,'*x' ])];    
          
          allIntercept = [allIntercept, intercept];
          allSlope = [allSlope, slope]; 
   
end     
    set(gcf,'position',[880,80,800,600])          
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    legend(legend_string, 'Location', 'best')
    %ylim([0 (meanVolumeMatrix(end,4) - VolumeBaseline(end)) + 1])
    ylabel("Diameter Difference (mm)")
    xlabel("Time (min)")
    title(join(["Linear Fit The Difference in Short-Axis Diameter",...
        newline ,"err >", num2str(err) ]))
    set(gca,'FontSize',14)
hold off
