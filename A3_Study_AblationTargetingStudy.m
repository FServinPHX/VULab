%%
clear
close all

patientNum = 1;

segStart = 1;
segStop = 8;

switch patientNum
    case 1 
        cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\3D-Slicer\Slicer patient 1 8 Lobes'
        order = [1,2,3,4,5,6,7,8];

    case 2
        cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\3D-Slicer\Slicer Patient 2 8 Liobes'
        order = [1,2,3,4,5,6,7,8];
    case 3
        cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\3D-Slicer\Slicer Patient 3 8 lobes'
        order =  [1,2,3,4,5,6,7,8];
    case 4
        cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\3D-Slicer\Slicer Patient 4 8 Lobes'
        order =  [1,2,3,4,5,6,7,8];
end 

names = dir('*.stl');

CiAll = [];


for i = 1:8
    CI = find(order == (i));
    CiAll =  [CiAll, CI];
 
end 


cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
grayColor = [.7 .7 .7];
plotColor  = rgb("Gray");



%stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1011_Vanderbilt_Slicer\1011_Vanderbilt_Slicer\Segmentation_liver and vena cava.stl");

stlData = stlread( fullfile(names(CiAll(1)).folder , names(CiAll(1)).name) );
LiverMeshpoints = stlData.Points;
LiverCenter = mean(LiverMeshpoints,1) ;
% trimesh(stlData,'FaceColor','none','EdgeColor',grayColor,'EdgeAlpha', .25 )
% plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3),.1 ,'.k' )

%axis square;
hold on

% HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1007_Vanderbilt_Slicer\1007_Vanderbilt_Slicer\Segmentation_hepatic.stl");
% VasculatureMeshData.HepaticVeinPoints = HepaticVeinData.Points; 
% trimesh(HepaticVeinData,'FaceColor','none','EdgeColor','b','EdgeAlpha', .5 )
% 
% 
% 
% PortalVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1007_Vanderbilt_Slicer\1007_Vanderbilt_Slicer\Segmentation_portal.stl" );
% VasculatureMeshData.PortalVeinPoints = PortalVeinData.Points; 
% trimesh(PortalVeinData,'FaceColor','none','EdgeColor','r','EdgeAlpha', .5 )

for segment = segStart:segStop
    
    %                                                                           LiverSegmentII         
    LiverSegmentII  = stlread(  fullfile(names(CiAll(2)).folder , names(CiAll(2)).name)  );
    LiverMeshData.LiverSegmentII = LiverSegmentII.Points; 
    LiverMeshData.CenterSegmentII = mean(LiverSegmentII.Points, 1);    
    
    %                                                                           LiverSegmentIII     
    LiverSegmentIII  = stlread(  fullfile(names(CiAll(3)).folder , names(CiAll(3)).name)  );
    LiverMeshData.LiverSegmentIII = LiverSegmentIII.Points; 
    LiverMeshData.CenterSegmentIII = mean(LiverSegmentIII.Points, 1);    

    %                                                                           LiverSegmentIV      
    LiverSegmentIV  = stlread(  fullfile(names(CiAll(4)).folder , names(CiAll(4)).name)  );
    LiverMeshData.LiverSegmentIV = LiverSegmentIV.Points; 
    LiverMeshData.CenterSegmentIV = mean(LiverSegmentIV.Points, 1);
    
    %                                                                           LiverSegmentV    
    LiverSegmentV  = stlread(  fullfile(names(CiAll(5)).folder , names(CiAll(5)).name)  );
    LiverMeshData.LiverSegmentV = LiverSegmentV.Points; 
    LiverMeshData.CenterSegmentV = mean(LiverSegmentV.Points, 1);
    
    %                                                                           LiverSegmentVI      
    LiverSegmentVI  = stlread(  fullfile(names(CiAll(6)).folder , names(CiAll(6)).name)  );
    LiverMeshData.LiverSegmentVI = LiverSegmentVI.Points; 
    LiverMeshData.CenterSegmentVI = mean(LiverSegmentVI.Points, 1);
    
    %                                                                           LiverSegmentVII      
    LiverSegmentVII  = stlread(  fullfile(names(CiAll(7)).folder , names(CiAll(7)).name)  );
    LiverMeshData.LiverSegmentVII = LiverSegmentVII.Points; 
    LiverMeshData.CenterSegmentVII = mean(LiverSegmentVII.Points, 1);    
    
    %                                                                           LiverSegmentVIII       
    LiverSegmentVIII  = stlread(  fullfile(names(CiAll(8)).folder , names(CiAll(8)).name)  );
    LiverMeshData.LiverSegmentVIII = LiverSegmentVIII.Points; 
    LiverMeshData.CenterSegmentVIII = mean(LiverSegmentVIII.Points, 1);    
    
