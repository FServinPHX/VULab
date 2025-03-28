


function [ Ablation1, Ablation2 ] = DualAblationCombineSeparate( TargetPoints1 , TargetPoints2, probe1,  probe2 ) 


% TargetPoints1  =Abl.AP_Probe1;
% TargetPoints2 = Abl.AP_Probe2;
% probe1 = e1;
% probe2 = e2;


%TARTGET 1 IS ABLATION 1
x1 = TargetPoints1(:,1);
y1 = TargetPoints1(:,2);
z1 = TargetPoints1(:,3);

%TARTGET 2 IS ABLATION 2
x2 = TargetPoints2(:,1);
y2 = TargetPoints2(:,2);
z2 = TargetPoints2(:,3);

%           %outde the tumor
distances = [];
distances1 = [];
distances2 = []; 

for i=1:length(x1)
    
    
    %Decide if the first Ablation Cloud Is Inside the SECOND Ablation Cloud
    [dist2, centerIDX2] =  min(sqrt((x1(i)-probe2(:,1)).^2+(y1(i)-probe2(:,2)).^2+(z1(i)-probe2(:,3)).^2));
    center2 = probe2( centerIDX2 ,:);
    
    
    %establish the new center and calculate the distance between the
    %closest ablation boundary point and {query point, probe point}    
    %If probe 1 is closer 
    center  = center2;
    
    [dist, idx] = min( sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2) ); 
    I = idx(1);     
    
    vectorT = sqrt( ( center(1) -x2(I) ).^2 + ( center(2) -y2(I) ).^2+...
                   ( center(3) -z2(I) ).^2) ; 

                         
    %Calculate the distance between the querry point and the center of the
    %probe
    vectorB = sqrt( ( center(1) -x1(i) ).^2 + ( center(2) -y1(i) ).^2+...
                    ( center(3) -z1(i) ).^2)*1.04 ; 
          
    if vectorT > vectorB
        dist = dist*-1;
    else
        dist = dist;
    end 

    distances1=[ distances1,dist] ;
end



for i=1:length(x2)
   
    %Decide if the Second Ablation Cloud Is Inside the First Ablation Cloud
    
    
    [dist1, centerIDX1] =  min(sqrt((x2(i)-probe1(:,1)).^2+(y2(i)-probe1(:,2)).^2+(z2(i)-probe1(:,3)).^2));
    center1 = probe1( centerIDX1 ,:);
   
    %establish the new center and calculate the distance between the
    %closest ablation boundary point and {query point, probe point}    
    %If probe 1 is closer 
    center  =center1;
    
    [dist, idx] = min( sqrt((x2(i)-x1).^2+(y2(i)-y1).^2+(z2(i)-z1).^2) ); 
    I = idx(1);  
    
    vectorT = sqrt( ( center(1) -x1(I) ).^2 + ( center(2) -y1(I) ).^2+...
                   ( center(3) -z1(I) ).^2) ;                       
                         
    %Calculate the distance between the querry point and the center of the
    %probe
    vectorB = sqrt( ( center(1) -x2(i) ).^2 + ( center(2) -y2(i) ).^2+...
                    ( center(3) -z2(i) ).^2)*1.04 ; 
          
    if vectorT > vectorB
        dist = dist*-1;
    else
        dist = dist;
    end 

    distances2=[ distances2,dist] ;
    
end    
    




    %----------------------------------------------------------------%
    NewAblation1 = [ x1, y1, z1]; 
    AllDistances1 = distances1';

    % get the idx of points that intersect
    AllDistancesidx1 = AllDistances1; 
    AllDistancesidx1(AllDistancesidx1 < .5) = nan; 
    AllDistancesidx1 = AllDistancesidx1./AllDistancesidx1; 
    %
    Ablation1 =  [NewAblation1, AllDistances1] .*AllDistancesidx1 ; 
    Ablation1(any(isnan(Ablation1),2),:)=[] ; 
    Ablation1 = Ablation1( :, 1:3 );
    
    
    %----------------------------------------------------------------%
    NewAblation2 = [ x2, y2, z2]; 
    AllDistances2 = distances2';

    % get the idx of points that intersect
    AllDistancesidx2 = AllDistances2; 
    AllDistancesidx2(AllDistancesidx2 < .5) = nan; 
    AllDistancesidx2 = AllDistancesidx2./AllDistancesidx2; 
    %
    Ablation2 =  [NewAblation2, AllDistances2] .*AllDistancesidx2 ; 
    Ablation2(any(isnan(Ablation2),2),:)=[] ; 
    Ablation2 = Ablation2( :, 1:3);

end 
 

    

% figure()
% colormap jet 
% s1 = repmat(5, 1, length(distances1)  );
% scatter3(x1, y1, z1, s1, distances1)
% hold on
% 
% s2 = repmat(5, 1, length(distances2)  );
% scatter3(x2, y2, z2, s2, distances2)
% % plot3( x2, y2, z2, '.', 'color', 'k')
% % plot3( x3, y3, z3, '.', 'color', 'b')
% colorbar
% axis equal



% figure()
% s3 = repmat(5, 1, length( AllData(:,4) )  );
% scatter3( AllData(:,1),  AllData(:,2), AllData(:,3), s3, AllData(:,4))
% colorbar
% axis equal

