  
function [ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  CenterQ ) 

% A = [14 8 91 19]
% [out,idx] = sort(A)
% A(idx)


% TargetPoints = ptsMulti;
% BoundaryPointsOG = ptsSingle;
%CenterQ = centerData; 

x1 = QuerryPointsOG(:,1);
y1 = QuerryPointsOG(:,2);
z1 = QuerryPointsOG(:,3);

x2 = TargetPoints(:,1);
y2 = TargetPoints(:,2);
z2 = TargetPoints(:,3);
%           %outde the tumor
distances = [];

for i=1:length(x1)
    
    [val, centerIDX] =  min(sqrt((x1(i)-CenterQ(:,1)).^2+(y1(i)-CenterQ(:,2)).^2+(z1(i)-CenterQ(:,3)).^2));
    center = CenterQ( centerIDX ,:);
    
    
    
    [dist, idx] = min( sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2) ); 
    I = idx(1);     %I2 = idx(2);     I3 = idx(3);

    
    vectorT1 = sqrt( ( center(1) -x2(I) ).^2 + ( center(2) -y2(I) ).^2+...
                    ( center(3) -z2(I) ).^2) ; 
%     vectorT2 = sqrt( ( center(1) -x2(I2) ).^2 + ( center(2) -y2(I2) ).^2+...
%                     ( center(3) -z2(I2) ).^2) ; 
%     vectorT3 = sqrt( ( center(1) -x2(I3) ).^2 + ( center(2) -y2(I3) ).^2+...
%                     ( center(3) -z2(I3) ).^2) ; 
%                 
    vectorT = (vectorT1); 
    
    
    vectorB = sqrt( ( center(1) -x1(i) ).^2 + ( center(2) -y1(i) ).^2+...
                    ( center(3) -z1(i) ).^2) ; 
    
                
    if vectorT > vectorB
        dist = dist*-1;
    else
        dist = dist;
    end 

    distances=[ distances,dist] ;
end



end 



% figure()
% colormap jet 
% s = repmat(5, 1, length(distances)  );
% scatter3(x1, y1, z1, s, distances)
% hold on
% plot3( x2, y2, z2, '.', 'color', 'k')
% colorbar
% axis equal




%end