function contourEdges(x,y,u,varargin)
    %CONTOUREDGES Contour plot following pixel edges.
    %   CONTOUREDGES(X,Y,Z,V) draw a contour line for each
    %   level specified in vector V.  Use CONTOUREDGES(X,Y,Z,[v v]) to 
    %   draw contours for the single level v.
    %   X and Y must be rows (or column) vecors and Z must be a MxN matrix.
    %
    %   Example:
    %       
    %       data = gauss2d(23,37);
    %       x = linspace(0,1,37);
    %       y = linspace(5,20,23);
    %       imagesc(x,y,data)
    %       m = mean(mean(data));        
    %       %To plot only the level m
    %       contourEdges(x,y,data,[m m])
    %       %To plot more levels: contourEdges(x,y,data,[m/2 m 2*m])
if isempty(varargin) || numel(varargin{1}) < 2
    message = ['Automatic selection of levels is not supported yet. A'...
        'simple workaround is to run [~,C] = contour(x,y,Z,{n}) and then'...
        'use C.LevelList as the fourth parameter here.'];
    error(message);
else
    contourLevels = unique(varargin{1});
end
x = [x(1)-(x(2)-x(1)); x(:); x(end)+(x(2)-x(1))];
y = [y(1)-(y(2)-y(1)); y(:); y(end)+(y(2)-y(1))];
edgesx = mean([x(2:end)';x(1:end-1)']);
edgesy = mean([y(2:end)';y(1:end-1)']);
inputExist = find(cellfun(@(x) strcmpi(x, 'linewidth') , varargin));
if isempty(inputExist)
  varargin{end+1} = 'linewidth';
  varargin{end+1} = 3;
end
if length(varargin{2})>4 && isempty(inputExist)
    varargin{end+1} = 'color';
    varargin{end+1} = [1 0 0];
end
ax = gca;
for contIdx=1:length(contourLevels)
    idx = u > contourLevels(contIdx);
    [a,b] = find(idx);
    for i=1:length(a)
            if b(i) == 1
                ax.ColorOrderIndex = 1;
                hold on;plot([edgesx(b(i)) edgesx(b(i))],[edgesy(a(i)) edgesy(a(i)+1)],varargin{2:end});
            end
            if b(i) ~= size(idx,2)
                if isempty(find(a==a(i) & b==(b(i)+1),1))
                    ax.ColorOrderIndex = 1;
                    hold on;plot([edgesx(b(i)+1) edgesx(b(i)+1)],[edgesy(a(i)) edgesy(a(i)+1)],varargin{2:end});
                end
            end
            if b(i) == size(idx,2)
                ax.ColorOrderIndex = 1;
                hold on;plot([edgesx(b(i)+1) edgesx(b(i)+1)],[edgesy(a(i)) edgesy(a(i)+1)],varargin{2:end});
            end
            if b(i) ~= 1
                if isempty(find(a==a(i) & b==(b(i)-1),1))
                    ax.ColorOrderIndex = 1;
                    hold on;plot([edgesx(b(i)) edgesx(b(i))],[edgesy(a(i)) edgesy(a(i)+1)],varargin{2:end});
                end
            end

            if a(i) == 1
                ax.ColorOrderIndex = 1;
                hold on;plot([edgesx(b(i)) edgesx(b(i)+1)],[edgesy(a(i)) edgesy(a(i))],varargin{2:end});
            end
            if a(i) ~= size(idx,1)
                if isempty(find(b==b(i) & a==(a(i)+1),1))
                    ax.ColorOrderIndex = 1;
                    hold on;plot([edgesx(b(i)) edgesx(b(i)+1)] ,[edgesy(a(i)+1) edgesy(a(i)+1)],varargin{2:end});
                end
            end
            if a(i) == size(idx,1)
                ax.ColorOrderIndex = 1;
                hold on;plot([edgesx(b(i)) edgesx(b(i)+1)],[edgesy(a(i)+1) edgesy(a(i)+1)],varargin{2:end});
            end
            if a(i) ~= 1
                if isempty(find(b==b(i) & a==(a(i)-1),1))
                    ax.ColorOrderIndex = 1;
                    hold on;plot([edgesx(b(i)) edgesx(b(i)+1)],[edgesy(a(i)) edgesy(a(i))],varargin{2:end});
                end
            end
    end
end