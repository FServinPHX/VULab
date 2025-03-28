% 
% % Example data [x, y, z, intensity]
% data = [1 2 3 -10; 4 5 6 -20; 1.1 2.1 3.2 5; 5.9 2.1 3.3 -5];
% 
% % Example midpoint
% midpoint = [1, 2, 3];
% 
% % Call the function
% new_intensities = functionName(data, midpoint);



function new_intensities = A3_Filter_NewIntensities_dSep(data, midpoint, distSep)


    % Extract the x, y, z coordinates and intensities from the data
    x = data(:, 1);
    y = data(:, 2);
    z = data(:, 3);
    intensities = data(:, 4);

    % Calculate the mean of the negative intensities
    meanNegativeIntensity = mean(intensities(intensities < 0));
    stdNegativeIntensity = mean(intensities(intensities < 0));
    %
    meanNegativeIntensity = meanNegativeIntensity - abs(stdNegativeIntensity);




    % Initialize new_intensities with the original intensities
    new_intensities = intensities;
    % Apply the conditions:
    % 1. Distance within 5 units from the midpoint (x and y only)
    % 2. Intensity is negative
    % 3. Intensity is less than the average negative intensity
    %distSep = 15;

    conditions = (abs(x - midpoint(1)) <= distSep) & (abs(y - midpoint(2)) <= distSep) & ...
                 (intensities < 0) & (intensities < meanNegativeIntensity);

    % Invert the intensities for points that meet the conditions
    new_intensities(conditions) = -new_intensities(conditions);

    % Output the new intensities
end