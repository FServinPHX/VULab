function [croppedTumorVolume, newAblationCloud] = subtractAblationAndTumor(tumorCloud, ablationCloud,center, r, r2, radii, ResampleData)


%%%
% [tumorD.x1, tumorD.y1,  tumorD.z1] = sphere(50);
% r = 15;
% 
% 
% tumor(:,1) = tumorD.x1(:)*r;
% tumor(:,2) = tumorD.y1(:)*r;
% tumor(:,3) =  tumorD.z1(:)*r; 
% r = 15;
% 
% 
% ablationCloud = BoundaryPoints.new;
%%%

tic 

P = [tumorCloud(:,1), tumorCloud(:,2), tumorCloud(:,3)];
%P = unique(P,'rows');
%P = P + center' + [0 ,0, 0];
%%Plot the tumor

shpAlph.shp = alphaShape(P(:,1),P(:,2),P(:,3), r); 
%plot(shp)
%figure(2)
%Displacememtn matrix to position the ablation margin
Tadd = [0 0 0];
    query.qx = ablationCloud(:,1) + Tadd(1);
    query.qy = ablationCloud(:,2) + Tadd(2);
    query.qz = ablationCloud(:,3) + Tadd(3);
    Pablation = [query.qx query.qy query.qz ] ;
%plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'.')
%
% shp = alphaShape(Pablation(:,1),Pablation(:,2),Pablation(:,3),20);
%
     indx.in = inShape(shpAlph.shp,query.qx,query.qy,query.qz);

% % %PLOT figure 1
% % figure(1)
% % plot3(P(:,1),P(:,2),P(:,3),'.')
% % axis equal
% % grid on
% % set(gcf,'color','w');
% % 
% % % plot(shp)
% % axis equal
% % hold on
% % plot3(query.qx(indx.in),query.qy(indx.in),query.qz(indx.in),'r.','MarkerSize',20)
% % plot3(query.qx(~indx.in),query.qy(~indx.in),query.qz(~indx.in),'b.','MarkerSize',20)
% % title( join(["Tumor (Light Blue)", newline, "Intersection (Red)",...
% %     newline "Remainder Ablation Margin (Dark Blue)"]))
% % grid off
% % view( -40, 20 );




    %%create alpha point
    shpAlph.shp2 = alphaShape(Pablation(:,1),Pablation(:,2),Pablation(:,3), r); 
    %plot(shp2)
    %create query points 
    query.qx2 = P(:,1);
    query.qy2 = P(:,2);
    query.qz2 = P(:,3);
    %find the intersection 
    indx.in2 = inShape(shpAlph.shp2, query.qx2, query.qy2, query.qz2 );

%plot the results

    %PLOT whole ablation Margin 

    %PLOT Exterior intersection of TUMOR MARGIN AND ABLATION VOLUME
    %plot3(query.qx2(indx.in2),query.qy2(indx.in2),query.qz2(indx.in2),'r.','MarkerSize',20)
    %plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)


    chompedVolume = [ [query.qx2(~indx.in2), query.qy2(~indx.in2), query.qz2(~indx.in2)] ; ...
        [query.qx(indx.in), query.qy(indx.in), query.qz(indx.in)] ] ;
%
%CREATE A CHOMPED VOLUME
%Exterior and Interior of the Chomped Tumor  
    %plot3(chompedVolume(:,1),chompedVolume(:,2),chompedVolume(:,3),'.')
%Alpha shape of the Chomped Tumor 
    shp3 = alphaShape(chompedVolume(:,1),chompedVolume(:,2),chompedVolume(:,3),5); 


% % 
% % figure(2)
% % set(gcf,'color','w');
% % plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'k.','MarkerSize',8)
% % hold on
% % plot(shp3)
% % hold on 
% % %Interior Intersection between the Ablation Margins and the tumor
% % plot3(query.qx(indx.in),query.qy(indx.in),query.qz(indx.in),'r.','MarkerSize',20)
% % ylabel("Y")
% % xlabel("X")
% % zlabel("Z")
% % set(gcf,'color','w');
% % title( join(["Chomped Volume (Alpha Shape)", newline, "Ablation Volume (Black)"]) )
% % axis equal
% % view( -40, 20 );
% % lighting phong;

%

%IF THE ABLATION MARGINS are too sparse, resample the margins. 