switch segment

    case 2 
    %Liver Segment II
    %LiverSegmentII  = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1011_Vanderbilt_Slicer\1011_Vanderbilt_Slicer\Segmentation_Liver Segment II .stl" );

    trimesh(LiverSegmentII,'FaceColor',rgb('PaleGreen'),'FaceAlpha', .35, ...
            'EdgeColor', rgb('PaleGreen') ,'EdgeAlpha', 0)


    case 3
    %Liver Segment III
    %LiverSegmentIII  = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1011_Vanderbilt_Slicer\1011_Vanderbilt_Slicer\Segmentation_Liver Segment III.stl");

    trimesh(LiverSegmentIII,'FaceColor',rgb('PeachPuff'), 'FaceAlpha', .35, ...
            'EdgeColor', rgb('PeachPuff') ,'EdgeAlpha', 0 )


    case 4 
    %Liver Segment IV
    %LiverSegmentIV  = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1011_Vanderbilt_Slicer\1011_Vanderbilt_Slicer\Segmentation_Liver Segment IV.stl");

    trimesh(LiverSegmentIV,'FaceColor',rgb('RosyBrown'), 'FaceAlpha', .35, ...
            'EdgeColor', rgb('RosyBrown') ,'EdgeAlpha',0)


    case 5 
    %Liver Segment V
    %LiverSegmentV  = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1011_Vanderbilt_Slicer\1011_Vanderbilt_Slicer\Segmentation_Liver Segment V.stl" );

    trimesh(LiverSegmentV,'FaceColor',rgb('DodgerBlue'), 'FaceAlpha', .35, ...
            'EdgeColor', rgb('DodgerBlue') ,'EdgeAlpha', 0)

    case 6 
    %Liver Segment VI
    %LiverSegmentVI  = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1011_Vanderbilt_Slicer\1011_Vanderbilt_Slicer\Segmentation_Liver Segment VI.stl");

    trimesh(LiverSegmentVI,'FaceColor',rgb('Chocolate'), 'FaceAlpha', .35, ...
            'EdgeColor', rgb('Chocolate') ,'EdgeAlpha', 0 )

    case 7 
    %Liver Segment VII
    %LiverSegmentVII  = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1011_Vanderbilt_Slicer\1011_Vanderbilt_Slicer\Segmentation_Liver Segment VII.stl");

    trimesh(LiverSegmentVII,'FaceColor',rgb('Pink'), 'FaceAlpha', .35, ...
            'EdgeColor', rgb('Pink'),'EdgeAlpha', 0 )

    case 8 
    %Liver Segment VIII
    %LiverSegmentVIII  = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1011_Vanderbilt_Slicer\1011_Vanderbilt_Slicer\Segmentation_Liver Segment VIII.stl");

    trimesh(LiverSegmentVIII,'FaceColor', rgb('DarkGreen'), 'FaceAlpha', .35, ...
            'EdgeColor', rgb('DarkGreen'),'EdgeAlpha', 0 )


    % LiverMeshData.AllPoints = [LiverMeshData.HepaticVeinPoints ;...
    %     LiverMeshData.PortalVeinPoints];

end 


end 

%Plot the tumors

%%Create the tumor
set(gcf,'color',plotColor );
set(gca,'color',plotColor ); 
title( join([' Ablation Targeting Experiment ', num2str(patientNum)]), 'FontSize', 14)
    
% title( join([' Ablation Targeting Experiment ', num2str(patientNum),...
%             newline,'Segment  ', num2str(segStart) ]) , 'FontSize', 14)
            
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
axis vis3d equal;
axis off
grid off
hold on
camlight;
view(90,0)


%Add the tumors and the probe placement strategies   rgb("Fuchsia")
TumorCenterTrue = [];


if segStart == 4 && segStop ==4
    segStart = 3;
    segStop = 4;
    
elseif segStart >= 5
    segStart = segStart;
    segStop = segStop;    
else 
    segStart = segStart-1;
    segStop = segStop-1;
end 

    

for i = segStart:segStart

    
TumorColors = [ rgb("Lime"); rgb("Tan"); rgb("Cyan"); rgb("Fuchsia")  ] ;
% offset = [ -5, +45, 10; ... 
%     -5, +45, 30; ...
%     -55, +45, 8; ...
%     -55, +45, 35; ...
%     
%     +20, -45, -25;...
%     40, 0, 10; ...
%     80, -20, 20];
segment3range = abs( max(LiverSegmentIII.Points(:,3)) -  min(LiverSegmentIII.Points(:,3)));

