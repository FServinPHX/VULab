all_liver_volumes = [];
all_liver_diameters = [];

gold = [0.847058824	0.670588235	0.298039216];
blue = [0	0.4	0.509803922 ];
green = [0.274509804	0.305882353	0.129411765];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];

patient_names = ["001_lf_lp", "002_lf_hp", "003_hf_lp", "004_hf_hp"];
tumor = "TRUE";
%
for patient_selection = 1:1
    all_liver_volumes = [];
    all_liver_diameters = [];
    
    if tumor == "TRUE"
    switch patient_selection
        case 1
            cd  'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params - With Tumor\Patient 001'
        case 2
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params - With Tumor\Patient 002'
        case 3
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params - With Tumor\Patient 003'
        case 4
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params - With Tumor\Patient 004'
    end 
    else 
    switch patient_selection
        case 1
            cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params\Patient 001'
        case 2
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params\Patient 002'
        case 3
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params\Patient 003'
        case 4
             cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params\Patient 004'
    end 
    end 
    %read all of the dicom names
    names = dir('*.csv');
    for all_filenames = 1:length(names)
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    patient_choice = patient_names(patient_selection);
    %current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    current_file_name= "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Perfusion Data\liver_001_915_MHZ_Fatty_Collins_Deshazer_with_tumor_low_fat_low_perfusion.csv";
    baseline_data = readtable(current_file_name);
    %
    coordinates = baseline_data(:,1:3);
    temp_and_arrhenius = baseline_data(:,4:end);
    baseline_temp_array = [];
    baseline_arrhenius_array = [];
    for i  = 1:width(temp_and_arrhenius)
       if mod(i,2) == 1
           baseline_temp_array = [baseline_temp_array, temp_and_arrhenius(:,i)];
       end 
       if mod(i,2) == 0
           baseline_arrhenius_array = [baseline_arrhenius_array ,temp_and_arrhenius(:,i)];
       end 
    end 
    baseline_true_temp = table2array(baseline_temp_array);
    baseline_true_arrhenius = table2array(baseline_arrhenius_array);
    X = table2array(coordinates(:,1));
    Y = table2array(coordinates(:,2));
    Z = table2array(coordinates(:,3));
    %
    for ii = 1:1
        if ii == 1
            all_data = baseline_data;
        end 
        if ii == 2
           all_data = homogenous_data;
        end 
        if ii == 3
           all_data = heterogenous_data; 
        end 
        coordinates = all_data(:,1:3);
        temp_and_arrhenius = all_data(:,4:end);
        temp_array = [];
        arrhenius_array = [];
        for i  = 1:width(temp_and_arrhenius)
           if mod(i,2) == 1
               temp_array = [temp_array, temp_and_arrhenius(:,i)];
           end 

           if mod(i,2) == 0
               arrhenius_array = [arrhenius_array ,temp_and_arrhenius(:,i)];
           end 
        end 
        true_temp = table2array(temp_array);
        true_arrhenius = table2array(arrhenius_array);
        X = table2array(coordinates(:,1));
        Y = table2array(coordinates(:,2));
        Z = table2array(coordinates(:,3));
        if ii == 1
            %we are now doing a temperature analysis
            baseline_temp = true_arrhenius;
            baseline_ahrrenhius = true_arrhenius;
        end 
        if ii == 2
            homogenous_temp = true_temp;
            homogenous_ahrrenius = true_arrhenius;
        end
        if ii ==3
            heterogenous_temp = true_temp;
            heterogenous_ahrrenius = true_arrhenius;
        end 
    end 
    %Ahrenius Volume
    arrhenius_thresh = [.98];
    %arrhenius_thresh = [55];
    baseline__nec_vol = [];
    baseline__nec_vol_points = [];
    homogenous_nec_vol = [];
    homogenous_nec_vol_points = [];
    baseline_diams = [];
    homogenous_diams = [];
    xyz_diameters = [];
    for fs = 1:length(arrhenius_thresh)
        for ii = 1:1
        necrosis_volume = [];
                if ii == 1
                    true_arrhenius = baseline_ahrrenhius ;
                    coordinates = baseline_data(:,1:3);
                    disp("healthy Liver")
                end 
                if ii == 2
                   true_arrhenius = homogenous_ahrrenius;
                   coordinates = homogenous_data(:,1:3);
                   disp("homogenous")
                end
            X = table2array(coordinates(:,1));
            Y = table2array(coordinates(:,2));
            Z = table2array(coordinates(:,3));
            %%%FINDS the necrosis volume
            for i  = 1:width(true_arrhenius)
                 total_necrosis = (true_arrhenius(:,i) >= arrhenius_thresh(fs));
                 total_necrosis=double(total_necrosis);
                 necrosis_points = [ (X.*total_necrosis), (Y.*total_necrosis), (Z.*total_necrosis) ];
