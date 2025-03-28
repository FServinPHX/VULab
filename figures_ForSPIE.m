

figure(1) 
set(gcf,'color','w');
X = 0:0.5:20*10;
Y = 20*exp(X/100);
colorLine = rgb("DarkGoldenRod");
plot(X,Y, 'Color', colorLine, 'LineWidth', 2)

% Fill 
xPoints = [0, 0, 5,5]*10 ;  
xPoints2 = [18, 18, 20,20]*10 ;  
xPoints3 = [7, 7, 15,15]*10 ;  

yPoints = [0, Y(end) ,...
    Y(end) , 0];
color = rgb("Salmon");
color2 = [ 139 161 142 ]./256;
hold on;

a = fill(xPoints, yPoints, color);
a.FaceAlpha = 0.25; 

b = fill(xPoints2, yPoints, color);
b.FaceAlpha = 0.25; 

c = fill(xPoints3, yPoints, color2);
c.FaceAlpha = 0.25; 


title(' Mesh Size vs Computation Time')
ylabel("Computation Time (min)")
xlabel("Elements Density (mm^3) ")
ylim([ Y(1) Y(end)-10])
set(gca, 'FontSize',12)


