%% 
clear
Sigma = [ .831, .749, .70, .634 ];
%Original Tumor Sampling
X = [3.9, 14.70, 21.20, 29.910 ] ;
%SPIE Tumor Sampling
%xtumor = [4.33, 12.79, 21.87, 33.25]; 
xtumor = [4.33, 5.56, 12.67, 33.25]; 

xtumor = [4.66, 5.56, 8.46 12.67 , 20.91, 29.90]; 
%xtumor = [ 4.6,  11.90,  22.2, 32.6 ];
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
        legnd.f1 = join(['y = (.521-.21)e^{ (', num2str( round(a_sol,3) ),'x) } + .21' ]);
        title('Thermal Conductivity Estimation')
        ylabel("(W/k*m)")
        colorLine = rgb("Crimson");
    end
    if i == 2
        legnd.f1 = join(['y = (.861 - .11)e^{ (', num2str( round(a_sol,3) ),'x ) } + .11' ]);
        title(' Electrical Conductivity Estimation')
        ylabel("(S/m)")
        colorLine = rgb("DarkGoldenRod");
    end
    

    hold on
    x_lim = linspace(0, 35, 100);
    plot(x_lim, f(a_sol,x_lim), 'Color', colorLine, 'LineWidth', 2)
    
    scatter(xtumor,  f(a_sol,xtumor),  'k', 'filled')
    
    %legnd.legend_array = join(["Original Points",legnd.f1 ]);
    legnd.legend_array = join([legnd.f1 ]);
    
    set(gca, 'FontSize',16)
    xlim([0 35])
%     xlabel("Liver  Fat (%)")
    %plot(x, fun(x, time),'-')
    set(0,'DefaultLegendAutoUpdate','off');
   
    xlabel("Liver  Fat (%)",'FontSize', 14 ) 
    legend(legnd.legend_array, 'FontSize', 12 ) 

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
    
    if i ==2
        legnd.f1 = join(['y = (.0185 - .010)*e^{ (', num2str( round(a_sol,3) ),'x) } + .010' ]);
        title('Perfusion Estimation')
        ylabel("(1/s)");
        colorLine = rgb("Navy");
    end
    if i == 1
        legnd.f1 = join(['y = (46.8 - 11.3)*e^{ (', num2str( round(a_sol,3) ),'x) } + 11.3' ]);
        title('Relative Permittivity');
        ylabel("(1)");
        colorLine = rgb("Sienna");
    end 
    
    hold on
    x_lim = linspace(0, 35, 100);
    plot(x_lim, f(a_sol,x_lim), 'Color', colorLine, 'LineWidth', 2)
    
    scatter(xtumor,  f(a_sol,xtumor), 'k', 'filled')
    
    %legnd.legend_array = join(["Original Points",legnd.f1 ]);
    legnd.legend_array = join([legnd.f1 ]);
%     legend(legnd.legend_array)
    xlim([0 35])
    
    %plot(x, fun(x, time),'-')
    set(0,'DefaultLegendAutoUpdate','off');
    set(gca, 'FontSize',16)
    
    xlabel("Liver  Fat (%)",'FontSize', 14 ) 
    legend(legnd.legend_array, 'FontSize', 12 ) 
end
set(gcf,'position',[880,80,800,600])
hold off
%%


figure()
set(gcf,'color','w');
X = [3.9, 14.70, 21.20, 29.910 ] ;
x_lim = linspace(0, 35, 100);

f = @(x) (3540 - 2348)*exp(-0.0547 * x) + 2348  ;


plot(x_lim, f(x_lim), 'r')
hold on
scatter(X,  f(X), 'g', 'filled')

 title('Heat Capacity = (3540 - 2348)*exp(-0.0547 * x) + 2348 ')
legend(["Estimated Values"])
xlim([0 35])
%plot(x, fun(x, time),'-')
set(0,'DefaultLegendAutoUpdate','off');
set(gca, 'FontSize',14)
set(gcf,'position',[880,80,800,600])

%%
clear
%Heat Capacity

%readFatIntensityData
patient = '4';
filename = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\Fat_cloud_txt\Patient_1\Fat Quant Data\Patient_004_fat_intensity.txt';
intensityData = readtable( filename );
intensityData = table2array(intensityData);

%%

