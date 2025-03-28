

%Input: iNewText = Text Data (Fat Conent), x,y,z, 
%       shp = slpha shape you are intersecting
%output: correct alignment. 


function [ capturedData, capturedfat  ]  = liverWfatIntersectHistogram(iNewText, shp, patient, plotIntersectGrid, plotIntersectHistogram) 
    gold = [0.847058824	0.670588235	0.298039216];
    blue = [0 0.4470 0.7410];
    green = [0.4660 0.6740 0.1880];
    red = [0.6	0.239215686	0.105882353];
    orange = [0.8500 0.3250 0.0980];
    purple = [0.4940 0.1840 0.5560];
    black = [0	0	0];
    
%     plotIntersectGrid = "F";
%     plotIntersectHistogram = "F";

    qx = iNewText(:,2) ;  
    qy = iNewText(:,3) ;
    qz = iNewText(:,4) ;
    %find the intersection 
    indx.in = inShape(shp, qx, qy, qz );

    fat = iNewText(:,1);
    capturedfat = fat(indx.in);
    capturedCoords = [qx(indx.in), qy(indx.in),...
        qz(indx.in)];
    
    
%     figure()
%     set(gcf,'color','w');
%     scatter3(qx, qy, qz, .5 ,iNewText(:,1)  )
%     colormap('jet');
%     title("Regular Grid Fat Fraction Data")
%     xlabel("X")
%     ylabel("Y")
%     zlabel("Z")   
    
if strcmp(plotIntersectGrid,"T")    
    figure()
    set(gcf,'color','w');
    scatter3(capturedCoords(:,1), capturedCoords(:,2), capturedCoords(:,3), .5 ,capturedfat  )
    colormap('jet');
    title( join([ "Regular Grid Fat Fraction Data", newline,...
        "Intersected With Alpha Shape"]) )
    xlabel("X")
    ylabel("Y")
    zlabel("Z")    
end 
    

    capturedfat(capturedfat <= 0) = [];
    capturedfat(capturedfat >= 50) = [];
    [N,edges] = histcounts(capturedfat,20);
    meanFatdata = mean(capturedfat) ;
    SDdata = std(capturedfat);
    %dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
    %
    hold on
    %subplot(2,2,i)
    colors = [ blue; orange; gold; purple];
    
if strcmp(plotIntersectHistogram,"T") 
       
    histogram(capturedfat,10,'Normalization','pdf','BinWidth',1,'FaceColor',colors(patient,:) )
    title("Sampled Fat Distrbution Whole Liver")
    ylabel("Probability Density")
    set(gcf,'color','w');
    set(gca,'FontSize',14)

end 
    
    
    capturedData = [ capturedCoords,  fat(indx.in)];
    
end 
    