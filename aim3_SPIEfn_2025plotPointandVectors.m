
function  [out] = aim3_SPIEfn_2025plotPointandVectors(  GroundTruthPoints,  GroundTruthDataVectors )


VecLenLow = 2;
VecLenUpp = 4; 
% Assuming 'GroundTruthPoints' and 'GroundTruthDataVectors' have been properly defined
P = GroundTruthPoints; % Points matrix
vectors1 = GroundTruthDataVectors;
%
% Calculate the magnitudes of the original vectors
original_magnitudes = sqrt(sum(vectors1.^2, 2)); % Each row is a vector
% Normalize the vectors to unit length
normalized_vectors = vectors1 ./ original_magnitudes;
% Generate random lengths between 1.5 and 3 for each vector
random_lengths = VecLenLow + (VecLenUpp - VecLenLow) * rand(size(vectors1, 1), 1);
% Rescale the normalized vectors to the new random lengths
scaled_vectors = normalized_vectors .* random_lengths;
% Calculate vector magnitudes for color coding
magnitudes = sqrt(sum(scaled_vectors.^2, 2)); % assuming each row is a vector


% % Perform the scatter plot for the original points
scatter3(P(:, 1), P(:, 2), P(:, 3), 12, 'filled', 'Color', 'k');


hold on;

% Color code the vectors based on their magnitude
cols = colormap(jet); % Using jet color map
c_ticks = linspace(min(magnitudes), max(magnitudes), size(cols, 1)); % Map magnitudes to color range
[~, c_indices] = min(abs(c_ticks - magnitudes), [], 2);
% Plot color-coded scaled vectors
% quiver3(P(:, 1), P(:, 2), P(:, 3), ...
%         scaled_vectors(:, 1), scaled_vectors(:, 2), scaled_vectors(:, 3), ...
%         0, 'LineWidth', 2, 'Color', [0.5 0.5 0.5]); % Default grey color

% Overdraw the colored quivers
for i = 1:length(magnitudes)
    quiver3(P(i, 1), P(i, 2), P(i, 3), ...
            scaled_vectors(i, 1), scaled_vectors(i, 2), scaled_vectors(i, 3), ...
            0, 'LineWidth', .75, 'Color', cols(c_indices(i), :));
end


% Perform the scatter plot for the original points
scatter3(P(:, 1), P(:, 2), P(:, 3), 12, 'filled', 'Color', 'k');



% Create the color bar to indicate vector magnitude
% lower = round( (mean(original_magnitudes) - std(original_magnitudes)*2), 0) ;
% upper = round( mean(original_magnitudes) + std(original_magnitudes)*2, 1) ;
% caxis([lower  upper])
% Create the colorbar


% cb=colorbar;
% cb.FontSize = 16;
% title(cb, join(['Vector', newline, 'Mag.']) );
% currentPosition = cb.Position;
% % Modify the height to be half of the original by changing the 4th element
% % of the position vector. Also, adjust the bottom position to center the colorbar.
% newHeight = currentPosition(4) / 1.5; % New height is half of the original
% newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
% cb.Position = [ currentPosition(1),   newBottom , currentPosition(3), ( .85)  ];


out = [original_magnitudes] ;

end 





