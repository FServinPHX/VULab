

function [BoundaryPointsALL, all_liver_volumes, all_liver_diameters,all_liver_diameters2] = calculateArrhVolDiamEllipBound(file_path,splitInHalf,splitInHalfx, arrhenius_thresh )

% splitInHalf = "F";
% splitInHalfx = "T";
% arrhenius_thresh = .98;
% file_path = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\BoxGeomPhantom_TrueBeefAblation_SingleAblation60W.csv"


[filepath,name,ext] = fileparts(file_path);    
%
for patient_selection = 1:1
    all_liver_volumes = [];
    all_liver_diameters = [];
    all_liver_diameters2 = [];
    %read all of the dicom names
    patient_choice = ["Individual"];
    %current_file_name = join([names(all_filenames).folder,'\', names(all_filenames).name]);
   baseline_data = readtable(file_path);
    %
    coordinates = baseline_data(:,1:3);
    temp_and_arrhenius = baseline_data(:,4:end);
    baseline_temp_array = [];
    baseline_arrhenius_array = [];
    
    BoundaryPoints.all = zeros(8000, 20*4*3);
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
    %arrhenius_thresh = [100];
    baseline__nec_vol = [];
    baseline__nec_vol_points = [];
    homogenous_nec_vol = [];
    homogenous_nec_vol_points = [];
    baseline_diams = [];
    homogenous_diams = [];
    xyz_diameters = [];
    %  TIME 
    %time = ([0:.25:15]);
    time = ([0:.25:20]);
    
    
    %arrhenius_thresh = [.98];
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




if plot_ellipse == "TRUE"
for i = 15*4+1 : 15*4+1
    BoundaryPoints.curr = BoundaryPoints.all(2:end, ((i-1)*3+1):((i-1)*3+3) );
    BoundaryPoints.curr(BoundaryPoints.curr == 0) = NaN;

    %Plotting Function
%     subplot(1,2,1)
%     scatter3(BoundaryPoints.curr(:,1),BoundaryPoints.curr(:,2),...
%        BoundaryPoints.curr(:,3))
%     axis equal
%     view( -70, 40 );
%     title( join(["Ablation Boundary", newline, "Time = ",time(i) ,"(s)" ]) )
%     
%     hold on
    
%end 
%
    x = rmmissing(BoundaryPoints.curr(:,1));
    y = rmmissing(BoundaryPoints.curr(:,2));
    z = rmmissing(BoundaryPoints.curr(:,3)) ;

    
%Remove NAN
%

[ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
radii1 = radii;

    if i == (15*4+1)
        figure()
        Ablation.p =  PlotEllispe(x, y, z);
        hold on 
        set( Ablation.p , 'FaceColor', 'g','FaceAlpha',.2, 'EdgeColor', 'none' );
        plot3(x,y,z, '.k', 'MarkerSize',10)

        title(join([  "X_d = ",num2str( round(radii(3)*2,0)) ,...
          "mm   |   ","Y_d = ", num2str(round(radii(1)*2,0) ),...
          "mm   |   ", "Z_d = ", num2str(round(radii(2)*2,0) ),"mm" ]) )
        xlabel("X")
        ylabel("Y")
        zlabel("Z")
        axis equal
    end 

%HALF PLOT | ALPHA SHAPE
% shpAll = alphaShape(x,y,z, radii1(1) );



% plot3(center(1), center(2), center(3),'.r', 'MarkerSize',20 )
% 
% hold off
% 
% pause(.15)

    if strcmp(splitInHalf,"T")
        BoundaryPoints.largeEllipse = [];
        excluded = 0;
        for j = 1:length(BoundaryPoints.curr)
            %If the points are larger than 
            if  BoundaryPoints.curr(j,2) > center(2)
                BoundaryPoints.largeEllipse = [BoundaryPoints.largeEllipse;...
                    BoundaryPoints.curr(j,:)];
            else 
                excluded = excluded + 1;
            end
        end
        BoundaryPoints.curr  =  BoundaryPoints.largeEllipse;

        x = (BoundaryPoints.curr(:,1));
        y = (BoundaryPoints.curr(:,2));
        z = (BoundaryPoints.curr(:,3)) ;

        [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
        radii2 = radii;
        pause(.5)
        
        %
        if i == (15*4+1)
            figure()
            Ablation.p =  PlotEllispe(x, y, z);
            hold on 
            set( Ablation.p , 'FaceColor', 'g','FaceAlpha',.2, 'EdgeColor', 'none' );
            plot3(x,y,z, '.k', 'MarkerSize',10)
            
            title(join([  "X_d = ",num2str( round(radii2(3)*2,0)) ,...
              "mm   |   ","Y_d = ", num2str(round(radii1(1)*2,0) ),...
              "mm   |   ", "Z_d = ", num2str(round(radii2(2)*2,0) ),"mm" ]) )
            xlabel("X")
            ylabel("Y")
            zlabel("Z")
            axis equal
        end 
        
    else
        
        
        
    end 

    %
%     plot3(x,y,z, '.')
%     hold on 
%     plot3(center(1), center(2), center(3),'.r', 'MarkerSize',20 )
    %
    
    
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
                        %remove the Nan Data
            BoundaryPoints.largeEllipseRight = ....
                rmmissing(BoundaryPoints.largeEllipseRight);
            
            x = (BoundaryPoints.largeEllipseRight(:,1));
            y = (BoundaryPoints.largeEllipseRight(:,2));
            z = (BoundaryPoints.largeEllipseRight(:,3)) ;
            
            
            
            %HALF PLOT | ALPHA SHAPE RIGHT SIDE
%             %subplot(1,2,1)
%             scatter3(x ,y, z, 'r')    
%             hold on
%             shpRight = alphaShape(x,y,z, radii1(1) );
%             plot(shpRight)
%             axis equal
%             %view( -70, 40 );
%             %title( join(["Ablation Boundary", newline, "Time = ",time(i) ,"(s)" ]) )
%             hold on

            
        [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
        radii2 = radii;
        disp(radii2)
            
            %Fit an ellipse the left side of the data
%             %remove the Nan Data

%             BoundaryPoints.largeEllipseLeft = ....
%                 rmmissing(BoundaryPoints.largeEllipseLeft);
%             %
%             x = (BoundaryPoints.largeEllipseLeft(:,1));
%             y = ( BoundaryPoints.largeEllipseLeft(:,2));
%             z = (BoundaryPoints.largeEllipseLeft(:,3)) ;
%                   
    
            %HALF PLOT | ALPHA SHAPE LEFT SIDE
           if i == 15*4+1
            
                figure()
                scatter3(x ,y, z, 'b')  
                hold on 
                Ablation.p2 =  PlotEllispe(x, y, z);
                set( Ablation.p2 , 'FaceColor', 'b','FaceAlpha',.25, 'EdgeColor', 'none' );

                axis equal
    %             shpleft = alphaShape(x,y,z, radii1(1) );
    %             plot(shpleft
                view( -80, 10 );
                title(join([  "X_d = ",num2str( round(radii2(3)*2,0)) ,...
                  "mm   |   ","Y_d = ", num2str(round(radii1(1)*2,0) ),...
                  "mm   |   ", "Z_d = ", num2str(round(radii2(2)*2,0) ),"mm" ]) ) 
                hold off
                set(gcf,'color','w');
                pause(.1)

           end 

                [ center, radiinew, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );
                radii3 = radiinew;
                disp(radii3)
            
            
            
            
    end 


    %radiiAll = [radiiAll; [time(i), radii'] ];
    %radiiAll = [radiiAll;  radii' ];
    %%IF you decide to split the data half in x and y.     
    if strcmp(splitInHalf,"T")
        radiiAll = [radiiAll; [ radii1(1)',radii2(2:3)' ] ];
    else 
        radiiAll = [radiiAll;  radii1' ];
    end 
    %%%
    
   
    if strcmp(splitInHalfXleft,"T") && strcmp(splitInHalfx,"T")
        radiiAll2 = [radiiAll2; [radii(1)',radii3(2:3)' ] ]; 

%         VolumeLeft = [ VolumeLeft, volume(shpleft)/1000  ];
%         VolumeRight = [ VolumeLeft, volume(shpRight)/1000 ];


    end 
    
    if strcmp(splitInHalfXleft,"F") && strcmp(splitInHalfx,"T")
        radiiAll2 = [radiiAll2; [radii(1)',radii3(2:3)' ] ]; 


    end     
    


end

BoundaryRadii = "T";
if strcmp(BoundaryRadii,"T")
    %Exporting Data as CSV DIAMETERS
    export_All_liver_diams = [ string(name) , arrhenius_thresh', 0; radiiAll.*2];
    %%%All Liver fat Diameters and Volumes 
    
    all_liver_diameters  = array2table(export_All_liver_diams);
    
    if strcmp(splitInHalfXleft,"T")
        export_All_liver_diams2 = [ string(name) , arrhenius_thresh', 0; radiiAll2*2];
        all_liver_diameters2  = array2table(export_All_liver_diams2);
        
%         AblationVolumeLeft = [string(name), arrhenius_thresh', VolumeLeft ]';
%         AblationVolumeLeft = array2table(all_liver_volumes);
%         
%         AblationVolumeRight = [string(name), arrhenius_thresh', VolumeRight ]';
%         AblationVolumeRight = array2table(all_liver_volumes);
        
        %%Export the ablationVolume of the left and right side of the probe
        %exportRightAblationVolume = [string(name); arrhenius_thresh'];
          
        %exportLeftAblationVolume = [string(name); arrhenius_thresh'];
    else 
       %%all_liver_diameters2 = [];
    end 
    
    
end 
end 



end 
