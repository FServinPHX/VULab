%  function [ nextPoint ] = NewTriangulate( TargetPoints ) 

% A = [14 8 91 19]
% [out,idx] = sort(A)
% A(idx)
close all
% TargetPoints = ptsMulti;
% BoundaryPointsOG = ptsSingle;
% center = [0,0,0]; 
%QuerryPointsOG = TargetPoints; 
QuerryPointsOG = BoundaryPoints.new;

% x1 = QuerryPointsOG(:,1);
% y1 = QuerryPointsOG(:,2);
% z1 = QuerryPointsOG(:,3);

% Reorganize points based on z-component
[~, sortedIndices] = sort(QuerryPointsOG(:, 3));
reorganizedPoints = QuerryPointsOG(sortedIndices, :);
QuerryPointsOG = reorganizedPoints;
triangulateMatrix = [];  
nextPoint = []; 
x1 = QuerryPointsOG(:,1);
y1 = QuerryPointsOG(:,2);
z1 = QuerryPointsOG(:,3);


%------------------------------------------------------------------------------------%
% %Sort the Points by creating a spectral shape
% distances=[ ]; 
% for i=1:length(x1)
%     
%     [dist] =  mean( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2) );
%     distances=[ distances,dist] ;
%     
% end
% %Normalize the distances 
% distances = distances/ max(distances);
% %Sort the distances in ascending order
% [DistSort, I_DS] =  sort(distances, 'ascend'); 
% %find the point that is most closest to all other points 
% i = I_DS(1); 
% %sort the remainingn points from furthest to closest. 
% [dist, I_DS] = sort( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2), 'ascend'); 
% 
% QuerryPointsOG = QuerryPointsOG(I_DS, :); 
% x1 = QuerryPointsOG(:,1);
% y1 = QuerryPointsOG(:,2);
% z1 = QuerryPointsOG(:,3);
%------------------------------------------------------------------------------------%

Ic = 1;
for i=1:length(x1)
    

    %for k = 1:1
    %Ic
    %if ~isnan(x1(i)) 
        
         [dist, idx] = sort( sqrt((x1(Ic)-x1).^2+(y1(Ic)-y1).^2+(z1(Ic)-z1).^2), 'ascend'); 
         %[dist, idx] = sort( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2), 'ascend'); 
         I = idx(2);     I2 = idx(3);     I3 = idx(4);

         %triangulateMatrix  =  [ triangulateMatrix; I, I2, I3];   
         nextPoint = [nextPoint; Ic, I];
         
         x1( Ic ) = nan; % x1(I2) = nan;  x1(I3) = nan;
         y1( Ic ) = nan;  %y1(I2) = nan;  y1(I3) = nan;
         z1( Ic ) = nan; % z1(I2) = nan;  z1(I3) = nan;
         Ic = I; 
%     else
%         id = 1;
%     end 
% end 

end


% Step 2: Create the remixed array
remixedArray=  [nextPoint(1)];
count = 1;
for i = 2:length(nextPoint)
    remixedArray = [remixedArray, nextPoint(i)]; 
    if count == 2
         remixedArray = [remixedArray, nextPoint(i)];
         count = 0;
    end 
    count = count+1;
end 
rmxd.floorNum = floor( length(remixedArray)/3);
rmxd.NewArr =  reshape(remixedArray(1:(rmxd.floorNum*3) ), 3, rmxd.floorNum )';
TriangulateMat = rmxd.NewArr;



%%
% end
figure()
x1 = QuerryPointsOG(:,1);
y1 = QuerryPointsOG(:,2);
z1 = QuerryPointsOG(:,3);
scatter3( x1, y1 , z1,  'k')
axis equal
hold on


%%
newQuerryPointsOG = QuerryPointsOG(nextPoint,:); 
x =  newQuerryPointsOG(:,1);
y =  newQuerryPointsOG(:,2); 
z =  newQuerryPointsOG(:,3); 
colorPoint = jet( length(nextPoint) ); 
count =1;
for i = 1:length(x)
    
    a = (i-1)*2+1 ;
    b = (i-1)*2+3 ;
   
    colorPoint = jet( length(nextPoint) );
    plot3( x(a:b), y(a:b), z(a:b),  'Color', colorPoint(i, :)  )
    plot3( x(a:b), y(a:b), z(a:b), '.', 'Color', colorPoint(i, :)  )
    %plot3( x(i), y(i), z(i), '.',  'Color', colorPoint(i, :)  )
    
%     I = nextPoint(i);
%     plot3( x1(I), y1(I), z1(I), '.',  'Color', colorPoint(i, :)  )
    
count = count +1;

if count == 100
    pause(.25)
    count = 0;
end 
    

end 

hold off


 
