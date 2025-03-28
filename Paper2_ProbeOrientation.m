clear
close all


Placement = "A"; 
% AllModels = ["915 Mhz Tumor Naive", "915 Mhz Digital Twin",...
%     "2450 Mhz Tumor Naive" , "2450 Mhz Digital Twin"];
ModelRun = [ "2450 Mhz Digital Twin" ] ;




figure()
AxesH = axes;
InSet = get(AxesH, 'TightInset');
set(AxesH, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)])

plotRibs = "FALSE";
plotLiver = "TRUE";
PlotBareArea = "FALSE";
plotVasc = "TRUE"; 
PlotAblation = "FALSE";
Add_atlas = "FALSE";
iCreateVideo = "TRUE";
grayColor = [.7 .7 .7];
plotColor  = rgb("Gray");
% plotColor  = rgb("DarkGray");
% plotColor = [246, 249, 255]./255; 



    stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Liver Mesh.stl");
    LiverMeshpoints = stlData.Points;
    LiverCenter = mean(LiverMeshpoints,1) ;
    if plotLiver == "TRUE"
        LiverData.Points = stlData.Points + [0, 9.5 , 0];
        LiverData.ConnectivityList = stlData.ConnectivityList ; 
        LiverDataT =  triangulation(  LiverData.ConnectivityList, LiverData.Points );
        %trimesh(LiverDataT ,'FaceColor',rgb("Sienna"),'FaceAlpha', .25 ,'EdgeColor','none','EdgeAlpha', .35 )

    %      trimesh(LiverDataT ,'FaceColor',rgb("DodgerBlue"),'FaceAlpha', .60 ,'EdgeColor','none','EdgeAlpha', .80 )
        liverColor = [85, 188, 236]./255; 
        trisurf(LiverDataT ,'FaceColor',rgb("Sienna"),...
                'FaceAlpha', .15 ,'EdgeColor', 'none' ,'EdgeAlpha', .60 )
            

        % plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3),.1 ,'.k' )
        %title(join(['Surgical Plan Example']), 'FontSize', 14)
        %axis square;
        hold on
       
        
    end 
    
    stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Bare Area\Segmentation_BareAreaLiver_Moved.stl");
    BareAreaMeshpoints = stlData.Points;
    if PlotBareArea == "TRUE"
        BareArea.Points = stlData.Points + [0, 9.5 , 0];
        BareArea.ConnectivityList = stlData.ConnectivityList ; 
        BareAreaT =  triangulation(  BareArea.ConnectivityList, BareArea.Points );
      
    %   trimesh(LiverDataT ,'FaceColor',rgb("DodgerBlue"),'FaceAlpha', .60 ,'EdgeColor','none','EdgeAlpha', .80 )
        liverColor = [85, 188, 236]./255; 
        trisurf(BareAreaT ,'FaceColor',rgb("Green"),...
                'FaceAlpha', .15 ,'EdgeColor', 'none' ,'EdgeAlpha', .60 )
        hold on
    end 
    
    

    stlData = stlread("D:\Slicer Models\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_Rib Segmentation_2-5mm.stl");
    RibMeshpoints = stlData.Points;
    RibCenter = mean(RibMeshpoints,1) ;
    if plotRibs == "TRUE"
             
        %rotate along the y-axis
        P = RibMeshpoints;
        R2 = rotz( 180 );
        C = [R2*P']' ; 
  
        
        RibData.Points = C + (LiverCenter-RibCenter) + [+25, -20,140] ;
        RibData.ConnectivityList = stlData.ConnectivityList ; 
        LiverDataT =  triangulation(  RibData.ConnectivityList, RibData.Points );
        %trimesh(LiverDataT ,'FaceColor',rgb("Sienna"),'FaceAlpha', .25 ,'EdgeColor','none','EdgeAlpha', .35 )

    %      trimesh(LiverDataT ,'FaceColor',rgb("DodgerBlue"),'FaceAlpha', .60 ,'EdgeColor','none','EdgeAlpha', .80 )
        liverColor = [85, 188, 236]./255; 
%         trisurf(LiverDataT ,'FaceColor',rgb("Ivory"),...
%                 'FaceAlpha', .65 ,'EdgeColor', 'none' ,'EdgeAlpha', .60 )
        
        X2 = RibData.Points(:,1);    Y2 = RibData.Points(:,2);  Z2 =  RibData.Points(:,3);
        trimesh( RibData.ConnectivityList, X2 , Y2 , Z2, 'Facecolor', rgb("DarkGray")  ,'FaceAlpha', .85 ,...
            'EdgeColor', rgb("Silver") , 'EdgeAlpha', .15)
        % plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3),.1 ,'.k' )
        %title(join(['Surgical Plan Example']), 'FontSize', 14)
        %axis square;
        hold on
    end 



    HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_hepatic_60pReduced.stl");
    VasculatureMeshData.HepaticVeinPoints = HepaticVeinData.Points; 
    if plotVasc == "TRUE"
        trimesh(HepaticVeinData,'FaceColor','b', 'FaceAlpha', .35...
            ,'EdgeColor','b','EdgeAlpha', .35 )
    end 
    PortalVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_portal_80pReduced.stl");
    VasculatureMeshData.PortalVeinPoints = PortalVeinData.Points; 
    if plotVasc == "TRUE"
        trimesh(PortalVeinData,'FaceColor',rgb('Brown'),'FaceAlpha', .45...
            ,'EdgeColor', rgb('Crimson') ,'EdgeAlpha', .35 )
    end 
    VasculatureMeshData.AllPoints = [VasculatureMeshData.HepaticVeinPoints ;...
        VasculatureMeshData.PortalVeinPoints];




