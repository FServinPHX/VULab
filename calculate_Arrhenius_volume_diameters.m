

%%%function [all_liver_volumes,all_liver_diameters] = calculateArrheniusVolumeDiameters(file_path)
%%%
clear
%cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent'
target_directory = 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation';
codeDirectory =  'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021';


cd(target_directory)
names = dir('*.csv');
pause(1)
cd(codeDirectory)

%[2,3,4,1]
%[4,2,3,1]
order = [1,2,3,4,5];
i = 1;
CI = find(order == (i));
file_path = fullfile(names(CI).folder , names(CI).name);
%%[liverVolumes,liverDiameters] = calculateArrheniusVolumeAndDiametersTemp(filePath);
   
[filepath,name,ext] = fileparts(file_path);    
%

shrinkNumber = 0:.1:1 ; 
zeros(1, 4*length(shrinkNumber))
radiiAll = [0,0,0,0,0];
radiiAll2 = [0,0,0,0,0];


%for shrinkInd = 1:length(shrinkNumber)
shrinkInd = 1;
tic     
    
for patient_selection = 1:length(names)
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
                    
                    k = boundary(necrosis_points, shrinkNumber(shrinkInd)  );
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
all_liver_diameters  =array2table(all_liver_diameters);
all_liver_volumes = array2table(all_liver_volumes);
%


AllBoundaryPoints = array2table(BoundaryPoints.all);

volumeDirectory = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\";
diameterDirectory = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\";
% volName = 'volumeA98Ellipse.csv';
% diamName = 'diametersA98Ellipse.csv';
BoundName = join([ names(patient_selection).name(1:end-4), 'AllBoundaryPoints.txt']);

%create a method to independently export the volume and diameter models 
% exportAllLiverTitleDiam = join([diameterDirectory,name,diamName]);
% exportAllLiverTitleVol = join([volumeDirectory,name,volName]);
exportAllBoundaryPoints = join([diameterDirectory,BoundName]);

% writetable( liverDiameters, exportAllLiverTitleDiam);
% writetable( liverVolumes, exportAllLiverTitleVol);

%ExportBoundaryPoints to the target directory
cd(target_directory)
writetable( AllBoundaryPoints, BoundName);

cd(codeDirectory)

end
toc
%%
%set(gcf,'color','w')
% shrinkNumber = 0:.1:1 ; 
% zeros(1, 4*length(shrinkNumber))
% radiiAll = [0,0,0,0];
% radiiAll2 = [0,0,0,0];
splitInHalfY = "T";

splitInHalfx = "F";
splitInHalfXleft = "F";

for i = 2:1:15*4+1
    BoundaryPoints.curr = BoundaryPoints.all(2:end, ((i-1)*3+1):((i-1)*3+3) );
    BoundaryPoints.curr(BoundaryPoints.curr == 0) = NaN;

    %%Plotting Function
%     figure(1)
%     set(gcf,'color','w');
%     %subplot(1,2,1)
%     scatter3(BoundaryPoints.curr(:,1),BoundaryPoints.curr(:,2),...
%        BoundaryPoints.curr(:,3),10, 'filled', 'r')
%     axis equal
%     view( -70, 40 );
%     title( join(["Ablation Boundary", newline, "Time = ",time(i) ,"(s)" ]) )
    
    %hold on
x = rmmissing(BoundaryPoints.curr(:,1));
y = rmmissing(BoundaryPoints.curr(:,2));
z = rmmissing(BoundaryPoints.curr(:,3)) ;
%Remove NAN
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
radii1 = radii;



