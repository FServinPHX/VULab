



function saveCurrentPlot(directoryPath, fileName)
    % saveCurrentPlot Saves the current active plot to a specified directory.
    %
    % Parameters:
    %   directoryPath (string): The directory path where the plot will be saved.
    %   fileName (string): The desired filename for the saved plot.
    %
    % The function saves the plot as a high-resolution PNG image with at least 300 DPI.

    % Verify if the directory exists, if not, throw an error
    if ~isfolder(directoryPath)
        error('Directory does not exist. Please provide a valid directory path.');
    end

    % Concatenate directory and filename to create full file path
    fullFilePath = fullfile(directoryPath, fileName);

    % Ensure the file has an appropriate extension
    [~, ~, ext] = fileparts(fullFilePath);
    if isempty(ext)
        ext = '.png';
        fullFilePath = [fullFilePath ext];
    end

    % Check if extension is supported
    validExtensions = {'.png', '.tiff', '.tif'};
    if ~ismember(ext, validExtensions)
        error('Unsupported file format. Please use PNG or TIFF.');
    end

    % Set figure properties for high-resolution output
    set(gcf, 'PaperPositionMode', 'auto');

     f = gcf;
     exportgraphics(f,fullFilePath,'Resolution', 500)

    fprintf('Plot successfully saved to %s\n', fullFilePath);
end