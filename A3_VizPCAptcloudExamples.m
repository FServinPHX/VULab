% Generate two 3D point clouds
nPoints = 100;
cloud1 = randn(nPoints, 3);
cloud2 = randn(nPoints, 3);

% Perform PCA analysis on the point clouds
[coeff1, score1, ~, ~, explained1] = pca(cloud1);
[coeff2, score2, ~, ~, explained2] = pca(cloud2);

% Calculate similarity in all dimensions
similarity = zeros(1, 3); % Change dimensions if needed
for dim = 1:3
    similarity(dim) = abs(dot(coeff1(:,dim), coeff2(:,dim)));
end

% Visualize the results
figure;
subplot(2, 2, 1);
scatter3(cloud1(:,1), cloud1(:,2), cloud1(:,3), 'filled');
title('Point Cloud 1');
xlabel('X');
ylabel('Y');
zlabel('Z');

subplot(2, 2, 2);
scatter3(cloud2(:,1), cloud2(:,2), cloud2(:,3), 'filled');
title('Point Cloud 2');
xlabel('X');
ylabel('Y');
zlabel('Z');

subplot(2, 2, 3);
bar(explained1);
title('Explained Variance (Point Cloud 1)');
xlabel('Principal Component');
ylabel('Explained Variance (%)');

subplot(2, 2, 4);
bar(explained2);
title('Explained Variance (Point Cloud 2)');
xlabel('Principal Component');
ylabel('Explained Variance (%)');

% Print similarity in all dimensions
disp('Similarity in all dimensions:');
disp(similarity);


%%
%{

This code generates three 3D point clouds (cloud1, cloud2, and cloud3) with a length of 
nPoints. It then performs a PCA analysis on all three point clouds using the pca function. 
The PCA results are stored in coeff1, score1, coeff2, score2, coeff3, and score3. 
The code then calculates the similarity between each pair of point clouds in all 
dimensions by taking the dot product of the corresponding principal component vectors and 
storing the results in similarity12, similarity13, and similarity23. Next, the code 
determines the most similar point clouds based on the total similarity across all 
dimensions. The point clouds are ranked based on the sum of their similarity values, 
and the two most similar point clouds are identified. The code then visualizes the three 
point clouds using scatter plots and displays their explained variances using a bar plot. 
Each subplot represents one of the point clouds. Finally, the code prints the similarities 
between the point clouds in all dimensions and displays the indices of the most similar 
point clouds. Note that in this example, the similarity calculation is done separately
 for each pair of point clouds. If you have more than three point clouds, you can extend 
the calculation and comparison accordingly.

%}

% Generate three 3D point clouds
nPoints = 100;
cloud1 = randn(nPoints, 3);
cloud2 = randn(nPoints, 3);
cloud3 = randn(nPoints, 3);

% Perform PCA analysis on the point clouds
[coeff1, score1, ~, ~, explained1] = pca(cloud1);
[coeff2, score2, ~, ~, explained2] = pca(cloud2);
[coeff3, score3, ~, ~, explained3] = pca(cloud3);

% Calculate similarity in all dimensions
similarity12 = zeros(1, 3); % Change dimensions if needed
similarity13 = zeros(1, 3);
similarity23 = zeros(1, 3);
for dim = 1:3
    similarity12(dim) = abs(dot(coeff1(:,dim), coeff2(:,dim)));
    similarity13(dim) = abs(dot(coeff1(:,dim), coeff3(:,dim)));
    similarity23(dim) = abs(dot(coeff2(:,dim), coeff3(:,dim)));
end

% Determine the most similar point clouds
similarities = [sum(similarity12), sum(similarity13), sum(similarity23)];
[~, mostSimilarIndices] = sort(similarities, 'descend');
mostSimilarClouds = mostSimilarIndices(1:2);

% Visualize the results
figure;

subplot(2, 2, 1);
scatter3(cloud1(:,1), cloud1(:,2), cloud1(:,3), 'filled');
title('Point Cloud 1');
xlabel('X');
ylabel('Y');
zlabel('Z');

subplot(2, 2, 2);
scatter3(cloud2(:,1), cloud2(:,2), cloud2(:,3), 'filled');
title('Point Cloud 2');
xlabel('X');
ylabel('Y');
zlabel('Z');

subplot(2, 2, 3);
scatter3(cloud3(:,1), cloud3(:,2), cloud3(:,3), 'filled');
title('Point Cloud 3');
xlabel('X');
ylabel('Y');
zlabel('Z');

subplot(2, 2, 4);
bar([explained1; explained2; explained3]');
title('Explained Variance');
xlabel('Principal Component');
ylabel('Explained Variance (%)');

% Print similarity in all dimensions
disp('Similarity between Point Cloud 1 and Point Cloud 2:');
disp(similarity12);
disp('Similarity between Point Cloud 1 and Point Cloud 3:');
disp(similarity13);
disp('Similarity between Point Cloud 2 and Point Cloud 3:');
disp(similarity23);

% Print the most similar point clouds
disp('The most similar point clouds are:');
disp(mostSimilarClouds);

%%


% Define the 1x3 matrix
vec1 = [1, 2, 3];

% Define the 9x3 matrix
mat2 = randn(9, 3);

% Perform the dot product
dotProduct = sum(vec1 .* mat2, 2);

% Display the dot product
disp('Dot product between vec1 and mat2:');
disp(dotProduct);


