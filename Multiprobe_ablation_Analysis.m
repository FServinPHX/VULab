
cd 'D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL_DATA\Multiprobe Data\Multiprobe_processed_results\Diameter'
names = dir('*.csv');
Mean_Volume_Matrix = [];
for all_filenames = 1:length(names)
    current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    volume_data = readtable(current_file_name);
    volume_data_mod = volume_data{:,:};
    
    Mean_Volume_Matrix = [Mean_Volume_Matrix, volume_data_mod];
    
end 

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%%
% Mean_Volume_Matrix = [mean(Healthy_liver_volume,2), mean(low_fat_volume,2),...
%         mean(mild_fat_volume,2), mean(moderate_fat_volume,2), mean(High_fat_volume,2)];
tumor = "TRUE";
legend_base = [ "Parrallel Probe", "Angled Probe"];
set(gcf,'color','w');
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];
linestyle = ["-","--"];
line_choice = linestyle(1);
legend_string = [];
for i = width(Mean_Volume_Matrix):-1:1
    time = ([0:.25:10]).*45.*60./1000;   
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
        %final_volume = [final_volume, Mean_Volume_Matrix(end,:)];
        %final_sd = [final_sd, stdev_vol_matrix(end,:)];
        
%         x_points = [20, 20, 35, 35];  
%         y_points = [0, Mean_Volume_Matrix(end,4) + 1,...
%             Mean_Volume_Matrix(end, 4) + 1, 0];
%         color = [.84, .8, .2];
%         hold on;
%         a = fill(x_points, y_points, color);
%         a.FaceAlpha = 0.1;       
        set(gcf,'position',[80,80,800,600])  
   
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
%     if tumor == "TRUE" ||   tumor == "JARROD_DESHAZER-TUMOR" 
%         title_name = ["Multiprobe Placements"];
%         %title("Necrotic Volume (cm^3) vs Dose (J) Models with 20 mm Diameter Tumor")
%     else 
%         title_name = ["ALL Patients Necrotic_Volume_915_A_995_No_Tumor"];
%         %title("Necrotic Volume (cm^3) vs Dose (J) Models without Tumor")
%     end 
    legend(legend_string, 'Location', 'best')
%     ylim([0 Mean_Volume_Matrix(end,4) + 1])
    ylabel("Ablation Volume cm^3")
    xlabel("Thermal Dose (kJ)")
    title("Ablation Trajectory Multiprobe Placements")
    set(gca,'FontSize',14)
%     plot_figure_name = join([title_name,'.png' ]);

hold off
plot_figure_name = 'Multiprobe Ablation Volume.png';
saveas(gcf,plot_figure_name)

