clear
close all



pause(1)


% AllModels = ["915 Mhz Tumor Naive", "915 Mhz Digital Twin",...
%     "2450 Mhz Tumor Naive" , "2450 Mhz Digital Twin"];
ModelRun = [ "2450 Mhz Digital Twin" ] ;
Process = "Kmeans";
%  TRUE    FALSE
PlotTumorSDA = "TRUE";
PlotDicom = "FALSE";
PlotTumorSDATA = "FALSE";

figure(1)
plotLiver = "TRUE";
PlotAblation = "FALSE";
grayColor = [.7 .7 .7];
plotColor  = rgb("Gray");




stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Liver Mesh.stl");
LiverMeshpoints = stlData.Points;
LiverCenter = mean(LiverMeshpoints,1) ;

if plotLiver == "TRUE"
    LiverData.Points = stlData.Points + [0, 9.5 , 0];
    LiverData.ConnectivityList = stlData.ConnectivityList ; 
    LiverDataT =  triangulation(  LiverData.ConnectivityList, LiverData.Points );
    trimesh(LiverDataT ,'FaceColor','none','EdgeColor',rgb("Sienna"),'EdgeAlpha', .25 )
    % plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3),.1 ,'.k' )
    title(join(['Surgical Plan Example']), 'FontSize', 14)
    %axis square;
    hold on
end 

HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_hepatic_60pReduced.stl");
VasculatureMeshData.HepaticVeinPoints = HepaticVeinData.Points; 
if plotLiver == "TRUE"
    
    trimesh(HepaticVeinData,'FaceColor','b', 'FaceAlpha', .35...
        ,'EdgeColor','b','EdgeAlpha', .35 )
    

end 

PortalVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_portal_80pReduced.stl");
VasculatureMeshData.PortalVeinPoints = PortalVeinData.Points; 
if plotLiver == "TRUE"
    trimesh(PortalVeinData,'FaceColor',rgb('Crimson'),'FaceAlpha', .35...
        ,'EdgeColor', rgb('Crimson') ,'EdgeAlpha', .65 )
end 



VasculatureMeshData.AllPoints = [VasculatureMeshData.HepaticVeinPoints ;...
    VasculatureMeshData.PortalVeinPoints];
set(gcf,'color',plotColor );
set(gca,'color',plotColor );
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
axis vis3d equal;
axis off
grid off
hold on
view(-250,20)





 
%%Create the tumor
ProbeNum = 2;
TumorNum = 1;

% TumorColors = [ rgb("Tan"); rgb("SlateGray"); rgb("Salmon"); rgb("Fuchsia")  ] ;
TumorColors = [ rgb("Tan"); rgb("Peru"); rgb("Salmon"); rgb("Fuchsia") ];

for i = 1:TumorNum

% X,Y,Z - Split | 1,2,3
    switch i
        case 1
%             Split = 3;
            %tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Vanderbilt_017_Tumor_remeshed.stl";
            tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Scout_Tumor_Export.stl";


        case 2
%             Split = 3;
            %tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\Patient_009_Vanderbilt\Segmentation_Tumor 2.stl";
            tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Scout_Tumor_Export.stl";

    end 
    
    
TumorData = stlread(tumorfile);
TumorPoints.Points = TumorData.Points;
VasculatureMeshData.TumorData = TumorPoints.Points; 

%Create a PDE Mesh Model
TumorPoints.model = createpde;
importGeometry( TumorPoints.model  , tumorfile);
TumorPoints.mesh = generateMesh( TumorPoints.model );

%Split the tumor into two sections along the x axis. 
trueCenter = [221, 260, 182];
TumorPoints.Points  = rotateZalongPoint(TumorPoints.Points , 90 , trueCenter ) ; 
 

TumorPoints.centerOne = mean(TumorPoints.Points);

TumorData = delaunayTriangulation( TumorPoints.Points(:,1)  , TumorPoints.Points(:,2)...
                          , TumorPoints.Points(:,3));

tetramesh(TumorData,'FaceColor','none','EdgeColor', TumorColors(i,:) ,'EdgeAlpha', .5 )

TumorPoints.Lower  = [];
TumorPoints.Upper = [];
TumorPoints.LowerX = [];
TumorPoints.UpperX = [];
TumorPoints.LowerY = [];
TumorPoints.UpperY = [];
TumorPoints.LowerZ = [];
TumorPoints.UpperZ = [];


