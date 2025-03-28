%Load Data
clear 
close all
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'

%  TRUE    FALSE
PlotTumorSDA = "FALSE";   %  TRUE
PlotDicom = "FALSE";     %  FALSE
PlotTumorSDATA = "FALSE"; %  TRUE



PortalVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_portal_80pReduced.stl");
VasculatureMeshData.PortalVeinPoints = PortalVeinData.Points; 
HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_hepatic_60pReduced.stl");
VasculatureMeshData.HepaticVeinPoints = HepaticVeinData.Points; 
VasculatureMeshData.AllPoints = [VasculatureMeshData.HepaticVeinPoints ;...
    VasculatureMeshData.PortalVeinPoints];


%Load in the tumor data
% tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Vanderbilt_017_Tumor_remeshed.stl";
tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Scout_Tumor_Export.stl";
TumorData = stlread(tumorfile);
TumorPoints.Points = TumorData.Points;
[~,TumorVolume] = boundary(TumorPoints.Points);
disp(TumorVolume/1000)


%Create a PDE Mesh Model
TumorPoints.model = createpde;
importGeometry( TumorPoints.model  , tumorfile);
TumorPoints.mesh = generateMesh( TumorPoints.model );


%Split the tumor into two sections along the x axis. 
trueCenter = [220, 263, 182];
TumorPoints.Points  = rotateZalongPoint(TumorPoints.Points , 0 , trueCenter ) ; 
TumorPoints.centerOne = mean(TumorPoints.Points);
% 
% TumorData = delaunayTriangulation( TumorPoints.Points(:,1)  , TumorPoints.Points(:,2)...
%                           , TumorPoints.Points(:,3));
TumorData = delaunayTriangulation( TumorPoints.Points(:,1)  , TumorPoints.Points(:,2)...
                          , TumorPoints.Points(:,3));


%Load in the Colors
% TumorColors = [ rgb("Pink") ; rgb("ForestGreen") ; rgb("Tan") ; rgb("RoyalBlue") ];
TumorColors = [ rgb("Black") ; rgb("Black") ; rgb("Black") ; rgb("Black"); rgb("Black") ];

Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"];    
colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; ...
    rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];

% colors2 = [rgb("ForestGreen"); rgb("DarkOrange") ; ...
%     rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];

% colorTumor = [ rgb("Maroon") ; rgb("DarkOliveGreen") ; ...
%     rgb("SandyBrown") ; rgb("PowderBlue") ; rgb("BurlyWood")];

colorTumor = [ rgb("LightCoral") ; rgb("PaleGreen") ; ...
    rgb("Tan") ; rgb("PowderBlue") ; rgb("Goldenrod")];
% colorTumor = [rgb("Sienna"); rgb("Sienna"); rgb("Sienna"); rgb("Sienna"); rgb("Sienna")];

Vandy_map  = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Orange"); rgb("OrangeRed"); ...
            rgb("FireBrick");  rgb("Maroon")];   

Vandy_map2 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Orange"); rgb("OrangeRed"); ...
            rgb("FireBrick");  rgb("Maroon")]; 

Vandy_map3 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Peru");  rgb("Orange"); rgb("Orange"); rgb("OrangeRed");  rgb("OrangeRed"); ...
            rgb("FireBrick"); rgb("FireBrick"); rgb("Maroon"); rgb("Maroon")]; 
        
Vandy_map4 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Peru"); rgb("Orange"); rgb("Orange");...
             rgb("OrangeRed");  rgb("OrangeRed"); ...
            rgb("FireBrick"); rgb("FireBrick"); rgb("Maroon"); rgb("Maroon")]; 
        
             
Vandy_map5  = [  repmat(rgb("RoyalBlue"), 5,1) ;...
            repmat( rgb("BurlyWood"), 5,1) ;repmat( rgb("Peru"), 5,1) ;...
            repmat( rgb("Orange"), 5,1) ;repmat( rgb("DarkOrange"), 5,1);...
            repmat( rgb("OrangeRed"), 4, 1) ; repmat( rgb("FireBrick"), 5,1) ;...
            repmat( rgb("Maroon"), 5,1) ];   

        
