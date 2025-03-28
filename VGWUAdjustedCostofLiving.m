
clear

University = ["MIT",...
"Harvard ",...
"Yale ",...
"Princeton ",...
"Duke ",...
"Brown ",...
"Dartmouth ",...
"Columbia ",...
"Georgetown ",...
"Johns Hopkins ",...
"Cornell ",...
"Georgia Tech",...
"University of Virginia",...
"Emory ",...
"Tufts ",...
"Boston ",...
"UMass Amherst",...
"UNC Chapel Hill",...
"Boston U",...
"Wake Forest ",...
"NYU",...
"Virginia Tech",...
"Vanderbilt"];




Stipend = [47000 43850	38300	50050	38500	42750	35299 ...
44955	34983	35469	40117	32550	31000	34000	34000	34384 ...
30900	30000	31000	29000	42000	31000 31000];

CostOfLiving = [22.59	22.59	17.48	20.27	17.32	17.42...
    17.67	22.51	22.15	17.81	18.26	18.93	18.68	19.21...
    22.59	22.59	22.59	17.32	22.59	15.19	22.51	16.33 17.99].*2080;


PercentBelowLiving = ((Stipend- CostOfLiving )./CostOfLiving).*100;
SortedPercent = sort(PercentBelowLiving,'descend');

figure()

numSample = 16;
x = [1:1:23].*2.5;
y = SortedPercent;
c = jet( numSample ); 
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
bar_h.FaceColor = 'flat';

for k = 1:size(c,1)
    bar_h.CData(k,:) = c(k,:);
end


% bar_child=get(bar_h,'Children');
% set(bar_child,'CData',mydata);
colormap(jet)
set(0,'defaultAxesFontSize',24 )
% ylabel( join(["Living" , newline, "Wage", newline, "Line"]), 'Rotation',0)
ylabel("Living Wage Line (%)")
set(gcf,'color','k');
set(gca,'color',rgb("DarkSlateGray") );
ax = gca % Get handle to current axes.
ax.XColor = 'w'; % Red
ax.YColor = 'w'; % Blue
yline(0, 'r','LineWidth',3);

% text(x+.25 ,y*1.1+.25, UniversityNew,'FontSize', 14 );

%%
clear

Housing = {
'Skyhouse'
'Barbizon'
'Villages at Vanderbilt'
'2010 West End'
'Millennium Music Row'
'Fallyn'
'twenty and grand'
'1818 Church'
'Elliston'
'Kenect'
'West end'
'Lee'
'Duet'
'State Street'
'2100 Acklen'
'Americana'
'Artisan'
'BROADVIEW'
};
Housing=string(Housing);

Cost = [
1830
1250
1750
2144
1855
2140
1845
1666
1741
2010
1690
1569
1541
1649
1674
1345
1659
1924
];

SortedCost = sort(Cost,'ascend');



numSample = 17;
numStart = 7; 
x = [1:1:length(Cost)].*2.5;
y = SortedCost;
c = jet( numSample-numStart+1 ); 
% scatter (x , y ,100, c, 'Filled', '')




HousingNew = [];
for i = 1:numSample
    idx = find(Cost == SortedCost(i));
    HousingNew = [HousingNew , Housing(idx)] ;
    
end 


X = categorical(HousingNew(numStart:numSample));
X = reordercats(X,HousingNew(numStart:numSample));

% XbarString = string(X(numStart:numSample));
% Xbar = categorical(XbarString); 
% YBar = y(numStart:numSample);


% Xbar = X(numStart:numSample);

YBar = SortedCost(numStart:numSample);

bar_h = bar(X , YBar );
bar_h.FaceColor = 'flat';


for k = 1:size(c,1)
    bar_h.CData(k,:) = c(k,:);
end


% bar_child=get(bar_h,'Children');
% set(bar_child,'CData',mydata);
colormap(jet)
set(0,'defaultAxesFontSize',18 )
% ylabel( join(["Living" , newline, "Wage", newline, "Line"]), 'Rotation',0)
ylabel("Monthly Rent ($)")
set(gcf,'color','k');
set(gca,'color',rgb("DarkSlateGray") );
ax = gca % Get handle to current axes.
ax.XColor = 'w'; % Red
ax.YColor = 'w'; % Blue


% yline(0, 'r','LineWidth',3);

% text(x+.25 ,y*1.1+.25, UniversityNew,'FontSize', 14 );
x0=500;
y0=250;
width=950;
height=700;
set(gcf,'position',[x0,y0,width,height])


set(gca,'fontname','Arial Rounded MT Bold')  % Set it to times
