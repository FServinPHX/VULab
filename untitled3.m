
% Load the CSV data
%

% ALL RUNS
%       "D:\ML COMSOL Models\COMSOL LowFat\ All_Volume RUNS- 9 .csv"
%       "D:\ML COMSOL Models\COMSOL MildFat\ All_Volume RUNS- 9 .csv"
%       "D:\ML COMSOL Models\COMSOL ModerateFat\ All_Volume RUNS- 9 .csv"
%       "D:\ML COMSOL Models\COMSOL ZHighFat\ All_Volume RUNS- 9 .csv"


data = readmatrix("D:\ML COMSOL Models\COMSOL LowFat\ All_Volume RUNS- 9 .csv");

% Calculate the minimum, maximum, and mean for each time point
min_values = min(data, [], 2); % Minimum across each row (time point)
max_values = max(data, [], 2); % Maximum across each row (time point)
mean_values = mean(data, 2);   % Mean across each row (time point)

% Plotting
figure;
hold on;

% Plot the mean trajectory
plot(mean_values, 'LineWidth', 2, 'Color', 'b', 'DisplayName', 'Mean Trajectory');

% Plot the minimum and maximum trajectories
plot(min_values, 'LineStyle', '--', 'Color', 'r', 'DisplayName', 'Minimum Trajectory');
plot(max_values, 'LineStyle', '--', 'Color', 'g', 'DisplayName', 'Maximum Trajectory');

% Fill the area between the min and max trajectories
fill_area = fill([1:length(min_values), fliplr(1:length(max_values))], ...
                [min_values', fliplr(max_values')], 'g', 'FaceAlpha', 0.45, 'EdgeColor', 'none');
set(fill_area, 'FaceColor', [0.5 1 0.5]); % Set color to green with specified transparency

% Add legends and labels
legend;
xlabel('Time Point');
ylabel('Value');
title('Trajectory Plot with Mean, Min, and Max Values');
grid on;

hold off;

%%


% Define the paths for CSV files
filePaths = {
    "D:\ML COMSOL Models\COMSOL LowFat\ All_Volume RUNS- 9 .csv",
    "D:\ML COMSOL Models\COMSOL MildFat\ All_Volume RUNS- 9 .csv",
    "D:\ML COMSOL Models\COMSOL ModerateFat\ All_Volume RUNS- 9 .csv",
    "D:\ML COMSOL Models\COMSOL ZHighFat\ All_Volume RUNS- 9 .csv"
};

% Define categories and corresponding colors
categories = {'Low Fat', 'Mild Fat', 'Moderate Fat', 'High Fat'};
colors = {[0 1 0], [1 1 0], [1 0.5 0], [0.5 0 0.5]}; % Green, Yellow, Orange, Purple

% Initialize a figure for plotting
figure;
hold on;
legendEntries = cell(1, length(filePaths));

% Loop through each file, load the data, and plot
for i = 1:length(filePaths)
    % Read the CSV data
    data = readmatrix(filePaths{i});
    
    % Calculate the mean for each time point
    mean_values = mean(data, 2); % Mean across each row (time point)
    
    % Plot the mean trajectory for each category
    plot(mean_values, 'LineWidth', 2, 'Color', colors{i}, 'DisplayName', categories{i});
    
    % Store legend entries
    legendEntries{i} = sprintf('%s (Mean Average)', categories{i});
end

% Customize the plot's legend and labels
legend(legendEntries, 'Location', 'Best');
xlabel('Time Point');
ylabel('Average Value');
title('Average Fat Content Trajectories');
grid on;
hold off;
