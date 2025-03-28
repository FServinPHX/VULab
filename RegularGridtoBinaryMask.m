



function [intensityGrid] =  RegularGridtoBinaryMask( xyzPoints, intensity )


x =  xyzPoints(:,1);
y =  xyzPoints(:,2);
z =  xyzPoints(:,3);
n = nthroot(length(x), 3 );


% Step 5: Organize points in a cell matrix
z_levels = unique(z); % Unique z values
cellMatrix = cell(length(z_levels), 1);

for i = 1:length(z_levels)
    idx_z = find(z == z_levels(i));
    points_z = [x(idx_z), y(idx_z), z(idx_z), intensity(idx_z)];
    sorted_points_z = sortrows(points_z, [1 2]); % Sort by x and y within same z
    cellMatrix{i} = sorted_points_z;
end

%

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

% % Displaying the output grid is just for verification; it is not part of the 100 lines limit.
% disp('3D Intensity Grid:');
% % disp(intensityGrid);
% 
% imagesc(intensityGrid(:,:,round(n/2)));
% title('Middle Slice of the 3D Binary Grid');
% colormap(gray);
% colorbar;

end 