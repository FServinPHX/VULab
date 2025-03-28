%%
clear 
close all

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_hepatic_60pReduced.stl");
VasculatureMeshData.HepaticVeinPoints = HepaticVeinData.Points; 
trimesh(HepaticVeinData,'FaceColor','none','EdgeColor','b','EdgeAlpha', .35 )

% Load triangulated mesh
% [V,F] = stlread('triangulated_mesh.stl');

% import STL file
F = HepaticVeinData.ConnectivityList ;
V = HepaticVeinData.Points ;




% Create random point cloud
N = 500;
X = (rand(N,3)*50) + [210 210 150];

% Calculate if each point is in the mesh
inMesh = ones(N,1);
for i = 1:N
    for j = 1:size(F,1)
        A = V(F(j,1),:);
        B = V(F(j,2),:);
        C = V(F(j,3),:);
        P = X(i,:);
        inMesh(i) = inMesh(i) || isPointInTriangle(A,B,C,P);
    end
end


% Plot the results
plotMesh(V,F);
hold on
%plot3( X(:,1),  X(:,2),  X(:,3), '.b', 'MarkerSize', 30)
%plotPoints(X,inMesh);
scatter3(X(inMesh,1),X(inMesh,2),X(inMesh,3),'r');
scatter3(X(~inMesh,1),X(~inMesh,2),X(~inMesh,3),'b');

% Function to calculate if a point is in a triangle
function inTri = isPointInTriangle(A,B,C,P)
    % Calculate barycentric coordinates
    ab = B-A;
    ac = C-A;
    ap = P-A;
    bary = [dot(ab,ab), dot(ac,ab); dot(ab,ac), dot(ac,ac)] \ [dot(ap,ab); dot(ap,ac)];
    
    % Check if barycentric coordinates are in range
    inTri = all(bary >= 0 & bary <= 1);
end

% Function to plot mesh
function plotMesh(V,F)
    patch('Faces',F,'Vertices',V,'FaceColor','w','EdgeColor','k','FaceAlpha',0.1);
    axis equal;
end

% Function to plot points
function plotPoints(X,inMesh)
    scatter3(X(inMesh,1),X(inMesh,2),X(inMesh,3),'r');
    scatter3(X(~inMesh,1),X(~inMesh,2),X(~inMesh,3),'b');
end
