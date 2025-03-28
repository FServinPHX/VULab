
function [returnData, BndPtsin , BndPtsout, Expt, STumor ] = AblationIntersectionTri(...
    TumorPointsOG , TumorPointsMesh ,   BoundaryPointsOG,  itime, ColorAbl, ColorTum  ) 


TumorPoints.Points =   TumorPointsOG;
BoundaryPoints.pts = BoundaryPointsOG ;
TumorPoints.mesh = TumorPointsMesh;

%Trinagulation
BoundaryPointsTri = delaunayTriangulation( BoundaryPoints.pts(:,1) ,...
    BoundaryPoints.pts(:,2) ,BoundaryPoints.pts(:,3))  ; 


TumorDataTri = delaunayTriangulation( TumorPoints.Points(:,1),...
    TumorPoints.Points(:,2) , TumorPoints.Points(:,3));
                      
%%%
%in Polyhedron: Find Tumor Points in Ablation                      
[Sablation.faces, Sablation.vertices] = freeBoundary(BoundaryPointsTri);
Tumpoints = TumorPoints.Points ;
tic
in1 = in_polyhedron(Sablation, Tumpoints);
% fprintf('Number of points inside is %i, outside is %i. Calculation time: %f sec\n', ...
%   nnz(in1), nnz(in1==0), toc);
Sablation.shp = alphaShape(BoundaryPoints.pts , 30 );
[~, Sablation.vol ] = boundary(BoundaryPoints.pts  );


%%%%
%in Polyhedron: Find Ablation Points in tumor
[STumor.faces, STumor.vertices] = freeBoundary(TumorDataTri);
points2 = BoundaryPoints.pts ;
tic
in2 = in_polyhedron(STumor, points2);
% fprintf('Number of points inside is %i, outside is %i. Calculation time: %f sec\n', ...
%   nnz(in2), nnz(in2==0), toc);

% STumor.Ogshp  = alphaShape( points , 10 );


% pdemesh(TumorPoints.model, 'FaceColor','g' ,'FaceAlpha', 0.25  ,'EdgeColor', 'g') 

TumorPoints.mVol = volume(TumorPoints.mesh)/1000; 

% title( join(["Vol =", num2str(TumorPoints.mVol) ])) 


%Find the ablated tissue 
AblatedTissue.pts  =[  [Tumpoints( in1,1), Tumpoints( in1,2), Tumpoints( in1,3)];...
   [points2( in2,1),points2( in2,2),points2( in2,3)]  ] ;


%%%%%%%%%                                                                   EXPORTED DATA
BndPtsin = [points2( in2,1),points2( in2,2),points2( in2,3)];
BndPtsout = [points2( ~in2,1),points2( ~in2,2),points2( ~in2,3)];


%

%Find the volume of the ablated tissue
AblatedTissue.shp = alphaShape(AblatedTissue.pts , 40 );
[~, AblatedTissue.BndVol ] = boundary(AblatedTissue.pts );

%Tumor that is not ablated
%sRadi = 9 - (1.5*itime)/60; 
STumor.remainderpts = [ Tumpoints(~in1,1),Tumpoints(~in1,2),Tumpoints(~in1,3) ]  ; 
STumor.remainderShp = alphaShape( STumor.remainderpts , 15);
STumor.remainderTri = delaunayTriangulation( Tumpoints(~in1,1),Tumpoints(~in1,2),Tumpoints(~in1,3) );
[STumor2.faces, STumor2.vertices] = freeBoundary( STumor.remainderTri );

%%%%%%%%%                                                                   EXPORTED DATA
Expt.TumPointOut = STumor.remainderpts;
Expt.TumPointsIn = [ Tumpoints(in1,1),Tumpoints(in1,2),Tumpoints(in1,3) ];

% Expt.AblationOut = 
% Expt.AblationIn = 


%       Plot the results
set(gcf,'color','w');
axis vis3d equal;
axis off
grid off
hold off
lighting phong;
set(gcf,'Position',[200 200 600 800])

%                                                                           Plot the delauny tri of tumor not ablated
% patch(STumor2,'FaceColor','g','FaceAlpha',0.2)
STumor.complete = alphaShape( TumorPointsOG , 15); 

