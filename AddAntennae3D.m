function [AntennaPoints ] = AddAntennae3D( bottomPoint,  topPoint, xposition, zposition, alphaVal)

% Define common parameters for the points
y_values = linspace(bottomPoint, topPoint, 200); % 300 points between 120 and 170 for y

% Define x values for the two sets of points
x_values1 = xposition * ones(1, 200); % 300 points at x = 114

z_values  = zposition * ones(1, 200);

% Plotting


% Plot the points along the first line
scatter3(x_values1, y_values, z_values, 150,'s', 'MarkerEdgeColor', 'k', 'MarkerEdgeAlpha', .05,...
    'MarkerFaceColor', 'k', 'MarkerFaceAlpha', alphaVal );
hold on; % Hold on to plot the second set of points on the same figure

AntennaPoints = [x_values1',  y_values'] ;
end 