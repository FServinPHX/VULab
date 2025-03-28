clear


fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Box Phantom Ablation\Multiprobe\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef.csv";
BoundaryPoints.all = table2array(readtable(fileName));

%%% ABLATION COVERAGE ANALYSIS

colors = [ 0, 0, 0; 75,0,130; 0,0,225; 0, 128, 128;  0,130,200;...  
    0,255,0; 210, 245, 60;  255,255,0;  255,127,0;
    255,0,0 ]./255;
time = ([.25:.25:15]);

FusedVolume = "F";

increment = 1;
tic 
%Creates a new_multiprobe model
for dataSelect = length(time):length(time) %50:1:51
    
    BoundaryPoints.multiprobe = [];

    BoundaryPoints.multCenter = [];
    BoundaryPoints.multRadii = [];
    for moveZ = 1:4

        a = (dataSelect)*3+1;
        b = (dataSelect)*3+3;

        %find the location of the first zero number
        n=find(BoundaryPoints.all( :, a)==0);
        %display the first time that number appears
        n(1)
        %Selects all NONZERO DATA
        BoundaryPoints.synth = BoundaryPoints.all( 2:n(1)-1, a:b);

        %FIND THE RADIUS OF THE CURRENT DATASET TO FIND THE OPTIMAL PROBE
        %PLACEMENT
        x = BoundaryPoints.synth(:,1);
        y = BoundaryPoints.synth(:,2);
        z = BoundaryPoints.synth(:,3); 
        [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

        %TRANSFORMATION MATRIX
%         BoundaryPoints.tMat = [ ( radii(2)*(5/3.6) ),...
%                 0,...
%                 ( radii(2)*(5/3.7) ) ];
        BoundaryPoints.tMat = [ ( radii(2)*(sqrt(2)) ),...
                0,...
                ( radii(2)*(sqrt(2)) ) ];
        
        %create a matrix to add to the original data points. Every case is a
        %new hypotherical probe
        switch moveZ
            case 1
              addMatrix = [0, 0, 0];
            case 2
              addMatrix = [0, 0, BoundaryPoints.tMat(3)];
            case 3
              addMatrix = [BoundaryPoints.tMat(1),0,BoundaryPoints.tMat(3)];
            case 4
              addMatrix = [BoundaryPoints.tMat(1), 0, 0];
        end 
        %Create symthetic data and adds the translation data
        BoundaryPoints.new = BoundaryPoints.synth+ addMatrix ; 
        %add the current synthetic data to a larger data
        BoundaryPoints.multiprobe = [ BoundaryPoints.multiprobe; BoundaryPoints.new ]; 

        x = BoundaryPoints.new(:,1);
        y = BoundaryPoints.new(:,2);
        z = BoundaryPoints.new(:,3); 
        [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

        figure(1)
        %subplot(1,2,2)
        set(gcf,'color','w');
%         p3 = plot3( x, y, z, '.k','MarkerSize',5);
%         alpha(p3,.2)
        xlabel("X")
        ylabel("Y")
        zlabel("Z")
        radii = round(radii,2);
        title(join(["Time = ",time(dataSelect),newline,  "X_d = ",...
            num2str( round(radii(3)*2,0)) , "mm   |   ","Y_d = ", num2str(round(radii(1)*2,0) ),...
          "mm   |   ", "Z_d = ", num2str(round(radii(2)*2,0) ),"mm", newline "Tumor_d = ",...
          num2str(round(radii(3)*4,0)), "mm" ]) )
        %hold on;
        %draw fit
        p = PlotEllispe(x, y, z);
        set( p, 'FaceColor', colors(increment,:) ,'FaceAlpha',.2, 'EdgeColor', 'none' );
        view( 0, 0 );
%         zlim([120 170])
%         xlim([140 190])
%         ylim([125 185])
        axis vis3d equal;
        grid on
        camlight;
        lighting phong;
        set(gcf,'position',[380,280, 500, 600]) 
        pause(.2)
        hold on

        BoundaryPoints.multCenter = [BoundaryPoints.multCenter; center' ] ;
        BoundaryPoints.multRadii = [BoundaryPoints.multRadii; radii' ];
        
        
        %%ADD A Tumor to the plot
        if moveZ == 1
            
            [tumorNew.x1, tumorNew.y1,  tumorNew.z1] = sphere( round(radii(1)*2,0)  );
            
            r = round(radii(3)*2,0) ;
            tumorNew.x1 = tumorNew.x1(:)*r + center(2) - 2*(radii(2)*(sqrt(2)))/sqrt(2);
            tumorNew.y1 = tumorNew.y1(:)*r + center(1) +  (radii(1)*(sqrt(2)) )/2;
            tumorNew.z1 = tumorNew.z1(:)*r + center(3) +  (radii(3)*(sqrt(2)) )/2;
            
            [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ tumorNew.x1 tumorNew.y1 tumorNew.z1 ], '' );
            tumorNew.p = PlotEllispe(tumorNew.x1 , tumorNew.y1, tumorNew.z1);
            hold on 
            set( tumorNew.p , 'FaceColor', 'g','FaceAlpha',.2, 'EdgeColor', 'none' );
%             hold on 
%             plot3( tumorNew.x1,tumorNew.y1,tumorNew.z1, '.g'  ) 
            disp("TUMOR ADDED")
        end 

    %Update the color changing 
    if increment >= 10
        increment = 1;
    end 
        
    end  
        
        
    set(gcf,'color','w');
    %subplot(1,2,1)
    plot3(BoundaryPoints.multCenter(:,1),BoundaryPoints.multCenter(:,2),...
       BoundaryPoints.multCenter(:,3), '.r', 'MarkerSize',20)
    axis equal
    pause(.5)
    
    hold off
    if strcmp(FusedVolume,"T")  
        dummString = "No Fused Volume";
    else 
        increment = increment + 1;
    end 


%

%FUSED ABLATION VOLUME
%Assigns the current set of datapoints
if strcmp(FusedVolume,"T") 
    %
    k = boundary(BoundaryPoints.multiprobe, .5  );
    BoundaryPoints.k = reshape(k,[],1);
    BoundaryPoints.kSort = unique(BoundaryPoints.k);
    BoundaryPoints.kSortPoint = BoundaryPoints.multiprobe(BoundaryPoints.kSort,:); 

    %
    %%Plotting Function
    figure(2)
    % set(gcf,'color','w');
    % %subplot(1,2,1)
    % scatter3(BoundaryPoints.multiprobe(:,1),BoundaryPoints.multiprobe(:,2),...
    %    BoundaryPoints.multiprobe(:,3),10, 'filled', 'r')
    % axis equal

    x = BoundaryPoints.kSortPoint(:,1);
    y = BoundaryPoints.kSortPoint(:,2);
    z = BoundaryPoints.kSortPoint(:,3); 
    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

     set(gcf,'color','w');
       
        title(join(["Time = ",time(dataSelect),newline,  "X_r = ", num2str(radii(3)), "   |   ","Y_r = ", num2str(radii(1)),...
          "   |   ", "Z_r = ", num2str(radii(2)) ]) )
        %hold on;
        %draw fit 
        
        p3 = plot3( x, y, z, '.k','MarkerSize',10);
        alpha(p3,.2)
        xlabel("X")
        ylabel("Y")
        zlabel("Z")
        radii = round(radii,2);
        mind = min( [ x y z ] );
        maxd = max( [ x y z ] );
        nsteps = 50;
        step = ( maxd - mind ) / nsteps;
        [ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ),...
            linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ),...
            linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
        Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
                  2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
                  2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
        p = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );
        set( p, 'FaceColor',  colors(increment,:),'FaceAlpha',.2, 'EdgeColor', 'none' );
        view( -20, 30 );
        axis vis3d equal;
        grid on
        camlight;
        lighting phong;
        set(gcf,'position',[880,280,400,500]) 
        pause(.5)

        increment = increment + 1;

end 

end 

set(gca,'FontSize',12) % Creates an axes and sets its FontSize to 18

toc 
%%
%%%DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO


% CALCULATE the intersection of Alpha Shapes and point clouds
% Parameters
R = 1;
d = 0.5;
N2 = 30:10:120;
% see: https://mathworld.wolfram.com/Sphere-SphereIntersection.html
fontSize = 14;
lineWidth = 2;
% Analytical solutions
V_intersection_analytical = (1/12)*pi*(4*R + d)*(2*R - d)^2;
V_sphere_analytical = (4/3)*pi*R^3;
% Preallocations
[V_int_numerical,V_sphere_numerical,N,t] = deal(zeros(numel(N2),1));
% Numerical
for ii = 1:1
    tic
    [x1,y1,z1] = sphere(N2(ii));
    
    P1 = [x1(:) y1(:) z1(:)];   % Points - sphere 1
    P1 = unique(P1,'rows');     
    P2 = P1 + [d 0 0];          % Points - sphere 2
    
    N(ii) = size(P1,1);         % Number of points
    
    shp1 = alphaShape(P1,1.01);
    shp2 = alphaShape(P2,1.01);
    id1=inShape(shp2,P1);
    id2=inShape(shp1,P2);
    
    P3 = unique([P1(id1,:);P2(id2,:)],'rows');
    
    shp3 = alphaShape(P3,1.01);
    V_int_numerical(ii)=volume(shp3);    % numerical volume of intersection
    t(ii) = toc; % time to generate the two spheres and estimate V
    
    V_sphere_numerical(ii) = volume(shp1);  % numerical volume of sphere.
    
    plot3(shp1.Points(:,1), shp1.Points(:,2),shp1.Points(:,3), 'k.')
    hold on 
    plot3(shp2.Points(:,1), shp2.Points(:,2),shp2.Points(:,3), 'b.')
    plot3(shp3.Points(:,1), shp3.Points(:,2),shp3.Points(:,3), 'r.')
    hold off
    axis vis3d equal;
    set(gcf,'color','w');
    pause(1)
end
E_intersection = 100*abs(V_int_numerical - V_intersection_analytical) ./ V_intersection_analytical;
E_sphere = 100*abs(V_sphere_numerical - V_sphere_analytical) ./ V_sphere_analytical;


%%%DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO DEMO
%%
hf = figure(); subplot(1,2,1)

ax1 = plot(t,E_intersection,'-.sk','LineWidth',lineWidth);
set(gca,'FontSize',fontSize-2)
xlabel('Computation time, t / (sec)','fontSize',fontSize)
ylabel('Error, E / (%)','fontSize',fontSize)
subplot(1,2,2)

plot(N,E_intersection,'-.sk','LineWidth',lineWidth);
set(gca,'FontSize',fontSize-2)
ylabel('Error, E / (%)','fontSize',fontSize)
xlabel('Number of Points, N / (-)','fontSize',fontSize)
hold on, plot(N,E_sphere,'-or','LineWidth',lineWidth);
set(gca,'FontSize',fontSize-2)
legend('E_{intersection}','E_{sphere}')
set(gcf,'color','w');
%%

% Illustrative Example of Multiprobe Placement 
%Zhang TQ, Huang SM, Gu YK, Jiang XY, Huang ZM, Deng HX, Huang JH. 
%%Sequential and Simultaneous 4-Antenna Microwave Ablation in an Ex Vivo Bovine Liver Model. 
%%Cardiovasc Intervent Radiol. 2019 Oct;42(10):1466-1474.

gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];