Vandy_map6  = [ rgb("MidnightBlue"); rgb("Navy") ;rgb("DarkBlue"); rgb("MediumBlue");...
    rgb("RoyalBlue");rgb("DarkCyan"); rgb("SeaGreen");...
    rgb("LightSeaGreen"); rgb('DarkTurquoise'); rgb("SteelBlue") ;...
    rgb("Peru"); rgb("Chocolate"); rgb("Orange"); rgb("DarkOrange");...
    rgb("OrangeRed"); rgb("IndianRed"); rgb("Crimson"); rgb("FireBrick");  rgb("Maroon")];  


 ALlPlace = [ "A", "B", "C", "D", "E" ] ; 
 Upsample = "TRUE";
 numpoints = 4000;
%Seleect the probe orientation
for pn = 1:1
    
alldata.tumorVol = [];
alldata.tumorVolCurrent = []; 
D.all= [];
exportSignedToDistance = zeros(800,5);
position = pn; 


Placement = ALlPlace(pn);


 switch  Placement
 
    case "A"
            psiAngle = [90+80 , 0 ];
            thetaAngle = [90-25 , 0 ];
            ChangePsiAngle = [+2.5, 0];
            ChangeThetaAngle = [-2.5, 0];  

            psiAngle = psiAngle + ChangePsiAngle;
            thetaAngle = thetaAngle + ChangeThetaAngle;
            patient = 1;
         
         
    case  "B"   
             psiAngle = [ (75+90) , 0 ];
             thetaAngle = [90 , 0 ];  
             ChangePsiAngle = [5, 0];
             ChangeThetaAngle = [0, 0];  

             psiAngle = psiAngle + ChangePsiAngle;
             thetaAngle = thetaAngle + ChangeThetaAngle;
             patient = 2;

   case "C" 
            psiAngle = [ (112.5+90 - 8 - 5 ) , 0 ];
            thetaAngle = [90 , 0 ];  
            ChangePsiAngle = [+3, 0];
            ChangeThetaAngle = [-5, 0];  

            psiAngle = psiAngle + ChangePsiAngle;
            thetaAngle = thetaAngle + ChangeThetaAngle;
            patient = 3;
        
    case "D"
            psiAngle = [100+90 , 0 ];
            thetaAngle = [90+10 , 0 ]; 
            ChangePsiAngle = [4, 0];
            ChangeThetaAngle = [0, 0];  

            psiAngle = psiAngle + ChangePsiAngle;
            thetaAngle = thetaAngle + ChangeThetaAngle;
            patient = 4;
 end 

 
    AngleSpacing = 1 ;
    %Radius is the targeting radius of the placement strategy
    radiusSrt = 1 ; 
    %Safety margin is how far away the probe should be from the vasculature
    safetyMargin = 1;

    
    iSlct = 1; 
    psiAngle(iSlct) 
    thetaAngle(iSlct)
    TargetCentr = TumorPoints.centerOne;
    NumTargets = linspace(0, 2*pi, 1 + 1 );
    ProbeColor = TumorColors(pn,:);

    

%Slect the fat value 1:5 corresponds to ["Healthy";   "Low" ;  "Mild";  "Moderate"; "High"];    
for pj = 1:1 %5:5
    
    
selectfile = convertStringsToChars(Patient(pj)); 
ModelRun = [ "Multiprobe" ] ;

