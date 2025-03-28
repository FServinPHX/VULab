
clear 

%%
%Checkeboard Image Detection 
a = 2;
pixelsize = floor(110/(a*2))  ;
K = (checkerboard(pixelsize , a, a) > 0.5);
figure
imshow(K)
saveas(gcf ,'MATLAB Figures\Checkerboard.png')
%%


imageFileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Ablation Phantom Study\Beef Ablation Study\Beef Ablation with Segmetation.png";
I = imread(imageFileName);

[imagePoints,boardSize] = detectCheckerboardPoints(I);

J = insertText(I,imagePoints,1:size(imagePoints,1));
J = insertMarker(J,imagePoints,'o','Color','red','Size',5);
imshow(J);
title(sprintf('Detected a %d x %d Checkerboard',boardSize));

hold on
Distance = [];
%Checkerboard Dimension in Milimeters; 
CheckerboardDim = 2;
for i = 1:length(imagePoints)-1
% 
%     plot( imagePoints(i,1), imagePoints(i,2), 'r.', 'MarkerSize', 20)
%     
%     pause(.2)
    Distance = [Distance,  sqrt( (imagePoints(i,1) - imagePoints(i+1,1))^2 ...
                + (imagePoints(i,2) - imagePoints(i+1,2))^2) ] ;

end 
Distance(Distance > Distance(1)*1.2) = [];
PixelToDim = CheckerboardDim/ mean(Distance); 
hold off;