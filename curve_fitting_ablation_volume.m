%%

%See https://tasks.illustrativemathematics.org/content-standards/tasks/569
set(gcf,'color','w');
tumor = "TRUE" ;

for choice_int = 1:2

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

% if tumor == "TRUE"
%     cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No-Tumor-Volume'
% else
%     cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Tumor-Volume'
% end 
% names = dir('*.csv');
% for allFilenames = 1:length(names)
%     currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
%     volumeData = readtable(currentFileName);
%     volumeDataMod = volumeData{:,:};
%     
%     healthyLiverVolume = [healthyLiverVolume, volumeDataMod(:,5)  ];
%     lowFatVolume = [lowFatVolume, volumeDataMod(:,2) ];
%     mildFatVolume = [mildFatVolume, volumeDataMod(:,3) ];
%     moderateFatVolume = [moderateFatVolume, volumeDataMod(:,4) ];
%     highFatVolume = [highFatVolume, volumeDataMod(:,1) ];
%     
% end 
% %Find the mean and stadard deviation of all of the runs
% meanVolumeMatrix = [mean(healthyLiverVolume,2), mean(lowFatVolume,2),...
%         mean(mildFatVolume,2), mean(moderateFatVolume,2), mean(highFatVolume,2)];
% stdev_vol_matrix = [std(healthyLiverVolume,0,2), std(lowFatVolume,0,2),...
%         std(mildFatVolume,0,2), std(moderateFatVolume,0,2), std(highFatVolume,0,2)];
    
fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allVolumeA98Baseline.csv";
volumeData = readtable(fileName);
MVM =  table2array(volumeData(2:end,1:4));

meanVolumeMatrix = MVM;
%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold];