switch ModelRun
    
    %%% 915 Mhz Tumor Naive Models
    case  "915 Mhz Tumor Naive"
        fileName = SelectAblationBoundaryPointsNoTumor( position , selectfile ) ;    
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive';
        SdtMap = Vandy_map2;
        SDATAMap = Vandy_map5;
        maxColorBar = -10;
        minColorBar = 10; 
        maxColorBar2 = -5;
        minColorBar2 = 35; 
        
    %%% 915 Mhz Digital Twin Models    
    case "915 Mhz Digital Twin"
        fileName = SelectAblationBoundaryPoints( position , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin';
        SdtMap = Vandy_map2;
        SDATAMap = Vandy_map5;
        maxColorBar = -10;
        minColorBar = 10; 
        maxColorBar2 = -5;
        minColorBar2 = 35; 
        
        
     case "915 Mhz Digital Twin Box"
        fileName = SelectAblationBoundaryDTwin915Box( 2 , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Probe A Twin Box';
        SdtMap = Vandy_map;
        SDATAMap = Vandy_map2;
        maxColorBar = -5;
        minColorBar = 5; 
        maxColorBar2 = -10;
        minColorBar2 = 10; 
        
        
    %%% 2450 Mhz Tumor Naive Models
    case "2450 Mhz Tumor Naive"   
        %fileName = SelectAblationBoundaryPoints2450mhzNoTumor( position , selectfile ) ;
        fileName = SelectAblationBoundaryPts2450mhzNoTumorV2( position , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2';
        SdtMap = Vandy_map;
        SDATAMap = Vandy_map4;
        maxColorBar = -5;
        minColorBar = 5;   
        maxColorBar2 = -5;
        minColorBar2 = 15; 
        
    %%% 2450 Mhz Digital Twin Models
    case "2450 Mhz Digital Twin"
        fileName = SelectAblationBoundaryPoints2450mhzV2( position , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2';
        SdtMap = Vandy_map;
        SDATAMap = Vandy_map2;
        maxColorBar = -5;
        minColorBar = 5; 
        maxColorBar2 = -10;
        minColorBar2 = 10;       
        
    case "2450 Mhz Digital Twin Box"
        fileName = SelectAblationBoundaryDTwin2450Box( 1 , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2';
        SdtMap = Vandy_map;
        SDATAMap = Vandy_map2;
        maxColorBar = -5;
        minColorBar = 5; 
        maxColorBar2 = -10;
        minColorBar2 = 10;    
        
    case "Vascular Tree"
        fileName = SelectAblationBoundary915VascularTree( 1 , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2';
        SdtMap = Vandy_map;
        SDATAMap = Vandy_map2;
        maxColorBar = -5;
        minColorBar = 5; 
        maxColorBar2 = -10;
        minColorBar2 = 10;     
        
    case "Multiprobe"
        %fileName = SelectAblationBoundary915Multiprobe( 1 , selectfile ) ;
        fileName = SelectAblationBoundary915Multiprobe( 1 , convertStringsToChars(Patient(2)) ) ;
        resultsDir = 'D:\Import To Matlab\Box Phantom\MultiprobeRefined\Patient 05 Multiprobe';
        SdtMap = Vandy_map;
        SDATAMap = Vandy_map2;
        maxColorBar = -5;
        minColorBar = 5; 
        maxColorBar2 = -10;
        minColorBar2 = 10;            
        
        
end 







BoundaryPoints.og = readtable(fileName);
BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:));

%  idx = 4:4:15*4;
%   idx = 15*4:15*4;
  idx = 15*4:15*4;
 
%     f_a = @(i) 3*(i-1) + 1;
%     f_b = @(i) 3*(i-1) + 3;
%     a = f_a(pj);
%     b = f_b(pj);

%     alldata.tumorVolCurrent = [pj, string(selectfile), 0, 0]; 
    alldata.tumorVolCurrent = [string(selectfile), position , pj]; 
    D.allC = [string(selectfile); string(fileName); position ];
    
   
    for j = 1:length(idx)

        itime = idx(j);

        X = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 1) );
        X(X == 0) = [];
        Y = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 2) );
        Y(Y == 0) = [];
        Z = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 3) );
        Z(Z == 0) = [];
        Y = Y +3;
        
        
        BoundaryPoints.new = [X,Y,Z];
       
       %----------------------------------------------------------------------------------%     
       if Upsample == "TRUE"  
            NewPoints = [BoundaryPoints.new];
            AllData1 = [BoundaryPoints.new];
            
            if size(AllData1,1) < numpoints
                [ AllData1 ] = UpsampledAblationSpec( NewPoints, numpoints ) ;
                disp("Upsampled") 
                
                %--------------------------------------------------------------%
                if size(AllData1,1) < numpoints
                    while size(AllData1,1) < numpoints
                        [ AllData1 ] = UpsampledAblationSpec( AllData1, numpoints ) ;
                        disp("Upsampled II") 
                    end 
                end 
            end 
                
            if  size(AllData1,1) > numpoints
                [ AllData1 ] = DownsampleAblationSpec( NewPoints, numpoints ) ;
                 disp("Downsample") 
            else
                disp("Best Sample")   
            end
            
            BoundaryPoints.new = AllData1;
       end      
       %----------------------------------------------------------------------------------%          
        
        
        r = 20;
%         [ NewPoints ] = UpsampleAblation( BoundaryPoints.new, 1.5 );
%         BoundaryPoints.new = NewPoints;

