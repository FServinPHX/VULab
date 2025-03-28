
function [endingFlag] = LiverSegmentPerTumor( segment2, segment3, segment4, ...
                                    segment5, segment6, segment7, segment8, InputTitle )

figure()


grayColor = [.7 .7 .7];
plotColor  = rgb("Gray");
hold on

%Liver Segment II
LiverSegmentII  = stlread( segment2 );
LiverMeshData.LiverSegmentII = LiverSegmentII.Points; 
LiverMeshData.CenterSegmentII = mean(LiverSegmentII.Points, 1);
trimesh(LiverSegmentII,'FaceColor','none','EdgeColor', rgb('PaleGreen') ,'EdgeAlpha', .25 )

%Liver Segment III
LiverSegmentIII  = stlread( segment3 );
LiverMeshData.LiverSegmentIII = LiverSegmentIII.Points; 
LiverMeshData.CenterSegmentIII = mean(LiverSegmentIII.Points, 1);
trimesh(LiverSegmentIII,'FaceColor','none','EdgeColor', rgb('PeachPuff') ,'EdgeAlpha', .25 )

%Liver Segment IV
LiverSegmentIV  = stlread( segment4 );
LiverMeshData.LiverSegmentIV = LiverSegmentIV.Points; 
LiverMeshData.CenterSegmentIV = mean(LiverSegmentIV.Points, 1);
trimesh(LiverSegmentIV,'FaceColor','none','EdgeColor', rgb('RosyBrown') ,'EdgeAlpha', .25 )

%Liver Segment V
LiverSegmentV  = stlread( segment5 );
LiverMeshData.LiverSegmentV = LiverSegmentV.Points; 
LiverMeshData.CenterSegmentV = mean(LiverSegmentV.Points, 1);
trimesh(LiverSegmentV,'FaceColor','none','EdgeColor', rgb('DodgerBlue') ,'EdgeAlpha', .25 )

%Liver Segment VI
LiverSegmentVI  = stlread( segment6 );
LiverMeshData.LiverSegmentVI = LiverSegmentVI.Points; 
LiverMeshData.CenterSegmentVI = mean(LiverSegmentVI.Points, 1);
trimesh(LiverSegmentVI,'FaceColor','none','EdgeColor', rgb('Chocolate') ,'EdgeAlpha', .25 )


%Liver Segment VII
LiverSegmentVII  = stlread( segment7 );
LiverMeshData.LiverSegmentVII = LiverSegmentVII.Points; 
LiverMeshData.CenterSegmentVII = mean(LiverSegmentVII.Points, 1);
trimesh(LiverSegmentVII,'FaceColor','none','EdgeColor', rgb('Pink'),'EdgeAlpha', .25 )


%Liver Segment VIII
LiverSegmentVIII  = stlread( segment8 );
LiverMeshData.LiverSegmentVIII = LiverSegmentVIII.Points; 
LiverMeshData.CenterSegmentVIII = mean(LiverSegmentVIII.Points, 1);
trimesh(LiverSegmentVIII,'FaceColor','none','EdgeColor', rgb('DarkGreen'),'EdgeAlpha', .25 )



% LiverMeshData.AllPoints = [LiverMeshData.HepaticVeinPoints ;...
%     LiverMeshData.PortalVeinPoints];

%Plot the tumors

%%Create the tumor
set(gcf,'color',plotColor );
set(gca,'color',plotColor );
title( InputTitle, 'FontSize', 14)
xlabel('X', 'FontSize', 14);
ylabel('Y', 'FontSize', 14);
zlabel('Z', 'FontSize', 14);
axis vis3d equal;
axis off
grid off
hold on
view(125,-10)

%

%Add the tumors and the probe placement strategies   rgb("Fuchsia")
TumorCenterTrue = [];
for i = 1:8

    
TumorColors = [ rgb("Lime"); rgb("Tan"); rgb("Cyan"); rgb("Fuchsia")  ] ;
% offset = [ -5, +45, 10; ... 
%     -5, +45, 30; ...
%     -55, +45, 8; ...
%     -55, +45, 35; ...
%     
%     +20, -45, -25;...
%     40, 0, 10; ...
%     80, -20, 20];

offset = [ LiverMeshData.CenterSegmentII ;...
    LiverMeshData.CenterSegmentIII;... 
    [ LiverMeshData.CenterSegmentIV - [0,0, -15 ] ];...
    [ LiverMeshData.CenterSegmentIV - [0,0, +15 ] ];...
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

[tumorNew.p1, TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
    = PlotEllispeNew(tumor.x1, tumor.y1  , tumor.z1 );
set( tumorNew.p1 , 'FaceColor', 'k' ,'FaceAlpha', 1 , 'EdgeColor', 'k'  );






pause(1)
endingFlag = "Success";


end 


end 
