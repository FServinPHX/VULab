

clc
close all
%
% figure
%     plot3( e1(:,1),  e1(:,2),  e1(:,3), 'r+')
%     hold on
%     plot3( e2(:,1),  e2(:,2),  e2(:,3), 'k+')
%     axis equal 
%     % center1 = e1(end ,:);
%     % center2 = e2(end ,:);
%     center1 = mean(e1);
%     center2 = mean(e2);
%     plot3( center1(1),  center1(1),  center1(1), 'r+')
%     plot3( center2(1),  center2(1),  center2(1), 'k+')
%     axis equal 


% Text string
%text = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v2\ PsiTheta1_ 0 - 0 PsiTheta2_ 0 - 45Points_a_Vectors.csv';
        text = filePath;
        % Regular expression to extract psi1, theta1, psi2, theta2
        % Breakdown: 
        % - 'PsiTheta1_ (\d+) - (\d+)' extracts "0 - 0" as psi1 and theta1
        % - 'PsiTheta2_ (\d+) - (\d+)' extracts "0 - 45" as psi2 and theta2
        %regex = 'PsiTheta1_\s*(\d+)\s*-\s*(\d+)\s*PsiTheta2_\s*(\d+)\s*-\s*(\d+)';
        % regex = 'PsiTheta1_\s*(\d+\.\d+)\s*-\s*(\d+\.\d+)\s*PsiTheta2_\s*(\d+\.\d+)\s*-\s*(\d+\.\d+)';
        % tokens = regexp(text, regex, 'tokens');

        % Regular expression to extract all numbers (including decimals)
        pattern = '\d+\.\d+|\d+'; % Match numbers with decimals and integers
        % Use regexp to find all matches
        tokens = regexp(text, pattern, 'match');
        % Convert the extracted string numbers to double
        numericValues = str2double(tokens);

        % Extract and convert the values to numeric
        if ~isempty(tokens) 
            Ltokns = size(tokens,2);
            psi1 = str2double(tokens{Ltokns-3});
            theta1 = str2double(tokens{Ltokns-2});
            psi2 = str2double(tokens{Ltokns-1});
            theta2 = str2double(tokens{Ltokns});
        else
            error('No match found');
        end
        % Display values
        fprintf('psi1 = %d, theta1 = %d, psi2 = %d, theta2 = %d\n', psi1, theta1, psi2, theta2);


%
length = 20;
% mean(e1)
% mean(e2)
%Create New Antennae
e1_2 = plot3DLineFromSpherical(psi1, theta1, (mean(e1)), length);
e2_2 = plot3DLineFromSpherical(psi2, theta2, (mean(e2)), length);
%
figure
plot3( e1(:,1),  e1(:,2),  e1(:,3), 'r+')
hold on
plot3( e2(:,1),  e2(:,2),  e2(:,3), 'k+')
plot3( e1_2(:,1),  e1_2(:,2),  e1_2(:,3), 'r+')
plot3( e2_2(:,1),  e2_2(:,2),  e2_2(:,3), 'k+')
%
intervalVectorData = vectorData(:, :, 3);
plot3( intervalVectorData(:,1), intervalVectorData(:,2), intervalVectorData(:,3), '.',...
      'MarkerSize', 4, 'Color', 'red');  
%
%
plot3(TargetPointCloud(:, 1), TargetPointCloud(:, 2), TargetPointCloud(:, 3), '.' ,...
      'MarkerSize', 4, 'Color', 'blue');
axis equal 

%
% target1 = (mean(e1) + mean(e1_2))/2;
% target2 = (mean(e2) + mean(e2_2))/2;

target1 = mean(e1) ;
target2 = mean(e2) ;
pointCloud = TargetPointCloud;
PHI_THETA_LABEL1 = fn_ThetaPhi_ptcld_TargetRelation(pointCloud, target1, target2) ;


target1 = mean(e1) ;
target2 = mean(e2) ;
pointCloud2 = [intervalVectorData(:,1), intervalVectorData(:,2), intervalVectorData(:,3)];
PHI_THETA_LABEL2 = fn_ThetaPhi_ptcld_TargetRelation(pointCloud2, target1, target2) ;

%


% % Constants
% numRows = 2600;
% numCols = 3;
% % Create matrices A and B
% A = [rand(numRows, 2) * 360 - 180, randi([1, 2], numRows, 1)]; % 360 degrees range shifted by -180
% B = [rand(numRows, 2) * 360 - 180, randi([1, 2], numRows, 1)];


