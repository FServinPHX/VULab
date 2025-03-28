clear 
close all
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];

Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"];    
colors2 = [rgb("ForestGreen"); rgb("RoyalBlue") ; ...
    rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];

colorTumor = [ rgb("LightCoral") ; rgb("PaleGreen") ; ...
    rgb("Tan") ; rgb("PowderBlue") ; rgb("Goldenrod")];

Vandy_map  = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Orange"); rgb("OrangeRed"); ...
            rgb("FireBrick");  rgb("Maroon")];   

Vandy_map2 = [ rgb("MidnightBlue"); rgb("DarkBlue"); rgb("RoyalBlue");...
            rgb("DarkCyan");  rgb("SeaGreen");...
            rgb("Peru"); rgb("Orange"); rgb("OrangeRed"); ...
            rgb("FireBrick");  rgb("Maroon")]; 
        
TurboMap = turbo(40);       
    
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'


colorsMap = jet(61);
colorshsv = hsv(13); 
colorsMap = colorshsv;



All.volume = [];
All.Radii = [];
% cases = [1,5,4,7,6,12,2,8,13,10,9,3,11]; 

for pj = 1:13
    

ModelRun = [ "Axisymmetric" ] ;

switch ModelRun
    
    %%% 915 Mhz Tumor Naive Models
    case  "Axisymmetric"     
        cases = [1,5,4,7,6,12,2,8,13,10,9,3,11]; 
        fileName = SelectAblationBoundaryPtsAxisymmetric( cases(pj) ) ;    
        resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive';
        SdtMap = Vandy_map2;
        maxColorBar = -10;
        minColorBar = 10; 
        plotRevolved = "TRUE";
        plotBox = "FALSE";
        PlotTumorSDA = "FALSE";
        CompareTwoAblations = "FALSE";

        
    case "Box Phantom"
        cases = [1,3,2,7,12,4,6,8, 5, 10, 11, 9,13]; 
        
        fileName = SelectAblationBoundaryPtsAxisBoxPhantom( cases(pj) )    
        resultsDir = 'D:\1.0 Vanderbilt\Dr. Miga Lab\3. Liver Project - Ablation - 2021\COMSOL\Box Phantom\Data\Results';
        SdtMap = Vandy_map2;
        maxColorBar = 10;
        minColorBar = -10;       
        plotRevolved = "FALSE";
        plotBox = "TRUE";   
        PlotTumorSDA = "TRUE";
        CompareTwoAblations = "TRUE";
end 


BoundaryPoints.og = readtable(fileName);
BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:));

%  idx = 4:4:15*4;
  idx = 1:1:(15*4+1);
 
%     f_a = @(i) 3*(i-1) + 1;
%     f_b = @(i) 3*(i-1) + 3;
%     a = f_a(pj);
%     b = f_b(pj);

%     alldata.tumorVolCurrent = [pj, string(selectfile), 0, 0]; 

    
   
    for j = length(idx)-25:length(idx)-25 %length(idx)

        itime = idx(j);

        
     if plotRevolved == "TRUE"        
        X = BoundaryPointsMatrix(2:end, ((itime-1)*2 + 1) );
        X(X == 0) = [];
        Y = BoundaryPointsMatrix(2:end, ((itime-1)*2 + 2) );
        Y(Y == 0) = [];
        BoundaryPoints.new = [X,Y];
     end 
     
      if plotBox == "TRUE"
        X = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 1) );
        X(X == 0) = [];
        Y = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 2) );
        Y(Y == 0) = [];
        Z = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 3) );
        Z(Z == 0) = [];
        Y = Y +3;
        BoundaryPoints.new = [X,Y,Z]; 
        
        
        
       if CompareTwoAblations == "TRUE"
           %Extract the exterior Boundary of the Ground Truth Boundary 
               [k1, ~] = boundary(X , Y, Z, 0);
               BoundaryPoints.k = reshape(k1,[],1);
               BoundaryPoints.kSort = unique(BoundaryPoints.k);
               BoundaryPoints.kSortPoint = BoundaryPoints.new(BoundaryPoints.kSort,:); 

           
            itime2 = itime + 15;
            
            %Find the Boundary point of the 
            X2 = BoundaryPointsMatrix(2:end, ((itime2-1)*3 + 1) );
            X2(X2 == 0) = [];
            Y2 = BoundaryPointsMatrix(2:end, ((itime2-1)*3 + 2) );
            Y2(Y2 == 0) = [];
            Z2 = BoundaryPointsMatrix(2:end, ((itime2-1)*3 + 3) );
            Z2(Z2 == 0) = [];
            Y2 = Y2  +3;
            BoundaryPoints2.new = [X2,Y2,Z2]; 
            
            %%%Upsample the ablation