figure(1)


%Create the 1st circle
viscircles([0,0],1,'Color', 'k','LineWidth', 2)
axis equal
hold on
%line
pcrcl.x1 = [0, sqrt(2)/2];
pcrcl.y1 = [0, -sqrt(2)/2];
% plot(pcrcl.x1, pcrcl.y1)


textSZ = 15; 
% text(pcrcl.x1(2)-.9, pcrcl.y1(2),'\surd2/ 2, -\surd2/ 2','FontSize', textSZ, 'fontweight','bold' )

%
%Create the 2nd Circle 
viscircles([2*pcrcl.x1(2), 0],1,...
    'Color', [0.847058824	0.670588235	0.298039216 0.8], 'LineStyle','-', 'LineWidth', 2)
% text(2*pcrcl.x1(2), 0, join([' \surd2/, 0 ']),'FontSize', textSZ, 'fontweight','bold' ) 

%%
%Create the 3rd Circle 
viscircles( [ 2*pcrcl.x1(2),  2*pcrcl.y1(2)] ,1,'Color', 'g', 'LineWidth', 2)
pcrcl.x2 = [ 2*pcrcl.x1(2), sqrt(2)/2];
pcrcl.y2 = [2*pcrcl.y1(2), -sqrt(2)/2];
plot(pcrcl.x2,pcrcl.y2)
% text(2*pcrcl.x1(2),2*pcrcl.y1(2), join([' \surd2/, -\surd2 ']),'FontSize', textSZ, 'fontweight','bold' ) 


