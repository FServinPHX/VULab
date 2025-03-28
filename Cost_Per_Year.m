

%Sources
%https://www.zumper.com/rent-research/nashville-tn
%https://docs.google.com/spreadsheets/d/12Ci9cr2LPw0_WigrFlEZj-jhbHOTyHdHeVS9zbxlQ5s/edit#gid=0
%https://www.bls.gov/regions/southeast/news-release/consumerpriceindex_south.htm
%https://www.macrotrends.net/countries/USA/united-states/inflation-rate-cpi

figure()
salary = 32000;

Initial.Groceries = 300;
Initial.Utilities = 180; 

CPI.percent = [2.208, 1.4416, .99166, 5.058, 8.928];
CPI.rent = [1376, 1150, 1295, 1300, 1833];
    

Year = [2018, 2019, 2020, 2021, 2022];

CPI.Groceries = [];
CPI.Utilities = [];
for i = 1:length(Year)
    
    CPI.Groceries = [CPI.Groceries , Initial.Groceries.*(1 + CPI.percent(i)/100)];
    Initial.Groceries = CPI.Groceries(i);
    
    CPI.Utilities = [CPI.Utilities, Initial.Utilities.*(1 + CPI.percent(i)/100)];
    Initial.Utilities = CPI.Utilities(i);
    
end

CPI.totalCost = CPI.rent + CPI.Groceries + CPI.Utilities;
CPI.totalCostRoomate = CPI.rent/2 + CPI.Groceries + CPI.Utilities/2;

font = 'Rockwell';

plot( Year, CPI.totalCost*12/1000 , '-o', 'LineWidth', 3,...
    'Color' , rgb('DarkRed') )
hold on
plot( Year, CPI.totalCostRoomate *12/1000 , '-o', 'LineWidth', 3,...
    'Color' , rgb('Navy') )
yline( salary./1000, '--', '$31,000 Salary','FontSize',16, 'fontname', font ,...
    'LineWidth',3, 'Color', rgb('DarkGreen')  )

set(gcf,'color','w' )  
set(gca, 'FontSize',14, 'fontname', font)

xlabel('Year')
ylabel(' $ Thousands ')
title('Cost of Living (1 Bedroom) vs Our Real Wages')
legend(["Living Alone", "1 Roommate"], 'Location' , 'best' )
ylim([ 10000 35000]./1000 )
xlim([Year(1) Year(end)])