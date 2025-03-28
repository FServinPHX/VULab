

function [filtered_probe_exp] = filter_probePoints(Ablation, B)
    % Determine the max and min in pointcloud A
    minA = min(Ablation);
    maxA = max(Ablation);

    %Tolerance = 0.1
    Tolerance = 0.10;
    
    % Define 90% limits
    limitMin = minA + Tolerance * (maxA - minA);
    limitMax = maxA - Tolerance * (maxA - minA);
    
    % Filter pointcloud B
    filter_mask = B(:,1) >= limitMin(1) & B(:,1) <= limitMax(1) & ...
                  B(:,2) >= limitMin(2) & B(:,2) <= limitMax(2) & ...
                  B(:,3) >= limitMin(3) & B(:,3) <= limitMax(3);
    filtered_probe = B(filter_mask, :);



     % Create a tetrahedral mesh using Delaunay triangulation
    DT = delaunayTriangulation(Ablation);
    % Extract the tetrahedral mesh connectivity list from Delaunay triangulation
    tet = DT.ConnectivityList;
    TR = triangulation(tet,  Ablation);
    [S.faces, S.vertices] = freeBoundary(TR);
    in1 = in_polyhedron(S, filtered_probe);


    
filtered_probe_exp =  [ filtered_probe(in1, 1)  ,   filtered_probe(in1, 2), ...
                        filtered_probe(in1, 3)  ];
end
% % Create hypothetical pointclouds
% A = 10 * rand(100, 3); % 100 points in a range [0, 10] for x, y, z
% B = 12 * rand(100, 3); % 100 points in a range [0, 12] for x, y, z
% 
% % Filter pointcloud B using the function
% filtered_B = filter_pointcloud(A, B);
% 
% % Visualize the results
% figure;
% scatter3(A(:,1), A(:,2), A(:,3), 'ro');
% hold on;
% scatter3(B(:,1), B(:,2), B(:,3), 'b*');
% scatter3(filtered_B(:,1), filtered_B(:,2), filtered_B(:,3), 'g^');
% legend('Pointcloud A', 'Pointcloud B', 'Filtered Pointcloud B');
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('Pointcloud Filtering Based on A');
% grid on;
% axis equal
% 
% 
% 
% 
% 
% 
% 
% 
% function filtered_B = filter_pointcloud(A, B)
%     % Determine the max and min in pointcloud A
%     minA = min(A);
%     maxA = max(A);
% 
%     % Define 90% limits
%     limitMin = minA + 0.1 * (maxA - minA);
%     limitMax = maxA - 0.1 * (maxA - minA);
% 
%     % Filter pointcloud B
%     filter_mask = B(:,1) >= limitMin(1) & B(:,1) <= limitMax(1) & ...
%                   B(:,2) >= limitMin(2) & B(:,2) <= limitMax(2) & ...
%                   B(:,3) >= limitMin(3) & B(:,3) <= limitMax(3);
%     filtered_B = B(filter_mask, :);
% end