%p1 = plot(STumor.remainderShp   ,'FaceColor', ColorTum  ,'FaceAlpha', 0.25  ,'EdgeAlpha', .15 );
p1 = plot( STumor.complete   ,'FaceColor', ColorTum  ,'FaceAlpha', 0.75 ,...
    'EdgeColor',  'none', 'EdgeAlpha', 0.6 );
p1.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on 

%                                                                           Plot the ablation volume
p2 = plot(Sablation.shp  ,'FaceColor', ColorAbl ,'FaceAlpha', 0.6  ,...
    'EdgeColor', 'none' , 'EdgeAlpha', .6*.9 );


% plot3(TumorPoints.Points(:,1), TumorPoints.Points(:,2) , TumorPoints.Points(:,3),...
%     'k.','MarkerSize',.1), axis image 

%%%%%%%%%%%%%%%%%%%%%%%%
% p2.Annotation.LegendInformation.IconDisplayStyle = 'off';

% plot3(points( in1,1),points( in1,2),points( in1,3),'bo','MarkerFaceColor','b')
% plot3(points2( in2,1),points2( in2,2),points2( in2,3),'bo','MarkerFaceColor','b')


%               Plot the points of the ablation volume
% plot3(BoundaryPoints.pts(:,1),BoundaryPoints.pts(:,2), BoundaryPoints.pts(:,3),...
%     '.','MarkerFaceColor', ColorTum, 'MarkerSize',5)   


%                                                                           Plot the tissure that was ablated

% plot3( AblatedTissue.pts(:,1) , AblatedTissue.pts(:,2) , AblatedTissue.pts(:,3)...
%     , 'o' ,'MarkerFaceColor', rgb('Maroon'), 'MarkerSize', 3)


% p3 = plot(AblatedTissue.shp ,'FaceColor','r' ,'FaceAlpha', 0.75  ,...
%     'EdgeColor','r','EdgeAlpha', .75 );
% p3.Annotation.LegendInformation.IconDisplayStyle = 'off';


% plot3(points(~in1,1),points(~in1,2),points(~in1,3),'k.','MarkerSize',5), axis image


% plot3(TumorPoints.Points(:,1), TumorPoints.Points(:,2) , TumorPoints.Points(:,3),...
%     'k.','MarkerSize',.1), axis image 

% legend({'volume', 'Ablated Tumor', 'Tumor Remainder'}, 'Location', 'southoutside')



%                                                                           Calculate all the ablation volume
%                                                                           Calculate the Time
abTime.total = itime*1 ;
abTime.sec = mod(abTime.total,1)*(60/100)*100 ; 
abTime.min = floor(itime/4);  %abTime.total - mod(abTime.total,4);



%Volume of tumor
Vol1 = ( TumorPoints.mVol );

%Volume of ablated tissue
Vol2 = volume( AblatedTissue.shp  )/1000; 
% Vol2 = AblatedTissue.BndVol/ 1000;

%volume of tumor remnant
Vol3 = Vol1 - Vol2;

%Volume of Ablation
Vol4 =  volume(Sablation.shp ) /1000; 



title( join([ "Time = ",num2str(abTime.min), 'm  ', num2str(abTime.sec), "s",...
    newline, " Ablated Vol = ", num2str( round( Vol2 ,2) )  "  [cm^{3}]"  ])) 

% title( join([ "Time = ",num2str(abTime.min), 'm  ', num2str(abTime.sec), "s",...
%     newline,  "OG Vol = ",num2str( round( Vol1 ,2) )  ,"  |New Vol = ", round( Vol3,2) ,...
%     " Ablated Vol = ", num2str( round( Vol2 ,2) )  ])) 


%Return [OriginalVol, TumorRemnant, AblatedTumor, ];
returnData.All = [ Vol1,  Vol3,  Vol2, Vol4] ;
returnData.OriginalVol = Vol1;
returnData.TumorRemnant = Vol3;
returnData.AblatedTumor = Vol2;
returnData.Ablation = Vol4;
returnData.DICE = (2*(Vol2))/(Vol1 + Vol4) ;

axis off
grid off


hold on


end 