A = PHI_THETA_LABEL1;
B = PHI_THETA_LABEL2;
% Initialize array to store the indices of the closest rows in B for rows in A
closestIndices = zeros(size(A,1), 1);
% Iterate over each row in A

for i = 1:numRows
    % Current row in A
    currentRow = A(i, :);
    
    % Filter rows of B to match the third column of the current row in A
    matchingRows = B(B(:,3) == currentRow(3), :);
    
    % Find the closest row in B (filtered by third column)
    if ~isempty(matchingRows)
        distances = sqrt(sum((matchingRows(:,1:2) - currentRow(1:2)).^2, 2));
        [~, idx] = min(distances);
        % Since matchingRows are filtered rows of B, we need to find the original index in B
        originalIndices = find(B(:,3) == currentRow(3));
        closestIndices(i) = originalIndices(idx);
    else
        closestIndices(i) = NaN; % Indicate no matching row was found
    end
end

% Display results (or use them for further processing)
%

A = pointCloud;
B = pointCloud2;
    PLOTFIG = "TRUE";
    if PLOTFIG == "TRUE"
        % Plotting the results
        figure;
        hold on;
        grid on;
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        %
        for i = 1:numPoints

            point = A(i, :);
            target1 = B( closestIndices(i), :);
            %
            plot3(point(1) , point(2), point(3) , 'k.', MarkerSize= 10);    
            plot3(target1(1), target1(2), target1(3), 'r.', MarkerSize= 10);
            % Connect to target 1
            plot3([point(1)  target1(1)], ...
                   [point(2) target1(2)], ...
                   [point(3) target1(3)], 'b');
        end
        %
        % Optionally add target points to the plot

    
        hold off;
        axis equal 
    end 




%%





% %%
% 
% % Generate a random point cloud
% numPoints = 100;
% pointCloud = (rand(numPoints, 3) * 25) - [5,5,5]; % 100 points in a 10x10x10 space
% 
% % Define two target points
% target1 = [5, 5, 5];
% target2 = [10, 10, 10];
% 
% % Initialize variables
% labels = zeros(numPoints, 1);
% angles = zeros(numPoints, 2); % First column for phi, second for theta
% 
% % Determine the closest target for each point in the point cloud
% for i = 1:numPoints
%     point = pointCloud(i, :);
%     dist1 = norm(point - target1);
%     dist2 = norm(point - target2);
% 
%     % Label assignment by proximity
%     if dist1 < dist2
%         labels(i) = 1;
%         closestTarget = target1;
%     else
%         labels(i) = 2;
%         closestTarget = target2;
%     end
% 
%     % Calculate angles
%     [azimuth, elevation, ~] = cart2sph(closestTarget(1) - point(1), closestTarget(2) - point(2), closestTarget(3) - point(3));
%     angles(i, 1) = rad2deg(azimuth);
%     angles(i, 2) = rad2deg(elevation);
% end
% PHI_THETA_LABEL = [angles, labels];
% 
% % Start plotting
% figure;
%     hold on;
%     grid on;
%     xlabel('X');
%     ylabel('Y');
%     zlabel('Z');
%     title('Point Cloud with Target Connections');
% % Plot lines between points and their nearest targets
% for i = 1:numPoints
%     point = pointCloud(i, :);
%     plot3(point(1) , point(2), point(3) , 'k.', MarkerSize= 10);
%     if labels(i) == 1
%         plot3([point(1) target1(1)], [point(2) target1(2)], [point(3) target1(3)], 'b');
%     else
%         plot3([point(1) target2(1)], [point(2) target2(2)], [point(3) target2(3)], 'r');
%     end
% end
% % Mark the target points
% plot3(target1(1), target1(2), target1(3), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 10);
% plot3(target2(1), target2(2), target2(3), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 10);
% hold off;
% axis equal


% numPoints = 100;
% pointCloud = (rand(numPoints, 3) * 25) - [5,5,5]; % 100 points in a 10x10x10 space
% % Define two target points
% target1 = [5, 5, 5];
% target2 = [10, 10, 10];
% PHI_THETA_LABEL2 = fn_ThetaPhi_ptcld_TargetRelation(pointCloud, target1, target2)  