%%Create the 4th Circle
viscircles([0, 2*pcrcl.y1(2)],1,...
    'Color', [0.847058824	0.670588235	0.298039216 0.8], 'LineStyle','--', 'LineWidth', 2)
% text(-.7,2*pcrcl.y1(2), join([' \surd2/, -\surd2 ']),'FontSize', textSZ, 'fontweight','bold' ) 
%%

text(pcrcl.x1(1), pcrcl.y1(1)+.1, '0, 0','FontSize',  textSZ, 'fontweight','bold' )
%text(pcrcl.x1(2)-.9, pcrcl.y1(2),'\surd2/ 2, -\surd2/ 2','FontSize', textSZ, 'fontweight','bold' )

 text(2*pcrcl.x1(2), 0, join([' \surd2/, 0 ']),'FontSize', textSZ, 'fontweight','bold' ) 
% text(2*pcrcl.x1(2),2*pcrcl.y1(2), join([' \surd2/, -\surd2 ']),'FontSize', textSZ, 'fontweight','bold' ) 
% text(-.7,2*pcrcl.y1(2), join([' \surd2/, -\surd2 ']),'FontSize', textSZ, 'fontweight','bold' ) 



%plot x1 and y1 again
% plot(pcrcl.x1, pcrcl.y1, 'r')
% plot(pcrcl.x2, pcrcl.y2, 'r')

