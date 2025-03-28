
% clear 

% % Step 1 & 2: Create two 3D points
P1 = [0, 0, 0]; % Point 1
% P2 = [0, 30, 30]; % Point 2 at least 10 units away

% Step 3: Calculate the vector between two points
vector = P2 - P1; 

% Step 4: Converting Cartesian Coordinates to Spherical Coordinates
r = norm(vector);                    % Scalar Distance
theta = atan2(norm(vector(1:2)), vector(3));     % Inclination angle
psi = atan2(vector(2), vector(1));           % Azimuth Angle

% Convert from radian to degree
theta = theta*180/pi; 
psi = psi*180/pi; 

% Find the axis of rotation
axisOfRotation = cross([0 0 1], vector);
axisOfRotation = axisOfRotation/norm(axisOfRotation); % Normalize to unit vector

% Step 7: Plotting

% Setting the 3D space and labels
figure;
hold on;
grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');

% Plotting the point at P2
plot3(P2(1), P2(2), P2(3), 'r*');
plot3(P1(1), P1(2), P1(3), 'b*')

% Plot the vector
quiver3(P1(1),P1(2),P1(3),vector(1),vector(2),vector(3), 'b');

% Plot the axis of rotation
quiver3(0,0,0,axisOfRotation(1),axisOfRotation(2),axisOfRotation(3), 'g');

% % Adding Annotations
% text(P2(1), P2(2), P2(3), ' P2');
% text(axisOfRotation(1), axisOfRotation(2), axisOfRotation(3), ' Axis of rotation');
% 
% % Plot legend
% legend('Point P2', 'Vector', 'Axis of Rotation', 'Location', 'best');


titleName = join([ 'Polar Angle (theta) = ' , num2str(theta) ,' degrees', newline...
                    'Azimutal Angle (phi) = ', num2str(psi) ,' degrees ', newline...
                    'r =', num2str(r) ,' units']);
% titleName = sprintf('Polar Angle (theta) = %.2f degrees, Azimutal Angle (phi) = %.2f degrees, r = %.2f units', theta, psi, r);


title( titleName );

hold off;
xlim([-50 50])
ylim([-50 50])
zlim([0 60])
grid off


% 
% axis equal
%%


% Define the points as a matrix
points = A__All_ProbePoints;

% Initialize an empty cell array to store indices
indicesOver10 = cell(size(points, 1), 1);

% Loop through each row of points
for i = 1:size(points,1)
    % Extract the second set of points from the current row
    point1 = points(i, 4:6);
    
    % Initialize an empty array to store distances
    distances = zeros(size(points, 1), 1);
    
    % Loop through all other rows 
    for j = 1:size(points,1)
        if i ~= j
            % Extract the second set of points from the other row
            point2 = points(j, 4:6);
            
            % Calculate the Euclidean distance
            distances(j) = sqrt(sum((point1 - point2).^2));
        end
    end
    
    % Find indices where distance is greater than 10 units
    indicesOver10{i} = find(distances > 10);
end

% Display the indices of points over 10 units away
%indicesOver10

%%

% Step 1: Create 20 x, y pairs
x = linspace(-10, 10, 20); % Generate 20 linearly spaced x values
true_slope = 2; % Define an arbitrary slope for the true underlying relationship
y_intercept = -5; % Define the y-intercept for the true line
noise = randn(size(x)); % Generate random noise
y = true_slope * x + y_intercept + noise; % Generate y values based on the true line with some added noise

% Step 2: Calculate the slope of the best fitting line
n = length(x);
sum_x = sum(x);
sum_y = sum(y);
sum_xy = sum(x .* y);
sum_x2 = sum(x .^ 2);

calculated_slope = (n*sum_xy - sum_x*sum_y) / (n*sum_x2 - sum_x^2);
calculated_intercept = (sum_y - calculated_slope*sum_x) / n;

% Step 3: Plot the points and the line
figure; % Create a new figure
plot(x, y, 'bo'); % Plot the points
hold on; % Keep the plot for adding the line

% Calculate the y values of the line based on the calculated slope and intercept
y_line = calculated_slope * x + calculated_intercept;
plot(x, y_line, 'r-'); % Plot the line

% Adding the equation of the line on the plot
eqn_str = sprintf('y = %.2fx + %.2f', calculated_slope, calculated_intercept);
text(mean(x), mean(y), eqn_str, 'FontSize', 12); % Display the equation on the plot

% Enhance plot appearance
xlabel('X');
ylabel('Y');
title('Plot of Points and Fitted Line');
legend('Data points', 'Fitted Line');
grid on;


%%



% Step 1: Generate 60 (x, y) pairs following a quadratic relationship
x = linspace(-10, 10, 60); % 60 x values linearly spaced
a_true = 1; % True quadratic coefficient
b_true = -2; % True linear coefficient
c_true = 3; % True constant term
noise = randn(size(x))*10; % Adding some random noise
y = a_true*x.^2 + b_true*x + c_true + noise; % Quadratic equation with noise

