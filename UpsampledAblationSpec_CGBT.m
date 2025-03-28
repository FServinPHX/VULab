




function [UpsampledPoints] = UpsampledAblationSpec_CGBT(NewPoints, numpoints)
%UPSAMPLEABLATIONSPEC Generates upsampled 3D points based on the proximity
%of the original points.
%  NewPoints: Nx3 matrix where each row is a point (x, y, z).
%  numpoints: Total desired number of points after upsampling.
%  UpsampledPoints: Resulting matrix of upsampled points.

% Extract individual coordinates
x1 = NewPoints(:,1);
y1 = NewPoints(:,2);
z1 = NewPoints(:,3);

%----------------------------------------------------------------------------------------%
% Sort the Points by computing a 'spectral shape' based on their distance average
% Compute mean distance from each point to all others
distances = arrayfun(@(i) mean( sqrt((x1(i)-x1).^2 + (y1(i)-y1).^2 + (z1(i)-z1).^2) ), 1:length(x1));

% Normalize the distances
distances = distances / max(distances);

% Sort the distances in ascending order to find orderly proximity
[~, I_DS] = sort(distances, 'ascend');

%----------------------------------------------------------------------------------------%
% Identify the origin point nearest to all other points
i = I_DS(1);
% Reorder NewPoints from closest to furthest from this origin
[~, I_DS] = sort( sqrt((x1(i)-x1).^2 + (y1(i)-y1).^2 + (z1(i)-z1).^2), 'ascend');
NewPoints = NewPoints(I_DS, :);

% Update reordered coordinates
x1 = NewPoints(:,1);
y1 = NewPoints(:,2);
z1 = NewPoints(:,3);

% Prepare to distribute a given number of points uniformly along the sorted distances
n = numpoints; % number to be divided
maxNum = length(x1); % max number of original points

% Initialize a summation array to ensure a uniform contribution from each group
sizeArray = ceil(n / maxNum);
summationArray = zeros(1, sizeArray);

% Distribute numpoints into the summation array until used
while n > 0
    minValue = min(n, maxNum); % Determine smallest usable segment
    firstNonZeroIdx = find(summationArray == 0, 1); % Identify unfilled position
    summationArray(firstNonZeroIdx) = minValue; % Fill position in summationArray
    n = n - minValue; % Decrease remaining points
end

% Remove the first element if zero; not involved in process
summationArray = summationArray(2:end);

%----------------------------------------------------------------------------------------%
% Initialize newpoints collection for upsampling points
newpoints = [];
AllPts = [x1, y1, z1];

for k = 1:length(summationArray)
    % Calculate pairwise Euclidean distances
    distances = pdist(AllPts);
    distMatrix = squareform(distances); % Convert to matrix form
    MinDist = mean(min(distMatrix, [], 2)); % Determine an average minimal separation

    upsampleC = summationArray(k); % Current point group size for iterative upsample

    % Generate newpoints for this cluster section
    for i = 1:upsampleC
        [dist, idx] = sort(sqrt((x1(i)-x1).^2 + (y1(i)-y1).^2 + (z1(i)-z1).^2));

        stop = 1;
        j = 1;
        newpoint = [];

        % Iterate to find appropriate midpoints
        while stop > 0
            if dist(j) > MinDist && dist(j) < 10 % Avoid clustering overly close points
                I = idx(j);
                newpoint = [ (x1(i) + x1(I))/2, (y1(i) + y1(I))/2, (z1(i) + z1(I))/2 ];
            end

            if j > 10 % Allow ample search before termination
                stop = -1;
            end
            j = j+1;
        end

        newpoints = [newpoints; newpoint];
    end

    % Append all processed points; continue process
    AllPts = [x1, y1, z1; newpoints]; 
end

% Reassess and finalize collection of ablation points to fit numpoints
Pablation = [x1, y1, z1]; % Consolidate the initial points
if size(Pablation, 1) > numpoints
    b = numpoints - size(Pablation, 1);
    Pablation = Pablation(b:end, :); % Trim excess points
end

% Compile all upsampled and original points
UpsampledPoints = [Pablation; newpoints];

end