if strcmp(ResampleData, "T") 
    
    sample.x = [(radii(2)*-1.2):1:(radii(2)*1.2) ] + center(1);
    sample.y = [(radii(1)*-1.2):1:(radii(1)*1.2)] + center(2);
    sample.z = [(radii(2)*-1.2):1:(radii(2)*1.2)] + center(3);
    
    [X,Y,Z] = meshgrid(sample.x,sample.y,sample.z);
    X = reshape(X, [],1);
    Y = reshape(Y, [],1);
    Z = reshape(Z, [],1);
    currentc = [];
    currentc = [X,Y,Z];


    %plot(shp2)
    %create query points 
    query.qx3 = currentc(:,1);
    query.qy3 = currentc(:,2);
    query.qz3 = currentc(:,3);
    %find the intersection 
    indx.in3 = inShape(shpAlph.shp2, query.qx3, query.qy3, query.qz3 );


    % % figure(3)
    % % plot3(currentc(:,1),currentc(:,2),currentc(:,3),'.')
    % % hold on
    % % plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'r.','MarkerSize',8)
    % % 
    % % ylabel("Y")
    % % xlabel("X")
    % % zlabel("Z")
    % % set(gcf,'color','w');
    % % title("Sampling Cube")
    % % lighting phong;
    % % %plot the results
    % % hold on
    % % plot3(Pablation(:,1),Pablation(:,2),Pablation(:,3),'k.','MarkerSize',8)
    % % %plot3(query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3),'r.','MarkerSize',20)
    % % %plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
    % % axis equal
    % % ylabel("Y")
    % % xlabel("X")
    % % zlabel("Z")
    % % title("Intersection of the Sampling Cube and the Ablation Margins")
    % % view( -40, 20 );
    % % %


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
        %%create alpha point
        shpAlph.shp3 = alphaShape(BoundaryPoints.kSortPoint(:,1),...
            BoundaryPoints.kSortPoint(:,2),BoundaryPoints.kSortPoint(:,3), r); 
        %plot(shpAlph.shp3)

        %Find the intersection between the Ablation and SamplingCube 
        indx.in4 = inShape(shpAlph.shp3, query.qx2, query.qy2, query.qz2 );
        %Find the intersection between the SamplingCube and Ablation
        indx.in5 = inShape(shpAlph.shp, BoundaryPoints.kSortPoint(:,1),...
            BoundaryPoints.kSortPoint(:,2), BoundaryPoints.kSortPoint(:,3) );

        query.qx4 = BoundaryPoints.kSortPoint(:,1);
        query.qy4 = BoundaryPoints.kSortPoint(:,2);
        query.qz4 = BoundaryPoints.kSortPoint(:,3);



    % %     %%Plotting Function
    % %     figure(4)
    % %     set(gcf,'color','w');
    % %     %subplot(1,2,1)
    % %     %PLOT the intersection of the ablation margins and the tumor surface. 
    % %     scatter3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
    % %        BoundaryPoints.kSortPoint(:,3),10, 'filled', 'k')
    % %     axis equal
    % %     %plot the results
    % %     hold on
    % %     plot3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
    % %         BoundaryPoints.kSortPoint(:,3),'k.','MarkerSize',8)
    % % %     plot3(query.qx2(indx.in4),query.qy2(indx.in4),...
    % % %         query.qz2(indx.in4),'r.','MarkerSize',20)
    % %     %plot3(qx2(~in2),qy2(~in2),qz2(~in2),'b.','MarkerSize',20)
    % %     title('Intersection of Ablation Volume and Tumor Exterior')
    % %     ylabel("Y")
    % %     xlabel("X")
    % %     zlabel("Z")
    % %     axis equal
    % %     view( -40, 20 );


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
    chompedVolume = chompedVolume2;
else
    chompedVolume2 = chompedVolume;
end 

    figure()
    shp3 = alphaShape(chompedVolume (:,1),chompedVolume (:,2),chompedVolume (:,3), r2); 
    plot(shp3)
    hold on 
    plot3(query.qx4(indx.in5) , query.qy4(indx.in5),  query.qz4(indx.in5) ...
        ,'r.','MarkerSize',20)
    
    plot3(BoundaryPoints.kSortPoint(:,1),BoundaryPoints.kSortPoint(:,2),...
    BoundaryPoints.kSortPoint(:,3),'k.','MarkerSize',8)

    x1 = BoundaryPoints.kSortPoint(:,1);
    y1 = BoundaryPoints.kSortPoint(:,2);
    z1 = BoundaryPoints.kSortPoint(:,3);

    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x1 y1 z1 ], '' );
    p = PlotEllispe(x1 , y1, z1);
    hold on 
    set( p , 'FaceColor', 'r','FaceAlpha',.2, 'EdgeColor', 'none' );

    axis('equal')
    ylabel("Y")
    xlabel("X")
    zlabel("Z")
    set(gcf,'color','w');
    %title("Final Alpha Shape of the Subtracted Volume")
    title("Tumor Volume (Green) Subtracted from Ablation Volume (red)")
    lighting phong;
    
    toc
    
    croppedTumorVolume = chompedVolume2;
    newAblationCloud = BoundaryPoints.kSortPoint;
    
end  
    
    
    
    
    
    