%         figure()
%         plot3( NewPoints(:,1), NewPoints(:,2), NewPoints(:,3), '.' )        
%         figure( (pj-1)*2 +1 )
%         figure( (pj) )

%generate quick figures
        figure()

        [returnData, BndPtsin, BndPtsout, Expt, STumor ] = ...
            AblationIntersectionTri( TumorPoints.Points ,TumorPoints.mesh  ,  ...
            BoundaryPoints.new , itime , colors2(pj ,:), colorTumor(position ,:)  ) ; 
        %
        plot3( BoundaryPoints.new(:,1),  BoundaryPoints.new(:,2),  BoundaryPoints.new(:,3), '.')
        
       
%         ProbeLength = 50;
%         [Arrange ] = CreatePlacementStrategyPaper2(NumTargets , psiAngle(iSlct) ,...
%                         thetaAngle(iSlct), AngleSpacing,  TargetCentr , radiusSrt,...
%                         VasculatureMeshData.AllPoints, safetyMargin, ProbeColor, ProbeLength);
        view(-10, 0)
        
        
        
%         figure()
%         plot3( BndPtsin(:,1) , BndPtsin(:,2), BndPtsin(:,3), '.r')
%         hold on 
%         plot3( BndPtsout (:,1), BndPtsout (:,2), BndPtsout (:,3), '.b')
  
        if j == length(idx)

            % Calculate the signed distance to agreement between the two point clouds
            %signed distance to agreement between All Ablation points
            %inside the tumor
            x1 = BndPtsin(:,1);
            y1 = BndPtsin(:,2);
            z1 = BndPtsin(:,3);

            x2 = TumorPoints.Points(:,1);
            y2 = TumorPoints.Points(:,2);
            z2 = TumorPoints.Points(:,3);
%           %outde the tumor
      
            distances = [];
           
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2)).*-1;
                distances=[ distances,dist] ;
            end
            
            x1 = BndPtsout(:,1);
            y1 = BndPtsout(:,2);
            z1 = BndPtsout(:,3);            
            
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2));
                 distances=[ distances,dist] ;
            end
            
            
            %%SDA TUMOR!!!
            % Calculate the signed distance to agreement between the two point clouds
            %signed distance to agreement between All Ablation points
            %inside the tumor
            x1 = Expt.TumPointsIn(:,1);
            y1 = Expt.TumPointsIn(:,2);
            z1 = Expt.TumPointsIn(:,3);

            x2 = X;
            y2 = Y;
            z2 = Z;