iVal = double( intensityData(:,4) );

%   Liver = 3540 |  Fat = 2348
iNewHeatCp = ( (3540 - 2348)*exp(-0.0116*iVal) + 2348 ) ;



cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\Fat_cloud_txt\Patient_1\'

INewTextWrite  =[  intensityData(:,1:3) ,  iNewHeatCp ];
HeatCapName = join(['Patient_00', patient, 'Heat_Capacity.txt']);
fileID = fopen(HeatCapName,'w');
%fprintf(fileID,'%6s %12s\n','x','exp(x)');
fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
fclose(fileID);   

%%
legnd.f1 = join(['y = (.521-.21)*e(', num2str(a_sol),'*x) + .21' ]);
title('Thermal Conductivity Estimation')



%%
%Curve fitting the temperature dependent curves 
clear
%

type = "therm";


k_liver  = .271;
sigma_liver = .5 ;
eps_liver = 36.20;

syms T

if type == "therm"
%Thermal Conductivity
y(T) = piecewise( T < 37, k_liver, ...
                  37 < T < 100 ,k_liver*(1+.00092*( T -37)),...
                  T == 100, (k_liver*(1+.00092*( T -37)) + k_liver*(1-.00092*(100-37)))/2, ...
                  T > 100 ,k_liver*(1-.00092*(100-37)) );
                           
param_min = k_liver*(1-.00092*(100-37)) ;
plotTitle = "Thermal Conductivity"; 
yLabel = "(W/k*m)";
plot_color = rgb('Maroon') ; 

elseif type == "elec"             
%Electrical Conductivity
y(T) = piecewise( T < 37, sigma_liver, ...
                  37 < T < 95 , .00897*T + (sigma_liver -.3372) ,...
                  95 < T < 100  , -.112*T + (sigma_liver  + 11.16) , ...
                  T > 100 , sigma_liver - .04 );
              
param_min =  sigma_liver - .04;
plotTitle = "Electrical Conductivity"; 
yLabel = "(S/m)";
plot_color = rgb('DarkGoldenRod') ; 


elseif type == "permtv" 

y(T) = piecewise( T < 95 , .0172*(T)+ (eps_liver - .39)  ,...
                  95 < T < 100  , (-3.40*(T) + (eps_liver + 320.97))  , ...
                  T > 100 , (eps_liver - 19.03)  );
              
param_min =  (eps_liver - 19.03);   
plotTitle = "Permittivity"; 
yLabel = "(1)";
plot_color = rgb('DarkSlateGray') ; 

end 
              
min_val = 0;
max_val = 200;
[ Vals.x , Vals.y ] =  fplot(y, [min_val max_val]);
Vals.xIntrp = min_val:.25:max_val;
Vals.vq1 = interp1(Vals.x ,Vals.y , Vals.xIntrp );

%Plotting Function
set(gcf,'color','w' );
%plot( Vals.x , Vals.y, '-' , Vals.xIntrp, Vals.vq1, '.' ) ;
plot( Vals.x , Vals.y, '-', 'Color', plot_color, 'LineWidth', 3 )


set(gca,'FontSize',14)
title(plotTitle)
xlabel("Temp (C)")
ylabel(yLabel);

% f = @(A,x) 
%%

x = Vals.xIntrp;
y = Vals.vq1;



f = @(A, tk, x) param_min + A*exp(tk * x* -1) ;
y =  Vals.vq1;

obj_fun = @(params) norm(f(params(1), params(2), x) -y);
sol = fminsearch(obj_fun, [.5 , .5 ]); 
a_sol = sol(1);
b_sol = sol(2);

hold on
plot(x, f( a_sol, b_sol, x), 'r')
title(type)

%%
%Curve fitting the temperature dependent curves 
clear
%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];



type = "powerOnThenOFF";


PowerIn  = 10;

syms T

if type == "powerOnThenOFF"
    %Thermal Conductivity
    y(T) = piecewise( 0 < T < 15 ,PowerIn,...
                      T == 15,  PowerIn/2, ...
                      T > 15 ,0  );

    plotTitle = "Power On Then Off"; 
    yLabel = "Watts (W)";

