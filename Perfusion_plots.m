clear
cd ' C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Perfusion Data\Perfusion Analysis'
names = dir('*.csv');
for all_filenames = 1:length(names)
    current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
    volume_data = readtable(current_file_name);
    volume_data_mod = volume_data{:,:};
end 