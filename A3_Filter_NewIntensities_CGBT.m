



function new_intensities = A3_Filter_NewIntensities_CGBT(data, midpoint)
% A3_Filter_NewIntensities
% This function modifies intensity values for data points within a certain 
% distance from a midpoint, specifically when those intensities are negative 
% and below the average negative intensity.
%
% Inputs:
% - data: Nx4 matrix where each row is [x, y, z, intensity].
% - midpoint: 1x2 vector [x_mid, y_mid] for calculating proximity.
%
% Output:
% - new_intensities: Modified intensity values based on specified conditions.

% Extract the x, y coordinates and intensities from the data
x = data(:, 1);
y = data(:, 2);
intensities = data(:, 4);

% Calculate mean and standard deviation for negative intensities
negativeIntensities = intensities(intensities < 0);
meanNegativeIntensity = mean(negativeIntensities);
stdNegativeIntensity = std(negativeIntensities);

% Adjust the mean considering standard deviation (optimizing for clarity)
adjustedMeanNegativeIntensity = meanNegativeIntensity - abs(stdNegativeIntensity);

% Initialize new_intensities with the original ones
new_intensities = intensities;

% Define distance separation for x and y
distSep = 15;

% Create a logical mask for conditions:
% 1. Distance within the specified threshold from the midpoint (x and y only)
% 2. Intensity is negative
% 3. Intensity is less than the adjusted mean of negative intensities
conditions = (abs(x - midpoint(1)) <= distSep) & ...
             (abs(y - midpoint(2)) <= distSep) & ...
             (intensities < 0) & ...
             (intensities < adjustedMeanNegativeIntensity);

% Invert the intensities for points that meet the conditions
new_intensities(conditions) = -new_intensities(conditions);

end