%PLot the Dots
%plot(pcrcl.x1(2), pcrcl.y1(2), '.k','MarkerSize',20 )

%Centers for circles 1,2,3,4
plot(pcrcl.x1(1), pcrcl.y1(1), '.k','MarkerSize',20 )
%plot(0, 2*pcrcl.y1(2), '.k','MarkerSize',20 )
%plot( 2*pcrcl.x1(2), 2*pcrcl.y1(2), '.k','MarkerSize',20 )
 plot(2*pcrcl.x1(2), 0, '.k','MarkerSize',20 )



title( join(["Maximum Probe Spacing", newline,...
    "centers are spaced (r*\surd2)"]),'FontSize', 14, 'fontweight','bold' )
title( join(["Antenna Spacing"]),'FontSize', 14, 'fontweight','bold' )
grid on
ylabel("Y", 'fontweight','bold' )
xlabel("X", 'fontweight','bold' )
set(gcf,'color','w');
grid off

%%
close all 
% CALCULATE the intersection of Alpha Shapes and point clouds (Ablation
% Zone and Tumor) 
%Determine if Ablation intersects with a tumor; 






figure(1)
[tumor.x1, tumor.y1,  tumor.z1] = sphere(50);
r = 20;


tumor.x1 = tumor.x1(:)*r;
tumor.y1 = tumor.y1(:)*r;
tumor.z1 = tumor.z1(:)*r;
tumor.x2 = tumor.x1+5;
P = [tumor.x1 tumor.y1 tumor.z1];

Tadd = [-10 0 0];
query.qx = BoundaryPoints.new(:,1) + Tadd(1);
query.qy = BoundaryPoints.new(:,2) + Tadd(2);
query.qz = BoundaryPoints.new(:,3) + Tadd(3);
Pablation = [query.qx query.qy query.qz ] ;

x = Pablation(:,1);
y = Pablation(:,2);
z = Pablation(:,3); 
%Establish the center of the tumor
[ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );



%P = unique(P,'rows');
P = P + center' + [0 +10 0];



    plot3(P(:,1),P(:,2),P(:,3),'.')
    axis equal
    grid on

    set(gcf,'color','w');
    %
    shpAlph.shp = alphaShape(P(:,1),P(:,2),P(:,3),r);
    % plot(shp)
    axis equal
    %
    hold on 
%figure(2)
%Displacememtn matrix to position the ablation margin

%plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'.')
%
% shp = alphaShape(Pablation(:,1),Pablation(:,2),Pablation(:,3),20);
% plot(shp)
indx.in = inShape(shpAlph.shp,query.qx,query.qy,query.qz);

hold on
plot3(query.qx(indx.in),query.qy(indx.in),query.qz(indx.in),'r.','MarkerSize',20)
plot3(query.qx(~indx.in),query.qy(~indx.in),query.qz(~indx.in),'b.','MarkerSize',20)
title( join(["Tumor (Light Blue)", newline, "Intersection (Red)",...
    newline "Remainder Ablation Margin (Dark Blue)"]))
grid off
view( -40, 20 );
%


figure(2)
set(gcf,'color','w');
%%create alpha point
shpAlph.shp2 = alphaShape(Pablation(:,1),Pablation(:,2),Pablation(:,3),10); 
%plot(shp2)
%create query points 
query.qx2 = P(:,1);
query.qy2 = P(:,2);
query.qz2 = P(:,3);
%find the intersection 
indx.in2 = inShape(shpAlph.shp2, query.qx2, query.qy2, query.qz2 );

%plot the results
hold on
%PLOT whole ablation Margin 
plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'k.','MarkerSize',8)
%PLOT Exterior intersection of TUMOR MARGIN AND ABLATION VOLUME
%plot3(query.qx2(indx.in2),query.qy2(indx.in2),query.qz2(indx.in2),'r.','MarkerSize',20)
%plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
axis equal
view( -40, 20 );