% Step 2: Calculate the quadratic curve fit
coeffs = polyfit(x, y, 2); % Polynomial fit of degree 2 (quadratic fit)
a_est = coeffs(1); % Estimated quadratic coefficient
b_est = coeffs(2); % Estimated linear coefficient
c_est = coeffs(3); % Estimated constant term

% Step 3: Plot the points and the quadratic curve
x_fit = linspace(min(x), max(x), 400); % x values for plotting the fit curve
y_fit = polyval(coeffs, x_fit); % Evaluate the polynomial at x_fit

figure; % Create a new figure window
plot(x, y, 'bo', 'MarkerFaceColor', 'blue'); % Plot original points
hold on; % Keep the plot for adding the quadratic curve
plot(x_fit, y_fit, 'r-', 'LineWidth', 2); % Plot the quadratic curve

% Adding the equation of the quadratic curve on the plot
eqn_str = sprintf('y = %.2fx^2 + %.2fx + %.2f', a_est, b_est, c_est);
text(min(x_fit), max(y), eqn_str, 'FontSize', 12, 'BackgroundColor', 'white'); % Display the equation

% Enhance plot appearance
xlabel('X');
ylabel('Y');
title('Plot of Points and Fitted Quadratic Curve');
legend('Data points', 'Fitted Quadratic Curve');
grid on; % Add grid for better readability



%%





% Step 1: Generate 60 (x, y) pairs following a cubic relationship
x = linspace(-10, 10, 60); % 60 x values linearly spaced
a_true = 0.5; % True cubic coefficient
b_true = -1.5; % True quadratic coefficient
c_true = 2; % True linear coefficient
d_true = -3; % True constant term
noise = randn(size(x))*15; % Adding some random noise
y = a_true*x.^3 + b_true*x.^2 + c_true*x + d_true + noise; % Cubic equation with noise

% Step 2: Calculate the cubic curve fit
coeffs = polyfit(x, y, 3); % Polynomial fit of degree 3 (cubic fit)
% coeffs(1) corresponds to a, coeffs(2) to b, etc.

% Step 3: Plot the points and the cubic curve
x_fit = linspace(min(x), max(x), 400); % x values for plotting the fit curve
y_fit = polyval(coeffs, x_fit); % Evaluate the polynomial at x_fit

figure; % Create a new figure window
plot(x, y, 'bo', 'MarkerFaceColor', 'blue'); % Plot original points
hold on; % Keep the plot for adding the cubic curve
plot(x_fit, y_fit, 'r-', 'LineWidth', 2); % Plot the cubic curve

% Adding the equation of the cubic curve on the plot
eqn_str = sprintf('y = %.2fx^3 + %.2fx^2 + %.2fx + %.2f', coeffs(1), coeffs(2), coeffs(3), coeffs(4));
text(min(x_fit), max(y), eqn_str, 'FontSize', 12, 'BackgroundColor', 'white'); % Display the equation

% Enhance plot appearance
xlabel('X');
ylabel('Y');
title('Plot of Points and Fitted Cubic Curve');
legend('Data points', 'Fitted Cubic Curve');
grid on; % Add grid for better readability





%%




% Step 1: Generate 60 (x, y) pairs following a 4th-degree polynomial relationship
x = linspace(-10, 10, 60); % 60 x values linearly spaced
a_true = 0.05; % True 4th-degree coefficient
b_true = -0.1; % True 3rd-degree coefficient
c_true = 0.5; % True quadratic coefficient
d_true = -1; % True linear coefficient
e_true = 2; % True constant term
noise = randn(size(x))*20; % Adding random noise
y = a_true*x.^4 + b_true*x.^3 + c_true*x.^2 + d_true*x + e_true + noise; % 4th-degree equation with noise

% Step 2: Calculate the 4th-degree polynomial fit
coeffs = polyfit(x, y, 4); % Polynomial fit of degree 4

% Step 3: Plot the points and the 4th-degree polynomial curve
x_fit = linspace(min(x), max(x), 400); % x values for plotting the fit curve
y_fit = polyval(coeffs, x_fit); % Evaluate the polynomial at x_fit

figure; % Create a new figure window
plot(x, y, 'bo', 'MarkerFaceColor', 'cyan'); % Plot original points
hold on; % Keep the plot for plotting the polynomial curve
plot(x_fit, y_fit, 'r-', 'LineWidth', 2); % Plot the 4th-degree curve

% Adding the equation of the 4th-degree polynomial curve on the plot
eqn_str = sprintf('y = %.2fx^4 + %.2fx^3 + %.2fx^2 + %.2fx + %.2f', ...
                  coeffs(1), coeffs(2), coeffs(3), coeffs(4), coeffs(5));
text(min(x_fit), max(y), eqn_str, 'FontSize', 12, 'BackgroundColor', 'white'); % Display the equation

% Enhance plot appearance
xlabel('X');
ylabel('Y');
title('Plot of Points and Fitted 4th-Degree Polynomial Curve');
legend('Data points', 'Fitted 4th-Degree Polynomial Curve');
grid on; % Add grid for better readability


%%




