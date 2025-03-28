





















function inside = pointInTriangulatedSphere(point, vertices, faces)
    % Compute the centroid of the sphere
    centroid = mean(vertices, 1);
    
    % Initialize as outside
    inside = false;
    
    % Number of triangle faces
    numFaces = size(faces, 1);
    
    for i = 1:numFaces
        % Get the vertices of the current triangle
        v0 = vertices(faces(i, 1), :);
        v1 = vertices(faces(i, 2), :);
        v2 = vertices(faces(i, 3), :);

        % Compute vectors
        v0v1 = v1 - v0;
        v0v2 = v2 - v0;
        v0p = point - v0;

        % Compute dot products
        dot00 = dot(v0v1, v0v1);
        dot01 = dot(v0v1, v0v2);
        dot02 = dot(v0v1, v0p);
        dot11 = dot(v0v2, v0v2);
        dot12 = dot(v0v2, v0p);

        % Compute barycentric coordinates
        invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
        u = (dot11 * dot02 - dot01 * dot12) * invDenom;
        v = (dot00 * dot12 - dot01 * dot02) * invDenom;

        % Check if point is in triangle
        if (u >= 0) && (v >= 0) && (u + v <= 1)
            inside = true;
            break;
        end
    end
end