chompedVolume = [ [query.qx2(~indx.in2), query.qy2(~indx.in2), query.qz2(~indx.in2)] ; ...
    [query.qx(indx.in), query.qy(indx.in), query.qz(indx.in)] ] ;
%
%CREATE A CHOMPED VOLUME
%Exterior and Interior of the Chomped Tumor  
%plot3(chompedVolume(:,1),chompedVolume(:,2),chompedVolume(:,3),'.')
%Alpha shape of the Chomped Tumor 
shp3 = alphaShape(chompedVolume(:,1),chompedVolume(:,2),chompedVolume(:,3),6); 

plot(shp3)
hold on 

%Interior Intersection between the Ablation Margins and the tumor
plot3(query.qx(indx.in),query.qy(indx.in),query.qz(indx.in),'r.','MarkerSize',20)
ylabel("Y")
xlabel("X")
zlabel("Z")
set(gcf,'color','w');
title( join(["Chomped Volume (Alpha Shape)", newline, "Ablation Volume (Black)"]) )
lighting phong;
%
%IF THE ABLATION MARGINS are too sparse, resample the margins. 
close all 
tic 


x = Pablation(:,1);
y = Pablation(:,2);
z = Pablation(:,3); 
%Create a 3D sample grid
    
    

    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

    sample.x = [(radii(2)*-1.2):1.5:(radii(2)*1.2) ] + center(1);
    sample.y = [(radii(1)*-1.2):1.5:(radii(1)*1.2)] + center(2);
    sample.z = [(radii(2)*-1.2):1.5:(radii(2)*1.2)] + center(3);

    [X,Y,Z] = meshgrid(sample.x,sample.y,sample.z);
    X = reshape(X, [],1);
    Y = reshape(Y, [],1);
    Z = reshape(Z, [],1);
    currentc = [];
    currentc = [X,Y,Z];
    
    %create query points 
    query.qx3 = currentc(:,1);
    query.qy3 = currentc(:,2);
    query.qz3 = currentc(:,3);
    %find the intersection 
    indx.in3 = inShape(shpAlph.shp2, query.qx3, query.qy3, query.qz3 );

    BoundaryPoints.reasampleAblation = [Pablation(:,1),Pablation(:,2),Pablation(:,3);...
        query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3)];
    k = boundary(BoundaryPoints.reasampleAblation, .5  );
    BoundaryPoints.k = reshape(k,[],1);
    BoundaryPoints.kSort = unique(BoundaryPoints.k);
    BoundaryPoints.kSortPoint = BoundaryPoints.reasampleAblation(BoundaryPoints.kSort,:); 

    %Create New Points, Create New Alpha Shape
    x =  BoundaryPoints.kSortPoint(:,1);
    y =  BoundaryPoints.kSortPoint(:,2);
    z =  BoundaryPoints.kSortPoint(:,3);
    shpAlph.shp2 = alphaShape(x,y, z,10); 
    

    
    
    

plot3(currentc(:,1),currentc(:,2),currentc(:,3),'.')
hold on
plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'r.','MarkerSize',8)

ylabel("Y")
xlabel("X")
zlabel("Z")
set(gcf,'color','w');
title("Sampling Cube")
lighting phong;


figure(2)
set(gcf,'color','w');
%plot(shp2)
%create query points 
query.qx3 = currentc(:,1);
query.qy3 = currentc(:,2);
query.qz3 = currentc(:,3);
%find the intersection 
indx.in3 = inShape(shpAlph.shp2, query.qx3, query.qy3, query.qz3 );

%plot the results
hold on
plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'k.','MarkerSize',8)

plot3(query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3),'r.','MarkerSize',20)
% plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)

axis equal
ylabel("Y")
xlabel("X")
zlabel("Z")
hold off
title("Intersection of the Sampling Cube and the Ablation Margins")
view( -40, 20 );
%
%IF THE BOUNDARY POINTS ARE SPARSE, HERE IS A CODE TO RESAMPLE THE DATA
%POINTS 
 %
    BoundaryPoints.reasampleAblation = [Pablation(:,1),Pablation(:,2),Pablation(:,3);...
        query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3)];
    k = boundary(BoundaryPoints.reasampleAblation, .5  );
    BoundaryPoints.k = reshape(k,[],1);
    BoundaryPoints.kSort = unique(BoundaryPoints.k);
    BoundaryPoints.kSortPoint = BoundaryPoints.reasampleAblation(BoundaryPoints.kSort,:); 

    %
    %%Plotting Function
    figure()
    set(gcf,'color','w');
    %subplot(1,2,1)
    %PLOT the intersection of the ablation margins and the Sampling Cube. 
    scatter3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
       BoundaryPoints.kSortPoint(:,3),10, 'filled', 'k')
    axis equal
    
    %%create alpha point
    shpAlph.shp3 = alphaShape(BoundaryPoints.kSortPoint(:,1),...
        BoundaryPoints.kSortPoint(:,2),BoundaryPoints.kSortPoint(:,3),15); 
