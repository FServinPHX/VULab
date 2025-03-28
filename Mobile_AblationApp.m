%
clear
 %Now that we have our functions, it is time to make an
 %Interactible application
%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersA98Baseline.csv";
%fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Homogenous Data\Processed Data\ALL_Diameters_A_98_Homg_No_tumor.csv"
fileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\Temp Dependent\Processed Data\allDiametersEllipsewithBAseline.csv";


volumeData = readtable(fileName);
% MVM =  table2array(volumeData(2:end,:));
MVM =  table2array(volumeData(: ,:));
DiameterMatrix = MVM./10;


type = "Temp";
switch type 
%%%%%Portion of this code finds the short-axis and the long axis to plot 
    case "NoTemp"
        %For non-Temperature Dependent Models
        ShortAxisModel.InterceptEq =  [  -3.3437, 0.02313 ];
        ShortAxisModel.SlopeEq =  [ 0.0872, 0.001697 ];

        LongAxisModel.InterceptEq = [4.8053, 0.31 ];
        LongAxisModel.SlopeEq =  [0.00904, -0.00447 ];
    case "Temp"
        %%%For Temperature Dependent Models 
%         ShortAxisModel.InterceptEq =  [  .052009 , 0.018664 ];
%         ShortAxisModel.SlopeEq =  [0.0145 , 0.0025496 ];
% 
%         LongAxisModel.InterceptEq = [1.263 , 0.43312 ];
%         LongAxisModel.SlopeEq =  [0.15719 , -0.015 ];
        LongAxisModel.InterceptEq = [ .1 , 0.31 ];
        LongAxisModel.SlopeEq =  [ 0.00904, -0.0037 ];      
        
        
        ShortAxisModel.InterceptEq =  [  -3.3437, 0.02313 ];
        ShortAxisModel.SlopeEq =  [ 0.0872, 0.001697 ];
 
end 

LongDiameterOG = round( DiameterMatrix( 6:end  , (1)  ), 2);
ShortDiameterOG = round( DiameterMatrix( 6:end  , (2)  ), 2);

%%
%Apply Deformation
%
ShortAxisModelCharred.InterceptEq =  [  -0.28696517, 0.0636057 ];
ShortAxisModelCharred.SlopeEq =  [-0.0099717 , 0.00018746 ];

LongAxisModelCharred.InterceptEq = [  -1.849526, 0.36801177 ];
LongAxisModelCharred.SlopeEq =  [ 0.2635046 , -0.0111617 ];

%
ShortAxisModelwDeformation.InterceptEq = ShortAxisModel.InterceptEq - ShortAxisModelCharred.InterceptEq*.25 ;
ShortAxisModelwDeformation.SlopeEq = ShortAxisModel.SlopeEq - ShortAxisModelCharred.SlopeEq*.25 ;

LongAxisModelwDeformation.InterceptEq = LongAxisModel.InterceptEq - LongAxisModelCharred.InterceptEq *.25;
LongAxisModelwDeformation.SlopeEq = LongAxisModel.SlopeEq - LongAxisModelCharred.SlopeEq*.25 ;


%
ShortAxisModel.InterceptEq =  ShortAxisModelwDeformation.InterceptEq;
ShortAxisModel.SlopeEq =  ShortAxisModelwDeformation.SlopeEq ;

LongAxisModel.InterceptEq = LongAxisModelwDeformation.InterceptEq;
LongAxisModel.SlopeEq =  LongAxisModelwDeformation.SlopeEq;



%%


%AblationApp.FatContentSamples = [5,10,15,20,25];
%AblationApp.FatContentSamples = linspace(4,30, 10 );

%  AblationApp.FatContentSamples = [4];
% AblationApp.FatContentSamples = 1:3.5:35;
AblationApp.FatContentSamples = linspace(4,35,11);

AblationApp.NewFatData= [];
%%create the equation that we will be using
f = @(intercept,slope,x) intercept + slope*x;

