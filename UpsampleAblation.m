


function [ NewPoints ] = UpsampleAblation( Pablation, spacing, resample )



    x = Pablation(:,1);
    y = Pablation(:,2);
    z = Pablation(:,3); 
    %Create a 3D sample grid
    BoundaryPointsTri = delaunayTriangulation(x,y,z)    ;
    
    shpAlph.shp2 = alphaShape( x,y,z ,10); 

    
    %fit an ellipsoid to the original abaltion volume
    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit_new( [ x y z ], '' );

%     sample.x = [(radii(2)*-1.2):1.5:(radii(2)*1.2) ] + center(1);
%     sample.y = [(radii(1)*-1.2):1.5:(radii(1)*1.2)] + center(2);
%     sample.z = [(radii(2)*-1.2):1.5:(radii(2)*1.2)] + center(3);
    
    sample.x = [(radii(2)*-1.5): spacing :(radii(2)*1.5) ] + center(1);
    sample.y = [(radii(1)*-1.5): spacing :(radii(1)*1.5)] + center(2);
    sample.z = [(radii(2)*-1.5): spacing :(radii(2)*1.5)] + center(3);

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
    [Sablation.faces, Sablation.vertices] = freeBoundary(BoundaryPointsTri);
    Tumpoints = currentc;
    
    in2 = in_polyhedron(Sablation, Tumpoints);    

%     
%     in2 = inShape(shpAlph.shp2, query.qx3, query.qy3, query.qz3 );


BoundaryPoints.reasampleAblation = [Pablation(:,1),Pablation(:,2),Pablation(:,3);...
        query.qx3(in2),query.qy3(in2),query.qz3(in2)];
    
    
if resample == "RAW"
    
    NewPoints = [ BoundaryPoints.reasampleAblation  ];
    
elseif resample == "BOUNDARY"
    k = boundary(BoundaryPoints.reasampleAblation, .5  );
    BoundaryPoints.k = reshape(k,[],1);
    BoundaryPoints.kSort = unique(BoundaryPoints.k);
    BoundaryPoints.kSortPoint = BoundaryPoints.reasampleAblation(BoundaryPoints.kSort,:); 

    %Create New Points, Create New Alpha Shape
%     x =  BoundaryPoints.kSortPoint(:,1) ;
%     y =  BoundaryPoints.kSortPoint(:,2) ;
%     z =  BoundaryPoints.kSortPoint(:,3) ;    
    
    NewPoints = [ [BoundaryPoints.kSortPoint(:,1); x ], [BoundaryPoints.kSortPoint(:,2);y] ,...
                [BoundaryPoints.kSortPoint(:,3); z] ];
end 
    
    
    

    
    end 
    