set(gcf,'color',plotColor );
set(gca,'color',plotColor );
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
% axis vis3d equal;
axis off
% grid off
hold on
axis vis3d equal;
camlight;
 view(-250,20)
 

%%Create the tumor
ProbeNum = 1;
TumorNum = 1;


%TumorColors = [ rgb("Tan"); rgb("Peru"); rgb("Salmon"); rgb("Fuchsia") ];
TumorColors = [ rgb("Pink") ; rgb("ForestGreen") ; rgb("Tan") ; rgb("LightSteelBlue") ];
% TumorColors = [ rgb("Black") ; rgb("ForestGreen") ; rgb("Tan") ; rgb("RoyalBlue") ];



%tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Vanderbilt_017_Tumor_remeshed.stl";
tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Scout_Tumor_Export.stl";



 
    
TumorData = stlread(tumorfile);
TumorPoints.Points = TumorData.Points;
x = TumorData.Points(:,1); y = TumorData.Points(:,2); z = TumorData.Points(:,3);  
 [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( TumorData.Points, '' );
 % draw data
hold on

% plot3( x, y, z, '.r' );
% 
% %draw fit
% mind = min( [ x y z ] );
% maxd = max( [ x y z ] );
% nsteps = 50;
% step = ( maxd - mind ) / nsteps;
% [ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ), linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ), linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
% Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
%           2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
%           2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
% p = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );
% TumorData = delaunayTriangulation( TumorPoints.Points(:,1)  , TumorPoints.Points(:,2)...
%                           , TumorPoints.Points(:,3));
% tetramesh(TumorData,'FaceColor', rgb("Brown"),'FaceAlpha', .65 ,'EdgeColor', 'none' ,'EdgeAlpha', 1 )
% 
% 
% set( p, 'FaceColor', 'g', 'FaceAlpha', .45 ,'EdgeColor', 'none' );
% view( -70, 40 );
% axis vis3d equal;
%     title(join([  "X_d = ",num2str( round(radii(3)*2,0)) ,...
%               "mm   |   ","Y_d = ", num2str(round(radii(1)*2,0) ),...
%               "mm   |   ", "Z_d = ", num2str(round(radii(2)*2,0) ),"mm" ]) )
%             xlabel("X")
%             ylabel("Y")
%             zlabel("Z")
 
 
VasculatureMeshData.TumorData = TumorPoints.Points; 




%Split the tumor into two sections along the x axis. 
trueCenter = [221, 260, 182];
TumorPoints.Points  = rotateZalongPoint(TumorPoints.Points , 90 , trueCenter ) ; 
TumorPoints.centerOne = mean(TumorPoints.Points);


