




function QuerryPointsOG = generateQuerryPointsOG_CGBT(intensity_spc, num_points, radius, voxel_size)
% generateQuerryPointsOG
% Generates 3D query points for a simulated box phantom model with a spherical point cloud.
%
% Inputs:
% - intensity_spc: Spacing for intensity mesh grid.
% - num_points: Number of points in the spherical point cloud.
% - radius: Radius of the spherical point cloud.
% - voxel_size: 3-element vector specifying the size of the voxel [x, y, z].
%
% Output:
% - QuerryPointsOG: Generated 3D query points for the model.

% Generate 3D spherical point cloud
theta = 2 * pi * rand(num_points, 1);
phi = acos(2 * rand(num_points, 1) - 1);

x = radius * sin(phi) .* cos(theta);
y = radius * sin(phi) .* sin(theta);
z = radius * cos(phi);
points = [x y z];

% Set up Box Phantom Model
center = [0, 0, 0] - (voxel_size / 2);
strt = [0, 0, 0];
endd = [0, 0, 0];

% Create voxel grid
Volxelx = [center(1) + voxel_size(1) * strt(1):voxel_size(1):voxel_size(1) * endd(1) + center(1)];
Volxely = [center(2) + voxel_size(2) * strt(2):voxel_size(2):voxel_size(2) * endd(2) + center(2)];
Volxelz = [center(3) + voxel_size(3) * strt(3):voxel_size(3):voxel_size(3) * endd(3) + center(3)];

% Generate mesh grid and reshape
[intensityX, intensityY, intensityZ] = meshgrid(Volxelx:intensity_spc:abs(Volxelx), ...
                                                Volxely:intensity_spc:abs(Volxely), ...
                                                Volxelz:intensity_spc:abs(Volxelz));
intensityX = reshape(intensityX, [], 1);
intensityY = reshape(intensityY, [], 1);
intensityZ = reshape(intensityZ, [], 1);

% Combine into query points
QuerryPointsOG = [intensityX, intensityY, intensityZ];

end