TumorPoints.idx = kmeans(TumorPoints.Points, ProbeNum);


% figure(2) 
% 
%     X = TumorPoints.Points;
%     idx = TumorPoints.idx;
%     scatter3(X(:,1), X(:,2), X(:,3), 15, idx, 'filled', 'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);% 3 number of classes
%     set(gcf,'color',plotColor );
%     set(gca,'color',plotColor );
%     xlabel('X', 'FontSize', 14);
%     ylabel('Y', 'FontSize', 14);
%     zlabel('Z', 'FontSize', 14);
%     title("Kmeans Cluster")
%     axis vis3d equal;
%     axis off
%     grid off
%     hold on
%     view(-250,20)
% 
% 
% figure(3) 
% 
%     X = TumorPoints.Points;
%     TumorPoints.idxCluster = kmedoids(TumorPoints.Points, ProbeNum, 'Distance','cityblock');
%     idx2 = TumorPoints.idxCluster;
%     scatter3(X(:,1), X(:,2), X(:,3), 15, idx2, 'filled', 'MarkerFaceAlpha',.1,'MarkerEdgeAlpha',.1);% 3 number of classes
%     set(gcf,'color',plotColor );
%     set(gca,'color',plotColor );
%     xlabel('X', 'FontSize', 14);
%     ylabel('Y', 'FontSize', 14);
%     zlabel('Z', 'FontSize', 14);
%     title("ClusterAlg Cluster")
%     axis vis3d equal;
% %     axis off
% %     grid off
%     hold on
%     view(-250,20)


% TumorPoints.idx = TumorPoints.idxCluster;

figure(1) 

    TumorPoints.LowerIdx = find( TumorPoints.idx ==1) ;
    TumorPoints.Lower = mean( TumorPoints.Points(TumorPoints.LowerIdx, :) );

    TumorPoints.MiddleIdx = find( TumorPoints.idx ==2) ;
    TumorPoints.Middle = mean( TumorPoints.Points(TumorPoints.MiddleIdx, :) );

    TumorPoints.UpperIdx = find( TumorPoints.idx == 3) ;
    TumorPoints.Upper = mean( TumorPoints.Points(TumorPoints.UpperIdx, :) );

    TumorPoints.Upper2Idx = find( TumorPoints.idx == 4) ;
    TumorPoints.Upper2 = mean( TumorPoints.Points(TumorPoints.Upper2Idx, :) );


if ProbeNum == 2

    
    if Process == "Average"
        for ipts = 1:length(TumorPoints.Points(:,1))

            scale = std(TumorPoints.Points) ;  
        %Process X mean
            if TumorPoints.Points(ipts,1) < TumorPoints.centerOne(1) - scale(1)
               TumorPoints.LowerX = [TumorPoints.LowerX; TumorPoints.Points(ipts,:) ] ; 

            elseif  TumorPoints.Points(ipts,1) > TumorPoints.centerOne(1) + scale(1)
               TumorPoints.UpperX = [TumorPoints.UpperX; TumorPoints.Points(ipts,:) ] ; 
            else 
                successRate.X = "Excluded"; 
            end 

        %Process Y mean
            if TumorPoints.Points(ipts,2) < TumorPoints.centerOne(2) - scale(2)
               TumorPoints.LowerY = [TumorPoints.LowerY; TumorPoints.Points(ipts,:) ] ; 

            elseif  TumorPoints.Points(ipts,2) > TumorPoints.centerOne(2)  + scale(2)
               TumorPoints.UpperY = [TumorPoints.UpperY; TumorPoints.Points(ipts,:) ] ; 
            else 
               successRate.Y = "Excluded";
            end 

        %Process Z mean    
            if TumorPoints.Points(ipts,3) < TumorPoints.centerOne(3) -  scale(3)
               TumorPoints.LowerZ = [TumorPoints.LowerZ; TumorPoints.Points(ipts,:) ] ; 

            elseif TumorPoints.Points(ipts,3) > TumorPoints.centerOne(3)  + scale(3)
               TumorPoints.UpperZ = [TumorPoints.UpperZ; TumorPoints.Points(ipts,:) ] ; 
            else 
               successRate.Y = "Excluded";
            end 

        %Process X,Y,Z means      
            TumorPoints.Lower = (mean(TumorPoints.LowerX) +...
                                mean(TumorPoints.LowerY) + mean(TumorPoints.LowerZ))/3 ;
            TumorPoints.Upper = ( mean(TumorPoints.UpperX) +  ...
                                mean(TumorPoints.UpperY) +  mean(TumorPoints.UpperZ))/3 ;
        end 
    end 

        
        if Process == "Kmeans"
            %%For Kmeans Algorithm
            TumorPoints.LowerIdx = find( TumorPoints.idx == 1) ;
            TumorPoints.Lower = mean( TumorPoints.Points(TumorPoints.LowerIdx, :) );

            TumorPoints.UpperIdx = find( TumorPoints.idx == 2) ;
            TumorPoints.Upper = mean( TumorPoints.Points(TumorPoints.UpperIdx, :) );
            
            disp("KMEANS")
        end 
   
 
end 






%Create a placement strategy for the two halves of the tumor
for iSplit = 1:ProbeNum
    switch iSplit 
        case 1
            TargetCentr = (TumorPoints.Lower) ; 
%               TargetCentr = TumorPoints.centerOne ; 
%               TargetCentr = [227, 256, 180];
             
        case 2 
            TargetCentr = (TumorPoints.Upper) ;
            
            if ProbeNum ==3 || ProbeNum == 4
                TargetCentr = (TumorPoints.Middle) ;
            end 

        case 3
            TargetCentr = (TumorPoints.Upper) ;

        case 4
            TargetCentr = (TumorPoints.Upper2) ;
    end 

   
    %psi, theta
    % psiAngle = [0 , 25, 320, 339];
    % thetaAngle = [270 , 270, 50, 68];
    
    %Each pair is for one probe orientation per tumor 
% for xyz = 1:4 
    
    
if ProbeNum == 1
 
     
%  ALlPlace = [ "A", "B", "C", "D" ] ;    
%  Placement = ALlPlace( xyz); 
 
%  switch  Placement
%  
%     case "A"
% 
%          psiAngle = [90+80 , 0 ];
%          thetaAngle = [90-25 , 0 ];
%          
%          ChangePsiAngle = [-15, 0];
%          ChangeThetaAngle = [0, 0];  
%          
%          psiAngle = psiAngle + ChangePsiAngle;
%          thetaAngle = thetaAngle + ChangeThetaAngle;
%          
%          patient = 1;
%          
%          
%     case  "B"   
% 
%          psiAngle = [ (75+90) , 0 ];
%          thetaAngle = [90 , 0 ];  
%          
%          ChangePsiAngle = [10+3, 0];
%          ChangeThetaAngle = [0, 0];  
%          
%          psiAngle = psiAngle + ChangePsiAngle;
%          thetaAngle = thetaAngle + ChangeThetaAngle;
%          
%          patient = 2;
% 
%    case "C" 
% %         189.5
%         psiAngle = [ (112.5+90 - 8 - 5 ) , 0 ];
%         thetaAngle = [90-4 , 0 ];  
%         
%          ChangePsiAngle = [0, 0];
%          ChangeThetaAngle = [0, 0];  
%          
%          psiAngle = psiAngle + ChangePsiAngle;
%          thetaAngle = thetaAngle + ChangeThetaAngle;
%          
%         patient = 3;
%         
%     case "D"
% 
%         psiAngle = [100+90 , 0 ];
%         thetaAngle = [90+10 , 0 ]; 
%         
%          ChangePsiAngle = [0, 0];
%          ChangeThetaAngle = [0, 0];  
%          
%          psiAngle = psiAngle + ChangePsiAngle;
%          thetaAngle = thetaAngle + ChangeThetaAngle;
%          
%         patient = 4;
%  
%  end 


    
    elseif ProbeNum == 2
   
%         psiAngle = [  189.5  ,   189.5, 0  , 0];
%         thetaAngle = [86 , 86, 86, 86];

        psiAngle = [  120, 189.5   ];
        thetaAngle = [  80, 86   ];

% 	elseif ProbeNum == 3
%         psiAngle = [15 , 15, 15, -25, -25,  -25];
%         thetaAngle = [90 , 90, 90, 90, 90,  90];
% 
% 	elseif ProbeNum == 4
%         psiAngle = [15 , 15, 15, 15,  0, 0, -15,  -15];
%         thetaAngle = [90 , 90, 90, 90,  90, 90, 90,  90];
end 

    %Angle Spacing: spacing between probes = 360°/# probes 
    %e.g.   1 for single placement
    %e.g.   4 = 4 probes paced 
    NumTargets = linspace(0, 2*pi, 1 + 1 );
    
    AngleSpacing = 1 ;

    %Radius is the targeting radius of the placement strategy
    radiusSrt = 2 ; 
    %Safety margin is how far away the probe should be from the vasculature
    safetyMargin = 1;

    % if i < 3
    iSlct = (i-1)*2 + iSplit;
    
    disp([ "iSlct", iSlct])
    disp([ "psiAngle",  psiAngle(iSlct) ] )
    disp([ "thetaAngle", thetaAngle(iSlct)] )
   
    figure(1)
        [Arrange ] = CreatePlacementStrategy(NumTargets , psiAngle(iSlct) , thetaAngle(iSlct),...
            AngleSpacing,  TargetCentr , radiusSrt, VasculatureMeshData.AllPoints, safetyMargin);
     
    
    YPAngle = Arrange.YPAngle(end, 1:2);
    YP = YawPitch( YPAngle(1),  0 ); 

    
    %Visualize Ablation Margins
    %3rd value is Ablation for tumor
%     if ProbeNum == 2
%         radius = 35 /2;
%         long_axis = 40 /2;
% 
% 	elseif ProbeNum == 3
%         radius = 30 /2;
%         long_axis = 33 /2 ; 
% 
% 	elseif ProbeNum == 4
%         radius = 30 /2;
%         long_axis = 33 /2; 
%     end 

    radius = 40 /2;
    long_axis = 48 /2; 
    
    if PlotAblation == "TRUE"
    %Create an Ellipsoid Ablation    
        [X,Y,Z] = ellipsoid(TargetCentr(1) ,TargetCentr(2) ,TargetCentr(3) ,...
             long_axis ,radius,  long_axis );
        X = reshape(X,[],1);
        Y = reshape(Y,[],1);
        Z = reshape(Z,[],1);
        P = [X,  Y, Z ];


        C = [YP*P']' ; 
        P = C + TargetCentr - mean(C);

    %%Plot the Ablation
        faceAlpha = [.1, .1, .1 ,1, 1];
        [ablationNew.p1, ablationPoints.centerOne, ablationPoints.radiiOne, ablationNew.v]...
            = PlotEllispeNew( P(:,1) ,  P(:,2)   ,  P(:,3)  );
        set( ablationNew.p1 , 'FaceColor', 'r' ,'FaceAlpha', faceAlpha(i) , 'EdgeColor', 'r','EdgeAlpha',  faceAlpha(i)  );


        pause(1)
    end
    
    



    %( ProbePosition, Patient)
    % ProbePosition = 1 2 3 4 = [A, B, C, D];
    Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"];    
    % colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];
    colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("Salmon") ; rgb("Indigo")];
    patient_All = [4,4];
    patient = patient_All(iSplit);
    
    psiAngleOG = [190 ];
    thetaAngleOG = [100 ]; 
    
    for pj = 5:5

    selectfile = convertStringsToChars(Patient(pj));     
    % ModelRun = [ "915 Mhz Digital Twin" ] ;
    switch ModelRun

        %%% 915 Mhz Tumor Naive Models
        case  "915 Mhz Tumor Naive"
            fileName = SelectAblationBoundaryPointsNoTumor( patient , selectfile ) ;    
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive';
            SdtMap = SelectVandyMapSDA( 2);
            SDATAMap = SelectVandyMapSDA(5);
            maxColorBar = -10;
            minColorBar = 10; 
            maxColorBar2 = -5;
            minColorBar2 = 35; 
        %%% 915 Mhz Digital Twin Models    
        case "915 Mhz Digital Twin"
            fileName = SelectAblationBoundaryPoints( patient , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin';
            SdtMap = SelectVandyMapSDA( 2);
            SDATAMap = SelectVandyMapSDA(5);
            maxColorBar = -10;
            minColorBar = 10; 
            maxColorBar2 = -5;
            minColorBar2 = 35; 
        %%% 2450 Mhz Tumor Naive Models
        case "2450 Mhz Tumor Naive"   
            %fileName = SelectAblationBoundaryPoints2450mhzNoTumor( position , selectfile ) ;
            fileName = SelectAblationBoundaryPts2450mhzNoTumorV2( patient , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2';
            SdtMap = SelectVandyMapSDA( 1);
            SDATAMap = SelectVandyMapSDA( 2);
            maxColorBar = -5;
            minColorBar = 5;   
            maxColorBar2 = -10;
            minColorBar2 = 10; 
        %%% 2450 Mhz Digital Twin Models
        case "2450 Mhz Digital Twin"
            fileName = SelectAblationBoundaryPoints2450mhzV2( patient , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2';
            SdtMap =  SelectVandyMapSDA( 1);
            SDATAMap =  SelectVandyMapSDA( 2);
            maxColorBar = -5;
            minColorBar = 5; 
            maxColorBar2 = -10;
            minColorBar2 = 10;  
    end    

            BoundaryPoints = readtable(fileName);
            BoundaryPointsMatrix =  table2array(BoundaryPoints(:,:));

            time = [0:.25:15];   
            timex = time; 
            spacing = 15*4;  
            angle = 20;
            timespacing = 1;
            colors = turbo( (ceil(spacing/timespacing))  );

            % set(gcf,'color',rgb('White'));
            set(gca,'FontSize',14)
        for iB = 15*4:15*4 %15-3 : 4 :15*4

            X = BoundaryPointsMatrix(2:end, ((iB-1)*3 + 1) );
            X(X == 0) = [];
            Y = BoundaryPointsMatrix(2:end, ((iB-1)*3 + 2) );
            Y(Y == 0) = [];
            Z = BoundaryPointsMatrix(2:end, ((iB-1)*3 + 3) );
            Z(Z == 0) = [];
            Y = Y +3;
    
            %AblationCenter = mean([X,Y,Z]); 
            AblationCenter = ((Arrange.text(1,:) + TargetCentr)/2 + TargetCentr*4 )/5 ; 

            %rearrange the points            C
            ChangePsiAngle = -[ psiAngleOG-psiAngle(iSlct) ];
            ChangeThetaAngle = [ thetaAngleOG-thetaAngle(iSlct) ];
            psiAngleA =  ChangePsiAngle;
            thetaAngleA = ChangeThetaAngle;
            YP =  YawPitch(psiAngleA, thetaAngleA); 
            Rc = [X ,Y ,Z]';
            C = [YP*Rc]';

            newCenter = AblationCenter - mean(C);
            X2 = C(:,1) + newCenter(1);
            Y2 = C(:,2) + newCenter(2);
            Z2 = C(:,3) + newCenter(3);


            figure(1)
            [k, vol] = boundary([X2,Y2,Z2] , .3 );
            hold on
    %         trisurf(k, X , Y , Z ,'Facecolor',colors(i,:)  ,'FaceAlpha',.1 )
            trisurf(k, X2 , Y2 , Z2 ,'Facecolor', colors2(pj,:)  ,'FaceAlpha',.5 ,...
                'EdgeColor', colors2(pj,:)  )
            hold on 
            %plot3( X, Y, Z, '.', 'MarkerSize', 5, 'Color',  colors(i,:) )
            %plot3( X, Y, Z, '.', 'MarkerSize', 5, 'Color',  colors2(pj,:) )
        end

    end

    set(gcf,'color',plotColor );
    set(gca,'color',plotColor );
    xlabel('X', 'FontSize', 14);
    ylabel('Y', 'FontSize', 14);
    zlabel('Z', 'FontSize', 14);
    axis vis3d equal;
    axis off
    grid off
    hold off
    
    
    %Find the Singed DistanceToAgreement
    figure(2)
    subplot(2,1,iSplit )
    itime = 60;
    AblationPoints = [X2 , Y2 , Z2];
    %Find the Intersection of the ablation and the tumor
    [returnData, BndPtsin, BndPtsout, Expt, STumor ] = ...
        AblationIntersectionTri( TumorPoints.Points ,TumorPoints.mesh  ,  ...
        AblationPoints , itime , colors2(pj ,:), TumorColors(i,:)  ) ; 
    view(-75, 0)
    
    %Using the data from the previous fucntion, calculate the signed
    %distance to agreement
    
    [distances, distancesTumor  ] = SDAcomputeTumor(BndPtsin, TumorPoints.Points, BndPtsout,...
                    Expt.TumPointsIn, AblationPoints ,Expt.TumPointOut );
                
    
   if PlotTumorSDA == "TRUE"
        % PLOT THE RESULTS
        
        %figure( (pj)*2  )
        figure(3)
        subplot(2,1,iSplit )
        set(gcf,'color','w');                
        newmap = brighten(SdtMap,.15);

        shift =  mean(TumorData.Points) - trueCenter ; 
        Xsct = [ Expt.TumPointsIn(:,1) ; Expt.TumPointOut(:,1) ]+ shift(1); 
        Ysct = [ Expt.TumPointsIn(:,2) ; Expt.TumPointOut(:,2) ]+ shift(2);
        Zsct = [ Expt.TumPointsIn(:,3) ; Expt.TumPointOut(:,3) ]+ shift(3);
        S = 100;
        C2 = distancesTumor;
        disp( [min(C2),max(C2)] )
     
        %Find the triangulation of the Interogation Boundary Points 
            P = [Xsct,Ysct,Zsct];
            P2 = TumorData.Points;
            k = boundary(P, .45);
            k2 = boundary(P2, .8);                
                
%         k = boundary(P, .8);
%         DT1 = delaunayTriangulation(P);
%         [k,v] = convexHull(DT1) ;     
        
        C2New = [];
        for triK  = 1:length(k)
            
            C2c   = [ C2(k(triK,1)), C2(k(triK,2)), C2(k(triK,3)) ];
            C2New = [C2New; mean(C2c) ];
            
        end        
%         scatter3(Xsct,Ysct,Zsct,S,C2, 'filled') 
        pt = trisurf( k ,Xsct,Ysct,Zsct, C2New, 'EdgeColor',...
                      rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha',1 );
                  
%         pt = trisurf( STumor.faces , P2(:,1) , P2(:,2) , P2(:,3),  C2, 'EdgeColor',...
%                       rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha',.9 );                
        colormap(newmap)
        hc=colorbar;
        hc.FontSize = 20;
        title(hc,'mm', 'FontSize', 15);
        title( 'SDA_{T-A}')
        C=caxis;
        caxis([maxColorBar , minColorBar ])
        axis equal
        grid off
        axis off 
        view(-75, 0)
        hold off
    end 
    

    if PlotTumorSDATA == "TRUE"
        % PLOT THE RESULTS      
        %figure( (pj)*2  )
        figure(4)
        subplot(1,2,iSplit )
        
        p1 = plot( STumor.complete   ,'FaceColor',   TumorColors(i,:)   ,'FaceAlpha', 0.8 ,...
        'EdgeColor',  TumorColors(i,:)  , 'EdgeAlpha', 0.5 );
        p1.Annotation.LegendInformation.IconDisplayStyle = 'off';
        hold on 
        
        set(gcf,'color','w');                
        newmap = brighten(SDATAMap ,.15);

        shift =  mean(TumorData.Points) - trueCenter ; 
        Xsct = [ BndPtsin(:,1) ; BndPtsout(:,1) ] ; 
        Ysct = [ BndPtsin(:,2) ; BndPtsout(:,2) ]   ;
        Zsct = [ BndPtsin(:,3) ; BndPtsout(:,3) ] ;
        S = 100;
        C2 = distances;
%         C2(C2 < 1.65) = -1;
        disp( [min(C2),max(C2)] )

        P = [Xsct,Ysct,Zsct];  
        %Find the triangulation of the Interogation Boundary Points 
         k = boundary(P, .8);
%         DT1 = delaunayTriangulation(P);
%         [k,v] = convexHull(DT1) ;          

        %Find the  SDA of the triangle elmenent by calculating the average
        %SDA value of the three vertecies
        C2New = [];
        for triK  = 1:length(k)
            
            C2c   = [ C2(k(triK,1)), C2(k(triK,2)), C2(k(triK,3)) ];
            C2New = [C2New; mean(C2c) ];
            
        end 
        pt = trisurf( k ,Xsct,Ysct,Zsct, C2New, 'EdgeColor',...
                      rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha',.85 );
        colormap(newmap)
        hc=colorbar;
        hc.FontSize = 15;
        title(hc,'mm', 'FontSize', 12);
        title( 'SDA_{T-A}')
        C=caxis;
        caxis([maxColorBar2 , minColorBar2 ])
        axis equal
        grid off
        axis off 
        view(-75, 0)
        hold off
        
    end 
        
    
end 

end 



figure(1)
view(290,-5)
x0=500;
y0=250;
width=650;
height=600;
set(gcf,'position',[x0,y0,width,height])
set(gca,'Position',get(gca,'OuterPosition'));


figure(2), figure(3)
set(gca,'Position',get(gca,'OuterPosition'));

