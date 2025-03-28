clear all
clear
set(gcf,'color','w');

%                                                                              AIM 3: COSINE SIMILARITY
%create x,y,z data for two ellipsoids
[x1,y1,z1] = ellipsoid(0,0,0,2,3,4);
[x2,y2,z2] = ellipsoid(1,1,1,3,2,1);


x1 = reshape(x1,length(x1)*length(y1),1);
y1 = reshape(y1,length(y1)*length(y1),1);
z1 = reshape(z1,length(z1)*length(z1),1);

x2 = reshape(x2,length(x2)*length(x2),1);
y2 = reshape(y2,length(y2)*length(y2),1);
z2 = reshape(z2,length(z2)*length(z2),1);


%perform pca analysis on data
data = [x1,y1,z1]';
[coeff,score,latent] = pca(data);

data2 = [x2,y2, z2]';
[coeff2,score2,latent2] = pca(data2);

%generate two vectors
vec1 = [coeff(1,1),coeff(2,1),coeff(3,1) ];    
vec2 = [coeff2(1,1),coeff2(2,1),coeff2(3,1)]   ;

%calculate cosine similarity between them
cosSim = dot(vec1,vec2)/(norm(vec1)*norm(vec2));



%plot ellipsoids and pca vector
plot3(x1,y1,z1, '.')
hold on
plot3(x2,y2,z2, '.')

figure()
%plot the two vectors
plot3([0 vec1(1)],[0 vec1(2)],[0 vec1(3)])
hold on
plot3([0 vec2(1)],[0 vec2(2)],[0 vec2(3)])
title(strcat('Cosine similarity=',num2str(cosSim)))
hold off;

%%

%                                                                              AIM 3


clear 
close all

colors = [ rgb("LightCoral") ; rgb("ForestGreen") ; rgb("DarkGoldenrod") ; rgb("RoyalBlue") ];
legend_string = ["A ", "B", "C", "D"];
pos = 1;
lineChoice = '-';
titleName = 'Predicited vs True Ablation';

% Create a vector of normally distributed data between 0 and 8 mm
a = (2.1*randn(1000,1)-5) ;
b = (1*randn(50,1))+5 ;
distancesAll = [a;b];
% x = 0 + (8-0).*norm(1000,1);
% x = normrnd( 5, 0.75, 1000);




figure(1);
set(gcf,'color','w');
set(gca,'FontSize',18)
g = histogram(distancesAll, 'Normalization','pdf', 'BinWidth', 1, ...
    'FaceColor', colors(pos ,:) ,'FaceAlpha', .25 , 'EdgeAlpha', 1 );
title('Signed Distance to Agreement of Two 3D Objects');
xlabel('Distance (mmm)');
ylabel("Probability Density");
hold on 

Bin_Counts = g.BinCounts;
Bin_Counts = Bin_Counts./(sum(Bin_Counts));
Bin_Width = g.BinWidth;
Bin_Centres = g.BinEdges(2:end) - Bin_Width;


figure(2)
set(gcf,'color','w');
p = plot(Bin_Centres,Bin_Counts, 'Color',colors(pos ,:), 'LineWidth', 3 );
p.LineStyle = lineChoice;
title( titleName  , 'FontSize', 18);
xlabel('Signed Distance to Agreement (SDA_{P-T})   [mm]');
ylabel("Probability Density");  
%     legend_string = ["A ", "B", "C", "D"];
legend(legend_string,'AutoUpdate','off')
hold on


maxBin = [maxBin,  max(Bin_Counts)]; 



mindist = [mindist ,min(distancesAll) ];
maxdist = [maxdist, max(distancesAll) ];


width = max(maxdist) - min(mindist);

height = max(maxBin)*1.1; 
txt = ["Inside Tumor","Outside Tumor"];

text([-6.5, 2.0 ],[ height , height ],txt, 'FontSize', 14)
% text([-4.0, 1.5 ],[ height , height ],txt, 'FontSize', 14)

ylim([0, (height*1.1) ])
xlim([ (min(mindist)-1) , (max(maxdist)+1) ])
xline(0)        

hold off

%%

%                                                                              AIM 3: Create Cube
clear

figure()
P = [10,5,10] ;   % you center point 
L = [20,20,20] ;  % your cube dimensions 
O = P-L/2 ;       % Get the origin of cube so that P is at center 
plotcube(L,O,.1,rgb('SkyBlue'));   % use function plotcube 
% hold on
% plot3(P(1),P(2),P(3),'*k')