offset = [ LiverMeshData.CenterSegmentII ;...
    LiverMeshData.CenterSegmentIII;... 
    [ LiverMeshData.CenterSegmentIV - [0,0, -segment3range/2.0 ] ];...
    [ LiverMeshData.CenterSegmentIV - [0,0, +segment3range/2.0 ] ];...
    LiverMeshData.CenterSegmentV;...
    LiverMeshData.CenterSegmentVI;...
    LiverMeshData.CenterSegmentVII;...
    LiverMeshData.CenterSegmentVIII;...
    ];
    
%radius = [5, 6.5, 7.5, 10];
radius = [5, 5, 5, 5, 5, 5, 5, 5 ];

[tumor.x1, tumor.y1,  tumor.z1] = sphere(25);
r = radius(i)*sqrt(2);

% tumor.x1 = tumor.x1(:)*r + LiverCenter(1)+offset(i,1);
% tumor.y1 = tumor.y1(:)*r + LiverCenter(2)+offset(i,2);
% tumor.z1 = tumor.z1(:)*r + LiverCenter(3)+offset(i,3);

tumor.x1 = tumor.x1(:)*r +offset(i,1);
tumor.y1 = tumor.y1(:)*r +offset(i,2);
tumor.z1 = tumor.z1(:)*r +offset(i,3);

P = [tumor.x1 tumor.y1 tumor.z1];

% TumorCenterTrue = [TumorCenterTrue; (LiverCenter(1)+offset(i,1)-313)/1.22 ...
%     (LiverCenter(2)+offset(i,2)-332)/1.22 , (LiverCenter(3)+offset(i,3)-268)/1.22 ];



%                                                                                          Plot Tumor
[tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
    = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
set( tumorNew.p1 , 'FaceColor', 'none' ,'FaceAlpha', 1 , 'EdgeColor', 'none'  );



NumTargets = linspace(0, 2*pi, 20 + 1 );
%psi, theta
psiAngle = [0 , 25, 320, 339];
thetaAngle = [270 , 270, 50, 68];
AngleSpacing = 4;
TargetCentr = TumorPoints.centerOne;
%Radius is the targeting radius of the placement strategy
radiusSrt = 3 ; 
%Safety margin is how far away the probe should be from the vasculature
safetyMargin = 5;

% [Arrange ] = CreatePlacementStrategy(NumTargets , psiAngle(i) , thetaAngle(i),...
%     AngleSpacing,  TargetCentr , radiusSrt, VasculatureMeshData.AllPoints, safetyMargin)


%Create a bounding Box
P = [offset(i,1) ,offset(i,2) ,offset(i,3)] ;   % you center point 
L = [10,10,10].*10 ;  % your cube dimensions 
O = P-L/2 ;       % Get the origin of cube so that P is at center 
plotcube(L,O,.1,rgb('SkyBlue'));   % use function plotcube 
set(gcf,'position',[ 650, 250, 500, 700])

pause(1)



% hold on
% plot3(P(1),P(2),P(3),'*k')

end 




%
% 
% [process] = addAtlasToPlacementStrategy( 1 , TargetCentr );
% xlabel('X', 'FontSize', 14);
% ylabel('Y', 'FontSize', 14);
% zlabel('Z', 'FontSize', 14);


%%

segment2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0210\Preop\Segmentation_Liver Segment II.stl";
segment3 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0210\Preop\Segmentation_Liver Segment III.stl";
segment4 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0210\Preop\Segmentation_Liver Segment IV.stl";
segment5 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0210\Preop\Segmentation_Liver Segment V.stl" ; 
segment6 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0210\Preop\Segmentation_Liver Segment VI.stl";
segment7 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0210\Preop\Segmentation_Liver Segment VII.stl";
segment8 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0210\Preop\Segmentation_Liver Segment VIII.stl";
InputTitle = join(["Ablation Targetting in Patient M0210"]);
LiverSegmentPerTumor(segment2, segment3, segment4, ...
                                    segment5, segment6, segment7, segment8, InputTitle )
                                
%%

segment2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0206\Preop\Segmentation_Liver Segment II.stl";
segment3 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0206\Preop\Segmentation_Liver Segment III.stl";
segment4 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0206\Preop\Segmentation_Liver Segment IV.stl";
segment5 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0206\Preop\Segmentation_Liver Segment V.stl";
segment6 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0206\Preop\Segmentation_Liver Segment VI.stl";
segment7 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0206\Preop\Segmentation_Liver Segment VII.stl";
segment8 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\PrintedPhantomCases\PrintedPhantomCases\M0206\Preop\Segmentation_Liver Segment VIII.stl";
InputTitle = join(["Ablation Targetting in Patient M0206"]);
LiverSegmentPerTumor(segment2, segment3, segment4, ...
                                    segment5, segment6, segment7, segment8, InputTitle )
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                

