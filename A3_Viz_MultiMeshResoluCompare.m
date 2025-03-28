
%
clear 
close all
% Read data from the first CSV file
data1 = readtable('D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results\ALLVolumeA98BoxPhantom_MultiProbe.csv');

% Read data from the second CSV file
data2 = readtable("D:\Import To Matlab\Box Phantom\Multiprobe\Results\ALLVolumeA98BoxPhantom_MultiProbeCompare.csv");
% Convert the data to arrays
data1 = table2array(data1);
data2 = table2array(data2);

% Determine the number of columns
numColumns = size(data1, 2);

% Define colors for each dataset
gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
% colors = [green; blue; orange; gold; purple];
colors = [blue; green; orange; gold; purple; black];
Fillcolors = [ green; orange; blue; gold]; 


% Visualize the data as a 2D line plot with different colors for each dataset
figure;
set(gca,'color', 'w' );
set(gcf,'color', 'w' );
hold on;
for i = 1:numColumns
    plot(data1(:,i), 'Color', colors(i,:), 'LineWidth', 2);
end

for i = 1:numColumns
    plot(data2(:,i), 'Color', colors(i,:), 'LineStyle', '--', 'LineWidth', 2);
end
% legend('Data 1', 'Data 2');
xlabel('Sample');
ylabel('Value');
title('Line Plot of Data 1 and Data 2');

% Compute the absolute difference between the data
abs_diff = abs(data1 - data2);

% Create a plot of the absolute difference with a specific color for all datasets
figure;
set(gca,'color', 'w' );
set(gcf,'color', 'w' );
hold on;
for i = 1:numColumns
    plot(abs_diff(:,i), 'Color', colors(i,:), 'LineWidth', 2);
end
xlabel('Sample');
ylabel('Absolute Difference');
title('Absolute Difference between Data 1 and Data 2');

% Compute the relative difference between the data
rel_diff = abs_diff ./ (abs(data1) + eps);

% Create a plot of the relative difference with a specific color for all datasets
figure;
set(gca,'color', 'w' );
set(gcf,'color', 'w' );
hold on;
for i = 1:numColumns
    plot(rel_diff(:,i), 'Color', colors(i,:), 'LineWidth', 2);
end
xlabel('Sample');
ylabel('Relative Difference');
title('Relative Difference between Data 1 and Data 2');