
clear 
close all

University = ["Peabody",...
"Divinity ",...
"Arts & Sciences ",...
"Hard Sciences ",...
"Engineering " ];


Stipend = [ 28000 30000 34000 35000 36000 ];
StudioCost = [2000]*12;



%PercentBelowLiving = ((Stipend- StudioCost )./StudioCost).*100;

PercentBelowLiving = StudioCost./Stipend.*100;

SortedPercent = sort(PercentBelowLiving,'descend');


figure()

numSample = 5;
x = [1:1:23].*2.5;
y = SortedPercent;
c = autumn( numSample ); 
% scatter (x , y ,100, c, 'Filled', '')



hold on 
UniversityNew = [];
for i = 1:numSample
    idx = find(PercentBelowLiving == SortedPercent(i));
    UniversityNew = [UniversityNew , University(idx)] ;
    
end 

X = categorical(UniversityNew);
X = reordercats(X,UniversityNew);
mydata = [x,y(1:numSample)];

bar_h = bar(X , y(1:numSample) );
bar_h.EdgeColor = 'flat';
bar_h.LineWidth = 5;
bar_h.FaceColor = rgb('Black');

for k = 1:size(c,1)
    bar_h.CData(k,:) = c(k,:);
end



set(0,'defaultAxesFontSize',24 )
% ylabel( join(["Living" , newline, "Wage", newline, "Line"]), 'Rotation',0)
ylabel("Rent Burden(%)")
set(gcf,'color','k');
set(gca,'color',rgb('Black') );
ax = gca % Get handle to current axes.
ax.XColor = 'w'; % Red
ax.YColor = 'w'; % Blue


yline( 30, 'w','LineWidth',3);
str = "Recomended Rent (%)";
% text( 0  ,0, str, 'FontColor', 'w')

