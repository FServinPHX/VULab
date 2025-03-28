


function [ distances ]   = SPIE_Ablation_and_Probes_toRegGrid( ProbePointExport, plotedLine1, plotedLine2, Ablation   )




  Spacing = 2;
  [ Points_To_Volume, intensity.X , intensity.Y , intensity.Z, ]  = Aim3_RegGridVolume_Export(  Spacing )

  %[ProbePointExport, plotedLine1, plotedLine2 ] =  A3_FindPlotPoints(file_path);
     % scatter3(ProbePointExport(:,1), ProbePointExport(:,2), ProbePointExport(:,3), ...
     %                            150, '.', 'k');
     % axis equal
    % 
    %
    QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
        %TargetPoints = SmoothedAblationTimePoints{i} ;
        TargetPoints = points ;
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
        filtered_probe_midpoints = filter_probePoints(   TargetPoints,   ProbeMidpoints  );
        filtered_probe =  filter_probePoints(   TargetPoints,   ProbePointExport  );
        AllProbesIN =  [ filtered_probe  ];


        [ distances ] = SDAVectorTargetFusedAblation_CombinedProbe_CGBT( TargetPoints , QuerryPointsOG,...
                                                        AllProbesIN ) ;
        
                 % Call the function
        midpoint = [mean(  AllProbesIN  )]  +  [0, 0,  max( AllProbesIN(:, 3)).* 75   ] ; 
        new_intensities = A3_Filter_NewIntensities_CGBT( [QuerryPointsOG, distances]  , midpoint)  ;
        distances = new_intensities;



    B = [QuerryPointsOG, distances];
    Ablation = chunkData(:, 1:3);
    Ablation = points(2:end, :);    
    %
    negative_distances = distances(distances < 0);
    Lower_threshold_value = prctile(negative_distances, 10)
    InsideLimit = -1 * Lower_threshold_value;
    OutsideLimit = -0.5;        
    %
    [filtered_point_exp] = filter_AblationFixedGridPoints(Ablation, B, InsideLimit, OutsideLimit);



    Ablation_Center = mean(chunkData(:, 1:3));
    z_Threshold = 20 + 50*(i/59)   ;
    specificPoint = [ Ablation_Center(1), Ablation_Center(2), z_Threshold] ;
    intensityThreshold = mean(negative_distances) ;
    radius = 6 + 4*(i/20);
    if radius > 10
        radius = 10;
    end 
    pointsFinal = filterIntensityPoints(filtered_point_exp, specificPoint, intensityThreshold, radius);





    distances = pointsFinal(:,4);
    distances(distances < .5) == [];
    
    volume = length(distrances).*Points_To_Volume; 



    end 