time = [0:.25:15];   
%DO NOT ERASE 
%stopping before the end of ablation. OG endstop = 4
% endstop = 4;
endstop = 0;
x = time( 6:end - endstop ); 
AblationApp.NewFatData = [0; x'];


for i = 1:length(AblationApp.FatContentSamples) % length(AblationApp.FatContentSamples):-1:1
    
    AblationApp.FatContent = AblationApp.FatContentSamples(i);


    AblationApp.findInterceptShortAxis = ShortAxisModel.InterceptEq(1) + ...
    AblationApp.FatContent*ShortAxisModel.InterceptEq(2);

    AblationApp.findSlopeShortAxis = ShortAxisModel.SlopeEq(1) + ...
    AblationApp.FatContent*ShortAxisModel.SlopeEq(2);


    AblationApp.findInterceptLongAxis = LongAxisModel.InterceptEq(1) + ...
    AblationApp.FatContent*LongAxisModel.InterceptEq(2);

    AblationApp.findSlopeLongAxis = LongAxisModel.SlopeEq(1) + ...
    AblationApp.FatContent*LongAxisModel.SlopeEq(2);
    %%%FInd the New Fat Data


  
    %The data is time 
    time = ([0:.25:15]).*45.*60./1000;   
     x = time( 6:end- endstop); 
    %%%
    %adding the data essentially is the difference + original baseline data
    %the equation is     y  = intercept(fat%) + slope(fat%)*fat% + baseline
    %data.
    AblationApp.LongAxisData = [AblationApp.FatContent; ...
    round( ( f(AblationApp.findInterceptLongAxis, AblationApp.findSlopeLongAxis, x)'/10 ...
        +  DiameterMatrix( 6:end- endstop , (1)  )), 2)];

    AblationApp.ShortAxisData = [AblationApp.FatContent;  ...
    round(  ( f(AblationApp.findInterceptShortAxis, AblationApp.findSlopeShortAxis, x)'/10 ...
        +  DiameterMatrix( 6:end- endstop , (2)  )), 2) ];
    
    AblationApp.addedData = [AblationApp.ShortAxisData, ...
                        AblationApp.LongAxisData ];

    AblationApp.NewFatData = [AblationApp.NewFatData, AblationApp.addedData ];
end 

tableTitles = ["Time", repmat(["Long-Axis", "Short-Axis"], 1, length(AblationApp.FatContentSamples))];

exportTable  = table( [tableTitles ;  AblationApp.NewFatData] );
ExportTitle = 'Ablation App with Thermal Properties.csv'; 
writetable( exportTable , ExportTitle);

%%
figure(1)
clf
fig = gcf; % current figure handle
set(gcf,'color',rgb('White'));

pause(.1)
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [green; blue; orange; gold; purple; black; red];



set(gca,'FontSize',14) % Creates an axes and sets its FontSize to 18
set(0,'DefaultLegendAutoUpdate','off');
hold on 
%legend_string = ["Ablation Plot (Necrosis)"];
legendString.all =  [];

time = [0:.25:15];   
timex = time( 6:end - endstop); 
spacing = 55; 
timespacing = 1;
colors2 = turbo( (ceil(spacing/timespacing))  );


bwr = createcolormap( 16 ,  blue, orange, gold, purple ); 
 
 
for timej = 1:timespacing:spacing
    
    for i  = 1:length(AblationApp.FatContentSamples) %length(AblationApp.FatContentSamples):-1:1  %1:length(AblationApp.FatContentSamples) % 1

        %going through the loop to different time points during the same
        %ablation
    %     legendString.current = join([ num2str(AblationApp.FatContentSamples(i)), "%fat", "time = ", num2str(timex((timej-1)*8+2) ) ]);
    %     legendString.all = [ legendString.all, legendString.current]


            %%a is the long axis and b is the short axis 
    %         a = AblationApp.NewFatData( (timej-1)*9+2 , (i-1)*2 + 3)*10;
    %         b = AblationApp.NewFatData( (timej-1)*9+2 , (i-1)*2 + 2)*10;
            a = AblationApp.NewFatData( (timej-1)*timespacing+2 , (i-1)*2 + 3)*10/2;
            b = AblationApp.NewFatData( (timej-1)*timespacing+2 , (i-1)*2 + 2)*10/2;
            %create the legend entry
            %legendString.current = join([ num2str(AblationApp.FatContentSamples(i)), "%fat", "time = ", num2str(timex((timej-1)*8+2) ) ]);
            %legendString.all = [ legendString.all, legendString.current];

            %create variables
            t = linspace(0,2*pi,40) ;
            x=cos(t)*a*.99; % width
            y=sin(t).*(b + x/6); %.*(b-x/7)+ 140 ; % height
            x = x +0;
            y = y + 0; 
            %Plotting Function 
            p1 = plot(x,y, 'LineWidth', 2);
            p1.LineStyle = '-';
            %p1.Color = colors(timej,:) ; 
            %p1.Color = blue; %rgb('DarkRed');
            p1.Color = bwr(i,:) ; 

            hold on
%             p2 = plot( (x.*(0.9) ),y, 'LineWidth', 1);
%             p2.LineStyle = '-';
%             p2.Color = 'g' ; 
            
        axis equal
        rectangle('Position', [-80 -1 100 2]./2 )
        axis([0 10 0 10])



        %this function transforms time represented as a minute.decimal into
        %minutes and seconds. ex 1.5 minutes = 1 minute and 30 seconds
        abTime.total = timex( (timej-1)*timespacing + 2) ;
        abTime.sec = mod(abTime.total,1)*(60/100)*100 ; 
        abTime.min = abTime.total - mod(abTime.total,1);

        title_name = join( ["Ablation Margins    4-35% Liver Fat"]) ; %, newline ,"Time ",...
%             num2str(abTime.min), 'm  ', num2str(abTime.sec), "s" ]);
        
        text(0, 4, join([num2str(abTime.min), 'm  ', num2str(abTime.sec), "s"]),...
            'FontSize', 14, 'fontweight','bold')

        title(title_name, 'fontweight','bold')
        xlabel("Long Axis (mm)", 'fontweight','bold')
        ylabel("Short Axis (mm)", 'fontweight','bold')
        ylim([-30 30]./2)
        xlim([-70 70]./2)
        
        


    end
%      pause(.22)
     pause(.05)
     hold off
end


% for legI = 1:5
%     %legendString.current = join([ num2str(AblationApp.FatContentSamples(i)), "%fat", "time = ", num2str(timex((timej-1)*8+2) ) ]);
%     %legendString.all = [ legendString.all, legendString.current];
% 
%     t = linspace(0,2*pi,40) ;
%     x=cos(t)*a*.99; % width
%     y=sin(t).*(b + x/6); %.*(b-x/7)+ 140 ; % height
%     x = x +0;
%     y = y + 0; 
% 
%     p1 = plot(x,y);
%     p1.LineStyle = '-';
%     p1.Color = colors(timej,:) ; 
%     hold on
% end
% 
% 
% % select which plots to plot
% %legend(legendString.all)
% title(title_name)
% xlabel("Long Axis (mm)")
% ylabel("Short Axis (mm)")
% % xlim([min(x) max(x)*1.25])
% % ylim([min(x)/1.5 max(x)/1.5])
% % set(gcf,'position',[80,80,800,800])  
% hold off