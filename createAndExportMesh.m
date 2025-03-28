
function createAndExportMesh(filePath)
    % Check if the filePath directory exists
    if ~isfolder(filePath)
        error('The specified directory does not exist.');
    end

    % Create a unit sphere mesh
    [X, Y, Z] = sphere(20); % 20x20 mesh

    % Open the file for writing
    objFileName = fullfile(filePath, 'sphere_mesh.obj');
    fileID = fopen(objFileName, 'w');

    % Write vertices
    fprintf(fileID, '# List of vertices\n');
    for i = 1:size(X, 1)
        for j = 1:size(X, 2)
            fprintf(fileID, 'v %f %f %f\n', X(i, j), Y(i, j), Z(i, j));
        end
    end

    % Write faces
    fprintf(fileID, '# List of faces\n');
    numVertices = size(X, 1);
    for i = 1:(numVertices - 1)
        for j = 1:(numVertices - 1)
            v1 = (i - 1) * numVertices + j;
            v2 = v1 + 1;
            v3 = v1 + numVertices;
            v4 = v3 + 1;
            fprintf(fileID, 'f %d %d %d\n', v1, v2, v3);
            fprintf(fileID, 'f %d %d %d\n', v2, v3, v4);
        end
    end

    % Close the file
    fclose(fileID);
    fprintf('Mesh successfully exported to %s\n', objFileName);
end