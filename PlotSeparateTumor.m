


function [Finished] = PlotSeparateTumor(TumorPoints,tumorNew, numProbe )
%Initialize the colors
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];


figure() 


plot3( TumorPoints.one(:,1), TumorPoints.one(:,2), TumorPoints.one(:,3), '.r')
hold on
plot3( TumorPoints.two(:,1), TumorPoints.two(:,2), TumorPoints.two(:,3), '.g')
hold on
plot3( TumorPoints.three(:,1), TumorPoints.three(:,2), TumorPoints.three(:,3), '.k')



%TUMOR PART 1
[ TumorPoints.centerOne, TumorPoints.radiiTwo, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
    = ellipsoid_fit_new( [ TumorPoints.one(:,1), TumorPoints.one(:,2), ...
    TumorPoints.one(:,3) ], '' );

tumorNew.p1 = PlotEllispe(TumorPoints.one(:,1), TumorPoints.one(:,2), ...
    TumorPoints.one(:,3));
set( tumorNew.p1 , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );
    hold on 
 plot3( TumorPoints.centerOne(1), TumorPoints.centerOne(2), ...
     TumorPoints.centerOne(3), '.r', 'MarkerSize',20)
pause(.5)
    
    
%TUMOR PART 2
[ TumorPoints.centerTwo, TumorPoints.radiiTwo, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
    = ellipsoid_fit_new( [ TumorPoints.two(:,1), TumorPoints.two(:,2), ...
    TumorPoints.two(:,3) ], '' );

tumorNew.p2 = PlotEllispe(TumorPoints.two(:,1), TumorPoints.two(:,2), ...
    TumorPoints.two(:,3));
set( tumorNew.p2 , 'FaceColor', 'g','FaceAlpha',.2, 'EdgeColor', 'none' );
    hold on 
 plot3( TumorPoints.centerTwo(1), TumorPoints.centerTwo(2), ...
     TumorPoints.centerTwo(3), '.g', 'MarkerSize',20)
pause(.5)

%TUMOR PART 3
[ TumorPoints.centerThree, TumorPoints.radiiThree, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
    = ellipsoid_fit_new( [ TumorPoints.three(:,1), TumorPoints.three(:,2), ...
    TumorPoints.three(:,3) ], '' );

tumorNew.p3 = PlotEllispe(TumorPoints.three(:,1), TumorPoints.three(:,2), ...
    TumorPoints.three(:,3));
set( tumorNew.p3 , 'FaceColor', 'k','FaceAlpha',.2, 'EdgeColor', 'none' );
plot3( TumorPoints.centerThree(1), TumorPoints.centerThree(2), ...
     TumorPoints.centerThree(3), '.k', 'MarkerSize',20)
pause(.5)


%TUMOR PART  4
if numProbe == 4
   hold on
   plot3( TumorPoints.four(:,1), TumorPoints.four(:,2), TumorPoints.four(:,3), '.', 'color', purple)
   
   pause(1)
   [ TumorPoints.centerFour, TumorPoints.radiiFour, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
    = ellipsoid_fit_new( [ TumorPoints.four(:,1), TumorPoints.four(:,2), ...
    TumorPoints.four(:,3) ], '' );

    tumorNew.p4 = PlotEllispe(TumorPoints.four(:,1), TumorPoints.four(:,2), ...
        TumorPoints.four(:,3));
    set( tumorNew.p4 , 'FaceColor', purple,'FaceAlpha',.1, 'EdgeColor', 'none');

   
end 

TumorPointsnew = TumorPoints;

title( join(["Tumor Separated in", num2str(numProbe), "Sections" ] ))
set(gcf,'color','w');
axis vis3d equal;
grid on
camlight;
lighting phong;

%
% tumorNew.p = PlotEllispe(tumorNew.x1, tumorNew.y1, tumorNew.z1,  tumorNew.v);
% hold on 
% title( join(["Tumor_d = ", num2str(round( tumorNew.radii(3)*2, 0)) ])) 
% set(gcf,'color','w');
% set( tumorNew.p , 'FaceColor', 'g','FaceAlpha',.2, 'EdgeColor', 'none' );
% axis vis3d equal;
% grid on
% camlight;
% lighting phong;

Finished = "T";

end 


