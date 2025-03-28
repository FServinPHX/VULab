close all
clear
% Example 3: Set fill option on. The fill transparency can be adjusted.
% Initialize data points
D1 =  linspace(0, 80, 20) ;
D2 =  linspace(0, 95, 20) ;
D3 =  linspace(0, 100, 20);
P = [D1; D2; D3]';

Plotlimits =[ repmat(1,  1, size(P,2))  ; repmat(100,  1, size(P,2))  ]  ;
PlotColors = jet(20);


% Spider plot
spider_plot(P,...
    'AxesLabels', {'S1', 'S2', 'S3'}, 'LineWidth', 1, 'Color', PlotColors )
%     'AxesLimits', [1, 1, 1; 100,100, 100]);