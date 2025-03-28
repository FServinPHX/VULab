
set(0,'defaultaxesfontname','cambria math')
set(gcf,'color','w');
x = [ 1  1  1] + 2;
y = [1.55 1.65 1.5] + 1.75;
z = [1.0 1.0 6];
scatter3(x,y,z,100, 'filled')
title(join(["How the Diameter Algorithm Works", newline, "Z-axis"]),'FontSize', 14)

set(gca,'FontSize',14)
hold on
x1 = x(2:3) ;
y1 = y(2:3);
z1 = z(2:3);
plot3(x1,y1,z1,'r')


x2 = [x(1) x(3)] ;
y2 = [y(1) y(3)];
z3 = [z(1) z(3)];
plot3(x2,y2,z3,'b')


rng(0,'twister');
a = 1.25 ;
b = 5;
xRand = (b-a).*rand(30,1) + a;
yRand = (b-a).*rand(30,1) + a;
zRand = (b-a).*rand(30,1) + a;

scatter3(xRand, yRand, zRand)

hold off
%%
clear
rng default;
P = rand(30,3);
plot3(P(:,1),P(:,2),P(:,3),'.')
grid on

k = boundary(P,0);

uniqueArr.k = reshape(k,[],1);
uniqueArr.kSort = unique(uniqueArr.k);
uniqueArr.kSortPoint = P(uniqueArr.kSort,:);

j = boundary(P,1);
%%
subplot(1,2,1);
plot3(P(:,1),P(:,2),P(:,3),'.','MarkerSize',10)
hold on
%trisurf(k,P(:,1),P(:,2),P(:,3),'FaceColor','red','FaceAlpha',0.1)
scatter3(uniqueArr.kSortPoint(:,1),uniqueArr.kSortPoint(:,2),...
    uniqueArr.kSortPoint(:,3),'r')
axis equal
title('Shrink Factor = 0')

%%
subplot(1,2,2);
plot3(P(:,1),P(:,2),P(:,3),'.','MarkerSize',10)
hold on
trisurf(j,P(:,1),P(:,2),P(:,3),'FaceColor','red','FaceAlpha',0.1)
axis equal
title('Shrink Factor = 1')