%           %outde the tumor
      
            distancesTumor = [];
           
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2)).*-1;
                distancesTumor=[ distancesTumor,dist] ;
            end
            
            x1 =  Expt.TumPointOut(:,1);
            y1 =  Expt.TumPointOut(:,2);
            z1 =  Expt.TumPointOut(:,3);            
            
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2));
                 distancesTumor=[ distancesTumor,dist] ;
            end         
        end 
        alldata.tumorVolCurrent = [ alldata.tumorVolCurrent ;returnData.All(1, 1:3) ];
    end 
    
    
    alldata.tumorVol = [alldata.tumorVol, alldata.tumorVolCurrent ]; 
    
    exportSignedToDistance( 1:(length(distances)+3) ,pj) =  [string(selectfile);...
        string(fileName);  position; distances' ];
    
    
    if PlotDicom == "TRUE"
        hold on 
        cd ' C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt'
        start = 1;
        %%If the patient is either 003 or 004
        names = '1017_FF.nii.gz';  
        rotateData = "T";
        flipData = "T";
        angle = 90;  
        division = 1; 
        tool = niftiinfo(names) ;


        %current_image = dicomread(names(i).name);
        currentImage = niftiread(names);
        %ROTATE DATA
         if strcmp(rotateData,"T")
            currentImage = imrotate(currentImage, angle);
            disp("images are rotated")
         end 
         %FLIP DATA
         if strcmp(flipData,"T")
            currentImage = flip(currentImage, 1);
            disp("images are flipped")
         end 
        I = currentImage./division;
        figure(1)
        
        scale = [tool.PixelDimensions(1),tool.PixelDimensions(2),tool.PixelDimensions(3)];
        
        z = round( (trueCenter(3)./scale(3)), 0);
        
        for j = z-5:z+5
            img = (I(:,:,j)) ;
            img(img >100) = 100;
            img(img<0) = 0;
        

            %[119.032897949219,369.778106689453,129.036392211914,320.061614990234,51.1875991821289,239.699401855469];
            ximg = [ 1, tool.ImageSize(1).*scale(1) ; 1,  tool.ImageSize(1).*scale(1)  ]-15;
            yimg = [ 1, 1; tool.ImageSize(2).*scale(2) ,  tool.ImageSize(2).*scale(2)  ];

    %         ximg = [ 119, 369; 119, 369  ];
    %         yimg = [ 129, 129; 320, 320  ];
            zimg = j.*scale(3);

            xImage = [ ximg(1) ximg(2) ; ximg(1) ximg(2)];   %# The x data for the image corners
            yImage = [ yimg(1) yimg(2) ; yimg(1) yimg(2)];   %# The y data for the image corners
            zImage = [zimg zimg; zimg  zimg];   %# The z data for the image corners
            surf(ximg,yimg,zImage,...    %# Plot the surface
             'CData',img,...
             'FaceColor','texturemap', 'FaceAlpha', .05);
            colormap jet
        
        end 
        cd ' C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Liver Project - Ablation - 2021' 
        
        hold off
        
    end 
    
    
    
    
    if PlotTumorSDA == "TRUE"
        % PLOT THE RESULTS
        %figure( (pj)*2  )
        figure()
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
        [Arrange ] = CreatePlacementStrategyPaper2(NumTargets , psiAngle(iSlct) , thetaAngle(iSlct),...
        AngleSpacing,  TargetCentr , radiusSrt, VasculatureMeshData.AllPoints, safetyMargin, ProbeColor, 50);
   
        colormap(newmap)
        hc=colorbar;
        hc.FontSize = 25;
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
        % figure( (pj)*2  )
        figure()
        
        p1 = plot( STumor.complete   ,'FaceColor',  colorTumor(position ,:)  ,'FaceAlpha', 0.8 ,...
        'EdgeColor', colorTumor(position ,:) , 'EdgeAlpha', 0.5 );
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
                  
        [Arrange ] = CreatePlacementStrategyPaper2(NumTargets , psiAngle(iSlct) , thetaAngle(iSlct),...
        AngleSpacing,  TargetCentr , radiusSrt, VasculatureMeshData.AllPoints, safetyMargin, ProbeColor);
    
        colormap(newmap)
        hc=colorbar;
        hc.FontSize = 25;
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

pause(1)
end



gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"]; 
colors = [green; blue; orange; gold; purple];
% alldata.tumorVol = alldata.tumorVol;
%%%Change the fontsize of the matlab oode
% S = settings();
% S.matlab.fonts.codefont.Size.TemporaryValue = 10;  % fontsize (points)
% alldata.plottumorVol = double( alldata.tumorVol(2:end, : )); 

set(0,'defaultAxesFontSize',14)


%%
for k = 1:5
    
    en = 3;
    
    fa = @(i) en*(i-1) + 1;
    fb = @(i) en*(i-1) + 2;
    fc = @(i) en*(i-1) + 3;
    fd = @(i) en*(i-1) + 4;
    
    
    figure(6)
    set(gcf,'color','w');
    plot(idx./4, alldata.plottumorVol( 1:length(idx) , fa(k) ), '--o', 'Color', colors(k,:), 'LineWidth', 3)
    hold on
    
    figure(7)
    set(gcf,'color','w');
    plot(idx./4, alldata.plottumorVol( 1:length(idx), fb(k) ), '--o', 'Color', colors(k,:),  'LineWidth', 3 )
    hold on
    
    figure(8)
    set(gcf,'color','w');
    plot(idx./4, alldata.plottumorVol( 1:length(idx), fc(k) ), '--o', 'Color', colors(k,:),  'LineWidth', 3 )
    hold on
    
    figure(9) 
    set(gcf,'color','w');
    fig4data =  alldata.plottumorVol( 1:length(idx), fc(k)) ./ alldata.plottumorVol( 1:length(idx) , fa(k)) ; 
    plot(idx./4, fig4data , '--o', 'Color', colors(k,:),  'LineWidth', 3 )
    hold on
%     legend(["Tumor Volume", "Tumor Left", "Volume Ablated"])

%     fig10 = figure(10) ;
%     set(gcf,'color','w');
%     fig5data =  alldata.plottumorVol( 1:length(idx), fc(k)) ./ alldata.plottumorVol( 1:length(idx) , fd(k)) ; 
%     plot(idx./4, fig5data , '--o', 'Color', colors(k,:),  'LineWidth', 2 ) 
%     hold on    
%     
%     pause(2)
end 

figure(6)

legend(Patient, 'Location', 'best')
title("Original Tumor Size")
xlabel("Time (min)")
ylabel("Volume cm^3")

figure(7)

legend(Patient, 'Location', 'best')
title("Tumor Remnant")
xlabel("Time (min)")
ylabel("Volume cm^3")

figure(8)

legend(Patient, 'Location', 'best')
title("Ablated Tissue")
xlabel("Time (min)")
ylabel("Volume cm^3") 

figure(9)

legend(Patient, 'Location', 'best')
title("Trajectory of Percent of Tissue Ablated")
xlabel("Time (min)")
ylabel("Volume Ablated PPV") 


% figure(10)
% set( fig10, 'defaultLegendAutoUpdate', 'off');
% legend(Patient, 'Location', 'best')
% % fig5data.Annotation.LegendInformation.IconDisplayStyle = 'off';
% 
% yline(.5)
% yline(1)
% ylim([.25 1.1])
% str = {'Greater Collcateral', 'Greater Tumor Ablated'} ;
% text( [.25, .25], [.45, .55],  str )
% title(" Tumor Ablated / Collateral Ablation")
% xlabel("Time (min)")
% ylabel(" 1 ") 





% disp(resultsDir)
% 
exportBoundaryTitle = fullfile(resultsDir, join(["Ablation Tumor Intersection Position", position, ".csv"]) );
exportSignedDistance = fullfile(resultsDir, join(["Signed Distance to Agreement Position", position, ".csv"]) );

%           Write the file

writematrix(  alldata.tumorVol ,...
    exportBoundaryTitle)

writematrix(  exportSignedToDistance  ,...
    exportSignedDistance)









%%

close all
clear
legendString = [];

for select = 1:2 
    
    
if select ==1     
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\Volume and Diameter\915 Tumor Naive'
elseif select == 2
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\Volume and Diameter\915 Digital Twin'
end 
    


lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
names = dir('*.csv');

fi = @(i) 4*(i-1) + 3;

for allFilenames = 1:length(names)
    currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
    volumeData = readtable(currentFileName);
    volDataMod = volumeData{:,:};

    healthyLiverVolume = [healthyLiverVolume, volDataMod(:, fi(1) )  ];
    lowFatVolume = [lowFatVolume, volDataMod(:, fi(2) ) ];
    mildFatVolume = [mildFatVolume, volDataMod(:, fi(3)) ];
    moderateFatVolume = [moderateFatVolume, volDataMod(:,  fi(4)  ) ];
    highFatVolume = [highFatVolume, volDataMod(:,  fi(5)  ) ];

end 
%Find the mean and stadard deviation of all of the runs
meanVolumeMatrix = [ mean(healthyLiverVolume,2) , mean(lowFatVolume,2),...
        mean(mildFatVolume,2), mean(moderateFatVolume,2), mean(highFatVolume,2)];
stdev_vol_matrix = [std(healthyLiverVolume,0,2), std(lowFatVolume,0,2),...
        std(mildFatVolume,0,2), std(moderateFatVolume,0,2), std(highFatVolume,0,2)];
    
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Liver Project - Ablation - 2021'
   
    
%   
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple];


