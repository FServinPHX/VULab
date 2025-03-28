

 %function [ UpsampledPoints ] = UpsampledAblationSpec( NewPoints, numpoints ) 

numpoints =6000;
x1 = NewPoints(:,1);
y1 = NewPoints(:,2);
z1 = NewPoints(:,3);
%
x2 = NewPoints(:,1);
y2 = NewPoints(:,2);
z2 = NewPoints(:,3);


%----------------------------------------------------------------------------------------%
    %Sort the Points by creating a spectral shape
    distances=[ ]; 
    for i=1:length(x1)
        
        [dist] =  mean( sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2) );
        distances=[ distances,dist] ;
        
    end
    %Normalize the distances 
    distances = distances/ max(distances);
    %Sort the distances in ascending order
    [DistSort, I_DS] =  sort(distances, 'ascend'); 
    %find the point that is most closest to all other points 
    i = I_DS(1); 
    %sort the remainingn points from furthest to closest. 
    [dist, I_DS] = sort( sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2), 'ascend'); 
    %----------------------------------------------------------------------------------------%
    NewPoints = NewPoints(I_DS, :); 
    % x1 = NewPoints(:,1);
    % y1 = NewPoints(:,2);
    % z1 = NewPoints(:,3);




    %n = numpoints; % number to be divided
    % maximum number allowed in summation array
    TargetPoints = numpoints - length(x1);




    sampledPts=  [];
    stop = 0;
    minTol = .5; 
    %
    count = 1;
    iterationArray = []; 
    BreakMainLoop = 1;
    while count < 60 && BreakMainLoop == 1

        minTolerance = minTol.* count;
        

        disp("Count")
        disp(count)
        % Create a 300-point point cloud with random x, y, z coordinates
        pointCloud = [x1, y1, z1];
        % Compute pairwise Euclidean distances between points
        distances = pdist(pointCloud);
        % Convert the distance vector to a square form matrix
        distMatrix = squareform(distances);
        % Set the diagonal to infinity to ignore zero distance (distance to itself)
        distMatrix(distMatrix == 0) = Inf;
        % Sort each row of the distance matrix and take the third-closest distance
        sortedDistances = sort(distMatrix, 2);
        xClosest = sortedDistances(:, 1);
        % Find the median of the third-closest distances
        
        medianXClosest = mean(xClosest) + std(xClosest)*1.2;
        %medianXClosest = median(xClosest);
        % Find indices of the points whose third-closest distance is greater than the median
        indicesGreaterMedian = find(xClosest > medianXClosest);
        indicesGreaterMinNum = find(xClosest > minTolerance);
        %
        %
        BestIndices = unique( [indicesGreaterMedian;  indicesGreaterMinNum] );
        MaxNum = max(xClosest);
        %
        if minTolerance < medianXClosest
            MinNum = minTolerance; 
        elseif medianXClosest < minTolerance
            MinNum = medianXClosest; 
        end 
     
    
    
        numSample = length(BestIndices); 
        %
        %
        MaxiterCount = (TargetPoints) - length(sampledPts);
        
        if MaxiterCount < numSample && MaxiterCount>0
            numSample = MaxiterCount;

        elseif MaxiterCount < numSample && MaxiterCount<0
            %numSample = 1;
            numsample =  length(BestIndices);
            count = 20;
            disp("STOP MaxiterCount Exceed")           
        end 
        

        iterationArray = [ iterationArray ; TargetPoints, length(sampledPts), MaxiterCount, numSample];
        

        BreakLoop = 1;
        i =1;
        CurrentPoints = [];
        % x1  = pointCloud(:,1); 
        % y1  = pointCloud(:,2);
        % z1  = pointCloud(:,3);
        while( i <= numSample && BreakLoop == 1) 
        


                ibst = BestIndices(i); 
                [ dist, idx ] =  sort( sqrt( (x1(ibst)-x2).^2   + ...
                                             (y1(ibst)-y2).^2   +...
                                             (z1(ibst)-z2).^2) );
                %find the midpoint between the two closest points
                stop = 1;      SampPt = [];

                % j = randi([1, 4]);

                for j = 1:200
                % while  stop >0
                    if dist(j) > 0 && dist(j) < MaxNum
                        I = idx(j);
                        SampPt = [   (x1(ibst) + x2(I))/2,  ...
                                     (y1(ibst) + y2(I))/2,  ....
                                     (z1(ibst) + z2(I))/2  ]; 
                        stop = -1;
                    end 
                end 


            if length(sampledPts) < (TargetPoints)
                 sampledPts=[ sampledPts; SampPt] ;
                 CurrentPoints = [CurrentPoints;  SampPt] ;
            end 
            if  length(sampledPts) >= (TargetPoints-1) 
                BreakMainLoop = 0;
                BreakLoop = 0; 
                i = numSample;
                disp("STOP Fulfilled Points")
            end 

        i = i+1;
      end



x1 = [NewPoints(:,1); sampledPts(:,1)];    
y1 = [NewPoints(:,2); sampledPts(:,2)];
z1 = [NewPoints(:,3); sampledPts(:,3)];

x2 = [NewPoints(:,1); sampledPts(:,1)];    
y2 = [NewPoints(:,2); sampledPts(:,2)];
z2 = [NewPoints(:,3); sampledPts(:,3)];






count = count + 1  ;

    end 



% The ablation points are now re-defined, also check to make sure that the
% number of points does not exceeed the defined number of points. 
Pablation = NewPoints;
if size(Pablation,1) > numpoints
    
    b = numpoints - size(Pablation,1);
    Pablation  =  Pablation( b:end, :);
    
end


    UpsampledPoints = [ Pablation; sampledPts]; 




figure()
scatter3(UpsampledPoints(:,1) , UpsampledPoints(:,2), ...
         UpsampledPoints(:,3), 15, 'filled', 'k')
axis equal


hold on 
x1 = NewPoints(:,1);
y1 = NewPoints(:,2);
z1 = NewPoints(:,3);
scatter3(x1, y1, z1, 20, 'filled', 'r')
axis equal
    
% end 




