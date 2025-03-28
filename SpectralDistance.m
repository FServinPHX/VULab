


function [ distances ] = SpectralDistance(    BoundaryPointsOG ) 


x1 = BoundaryPointsOG(:,1);
y1 = BoundaryPointsOG(:,2);
z1 = BoundaryPointsOG(:,3);

 distances=[ ]; 
for i=1:length(x1)
    
    [dist] =  mean( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2) );
    

    distances=[ distances,dist] ;
end


%distances = distances/ max(distances);
distances = (distances);

% s =  repmat(20, length(x1), 1 ); 
% 
% scatter3( x1, y1, z1 , s, distances, 'filled');
% axis equal
% colormap jet
% colorbar
end 