legend_base = ["Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
set(gcf,'color','w');
legend_string = [];

allVals = [];
for i = width(meanVolumeMatrix):-1:1
    time = ([0:.25:15]).*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        p = plot(time, (meanVolumeMatrix(2:end,i)))  ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        legend_string = [legend_string, join([legend_base(i)])]; 
        
        
        x = time; y = (meanVolumeMatrix(2:end,i));
        %f = @(a,b,x) a*exp(b*x);
        %f = @(L,k,x0,x) L./(1+ exp((-k)*(x-x0)) )
        f = @(L,R,k,x) L - R*exp(-k*x)
        obj_fun = @(params) norm(f(params(1), params(2), params(3), x)-y);
        sol = fminsearch(obj_fun, [17,10,.05])
        a_sol = sol(1);
        b_sol = sol(2);
        c_sol = sol(3);
%         xdata = time; ydata = (Mean_Volume_Matrix(2:end,i))';
%         fun = @(x,xdata)x(1)*exp(x(2)*xdata);
%         x0 = [100,-1];
%         x1 = lsqcurvefit(fun,x0,xdata,ydata);
%         hold on
        p2 = plot(x, f(a_sol, b_sol,c_sol, x), '--');
        p2.Color = colors(i,:);
        leg = legend(p2);
        %plot(x, fun(x, time),'-')
        set(leg,'AutoUpdate','off');
        
        allVals = [allVals; a_sol, b_sol, c_sol];
end 
        x_points = [20, 20, 35, 35];  
        y_points = [0, meanVolumeMatrix(end,4) + 1,...
            meanVolumeMatrix(end, 4) + 1, 0];
        color = gold; %[.84, .8, .2];
        hold on;
        a = fill(x_points, y_points, color);
        a.FaceAlpha = 0.1;       
        set(gcf,'position',[80,80,800,600])     
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    if tumor == "TRUE" ||   tumor == "JARROD_DESHAZER-TUMOR" 
        title_name = ["ALL Patients Necrotic_Volume_915_A_995_Tumor"];
        %title("Necrotic Volume (cm^3) vs Dose (J) Models with 20 mm Diameter Tumor")
    else 
        title_name = ["ALL Patients Necrotic_Volume_915_A_995_No_Tumor"];
        %title("Necrotic Volume (cm^3) vs Dose (J) Models without Tumor")
    end 
    legend(legend_string, 'Location', 'best')
    ylim([0 meanVolumeMatrix(end,4) + 1])
    ylabel("Volume cm^3")
    xlabel("Thermal Dose (J)")
    title("Curve Fit Ablation Trajectory in All Models")
    set(gca,'FontSize',14)
    plot_figure_name = join([title_name,'.png' ]);
end
hold off
plot_figure_name = 'CombinedAblationVolumePlotTemperatureEstimation.png';
saveas(gcf,plot_figure_name)
%%
Sigma = [0.518853194, 0.517548778, 0.50983313, 0.523714518, 0.512471455,...
    0.506623854, 0.490603367, 0.504081296, 0.510244991, 0.505759594, ...
    0.457959634, 0.511293319, 0.496593833, 0.491479552, 0.487533985];
 X = [ 2.64, 3.59, 6.15, 2.71, 5.57, 6.37, 13.26, 3.15, 5.71, 6.37,...
     12.31, 2.64, 8.72, 9.16, 11.58];
 K = [ 0.659352373, 0.636003483, 0.587299622, 0.656681254,...
     0.598125851, 0.588939748, 0.50527746, 0.631607658, 0.603890399,...
     0.594960763, 0.480452978, 0.660988093, 0.535765427, 0.533746263, 0.489459631 ];
%% 
clear
Sigma = [ .831, .749, .70, .634 ];
X = [3.9, 14.70, 21.20, 29.910 ] ;
xtumor = [ 4.6,  11.90,  22.2, 32.6 ];
K = [.461, .349, .307, .271 ] ;


figure(1) 
set(gcf,'color','w');
for i  = 1:2 
    
    subplot(2,1,i)
    x = X;
    %f = @(a,b,x) a*exp(b*x);
    if i == 1     
        y = K;
        f = @(tk,x) (.521 - .21)*exp(tk * x) + .21;
    end 
    if i == 2
        f = @(tk,x) (.861 - .11)*exp(tk * x) + .11;
        y = Sigma;
    end 
    scatter(x,y,'b')   
    
    obj_fun = @(params) norm(f(params(1), x)-y);
    sol = fminsearch(obj_fun, [-.0546]); 
    a_sol = sol(1);
 
    
    if i ==1 
        legnd.f1 = join(['y = (.521-.21)*e(', num2str(a_sol),'*x) + .21' ]);
        title('Electrical Conductivity Estimation')
    end
    if i == 2
        legnd.f1 = join(['y = (.861 - .11)*e(', num2str(a_sol),')*x + .11' ]);
        title(' Thermal Conductivity Estimation')
    end
    

    hold on
    x_lim = linspace(0, 35, 100);
    plot(x_lim, f(a_sol,x_lim), 'r')
    
    scatter(xtumor,  f(a_sol,xtumor),  'g', 'filled')
    
    legnd.legend_array = join(["Original Points",legnd.f1 ]);
    legend(legnd.legend_array)
    xlim([0 35])
    %plot(x, fun(x, time),'-')
    set(0,'DefaultLegendAutoUpdate','off');
    set(gca, 'FontSize',14)

end 
set(gcf,'position',[80,80,800,600]) 
hold off

Perf = [ .01722, .01506, .01376, .01202 ];
X = [3.9, 14.70, 21.20, 29.910 ] ;
Er = [45.4, 41.6, 39.3, 36.2 ] ;
figure(2)
set(gcf,'color','w');

for i  = 1:2 
    x = X;
    subplot(2,1,i)
    %f = @(a,b,x) a*exp(b*x);
    if i == 1 
        f = @(tk,x) (.0185 - .010)*exp(tk * x) + .010;
        y = Perf;
    end 
    if i == 2
        f = @(tk,x) (46.8 - 11.3)*exp(tk * x) + 11.3;
        y = Er;
    end 
    scatter(x,y,'b')
    
    obj_fun = @(params) norm(f(params(1), x)-y);
    sol = fminsearch(obj_fun, [-.0546]); 
    a_sol = sol(1);
    
    if i ==1 
        legnd.f1 = join(['y = (.0185 - .010)*e(', num2str(a_sol),'*x) + .010' ]);
        title('Perfusion Estimation')
    end
    if i == 2
        legnd.f1 = join(['y = (46.8 - 11.3)*e(', num2str(a_sol),'*x) + 11.3' ]);
        title('Relative Permittivity')
    end 
    
    hold on
    x_lim = linspace(0, 35, 100);
    plot(x_lim, f(a_sol,x_lim), 'r')
    
    scatter(xtumor,  f(a_sol,xtumor), 'g', 'filled')
    
    legnd.legend_array = join(["Original Points",legnd.f1 ]);
    legend(legnd.legend_array)
    xlim([0 35])
    %plot(x, fun(x, time),'-')
    set(0,'DefaultLegendAutoUpdate','off');
    set(gca, 'FontSize',14)
end
set(gcf,'position',[880,80,800,600])
hold off


%%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold];
%Thermal Conductivity Estimation: (liver% - fat%)*e^(-.048372*x)+ %fat
%electrical Conductivity Est.: (liver% - fat%)*e(-.068591*x) + %fat [S/m]
    %liver = 1.69    fat = .268
%permittivity Cond = (liver% - fat%)*e(-.068591*x) + %fat
    %liver = 43    fat = 10.8    
 X = [3.9 14.70 21.20 29.90 ];
K = [ 0.659352373, 0.636003483, 0.587299622, 0.656681254,...
 0.598125851, 0.588939748, 0.50527746, 0.631607658, 0.603890399,...
 0.594960763, 0.480452978, 0.660988093, 0.535765427, 0.533746263, 0.489459631 ];