% TumorData = delaunayTriangulation( TumorPoints.Points(:,1)  , TumorPoints.Points(:,2)...
%                           , TumorPoints.Points(:,3));
% tetramesh(TumorData,'FaceColor', rgb("Brown"),'FaceAlpha', .7 ,'EdgeColor', 'none' ,'EdgeAlpha', 1 )

STumor.complete = alphaShape( TumorPoints.Points , 15); 
p1 = plot( STumor.complete   ,'FaceColor', rgb('Tan')  ,'FaceAlpha', 0.75 ,...
    'EdgeColor',  'none', 'EdgeAlpha', 0.6 );
p1.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on 



 ALlPlace = [ "A", "B", "C", "D" ] ;   
for z = 4:4
     Placement = ALlPlace(z);
     

 
 switch  Placement
 
    case "A"

         psiAngle = [90+80 , 0 ];
         thetaAngle = [90-25 , 0 ];
         
         ChangePsiAngle = [-15, 0];
         ChangeThetaAngle = [0, 0];  
         
         psiAngle = psiAngle + ChangePsiAngle;
         thetaAngle = thetaAngle + ChangeThetaAngle;
         
         patient = 1;
         
         
    case  "B"   

         psiAngle = [ (75+90) , 0 ];
         thetaAngle = [90 , 0 ];  
         
         ChangePsiAngle = [10+3, 0];
         ChangeThetaAngle = [0, 0];  
         
         psiAngle = psiAngle + ChangePsiAngle;
         thetaAngle = thetaAngle + ChangeThetaAngle;
         
         patient = 2;

   case "C" 
%         189.5
        psiAngle = [ (112.5+90 - 8 - 5 ) , 0 ];
        thetaAngle = [90-4 , 0 ];  
        
         ChangePsiAngle = [0, 0];
         ChangeThetaAngle = [0, 0];  
         
         psiAngle = psiAngle + ChangePsiAngle;
         thetaAngle = thetaAngle + ChangeThetaAngle;
         
        patient = 3;
        
    case "D"

        psiAngle = [100+90 , 0 ];
        thetaAngle = [90+10 , 0 ]; 
        
         ChangePsiAngle = [0, 0];
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
    % if i < 3
    iSlct = 1;
    psiAngle(iSlct) 
    thetaAngle(iSlct)
    TargetCentr = TumorPoints.centerOne;
    NumTargets = linspace(0, 2*pi, 1 + 1 );
    ProbeColor = TumorColors(z,:);
      
    
    ProbeLength = 150;
    [Arrange ] = CreatePlacementStrategyPaper2(NumTargets , psiAngle(iSlct) ,...
        thetaAngle(iSlct), AngleSpacing,  TargetCentr , radiusSrt, ...
        VasculatureMeshData.AllPoints, safetyMargin, ProbeColor, ProbeLength);
     
 
    
     
    
    YPAngle = Arrange.YPAngle(end, 1:2);
    YP = YawPitch( YPAngle(1),  0 ); 
    %Visualize Ablation Margins
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

    
    

    
end 

view(290,-5)
x0=850;
y0=50;
width=850;
height=900;
set(gcf,'position',[x0,y0,width,height])






    %ADD AND ATLAS
