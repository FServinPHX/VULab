
clear 
close all

%   Insert Vasculature

%Read in Perfusion Map
%
%hCOEF = 810
wb = 810/(1060.*3639/100); 

%%

close all
clear

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\Patient Stl Meshes'
namesStl = dir('*.stl'); 

%names = [1,2,3, 4]
modelInd = 5 ;
createStartPlot = "T";
createFinalPlot = "F";

tic

if strcmp(createStartPlot,"T")
    figure(2)
    model = createpde(3);
    gm = importGeometry(model ,namesStl(modelInd).name);
    figure(1)
    set(gcf,'color','w');
    pdegplot(model)
    view(290,20)
    title("Imported STL File")
    axis vis3d equal;


    figure(2)
    set(gcf,'color','w');
    stlData = stlread(namesStl(modelInd).name);
    LiverMeshpoints = stlData.Points;
    plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.k' )
    title(join(['Exterior Point Cloud', newline, 'With boundaries (Red)']))
    %axis square;
    hold on
    axis vis3d equal;


    figure(3)
    set(gcf,'color','w');
    ptCloud = pointCloud(LiverMeshpoints);
    roi = [1 300 1 300 1 300];
    indices = findPointsInROI(ptCloud,roi);
    ptCloudB = select(ptCloud,indices);
    pcshow(ptCloud.Location,[0.5 0.5 0.5])
    hold on
    pcshow(ptCloudB.Location,'r');
    title("Lidar Exterior Point Clouds")
    legend('Point Cloud','Points within ROI','Location','southoutside','Color',[1 1 1])
    hold off
    axis vis3d equal;
else 
    model = createpde(3);
    gm = importGeometry(model ,namesStl(modelInd).name);
    stlData = stlread(namesStl(modelInd).name);
    LiverMeshpoints = stlData.Points;
    

end 


%
Boundaries = [min(LiverMeshpoints(:,1)),max(LiverMeshpoints(:,1)),min(LiverMeshpoints(:,2)),max(LiverMeshpoints(:,2))...
    ,min(LiverMeshpoints(:,3)),max(LiverMeshpoints(:,3))  ];
%Find the Exterior most points of the liver mesh 
fIndexs = zeros(6,3);
    for i = 1:6
        [fRow,fCol] = find( LiverMeshpoints(:,:) == Boundaries(i) );
        if mod(i,2) == 0 
            fIndexs(i,:) = LiverMeshpoints(fRow,:) %+ 40;
        else
            fIndexs(i,:) = LiverMeshpoints(fRow,:) %- 30;
        end
    end 

if strcmp(createStartPlot,"T")   
    figure(2)
    scatter3(fIndexs(:,1), fIndexs(:,2), fIndexs(:,3), 50, 'r', 'filled')
end 
    
query.ogLiver = LiverMeshpoints;
query.LivercenterMass =  [ mean(LiverMeshpoints(:,1)), mean(LiverMeshpoints(:,2)), mean(LiverMeshpoints(:,3)) ] ;    
 

%%


patient  = 5;
patient_name = "1";
fatPercent = 1;
%Single Fat values for each patient 
singlFatVal = "F";
createDataCube = "F";
%Should akk data > 50  = 50 and any valu < 0 ==-= 0
dataThreshold = "T";
createVolumePlot = "T";
Plot3DFatDistribution = "T";
calculate_parameters = "T";
AlignImageData = "T";
%%Create a boundary that is patient specific
createBoundary = "T";
%Write the data for the data cubes
writeParameters = "F";
%Wrtie the values for fat (is used with single values)
writeFat = "F";

cd ' C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Vasculature'
dicom = "F" ; 
names = '1017 cropped masked_Vasculature.nii.gz';

      %read all of the dicom names
if patient == 4 || patient == 3
    rotateData = "T";
    flipData = "F";
    angle = 90;
elseif patient == 5
    rotateData = "T";
    flipData = "T";
    angle = 270;    
