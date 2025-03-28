

function trimesh2obj(objExportPath, convHull, pointCloud)
    % Check if the export path directory exists
    [fileDir, ~, ~] = fileparts(objExportPath);
    if ~exist(fileDir, 'dir')
        error('Directory does not exist: %s', fileDir);
    end
    
    % Open the file for writing
    fileID = fopen(objExportPath, 'w');
    if fileID == -1
        error('Failed to open file for writing: %s', objExportPath);
    end
    
    % Write vertices
    fprintf(fileID, '# List of vertices\n');
    numVertices = size(pointCloud, 1);
    for i = 1:numVertices
        fprintf(fileID, 'v %f %f %f\n', pointCloud(i, 1), pointCloud(i, 2), pointCloud(i, 3));
    end
    
    % Write faces using convHull indices
    fprintf(fileID, '# List of faces\n');
    numFaces = size(convHull, 1);
    for i = 1:numFaces
        fprintf(fileID, 'f %d %d %d\n', convHull(i, 1), convHull(i, 2), convHull(i, 3));
    end
    
    % Close the file
    fclose(fileID);
    fprintf('Mesh successfully exported to %s\n', objExportPath);
end