%     plot(shpAlph.shp3)
    
    %Find the intersection between the Ablation and Sampling Cube
    indx.in4 = inShape(shpAlph.shp3, query.qx2, query.qy2, query.qz2 );
    %Find the intersection between the Sampling Cube and Ablation
    indx.in5 = inShape(shpAlph.shp, BoundaryPoints.kSortPoint(:,1),...
        BoundaryPoints.kSortPoint(:,2), BoundaryPoints.kSortPoint(:,3) );
    
    query.qx4 = BoundaryPoints.kSortPoint(:,1);
    query.qy4 = BoundaryPoints.kSortPoint(:,2);
    query.qz4 = BoundaryPoints.kSortPoint(:,3);

    %plot the results
    hold on
    plot3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
        BoundaryPoints.kSortPoint(:,3),'k.','MarkerSize',8)
%     plot3(query.qx2(indx.in4),query.qy2(indx.in4),...
%         query.qz2(indx.in4),'r.','MarkerSize',20)
    %plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
    title('Intersection of Ablation Volume and Tumor Exterior')
    ylabel("Y")
    xlabel("X")
    zlabel("Z")
    axis equal
    hold off    
    view( -40, 20 );
    

    %Add the points that are sampled from the exterior CHOMPED tumor and
    %interior CHOMPED TUMOR
    chompedVolume2 = [ [query.qx2(~indx.in4), query.qy2(~indx.in4), query.qz2(~indx.in4)] ; ...
        [query.qx4(indx.in5), query.qy4(indx.in5), query.qz4(indx.in5)] ] ;
    %
    %CREATE A CHOMPED VOLUME
    %New Figure 
%     figure()    
%     plot3(chompedVolume2 (:,1),chompedVolume2 (:,2),chompedVolume2 (:,3),'-b')
%     axis('equal')
%     title('Point Cloud of the chomped volume')
%     set(gcf,'color','w');
    
    figure()
    shp3 = alphaShape(chompedVolume2 (:,1),chompedVolume2 (:,2),chompedVolume2 (:,3),7); 
    plot(shp3)
    hold on 
    
    plot3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
    BoundaryPoints.kSortPoint(:,3),'k.','MarkerSize',8)   

    hold on
   
    plot3(query.qx4(indx.in5) , query.qy4(indx.in5),  query.qz4(indx.in5) ...
        ,'r.','MarkerSize',20)
    
    hold on
    plot3(chompedVolume2(:,1), chompedVolume2(:,2), chompedVolume2 (:,3), '.b','MarkerSize',20)
    
    ylabel("Y")
    xlabel("X")
    zlabel("Z")
    set(gcf,'color','w');
    title("Alpha Shape of the Chomped Volume")
    lighting phong;
    hold off
    
    toc

%%

%FULLY INTEGRATED TUMOR LOCALIZATION

gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];


%Steps in order
%Find Dimensions of the Ablation
%Find the Dimesions of the tumor 
%Split the Tumor in separate Parts
%Align the center of the probe to the center of the tumor segments
%(ICP)
%PLot the final results. 


%ABLATION: Find the dimensions of the ablation margins

ablationCloud.all  = [BoundaryPoints.kSortPoint(:,1),...
        BoundaryPoints.kSortPoint(:,2),BoundaryPoints.kSortPoint(:,3) ];
% ablationCloud.all = BoundaryPoints.new;
[ ablationCloud.center, ablationCloud.radii, ablationCloud.evecs, ablationCloud.v,...
    ablationCloud.chi2 ] = ...
    ellipsoid_fit_new( [ablationCloud.all(:,1), ablationCloud.all(:,2),...
    ablationCloud.all(:,3)] , '');

%TUMOR: Create Tumor
[tumorNew.x1, tumorNew.y1,  tumorNew.z1] = sphere(20);
r = 15;
tumorNew.x1 = tumorNew.x1(:)*r;
tumorNew.y1 = tumorNew.y1(:)*r ;
tumorNew.z1 = tumorNew.z1(:)*r;
tumorCloud = [tumorNew.x1, tumorNew.y1, tumorNew.z1 ] + ablationCloud.center'  ; 



