



file_path = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\T_ThetaD_Electric Field\BoxPhantomMultiprobe_TrueBeef0Degrees_Refined_9.9mmSpc.csv";
[filepath,name,ext] = fileparts(file_path);    
baseline_data = readtable(file_path);


%%
for patient_selection = 1:1
    all_liver_volumes = [];
    all_liver_diameters = [];
    all_liver_diameters2 = [];
    %read all of the dicom names

    %
    coordinates = baseline_data(:,1:3);
    temp_and_arrhenius = baseline_data(:,4:end);
    baseline_temp_array = [];
    baseline_arrhenius_array = [];
    BoundaryPoints.all = zeros(8000, 20*4*3);
    
    
    %SECTION OF THE CODE for Ahrenius Volume Calulation 
    %arrhenius_thresh = [100];
    baseline__nec_vol = [];
    baseline_diams = [];
    homogenous_diams = [];
    xyz_diameters = [];
    %  TIME 
    %time = ([0:.25:15]);
    time = ([0:.25:20]);
    
    
    
    
    %arrhenius_thresh = [.98];
    for fs = 1:length(arrhenius_thresh)
        
        necrosis_volume = [];
                
        %%% TO CHANGE FROM ARREHNIUS vs temperature 
        true_arrhenius = baseline_ahrrenhius ;
        coordinates = baseline_data(:,1:3);
        disp("healthy Liver")
               
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
                    %[~, vol] = boundary(necrosis_points, .20);
                    [~, vol] = boundary(necrosis_points, .4);
                    %%% TOGGLE THE SHRINK VALUE, DEFAULT = .5, 
                    %%% min = 0 (convex), max = 1 (concave) ] 
                    k = boundary(necrosis_points);
                    %BoundaryPoints.k = reshape(k,[],1);
                    BoundaryPoints.k = reshape(k,[],1);
                    BoundaryPoints.kSort = unique(BoundaryPoints.k);    
                    BoundaryPoints.kSortPoint = necrosis_points(BoundaryPoints.kSort,:);
                   % BoundaryPoints.kSortPoint = necrosis_points;
                    
                    
                    
                    
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
            %%ASSIGNS the Necrosis Volume and Diameteter
            if ii == 1
                    baseline__nec_vol = [baseline__nec_vol; necrosis_volume] ;
                    baseline_diams = [baseline_diams;xyz_diameters];    
            end 
        xyz_diameters = [];    
        end 
end 
    
    

% Exporting 
Data as CSV
%Exporting Data as CSV Volume
export_ALL_liver_vol = [string(name), arrhenius_thresh', ( baseline__nec_vol./1000 )]';
%Exporting Data as CSV DIAMETERS
export_All_liver_diams = [ string(name) , arrhenius_thresh', 0; baseline_diams];
%%%All Liver fat Diameters and Volumes 
all_liver_diameters = [all_liver_diameters, export_All_liver_diams];
all_liver_volumes = [all_liver_volumes, export_ALL_liver_vol];


%Exporting Volume Data as CSV 
%Exporting Volume Data as CSV 
all_liver_diameters  =array2table(all_liver_diameters);
all_liver_volumes = array2table(all_liver_volumes);
BoundaryPointsALL =  BoundaryPoints.all; 
%
end

%%%SECTION OF THE CODE THAT FITS AND ELLIPSE
radiiAll = [0,0,0];
radiiAll2 = [0,0,0];
VolumeLeft = [];
VolumeRight = [];


%splitInHalfx = "T";
splitInHalfXleft = "T";
plot_ellipse = "FALSE";

