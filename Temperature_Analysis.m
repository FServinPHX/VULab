clear
all_liver_temps = [];
gold = [0.847058824	0.670588235	0.298039216];
blue = [0	0.4	0.509803922 ];
green = [0.274509804	0.305882353	0.129411765];
red = [0.6	0.239215686	0.105882353];
black = [0	0	0];
patient_names = ["001", "002", "003", "004"];
tumor = "FALSE";
%
for patient_selection = 1:5
    all_liver_temps = [];
    patient_names = ["Healthy", "Low Fat", "Mild Fat", "Moderate Fat", "High Fat"];
    if tumor == "FALSE"
    switch patient_selection
        case 1
            cd  'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\No_Tumor\Healthy_Tissue'
        case 2
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\No_Tumor\Low_Fat_Tissue'
        case 3
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\No_Tumor\Mild_Fat_Tissue'
        case 4
            cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\No_Tumor\Moderate_Fat_Tissue'
        case 5
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\No_Tumor\High_Fat_Tissue'
    end 
    else 
    switch patient_selection
         case 1
            cd  'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\With_Tumor\Healthy_Tissue'
        case 2
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\With_Tumor\Low_Fat'
        case 3
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\With_Tumor\Mild_Fat'
        case 4
            cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\With_Tumor\Moderate_Fat'
        case 5
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\With_Tumor\High_Fat'
    end 
    end
    %read all of the dicom names
    names = dir('*.csv');
    for all_filenames = 1:length(names)
    patient_choice = patient_names(patient_selection);
    current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    temperature_data = readtable(current_file_name);
    temperature_data = table2array(temperature_data(6:end,:));
    %Exporting Data as CSV DIAMETERS
    export_All_temps = [ string(names(all_filenames).name) , 0; temperature_data];
    %%%All Liver fat Diameters and Volumes 
    all_liver_temps = [all_liver_temps, export_All_temps];   
    end 
    all_liver_temps = array2table(all_liver_temps);  
    if tumor == "TRUE"
        direct_temper = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\Exported_Data_With_Tumor\';
        temper_name = ' All Liver Temperature_915MHZ_A_90_Tumor.csv';
    else
        direct_temper = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\Exported_Data_No_Tumor\';
        temper_name = ' All Liver Temperature_915MHZ_A_90_No_Tumor.csv';
    end
    %Exporting DIAMETERS Data as CSV
    export_All_liver_title_vol = join([direct_temper,patient_choice, temper_name ]);
    writetable( all_liver_temps, export_All_liver_title_vol);
end 
%%
set(gcf,'color','w');
trapz_matrix = [];
for choice_int = 2:-1:1 
tumor = "false" ;
High_fat_temp = [];
Healthy_liver_temp = [];
all_temp_data = [];
legend_array =[];
block_data = 8;
choice = ["FALSE","TRUE"];

    
tumor = choice( choice_int );
linestyle = ["-","--"];
line_choice = linestyle(choice_int);
disp(tumor)

if tumor == "TRUE"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2D Temperature Data\Exported_Data_With_Tumor'
else
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2D Temperature Data\Exported_Data_No_Tumor'
end 
names = dir('*.csv');
for all_filenames = 1:length(names)
    current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    volume_data = readtable(current_file_name);
    volume_data_mod = volume_data{:,:};
    all_temp_data = [all_temp_data, volume_data_mod];
end 

Healthy_liver_temp = all_temp_data(:,1:block_data);
High_fat_temp = all_temp_data(:,block_data+1:block_data*2 ) ;
Low_fat_temp = all_temp_data(:,block_data*2+1:block_data*3 ) ;
Mild_fat_temp = all_temp_data(:,block_data*3+1:block_data*4 ) ;
Moderate_fat_temp  = all_temp_data(:,block_data*4+1:block_data*5 ) ;

Liver_mean = [ mean(Healthy_liver_temp(:,2:2:block_data),2),...
    mean(Low_fat_temp(:,2:2:block_data),2),...
     mean(Mild_fat_temp(:,2:2:block_data),2),...
      mean(Moderate_fat_temp(:,2:2:block_data),2),...
    mean(High_fat_temp(:,2:2:block_data),2)];