%                 %%removes all points where there is no tissue necrosis
                 necrosis_points(necrosis_points == 0) = [];
                 necrosis_points = reshape(necrosis_points, [], 3);
                if isempty(necrosis_points)
                    vol = 0;
                    xyz_diameters_temp = [0,0,0];
                else 
                    [~, vol] = boundary(necrosis_points);
                    xyz_diameters_temp = find_diameters(necrosis_points);                   
                end 
                    necrosis_volume = [necrosis_volume, vol];
                    xyz_diameters = [xyz_diameters; xyz_diameters_temp];
            end 
            %%%ASSIGNS the Necrosis Volume
            if ii == 1
                    baseline__nec_vol = [baseline__nec_vol; necrosis_volume] ;
                    baseline__nec_vol_points = (necrosis_points);
                    baseline_diams = [baseline_diams;xyz_diameters];    
            end 
            if ii == 2
               homogenous_nec_vol = [homogenous_nec_vol; necrosis_volume] ;
               homogenous_nec_vol_points = (necrosis_points);
               homogenous_diams = [homogenous_diams;xyz_diameters]; 
            end
            if ii ==3
               true_arrhenius =  heterogenous_ahrrenius;
            end 
        xyz_diameters = [];    
        end 
      %Plot Volume every iteration
%     figure()
%     k = boundary(baseline__nec_vol_points,0);
%     %j = boundary(homogenous_nec_vol_points,0);
%     P = baseline__nec_vol_points;
%     %P2 = homogenous_nec_vol_points;
%     subplot(1,2,1);
%     plot3(P(:,1),P(:,2),P(:,3),'.','MarkerSize',10)
%     hold on
%     trisurf(k,P(:,1),P(:,2),P(:,3),'FaceColor','red','FaceAlpha',0.1)
%     axis equal
%     title_name = join([patient_choice,' healthy Liver Necrosis Volume = ',num2str(baseline__nec_vol(end)/1000), 'cm^3']);
%     title(title_name)
    end 
    % Exporting Data as CSV
    %Exporting Data as CSV Volume
    export_ALL_liver_vol = [string(names(all_filenames).name), arrhenius_thresh', ( baseline__nec_vol./1000 )]';
    %Exporting Data as CSV DIAMETERS
    export_All_liver_diams = [ string(names(all_filenames).name) , arrhenius_thresh', 0; baseline_diams];
    %%%All Liver fat Diameters and Volumes 
    all_liver_diameters = [all_liver_diameters, export_All_liver_diams];
    all_liver_volumes = [all_liver_volumes, export_ALL_liver_vol];
    end
%Exporting Volume Data as CSV 
patient_choice = convertStringsToChars(patient_choice);
all_liver_diameters  =array2table(all_liver_diameters);
all_liver_volumes = array2table(all_liver_volumes);
%
if tumor == "TRUE"
    direct_vol = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Tumor-Volume_Temp\';
    direct_diam = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Tumor-Diameter_Temp\';
    vol_name = ' All Liver volume_915MHZ_A_90_Tumor_perfusion_analysis.csv';
    diam_name = ' All Liver Diameters_915MHZ_A_90_Tumor_perfusion_analysis.csv';
else
    direct_vol = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No-Tumor-Volume_Temp\';
    direct_diam = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No-Tumor-Diameter_Temp\';    
    vol_name = ' All Liver volume_915MHZ_A_90_No_Tumor_perfusion_analysis.csv';
    diam_name = ' All Liver Diameters_915MHZ_A_90_No_Tumor_perfusion_analysis.csv';
end 
export_All_liver_title_vol = join([direct_vol,patient_choice, vol_name ]);
writetable( all_liver_volumes, export_All_liver_title_vol);
%Exporting DIAMETERS Data as CSV 
export_All_liver_title_diam = join([direct_diam,patient_choice, diam_name ]);
writetable( all_liver_diameters, export_All_liver_title_diam); 
end
%%
set(gcf,'color','w');
tumor = "TRUE" ;
final_volume=  [];
final_sd = [];
for choice_int = 1:2

low_fat_volume = [];
mild_fat_volume = [];
moderate_fat_volume = [];
High_fat_volume = [];
Healthy_liver_volume = [];
%%% 
choice = ["TRUE","FALSE"];
linestyle = ["-","--"];
line_choice = linestyle(choice_int);
tumor = choice( choice_int );
disp(tumor)

if tumor == "TRUE"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No-Tumor-Volume'
else
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Tumor-Volume'
end 
names = dir('*.csv');
for all_filenames = 1:length(names)
    current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    volume_data = readtable(current_file_name);
    volume_data_mod = volume_data{:,:};
    
    Healthy_liver_volume = [Healthy_liver_volume, volume_data_mod(:,5)  ];
    low_fat_volume = [low_fat_volume, volume_data_mod(:,2) ];
    mild_fat_volume = [mild_fat_volume, volume_data_mod(:,3) ];
    moderate_fat_volume = [moderate_fat_volume, volume_data_mod(:,4) ];
    High_fat_volume = [High_fat_volume, volume_data_mod(:,1) ];
    
end 
%Find the mean and stadard deviation of all of the runs
Mean_Volume_Matrix = [mean(Healthy_liver_volume,2), mean(low_fat_volume,2),...
        mean(mild_fat_volume,2), mean(moderate_fat_volume,2), mean(High_fat_volume,2)];
stdev_vol_matrix = [std(Healthy_liver_volume,0,2), std(low_fat_volume,0,2),...
        std(mild_fat_volume,0,2), std(moderate_fat_volume,0,2), std(High_fat_volume,0,2)];
%
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];

legend_base = ["No Fat", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
set(gcf,'color','w');
legend_string = [];
for i = width(Mean_Volume_Matrix):-1:1
    time = ([0:.25:15]).*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2);
        %%Add Standard Deviation
        
        p = plot(time, (Mean_Volume_Matrix(2:end,i)) ) ;
        p.LineStyle = line_choice;
        p.Color = colors(i,:);
        hold on
        legend_string = [legend_string, join([legend_base(i)])]; 

end 
        final_volume = [final_volume, Mean_Volume_Matrix(end,:)];
        final_sd = [final_sd, stdev_vol_matrix(end,:)];
        
        x_points = [20, 20, 35, 35];  
        y_points = [0, Mean_Volume_Matrix(end,5) + 1,...
            Mean_Volume_Matrix(end, 5) + 1, 0];
        color = [.84, .8, .2];
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
    ylim([0 Mean_Volume_Matrix(end,5) + 1])
    ylabel("Ablation Volume cm^3")
    xlabel("Thermal Dose (kJ)")
    title("Ablation Trajectory in All Models")
    set(gca,'FontSize',14)
    plot_figure_name = join([title_name,'.png' ]);
end
hold off
plot_figure_name = 'Combined_Ablation_Volume_plot_Temperature_Estimation.png';
saveas(gcf,plot_figure_name)
%%
%Assigning the x and y vectors 
x = final_volume(1:5);
x_sd = final_sd(1:5);
y = final_volume(6:10);
y_sd = final_sd(6:10);
%[significance_matrix] = t_test_between_data_sets(x,x_sd,y,y_sd,num_subjects)
[significance_matrix] = t_test_between_data_sets(x,x_sd,y,y_sd,4);

cdata = reshape(significance_matrix(:,5),[],5);
xvalues = [];
yvalues  = [];
xvalues_names = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
yvalues_names = ["No Fat";"Low Fat";"Mild Fat";"Moderate Fat";"High Fat"];
for i = 1:5
     xvalues = [xvalues, join([xvalues_names(i),'-', round(final_volume(i),2) ])]; 
     yvalues = [yvalues, join([yvalues_names(i),'-', round(final_volume(i+5),2) ])]; 
end     
    
%
Vandy_map = [green; blue; orange; gold; purple];
newmap = brighten(Vandy_map,.7);
figure()
set(gcf,'color','w');
h = heatmap(xvalues,yvalues, cdata,'Colormap',newmap);
h.ColorScaling = 'scaledcolumns';
h.Title = "Two-Paired Test P-Val For Ablation Volume";
h.XLabel = 'With Tumor (Fat - Ablation Volume (cm^3)';
h.YLabel = 'Without Tumor (Fat - Ablation Volume (cm^3)';
saveas(gcf,join(["Ablation Volume P_val Matrix",'.png']) )

%%
%clear
%%% Notes, make a 4*2 figure for each of the patients
%%% Remove the long diameter and the short diameter
%%% 
tumor = "TRUE" ;
low_fat_diameter = [];
mild_fat_diameter = [];
moderate_fat_diameter = [];
High_fat_diameter = [];
Healthy_liver_diameter = [];
set(gcf,'color','w');
%spacing between the data points 
space = 3;
if tumor == "TRUE"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No-Tumor-Diameter'
else
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\No-Tumor-Diameter'
end 
names = dir('*.csv');
for all_filenames = 1:length(names)
    current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    diameter_data = readtable(current_file_name);
    diameter_data_mod = diameter_data{:,:};
    
    Healthy_liver_diameter = [Healthy_liver_diameter, diameter_data_mod(:,(5-1)*space+1:space*5 )  ];
    low_fat_diameter = [low_fat_diameter, diameter_data_mod(:,(2-1)*space+1:space*2 ) ];
    mild_fat_diameter = [mild_fat_diameter, diameter_data_mod(:,(3-1)*space+1:space*3 ) ];
    moderate_fat_diameter = [moderate_fat_diameter, diameter_data_mod(:,(4-1)*space+1:space*4 ) ];
    High_fat_diameter = [High_fat_diameter, diameter_data_mod(:,(1:space) )];
end 
%find the mean of the diameters
diameters_mean = [];
for a = 1:3
diameters_mean=[ mean(Healthy_liver_diameter(:,a:3:12),2), mean(low_fat_diameter(:,a:3:12),2)...
    ,mean(mild_fat_diameter(:,a:3:12),2), mean(moderate_fat_diameter(:,a:3:12),2),...
    mean(High_fat_diameter(:,a:3:12),2),...
    diameters_mean];
end 
diamters_std = [];
for a = 1:3
diamters_std=[ std(Healthy_liver_diameter(:,a:3:12),0,2), std(low_fat_diameter(:,a:3:12),0,2)...
    ,std(mild_fat_diameter(:,a:3:12),0,2), std(moderate_fat_diameter(:,a:3:12),0,2),...
    std(High_fat_diameter(:,a:3:12),0,2),...
    diamters_std];
end 
%
%creates a block space to keep track of the number of total patients. this
%will allows for simulations to scale. 
figure()
block_space = width(diameters_mean)/space;
for i = 1:block_space
    time = ([0:.25:15]).*45.*60./1000;   
    select_color = repmat([1 2 3 4 5],1,5);

        legend_string = [];
%Set the figure parameters
        %plot the short-axis diameter
        set(0, 'DefaultLineLineWidth', 2);
        subplot(2,1,1)
        p = plot(time, (diameters_mean(2:end,block_space*2+i)) ) ;
        %p.Color = blue;
        p.LineStyle = '-';
        p.Marker = 'o';
        hold on
        subplot(2,1,2)
        %plot the long axis_diameter
        p2 = plot(time, (diameters_mean(2:end,block_space*1+i)) ) ;
        p2.LineStyle = '-';
        p2.Marker = 'o';
        hold on
        
end 
        x_points = [20, 20, 35, 35];
        subplot(2,1,1)
            y_points = [0, diameters_mean(end,block_space*1) + 2,...
                diameters_mean(end, block_space*1) + 2, 0];
            color = [.84, .8, .2];
            a = fill(x_points, y_points, color);
            a.FaceAlpha = 0.1;   
        subplot(2,1,2)
            y_points = [0, diameters_mean(end, block_space*2) + 2,...
            diameters_mean(end, block_space*2) + 2, 0];
            %set the color to the background space as gold 
            color = [.84, .8, .2];
            a = fill(x_points, y_points, color);
            a.FaceAlpha = 0.1;   
    %set(gcf,'position',[80,80,800,600])  
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    if tumor == "TRUE" ||   tumor == "JARROD_DESHAZER-TUMOR" 
        title_name = ["ALL Patients Necrotic_Volume_915_A_995_Tumor"];
        title("Models with 20 mm Diameter Tumor")
    else 
        title_name = ["ALL Patients Necrotic_Volume_915_A_995_Tumor"];
        title("Models with 20 mm Diameter Tumor")
    end 
    legend_string = ["No Fat", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
    %legend_string = repelem(legend_string,2);

    legend(legend_string)
    ylabel("Diameter")
    xlabel("Thermal Dose (J)")

    hold off
    plot_figure_name = join([title_name,'.png' ]);
    saveas(gcf,plot_figure_name)
    
mean_long_diameter = diameters_mean(:, block_space+1:block_space*2);
mean_short_diameter = diameters_mean(:, block_space*2+1:block_space*3);
std_long_diameter  = diamters_std(:, block_space+1:block_space*2);
std_short_diameter = diamters_std(:, block_space*2+1:block_space*3);
%
%%
%%%recreate the mathematical ablation margin. 

if tumor == "TRUE"
model = mphload( "C:\Users\servinf\.comsol\v56\llmatlab\Liver_MWA_MODELS_with_Tumor\001_915_mhz_COLLINS_Probe_Healthy_Tissue _with_tumor.mph");
else
model = mphload( "C:\Users\servinf\.comsol\v56\llmatlab\Liver_MWA_MODELS_with_Tumor\001_915_mhz_COLLINS_Probe_Healthy_Tissue .mph"); 
end %
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

liver_fat = [3.91, 14.7 , 20.2, 29.9 ];
mean_long_diameter = diameters_mean(:, block_space+1:block_space*2);
mean_short_diameter = diameters_mean(:, block_space*2+1:block_space*3);

h1 = mphplot(model, 'pg6'); 
set(gca,'FontSize',14) % Creates an axes and sets its FontSize to 18
set(0,'DefaultLegendAutoUpdate','off');
hold on 
%legend_string = ["Ablation Plot (Necrosis)"];
legend_string = [];
baseline_string =  [];

for i  = 1:5
    a = round(mean_long_diameter(end,i),2)*5;
    b = round(mean_short_diameter(end,i),2)*5; 
    if i == 1
         %baseline_string = [join(["Healthy Tissue, ", "LD = ", round(a*2,3) ,"(mm) ", "SD = ", round(b*2,3), "(mm)"]) ];
        baseline_string = ["No Fat"];
        color = 'g';
        legend_string = [legend_string, baseline_string];
    elseif i == 5
        %baseline_string = [join([(liver_fat(i-1)), "% FAT,   LD = ", round(a*2,3) ,"(mm) ", "SD = ", round(b*2,3), "(mm)"]) ];
        baseline_string = ["High Fat"];
        color = [.84, .8, .2];    
        legend_string = [legend_string, baseline_string];
    else 
        disp('no plot')
    end 
    t = linspace(0,2*pi,40) ;
    if tumor == "TRUE"
    x=cos(t)*a*.99; % width
    y=sin(t).*(b + x/6); %.*(b-x/7)+ 140 ; % height
    x = x +159;
    y = y + 140;
    else 
    x=cos(t)*a*1.02; % width
    y=sin(t).*(b*1.02 + x/6); %.*(b-x/7)+ 140 ; % height
    x = x +157.5;
    y = y + 140;
    end 
    if i == 1 
    p1 = plot(x,y,'k--', 'LineWidth', 2);
    elseif i == 5 
    p2 = plot(x,y, 'LineWidth', 2);
    p2.Color = purple;
    p2.LineStyle = '--';
    p2.Marker = 'o';
    p2.MarkerSize = 4;
    else 
   % plot(x,y,'--', 'LineWidth', 2)   
    end 
%     a = fill(x, y, color);
%     a.FaceAlpha = 0.1;
    hold on 
    axis equal
     if tumor == "TRUE" ||   tumor == "JARROD_DESHAZER-TUMOR" 
        title_name = ["Visualizing Ablation Area (mm) with 20 mm Diameter Tumor"];
    else 
        title_name = ["Visualizing Ablation Area (mm) without Tumor"];
     end 
end
% select which plots to plot
legend([p1,p2],legend_string)
title(title_name)
colorbar
colormap jet
xlabel("Long Axis (mm)")
ylabel("Short Axis (mm)")
ylim([100 180])
xlim([110 200])
set(gcf,'position',[80,80,800,800])  
hold off
saveas(gcf,join([title_name,'.png']) )

%%
%Find the area

%Curve_fit_the_nearest_point
necrosis_values  = double( h1{1, 2}{1, 1}.d );
necrosis_points_og = double( h1{1, 2}{1, 1}.p )  ;
%imagesc(necrosis_points(1,:),necrosis_points(2,:),necrosis_values)
%
set(gcf,'color','w');
scatter(necrosis_points_og(1,:),necrosis_points_og(2,:),[],necrosis_values );
colorbar
colormap jet
set(gcf,'position',[80,80,800,600]) 

%
necrosis_volume = [];
true_arrhenius = necrosis_values ;
coordinates = necrosis_points_og;

arrhenius_thresh = [.95];
X = coordinates(1,:);
Y = coordinates(2,:);
%%%FINDS the necrosis volume
for i  = 1:width(true_arrhenius)
     total_necrosis = (true_arrhenius(:,i) >= arrhenius_thresh);
     total_necrosis=double(total_necrosis);
     necrosis_points = [ (X'.*total_necrosis), (Y'.*total_necrosis) ];
%                 %%removes all points where there is no tissue necrosis
     necrosis_points(necrosis_points == 0) = [];
     necrosis_points = reshape(necrosis_points, [], 2);
    if isempty(necrosis_points)
        vol = 0;
        xyz_diameters_temp = [0,0,0];
    else 
        k = boundary(necrosis_points);
    end
end 
%%
set(gcf,'color','w');
boundary_x = necrosis_points(:,1);
boundary_x = boundary_x(k);
boundary_y = necrosis_points(:,2);
boundary_y = boundary_y(k);
hold on
scatter(necrosis_points(:,1),necrosis_points(:,2))
hold on 
scatter(boundary_x,boundary_y)
%
compare_y = [boundary_y(10:end); boundary_y(1:9)];
a = round(mean_long_diameter(end,i),2)*5;
b = round(mean_short_diameter(end,i),2)*5; 
t = linspace(0,2*pi,length(boundary_y)) ;
x= cos(t).*a; % width
y= sin(t).*(b + x/6); %.*(b-x/7)+ 140 ; % height


f = @(q) sin(t).*(b + (x)/q)+140;
obj_fun = @(params) sum(sum( ((f(params(1)) )-boundary_y).^2));
%sol = fminsearch(obj_fun, [6])
sol = fminbnd(obj_fun,0,6)
a_sol = sol(1);

% func = f(6)';
% func_2 = f(a_sol)'; 
% compare_functions_sum =  [compare_y, f(a_sol)', abs(f(a_sol)'- compare_y) , ...
%     f(6)',  abs(f(6)'- compare_y) ];
plot(boundary_x, boundary_y, 'r')
hold on
plot(x+157, f(a_sol), 'b')
hold off
legend("Points > .985","Boundary Points","Boundary Line","Fitted Ablation Zone")

%%
x = x +158;
y = y + 140;

 plot(x, f(a_sol)+140, 'b')
% hold on 
plot(x, f(6)+140, 'k', 'LineWidth', 2)
hold on
scatter(boundary_x,boundary_y, 'k')
ylim([100 180])
xlim([110 200])
        
%%
%set(gcf,'color','w');

mainFolder = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL\915 MHZ Collins Probe - 3D - With Tumor';  % Use absolute paths
FileList   = dir(fullfile(mainFolder, '**'));
Result     = cell(1, numel(FileList))
for iFile = 1:numel(FileList)
  File = fullfile(FileList(iFile).folder, FileList(iFile).name);
  Str  = fileread(File);
  CStr = strsplit(Str, '\n');
  Result{iSub} = CStr{end};
end
%%
model = mphload( "C:\Users\servinf\.comsol\v56\llmatlab\Liver_MWA_MODELS_with_Tumor\001_915_mhz_COLLINS_Probe_Healthy_Tissue _with_tumor.mph");
mphplot(model, 'pg6') 