A = [ 1, 1, 1, 1 ; 1, 1, 1, 1;
     1, 1, 1, 1; 1, 1, 1, 1]; 
 
 stats = graycoprops(A,{'contrast','homogeneity'});
 
 
 
 glcm = [0 1 2 3;1 1 2 3;1 0 2 0;0 0 0 3]
 stats = graycoprops(glcm)
 %%
 
 I = imread('circuit.tif');
 imshow(I)
 
 glcm = graycomatrix(I,'Offset',[2 0;0 2]);
 stats = graycoprops(glcm,{'contrast','homogeneity'});
 
 
 
 %%
clear 


x = 1:10; 
y = 1:10;
[X, Y] = meshgrid(x,y);
f = X + Y;
f(:,:) = 0;
imagesc(f);

[glcm,SI] = graycomatrix(f,'NumLevels',10,'GrayLimits',[min(f(:)), max(f(:))]);
stats = graycoprops(glcm)
