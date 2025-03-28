
function [AntennaPoints ] = AddAntennae2D( bottomPoint,  topPoint, position)

% Define common parameters for the points
y_values = linspace(bottomPoint, topPoint, 200); % 300 points between 120 and 170 for y

% Define x values for the two sets of points
x_values1 = position * ones(1, 200); % 300 points at x = 114

% Plotting


% Plot the points along the first line
scatter(x_values1, y_values, 's', 'MarkerEdgeColor', 'k', 'MarkerEdgeAlpha', .05,...
    'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 0.1);
hold on; % Hold on to plot the second set of points on the same figure

AntennaPoints = [x_values1',  y_values'] ;
end 