Liver_sd = [ std(Healthy_liver_temp(:,2:2:block_data),0,2),...
    std(Low_fat_temp(:,2:2:block_data),0,2),...
     std(Mild_fat_temp(:,2:2:block_data),0,2),...
      std(Moderate_fat_temp(:,2:2:block_data),0,2),...
    std(High_fat_temp(:,2:2:block_data),0,2)];   

%Calculate the global average and global standard deviation 
global_liver_temp =[ (Healthy_liver_temp(:,2:2:block_data)),...
(Low_fat_temp(:,2:2:block_data)),...
(Mild_fat_temp(:,2:2:block_data)),...
(Moderate_fat_temp(:,2:2:block_data)),...
(High_fat_temp(:,2:2:block_data))];

average_global_liver_temp = mean(global_liver_temp,2);
std_global_temp = std(global_liver_temp,0,2);

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
gold = [0.847058824	0.670588235	0.298039216];
dark_gold = [0.9290, 0.6940, 0.1250];
blue = [0 0.4470 0.7410];
blue2 = [0 0.4470 0.8410];
light_blue = [0.3010, 0.7450, 0.9330];
green = [0.4660 0.6740 0.1880];
red = [1	0.239215686	0.105882353];
red2 = [.7	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
dark_grey = [0.7, 0.7, 0.7];
%colors = [green; blue; orange; gold; purple];
colors = [red; blue];
colors_std =  [red; blue];

current_means = reshape(average_global_liver_temp(2:end,1),[],8);
current_sd = reshape(std_global_temp(2:end,1),[],8);

x = [Healthy_liver_temp(3:length(current_means)+1,1) .*45.*60./1000]'; 
y_vals = current_means(2:end,1)' ;
std_dev = current_sd(2:end,1)';

curve1 = y_vals + std_dev;
curve2 = y_vals - std_dev;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
h = fill(x2, inBetween, colors_std(choice_int,:));
set(h,'facealpha',.8)
%h.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on;
trapz_matrix = [trapz_matrix, trapz(x,curve1-curve2)];
%     p = plot(x , y_vals,'LineWidth',2  ) ;
%     p.LineStyle = line_choice;
%     txt = join([round(y_vals(end),1)," C"]);
%     text(x(end)-4,y_vals(end)+1.5,txt)
%     %p.Color = color_array(i,:);
%     p.LineStyle = '-';
%     p.Color = colors(choice_int,:);
%     %p.Marker = 'o';
if tumor == "TRUE"
    top_curve = curve2;
    curve3 = curve1;
else 
    bottom_curve = curve1;
    curve4 = curve2;
end 

hold on

set(gcf,'position',[300,300,800,600])  
disp("go")
%disp(title_arr(i))

end 
curve1 = bottom_curve; 
curve2 = top_curve;
x2 = [x, fliplr(x)];
inBetween = [curve1, fliplr(curve2)];
h = fill(x2, inBetween, purple);
trap_val = trapz(x,curve1- curve2);
hold on

p1 = plot(x,curve1,'--', 'LineWidth',3.5);
p1.Color = red2;
hold on 
p2 = plot(x,curve4,'--', 'LineWidth',3.5);
p2.Color = red2;

hold on 
p3 = plot(x, curve2, '--','LineWidth',3.5);
p3.Color = blue2;
hold on 
p4 = plot(x, curve3, '--','LineWidth',3.5);
p4.Color = blue2;

txt = [join([round(trap_val/trapz_matrix(1),4)*100,"% Overlap With Tumor"])...
    join([round(trap_val/trapz_matrix(2),4)*100,"% Overlap Without Tumor"]) ];
%text(x(end)-20,curve2(end)+(curve1(end)- curve2(end))/2,txt, 'FontSize',14 )
set(gca,'FontSize',14)
set(h,'facealpha',.7)
%h.Annotation.LegendInformation.IconDisplayStyle = 'off';

legend_array = ["Models with Tumor", "Models without Tumor","Overlap Between Models"];
ylabel("Temperature (C)")
ylim([50 121])
xlabel("Thermal Dose (kJ)")
%title("Average Temperatures (C)")
legend(legend_array, 'Location','Best')
title(["Potential Temperature Values"," When Naive to Fat Content"])
%hold off
plot_figure_name = join(['Aggregate_Temperature_Over_Time_.png' ]);
saveas(gcf,plot_figure_name)
%Separate the blue and red regions/ make them more distinguished 
%%
title_arr = ["Healthy","Low Fat","Mild Fat","Moderate Fat","High Fat"];
legend_temp= ["5 mm ", "10 mm", "15 mm", "20 mm" ];
legend_array = [];
gold = [0.847058824	0.670588235	0.298039216];
dark_gold = [0.9290, 0.6940, 0.1250];
blue = [0 0.4470 0.7410];
light_blue = [0.3010, 0.7450, 0.9330];
green = [0.4660 0.6740 0.1880];
red = [0.9	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
dark_grey = [0.7, 0.7, 0.7];
colors = [green; blue; orange; gold; purple];

for i  =width(Liver_mean):-1:1
    %legend_array = [];
    current_means = reshape(Liver_mean(2:end,i),[],8);
    current_sd = reshape(Liver_sd(2:end,i),[],8);
    %subplot(2,2,i)
    %figure(i)
    for y = 1:1%width(current_means)/2
        x = [Healthy_liver_temp(3:length(current_means)+1,1) .*45.*60./1000]'; 
        y_vals = current_means(2:end,y)' ;
        std_dev = current_sd(2:end,y)';
        
        curve1 = y_vals + std_dev;
        curve2 = y_vals - std_dev;
        x2 = [x, fliplr(x)];
        inBetween = [curve1, fliplr(curve2)];
        h = fill(x2, inBetween, black);
        set(h,'facealpha',.1)
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        hold on;
        
        p = plot(x , y_vals,'LineWidth',2  ) ;
        txt = join([round(y_vals(end),1)," C"]);
        text(x(end)-4,y_vals(end)+2,txt)
        %p.Color = color_array(i,:);
        p.LineStyle = '-';
        p.Color = colors(i,:);
        %p.Marker = 'o';
        hold on
        disp("go")
        disp(title_arr(i))
        legend_array = [legend_array, join([legend_temp(y),title_arr(i)]),  ]; 
    end 
    
        ylabel("Temperature (C)")
        xlabel("Thermal Dose (J)")
        %title("Average Temperatures (C)")
        legend(legend_array, 'Location','Best')
        
end 
if tumor == "TRUE" 
    title_name = ["Average Temperatures (C) With 20 mm Diameter Tumor"];
    title(title_name)
else 
    title_name = ["Average Temperatures (C) Without Tumor"];
    title(title_name)
end 
    
hold off
plot_figure_name = join([title_name,'.png' ]);
saveas(gcf,plot_figure_name)
%%
for choice_int = 2:-1:1 
tumor = "false" ;
High_fat_temp = [];
Healthy_liver_temp = [];
all_temp_data = [];
legend_array =[];
block_data = 8;
choice = ["FALSE","TRUE"];

    
tumor = choice( choice_int );
linestyle = ["-","--"];
line_choice = linestyle(choice_int);
disp(tumor)

if tumor == "TRUE"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\Exported_Data_With_Tumor'
else
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\Exported_Data_No_Tumor'
end 
names = dir('*.csv');
for all_filenames = 1:length(names)
    current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    volume_data = readtable(current_file_name);
    volume_data_mod = volume_data{:,:};
    all_temp_data = [all_temp_data, volume_data_mod];
end 

Healthy_liver_temp = all_temp_data(:,1:block_data);
High_fat_temp = all_temp_data(:,block_data+1:block_data*2 ) ;
Low_fat_temp = all_temp_data(:,block_data*2+1:block_data*3 ) ;
Mild_fat_temp = all_temp_data(:,block_data*3+1:block_data*4 ) ;
Moderate_fat_temp  = all_temp_data(:,block_data*4+1:block_data*5 ) ;

Liver_mean = [ mean(Healthy_liver_temp(:,2:2:block_data),2),...
    mean(Low_fat_temp(:,2:2:block_data),2),...
     mean(Mild_fat_temp(:,2:2:block_data),2),...
      mean(Moderate_fat_temp(:,2:2:block_data),2),...
    mean(High_fat_temp(:,2:2:block_data),2)];

Liver_sd = [ std(Healthy_liver_temp(:,2:2:block_data),0,2),...
    std(Low_fat_temp(:,2:2:block_data),0,2),...
     std(Mild_fat_temp(:,2:2:block_data),0,2),...
      std(Moderate_fat_temp(:,2:2:block_data),0,2),...
    std(High_fat_temp(:,2:2:block_data),0,2)];   

%Calculate the global average and global standard deviation 
global_liver_temp =[ (Healthy_liver_temp(:,2:2:block_data)),...
(Low_fat_temp(:,2:2:block_data)),...
(Mild_fat_temp(:,2:2:block_data)),...
(Moderate_fat_temp(:,2:2:block_data)),...
(High_fat_temp(:,2:2:block_data))];

average_global_liver_temp = mean(global_liver_temp,2);
std_global_temp = std(global_liver_temp,0,2); 

if tumor == "TRUE"
    tumor_liver_mean = Liver_mean;
    tumor_liver_sd = Liver_sd;
else
    no_tumor_liver_mean = Liver_mean;
    no_tumor_liver_sd = Liver_sd; 
end 
end 
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%%
significance_matrix = [];
all_probs = [];
patient_status = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
T.final_temp_tumor = [];
T.final_temp_tumor_sd = [];
T.final_temp_no_tumor = [];
T.final_temp_no_tumor_sd = [];
for i = 1:width(Liver_mean)
    %legend_array = [];
    %Means 
    current_means_tumor = reshape(tumor_liver_mean(2:end,i),[],8);
    current_means_no_tumor = reshape(no_tumor_liver_mean(2:end,i),[],8);
    %Standard Deivation
    current_sd_tumor = reshape(tumor_liver_sd(2:end,i),[],8);
    current_sd_no_tumor =  reshape(no_tumor_liver_sd(2:end,i),[],8);
    %subplot(2,2,i)
    %figure(i)
    for y = 1:1%width(current_means)/2

    y_vals_tumor = current_means_tumor(end,y)' ;
    std_dev_tumor = current_sd_tumor(end,y)';
    y_vals_no_tumor = current_means_no_tumor(end,y)'; 
    std_dev_no_tumor =  current_sd_no_tumor(end,y)';

    T.final_temp_tumor =[T.final_temp_tumor, y_vals_tumor]; 
    T.final_temp_tumor_sd =[T.final_temp_tumor_sd, std_dev_tumor]; 
    T.final_temp_no_tumor =[T.final_temp_no_tumor, y_vals_no_tumor]; 
    T.final_temp_no_tumor_sd =[T.final_temp_no_tumor_sd, std_dev_tumor]; 

    end 
end 

   
%%
%Assigning the x and y vectors 
x =  T.final_temp_tumor;
x_sd = T.final_temp_tumor_sd;
y = T.final_temp_no_tumor;
y_sd = T.final_temp_no_tumor_sd ;
%[significance_matrix] = t_test_between_data_sets(x,x_sd,y,y_sd,num_subjects)
[significance_matrix] = t_test_between_data_sets(y,y_sd, y, y_sd,4);

cdata = reshape(significance_matrix(:,5),[],5);
xvalues = [];
yvalues  = [];
xvalues_names = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
yvalues_names = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
for i = 1:5
     xvalues = [xvalues, join([xvalues_names(i),'-', round(x(i),2) ])]; 
     yvalues = [yvalues, join([yvalues_names(i),'-', round(y(i),2) ])]; 
end     
    
%
Vandy_map = [green; blue; orange; gold; purple];
newmap = brighten(Vandy_map,.7);
figure()
set(gcf,'color','w');
h = heatmap(yvalues,yvalues, cdata,'Colormap',newmap);
h.ColorScaling = 'scaledcolumns';
h.Title = "Two-Paired Test P-Val For Ablation Volume";
h.XLabel = 'Without Tumor Temperatures (C)';
h.YLabel = 'Without Tumor Temperatures (C)';
saveas(gcf,join(["Temperature P_val Matrix",'.png']) )
%%
set(gcf,'color','w');
trapz_matrix = [];
for choice_int = 2:-1:1 
tumor = "false" ;
High_fat_temp = [];
Healthy_liver_temp = [];
all_temp_data = [];
legend_array =[];
block_data = 8;
choice = ["FALSE","TRUE"];

title_arr = ["Healthy","Low Fat","Mild Fat","Moderate Fat","High Fat"];
legend_temp= ["5 mm ", "10 mm", "15 mm", "20 mm" ];
legend_array = [];
gold = [0.847058824	0.670588235	0.298039216];
dark_gold = [0.9290, 0.6940, 0.1250];
blue = [0 0.4470 0.7410];
light_blue = [0.3010, 0.7450, 0.9330];
green = [0.4660 0.6740 0.1880];
red = [0.9	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
dark_grey = [0.7, 0.7, 0.7];
colors = [green; blue; orange; gold; purple];
    
tumor = choice( choice_int );
linestyle = ["--","-"];
line_choice = linestyle(choice_int);
disp(tumor)

if tumor == "TRUE"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\Exported_Data_With_Tumor'
else
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\2-D Temperature Data\Exported_Data_No_Tumor'
end 
names = dir('*.csv');
for all_filenames = 1:length(names)
    current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    volume_data = readtable(current_file_name);
    volume_data_mod = volume_data{:,:};
    all_temp_data = [all_temp_data, volume_data_mod];
end 

Healthy_liver_temp = all_temp_data(:,1:block_data);
High_fat_temp = all_temp_data(:,block_data+1:block_data*2 ) ;
Low_fat_temp = all_temp_data(:,block_data*2+1:block_data*3 ) ;
Mild_fat_temp = all_temp_data(:,block_data*3+1:block_data*4 ) ;
Moderate_fat_temp  = all_temp_data(:,block_data*4+1:block_data*5 ) ;

Liver_mean = [ mean(Healthy_liver_temp(:,2:2:block_data),2),...
    mean(Low_fat_temp(:,2:2:block_data),2),...
     mean(Mild_fat_temp(:,2:2:block_data),2),...
      mean(Moderate_fat_temp(:,2:2:block_data),2),...
    mean(High_fat_temp(:,2:2:block_data),2)];



for i  =width(Liver_mean):-1:1
    %legend_array = [];
    current_means = reshape(Liver_mean(2:end,i),[],8);
    %current_sd = reshape(Liver_sd(2:end,i),[],8);
    %subplot(2,2,i)
    %figure(i)
    for y = 1:1%width(current_means)/2
        x = [Healthy_liver_temp(3:length(current_means)+1,1) .*45.*60./1000]'; 
        y_vals = current_means(2:end,y)' ;
%         std_dev = current_sd(2:end,y)';
%         
%         curve1 = y_vals + std_dev;
%         curve2 = y_vals - std_dev;
%         x2 = [x, fliplr(x)];
%         inBetween = [curve1, fliplr(curve2)];
%         h = fill(x2, inBetween, black);
%         set(h,'facealpha',.1)
%         h.Annotation.LegendInformation.IconDisplayStyle = 'off';
%         hold on;
        
        p = plot(x , y_vals,'LineWidth',2  ) ;
        txt = join([round(y_vals(end),1)," C"]);
        %text(x(end)-4,y_vals(end)+2,txt)
        %p.Color = color_array(i,:);
        p.LineStyle = line_choice;
        p.Color = colors(i,:);
        %p.Marker = 'o';
        hold on
        disp("go")
        disp(title_arr(i))
        legend_array = [legend_array, join([legend_temp(y),title_arr(i)]),  ]; 
    end 
    
        ylabel("Temperature (C)")
        xlabel("Thermal Dose (kJ)")
        %title("Average Temperatures (C)")
        legend(legend_array, 'Location','Best')
        
end 
if tumor == "TRUE" 
    title_name = ["Average Temperatures (C) With 20 mm Diameter Tumor"];
    title(title_name)
else 
    title_name = ["Average Temperatures (C)"];
    title(title_name)
end 
end 
    
hold off
plot_figure_name = join([title_name,'.png' ]);
saveas(gcf,plot_figure_name)

