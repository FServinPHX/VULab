
% Function to estimate the initial center of the grid
function center = estimateCenter(xyzData)
    n = nthroot(size(xyzData, 1), 3);
    center = [(n+1)/2, (n+1)/2, (n+1)/2]; % Approximate center
end