if select == 1
    Fillcolors = [green; blue; orange; gold; purple];
elseif select ==  2
    Fillcolors = [ rgb('PaleGreen');  rgb('SkyBlue');  rgb('Tomato');...
        rgb('Khaki');  rgb('MediumPurple')];
end 

% Fillcolors = [ green; orange; blue; gold]; 
  



%legend_base = ["No Fat", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
% titleName = join([ "Ablated Tumor in Patient 017",newline "Temperature Dependent Models", newline, "915 MHz Silva"]);
titleName = join([ "Ablated Tumor Trajectory" ]) ;
legendBase = [ "Healthy", "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];
TumorType = ["DT", "TN" ];
set(gcf,'color','w');

trapz_matrix=  [];
choiceInt = 1 ;
linestyle = ["-","-."];
lineChoice = linestyle(choiceInt);


for i = 1:1 %width(meanVolumeMatrix) %width(meanVolumeMatrix) : -1 : 1 %4:4 %width(meanVolumeMatrix) : -1 : 1
    %time = ([0:.25:15]); %.*45.*60./1000;   
    time = ([1:1:15]);
    selectColor = repmat([1 2 3 4 5],1,5);
%Set the figure parameters
        set(0, 'DefaultLineLineWidth', 2.5);
        
        
        p = plot(time, (meanVolumeMatrix(2:end,i)) ) ;
        p.LineStyle = lineChoice;
        p.Color = colors(i,:);
        hold on
        
%         yline( 3, '--' )
%         yline( 4.25, '--', '4.25'   )
        
        %%Add Standard Deviation to the plot
        set(gcf,'defaultLegendAutoUpdate','off')
        p2 = plot( time, ( meanVolumeMatrix(2:end,i) + stdev_vol_matrix(2:end,i) ) );
        p2.LineStyle = "--";
        p2.Color = 'k';
        p2.LineWidth = .5;
        p2.Annotation.LegendInformation.IconDisplayStyle = 'off';
        
        
        set(groot,'defaultLegendAutoUpdate','off')
        p3 = plot( time, ( meanVolumeMatrix(2:end,i) - stdev_vol_matrix(2:end,i) ) );
        p3.LineStyle = "--";
        p3.Color = 'k';
        p3.LineWidth = .5;
        p3.Annotation.LegendInformation.IconDisplayStyle = 'off';
%         
%         
        legendString = [legendString, join([ legendBase(i) ])]; 
        %   Comparative Ablation
        
        
        
    %%% Fill in between Data 
        bottom_curve = ( meanVolumeMatrix(2:end,i) - stdev_vol_matrix(2:end,i) );
        top_curve = ( meanVolumeMatrix(2:end,i) + stdev_vol_matrix(2:end,i) )
        curve1 = bottom_curve'; 
        curve2 = top_curve';
        x2 = [(time) , fliplr(time) ] ; %[time, fliplr(time) ];
        inBetween =  [(curve1) , fliplr(curve2)];
        h = fill(x2, inBetween,  Fillcolors(i,:) ); 
        set(h,'facealpha',.5)
        trap_val = trapz(time ,curve1- curve2);
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        hold on
        
%         trapz_matrix = [trapz_matrix, trapz(x,curve1-curve2)];        

        
        
        
        
%         if i  == width(meanVolumeMatrix)
%             top_curve = (meanVolumeMatrix(2:end,i))';
%         end 
%         if i  == 1
%             bottom_curve = (meanVolumeMatrix(2:end,i))';
%         end 

% pause(3)
end 
%         finalVolume = [finalVolume, meanVolumeMatrix(end,:)];
        %final_sd = [final_sd, stdev_vol_matrix(end,:)];
        
        xPoints = [20, 20, 35, 35]/ ( 45.*60./1000 );  
        yPoints = [0, meanVolumeMatrix(end,4) + 1,...
            meanVolumeMatrix(end, 4) + 1, 0];
        color = [.84, .8, .2];
        hold on;
%         if choiceInt < 2
%             a = fill(xPoints, yPoints, color);
%             a.FaceAlpha = 0.1; 
%         end 
%         set(gcf,'position',[80,80,800,600])  
   
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Liver Project - Ablation - 2021'




%%% Fill in between Data     
%     curve1 = bottom_curve; 
%     curve2 = top_curve;
%     x2 = [(time) , fliplr(time) ] ; %[time, fliplr(time) ];
%     inBetween =  [(curve1) , fliplr(curve2)];
%     h = fill(x2, inBetween,  Fillcolors(choiceInt,:) ); 
%     set(h,'facealpha',.5)
%     trap_val = trapz(time ,curve1- curve2);
%     hold on
%     
%     trapz_matrix = [trapz_matrix, trapz(x,curve1-curve2)];


    %PLOT information
    legend(legendString, 'Location', 'best')
    ylim([0 meanVolumeMatrix(end,4) + 1.5 ])
    ylabel("Ablated Tumor cm^3")
    xlabel("Time (min)")
    %title("Ablation Trajectory in All Dense Fat Sphere Models")
    title(titleName)
        legend('AutoUpdate', 'off')
%         yline(9)
%         text(2,9.25,'9')
%         yline(10)
%         text(2,10.25,'10')       
%         yline(11)
%         text(2,11.25,'11')
%         xlim([0 40])
%         text(2,12.25,'12')
%         xlim([0 40])
    %title("Ablation Trajectory in Homogenous vs Heterogenous")
    set(gca,'FontSize',16)
    plotFigureName = join([titleName,'.png' ]);






end 


%%


%Create table of ablated volumes per run
close all
clear
legendString = [];

modelNum = 6;

ModelRunAll = ["915 Mhz Tumor Naive", "915 Mhz Digital Twin",...
            "2450 Mhz Tumor Naive", "2450 Mhz Digital Twin", ...
            "2450 Mhz Digital Twin V2", "2.45 GHz Tumor Naive V2"  ] ;
        
ModelRun = ModelRunAll(modelNum); 
switch ModelRun
    
    %%% 915 Mhz Tumor Naive Models
    case  "915 Mhz Tumor Naive"
        cd 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive'

            
    %%% 915 Mhz Digital Twin Models    
    case "915 Mhz Digital Twin"
        cd 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin';

        
    %%% 2450 Mhz Tumor Naive Models
    case "2450 Mhz Tumor Naive"   
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive';
  
        
    %%% 2450 Mhz Digital Twin Models
    case "2450 Mhz Digital Twin"
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin'
        meanVol = [ 3.89, 4.28, 4.57, 4.88, 5.12 ];
        sdVol = [0.19, 0.47, 0.64, 0.71, 0.6];         
        
    case "2450 Mhz Digital Twin V2"
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2'

        
    case "2.45 GHz Tumor Naive V2"
        cd 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2'

end 
    
 
 


lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
Table=  [];
names = dir('*.csv');

fi = @(i) 3*(i-1) + 3;

for allFilenames = 1:length(names)
    
    currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
    volumeData = readtable(currentFileName);
    volDataMod = volumeData{:,:};

    healthyLiverVolume = [healthyLiverVolume, volDataMod(:, fi(1) )  ];
    lowFatVolume = [lowFatVolume, volDataMod(:, fi(2) ) ];
    mildFatVolume = [mildFatVolume, volDataMod(:, fi(3)) ];
    moderateFatVolume = [moderateFatVolume, volDataMod(:,  fi(4)  ) ];
    highFatVolume = [highFatVolume, volDataMod(:,  fi(5)  ) ];
    
    
    
    Table = [ Table; volDataMod(end, fi(1)), volDataMod(end, fi(2)),...
       volDataMod(end, fi(3)), volDataMod(end, fi(4)), volDataMod(end, fi(5)) ]; 

end 

 Table  = round( Table , 2);
 
 cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Liver Project - Ablation - 2021'
 
 %%
 
 
 
 cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\Volume and Diameter\915 Tumor Naive\SignDist'
    


lowFatVolume = [];
mildFatVolume = [];
moderateFatVolume = [];
highFatVolume = [];
healthyLiverVolume = [];
Table=  [];
names = dir('*.csv');

% fi = @(i) 3*(i-1) + 3;

fi = @(i) i+0;

for allFilenames = 1:length(names)
    
    currentFileName = join([names(allFilenames).folder,'\', names(allFilenames).name]);
    volumeData = readtable(currentFileName);
    volDataMod = volumeData{:,:};

    healthyLiverVolume = [healthyLiverVolume, volDataMod(:, fi(1) )  ];
    lowFatVolume = [lowFatVolume, volDataMod(:, fi(2) ) ];
    mildFatVolume = [mildFatVolume, volDataMod(:, fi(3)) ];
    moderateFatVolume = [moderateFatVolume, volDataMod(:,  fi(4)  ) ];
    highFatVolume = [highFatVolume, volDataMod(:,  fi(5)  ) ];
    
    
    
    Table = [ Table; mean(healthyLiverVolume(:)), mean(lowFatVolume(:)), mean(mildFatVolume(:)),...
        mean(moderateFatVolume(:)), mean(highFatVolume(:)), mean(volDataMod(:)) ]; 

end 

 Table  = round( Table , 2);
 
 Table = Table./ max(Table);

