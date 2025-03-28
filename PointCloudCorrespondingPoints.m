

% % Step 1: Create two 3D point clouds A and B with 200 points
% num_points = 2000;
% % Generate random points within the specified range [0, 100] in x, y, and z
% A = rand(num_points, 3) * 100;
% B = rand(num_points, 3) * 100;
% 
%
% A = TargetPointCloud;
% B = [intervalVectorData(:,1), intervalVectorData(:,2), intervalVectorData(:,3)];
% num_points = length(A);


function [MatrixPairSorted] = LinkedPointCorrespond(A,B)



% Create a copy of the original matrices for final visualization
A_copy = A;
B_copy = B;
 num_points = length(A);
% Initialize containers for point pairs and their indices
point_indices_A = zeros(1, num_points);
point_indices_B = zeros(1, num_points);
point_pair_A = [];
point_pair_B = [];
pair_count = 1;

%
% Iterate until all point pairs within __cm are found
min_dist = 0; 
min_num = 5;
while  min_dist < min_num || pair_count<= num_points
    % Step 2: Find the closest unique point pair from A to B
    dist_matrix = pdist2(A, B);
    min_dist = min(dist_matrix(:));
    
    if min_dist < min_num
        [idx_A, idx_B] = find(dist_matrix == min_dist, 1);

        % Step 4: Record the actual point pair and delete the point values
        point_pair_A = [point_pair_A ;A(idx_A,:)];
        point_pair_B = [point_pair_B ;B(idx_B,:)];
        A(idx_A, :) = [];
        B(idx_B, :) = [];
    end
    % Increment pair count
    pair_count = pair_count + 1;
    
end

% Initialize containers for matching point indices
matching_indices_A = zeros(size(point_pair_A, 1), 1);
matching_indices_B = zeros(size(point_pair_B, 1), 1);
% Iterate through each point in A
for i = 1:size(point_pair_A, 1)
    % Find the matching point index in B
    [~, matching_indices_A(i)] = ismember(point_pair_A(i, :), A_copy, 'rows');
end
% Iterate through each point in B
for i = 1:size(point_pair_B, 1)
    % Find the matching point index in A
    [~, matching_indices_B(i)] = ismember(point_pair_B(i, :), B_copy, 'rows');
end



pause(.1)

%


% Iterate until all point pairs greater than __cm are found
B = B_copy;
point_pair_AII = [];
point_pair_BII = [];
num_pointsII = num_points - length(point_pair_A);

% while  min_dist < min_num && pair_count <= num_pointsII
for i = 1:num_pointsII
    
    % Step 2: Find the closest unique point pair from A to B
    pA = A(1,:);
    dist_matrix = pdist2(pA, B);
    min_dist = min(dist_matrix(:));
    

    [idx_A, idx_B] = find(dist_matrix == min_dist, 1);

    % Step 4: Record the actual point pair and delete the point values
    point_pair_AII = [point_pair_AII ;A(1,:)];
    point_pair_BII = [point_pair_BII ;B(idx_B,:)];
    A(idx_A, :) = [];

    
    
end


%Initialize containers for matching point indices
matching_indices_AII = zeros(size(point_pair_AII, 1), 1);
matching_indices_BII = zeros(size(point_pair_BII, 1), 1);
% Iterate through each point in A
for i = 1:size(point_pair_AII, 1)
    % Find the matching point index in B
    [~, matching_indices_AII(i)] = ismember(point_pair_AII(i, :), A_copy, 'rows');
end
% Iterate through each point in B
for i = 1:size(point_pair_BII, 1)
    % Find the matching point index in A
    [~, matching_indices_BII(i)] = ismember(point_pair_BII(i, :), B_copy, 'rows');
end






pause(.1)


PlotResults = "FALSE";

if PlotResults == "TRUE"
    % Visualize the point pairs by drawing lines
    figure;

    % Plot original point clouds A and B
    scatter3(A_copy(:,1), A_copy(:,2), A_copy(:,3), 'r', 'filled');
    hold on;
    scatter3(B_copy(:,1), B_copy(:,2), B_copy(:,3), 'b', 'filled');
    title('Original Point Clouds A and B');

    %
    % Draw lines between the point pairs
    for i = 1:length(matching_indices_A)
        line([A_copy(matching_indices_A(i), 1) B_copy(matching_indices_B(i), 1)], ...
            [A_copy(matching_indices_A(i), 2) B_copy(matching_indices_B(i), 2)], ...
            [A_copy(matching_indices_A(i), 3) B_copy(matching_indices_B(i), 3)], 'Color', 'k');
    end


    % Draw lines between the point pairs
    for i = 1:length(matching_indices_AII)
        line([A_copy(matching_indices_AII(i), 1) B_copy(matching_indices_BII(i), 1)], ...
            [A_copy(matching_indices_AII(i), 2) B_copy(matching_indices_BII(i), 2)], ...
            [A_copy(matching_indices_AII(i), 3) B_copy(matching_indices_BII(i), 3)], 'Color', 'g');
    end

    % Adjust subplot spacing
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal
end 


%

MatrixPair = [ matching_indices_A,matching_indices_B;...
               matching_indices_AII, matching_indices_BII];
% Reorder the numbers in the first column while preserving the pairs in the second column
[~, sorted_indices] = sort(MatrixPair(:, 1));  % Sort the first column
MatrixPairSorted = MatrixPair(sorted_indices, :);  % Apply the sorting to the entire matrix

end 