figure() 
set(gcf,'color', 'w')
for i  = 1:3
    
    x = X; y = K;
    subplot(3,1,i)
    
    %f = @(a,b,x) a*exp(b*x);
    if i == 1 
    f = @(tk,x) (.521 - .21)*exp(tk * x) + .21;
    title(' Thermal Conductivity Estimation')
    tkSol = -.048372;
    end 
    
    if i == 2
    f = @(tk,x) (1.69 - .268)*exp(tk * x) + .268;
    title('Electrical Conductivity Estimation')
    tkSol = -.068591;
    end 
    
    if i == 3
    f = @(tk,x) (43 - 10.8)*exp(tk * x) + 10.8;
    title('Permittivity Estimation')
    tkSol = -.068591;
    end 
  
    x_lim = linspace(0, 35, 40);
    p = plot(x_lim, f(tkSol,x_lim));
    p.Color = green;
    hold on 
    scatter(X,f(tkSol,X),'b')   
    
    
    if i ==1 
        legnd.f1 = join(['y = (.7-.21)* e(', num2str(tkSol),'*x) + .21' ]);
        title('Thermal Conductivity Estimation')
        xlabel('Fat%')
        ylabel('[W/(m*K)]')
    end
    if i == 2
        legnd.f1 = join(['y = (1.69 - .268)* e(', num2str(tkSol),'*x) + .268' ]);
        title('Electrical Conductivity Estimation')
        xlabel('Fat%')
        ylabel('S/m')
    end 
    if i ==3
        legnd.f1 = join(['y = (43 - 10.8)* e(', num2str(tkSol),'*x) + 10.8' ]);
        title('Permittivity Estimation')
        xlabel('Fat%')
        ylabel('1')
    end 
    hold on

    legnd.legend_array = join(["Original Points",legnd.f1 ]);
    legend(legnd.legend_array)
    %plot(x, fun(x, time),'-')
    set(0,'DefaultLegendAutoUpdate','off');
    set(gcf,'position',[80,80,700,800])  
    set(gca,'FontSize',11)
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
%linear equation 
%electrical Conductivity Est.: (liver% - fat%)*e(-.068591*x) + %fat [S/m]
    %liver = 1.69    fat = .268
%permittivity Cond = (liver% - fat%)*e(-.068591*x) + %fat
    %liver = 43    fat = 10.8  
X = [3.9 14.70 21.20 29.90 ];    

figure()
for i  = 1:3
    
    x = X; y = K;
    subplot(3,1,i)
    x_lim = linspace(0, 35, 40);
    set(gcf,'color', 'w')
    
    %f = @(a,b,x) a*exp(b*x);
    if i == 1 
        f = @(tk,x) (.521 - .21)*exp(tk * x) + .21;
        
        tkSol = -.048372;
        p1 = plot(x_lim, f(tkSol,x_lim));
        p1.Color = gold;
        hold on
        scatter(X,f(tkSol,X),'b')
        title('Thermal Conductivity Estimation')
        xlabel('Fat%')
        ylabel('[W/(m*K)]')
    end 
    if i == 2
        %f = @(tk,x) (1.69 - .268)*exp(tk * x) + .268;
        f = @(x) (1.69*(100-x)/100) + .268*(x)/100;
        
        tkSol = -.068591;
        p2 = plot(x_lim, f(x_lim));
        p2.Color = gold;
        hold on
        scatter(X,f(X),'b')
        title('Electrical Conductivity Estimation')
        xlabel('Fat%')
        ylabel('S/m')
    end 
    if i == 3
        %f = @(tk,x) (43 - 10.8)*exp(tk * x) + 10.8;
        f = @(x) (43*(100-x)/100) + 10.8*(x)/100;
        
        tkSol = -.068591;
        p3 = plot(x_lim, f(x_lim));
        p3.Color = gold;
        hold on
        scatter(X,f(X),'b')
        title('Permittivity Estimation')
        xlabel('Fat%')
        ylabel('(1)')
    end 
    
    % Printing the legend
    if i ==1 
        legnd.f1 = join(['y = (.7-.21)* e(', num2str(tkSol),')*x + .21' ]);
    end
    if i == 2
        legnd.f1 = join(['y = 1.69*(liver%) + .268*(fat%)' ]);
    end 
    if i ==3
        legnd.f1 = join(['y = 43*(liver%) + 10.8*(fat%)' ]);
    end 
    hold on
    legnd.legend_array = join(["Original Points",legnd.f1 ]);
    legend(legnd.legend_array)
    %plot(x, fun(x, time),'-')
    set(0,'DefaultLegendAutoUpdate','off');
    
    set(gcf,'position',[80,80,700,800])  
    set(gca,'FontSize',11)
end 