else 
    rotateData = "F";
    flipData = "F";
    angle = 0;
    
end 


 if strcmp(dicom,"T") %dicom == "T" 
    start = 1;
     names = dir('*.dcm');
%      figure()
    for i = start:size(names, 1)
        tool = dicominfo((names(i).name)) ;
        currentImage = dicomread(names(i).name);
        %current_image = niftiread(names);
        I(:, :, i) = currentImage(:,:,1);
        imshow(I(:,:,i), [])
    end 
% %tool = dicominfo((names(i).name)) ;
%toolCT = dicominfo("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt\1017_Vanderbilt\1017_Vanderbilt 09.06.2022 16.22.27\DICOMS\IMG00001.dcm"); 
    scale = [tool.PixelSpacing(1),tool.PixelSpacing(2),tool.SliceThickness];
% 
 else
    start = 1;
    %%If the patient is either 003 or 004

    tool = niftiinfo(names) ;
    for i = start:size(names, 1)
        %current_image = dicomread(names(i).name);
        currentImage = niftiread(names);
        
        %ROTATE DATA
         if strcmp(rotateData,"T")
            currentImage = imrotate(currentImage, angle);
            disp("images are rotated")
         end 
         
         %FLIP DATA
         if strcmp(flipData,"T")
            currentImage = flip(currentImage, 1);
            disp("images are flipped")
         end  
        I = currentImage./1;
%         figure(1)
%         for j = 1:size(I,3)
%         imshow(I(:,:,j), [])
%         end 
    end 
    
    %%Change the dimension if the patient is either 003 or 004
    switch patient
    case 3
        scale = [tool.PixelDimensions(1),tool.PixelDimensions(2),tool.PixelDimensions(3)];
    case 4 
        scale = [tool.PixelDimensions(1),tool.PixelDimensions(2),tool.PixelDimensions(3)];
    case 5
        scale = [tool.PixelDimensions(1),tool.PixelDimensions(2),tool.PixelDimensions(3)];
    end

 end 
 
