



X = TumorPoints.one(:,1);
Y = TumorPoints.one(:,2);
Z = TumorPoints.one(:,3);

% Create the data point-matrix
M = [ X, Y, Z;  tumorNew.center(1) tumorNew.center(2) tumorNew.center(3) ]' ;

D = [newAblationCloud' ,ablationCloud.center ]' ;

    BoundaryPoints.Bulb = [];
    BoundaryPoints.Stem = [];
    excluded = 0;

    for j = 1:length(D)
        %If the points are larger than 
        if  D(j,2) > ablationCloud.center(2)-10
            BoundaryPoints.Bulb  = [BoundaryPoints.Bulb ;...
                D(j,:)];
        else 
            BoundaryPoints.Stem = [BoundaryPoints.Stem;...
                D(j,:)];
        end
    end
    
D = BoundaryPoints.Bulb'  ; 



% Run ICP (standard settings)
[Ricp Ticp ER t] = icp(M, D, 15);

% Transform data-matrix using ICP result
n = length(D);
Dicp = Ricp * D + repmat(Ticp, 1, n);

% Plot model points blue and transformed points red
figure;
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
plot(0:15,ER,'--x');
xlabel('iteration#');
ylabel('d_{RMS}');
legend('bruteForce matching');
title(['Total elapsed time: ' num2str(t(end),2) ' s']);


%% Run ICP (fast kDtree matching and extrapolation)
[Ricp Ticp ER t] = icp(M, D, 15, 'Matching', 'kDtree', 'Extrapolation', true);

% Transform data-matrix using ICP result
Dicp = Ricp * D + repmat(Ticp, 1, n);

% Plot model points blue and transformed points red
figure;
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
plot(0:15,ER,'--x');
xlabel('iteration#');
ylabel('d_{RMS}');
legend('kDtree matching and extrapolation');
title(['Total elapsed time: ' num2str(t(end),2) ' s']);


