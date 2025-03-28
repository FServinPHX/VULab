

set(gcf,'color','w');


% Data setup
frameworks = {'TensorFlow', 'PyTorch'};
trainingTimes = [8, 2]; % Training times per epoch in hours
colors = [0 0.4470 0.7410; 0.4660 0.6740 0.1880]; % Default MATLAB blue and green

% Creating the bar graph
figure;
b = bar(trainingTimes, 'FaceColor', 'flat');

% Setting the colors for each bar
for k = 1:length(trainingTimes)
    b.CData(k, :) = colors(k, :);
end

% Adding details to the graph
set(gca, 'XTickLabel', frameworks, 'XTick', 1:numel(frameworks));
title('GPU Training Time Comparison: TensorFlow vs PyTorch');
ylabel('Time per Epoch (hours)');
xlabel('Deep Learning Frameworks');

% Adding text labels above the bars to show the exact training times
text(1:length(trainingTimes), trainingTimes, num2str(trainingTimes', '%0.1f'),...
    'vert', 'bottom', 'horiz', 'center', 'FontWeight', 'bold', 'Color', 'k');

% Setting the axis limits for better visualization
ylim([0 10]);

% Improving style for presentation or publication purposes
set(gca, 'Box', 'off', 'FontSize', 14); % Increase font size for better readability
set(gcf, 'Color', 'w'); % Set background color to white for clean export

% Saving the figure for inclusion in publications/presentations
saveas(gcf, 'GPU_Performance_Comparison.png');

% Display the graph
grid on;


%%



set(gcf,'color','w');
Epochs = 1:50; % From epoch 1 to 50

% Hypothetical training times decreasing as epochs increase.
TensorFlowTimes = (60 - log(Epochs)) * 8; % Simulated time decrease with a base time of 60 mins
PyTorchTimes = (58 - log(Epochs)) * 2; % Slightly faster, simulated similarly

% Create a figure
figure;

% Create first axes for TensorFlow
yyaxis left; % Activates left y-axis
p1 = plot(Epochs, TensorFlowTimes, '-bo', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', 'blue');
yl = ylabel('TensorFlow Training Time (minutes)', 'FontWeight', 'bold', 'Color', 'blue'); % Bold and colored label

% Change font color to black for numerics on y-axis
set(gca, 'YColor', 'k', 'FontWeight', 'bold');  % Set y-axis numbers to black and bold

% Hold on to the same figure to plot PyTorch data against right y-axis
hold on;
yyaxis right; % Switches to right y-axis
p2 = plot(Epochs, PyTorchTimes, '-go', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerEdgeColor', 'green', 'MarkerFaceColor', 'green');
yr = ylabel('PyTorch Training Time (minutes)', 'FontWeight', 'bold', 'Color', 'green'); % Bold and colored label

% Change font color to black for numerics on y-axis
set(gca, 'YColor', 'k', 'FontWeight', 'bold', 'FontSize', 18);  % Set y-axis numbers to black and bold

% Add titles and labels
t = title( join(['GPU Performance Comparison:', newline,  'TensorFlow vs. PyTorch']) ...
                    , 'FontWeight', 'bold'); % Bold title
xl = xlabel('Number of Epochs', 'FontWeight', 'bold'); % Bold x-axis label

% Adding a legend to explain the colors
lg = legend([p1 p2], 'TensorFlow', 'PyTorch', 'Location', 'northeast');

% Ensure grid is on for better readability
grid on;
set(gcf,'color','w');











































