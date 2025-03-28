


function [phi, theta] = vecToSpherical(V)
% vecsToSpherical: Converts series of 3D vectors to spherical coordinates (phi and theta)
% Inputs:
%   V: A matrix of 3D vectors, each row is a vector [x, y, z]
% Outputs:
%   phi: A column vector of azimuthal angles in radians, range: 0 to 2*pi
%   theta: A column vector of polar angles in radians, range: 0 to pi

% Number of vectors
n = size(V, 1);

% Pre-allocate output arrays
phi = zeros(n, 1);
theta = zeros(n, 1);

% Loop through each vector
for i = 1:n
    % Extract single vector components
    x = V(i, 1);
    y = V(i, 2);
    z = V(i, 3);
    
    % Calculate the radius from the origin to the point
    r = sqrt(x^2 + y^2 + z^2);
    
    % Ensure the vector is not the zero vector
    if r == 0
        %error('One of the input vectors is the zero vector.');
        phi(i) = 0;
        theta(i) = 0;
   
    else 
    
        % Calculate the azimuthal angle phi
        phi(i) = atan2(y, x);
        
        % Handle negative phi values to keep the range within 0 to 2*pi
        if phi(i) < 0
            phi(i) = phi(i) + 2*pi;
        end
        
        % Calculate the polar angle theta
        theta(i) = acos(z / r);

    end 
end

end

% Example usage:
% V = [1 1 1; -1 -1 1; 0 1 -1]; % A series of 3 vectors
% [phi, theta] = vecsToSpherical(V)
% This will output phi and theta for each vector in V