if Add_atlas == "TRUE"


    %Create an atlas
    TargetCentr = [221 ,260 ,182] - [100, -160, 100  ];     

    radiusSrt = 7*sqrt(2);

    %Angles Determine the number of potential target you want to model
    angles = linspace(0, 2*pi, 1 + 1);

    %
    %  psiAngleArr =  linspace(0 , 360, 16 + 1);
    %  thetaAngleArr = linspace(0, 360, 17 + 1);

    psiAngleArr =  linspace(0 , 360, 4 + 1) -radiusSrt;
    thetaAngleArr = linspace(0, 360, 4 + 1);


    % 
    %  AllAngles = [ [repmat(0, 1, length(psiAngleArr) ) ; psiAngleArr ],   ...
    %   [ thetaAngleArr ; repmat(80, 1, length(thetaAngleArr) ) ] ]';

     AllAngles = [0,-9.89949493661167;
                 0,80.1005050633883;
                 0,170.100505063388;
                 0,260.100505063388;
                 0,80;
                 90,80;
                 270,80];


    for angleIdx = 1:length(AllAngles)




    psiAngle = AllAngles(angleIdx, 1 ); %rad2deg( 30*pi/180 ) ;
    psi = deg2rad( psiAngle);    % yaw rotation angle

    thetaAngle = AllAngles(angleIdx, 2 );  %rad2deg( -45*pi/180) ;
    theta = deg2rad( thetaAngle ); % pitch rotation angle (negative rotation is up)


    % Define vectors and Calculate the YAW-PITCH transformation matrix
    YAW = [cos(psi), -sin(psi), 0; sin(psi), cos(psi), 0; 0, 0, 1]; % Planar YAW rotation
    PITCH = [cos(theta), 0, sin(theta); 0,1,0; -sin(theta), 0, cos(theta)]; % Planar PITCH rotation
    YP = YAW*PITCH; % YAW-PITCH rotation matrix
    % Rc = Column Vector pointing to circle on X-Axis (start point)
    % Now sweep the Rc vector around the X-axis to generate the circle 
    % This is done by adding a planar ROLL rotation to YP


    spacing = 1;
    colorNew = hsv(spacing);
    TargetColor = lines(length(angles));



    radiusSrt = 7*sqrt(2);
    ProbeAngleSpacing = radiusSrt*.46 ; 
    % plot3(0, 0, 0, '.r', 'MarkerSize', 20);
    hold on


    CenterX = 0;
    CenterY = 0;

    Target.x = [radiusSrt * cos(angles) + CenterX]' *0  ;
    Target.y = [radiusSrt * sin(angles) + CenterY]' *0 ;
    Target.z = [repmat(0, 1, length(angles) )]' *0 ;

    %Rotate the targets
    Rc = [Target.x  ,Target.y  ,Target.z ]';
    C = [YP*Rc]' ; 

    Target.x  = C(:,1);
    Target.y = C(:,2);
    Target.z = C(:,3);

    clear C
    %

    Arrange.VectorAngles = [];
    Arrange.VectorAnglesX = [];
    Arrange.VectorAnglesY = [];
    Arrange.VectorAnglesZ = [];
    Arrange.ProbeDepth =[];
    Arrange.DistanceFromCenter=  [];


    spaceEnd = spacing;

    for i = 1:spaceEnd

        Nz = 50; 
        Vector = [];
        radius = radiusSrt + ProbeAngleSpacing*(i-1);
        CenterX = 0;
        CenterY = 0;
        x = [radius * cos(angles) + CenterX]';
        y = [radius * sin(angles) + CenterY]';
        z = [repmat(Nz , 1, length(angles) )]';
        %Rotate the points
        Rc = [x,y,z]';
        C = [YP*Rc]' ; 

        x = C(:,1);
        y = C(:,2);
        z = C(:,3);


        Vector = ( [Target.x, Target.y, Target.z] - [x, y, z]  );




        Arrange.ProbeDepth = [Arrange.ProbeDepth;...
            round( sqrt( Vector(1,1)^2 +  Vector(1,2)^2 +  Vector(1,3)^2), 1)  ];

        Arrange.DistanceFromCenter = [Arrange.DistanceFromCenter;...
            round( sqrt( x(1)^2 +  y(1)^2 ) , 1) ];


        %if angleIdx <  length(AllAngles)

           Nz = Nz/40;
           x = x/Nz ;   
           y = y/Nz ;     
           z = z/Nz;



            plot3( x  + TargetCentr(1) , y + TargetCentr(2), z + TargetCentr(3) ,...
                '.', 'LineWidth', 2, 'MarkerSize', 20, 'Color', colorNew( i, :) )

            textadd.x = 5*x(1)/abs(x(1)+.0001)  + TargetCentr(1) ;
            textadd.y = 5*y(1)/abs(y(1)+.0001) + TargetCentr(2) ; 
            textadd.z = 2*z(1)/abs(z(1)+.0001) + TargetCentr(3); 


            text(  x(1)+ textadd.x  , y(1) + textadd.y , z(1) + textadd.z, ...
            join([ num2str( round(AllAngles(angleIdx, 1 ),0) ), char(176),...
            ",", num2str( round(AllAngles(angleIdx, 2 ),0) ), char(176) ]),'FontSize', 8)



            hold on;
            Vector = Vector/Nz;

            quiver3(x  + TargetCentr(1) , y + TargetCentr(2), z + TargetCentr(3),...
                    Vector(:,1) , Vector(:,2) , Vector(:,3) , ...
                 0, 'Color', 'black' , 'LineWidth', 8 )

            grid on;
        %end 

    end
    %
    slct  = 1; 
    for i = 1:length(angles)

    %     plot3( Target.x(i)  + TargetCentr(1) , Target.y(i) + TargetCentr(2) , Target.z(i) + TargetCentr(3) ,...
    %         '+', 'Color',TargetColor(slct, :)  ,'LineWidth', 3, 'MarkerSize', 14)
        hold on

        slct = slct +1;
        if slct >= length(angles)/2
            slct = 1;
        end 
    end 
    end 
    %%Create the tumor
    [tumor.x1, tumor.y1,  tumor.z1] = sphere(25);
    r = 14*sqrt(2);

    TargetCentr = TumorPoints.centerOne;   
    tumor.x1 = tumor.x1(:)*r ;
    tumor.y1 = tumor.y1(:)*r ;
    tumor.z1 = tumor.z1(:)*r + TargetCentr(3);
    P = [tumor.x1 tumor.y1 tumor.z1];

    % [tumorNew.p1, TargetCentr , TumorPoints.radiiOne, tumorNew.v]...
    %     = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
    % set( tumorNew.p1 , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );


    axis equal;
    % grid off
    % axis off
    % xlabel('X', 'FontSize', 14);
    % ylabel('Y', 'FontSize', 14);
    % zlabel('Z', 'FontSize', 14);
    title("Probe Placement Atlas",'FontSize', 30)
    pause(.1)


    %view(-80,20)
    % grid off
