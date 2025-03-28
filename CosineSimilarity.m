clear

rng('default') % For reproducibility
X = rand(50,3);
Y = rand(100,3);



D.mat = pdist2(Y,Y);
D.avg = mean(D.mat(:));



set(gcf,'color','w');
plot3(X(:,1), X(:,2), X(:,3), 'r.', 'MarkerSize',20)
hold on 
plot3(Y(:,1), Y(:,2), Y(:,3), 'b.', 'MarkerSize',20)
title( join([ " Cosine Similarity", string(round(D.avg ,2))]))

%%

x = rand(100,3); % Generate a random pointcloud X
y = rand(100,3); % Generate a random pointcloud Y
d = pdist2(y,y); % Calculate the Euclidean distance between X and Y
mean_dist = mean(d(:)); % Calculate the mean Euclidean distance