%TUMOR: Find the dimensions of the tumor 
[ tumorNew.Wholecenter, tumorNew.Wholeradii, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
    = ellipsoid_fit_new( [ tumorCloud(:,1) ,tumorCloud(:,2), tumorCloud(:,3) ], '' );


numProbe = 4;

%Number of Probes 
[ TumorPoints ] = SeparateTumor(tumorNew.Wholecenter, numProbe, tumorCloud);



plot3( TumorPoints.one(:,1), TumorPoints.one(:,2), TumorPoints.one(:,3), '.r')
hold on
plot3( TumorPoints.two(:,1), TumorPoints.two(:,2), TumorPoints.two(:,3), '.g')
hold on
plot3( TumorPoints.three(:,1), TumorPoints.three(:,2), TumorPoints.three(:,3), '.k')



%TUMOR PART 1
%[ patchPlot,center,radii,v  ]
% [ TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
%     = ellipsoid_fit_new( [ TumorPoints.one(:,1), TumorPoints.one(:,2), ...
%     TumorPoints.one(:,3) ], '' );


[tumorNew.p1,TumorPoints.centerOne, TumorPoints.radiiOne, tumorNew.v]...
    = PlotEllispeNew(TumorPoints.one(:,1), TumorPoints.one(:,2), TumorPoints.one(:,3));
set( tumorNew.p1 , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );
    hold on 
 plot3( TumorPoints.centerOne(1), TumorPoints.centerOne(2), ...
     TumorPoints.centerOne(3), '.r', 'MarkerSize',20)
pause(.5)
    
    
%TUMOR PART 2
% [ TumorPoints.centerTwo, TumorPoints.radiiTwo, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
%     = ellipsoid_fit_new( [ TumorPoints.two(:,1), TumorPoints.two(:,2), ...
%     TumorPoints.two(:,3) ], '' );

[tumorNew.p2,  TumorPoints.centerTwo, TumorPoints.radiiTwo,tumorNew.v]...
    = PlotEllispeNew(TumorPoints.two(:,1), TumorPoints.two(:,2), TumorPoints.two(:,3));



set( tumorNew.p2 , 'FaceColor', 'g','FaceAlpha',.2, 'EdgeColor', 'none' );
    hold on 
 plot3( TumorPoints.centerTwo(1), TumorPoints.centerTwo(2), ...
     TumorPoints.centerTwo(3), '.g', 'MarkerSize',20)
pause(.5)

%TUMOR PART 3
% [ TumorPoints.centerThree, TumorPoints.radiiThree, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
%     = ellipsoid_fit_new( [ TumorPoints.three(:,1), TumorPoints.three(:,2), ...
%     TumorPoints.three(:,3) ], '' );


[tumorNew.p3, TumorPoints.centerThree, TumorPoints.radiiThree,  tumorNew.v] ...
    = PlotEllispeNew(TumorPoints.three(:,1), TumorPoints.three(:,2), TumorPoints.three(:,3) );

set( tumorNew.p3 , 'FaceColor', 'k','FaceAlpha',.2, 'EdgeColor', 'none' );
plot3( TumorPoints.centerThree(1), TumorPoints.centerThree(2), ...
     TumorPoints.centerThree(3), '.k', 'MarkerSize',20)
pause(.5)


%TUMOR PART  4
if numProbe == 4
   hold on
   plot3( TumorPoints.four(:,1), TumorPoints.four(:,2), TumorPoints.four(:,3), '.', 'color', purple)
   
   pause(1)
%    [ TumorPoints.centerFour, TumorPoints.radiiFour, tumorNew.evecs, tumorNew.v, tumorNew.chi2 ]...
%     = ellipsoid_fit_new( [ TumorPoints.four(:,1), TumorPoints.four(:,2), ...
%     TumorPoints.four(:,3) ], '' );

    [tumorNew.p4, TumorPoints.centerFour, TumorPoints.radiiFour, tumorNew.v]  = ...
        PlotEllispeNew(TumorPoints.four(:,1), TumorPoints.four(:,2), TumorPoints.four(:,3) );
    set( tumorNew.p4 , 'FaceColor', purple,'FaceAlpha',.1, 'EdgeColor', 'none');

   
end 
set(gcf,'color','w');
axis vis3d equal;
grid on
camlight;
lighting phong;
title( join(["Tumor separated in", num2str(numProbe), "Sections" ] ))


%
% tumorNew.p = PlotEllispe(tumorNew.x1, tumorNew.y1, tumorNew.z1,  tumorNew.v);
% hold on 
% title( join(["Tumor_d = ", num2str(round( tumorNew.Wholeradii(3)*2, 0)) ])) 
% set(gcf,'color','w');
% set( tumorNew.p , 'FaceColor', 'g','FaceAlpha',.2, 'EdgeColor', 'none' );
% axis vis3d equal;
% grid on
% camlight;
% lighting phong;


%


%Find the number of probes required to destroy tumor
ablationCloud.numProbe = [ ceil( tumorNew.Wholeradii(2)/ablationCloud.radii(2) ) + ...
    ceil( tumorNew.Wholeradii(3)/ablationCloud.radii(3) ) ];

%
%separate the tumor in x-directions 
%See above
ablationCloud.center = ablationCloud.center + [0;10;0];
%RUN THE ALGORITHM TO CROP THE TUMOR
tumorCloud = tumorCloud ;%+ ablationCloud.center';

%
%
    
[croppedTumorVolume, newAblationCloud] = subtractAblationAndTumor(tumorCloud,...
    ablationCloud.all ,ablationCloud.center, r , 3, ablationCloud.radii, "T");

%%
%         Tadd = [-10 0 0];
%         query.qx = BoundaryPoints.new(:,1) + Tadd(1);
%         query.qy = BoundaryPoints.new(:,2) + Tadd(2);
%         query.qz = BoundaryPoints.new(:,3) + Tadd(3);
%         Pablation = [query.qx query.qy query.qz ] ;
% 
%         x = Pablation(:,1);
%         y = Pablation(:,2);
%         z = Pablation(:,3); 
%         newAblationCloud = [x,y,z;ablationCloud.center'];

%
useCenter = "T";
useWeight = "T";
iterations = 3;

x = [ones(length(ablationCloud.all), 1) ;  10] ;
weights = @(x) x;
%ICP Probe for Tumor 1
[Dicp.Tumor1] = icpAblationTumor(TumorPoints.one, newAblationCloud ,...
    ablationCloud.center, TumorPoints.centerOne, iterations, useWeight,useCenter, weights);


%

%ICP Probe for Tumor 2
[Dicp.Tumor2] = icpAblationTumor(TumorPoints.two, newAblationCloud ,...
    ablationCloud.center, TumorPoints.centerTwo, iterations,  useWeight ,useCenter, weights);


%

%ICP Probe for Tumor 3
[Dicp.Tumor3] = icpAblationTumor(TumorPoints.three, newAblationCloud ,...
    ablationCloud.center, TumorPoints.centerThree, iterations, useWeight ,useCenter, weights );


%

%ICP Probe for Tumor 4
[Dicp.Tumor4] = icpAblationTumor( TumorPoints.four, newAblationCloud ,...
    ablationCloud.center, TumorPoints.centerFour, iterations, useWeight , useCenter, weights);


%

%TADA!!!
[Finished] = PlotSeparateTumor(TumorPoints, tumorNew, numProbe );
hold on
plot3(Dicp.Tumor1(:,1),Dicp.Tumor1(:,2), Dicp.Tumor1(:,3), '.')
hold on 
plot3(Dicp.Tumor2(:,1),Dicp.Tumor2(:,2), Dicp.Tumor2(:,3), '.')
hold on 
plot3(Dicp.Tumor3(:,1),Dicp.Tumor3(:,2), Dicp.Tumor3(:,3), '.')
hold on 
plot3(Dicp.Tumor4(:,1),Dicp.Tumor4(:,2), Dicp.Tumor4(:,3), '.')
hold off


%%
%TODO Create a probe Model
t = 0:pi/10:2*pi;
r = 1 + cos(t/10);
% r = 3;
R = rotx(90);
[X,Y,Z] = cylinder( r) ;
X = reshape(X, [],1);
Y = reshape(Y, [],1);
Z = reshape(Z, [],1);


%
%+ [ablationCloud.center(1)]
%Prototyping, not goof code so far
h = 60;
Z = Z*h;

newP = [R * [X,Y,Z]']' ;
X = newP(:,1) + ablationCloud.center(1); 
Y = newP(:,2) + ablationCloud.center(2); 
Z = newP(:,3) + ablationCloud.center(3);

shpAlph.shp4 = alphaShape(X,Y,Z,15); 
plot(shpAlph.shp4,'FaceAlpha',0.1 )
hold on

set(gcf,'color','w');

plot3(X,Y,Z, '.k')
hold on

plot3(newAblationCloud(:,1), newAblationCloud(:,2), newAblationCloud(:,3), '.b')
axis vis3d equal;
grid on
camlight;
lighting phong;