%Split the data in the Y direction
    if strcmp(splitInHalfY,"T")
        BoundaryPoints.largeEllipseTop = [];
        BoundaryPoints.largeEllipseBottom = [];
        excluded = 0;
        for j = 1:length(BoundaryPoints.curr)
            %If the points are larger than 
            if  BoundaryPoints.curr(j,2) > center(2)
                BoundaryPoints.largeEllipseTop = [BoundaryPoints.largeEllipseTop;...
                    BoundaryPoints.curr(j,:)];
            else 
                BoundaryPoints.largeEllipseBottom = [BoundaryPoints.largeEllipseBottom;...
                    BoundaryPoints.curr(j,:)];
            end
        end
        BoundaryPoints.curr  =  BoundaryPoints.largeEllipseTop;
        %Assign X, Y, Z 
        x = (BoundaryPoints.curr(:,1));
        y = (BoundaryPoints.curr(:,2));
        z = (BoundaryPoints.curr(:,3)) ;
        [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
        radii2 = radii;
    end 

%Split the data in the X direction
    if strcmp(splitInHalfx,"T")
            BoundaryPoints.largeEllipseLeft = [];
            BoundaryPoints.largeEllipseRight = [];
            excluded = 0;
            for j = 1:length(BoundaryPoints.curr)
                %If the points are larger than 
                if  BoundaryPoints.curr(j,1) > center(1)
                    BoundaryPoints.largeEllipseRight = [BoundaryPoints.largeEllipseRight;...
                        BoundaryPoints.curr(j,:)];
                else 
                    BoundaryPoints.largeEllipseLeft = [BoundaryPoints.largeEllipseLeft;...
                        BoundaryPoints.curr(j,:)];
                end
            end
            BoundaryPoints.curr  =  BoundaryPoints.largeEllipseRight;
            %%%if you want to recover the X-axis left and right. 
            if strcmp(splitInHalfXleft,"T")
                BoundaryPoints.curr  =  BoundaryPoints.largeEllipseLeft;
            end 
            %Assign X, Y, Z to the right side of the data
            x = (BoundaryPoints.largeEllipseRight(:,1));
            y = (BoundaryPoints.largeEllipseRight(:,2));
            z = (BoundaryPoints.largeEllipseRight(:,3)) ;
            [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
            radii2 = radii;
            
            %Fit an ellipse the left side of the data
            x = (BoundaryPoints.largeEllipseLeft(:,1));
            y = ( BoundaryPoints.largeEllipseLeft(:,2));
            z = (BoundaryPoints.largeEllipseLeft(:,3)) ;
            [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
            radii3 = radii;
            
            
    end 
    
%%IF you decide to split the data half in x and y.     
if strcmp(splitInHalfY,"T")
    radiiAll = [radiiAll; [time(i), shrinkNumber(shrinkInd)  ,  radii1(1)',radii2(2:3)' ] ];
else 
    radiiAll = [radiiAll; [time(i), shrinkNumber(shrinkInd)  ,  radii1' ] ];
end 

if strcmp(splitInHalfXleft,"T")
    radiiAll2 = [radiiAll2; [time(i),shrinkNumber(shrinkInd), radii1(1)',radii3(2:3)' ] ]; 
end 

%
%
% fprintf( 'Ellipsoid center: %.5g %.5g %.5g\n', center );
% fprintf( 'Ellipsoid radii: %.5g %.5g %.5g\n', radii );
% fprintf( 'Ellipsoid evecs:\n' );
% fprintf( '%.5g %.5g %.5g\n%.5g %.5g %.5g\n%.5g %.5g %.5g\n', ...
%     evecs(1), evecs(2), evecs(3), evecs(4), evecs(5), evecs(6), evecs(7), evecs(8), evecs(9) );
% fprintf( 'Algebraic form:\n' );
% fprintf( '%.5g ', v );
% fprintf( '\nAverage deviation of the fit: %.5f\n', sqrt( chi2 / size( x, 1 ) ) );
% fprintf( '\n' );
% draw data

figure(2)
%subplot(1,2,2)
set(gcf,'color','w');
plot3( x, y, z, '.r','MarkerSize',20 );
xlabel("X")
ylabel("Y")
zlabel("Z")
radii = round(radii,2);
title(join(["Time = ",time(i),newline,  "X_r = ", num2str(radii(3)), "   |   ","Y_r = ", num2str(radii(1)),...
  "   |   ", "Z_r = ", num2str(radii(2)) ]) )
%hold on;
%draw fit
mind = min( [ x y z ] );
maxd = max( [ x y z ] );
nsteps = 50;
step = ( maxd - mind ) / nsteps;
[ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ),...
    linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ),...
    linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
          2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
          2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
p = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );
set( p, 'FaceColor', 'b', 'EdgeColor', 'none' );
view( -70, 40 );
axis vis3d equal;
grid on
camlight;
lighting phong;
set(gcf,'position',[180,280,400,600]) 
pause(.2)

end


%%

colors = [ 0, 0, 0; 75,0,130; 0,0,225; 0, 128, 128;  0,130,200;...  
    0,255,0; 210, 245, 60;  255,255,0;  255,127,0;
    255,0,0 ]./255;


increment = 1;
%Creates a new_multiprobe model
for dataSelect = 10:5:50
    
    BoundaryPoints.multiprobe = [];

    BoundaryPoints.multCenter = [];
    BoundaryPoints.multRadii = [];
    for moveZ = 1:4

        a = (dataSelect)*3+1;
        b = (dataSelect)*3+3;

        %find the location of the first zero number
        n=find(BoundaryPoints.all( :, a)==0);
        %display the first time that number appears
        n(1)
        %Selects all NONZERO DATA
        BoundaryPoints.synth = BoundaryPoints.all( 2:n(1)-1, a:b);

        %FIND THE RADIUS OF THE CURRENT DATASET TO FIND THE OPTIMAL PROBE
        %PLACEMENT
        x = BoundaryPoints.synth(:,1);
        y = BoundaryPoints.synth(:,2);
        z = BoundaryPoints.synth(:,3); 
        [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

        %TRANSFORMATION MATRIX
        tMat = [ ( radii(2)*(5/3.6) ),...
                0,...
                ( radii(2)*(5/3.7) ) ];
        %create a matrix to add to the original data points. Every case is a
        %new hypotherical probe
        switch moveZ
            case 1
              addMatrix = [0, 0, 0];
            case 2
              addMatrix = [0, 0, tMat(3)];
            case 3
              addMatrix = [tMat(1),0,tMat(3)];
            case 4
              addMatrix = [tMat(1), 0, 0];
        end 


        %Create symthetic data and adds the translation data
        BoundaryPoints.new = BoundaryPoints.synth+ addMatrix ; 
        %add the current synthetic data to a larger data
        BoundaryPoints.multiprobe = [ BoundaryPoints.multiprobe; BoundaryPoints.new ]; 

        x = BoundaryPoints.new(:,1);
        y = BoundaryPoints.new(:,2);
        z = BoundaryPoints.new(:,3); 
        [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

        figure(1)
        %subplot(1,2,2)
        set(gcf,'color','w');
        p3 = plot3( x, y, z, '.k','MarkerSize',5);
        alpha(p3,.2)
        xlabel("X")
        ylabel("Y")
        zlabel("Z")
        radii = round(radii,2);
        title(join(["Time = ",time(dataSelect),newline,  "X_r = ", num2str(radii(3)), "   |   ","Y_r = ", num2str(radii(1)),...
          "   |   ", "Z_r = ", num2str(radii(2)) ]) )
        %hold on;
        %draw fit
        mind = min( [ x y z ] );
        maxd = max( [ x y z ] );
        nsteps = 50;
        step = ( maxd - mind ) / nsteps;
        [ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ),...
            linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ),...
            linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
        Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
                  2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
                  2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
        p = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );
        set( p, 'FaceColor', colors(increment,:) ,'FaceAlpha',.2, 'EdgeColor', 'none' );
        view( -5, 10 );
        axis vis3d equal;
        grid on
        camlight;
        lighting phong;
        set(gcf,'position',[380,280,500,500]) 
        pause(.2)


        hold on

        BoundaryPoints.multCenter = [BoundaryPoints.multCenter; center' ] ;
        BoundaryPoints.multRadii = [BoundaryPoints.multRadii; radii' ];
    end 

    set(gcf,'color','w');
    %subplot(1,2,1)
    plot3(BoundaryPoints.multCenter(:,1),BoundaryPoints.multCenter(:,2),...
       BoundaryPoints.multCenter(:,3), '.r', 'MarkerSize',20)
    axis equal
    
    
    increment = increment + 1;
end 
%%
%Assigns the current set of datapoints
%
k = boundary(BoundaryPoints.multiprobe, .5  );
BoundaryPoints.k = reshape(k,[],1);
BoundaryPoints.kSort = unique(BoundaryPoints.k);
BoundaryPoints.kSortPoint = BoundaryPoints.multiprobe(BoundaryPoints.kSort,:); 
                                         
%
%%Plotting Function
figure(2)
% set(gcf,'color','w');
% %subplot(1,2,1)
% scatter3(BoundaryPoints.multiprobe(:,1),BoundaryPoints.multiprobe(:,2),...
%    BoundaryPoints.multiprobe(:,3),10, 'filled', 'r')
% axis equal

x = BoundaryPoints.kSortPoint(:,1);
y = BoundaryPoints.kSortPoint(:,2);
z = BoundaryPoints.kSortPoint(:,3); 
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
    
 set(gcf,'color','w');
    p3 = plot3( x, y, z, '.k','MarkerSize',10);
    alpha(p3,.2)
    xlabel("X")
    ylabel("Y")
    zlabel("Z")
    radii = round(radii,2);
    title(join(["Time = ",time(i),newline,  "X_r = ", num2str(radii(3)), "   |   ","Y_r = ", num2str(radii(1)),...
      "   |   ", "Z_r = ", num2str(radii(2)) ]) )
    %hold on;
    %draw fit
    mind = min( [ x y z ] );
    maxd = max( [ x y z ] );
    nsteps = 50;
    step = ( maxd - mind ) / nsteps;
    [ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ),...
        linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ),...
        linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
    Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
              2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
              2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
    p = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );
    set( p, 'FaceColor', 'b','FaceAlpha',.2, 'EdgeColor', 'none' );
    view( -20, 30 );
    axis vis3d equal;
    grid on
    camlight;
    lighting phong;
    set(gcf,'position',[880,280,400,600]) 
    pause(.2)
%%
    
    
    



