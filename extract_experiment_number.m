function experiment_number = extract_experiment_number(input_str)
    % This function extracts the experiment number from the given string
    % using a regular expression.

    % Regular expression pattern to match "Experiment" followed by
    % any number of white spaces, and then a number from 1 to 1000.
    % The number is captured in a group for extraction.
    pattern = 'Experiment\s+(\d{1,4})';
    
    % Use regexp to search for the pattern and capture the number
    tokens = regexp(input_str, pattern, 'tokens');
    
    % Check if any match is found
    if ~isempty(tokens)
        % Convert the captured string to a number
        experiment_number = str2double(tokens{1}{1});
    else
        % No match found, return NaN or some indicator
        experiment_number = NaN;
    end
end