


function [new_vectors] =  CleanUpVectors( points, random_phi, random_theta, magnitudes )



% Step 1 & 2: Create and Plot the Spherical Atlas
%Degree Separation

% 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 24, 30, 36, 40, 45, 60, 72, 90, 120, 180, and 360.
DegreeSeparate = 60; 

[phi, theta] = meshgrid(deg2rad(0:DegreeSeparate:180), deg2rad(0:DegreeSeparate:360));
u = sin(theta) .* cos(phi);
v = sin(theta) .* sin(phi);
w = cos(theta);


% figure;
% quiver3(0*u, 0*v, 0*w, u, v, w, 0.5);
% title('Spherical Atlas (Vectors)');
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% axis equal; hold on;


%
% Step 3: Create a Point Cloud with Random Vectors

% points = rand(num_points,3) * 20 - 10; % Scale to [-10,10]
% random_phi = 2 * pi * rand(num_points, 1);
% random_theta = pi * rand(num_points, 1);
% rx = 5 * sin(random_theta) .* cos(random_phi);
% ry = 5 * sin(random_theta) .* sin(random_phi);
% rz = 5 * cos(random_theta);
num_points = length(points);
% Step 4, 5 & 6: Find Closest Atlas Angle and Replace
atlas_phi_values = [ phi(1, :), phi(1, 2:end)+pi] ; % Flatten
atlas_theta_values = theta( :, 1); % Flatten
new_vectors = zeros(num_points, 3);


Information = []; 
for i = 1:num_points


    [val, index] = min(sqrt((atlas_theta_values - random_theta(i)) .^ 2 ));

    [val2, index2] = min(sqrt( (atlas_phi_values - random_phi(i)) .^ 2));



        if index < length(atlas_theta_values)
                index = index;
        end 

        if index2 < length(atlas_phi_values)
                index2 = index2 ;
        end     


    SelectedTheta = atlas_theta_values(index) ;  
    SelectedPhi  = atlas_phi_values(index2) ;


    % MATLAB code to create a random number between 0.1 and 0.5

    % Generate a random number between 0 and 1
    randNum = rand();
    % Scale and shift the number to be in the range [0.1, 0.5]
    scaledNum = 0.1 + randNum * 0.4;
    % Display the result
    %disp(scaledNum);


    % atlas_vector = [sin( SelectedPhi )  * cos(SelectedTheta), ...
    %                 sin( SelectedPhi )  *  sin(SelectedTheta), ...
    %                 cos( SelectedPhi ) ] * 5;

    % atlas_vector = [sin( SelectedTheta )  * cos(SelectedPhi), ...
    %             sin( SelectedTheta )  *  sin(SelectedPhi), ...
    %             cos( SelectedTheta ) ] * 1 % (1+ scaledNum) ;  % (magnitudes(i)./ (magnitudes(i)*.98 )) *5;

    atlas_vector = [sin( SelectedTheta )  * cos(SelectedPhi), ...
                sin( SelectedTheta )  *  sin(SelectedPhi), ...
                cos( SelectedTheta ) ] * ( (magnitudes(i)/ (magnitudes(i)*.98 +.001 )) + scaledNum) ;


    new_vectors(i, :) = atlas_vector;

    Information = [ Information;  random_theta(i), SelectedTheta,...
                                  random_phi(i),  SelectedPhi]; 
end



end 

% %
% 
% % Step 7: Visualize the Original and Modified Pointcloud
% figure;
% subplot(1,2,1);
% quiver3(points(:,1), points(:,2), points(:,3), rx, ry, rz, 0);
%     hold on;
%     % Annotate each point with a small number
%     offset = 0.5; % Offset for the text for better visibility
%     for i = 1:num_points
%         text(points(i,1) + offset, points(i,2) + offset, points(i,3) + offset, num2str(i, '%d'), ...
%             'FontSize', 8, 'Color', 'b');
%     end
% 
% title('Original Pointcloud');
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% axis equal;
% 
% 
% 
% 
% subplot(1,2,2);
% quiver3(points(:,1), points(:,2), points(:,3), new_vectors(:,1), new_vectors(:,2), new_vectors(:,3), 0);
% title('Modified Pointcloud with Atlas Vectors');
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% axis equal;
%     hold on;
%     % Annotate each point with a small number
%     offset = 0.5; % Offset for the text for better visibility
%     for i = 1:num_points
%         text(points(i,1) + offset, points(i,2) + offset, points(i,3) + offset, num2str(i, '%d'), ...
%             'FontSize', 8, 'Color', 'b');
%     end
% 
% 
% 