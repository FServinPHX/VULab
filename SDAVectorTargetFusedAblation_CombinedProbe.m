function [ distances ] = SDAVectorTargetFusedAblation_CombinedProbe( TargetPoints , QuerryPointsOG,...
                                                    AllProbes ) 


% TargetPoints1  =Abl.AP_Probe1;
% TargetPoints2 = Abl.AP_Probe2;
% probe1 = e1;
% probe2 = e2;


% QUERRY POINTS ARE THE IMAGE GRID
x1 = QuerryPointsOG(:,1);
y1 = QuerryPointsOG(:,2);
z1 = QuerryPointsOG(:,3);

%TARTGET IS THE ABLATION 
x2 = TargetPoints(:,1);
y2 = TargetPoints(:,2);
z2 = TargetPoints(:,3);


%           %outde the tumor
distances = [];


% AllProbes = [probe1;  probe2];

% figure() 
% set(gcf,'color','w');                
%     %Find the triangulation of the Interogation Boundary Points 
%     plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3), ...
%                 '.', 'Color', rgb('Black'),...
%         'MarkerSize', 10)  
%     hold on 
%     % plot3( Probe1in(:,1), Probe1in(:,2), Probe1in(:,3), ...
%     %         'k.', 'MarkerSize', 10)  
%     % plot3( Probe2in(:,1), Probe2in(:,2), Probe2in(:,3), ...
%     %         'k.', 'MarkerSize', 10 )
% 
%     plot3( AllProbes(:,1), AllProbes(:,2), AllProbes(:,3), ...
%             'r.', 'MarkerSize', 10 )
%     axis equal

%
% count = 0;



max_vals = max(TargetPoints);
min_vals = min(TargetPoints);



for i=1:length(x1)


    
    %Find out which probe point the querry point is closest to.
    [dist1, centerIDX1] =  min(sqrt((x1(i)-AllProbes(:,1)).^2  + (y1(i)-AllProbes(:,2)).^2  +...
                               (z1(i)-AllProbes(:,3)).^2)  );
    center = AllProbes( centerIDX1 ,:);


    %find the midpoint between the probe point and the target point
    midpointSearch = (center + [x1(i),  y1(i), z1(i)]) / 2;
    

    %find out which target point, the querry point is closest to.

    [dist1, idx1] = min( sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2) ); 


    [dist2, idx2] =  min( sqrt( (midpointSearch(1) - x2).^2+ ...
                              (midpointSearch(2) - y2).^2+ ...
                              (midpointSearch(3) - z2).^2) ); 
    idx = idx2;
    dist = dist2;

    %if the ablation boundary point is really close to the query point
    if dist1 < 2.5
        idx = idx1;
        dist  = dist1;
    end 

    I = idx(1);    



    %Calculate the 
    % 1. distance between the target point and the "center"  
    % 2. distance between the querry point and the "center"  
    vectorT = sqrt( ( center(1) -x2(I) ).^2 + ( center(2) -y2(I) ).^2+...
                   ( center(3) -z2(I) ).^2) ;            

    vectorB = sqrt( ( center(1) -x1(i) ).^2 + ( center(2) -y1(i) ).^2+...
                    ( center(3) -z1(i) ).^2)    ; 


    % Check each target point
    A = [ x1(i), y1(i), z1(i)]; 
    inside_mask = all(A >= min_vals & A <= max_vals, 2);

    if vectorT > vectorB 
        dist = dist*-1;
    else
        dist = dist;
    end 

    if inside_mask == 0
         dist = dist;
    end 

    distances=[ distances; dist] ;


    % hold on
    % plot3( x1(i), y1(i), z1(i), '.k')
    % plot3( x2(I), y2(I), z2(I), '.r')
    % plot3( center(1), center(2), center(3), '+')
    % 
    % count = count  + 1;
    % if count == 2000        
    %     pause(.1)
    %     count = 0;
    %     title( join([ "QuerryIDX: ", num2str(i), newline, "TargetIDX:", num2str(I)  ]) )
    %     axis equal 
    % end 
end


% QUERRY POINTS ARE THE IMAGE GRID
% x1 = QuerryPointsOG(:,1);
% y1 = QuerryPointsOG(:,2);
% z1 = QuerryPointsOG(:,3);
% distances = distances;
% 
% TARTGET IS THE ABLATION 
% x2 = TargetPoints(:,1);
% y2 = TargetPoints(:,2);
% z2 = TargetPoints(:,3);
% 
% 
% 
% TODO
% Create a new loop that finds all the points that are within 40 units away
% from the veneter of the average of the target points. 
% start from the outer edge of this search area. ie the points that the
% closest ro 40 units away and move in to the points that are almost 0
% units away. 
% With that estabished. 
% find the value that represent the 10% lowest value in the distances.
% 
% Here are the following conditions for the current point (pi)
% 1. the current point (pi) distance is positive or zero
% 2. find the 10 closest points to the current point (pi).  if one of those points
% has a value that is equal to or lower than the lowest 10% value.
% 
% with these conditions meet, then
% find the distance between the current point (pi)  and the point with the low
% value (lpv). use the formula: (distance value of lpv) - (distance between pi and lpv).
% This value is now the new distance value of (pi). 
% Keep track of the location of (pi) with respect to the incies of the imported data. 
% Do this throughout the entire code. 





end 
