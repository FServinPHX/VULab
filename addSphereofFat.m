function [exportData] = addSphereofFat(VoxelData , radiusSrt, center, fatBegin, fatEnd ) 

% VoxelData = VoxelDataOG;
% center = [5,5,5];
% radiusSrt = 20;
% fatBegin = 99;
% fatEnd = 130;


[X,Y,Z] = sphere(radiusSrt);
X2 = X(:) * radiusSrt + center(1) ;
Y2 = Y(:) * radiusSrt + center(2) ;
Z2 = Z(:) * radiusSrt + center(3) ;

%%%Create a Boundary to remove points that may mess with the triangulation
kBounds = boundary(X2, Y2, Z2, 0 );
kBounds  = reshape(kBounds,[],1);
kBounds = unique(kBounds);
%Assign new poitns 
X2 = X2( kBounds );
Y2 = Y2( kBounds );
Z2 = Z2( kBounds );

%%%Create Delauny Triangulation
DT = delaunayTriangulation(X2 ,Y2 ,Z2 );
TR = triangulation(DT.ConnectivityList ,X2 ,Y2 ,Z2 );
[S.faces, S.vertices] = freeBoundary(TR);
%Find the index of the 
indx = in_polyhedron(S, VoxelData(:,1:3) );

Xnew = VoxelData(:,1); 
Xnew = Xnew(indx);
Ynew = VoxelData(:,2); 
Ynew = Ynew(indx);
Znew = VoxelData(:,3); 
Znew = Znew(indx);

%empty the data that was captured by the sphere so it can be replaced
for i = 1:length(Xnew)
    
%     disp( [Xnew(i), Ynew(i), Znew(i)] ) 
    k = find( VoxelData(:,1) == Xnew(i) &  VoxelData(:,2) == Ynew(i) ...
        & VoxelData(:,3) == Znew(i) );
    %Empty the data 
    VoxelData(k, :) = [];
    
end 
%Function creates a new intensity range for the data that replaces the
%input data 
% newIntensity = (fatEnd - fatBegin).*rand(length(Xnew),1) + fatBegin;

mu = (fatEnd + fatBegin)/2;
%sigma = sqrt(mu*fatBegin ^2);
sigma = (mu-fatBegin)/2.5; 

newIntensity = normrnd(mu, sigma, [length(Xnew),1]) ;

NewData = [Xnew, Ynew, Znew, newIntensity]  ;

% %plot the data (only for testing) 
% figure()
% % plot(shp, 'FaceAlpha', 1, 'EdgeAlpha', .5)
% % patch(S,'FaceColor','g','FaceAlpha',0.2)
% hold on 
% scatter3(Xnew, Ynew , Znew, 20 , newIntensity , 'Filled' )
% title(" Sphere Data of captured Data ") 
% % scatter3( VoxelData(:,1) , VoxelData(:,2) , VoxelData(:,3), 20 , VoxelData(:,4) , 'Filled' )
% colorbar()
% colormap( jet )


exportData = [NewData; VoxelData];


end 