

 function [ UpsampledPoints ] = UpsampledAblationSpecRange( NewPoints, numpoints,...
                                                            lower, upper, MaxIteration ) 

                                                                                                                        
x1 = NewPoints(:,1);
y1 = NewPoints(:,2);
z1 = NewPoints(:,3);

%----------------------------------------------------------------------------------------%
%Sort the Points by creating a spectral shape
distances=[ ]; 
for i=1:length(x1)
    
    [dist] =  mean( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2) );
    distances=[ distances,dist] ;
    
end
%Normalize the distances 
distances = distances/ max(distances);
%Sort the distances in ascending order
[DistSort, I_DS] =  sort(distances, 'ascend'); 
%find the point that is most closest to all other points 
i = I_DS(1); 
%sort the remainingn points from furthest to closest. 
[dist, I_DS] = sort( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2), 'ascend'); 


%----------------------------------------------------------------------------------------%
NewPoints = NewPoints(I_DS, :); 
x1 = NewPoints(:,1);
y1 = NewPoints(:,2);
z1 = NewPoints(:,3);


n = numpoints; % number to be divided
maxNum = length(x1); % maximum number allowed in summation array

% Initialize array to hold the summation values
sizeArray = ceil( n/maxNum);
summationArray = zeros(1, sizeArray);

while n > 0
    % Find the minimum value between n and maxNum
    minValue = min(n, maxNum);
    
    % Find the index of the first non-zero element in the summationArray
    firstNonZeroIdx = find(summationArray == 0, 1);
    
    % Update the element in summationArray
    summationArray(firstNonZeroIdx) = minValue;
    
    % Subtract the minimum value from n
    n = n - minValue;
end
summationArray = summationArray(2:end); 
% 
% % Display the summation array
%  disp(summationArray);
%  disp(maxNum)



%------------------%
newpoints=  [];

for k = 1:length(summationArray)
    
    upsampleC = summationArray(k); 
    
    for i=1:upsampleC
        [ dist, idx ] =  sort( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2) );
        %find the midpoint between the two closest points
        stop = 1;
        j = 1;
        newpoint = [];
        
        while  stop >0
            
            if dist(j) > lower && dist(j) < upper
                I = idx(j);
                newpoint = [ (x1(i) + x1(I))/2,  (y1(i) + y1(I))/2,  (z1(i) + z1(I))/2  ]; 
            end 
            
            if j > MaxIteration
                stop = -1;
            end  
            j = j+1;
        end        
        newpoints=[ newpoints; newpoint] ;
    end
end 



% The ablation points are now re-defined, also check to make sure that the
% number of points does not exceeed the defined number of points. 
Pablation = [x1, y1, z1];
if size(Pablation,1) > numpoints
    
    b = numpoints - size(Pablation,1);
    Pablation  =  Pablation( b:end, :);
    
end
    UpsampledPoints = [ Pablation; newpoints]; 


    
 end 




