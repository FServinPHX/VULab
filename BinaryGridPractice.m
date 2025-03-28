




% Generate sample data for x, y, and z
num_points = 1000;
x = rand(num_points, 1) * 100; % Random x-coordinates in range [0, 100]
y = rand(num_points, 1) * 100; % Random y-coordinates in range [0, 100]
z = rand(num_points, 1) * 100; % Random z-coordinates in range [0, 100]

% Generate binary intensity values randomly
intensity = randi([0, 1], num_points, 1);

% Define grid size
grid_size = 51;

% Initialize the 3D binary grid
grid3D = zeros(grid_size, grid_size, grid_size);

% Normalize coordinates to grid indices
x_indices = floor((x - min(x)) / (max(x) - min(x)) * (grid_size - 1)) + 1;
y_indices = floor((y - min(y)) / (max(y) - min(y)) * (grid_size - 1)) + 1;
z_indices = floor((z - min(z)) / (max(z) - min(z)) * (grid_size - 1)) + 1;

% Populate the grid with intensity values
for i = 1:num_points
    grid3D(x_indices(i), y_indices(i), z_indices(i)) = intensity(i);
end

% Example Visualization (middle slice of the 3D binary grid)
figure;
imagesc(grid3D(:,:,round(grid_size/2)));
title('Middle Slice of the 3D Binary Grid');
colormap(gray);
colorbar;


%%


clc
clear



% Step 1: Generate x, y, z points from a 3D grid - 51x51x51
n = 51;
[x, y, z] = ndgrid(1:n, 1:n, 1:n);

% Flatten to 1D arrays for easier manipulation
x = x(:);
y = y(:);
z = z(:);

% Step 2: Shift the points to a randomly selected center
rand_shift = randi([1, n], [1, 3])*1.25;
x_shifted = x + rand_shift(1);
y_shifted = y + rand_shift(2);
z_shifted = z + rand_shift(3);

% Step 3: Shuffle all (x, y, z) points, keeping the integrity
num_points = numel(x_shifted);
perm = randperm(num_points);
x_shuffled = x_shifted(perm);
y_shuffled = y_shifted(perm);
z_shuffled = z_shifted(perm);

% Step 4: Generate binary intensity values for each point
intensity = randi([0, 1], [num_points, 1]);

% Step 5: Organize points in a cell matrix
z_levels = unique(z_shifted); % Unique z values
cellMatrix = cell(length(z_levels), 1);

for i = 1:length(z_levels)
    idx_z = find(z_shifted == z_levels(i));
    points_z = [x_shifted(idx_z), y_shifted(idx_z), z_shifted(idx_z), intensity(idx_z)];
    sorted_points_z = sortrows(points_z, [1 2]); % Sort by x and y within same z
    cellMatrix{i} = sorted_points_z;
end

% Step 6 & 7: Iterate cells, assign grid index, and populate 3D grid
intensityGrid = zeros(n, n, n);

%

Cell1 =  cellMatrix{1};
shift2 = [ min(Cell1) -1  ]  ;

for i = 1:length(z_levels)
    currentCell = cellMatrix{i};
    for j = 1:size(currentCell, 1)

        


        x_idx = currentCell(j, 1) - shift2(1);
        y_idx = currentCell(j, 2) - shift2(2);
        z_idx = currentCell(j, 3) - shift2(3);
        if x_idx > 0 && y_idx > 0 && z_idx > 0 && x_idx <= n && y_idx <= n && z_idx <= n
            intensityGrid(x_idx, y_idx, z_idx) = currentCell(j, 4);
        end
    end
end

% Displaying the output grid is just for verification; it is not part of the 100 lines limit.
disp('3D Intensity Grid:');
% disp(intensityGrid);

imagesc(intensityGrid(:,:,round(n/2)));
title('Middle Slice of the 3D Binary Grid');
colormap(gray);
colorbar;





% Define output directory and file name
outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
niftiFile = fullfile(outputDir, 'Random_segmentation.nii');


% Create NIFTI structure using the make_nii function
nii = make_nii(intensityGrid, [1 1 1], [0 0 0], 2); % Ensuring datatype is int16

% Save NIFTI file using the save_nii function provided by the NIFTI toolbox
fprintf('Saving segmentation to %s\n', niftiFile);
save_nii(nii, niftiFile);
fprintf('3D segmentation saved successfully!\n');
fprintf('Script execution complete.\n');


%%



clc
clear

% Step 1: Generate x, y, z points from a 3D grid - 51x51x51
n = 51;
[x, y, z] = ndgrid(1:n, 1:n, 1:n);
% Flatten to 1D arrays for easier manipulation
x = x(:);
y = y(:);
z = z(:);
% Step 2: Shift the points to a randomly selected center
rand_shift = randi([1, n], [1, 3])*1.25;
x_shifted = x + rand_shift(1);
y_shifted = y + rand_shift(2);
z_shifted = z + rand_shift(3);
% Step 3: Shuffle all (x, y, z) points, keeping the integrity
num_points = numel(x_shifted);
perm = randperm(num_points);
x_shuffled = x_shifted(perm);
y_shuffled = y_shifted(perm);
z_shuffled = z_shifted(perm);

% Step 4: Generate binary intensity values for each point
intensity = randi([0, 1], [num_points, 1]);
xyzPoints = [x_shuffled,  y_shifted,  z_shifted  ];




[intensityGrid] =  RegularGridtoBinaryMask( xyzPoints, intensity ); 



% Displaying the output grid is just for verification; it is not part of the 100 lines limit.
disp('3D Intensity Grid:');
% disp(intensityGrid);

imagesc(intensityGrid(:,:,round(n/2)));
title('Middle Slice of the 3D Binary Grid');
colormap(gray);
colorbar;



% Define output directory and file name
outputDir = 'D:\Import To Matlab\2.0 Regular Grid to Imaging Data';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end
niftiFile = fullfile(outputDir, 'Random_segmentation.nii');


% Create NIFTI structure using the make_nii function
nii = make_nii(intensityGrid, [1 1 1], [0 0 0], 2); % Ensuring datatype is int16


