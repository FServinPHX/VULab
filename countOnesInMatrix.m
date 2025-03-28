function count = countOnesInMatrix(matrix)
    % This function returns the number of times the number 1 appears in matrix

    % Flatten the matrix into a single column vector
    matrix_flat = matrix(:);

    % Find the number of 1's in the matrix
    count = sum(matrix_flat == 1);
end