%             [ NewPoints ] = UpsampleAblation( BoundaryPoints2.new, 1.5 );
%              BoundaryPoints2.new = NewPoints;
            
            %Extract the exterior Boundary of the Interogated Bounday 
               [k2, ~] = boundary(X2 , Y2, Z2, 0.2);
               BoundaryPoints.k2 = reshape(k2,[],1);
               BoundaryPoints.kSort2 = unique(BoundaryPoints.k2);
               BoundaryPoints.kSortPoint2 = BoundaryPoints2.new(BoundaryPoints.kSort2,:);
               
           F = delaunay(BoundaryPoints.kSortPoint2); V=[BoundaryPoints.kSortPoint2]; n =2;
           [Fs,Vs]=subtri(F,V,n);
           
           
            
            %Establish Color Map 
            colorsMap(cases(pj),:)
            BoundaryPointsGT = BoundaryPoints.kSortPoint;
            
            %Find the points that are in/out of the ground truth ablation
            %points 
            [returnData, BndPtsin, BndPtsout, Expt, STumor ] = ...
            ObjectIntersectionTri( BoundaryPoints.kSortPoint2,  ...
            BoundaryPointsGT  , itime , colorsMap(cases(pj),:), colors2(pj ,:) ) ;
        
            %Find the Signed Distance to Agreement between the ground truth
            %volume and the interogated volume
            GroundTruthPTx = BoundaryPointsGT ;      InterogatePts =BoundaryPoints.kSortPoint2  ; % InterogatePts =BoundaryPoints.kSortPoint2  ;
            [distancesGT, distancesTumorInt] = ...
                SDACompute( GroundTruthPTx, Expt,  InterogatePts, BndPtsin, BndPtsout  );

        end 
            
            
       end 
       
       
       
      end 
        
        