elseif type == "powerOFFThenON"             
    %Electrical Conductivity
    y(T) = piecewise( 0 < T < 15 , 0 ,...
                      T == 15 ,  PowerIn/2, ...
                      T > 15 , PowerIn ); 

    plotTitle = "Power Off Then On"; 
    yLabel = "Watts (W)";

end 
              
min_val = 0;
max_val = 20;
[ Vals.x , Vals.y ] =  fplot(y, [min_val max_val]);
Vals.xIntrp = min_val:.25:max_val;
Vals.vq1 = interp1(Vals.x ,Vals.y , Vals.xIntrp );

%Plotting Function
set(gcf,'color','w' );
%plot( Vals.x , Vals.y, '-' , Vals.xIntrp, Vals.vq1, '.' ) ;
plot( Vals.x , Vals.y, '-', 'Color', gold )
ylim([0 PowerIn+10])

set(gca,'FontSize',14)
title(plotTitle)
xlabel("Time (min)")
ylabel(yLabel);

%%

%               2.45GHz Models
clear

%Thermal Cond    fat = 0.21         Liver = 0.52	
%Electrica Cond  fat = 2.68E-1	    Liver = 1.69E+0	
%Relative Perm   fat = 1.08E+1     Liver = 4.30E+1

%Original Tumor Sampling
% X = [3.9, 14.70, 21.20, 29.910 ] ;
X = [4.66, 12.67 , 20.91, 29.90, 5.56, 2.90]; 
x_lim = linspace(0, 35, 100);
set(gcf,'color','w');
figure(1) 
for i = 1:3
    
subplot(2,2,i)
   switch i
       case 3
            fiNewKIso = @(iVal) ( (.52-.21)*exp(-0.0547*iVal) + .21 ) ;
            f = fiNewKIso;
            title('Thermal Conductivity Estimation')
            
       case 1
            fiNewEr =@(iVal)  ( ( 43.0 - 5.28 )*exp(-0.01144*iVal) + 5.28 ) ;
            f = fiNewEr;
            title('Relative Permittivity')
            
       case 2
            fiNewEc = @(iVal)  ( (1.69 - .268 )*exp(-0.0116*iVal) + .268 ) ;
            f = fiNewEc;
            title(' Electrical Conductivity Estimation')
            
   end 


% f = @(A, tk, x) param_min + A*exp(tk * x* -1) ;

hold on 
scatter(X ,  f(X), 'g', 'filled')
plot(x_lim, f(x_lim),'b')
set(0,'DefaultLegendAutoUpdate','off');
set(gca, 'FontSize',12)
hold off

end 

all_vals = round( [ fiNewKIso(X)', fiNewEr(X)', fiNewEc(X)'], 5) ;


%%
clear
% Given x and y data
xdata = [0, 100];
ydata = [.018, 0];

% Define the decaying exponential model
model = fittype('a * exp(b * x)');

% Fit the model to the data
fitResult = fit(xdata', ydata', model);

% Get the coefficient values
coefs = coeffvalues(fitResult);
a = coefs(1);
b = coefs(2);

% Generate a fine-grained x-axis for plotting
x = linspace(0, 100, 1000);

% Calculate the corresponding y values using the fitted coefficients
y = a * exp(b * x);

% Plot the data and the fitted exponential function
plot(xdata, ydata, 'ro', 'DisplayName', 'Data');
hold on;
plot(x, y, 'b-', 'DisplayName', 'Fitted Exponential Function');
hold off;

% Set labels and title
xlabel('x');
ylabel('y');
title('Decaying Exponential Function Fit to Data');

% Add legend
legend('Location', 'best');

% Display the fitted exponential coefficients and the curve equation
disp(['Fitted exponential coefficients: a = ', num2str(a), ', b = ', num2str(b)]);
disp(['Curve equation: y = ', num2str(a), ' * exp(', num2str(b), ' * x)']);

%
figure()
% Define the range of y and x
yRange = [0, 0.0180];
xRange = [0, 100];

% Generate a grid of y and x values
[y, x] = meshgrid(yRange(1):0.001:yRange(2), xRange(1):1:xRange(2));

% Calculate the corresponding z values
z = y .* exp(-0.044196 * x);

% Create a 3D surface plot
surf(x, y, z);

% Set labels and title
xlabel('x');
ylabel('y');
zlabel('z');
title('3D Surface Plot: z = y * exp(-0.044196 * x)');
