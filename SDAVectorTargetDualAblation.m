  
function [ distances ] = SDAVectorTargetDualAblation( TargetPoints1 , TargetPoints2,...
                         QuerryPointsOG,  probe1,  probe2 ) 


% TargetPoints1  =Abl.AP_Probe1;
% TargetPoints2 = Abl.AP_Probe2;
% probe1 = e1;
% probe2 = e2;


% QUERRY POINTS ARE THE IMAGE GRID
x1 = QuerryPointsOG(:,1);
y1 = QuerryPointsOG(:,2);
z1 = QuerryPointsOG(:,3);

%TARTGET 1 IS ABLATION 1
x2 = TargetPoints1(:,1);
y2 = TargetPoints1(:,2);
z2 = TargetPoints1(:,3);

%TARTGET 2 IS ABLATION 2
x3 = TargetPoints2(:,1);
y3 = TargetPoints2(:,2);
z3 = TargetPoints2(:,3);

%           %outde the tumor
distances = [];

for i=1:length(x1)
    
    %Find out which probe the querry point is closer to
    %PROBE 1
    [dist1, centerIDX1] =  min(sqrt((x1(i)-probe1(:,1)).^2+(y1(i)-probe1(:,2)).^2+(z1(i)-probe1(:,3)).^2));
    center1 = probe1( centerIDX1 ,:);
    
    %PROBE2
    [dist2, centerIDX2] =  min(sqrt((x1(i)-probe2(:,1)).^2+(y1(i)-probe2(:,2)).^2+(z1(i)-probe2(:,3)).^2));
    center2 = probe2( centerIDX2 ,:);
    
    
    %establish the new center and calculate the distance between the
    %closest ablation boundary point and {query point, probe point}    
    %If probe 1 is closer 
    if dist1 < dist2
        
        center  =center1;
        [dist, idx] = min( sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2) ); 
        I = idx(1);     
        vectorT = sqrt( ( center(1) -x2(I) ).^2 + ( center(2) -y2(I) ).^2+...
                       ( center(3) -z2(I) ).^2) ; 
                   
    %If probe 2 is closer               
    else
        
        center  = center2;
        [dist, idx] = min( sqrt((x1(i)-x3).^2+(y1(i)-y3).^2+(z1(i)-z3).^2) ); 
        I = idx(1);     
        vectorT = sqrt( ( center(1) -x3(I) ).^2 + ( center(2) -y3(I) ).^2+...
                       ( center(3) -z3(I) ).^2) ; 
    end 
                         
    %Calculate the distance between the querry point and the center of the
    %probe
    vectorB = sqrt( ( center(1) -x1(i) ).^2 + ( center(2) -y1(i) ).^2+...
                    ( center(3) -z1(i) ).^2)*1.04 ; 
          
    if vectorT > vectorB
        dist = dist*-1;
    else
        dist = dist;
    end 

    distances=[ distances,dist] ;
end



end 

%
% 
% figure()
% colormap jet 
% s = repmat(5, 1, length(distances)  );
% scatter3(x1, y1, z1, s, distances)
% hold on
% plot3( x2, y2, z2, '.', 'color', 'k')
% plot3( x3, y3, z3, '.', 'color', 'b')
% colorbar
% axis equal




%end