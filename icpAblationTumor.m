

function [Dicp] = icpAblationTumor(tumorCloud, ablationCloud, ablationCenter, tumorCenter,iter, Weight,Useceter, weights)


X = tumorCloud(:,1);
Y = tumorCloud(:,2);
Z = tumorCloud(:,3);

% Create the data point-matrix


if strcmp(Useceter, "T")
    D = [ablationCloud' ,ablationCenter ]' ;
    M = [ X, Y, Z;  tumorCenter(1) tumorCenter(2) tumorCenter(3) ]' ;
    disp("Use Center")
else 
    D = [ablationCloud' ]' ;
    M = [ X, Y, Z]' ;
    disp("No Center")
end 
    

    BoundaryPoints.Bulb = [];
    BoundaryPoints.Stem = [];
    excluded = 0;

    for j = 1:length(D)
        %If the points are larger than 
        if  D(j,2) > ablationCenter(2)-10
            BoundaryPoints.Bulb  = [BoundaryPoints.Bulb ;...
                D(j,:)];
        else 
            BoundaryPoints.Stem = [BoundaryPoints.Stem;...
                D(j,:)];
        end
    end
    
D = BoundaryPoints.Bulb'  ; 



% Run ICP (standard settings)

if strcmp(Weight,"T") 
    [Ricp Ticp ER t] = icp(M, D, iter, 'Weight', weights );
else 
    [Ricp Ticp ER t] = icp(M, D, iter);
end 

% Transform data-matrix using ICP result

%Reassign the original ablation points in the ablation cloud

if strcmp(Useceter, "T")
    
    D = [ablationCloud' ,ablationCenter ] ;
    disp("Use Center")
    
else 
    D = [ablationCloud' ] ;
    disp("No Center")
end 

% D = [ablationCloud' ,ablationCenter ] ;
n = length(D);
Dicp = Ricp * D + repmat(Ticp, 1, n);


    % Plot model points blue and transformed points red
    figure;
    set(gcf,'color','w');
    subplot(2,2,1);
    plot3(M(1,:),M(2,:),M(3,:),'bo',D(1,:),D(2,:),D(3,:),'r.');
    axis equal;
    xlabel('x'); ylabel('y'); zlabel('z');
    title('Red: z=sin(x)*cos(y), blue: transformed point cloud');

    % Plot the results
    subplot(2,2,2);
    plot3(M(1,:),M(2,:),M(3,:),'bo',Dicp(1,:),Dicp(2,:),Dicp(3,:),'r.');
    axis equal;
    xlabel('x'); ylabel('y'); zlabel('z');
    title('ICP result');

    % Plot RMS curve
    subplot(2,2,[3 4]);
    plot(0:iter ,ER,'--x');
    xlabel('iteration#');
    ylabel('d_{RMS}');
    legend('bruteForce matching');
    title(['Total elapsed time: ' num2str(t(end),2) ' s']);
Dicp = Dicp';
end 