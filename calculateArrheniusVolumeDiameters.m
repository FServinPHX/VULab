

function [all_liver_volumes,all_liver_diameters] = calculateArrheniusVolumeDiameters(file_path)
[filepath,name,ext] = fileparts(file_path);    
%
for patient_selection = 1:1
    all_liver_volumes = [];
    all_liver_diameters = [];
    %read all of the dicom names
    patient_choice = ["Individual"];
    %current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
   baseline_data = readtable(file_path);
    %
    coordinates = baseline_data(:,1:3);
    temp_and_arrhenius = baseline_data(:,4:end);
    baseline_temp_array = [];
    baseline_arrhenius_array = [];
    
    BoundaryPoints.all = zeros(2000, 16*4*3);
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
        %extracting the coordinates from the COMSOL Data
        X = table2array(coordinates(:,1));
        Y = table2array(coordinates(:,2));
        Z = table2array(coordinates(:,3));
        if ii == 1
            %we are now doing a temperature analysis
            baseline_temp = true_temp;
            baseline_ahrrenhius = true_arrhenius;
        end 
    end 
    
    %SECTION OF THE CODE for Ahrenius Volume Calulation 
    arrhenius_thresh = [.98];
    %arrhenius_thresh = [100];
    baseline__nec_vol = [];
    baseline__nec_vol_points = [];
    homogenous_nec_vol = [];
    homogenous_nec_vol_points = [];
    baseline_diams = [];
    homogenous_diams = [];
    xyz_diameters = [];
    %  TIME 
    time = ([0:.25:15]);
    
    for fs = 1:length(arrhenius_thresh)
        for ii = 1:1
        necrosis_volume = [];
                if ii == 1
                    %%% TO CHANGE FROM ARREHNIUS vs temperature 
                    true_arrhenius = baseline_ahrrenhius ;
                    coordinates = baseline_data(:,1:3);
                    disp("healthy Liver")
                end 
            X = table2array(coordinates(:,1));
            Y = table2array(coordinates(:,2));
            Z = table2array(coordinates(:,3));
            %%%FINDS the necrosis volume
            for i  = 1:width(true_arrhenius)
                 total_necrosis = (true_arrhenius(:,i) >= arrhenius_thresh(fs));
                 total_necrosis=double(total_necrosis);
                 necrosis_points = [ (X.*total_necrosis), (Y.*total_necrosis), (Z.*total_necrosis) ];
%                 %%REMOVES all points where there is no tissue necrosis
                 necrosis_points(necrosis_points == 0) = [];
                 necrosis_points = reshape(necrosis_points, [], 3);
                 
                 %If there are no points that are necrosed, then this
                 %section of the code returns the volume and points as zero
                if isempty(necrosis_points)
                    vol = 0;
                    xyz_diameters_temp = [0,0,0];
                    %inserting the boundary points 
                    BoundaryPoints.all(1,((i-1)*3+1):((i-1)*3+3)) = ...
                        [time(i) , arrhenius_thresh', 0];
                    BoundaryPoints.all(2,((i-1)*3+1):((i-1)*3+3)) = xyz_diameters_temp;
                else 
                    %finds the volume of the boundary
                    [~, vol] = boundary(necrosis_points);
                    
                    k = boundary(necrosis_points);
                    BoundaryPoints.k = reshape(k,[],1);
                    BoundaryPoints.kSort = unique(BoundaryPoints.k);
                    BoundaryPoints.kSortPoint = necrosis_points(BoundaryPoints.kSort,:);
                    %%store the boundary points
                    BoundaryPoints.all( 1:length( BoundaryPoints.kSortPoint )...
                        ,((i-1)*3+1):((i-1)*3+3)) = BoundaryPoints.kSortPoint;
                    %%%Mark the 
                    BoundaryPoints.all(1,((i-1)*3+1):((i-1)*3+3)) = ...
                        [time(i) , arrhenius_thresh', 0];
                    
                    xyz_diameters_temp = find_diameters(necrosis_points);                   
                end 
                
                    necrosis_volume = [necrosis_volume, vol];
                    xyz_diameters = [xyz_diameters; xyz_diameters_temp];
            end 
            %%ASSIGNS the Necrosis Volume
            if ii == 1
                    baseline__nec_vol = [baseline__nec_vol; necrosis_volume] ;
                    baseline__nec_vol_points = (necrosis_points);
                    baseline_diams = [baseline_diams;xyz_diameters];    
            end 
        xyz_diameters = [];    
        end 
    end 
    
    
    % Exporting Data as CSV
    %Exporting Data as CSV Volume
    export_ALL_liver_vol = [string(name), arrhenius_thresh', ( baseline__nec_vol./1000 )]';
    %Exporting Data as CSV DIAMETERS
    export_All_liver_diams = [ string(name) , arrhenius_thresh', 0; baseline_diams];
    %%%All Liver fat Diameters and Volumes 
    all_liver_diameters = [all_liver_diameters, export_All_liver_diams];
    all_liver_volumes = [all_liver_volumes, export_ALL_liver_vol];
%     end
%Exporting Volume Data as CSV 
%     end
%Exporting Volume Data as CSV 
all_liver_diameters  =array2table(all_liver_diameters);
all_liver_volumes = array2table(all_liver_volumes);
%
% direct_vol = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Tumor-Volume_Temp\';
% direct_diam = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Tumor-Diameter_Temp\';
% vol_name = ' All Liver volume_915MHZ_A_90_Tumor_perfusion_analysis.csv';
% diam_name = ' All Liver Diameters_915MHZ_A_90_Tumor_perfusion_analysis.csv';
% 
% export_All_liver_title_vol = join([direct_vol,patient_choice, vol_name ]);
% writetable( all_liver_volumes, export_All_liver_title_vol);
% %Exporting DIAMETERS Data as CSV 
% export_All_liver_title_diam = join([direct_diam,patient_choice, diam_name ]);
% writetable( all_liver_diameters, export_All_liver_title_diam); 
end
end 
