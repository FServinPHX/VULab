



% Load NIfTI library (adjust to your library's location if necessary)

% Read the NIfTI file
path = "D:\Import To Matlab\2.0 Regular Grid to Imaging Data\ 22-All Predictions_model Pytorch Distances_10 EPOCH__Part2\RUN_num_ 0 15 Min 15 s .nii"
path = convertStringsToChars(path);
nii = load_nii(path);

% Extract the image data
img = nii.img;

% Get the number of slices
num_slices = size(img, 3);

% Create a figure
figure;

% Iterate over every slice and display it
for i = 1:num_slices
    subplot(ceil(sqrt(num_slices)), ceil(sqrt(num_slices)), i);
    imshow(img(:, :, i), []);
    title(['Slice ', num2str(i)]);
end


% Adjust figure properties as needed
sgtitle('NIfTI Image Slices');
set(gcf, 'Position', [100, 100, 1200, 800]);



%%





intensityspc = 2;
%Create the Box Phantom Model
pVoxVoxSize = [100, 100, 100 ] ;
center = [0,0,0]- (pVoxVoxSize/2) ;
%Choose where to start and end 
strt = [0, 0, 0];
endd = [0,0,0];
pVoxVolxelx = [ center(1) +  pVoxVoxSize(1)*strt(1) :pVoxVoxSize(1): pVoxVoxSize(1)*endd(1)  +  center(1)  ] ;
pVoxVolxely = [ center(2) +  pVoxVoxSize(2)*strt(2) :pVoxVoxSize(2): pVoxVoxSize(2)*endd(2)  +  center(2)  ] ;
pVoxVolxelz = [ center(3) +  pVoxVoxSize(3)*strt(3) :pVoxVoxSize(3): pVoxVoxSize(3)*endd(3)  +  center(3)  ] ;


%
QuerryPointsOG = dataPoints; 
intensityI  = binaryIntensities;

[intensity_X, intensity_Y, intensity_Z, intensity_I] = transformQuerryPointsToMeshgrid(QuerryPointsOG, intensityI, ...
    pVoxVolxelx, pVoxVolxely, pVoxVolxelz, intensityspc);




% Call the function to count the number of 1's
count = countOnesInMatrix(binaryIntensities);

% Display the result
disp(['Number of 1s in the Original matrix: ', num2str(count)]);



% Call the function to count the number of 1's
count = countOnesInMatrix(intensity_I);

% Display the result
disp(['Number of 1s in the matrix: ', num2str(count)]);




