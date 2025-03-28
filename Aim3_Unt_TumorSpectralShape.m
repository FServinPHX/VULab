

% Generate some data and a plot
tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Scout_Tumor_Export.stl";
TumorData = stlread(tumorfile);
TumorPoints = TumorData.Points;

numpoints = 900;
[ TumorPoints ] = UpsampledAblationSpec( TumorPoints, numpoints ) ;
[ distances ] = SpectralDistance(    TumorPoints ) ;




    P = TumorPoints;
    figure()
    set(gcf,'color','w');  
    scatter3( P(:,1) , P(:,2) ,P(:,3), 50,   distances, "filled") 
        colormap jet
        % Add a colorbar
        cb = colorbar;
        cb.FontSize = 14;
        % Set a title for the colorbar
        title(cb, join(["Spectral Distance", newline, "(mm)"]) );
        % Get current position of the colorbar
        currentPosition = cb.Position;
        % Modify the height to be half of the original by changing the 4th element
        % of the position vector. Also, adjust the bottom position to center the colorbar.
        newHeight = currentPosition(4) / 1.5; % New height is half of the original
        newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
        cb.Position = [currentPosition(1) newBottom currentPosition(3) newHeight];

% Additional plot formatting
title( join(["Spectral Coordinates", newline, "Tumor"]), 'FontSize', 20);
axis equal 
grid off


%%

% Generate some data and a plot
tumorfile = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Scout_Tumor_Export.stl";
TumorData = stlread(tumorfile);
TumorPoints = TumorData.Points;
ConnectivityList = TumorData.ConnectivityList;  

% numpoints = 900;
% [ TumorPoints ] = UpsampledAblationSpec( TumorPoints, numpoints ) ;
[ distances ] = SpectralDistance(    TumorPoints ) ;

    set(gcf,'color','w');  

%         scatter3(Xsct,Ysct,Zsct,S,C2, 'filled') 
    pt = trisurf( ConnectivityList ,TumorPoints(:,1) , TumorPoints(:,2) , TumorPoints(:,3), ...
                    distances, 'EdgeColor',...
                    rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha',1 );
              
%         pt = trisurf( STumor.faces , P2(:,1) , P2(:,2) , P2(:,3),  C2, 'EdgeColor',...
%                       rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha',.9 );


        colormap jet
        % Add a colorbar
        cb = colorbar;
        cb.FontSize = 14;
        % Set a title for the colorbar
        title(cb, join(["Spectral Distance", newline, "(mm)"]) );
        % Get current position of the colorbar
        currentPosition = cb.Position;
        % Modify the height to be half of the original by changing the 4th element
        % of the position vector. Also, adjust the bottom position to center the colorbar.
        newHeight = currentPosition(4) / 1.5; % New height is half of the original
        newBottom = currentPosition(2) + (currentPosition(4) - newHeight)/2; % Adjust bottom to center
        cb.Position = [currentPosition(1) newBottom currentPosition(3) newHeight];

% Additional plot formatting
title( join(["Spectral Coordinates", newline, "Tumor"]), 'FontSize', 20);
axis equal 
grid off
