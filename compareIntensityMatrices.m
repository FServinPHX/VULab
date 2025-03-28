



function C = compareIntensityMatrices(A, B)
    % Check if the input matrices A and B have the same dimensions
    if ~isequal(size(A), size(B))
        error('Matrices A and B must have the same dimensions.');
    end
    
    % Initialize matrix C with zeros
    C = zeros(size(A));
    
    % Loop through each element of the matrices
    for i = 1:numel(A)
        if isnan(A(i)) && isnan(B(i))
            % Both A and B have NaN at the same index
            C(i) = 0;
        elseif isnan(A(i))
            % A has NaN but B does not
            C(i) = -4;
        elseif isnan(B(i))
            % B has NaN but A does not
            C(i) = -5;
        elseif A(i) < 0 && B(i) < 0
            % Both A and B have negative intensity values at the same index
            C(i) = +1;
        elseif A(i) < 0 && B(i) >= 0
            % A has a negative value and B does not
            C(i) = -1;
        elseif A(i) >= 0 && B(i) < 0
            % B has a negative value and A does not
            C(i) = -2;
        end
    end
end


% 
% function C = compareIntensityMatrices(A, B)
%     % Check if the input matrices A and B have the same dimensions
%     if ~isequal(size(A), size(B))
%         error('Matrices A and B must have the same dimensions.');
%     end
% 
%     % Initialize matrix C with zeros
%     C = zeros(size(A));
% 
%     % Loop through each element of the matrices
%     for i = 1:numel(A)
%         if isnan(A(i)) && isnan(B(i))
%             % Both A and B have NaN at the same index
%             C(i) = 0;
%         elseif isnan(A(i))
%             % A has NaN but B does not
%             C(i) = -4;
%         elseif isnan(B(i))
%             % B has NaN but A does not
%             C(i) = -5;
%         elseif A(i) == B(i)
%             % Both A and B have the same value at the index
%             C(i) = +1;
%         elseif ~isnan(A(i)) && isnan(B(i))
%             % A has a value and B has NaN
%             C(i) = -4;
%         elseif isnan(A(i)) && ~isnan(B(i))
%             % B has a value and A has NaN
%             C(i) = -5;
%         elseif ~isnan(A(i)) && ~isnan(B(i))
%             if A(i) == B(i)
%                 % Both A and B have the same non-NaN value
%                 C(i) = +1;
%             else
%                 % Both A and B have different non-NaN values at the index
%                 % If A contains a value and B doesn't or vice-versa, it was already covered
%                 % in the isNaN checks
%                 % So this part of code should just mark the different non-NaN values that exist
%                 C(i) = -1;
%             end
%         else
%             % If we reach here, one has a value while the other has none.
%             if ~isnan(A(i))
%                 % A has a value but B does not
%                 C(i) = -1;
%             elseif ~isnan(B(i))
%                 % B has a value but A does not
%                 C(i) = -2;
%             end
%         end
%     end
% end