end 






%


 view(190,10)



if iCreateVideo == "TRUE"
    Video_Dir = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Video_Files\";
    Video_FileName = 'AblationEvolutionPosA.mp4';
    Video_fullfile = fullfile(Video_Dir, Video_FileName);
    videoWriter = VideoWriter(Video_fullfile,  'MPEG-4'); %// initialize the VideoWriter object
    videoWriter.FrameRate = 4.5;
    videoWriter.Quality = 100; % High quality video
    open(videoWriter);
end 



%( ProbePosition, Patient)
% ProbePosition = 1 2 3 4 = [A, B, C, D];
Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"];    
% colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];
colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("Salmon") ; rgb("Indigo")];

colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("Salmon") ;...
           rgb("Violet"); ( [90, 70, 27]./255 )];
%

for pj = 5:5
    
selectfile = convertStringsToChars(Patient(pj));     
% ModelRun = [ "915 Mhz Digital Twin" ] ;

switch ModelRun
    
    %%% 915 Mhz Tumor Naive Models
    case  "915 Mhz Tumor Naive"
        fileName = SelectAblationBoundaryPointsNoTumor( patient , selectfile ) ;    
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive';
        
    %%% 915 Mhz Digital Twin Models    
    case "915 Mhz Digital Twin"
        fileName = SelectAblationBoundaryPoints( patient , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin';

    %%% 2450 Mhz Tumor Naive Models
    case "2450 Mhz Tumor Naive"   
        %fileName = SelectAblationBoundaryPoints2450mhzNoTumor( position , selectfile ) ;
        fileName = SelectAblationBoundaryPts2450mhzNoTumorV2( patient , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2';
        
    %%% 2450 Mhz Digital Twin Models
    case "2450 Mhz Digital Twin"
        fileName = SelectAblationBoundaryPoints2450mhzV2( patient , selectfile ) ;
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2';

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
        
        % Create an autumn colormap with 60 entries
        autumnColormap = autumn(62);
        % Reverse the order of the colormap
        reversedColormap = autumnColormap(end:-1:1, :);

    
    for i = 2: (15*4+1) %15-3 : 4 :15*4

        X = BoundaryPointsMatrix(2:end, ((i-1)*3 + 1) );
        X(X == 0) = [];
        Y = BoundaryPointsMatrix(2:end, ((i-1)*3 + 2) );
        Y(Y == 0) = [];
        Z = BoundaryPointsMatrix(2:end, ((i-1)*3 + 3) );
        Z(Z == 0) = [];
        Y = Y +3;
        
        psiAngle =  ChangePsiAngle;
        thetaAngle = ChangeThetaAngle;
        %AblationCenter = mean([X,Y,Z]); 
       switch ModelRun
       
         case  "915 Mhz Tumor Naive"
               AblationCenter = ((Arrange.text(1,:) + TargetCentr)/2 + TargetCentr )/2 ; 

        %%% 915 Mhz Digital Twin Models    
        case "915 Mhz Digital Twin"
               AblationCenter = ((Arrange.text(1,:) + TargetCentr)/2 + TargetCentr )/2 ; 

        %%% 2450 Mhz Tumor Naive Models
        case "2450 Mhz Tumor Naive"   
            %fileName = SelectAblationBoundaryPoints2450mhzNoTumor( position , selectfile ) ;
            AblationCenter = ((Arrange.text(1,:) + TargetCentr)/2 + TargetCentr*4 )/5 ; 

        %%% 2450 Mhz Digital Twin Models
        case "2450 Mhz Digital Twin"
            AblationCenter = ((Arrange.text(1,:) + TargetCentr)/2 + TargetCentr*4 )/5 ; 
       end 
        
        %rearrange the points
        YP =  YawPitch(psiAngle, thetaAngle); 
        Rc = [X ,Y ,Z]';
        C = [YP*Rc]';
        newCenter = AblationCenter - mean(C);
        X2 = C(:,1) + newCenter(1);
        Y2 = C(:,2) + newCenter(2);
        Z2 = C(:,3) + newCenter(3);


        
        [k, vol] = boundary([X2,Y2,Z2]  );
        hold on
%         trisurf(k, X , Y , Z ,'Facecolor',colors(i,:)  ,'FaceAlpha',.1 )
%         trisurf(k, X2 , Y2 , Z2 ,'Facecolor', colors2(pj,:)  ,'FaceAlpha', .45 ,...
%             'EdgeColor', colors2(pj,:) , 'EdgeAlpha', .75, 'LineWidth', 1.5)
        hold on 
        
        DT = boundary([X2 , Y2 , Z2]);
%         trimesh(DT,X2 , Y2 , Z2, 'Facecolor', colors2(pj,:)  ,'FaceAlpha', .45 ,...
%             'EdgeColor', 'none' , 'EdgeAlpha', .05)
    
        tmeshplot = trimesh(DT,X2 , Y2 , Z2, 'Facecolor', reversedColormap(i ,:)  ,'FaceAlpha', .65 ,...
            'EdgeColor', 'none' , 'EdgeAlpha', .05);
        
        
        idx = 1 : 1 : (15*4)+1 ; 
        minutes =  floor( (idx(i)*15-15)/60) ; 
        seconds  = mod( (idx(i)*15-15), 60)    ;
        title( join(["Ablation Evolution",...
        newline,  num2str(minutes),  "m","  ", num2str(seconds), "s" ]), 'Fontsize', 14 )     

        %plot3( X, Y, Z, '.', 'MarkerSize', 5, 'Color',  colors(i,:) )
        %plot3( X, Y, Z, '.', 'MarkerSize', 5, 'Color',  colors2(pj,:) )
 
if iCreateVideo == "TRUE"
    Frame = getframe(gcf) ;                
    writeVideo(videoWriter,Frame)  
end 


        pause(.5)
     
        delete(tmeshplot)
    end

end
set(gcf,'color',plotColor );
set(gca,'color',plotColor );
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
axis vis3d equal;
axis off
%grid off
hold on

if iCreateVideo == "TRUE" 
    close(videoWriter); 
    disp("Video Complete")
    disp(videoWriter.Filename  )
end 


% hold off