% %plot the images
% for i = start:size(names, 1)
%     %current_image = dicomread(names(i).name);
%     current_image = niftiread(names);
%     I(:, :, i) = current_image;
%     figure(1)
%     imshow(I(:,:,i), [])
% end 
% %tool = dicominfo((names(i).name)) ;
% scale = [tool.PixelDimensions(1),tool.PixelDimensions(2),tool.PixelDimensions(3)];
intensityScale = [1,1,10,10];
iNewText = [];
currentImage = [];
if strcmp(dicom,"T") %dicom == 'T'
%%%% if the image is a dicom image
    if patient == 2 
        shift = [12,0,0];
        disp("Shifted Data")
    else 
        shift = [0,0,0];
    end 
    
    for i = start:size(I,3)
        currentImage = dicomread(names(i).name);
        currentImage = currentImage(:,:,1);
        
        iNew = reshape(currentImage, [],1)/intensityScale(2);
        
        x = [0:1:size(currentImage,1)-1]*scale(1) + shift(1);
        x = repelem(x,size(currentImage,2)) ; 
        y = [0:1:size(currentImage,1)-1]*scale(2);
        y = repmat(y,1,size(currentImage,2) );
        z = repelem(scale(3)*(i-1), size(currentImage,1)*size(currentImage,2) ) ;
        iNewText =[iNewText; iNew, x',y',z']; 
    end 
    
%%%% if the image is not a dicom image (most likely a NITFTI image)
else
    %I = imwarp( double(I) , tool.Transform);     
    for i = start:size(I,3)
    currentImage = I(:,:,i);
    
%     figure(1)
    
%     imshow(currentImage, [])
    

    %shift the image in a new dimension
    iNew = reshape(currentImage, [],1);
    %CASE 3:  for some reason, case 3 is shifted in the y-axis by 50 
    if patient == 3 || patient == 4
        x = [0:1:size(I,1)-1]*scale(1) - 12;  % -15
        y = [0:1:size(I,1)-1]*scale(2) - 54;  % -50
         if i ==1
            disp("Shifted Data")
         end 
         
    elseif patient == 5
        x = [0:1:size(I,1)-1]*scale(1) + 135;  % -15
        y = [0:1:size(I,1)-1]*scale(2) + 110;  % -50
        z = [0:1:size(I,1)-1]*scale(3) + 0;  % -50
         if i ==1
            disp("Shifted Data")
         end         
        
    else
         x = [0:1:size(I,1)-1]*scale(1);
         y = [0:1:size(I,1)-1]*scale(2);
    end
    
    x = repelem(x,size(I,2)) ;
    y = repmat(y,1,size(I,2) );
    z = repelem(scale(3)*(i-1), size(I,1)*size(I,2) ) ;
    iNewText =[iNewText; iNew, x',y',z']; 
    end 
    iNewText  = double(iNewText);
    
    %newP = [R * [X,Y,Z]']' ;
%     iNewText  = [iNewText(:,1), ...
%         [tool.Transform.T(1:3 , 1:3) * iNewText(:,2:4)' ]' ];
    
%     iNewText = iNewText + [ 0, double(tool.raw.qoffset_x)*scale(1) ,...
%         double(tool.raw.qoffset_y)*scale(1) , 0 ] ;

    
end 


%%keep the original data 
if strcmp(dataThreshold,"F") %dataThreshold == "F"
    
    disp("No dataThreshold")
end 
if strcmp(dataThreshold,"T") %dataThreshold == "T"
    % change the threshold of the data 
    iNewText(iNewText(:,1) < 0) = 0;
    iNewText(iNewText(:,1) > 50) = 50;
    disp("dataThreshold")
    %
end 

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'


%create a data cube of "Heterogenous Data" of a specified value
if strcmp(createDataCube,"T") %createDataCube == "T"

    iNewText(iNewText(:,1) > 0) = 0;
    dataCube.data = double([iNewText(:,2:end), iNewText(:,1)]);
    %
    
    %[new_data] = insert_data_cube(data,center_x,center_y,center_z,x_length,y_length,z_length,assigned_value);
    [dataCube.newData] = insert_data_cube(dataCube.data,119,167,140,30,60,30,fatPercent);
    %
    boundary = [30,310,40,290,10,220];
    [dataCube.newData] = crop_boundary(dataCube.newData, boundary(1), boundary(2), boundary(3)...
        ,boundary(4), boundary(5), boundary(6));
    %
    iNewText2 = [dataCube.newData(:,4), dataCube.newData(:,1:3)];
    iNewText = iNewText2;
end 


%Rotate the data along the Z-Axis
% if strcmp(rotateData,"T")
%     angle = 90;
%     R = rotz(90);
%     xyzold = double(iNewText(:,2:4));
%     switch angle
%         case 90
%             addm = [0,double(max(max(iNewText(:,3)))),0];
%         case 1800
%             addm = [boundary(2),0,0];
%         case 270 
%             addm = [boundary(2),boundary(4),0];
%     end 
%             
%     xyznew = xyzold*R + addm;;
%     iNewText(:,2:4) = abs( (xyznew) );
% end 

%%Create a boundary to crop the data

if strcmp(createBoundary, "T")
    
    iNewText = double(iNewText);
    PlotiNewText = iNewText;

    PlotiNewText(PlotiNewText(:,1) < 5) = NaN;
    PlotiNewText(PlotiNewText(:,1) > 45) =  NaN;

    query.nonNanIdx =  find(~isnan(PlotiNewText(:,1) ));
    query.NonNanData = [PlotiNewText(query.nonNanIdx,1)  , PlotiNewText(query.nonNanIdx,2) , ...
        PlotiNewText(query.nonNanIdx, 3), PlotiNewText(query.nonNanIdx,4)];


    %Find the center of mass for the imaging data
    query.ImagecenterMass1 =  [ mean(query.NonNanData(:,2)),...
        mean(query.NonNanData(:,3)), mean(query.NonNanData(:,4)) ] ;

    query.DiffCenterMass = query.ImagecenterMass1-query.LivercenterMass ;

%     query.tForm1 = [0, [44.4993 22.1861] - query.DiffCenterMass(1:2) , 0 ];
%     
    query.tForm1 = [0, (0) , (0) , 0 ];
%     query.tForm1 = -[0, query.DiffCenterMass(1:2) , 0 ];
    iNewText = iNewText +  query.tForm1;
%     
    
   
    disp("Boundaries are Created")
    %rearrange the new data
    dataCube.newData = double([iNewText(:,2:end), iNewText(:,1)]);
    if strcmp(singlFatVal, "T")
       boundary = [55,230,105,275,40,195];
       
       
    else
        
       switch patient 
            case 1
                boundary = [55,230,105,275,40,195];
            case 2 
                boundary = [65,305,90,285,25,250];
            case 3
                %boundary = [50*scale(1),240*scale(1),50*scale(2),240*scale(2),10,190];
                boundary = [fIndexs(1,1)-30,fIndexs(2,1)+30, ...
                    fIndexs(3,2)-30, fIndexs(4,2)+30, ...
                    fIndexs(5,3)-30,fIndexs(6,3)+30 ];
            case 4
                boundary = [10,290,52,258,42,188];
%                 boundary = [ min(iNewText(:,2))+10 ,max(iNewText(:,2))-10, ...
%                     min(iNewText(:,3))+10 ,max(iNewText(:,3))+10, 42,188];
                boundary = [fIndexs(1,1)-30,fIndexs(2,1)+50, ...
                    fIndexs(3,2)-30, fIndexs(4,2)+50, ...
                    fIndexs(5,3)-30,fIndexs(6,3)+50 ];
           case 5 
               boundary = [fIndexs(1,1)-30,fIndexs(2,1)+30, ...
                    fIndexs(3,2)-30, fIndexs(4,2)+30, ...
                    fIndexs(5,3)-30,fIndexs(6,3)+30 ];
       end 
        
    end

    %Crop the boundary of the data cube
    [dataCube.newData] = crop_boundary(dataCube.newData, boundary(1), boundary(2), boundary(3)...
    ,boundary(4), boundary(5), boundary(6));
    %
    iNewText = [dataCube.newData(:,4), dataCube.newData(:,1:3)];
    %iNewText = iNewText2;
end 



iNewPerf = double( iNewText(:,1) );


%Plot vasculature Mesh
figure()
hold on

stlData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Liver Mesh.stl");
LiverMeshpoints = stlData.Points;
LiverCenter = mean(LiverMeshpoints,1) ;


LiverData.Points = stlData.Points + [0, 0 , 5];
LiverData.ConnectivityList = stlData.ConnectivityList ; 
LiverDataT =  triangulation(  LiverData.ConnectivityList, LiverData.Points );
trimesh(LiverDataT ,'FaceColor','none','EdgeColor',rgb("Sienna"),'EdgeAlpha', .25 )
    
    
% HepaticVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_hepatic_60pReduced.stl");
% VasculatureMeshData.HepaticVeinPoints = HepaticVeinData.Points; 
% trimesh(HepaticVeinData,'FaceColor','none','EdgeColor','b','EdgeAlpha', .35 )
% 
% hold on
% 
% PortalVeinData = stlread("C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt_Slicer\Segmentation_portal_80pReduced.stl");
% VasculatureMeshData.PortalVeinPoints = PortalVeinData.Points; 
% trimesh(PortalVeinData,'FaceColor','none','EdgeColor',rgb('Crimson'),'EdgeAlpha', .65 )
% 
% VasculatureMeshData.AllPoints = [VasculatureMeshData.HepaticVeinPoints ;...
%     VasculatureMeshData.PortalVeinPoints];


%Plot the vasculature

Plot.dat = iNewPerf;
Plot.dat(Plot.dat <1) = nan;

% transform1 = [0, mean(VasculatureMeshData.AllPoints)]  ;
% transform2 = [0, mean(iNewText(:, 2:end)) ];


transform3 = [0, mean(iNewText(:, 2:end)) ];
% plot3( transform1(2), transform1(3), transform1(4), 'r.', 'MarkerSize', 50)
% plot3( transform2(2), transform2(3), transform2(4), 'b.', 'MarkerSize', 50)
% plot3( transform3(2), transform3(3), transform3(4), 'k.', 'MarkerSize', 50)
iNewText = iNewText + [0, -2, 5, 40];




%%


VasculaturePoints = iNewText;
% Find rows where the first column is zero
rowsToDelete = VasculaturePoints(:, 1) < 1;
% Remove the corresponding rows from the matrix
VasculaturePoints(rowsToDelete, :) = [];
numpoints = 80000;
VasculaturePoints =  VasculaturePoints(:, 2:4); 
[ NewVascPoints ] =  UpsampledAblationSpecRange( VasculaturePoints, numpoints , .75 , 8, 6) ;

NewVascIntensity = ones(length(NewVascPoints), 1)  ; 

iNewText_Vasc = [NewVascIntensity, NewVascPoints; iNewText];



%%
figure()
set(gcf,'color','w');
% Read the data from the text file
data = iNewText_Vasc;
% Extract the columns
intensity = data(:, 1);
x = data(:, 2);
y = data(:, 3);
z = data(:, 4);
% Convert intensity data less than or equal to 0 to 0.152
intensity(intensity <= 0) = 0.032;
% Convert intensity data greater than or equal to 1 to 0.025
intensity(intensity >= 1) = 0.032;
% intensity(intensity >= 1) = 0.025;
% Plot the 3D data
scatter3(x, y, z, .5, intensity, 'filled');
colorbar;
% Set labels and title
title('3D Scatter Plot with Intensity Data Processed');


%[ AllData2 ] = UpsampledAblationSpec( AllData2, numpoints ) ;


hold on
scatter3( NewVascPoints(:,1),  NewVascPoints(:,2),  NewVascPoints(:,3),...
          .1, 'filled' )    
%scatter3( iNewText(:,2),  iNewText(:,3),  iNewText(:,4), .5, Plot.dat)
xlabel("X")
ylabel("Y")
zlabel("Z")
colormap('jet')
colorbar
caxis([0  1 ])
axis equal


% hold on
% plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.k' )
%%
%Create Hyperperfused Data  


cd 'D:\Import To Matlab\Perfusion Data\PerfusionMaps'

wb = 810/(1060.*3639/100); 
perf = [ 0.018, 0.017, 0.0150812, 0.01363, 0.012524];

iNewPerf = [x, y, z,  intensity] ;
    for pz = 3:3
        iNewPerfAdj = iNewPerf;
        
%         iNewPerfAdj(iNewPerfAdj < 1) = perf(pz);
%         iNewPerfAdj(iNewPerfAdj > 1 ) = wb;
        

        INewTextWrite  = iNewPerfAdj; %[iNewText(:,2:end), iNewPerfAdj ];
        %iNewPerfName = join(['Patient_00', patient, '_Blood_Perfusion', string(round(perf(pz), 5)) , 'ADJ.txt' ]);
        iNewPerfName = join(['Patient_00', patient, '_Blood_Perfusion', "Syntehtic" , 'ALL_032.txt' ]);
        fileID = fopen(iNewPerfName,'w');
        %fprintf(fileID,'%6s %12s\n','x','exp(x)');
        fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.6f\n',INewTextWrite');
        fclose(fileID);
    
    end



cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021'
