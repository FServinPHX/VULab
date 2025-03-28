clear

data = gauss2d( [23,37], [2,20] , 10, 3  );
x = linspace(0,1,37);
y = linspace(5,20,23);
imagesc(x,y,data)
m = mean(mean(data));        
%To plot only the level m
contourEdges(x,y,data,[m m])
%To plot more levels: contourEdges(x,y,data,[m/2 m 2*m])