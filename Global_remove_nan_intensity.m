
function [filtered_coords, filtered_intensities] = Global_remove_nan_intensity(coordinates, intensities)
    % Filter out NaN intensity values and corresponding coordinates
    valid_idx = ~isnan(intensities);  % Indices of non-NaN intensity values
    filtered_coords = coordinates(valid_idx, :);  % Filter coordinates
    filtered_intensities = intensities(valid_idx);  % Filter intensities
end