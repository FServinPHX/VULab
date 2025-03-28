

% % Generate 100,000 random points for A from a normal distribution (mean=50, std=10)
% A = 50 + 10.*randn(100000, 1);
% 
% % Generate 100,000 random points for B from a uniform distribution (range [30, 70])
% B = 30 + 40.*rand(100000, 1); % (Uniform distribution from 30 to 70)
% 
% 
% B_new = matchHistograms(A, B)

function B_new = matchHistograms(A, B)
    % Ensure the data are in vector form
    A = A(:);
    B = B(:);

    % Histogram of A (reference histogram)
    [countsA, binEdgesA] = histcounts(A, 256);
    % Histogram of B (to be modified)
    [countsB, binEdgesB] = histcounts(B, 256);

    % Calculate cumulative distribution function (CDF) for A and B
    cdfA = cumsum(countsA) / sum(countsA);
    cdfB = cumsum(countsB) / sum(countsB);

    % Ensure unique for interp1 by using unique CDF values
    [uniqueCdfB, uniqueI] = unique(cdfB);
    uniqueBinEdgesB = binEdgesB(uniqueI);

    % Create an interpolation to match histograms
    lookupTable = interp1(uniqueCdfB, uniqueBinEdgesB, cdfA, 'pchip', 'extrap');

    % Apply the mapping
    B_new = interp1(binEdgesB(1:end-1), lookupTable, B, 'pchip', 'extrap');

    % Plotting code commented out for clarity

    % Plotting
    figure(2);
    subplot(2, 2, 1);
    histogram(A, 256);
    title('Distribution of A');

    subplot(2, 2, 2);
    histogram(B, 256);
    title('Distribution of B Before');

    subplot(2, 2, 3);
    histogram(B_new, 256);
    title('Distribution of B After');

    % Adjust layout
    subplot(2, 2, 4);
    plot(binEdgesA(1:end-1), cdfA, 'r-'); hold on;
    plot(binEdgesB(1:end-1), cdfB, 'b--');
    title('CDF Comparison');
    legend('CDF of A', 'CDF of B', 'location', 'southeast');

    hold off
end