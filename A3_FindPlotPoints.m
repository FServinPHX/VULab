






function [ProbePointExport, plotedLine1, plotedLine2] =  A3_FindPlotPoints(file_path)


    MphName = file_path;

    input_str = MphName;
    experiment_num = extract_experiment_number(input_str);
    %disp(['The experiment number is: ', num2str(experiment_num)]);
    ProbeFilePath = "D:\Import To Matlab\Aim 3_ProbePlacements\ALL Experiment Dual Probe Placement Information.csv";
    [filepath2,name2,ext] = fileparts(ProbeFilePath);    
    OGdata = readtable(ProbeFilePath);
    AntnaNames = ( OGdata(:, 1) );
    data2 = table2array(OGdata(:, 2:end));
            % Example table creation with a single column of names
            T = AntnaNames;
            % Assuming all names are stored in the first column, convert to string matrix
            if istable(T) && width(T) >= 1
                % Preallocate string array based on the number of rows in the table
                stringMatrix = strings(height(T), 1);
                % Iterate through the table and fill the string matrix
                for i = 1:height(T)
                    % Assign each name to the string array
                    stringMatrix(i) = string(T.Name(i));
                end
            end
            AntnaNames = stringMatrix;
    %
        experiment_num_Ant_All = [];
        for i = 1: size(AntnaNames,1)
            experiment_num_Ant = extract_experiment_number(AntnaNames(i));
            experiment_num_Ant_All = [experiment_num_Ant_All ,experiment_num_Ant];
        end
    % Find the indices of the specific number
    [rowIndices, colIndices] = find(experiment_num_Ant_All == experiment_num);
    % Combine row and column indices to have pairs of indices
    indices = [colIndices];
    %
    %


                        disp( join(['The FOUND experiment number is: ' , ...
                                        num2str( experiment_num_Ant_All(indices) ) ]) )
    % %startPoint = 3;
    % disp("       DATA   LOADING   FINISHED       "  )



    lineSize = 50;
    % Given parameters
        theta = data2( indices(1) , 1); % degrees
        phi   = data2(indices(1), 2); % degrees
        center = [data2(indices(1), 3) , data2(indices(1), 4) , data2(indices(1), 5) ]; % Starting point
        lengthLine = lineSize; % Length of the line   
        % Plotting the 3D line
    [plotedLine1] =  plot3DLineFromSpherical(phi, theta, center, lengthLine);
            % plot3( plotedLine1(:,1), plotedLine1(:,2), plotedLine1(:,3), ...
            %         'k.', 'MarkerSize', 10
        theta2 = data2(indices(1), 6); % degrees
        phi2   = data2(indices(1), 7); % degrees
        center2 = [data2(indices(1), 8) , data2(indices(1), 9) , data2(indices(1), 10) ]; % Starting point
        lengthLine = lineSize; % Length of the line   
        % Plotting the 3D line
    [plotedLine2] =plot3DLineFromSpherical(phi2, theta2, center2, lengthLine);
            % plot3( plotedLine2(:,1), plotedLine2(:,2), plotedLine2(:,3), ...
            %         'k.', 'MarkerSize', 10 )




A = [plotedLine1; plotedLine2] ;


ProbePointExport = A; 
end 