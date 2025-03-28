


function [ distances, Points_To_Volume, Volume ]   = Aim3_SPIEfn_Ablation_and_Probes_toRegGrid( ProbePointExport, plotedLine1, plotedLine2, Ablation, time   )




  Spacing = 2;
  [ Points_To_Volume, intensity.X , intensity.Y , intensity.Z ]  = Aim3_RegGridVolume_Export(  Spacing ) ;

  %[ProbePointExport, plotedLine1, plotedLine2 ] =  A3_FindPlotPoints(file_path);
     % scatter3(ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3), ...
     %                            150, '.', 'k');
     % axis equal
    % 
    %
    QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
        %TargetPoints = SmoothedAblationTimePoints{i} ;
        TargetPoints = Ablation ;
        TargetCenter = mean(TargetPoints);
        %TargetPoints = TargetPoints; %+ (mean(QuerryPointsOG ) - TargetCenter);
        %
        %
        AllProbes = ProbePointExport; % + (mean(QuerryPointsOG ) - TargetCenter);
        TargetCenterIn = mean(TargetPoints);
        %
        ProbeMidpoints =  ProbeTargetsLineUp_CGBT(  plotedLine1, plotedLine2 ) ;
        %
        %
        %filtered_probe_midpoints = filter_probePoints(   TargetPoints,   ProbeMidpoints  );
        filtered_probe =  filter_probePoints(   TargetPoints,   ProbePointExport  );
        AllProbesIN =  [ filtered_probe  ];


        [ distances ] = SDAVectorTargetFusedAblation_CombinedProbe_CGBT( TargetPoints , QuerryPointsOG,...
                                                        AllProbesIN ) ;
        
                 % Call the function
        midpoint = [mean(  AllProbesIN  )]  +  [0, 0,  max( AllProbesIN(:, 3)).* 75   ] ; 
        new_intensities = A3_Filter_NewIntensities_CGBT( [QuerryPointsOG, distances]  , midpoint)  ;
        distances = new_intensities;



    B = [QuerryPointsOG, distances];
    %
    negative_distances = distances(distances < 0);
    Lower_threshold_value = prctile(negative_distances, 10)
    InsideLimit = -1 * Lower_threshold_value;
    OutsideLimit = -0.5;        
    %
    [filtered_point_exp] = filter_AblationFixedGridPoints(Ablation, B, InsideLimit, OutsideLimit);



    Ablation_Center = mean( Ablation );
    z_Threshold = 20 + 50*( time/59)   ;
    specificPoint = [ Ablation_Center(1), Ablation_Center(2), z_Threshold] ;
    intensityThreshold = mean(negative_distances) ;
    radius = 6 + 4*(i/20);
    if radius > 10
        radius = 10;
    end 
    pointsFinal = filterIntensityPoints(filtered_point_exp, specificPoint, intensityThreshold, radius);





    distances = pointsFinal(:,4);
    distancesIn = distances;
    distancesIn(distancesIn > 0) = nan;
    %distancesIn(distancesIn < -10) = nan;
    [filtered_coords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, distancesIn);
    Volume = round( (Points_To_Volume*length(filtered_coords))/1000, 2); 

    
    plotfunction = "FALSE";
    if plotfunction == "TRUE"

        set(gcf,'color','w');                
            %Find the triangulation of the Interogation Boundary Points 
            plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3), ...
                        '.', 'Color', rgb('Black'),...
                'MarkerSize', 10)  
            hold on 
    
                    % Probe1in = ProbePointExport( 1:100, :);
                    % Probe2in = ProbePointExport( 101:200, :);
                    % %
                    % plot3( Probe1in(:,1), Probe1in(:,2), Probe1in(:,3), ...
                    %         'k.', 'MarkerSize', 10)  
                    % plot3( Probe2in(:,1), Probe2in(:,2), Probe2in(:,3), ...
                    %         'k.', 'MarkerSize', 10 )
                     % plot3( ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3), ...
                     %         'k.', 'MarkerSize', 25 )    
                     plot3( AllProbesIN(:,1), AllProbesIN(:,2), AllProbesIN(:,3), ...
                             'k.', 'MarkerSize', 25 )        
           P = filtered_coords;
           % filtered_intensities = distances;
            scatter3( P(:,1) , P(:,2) ,P(:,3), 10,  filtered_intensities, 'filled' ) 
                colormap jet
                cb=colorbar;
                cb.FontSize = 18;
                title(cb, join(["SDA_{T-A}", newline, "(mm)"]) );
                    currentPosition = cb.Position;
                % Modify the height to be half of the original by changing the 4th element
                % of the position vector. Also, adjust the bottom position to center the colorbar.
                newHeight = currentPosition(4) / 1.5; % New height is half of the original
                newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
                cb.Position = [currentPosition(1) newBottom currentPosition(3) newHeight];
                %         title(hc,'mm', 'FontSize', 20);
                title( join([ "Exp. ", newline, "Vol = ", Volume, 'cm^{3}']), 'Fontsize', 30)
                C=caxis;
                axis equal



    end 


    end 