%         plot( X, Y, '.', 'color', colorsJet(j,:))
%         xlabel('X [mm]')
%         ylabel('Y [mm]')
%         axis equal
%         hold on
%                                                                                                                             
        
     if plotRevolved == "TRUE"
            x = X;
            y = Y;
            hi = 1;
            figure()
            hplot.X =  [];
            hplot.Y = [];
            hplot.Z = [];
            mult = 1.0;
            n2 = 36;            % number of circles
            center = [mean(x)*mult , mean(y)];


            h = zeros(1,n2);                            % objects for each circle
            set(gcf,'color','w');
            ax = axes;
            h(1) = plot(x,y, '.');                           % plot circle
            axis equal
            for i = 2:n2
                h(i) = copyobj(h(i-1),ax);              % copy previous object
                rotate(h(i),[0 1 0], 10 ,[center(1) center(2) 0]);      % rotate object about [1 0.5 0] vector 15 degree (degree/rotations) 5/40
            end

            hplot.Xtemp = cell2mat(get(h(2:end),'xdata'));
            hplot.Ytemp = cell2mat(get(h(2:end),'ydata'));
            hplot.Ztemp = cell2mat(get(h(2:end),'zdata'));

            close 

            hplot.X = [hplot.X ; hplot.Xtemp(:) ];
            hplot.Y = [hplot.Y ; hplot.Ytemp(:) ];
            hplot.Z = [hplot.Z  ; hplot.Ztemp(:) ];
            necrosis_points = [hplot.X , hplot.Y, hplot.Z];

           [k, vol] = boundary(hplot.X , hplot.Y, hplot.Z);
           BoundaryPoints.k = reshape(k,[],1);
           BoundaryPoints.kSort = unique(BoundaryPoints.k);
           BoundaryPoints.kSortPoint = necrosis_points(BoundaryPoints.kSort,:); 
           x = BoundaryPoints.kSortPoint(:,1);       y = BoundaryPoints.kSortPoint(:,2); 
           z = BoundaryPoints.kSortPoint(:,3);

           [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

            % hplot.X = [ hplot.X1 ; hplot.X2 ];
            % hplot.Y = [ hplot.Y1 ; hplot.Y2 ];
            % hplot.Z = [ hplot.Z1 ; hplot.Z2  ];

            subplot(3,5,pj+2);

    %         hold on
    %         trisurf(k,hplot.X , hplot.Y, hplot.Z,'Facecolor','red','FaceAlpha',0.1)

            %colorsMap(cases(pj),:)
    %         plot3( hplot.X , hplot.Y, hplot.Z ,'.', 'color', rgb("Black"), 'MarkerSize', .1 )
            %
    %         set(h(1),'color','black','linewidth',3)       % highlight original circle
            hold on
            % quiver(0,0,10,5,'linewidth',3)              % draw vector of rotation    
            trisurf(k,hplot.X , hplot.Y, hplot.Z,'Facecolor', colorsMap(cases(pj),:),...
                'FaceAlpha',0.55,'EdgeAlpha', 0.15, 'Edgecolor', 'none' ) %colorsMap(cases(pj),:))        
            ylabel("Y")
            xlabel("X")
            zlabel("Z")
            title( join(["Revolved Ablation","Case", cases(pj) ,...
                newline, "Vol =", round(vol/1000,2) , "cm^{3}",]))

    %         txt = join(["X = ",round(radii(2),2)  ,"cm", newline...
    %                     "Y = ",round(radii(1),2)  ,"cm", newline...
    %                     "Z = ",round(radii(3),2)  ,"cm"]);           
    %         height = center(3)+ radii(3)*.75; 
    %         text(center(1),center(2)+radii(1), height ,txt, 'FontSize', 14)

            set(gcf,'color','w');
            axis vis3d equal;
            grid off
            axis off
            camlight;
    %         lighting phong;
            view( 270, 5)
            x0=550;
            y0=50;
            widthImg=650;
            height=600;
            set(gcf,'position',[x0,y0,widthImg,height])

            %TODO Create a probe Model
            t = 0:pi/10:2*pi;
            r = 1 + cos(t/10);
            % r = 3;
            R = rotx(90);
            [X,Y,Z] = cylinder( r) ;
            X = reshape(X, [],1);
            Y = reshape(Y, [],1);
            Z = reshape(Z, [],1);
            %+ [ablationCloud.center(1)]
            %Prototyping, not goof code so far
            h = 45;
            Z = Z*h;

            newP = [R * [X,Y,Z]']' ;
            X = newP(:,1) + center(1); 
            Y = newP(:,2) + center(2)+30; 
            Z = newP(:,3) + center(3);

            shpAlph.shp4 = alphaShape(X,Y,Z,15); 
            plot(shpAlph.shp4,'FaceAlpha',1,'Facecolor','k', 'EdgeColor', 'none' )
            hold on
            set(gcf,'color','w');
     end 
     
     
     if plotBox == "TRUE"
       
           necrosis_points = [X , Y, Z];  
           [k, vol] = boundary(X , Y, Z, 0);
           BoundaryPoints.k = reshape(k,[],1);
           BoundaryPoints.kSort = unique(BoundaryPoints.k);
           BoundaryPoints.kSortPoint = necrosis_points(BoundaryPoints.kSort,:); 
           x = BoundaryPoints.kSortPoint(:,1);       y = BoundaryPoints.kSortPoint(:,2); 
           z = BoundaryPoints.kSortPoint(:,3);

           [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );     


    %         subplot(3,5,pj+2);


            hold on
            % quiver(0,0,10,5,'linewidth',3)              % draw vector of rotation    
            trisurf(k,X , Y, Z,'Facecolor', colorsMap(cases(pj),:),...
                'FaceAlpha',0.55,'EdgeAlpha', 0.15, 'Edgecolor', 'none' ) %colorsMap(cases(pj),:))        
            ylabel("Y")
            xlabel("X")
            zlabel("Z")
            flnm = char(fileName);
            flnm =flnm(end-5:end-4);
            title( join(["3D Box Ablation","Case", pj ,...
                newline, "Vol =", round(vol/1000,1) , "cm^{3}",]))

            set(gcf,'color','w');
            axis vis3d equal;
            grid off
            axis off
            camlight;
    %         lighting phong;
            view( 270, 5)
            x0=550;
            y0=150;
            widthImg=250;
            height=350;
    %         set(gcf,'position',[x0,y0,widthImg,height])
            %TODO Create a probe Model
            t = 0:pi/10:2*pi;
            r = 1 + cos(t/10);
            % r = 3;
            R = rotx(90);
            [X,Y,Z] = cylinder( r) ;
            X = reshape(X, [],1);
            Y = reshape(Y, [],1);
            Z = reshape(Z, [],1);
            %+ [ablationCloud.center(1)]
            %Prototyping, not goof code so far
            h = 40;
            Z = Z*h;

            newP = [R * [X,Y,Z]']' ;
            X = newP(:,1) + center(1); 
            Y = newP(:,2) + center(2)+15; 
            Z = newP(:,3) + center(3);   
            set(gcf,'color','w');
            shpAlph.shp4 = alphaShape(X,Y,Z,15); 
            plot(shpAlph.shp4,'FaceAlpha',1,'Facecolor','k', 'EdgeColor', 'none' )
            hold off

     end 
     
     
      if PlotTumorSDA == "TRUE"
            % PLOT THE RESULTS

            %figure( (pj)*2  )
            figure()
            set(gcf,'color','w');                
            newmap = brighten(SdtMap,.15);


            Xsct = [ Expt.TumPointsIn(:,1) ; Expt.TumPointOut(:,1) ];
            Ysct = [ Expt.TumPointsIn(:,2) ; Expt.TumPointOut(:,2) ];
            Zsct = [ Expt.TumPointsIn(:,3) ; Expt.TumPointOut(:,3) ];
            S = 100;
            C2 = distancesTumorInt;
            disp( [min(C2),max(C2)] )

%           re-estalbish finding the boundary points for 'trisurf'
%           visualization
            P = [BoundaryPointsGT(:, 1), BoundaryPointsGT(:, 2), BoundaryPointsGT(:, 3)];
            P2 = [Xsct,Ysct,Zsct];

%             k1 = boundary(P, 0);
%             k2 = boundary(P2,  .75);  
            
            %Find the triangulation of the Interogation Boundary Points 
            DT1 = delaunayTriangulation(P);
            [k1,v] = convexHull(DT1) ;          

            %Find the triangulation of the Interogation Boundary Points 
            DT2 = delaunayTriangulation(P2);
            [k2,v] = convexHull(DT2) ;
            
            %Find the  SDA of the triangle elmenent by calculating the average
            %SDA value of the three vertecies
            C2New = [];
            for triK  = 1:length(k2)

                C2c   = [ C2(k2(triK,1)), C2(k2(triK,2)), C2(k2(triK,3)) ];
                C2New = [C2New; mean(C2c) ];

            end 
        
        
            
            hold on
%             plot3(X2, Y2, Z2, '.r'  )
%             plot3( BoundaryPointsGT(:, 1), BoundaryPointsGT(:, 2), BoundaryPointsGT(:, 3), '.k' )
            
            %Plot the shape of the ground truth ablation 
            %Color: colorsMap(cases(pj),:) 
            p0 = trisurf(k1 ,BoundaryPointsGT(:, 1), BoundaryPointsGT(:, 2), BoundaryPointsGT(:, 3),...
                'Facecolor', 'k' ,...
                'FaceAlpha',0.55,'EdgeAlpha', 0.15, 'Edgecolor', 'none' );

            
            %Plot the interogation ablation 
    %         scatter3(Xsct,Ysct,Zsct,S,C2, 'filled') 
            pt = trisurf( k2 ,Xsct,Ysct,Zsct, C2New, 'EdgeColor',...
                          rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha',.35 );
            colormap(newmap)
            hc=colorbar;
            hc.FontSize = 20;
            title(hc,'mm', 'FontSize', 15);
            title( 'SDA_{DT vs  GT}', 'FontSize', 24)
            C=caxis;
            caxis([ minColorBar , maxColorBar  ])
            axis equal
            grid off
            axis off 
            view(-75, 0)

            hold off
        
         end 
    
         

    
    
    radii2 = [radii(2); radii(1); radii(3)]./10; 
    All.volume = [All.volume, round(vol/1000,2)];
    All.Radii = [All.Radii, round(radii2,2)];

    pause(.25)
    hold off
% close all
end 
    
[All.volumeSorted, All.Voldx1 ] = sort(All.volume, 'ascend');
All.Vol2 = All.volume(All.Voldx1);
[~,All.Radidx] = sort(All.Radii(2,:)); 
% All.RadiiSorted = All.Radii(:,All.Radidx);   



%%
%10-6 mm^2/s
set(gcf,'color','w');
c = colorbar();
colormap jet
caxis([0.25 , .6 ])
title(c,'[W/m*K]', 'FontSize', 12);





