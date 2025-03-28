
clear

%directory = 'D:\Import To Matlab\SyntheticPointCloud_v5\ PsiTheta1_ 0 - 0     PsiTheta2_ 0 - 0 Abl';  % Replace with the actual directory path

% Specify the path of the directory full of folders
folderPath = 'D:\Import To Matlab\SyntheticPointCloud_v5\';


% Get all files and folders in the current folder
contents = dir(folderPath);


%
  
for ki = 1:numel(contents)
    
% Get a list of all files in the directory
item = contents(ki) ;
directory = fullfile(folderPath, item.name  ); 
files = dir(directory);
% Get a list of all files in the directory
files = dir(fullfile(directory, '*.csv'));  % Replace '*.txt' with the actual file extension


% Sort the files based on the numerical order in the filename
[~, order] = sort(cellfun(@(x) str2double(x(1:strfind(x, 'P')-1)), {files.name}));
% Reorder the files based on the sorted order
sorted_files = files(order);
files = sorted_files;


%
% Loop through each file
AblAP_All_Multi = [];
for i = 1:numel(files)
    filename = files(i).name;
    
    % Check if the file is a text file
    idx = 5 : 1 : (15*4)+1 ;
    if ~isequal(filename, '.') && ~isequal(filename, '..') && ~files(i).isdir
    
        % Read the data from the current file
        file_data = dlmread(fullfile(directory, filename));
        
        % Get the data points
        x = file_data(:, 1);
        y = file_data(:, 2);
        z = file_data(:, 3);
        
        QuerryPointsOG = [x,y,z];
        
        % Process the data points here...
        
        % Read the subsequent file
        if i < numel(files)
            next_file_data = dlmread(fullfile(directory, files(i+1).name));
            next_x = next_file_data(:, 1);
            next_y = next_file_data(:, 2);
            next_z = next_file_data(:, 3);
            
            % Process the subsequent data points here...
            TargetPoint = [next_x, next_y, next_z];
            VectorsBnd = AIM3AblationVectorFieldLinked( QuerryPointsOG, TargetPoint );   
            
            
            
            X1 = x;    Y1 = y;     Z1 = z;
            [k, vol] = boundary([X1,Y1,Z1], 0 );
            set(gcf,'color','w');
            axis equal;
            title( join(["Probe Placement Atlas"]), 'Fontsize', 14 )   
            
  
            %USE angleIdx or exprmt
            t1 = trisurf(k, X1, Y1 , Z1 ,'Facecolor', 'b' ,'FaceAlpha', .05 ,...
                 'EdgeColor', 'none' );
            %Plot the next
            %p1 = plot3( X2, Y2 , Z2 , '.', 'Color', 'k', 'MarkerSize', 5); 
            %plot the direction of growth of the ablation volume
            p2 = plot3( X1, Y1 , Z1  , '.', 'Color', 'k', 'MarkerSize', 1);
            hold on
            q = quiver3( X1, Y1 , Z1 , VectorsBnd(:,1)  ,VectorsBnd(:,2), VectorsBnd(:,3),...
                         'LineWidth', 1.5);
            %// Compute the magnitude of the vectors
            mags = sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
                        reshape(q.WData, numel(q.UData), [])).^2, 2));
            %// Get the current colormap
            currentColormap = colormap(jet);
            %// Now determine the color to make each arrow using a colormap
            [~, ~, ind] = histcounts(mags, size(currentColormap, 1));
            %// Now map this to a colormap to get RGB
            cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
            cmap(:,:,4) = 255;
            cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);
            %// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
            set(q.Head, ...
                'ColorBinding', 'interpolated', ...
                'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'
            %// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
            set(q.Tail, ...
                'ColorBinding', 'interpolated', ...
                'ColorData', reshape(cmap(1:2,:,:), [], 4).');
            
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
            title( join([ item.name ])   )
            view( -40 ,20)
            xlim([-30, 30])
            ylim([-30, 30])
            zlim([-40, 40])  
            axis equal
            hold off
            
            
            minutes =  floor( (idx(i)*15-15)/60) ; 
            seconds  = mod( (idx(i)*15-15), 60)    ;
            firstRow = [1,2,3, 0, minutes, seconds];
            ptsMulti = [ firstRow; X1, Y1 , Z1, VectorsBnd]; 
            
            AblAP_All_Multi = [AblAP_All_Multi , ptsMulti ];
         
            
            
            
            pause(.1) 
        end
    end
end

firstRow1 = [1,2,3, 0, 14, 30];
firstRow2 = [1,2,3, 0, 14, 45];
firstRow3 = [1,2,3, 0, 15, 0];
ptsMulti1 = [ firstRow1; X1, Y1 , Z1, VectorsBnd.*.90]; 
ptsMulti2 = [ firstRow2; X1, Y1 , Z1, VectorsBnd.*80]; 
ptsMulti3 = [ firstRow3; X1, Y1 , Z1, VectorsBnd.*70]; 

AblAP_All_Multi = [AblAP_All_Multi , ptsMulti1, ptsMulti2, ptsMulti3 ];
%

resultsDir = 'D:\Import To Matlab\SyntheticPointCloud_Linked Ablation Vectors v3\'; 
[filepath,name,ext] = fileparts(directory);


resultsDir2 = join([ resultsDir ]);
% [status, msg, msgID] = mkdir(resultsDir2);
ExportFileName = join([ name, 'Points_a_Vectors.csv'  ]);
exportBoundaryTitle = fullfile(resultsDir2, ExportFileName);
%-----------------------------------------%             Write the filename              
writematrix( AblAP_All_Multi , exportBoundaryTitle);   



pause(5)
end 

%%
% Create a spherical point cloud
numPoints = 300;
radius = 5;
theta = 2*pi * rand(numPoints, 1);
phi = acos(2*rand(numPoints, 1) - 1);
x = radius * sin(phi) .* cos(theta);
y = radius * sin(phi) .* sin(theta);
z = radius * cos(phi);
pointCloud = [x, y, z];

% Create a 3D spherical gradient
numVectors = 200;
gradTheta = linspace(0, 2*pi, numVectors)';
gradPhi = linspace(0, pi, numVectors)';
gradRadius = linspace(0, 10, numVectors)';
gradX = gradRadius .* sin(gradPhi) .* cos(gradTheta);
gradY = gradRadius .* sin(gradPhi) .* sin(gradTheta);
gradZ = gradRadius .* cos(gradPhi);
gradient = [gradX, gradY, gradZ];

% Displace the spherical point cloud using the gradient information
displacedPointCloud = pointCloud;
threshold = 1;  % Define a threshold for displacement

for i = 1:numPoints
    point = pointCloud(i,:);
    
    % Find the closest vector from the gradient for displacement
    closestVectorIndex = -1;
    closestVectorDistance = Inf;
    
    for j = 1:numVectors
        vector = gradient(j,:);
        vectorDistance = norm(point - vector);
        
        if vectorDistance < closestVectorDistance
            closestVectorDistance = vectorDistance;
            closestVectorIndex = j;
        end
    end
    
    % Calculate displacement if the closest vector meets the threshold
    if closestVectorDistance > threshold
        displacement = threshold * gradient(closestVectorIndex,:);
        displacedPointCloud(i,:) = point + displacement;
    end
end

% Visualize the original point cloud, the gradients, and the displaced point clouds
figure;
scatter3(pointCloud(:, 1), pointCloud(:, 2), pointCloud(:, 3), 'filled', 'MarkerFaceColor', 'blue');
hold on;
quiver3(zeros(numVectors, 1), zeros(numVectors, 1), zeros(numVectors, 1), gradient(:, 1), gradient(:, 2), gradient(:, 3), 'color', 'red');
scatter3(displacedPointCloud(:, 1), displacedPointCloud(:, 2), displacedPointCloud(:, 3), 'filled', 'MarkerFaceColor', 'green');

title('Spherical Point Cloud, Gradients, and Displaced Point Cloud');
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('Original Point Cloud', 'Gradients', 'Displaced Point Cloud');
axis equal





































