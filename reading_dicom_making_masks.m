
cd 'C:\Users\srvinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\Imaging Data-selected\ScalarVolume_162_patient_001'
file = 'IMG00001.dcm';
%dicom  = dicomread('C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\001\001 06.07.2021 20.13.28\DICOMS\IMG00001.dcm');
info = dicominfo('IMG00001.dcm');
Y = dicomread(info);
figure
imshow(Y,[])
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
    


if strcmp(createStartPlot,"T")
    %create query points 
    figure()
    %create a boundary of the original liver
    query.ogLiver = LiverMeshpoints;
    query.ksrtOG = boundary(query.ogLiver, .8);
    query.ksrt = reshape(query.ksrtOG,[],1);
    query.kSort1 = unique(query.ksrt);
    query.kSortPoint1 = query.ogLiver(query.kSort1,:); 
    
    %create a Delauny Traingulation of the original liver
    query.ksrtDLNY = delaunay(query.ogLiver(:,1),  query.ogLiver(:,2), ...
        query.ogLiver(:,3));
    
    
    query.shp = alphaShape(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), 70,'HoleThreshold',10);
%     query.shp = alphaShape(query.kSortPoint1(:,1), query.kSortPoint1(:,2), ... 
%                 query.kSortPoint1(:,3), 10,'HoleThreshold',10);
    plot(query.shp) 
    hold on 
    plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.b' )
    hold on 
%     figure()
%   Boundary Methof
%     trisurf(query.ksrtOG ,query.ogLiver(:,1),  query.ogLiver(:,2), ...
%         query.ogLiver(:,3) ,'Facecolor','red','FaceAlpha',0.1)
%  Delauny traingulation
%     triplot(query.ksrtDLNY, query.ogLiver(:,1),  query.ogLiver(:,2), ...
%         query.ogLiver(:,3))
    
    set(gca,'FontSize',12)
    set(gcf,'color','w');
    title(join(['Original Alpha Shape of the Liver',...
        newline, 'points = ', num2str(length(LiverMeshpoints(:,1)))   ]))
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
else 
    query.shp = alphaShape(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), 10, 'HoleThreshold',10);
end 

query.LivercenterMass =  [ mean(LiverMeshpoints(:,1)), mean(LiverMeshpoints(:,2)), mean(LiverMeshpoints(:,3)) ] ;    
%     sample.currentc = [];
%     for ix = 1:length(sample.x)
%         xc = sample.x(ix);
%         for iy = 1:length(sample.y)
%             yc = sample.y(iy);
%             for iz = 1:length(sample.z)
%                 zc = sample.z(iz);
%                 sample.currentc = [sample.currentc; xc, yc, zc];
%             end 
%         end 
%     end 

%     plot3( sample.currentc(:,1), sample.currentc(:,2), sample.currentc(:,3), '.')
%     title("Data Sampling Cube")
%     set(gcf,'color','w');
%     xlabel('X')
%     ylabel('Y')
%     zlabel('Z')
%     toc

if strcmp(createFinalPlot,"T") 
    
    
    sample.x = [(  min(fIndexs(:,1))*-1.2):2:( max(fIndexs(:,1))*1.2) ] ;
    sample.y = [(  min(fIndexs(:,2))*-1.2):2:( max(fIndexs(:,2))*1.2) ] ;
    sample.z = [(  min(fIndexs(:,2))*-1.2):2:( max(fIndexs(:,3))*1.2) ] ;
    [X,Y,Z] = meshgrid(sample.x,sample.y,sample.z);
    X = reshape(X, [],1);
    Y = reshape(Y, [],1);
    Z = reshape(Z, [],1);
    sample.currentc = [];
    sample.currentc = [X,Y,Z];
    

    %plot(shp2)
    %create query points 
    query.qx3 =  sample.currentc(:,1);
    query.qy3 =  sample.currentc(:,2);
    query.qz3 =  sample.currentc(:,3);
    %find the intersection 
    indx.in3 = inShape(query.shp, query.qx3, query.qy3, query.qz3 );
    query.reasampleLiver = [LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3);...
    query.qx3(indx.in3),query.qy3(indx.in3),query.qz3(indx.in3)];

    %plot3(query.qx3(indx.in3), query.qy3(indx.in3), query.qz3(indx.in3), '.');
    k = boundary(query.reasampleLiver , 1  );
    query.k = reshape(k,[],1);
    query.kSort = unique(query.k);
    query.kSortPoint = query.reasampleLiver(query.kSort,:); 
    figure()
    plot3(query.kSortPoint(:,1), query.kSortPoint(:,2), query.kSortPoint(:,3), '.');
    title( join(['New Points of the Liver' newline,...
        'points = ', num2str(length( query.kSortPoint(:,1) ))   ]))
    set(gca,'FontSize',12)
    set(gcf,'color','w');
    axis vis3d equal;
    xlabel('X')
    ylabel('Y')
    zlabel('Z')   
    %
    %create query points 
    figure()
    query.shp2 = alphaShape(query.kSortPoint(:,1), query.kSortPoint(:,2), query.kSortPoint(:,3), 40);
    plot(query.shp2) 
    title('Alpha Shape of the Resampled Liver' )
    set(gca,'FontSize',12)
    set(gcf,'color','w');
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end 
    
    toc

%%
close all
tic 



gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
colors = [blue;orange; gold; purple; purple]  ;


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
%%%NOTES
    %%PATIENT 2
    % %     if patient ==2 
    % %         shift = [12,0,0];
    % %     else 
    % %         shift = [0,0,0];
    % %     end 
    %%PATIENT 3
    %%%ANGLE = 90. currentImage = flip(currentImage, 1);
    %%PATENT 4
    %%%ANGLE = 0. NO flip; 90. currentImage = flip(currentImage, 1);


%%%Directories
%ScalarVolume_162_patient_001
%ScalarVolume_184_patient_002
%
%dicom = "T" ; 
patient  = 5;
patient_name = "1";
fatPercent = 1;
switch patient
    case 1 
     cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\Imaging Data-selected\ScalarVolume_162_patient_001'
     dicom = "T" ; 
    case 2 
     cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\Imaging Data-selected\ScalarVolume_184_patient_002'   
     dicom = "T" ; 
    case 3
     cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\Imaging Data-selected\'
     dicom = "F" ; 
    case 4 
     cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\Imaging Data-selected\'
     dicom = "F" ; 
    case 5
     cd ' C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt'
     dicom = "F" ; 
end 

     %read all of the dicom names

if patient == 4 || patient == 3
    rotateData = "T";
    flipData = "F";
    angle = 90;
elseif patient == 5
    rotateData = "T";
    flipData = "T";
    angle = 90;    
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
%toolCT = dicominfo("C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Memorial Sloan Kettering Liver Study\1017_Vanderbilt\1017_Vanderbilt\1017_Vanderbilt\1017_Vanderbilt 09.06.2022 16.22.27\DICOMS\IMG00001.dcm"); 
    scale = [tool.PixelSpacing(1),tool.PixelSpacing(2),tool.SliceThickness];
% 
 else
    start = 1;
    %%If the patient is either 003 or 004
    switch patient
        case 3
            names = 'Patient_003.nii.gz'
            division = 10; 
        case 4
            names = 'Patient_004_v2.nii.gz'
            division =  10; 
        case 5
             names = '1017_FF.nii.gz';
%             names = '1017.nii.gz';
            division = 1; 
    end 
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
         
        I = currentImage./division;
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
        x = [0:1:size(I,1)-1]*scale(1) - 0;  % -15
        y = [0:1:size(I,1)-1]*scale(2) - 0;  % -50
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
               boundary = [fIndexs(1,1)-30,fIndexs(2,1)+50, ...
                    fIndexs(3,2)-30, fIndexs(4,2)+50, ...
                    fIndexs(5,3)-30,fIndexs(6,3)+50 ];
               
               
       end 
        
    end


    %Crop the boundary of the data cube
    [dataCube.newData] = crop_boundary(dataCube.newData, boundary(1), boundary(2), boundary(3)...
    ,boundary(4), boundary(5), boundary(6));
    %
    iNewText = [dataCube.newData(:,4), dataCube.newData(:,1:3)];
    %iNewText = iNewText2;
end 





if strcmp(createVolumePlot,"T") %createVolumePlot == "T"
    for cVi = 1:2
%         iNewText = double(iNewText);
%         PlotiNewText = iNewText;

        PlotiNewText(PlotiNewText(:,1) < 5) = NaN;
        PlotiNewText(PlotiNewText(:,1) > 45) =  NaN;

        query.nonNanIdx =  find(~isnan(PlotiNewText(:,1) ));
        query.NonNanData = [PlotiNewText(query.nonNanIdx,1)  , PlotiNewText(query.nonNanIdx,2) , ...
            PlotiNewText(query.nonNanIdx, 3), PlotiNewText(query.nonNanIdx,4)];

        
%         Find the center of mass for the imaging data
        query.ImagecenterMass1 =  [ mean(query.NonNanData(:,2)),...
            mean(query.NonNanData(:,3)), mean(query.NonNanData(:,4)) ] ;

        query.DiffCenterMass = query.ImagecenterMass1-query.LivercenterMass ;
%         query.tForm1 = [0, [44.4993 22.1861] - query.DiffCenterMass(1:2) , 0 ];
%     
%         query.tForm1 = [0, -15, -50, 0 ];
%         
        if cVi ==2
            %Plot 3D Scatter of Raw Image Data
            figure()
            set(gcf,'color','w');
            %scatter3(PlotiNewText(:,2), PlotiNewText(:,3), PlotiNewText(:,4), .5 ,PlotiNewText(:,1)  )
            scatter3(query.NonNanData(:,2), query.NonNanData(:,3), query.NonNanData(:,4), .5 ,query.NonNanData(:,1)  )
            colormap('jet'); 

            hold on 
            plot(query.shp) 
            plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.b' )
            hold off    
           
            title("Regular Grid Fat Fraction Data")
            xlabel("X")
            ylabel("Y")
            zlabel("Z")


            %Plot Alpha Shape, Center of Liver Mesh, and Center of Imaging
            %Data
            figure()
            plot3(query.ImagecenterMass1(1), query.ImagecenterMass1(2), query.ImagecenterMass1(3), '.k', 'MarkerSize',100)
            hold on 
            plot3(query.LivercenterMass (1), query.LivercenterMass (2), query.LivercenterMass (3), '.r', 'MarkerSize',100)  
            plot(query.shp,'FaceColor', colors(patient,:) , 'FaceAlpha',.25, 'EdgeColor','none') 
        %     plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.b' )
            title( join(["Image Data Center Mass (Black)", newline, "Vs Liver Center Mass", newline, num2str( query.tForm1(2:4) ) ]))

            set(gcf,'color','w');
            
            
            
            [ aligndata.capturedDataOG, aligndata.capturedfat  ] = ...
            liverWfatIntersectHistogram(iNewText, query.shp, patient, "T", "F"); 
            PlotiNewText = aligndata.capturedDataOG;
            scatter3(PlotiNewText(:,1), PlotiNewText(:,2), PlotiNewText(:,3), .5 ,PlotiNewText(:,4)  )
            colormap('jet');
            colorbar
%             caxis([0 70]);

            hold on 
            plot(query.shp,'Edgecolor', 'none', 'FaceColor','blue', 'FaceAlpha',0.1 ) 
    %         plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.b' )
    %         hold off    
            title( join(["Liver",  num2str(patient) , "OG Alignment"  ]) )
            xlabel("X")
            ylabel("Y")
            zlabel("Z")
%             set(gcf,'position',[80,80,800,600])
            view( -20, 10 );
            axis vis3d equal;
            axis off
            grid off
            
            
        end 

        %colorbar
        % %%
        % cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\001\001 06.07.2021 20.13.28\Export\001'
        % segment = load("VolumetricMesh\001_VolMesh.bel");
%           if cVi == 1 
%               query.tForm1 = [0, [44.4993 22.1861] - query.DiffCenterMass(1:2) , 0 ];
%               iNewText = iNewText +  query.tForm1;
%           end 
    end 
end 
hold off



%%

    %Create a new function that checks if the data
    if strcmp(AlignImageData, "T")

        aligndata.GTfileName = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\FatDistribution.csv";
        aligndata.GTfat = readtable(aligndata.GTfileName);
        aligndata.GTfat  =  table2array(aligndata.GTfat);

        aligndata.TotalTransform = [0 ,0 ,0 ,0] + query.tForm1;
        %Set up the search parameters
        aligndata.xsample = -70:35:70;
        aligndata.ysample = -70:35:70;

    %     aligndata.xsample = -5:scale(1):5;
    %     aligndata.ysample = -5:scale(2):5;

    ligndata.bestTfrm = [0 ,0 ,0 ,0] + query.tForm1;
    aligndata.xsample = aligndata.bestTfrm(2)-scale(1)*3:scale(1):aligndata.bestTfrm(2)+scale(1)*3;
    aligndata.ysample = aligndata.bestTfrm(3)-scale(1)*3:scale(1):aligndata.bestTfrm(3)+scale(1)*3;   

    figure()   
    for i = 2:3
        tic  
        %basically a grid searching method to determine the best histogram
        %data. 


        aligndata.length = length(aligndata.xsample).*length(aligndata.ysample);

        %set up the variables
        aligndata.addHistdata = zeros( length(iNewText(:,1)),   aligndata.length );
        aligndata.index = 1;
        aligndata.mean=  [];
        aligndata.StDev =  [];
        aligndata.transform = [];
        aligndata.pdfX =  0:1:50;
        aligndata.pdfAll = []; 


        for xi = 1:length(aligndata.xsample)
            for yi = 1:length(aligndata.ysample)
                %establish Inewtext as empty to start a new analysis do not
                %change the value for inew text
                aligndata.iNewText = [];


                aligndata.tmatrix = [ 0, aligndata.xsample(xi), ...
                    aligndata.ysample(yi), 0];

                if xi == 1 && yi == 1 
                    aligndata.tmatrix = [0,0,0,0];
                end             


                aligndata.iNewText = iNewText + aligndata.tmatrix;

                 [ aligndata.capturedDataOG, aligndata.capturedfat  ] = ...
                     liverWfatIntersectHistogram(aligndata.iNewText, query.shp, patient, "F", "F"); 

                 aligndata.addHistdata(1:length(aligndata.capturedfat),aligndata.index  ) = aligndata.capturedfat; 
                 aligndata.mean = [aligndata.mean , mean(aligndata.capturedfat)] ; 
                 aligndata.StDev = [aligndata.StDev  , std( aligndata.capturedfat)];

                 %Fit a probability distribution function to the data 
                 aligndata.pd = fitdist(aligndata.capturedfat,'tLocationScale');
                 aligndata.pdfY = pdf(aligndata.pd, aligndata.pdfX);
                 aligndata.pdfAll =  [aligndata.pdfAll , aligndata.pdfY'];


                 %Track the specific displacement vector at every iteration 
                 aligndata.transform =  [aligndata.transform ; aligndata.tmatrix];
                 aligndata.index = aligndata.index + 1;

            end 
        end 

        %determine the best run using the known mean and standard deviation
        aligndata.minimize = [];
        aligndata.minimizeDist = [];
        for Indx = 1:aligndata.index-1
            Mean = [11.0020713485421	17.6231881646170	20.2094572027572	27.4251212301907];
            StDev = [17.9249918881389	14.0273490911915	10.7264589235913	9.69548477248007];

            aligndata.minimize = [aligndata.minimize,...
                abs( (aligndata.mean(Indx) - Mean(patient)) + ...
                abs(aligndata.StDev(Indx) - StDev(patient))*5.0 ) ] ;


          %minimize the error of the  
          aligndata.minimizeDist = [aligndata.minimizeDist, ...
            sum( abs( aligndata.GTfat(:,patient) - aligndata.pdfAll(:,Indx) ) )...
            + abs( abs(aligndata.mean(Indx) - Mean(patient)) + ...
                abs(aligndata.StDev(Indx) - StDev(patient) )*3.0 ) ];      

        end 

        [aligndata.bestFit,aligndata.bestFitInd]  = min( aligndata.minimizeDist );

        if i <= i(end) 
          [aligndata.bestFit,aligndata.bestFitInd]  = max( aligndata.minimizeDist );
        end
        %Find the best transformation matrix
        aligndata.bestTfrm = aligndata.transform(aligndata.bestFitInd ,:);
        %Keep Track of the total transformation
        %ligndata.TotalTransform = aligndata.TotalTransform + aligndata.bestTfrm;

        %Plot the bestfit Histogram
        %capturedfat = aligndata.addHistdata(:, 1);
        capturedfat = aligndata.addHistdata(:,aligndata.bestFitInd);
        capturedfat(capturedfat <= 0) = [];
        capturedfat(capturedfat >= 50) = [];
        [N,edges] = histcounts(capturedfat,20);
        meanFatdata = mean(capturedfat) ;
        SDdata = std(capturedfat);
        %dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
        %
        %subplot(2,2,i)
        colors = [ blue; orange; gold; purple];


        histogram(capturedfat,10,'Normalization','pdf','BinWidth',1,'FaceColor',colors(patient,:) )
        if i < i(end) 
            title( join(["Finding Fit for Patient ", num2str(patient), newline, "Sampled Fat Distrbution Whole Liver"]) )
            legend(join(["translate ", num2str(aligndata.bestTfrm )]) )
            hold on 
        else
            hold off

            figure()
            histogram(capturedfat,10,'Normalization','pdf','BinWidth',1,'FaceColor',colors(patient,:) )
            title( join(["Best Fit for Patient ", num2str(patient), newline, "Sampled Fat Distrbution Whole Liver"]) )
            aligndata.bestTfrm = aligndata.bestTfrm ;
            legend(join(["translate ", num2str(aligndata.bestTfrm+ query.tForm1 )]) )
            hold on

        end 
        ylabel("Probability Density")
        set(gcf,'color','w');
        set(gca,'FontSize',14)

        %Plot the Current Fat Distribution of the Querry Data
        pDfplot = plot( aligndata.pdfX , aligndata.pdfAll(:,aligndata.bestFitInd)  ,'MarkerEdgeColor', colors(patient,:));
        pDfplot.Annotation.LegendInformation.IconDisplayStyle = 'off'; % make the legend for step plot off
        %Plot the Ground Truth Fat Distribution 
        pDFplot2 = plot( aligndata.pdfX , aligndata.GTfat(:,patient)  ,'MarkerEdgeColor', colors(patient,:));
        pDfplot2.Annotation.LegendInformation.IconDisplayStyle = 'off'; % make the legend for step plot off


    %     figure()
    %     aligndata.pdfX= 0:1:40;
    %     aligndata.pdfY = pdf(aligndata.pd, aligndata.pdfX);
    %     plot(aligndata.pdfX, aligndata.pdfY )

        %Find the best transformation matrix to align the data



        if i == 1
            aligndata.xsample = aligndata.bestTfrm(2)-30:10:aligndata.bestTfrm(2)+30;
            aligndata.ysample = aligndata.bestTfrm(3)-30:10:aligndata.bestTfrm(3)+30; 
        elseif i == 1
            aligndata.xsample = aligndata.bestTfrm(2)-scale(1)*3:scale(1):aligndata.bestTfrm(2)+scale(1)*3;
            aligndata.ysample = aligndata.bestTfrm(3)-scale(1)*3:scale(1):aligndata.bestTfrm(3)+scale(1)*3;   

        elseif i == 2
            aligndata.xsample = aligndata.bestTfrm(2)-4:1:aligndata.bestTfrm(2)+4;
            aligndata.ysample = aligndata.bestTfrm(3)-4:1:aligndata.bestTfrm(3)+4;
        end 



    toc

    end 

        [ aligndata.capturedDataOG, aligndata.capturedfat  ] = ...
         liverWfatIntersectHistogram(aligndata.iNewText, query.shp, patient, "T", "F"); 


        %%%Finally align the Image Data
        %%%
        %%%

        %ENBALBLE OUTSIDE OF TESTING

    %     iNewText = iNewText + aligndata.bestTfrm;
    %     
    %     query.ImagecenterMass2 =  [ mean(iNewText(:,2)), mean(iNewText(:,3)), mean(iNewText(:,4)) ] ;    




    % iNewText = PlotiNewText;

    if strcmp(Plot3DFatDistribution,"T") %createVolumePlot == "T"


        fatP = [0,6, 17, 22, 50];
        legendBase = [ "Low Fat", "Mild Fat","Moderate Fat", "High Fat"];

        for i = 1:4
            iNewText = double(iNewText);


            PlotiNewText = aligndata.capturedDataOG;

            PlotiNewText(PlotiNewText(:,4) < fatP(i) ) = NaN;
            PlotiNewText(PlotiNewText(:,4) > fatP(i+1) ) =  NaN;

            figure()
            set(gcf,'color','w');
            scatter3(PlotiNewText(:,1), PlotiNewText(:,2), PlotiNewText(:,3), .5 ,PlotiNewText(:,4)  )
            colormap('jet'); 
            colorbar

            hold on 
            plot(query.shp,'Edgecolor', 'none', 'FaceColor','blue', 'FaceAlpha',0.1 ) 
    %         plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.b' )
    %         hold off    

            title( join(["Liver",  num2str(patient) ,newline ,...
                num2str(fatP(i)), "-",num2str(fatP(i+1)),"% Liver Fat ",newline,  legendBase(i)  ]) )
            xlabel("X")
            ylabel("Y")
            zlabel("Z")

            set(gcf,'position',[80,80,800,600])
            view( -20, 10 );
            axis vis3d equal;
        end 



        %colorbar
        % %%
        % cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\001\001 06.07.2021 20.13.28\Export\001'
        % segment = load("VolumetricMesh\001_VolMesh.bel");
    end 


    end
%%


if strcmp(createVolumePlot,"T") %createVolumePlot == "T"
    iNewText = double(iNewText);
    
    
    PlotiNewText = iNewText;
    
    PlotiNewText(PlotiNewText(:,1) < 5) = NaN;
    PlotiNewText(PlotiNewText(:,1) > 45) =  NaN;
    
    query.nonNanIdx =  find(~isnan(PlotiNewText(:,1) ));
    query.NonNanData = [PlotiNewText(query.nonNanIdx,1)  , PlotiNewText(query.nonNanIdx,2) , ...
        PlotiNewText(query.nonNanIdx, 3), PlotiNewText(query.nonNanIdx,4)];
    
    figure()
    set(gcf,'color','w');
    %scatter3(PlotiNewText(:,2), PlotiNewText(:,3), PlotiNewText(:,4), .5 ,PlotiNewText(:,1)  )
    scatter3(query.NonNanData(:,2), query.NonNanData(:,3), query.NonNanData(:,4), .5 ,query.NonNanData(:,1)  )
    colormap('jet'); 
    
    hold on 
    plot(query.shp) 
    plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.b' )
    hold off    
    
    title("Regular Grid Fat Fraction Data")
    xlabel("X")
    ylabel("Y")
    zlabel("Z")
    
    %Find the center of mass for the imaging data
    
    query.ImagecenterMass2 =  [ mean(query.NonNanData(:,2)),...
        mean(query.NonNanData(:,3)), mean(query.NonNanData(:,4)) ] ;
    
    query.DiffCenterMass2 = query.ImagecenterMass1-query.LivercenterMass ;
    
    
    figure()
    plot3(query.ImagecenterMass2(1), query.ImagecenterMass2(2), query.ImagecenterMass2(3), '.k', 'MarkerSize',100)
    hold on 
    plot3(query.LivercenterMass (1), query.LivercenterMass (2), query.LivercenterMass (3), '.r', 'MarkerSize',100)  
    plot(query.shp,'FaceColor', colors(patient,:) , 'FaceAlpha',.25, 'EdgeColor','none') 

%     plot3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3), '.b' )
    title( join(["Image Data Center Mass (Black)", newline, "Vs Liver Center Mass"]))
    
    set(gcf,'color','w');
    %colorbar
    % %%
    % cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\001\001 06.07.2021 20.13.28\Export\001'
    % segment = load("VolumetricMesh\001_VolMesh.bel");
end 

%%


% if strcmp(createVolumePlot,"T") %createVolumePlot == "T"
%     figure(2)
%     set(gcf,'color','w');
%     scatter3(iNewText(:,2), iNewText(:,3), iNewText(:,4), .5 ,iNewText(:,1)  )
%     colormap('jet');
%     title("Regular Grid Fat Fraction Data")
%     xlabel("X")
%     ylabel("Y")
%     zlabel("Z")
%     %colorbar
%     % %%
%     % cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\001\001 06.07.2021 20.13.28\Export\001'
%     % segment = load("VolumetricMesh\001_VolMesh.bel");
% end 
%
%%calculate the parameters at every voxel :)


if strcmp(calculate_parameters,"T") %calculate_parameters == "T"
    intensityScale = [1,1,10,10];
    iVal = double( iNewText(:,1) );
    %%I_new__Cp = (1-(I_val/100))*3400+(I_val/100)*2348;
    %I_new__k_iso = (1-(I_val/100))*.52 +(I_val/100)*.21;
    iNewKIso = ( (.52-.21)*exp(-0.0547*iVal) + .21 ) ;
    %iNewKIso = ( (.47-.21)*exp(-0.0547*iVal) + .21 ) ;
    
    %           915 MHZ 
    iNewEr = ( (46.8-11.3)*exp(-0.01144*iVal) + 11.3 ) ;
    %           2450 MHZ/ 2.45 GHz
    %iNewEr = ( (43 - 10.8 )*exp(-0.01144*iVal) + 10.8 ) ;
        
    %           915 MHZ 
    iNewEc =  ( (.861-.11)*exp(-0.0116*iVal) + .11 ) ;
    %     2450 MHZ/ 2.45 GHz
    %     iNewEc =  ( ( 1.69 - .268 )*exp(-0.0116*iVal) + .268 ) ;    
    %COMPEMSATE For the fact that blood perfusion overestimates for fat
    %concentration above 20;
    iValperf = iVal;
    iValperf(iValperf < 7) = 0; 
    %iNewPerf = ( (.025-.011)*exp(-0.040609*iVal) + .011 ) ;
    iNewPerf = ( (.018-.011)*exp(-0.040609*(iValperf)) + .011 ) ;  
    minPerf = min(iNewPerf); 
    iNewPerf(iNewPerf == minPerf) = .04;
    
    disp(' Created K_iso, E_r, E_c')
end



if strcmp(singlFatVal,"T")
    disp("  ")
    disp( join(["Fat_Percent ", num2str(fatPercent) ]) )
    disp( join(["K_iso", num2str( ( (.52-.21)*exp(-0.0546*fatPercent) + .21 )  )]) )
    disp( join(["Electrical Conductivity", num2str( ( (.861-.11)*exp(-0.0116*fatPercent) + .11 )  )]) )
    disp( join(["Permittivity", num2str( ( (46.8-11.3)*exp(-0.01144*fatPercent) + 11.3 )       ) ]) )   
    disp( join(["Perfusion", num2str( ( (.018-.011)*exp(-0.040609*(fatPercent)) + .011 )   ) ]) )
end 

if strcmp(writeFat,"T") %writeFat == "T"
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'
    %I_new_text_write = ["I","x","y","z"; I_new_text];
    %csvwrite("Patient_001_intensity_encoded_file.csv",I_new_text); 
    iNewTextWrite  =[iNewText(:,2:end), iNewText(:,1)];
    fileID = fopen('Patient_005_intensity_encoded_file_2450MHz.txt','w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.2f\n',INewTextWrite');
    fclose(fileID);
    
    
end 

%%Write Interpolated Data clouds for liver models (in this case Patient
%%001)
if strcmp(writeParameters,"T") %writeParameters == "T"
    %convert the patient choice to a string
    
    if strcmp(singlFatVal,"T")
        patient = patient_name;
    else 
        patient = num2str(patient);
    end 
    
    
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\Fat_cloud_txt\Patient_1\Patient_017'
    
    INewTextWrite  =[iNewText(:,2:end), iNewKIso];
    thermCondName = join(['Patient_00', patient, '_thermal_conductivity.txt']);
    fileID = fopen(thermCondName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    %
    INewTextWrite  =[iNewText(:,2:end), iNewEr];
    permittivityName = join(['Patient_00', patient, '_Permittivity.txt']);
    fileID = fopen(permittivityName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    %
    INewTextWrite  =[iNewText(:,2:end), iNewEc];
    electCondName = join(['Patient_00', patient , '_Electrical Conductivity.txt']) ;
    fileID = fopen(electCondName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %5.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    
    
    perf = [ 0.018, 0.017, 0.0150812, 0.01363, 0.012524];
    for pz = 1:5
        
        B = ones(size(iNewPerf)) ;
        
        B = B.*perf(pz);
        
        INewTextWrite  =[iNewText(:,2:end), B ];
        iNewPerfName = join(['Patient_00', patient, '_Blood_Perfusion', string(round(perf(pz), 5)) , '.txt' ]);
        fileID = fopen(iNewPerfName,'w');
        %fprintf(fileID,'%6s %12s\n','x','exp(x)');
        fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.6f\n',INewTextWrite');
        fclose(fileID);
    
    end
    
    %Create Hyperperfused Data  
    iNewPerfAdj = iNewPerf;
    iNewPerfAdj(iNewPerfAdj > .0168) = .18;
    
    B = iNewPerfAdj ;
    INewTextWrite  =[iNewText(:,2:end), B ];
    iNewPerfName = join(['Patient_00', '_Blood_Perfusion_ADJ_Vasc' , '.txt' ]);
    fileID = fopen(iNewPerfName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.6f\n',INewTextWrite');
    fclose(fileID);
    
    
    %Create Fat Data  
    INewTextWrite  =[iNewText(:,2:end), iVal];
    fatIntensity = join(['Patient_00', patient, '_fat_intensity.txt']);
    fileID = fopen(fatIntensity,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
end 

toc
%%

cd 'D:\Import To Matlab\Material Properties'
    
PatientName = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"]; 


    
    
    Permittivity = [43.0, 41.328, 38.655, 36.149, 33.672 ];
    Cond = [1.69, 1.6152, 1.4956, 1.3837, 1.2732 ]; 
    K0 = [ 0.521, 0.451, 0.3653, 0.309, 0.270 ];
    
    for pz = 1:5
        
        B = ones(size(iNewEr)) ;
        

    iNewEc = B.*Cond(pz);
    iNewEr = B.*Permittivity(pz);
    iNewKIso = B.*K0(pz);
    
    %Permittivity
    
    INewTextWrite  =[iNewText(:,2:end), iNewEr];
    permittivityName = join(['Patient_00', patient, PatientName(pz), ...
        '_Permittivity', string(round(Permittivity(pz), 5)) , '.txt']);
    
    fileID = fopen(permittivityName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    
    
    %Electrical Conductivity
    
    INewTextWrite  =[iNewText(:,2:end), iNewEc];
    electCondName = join(['Patient_00', patient ,PatientName(pz), ...
        '_Electrical Conductivity',string(round(Cond(pz), 5)),  '.txt']) ;
    
    fileID = fopen(electCondName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %5.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    
    %Thermal Conductivity
    
    INewTextWrite  =[iNewText(:,2:end), iNewKIso];
    thermCondName = join(['Patient_00', patient , PatientName(pz),...
        '_thermal_conductivity', string(round(K0(pz), 5))  ,'.txt']);
    fileID = fopen(thermCondName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    
    
    end 



%%
close
clear
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\Patient Stl Meshes'
namesStl = dir('*.stl'); 
modelInd = 1;


figure(2)
model = createpde(3);
gm = importGeometry(model ,namesStl(modelInd).name);

figure(1)
set(gcf,'color','w');
pdegplot(model)
view(290,20)
title("Imported STL File")

figure(2)
set(gcf,'color','w');
stlData = stlread(namesStl(modelInd).name);
LiverMeshpoints = stlData.Points;
scatter3(LiverMeshpoints(:,1), LiverMeshpoints(:,2), LiverMeshpoints(:,3))
title(join(['Exterior Point Cloud', newline, 'With boundaries (Red)']))
%axis square;
hold on

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
%
Boundaries = [min(LiverMeshpoints(:,1)),max(LiverMeshpoints(:,1)),min(LiverMeshpoints(:,2)),max(LiverMeshpoints(:,2))...
    ,min(LiverMeshpoints(:,3)),max(LiverMeshpoints(:,3))  ];


figure(2)
fIndexs = zeros(6,3);
    for i = 1:6
        [fRow,fCol] = find( LiverMeshpoints(:,:) == Boundaries(i) );
        if mod(i,2) == 0 
            fIndexs(i,:) = LiverMeshpoints(fRow,:) %+ 40;
        else
            fIndexs(i,:) = LiverMeshpoints(fRow,:) %- 30;
        end
    end 
scatter3(fIndexs(:,1), fIndexs(:,2), fIndexs(:,3), 50, 'r', 'filled')




    
%%
figure
model = createpde;
model2 = createpde;
importGeometry(model,'Liver_001_v2_smooth_remesh.stl');
pdegplot(model,'EdgeLabels','off')

gm = importGeometry(model2,'Liver_001_v2_smooth_remesh.stl');
%%
tmpvol = zeros(300,300,300); % Empty voxel volume
% 
 for i  = 1:length(LiverMeshpoints)
     tmpvol(round(LiverMeshpoints(i,1),0), round(LiverMeshpoints(i,2),0), round(LiverMeshpoints(i,3),0)) = 1;
 end 
%%
tmpvol = zeros(20,20,20); % Empty voxel volume
tmpvol(5:15,8:12,8:12) = 1; % Turn some voxels on
tmpvol(8:12,5:15,8:12) = 1;
tmpvol(8:12,8:12,5:15) = 1;

fv = isosurface(tmpvol, 0.99); % Create the patch object
fv.faces = fliplr(fv.faces); % Ensure normals point OUT
%%
% % Test SCATTERED query points
%pts = rand(200,3)*200 + 4; % Make some query points
pts = rand(200,3)*12 + 4; % Make some query points
in = inpolyhedron(fv, pts); % Test which are inside the patch
figure, hold on, view(3) % Display the result
patch(fv,'FaceColor','g','FaceAlpha',0.2)
plot3(pts(in,1),pts(in,2),pts(in,3),'bo','MarkerFaceColor','b')
plot3(pts(~in,1),pts(~in,2),pts(~in,3),'ro'), axis image
%%
% Test STRUCTURED GRID of query points
%gridLocs = 1:20:300;
gridLocs = 3:2.1:19;
[x,y,z] = meshgrid(gridLocs,gridLocs,gridLocs);
in = inpolyhedron(fv, gridLocs,gridLocs,gridLocs);
figure, hold on, view(3) % Display the result
patch(fv,'FaceColor','g','FaceAlpha',1)
plot3(x(in), y(in), z(in),'bo','MarkerFaceColor','b')
plot3(x(~in),y(~in),z(~in),'ro'), axis image

%%
model_2 = mphload( "C:\Users\servinf\.comsol\v56\llmatlab\Liver_MWA_MODELS_with_Tumor\001_915_mhz_COLLINS_Probe_Healthy_Tissue _with_tumor.mph");
%
model_2_mod = mphmodel(model_2);
geometry = mphgeom(model_2, 'geom1');
geometry_2 = mphgeom(model_2, 'mgeom1');
Expression_1 = mphgetexpressions(model_2.param);

mesh = model_2.mesh('mesh1')
%%
file_name = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\Imaging Data-selected\Patient_001_Masked Volume.nii.gz";
file_name2 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\Imaging Data-selected\Patient_002_Masked Volume_1.nii.gz";
file_name3 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\Imaging Data-selected\Patient_003_Masked Volume.nii.gz";
file_name4 = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\2021-Liver Project - Patient Data\All Image Data Segmentations\Imaging Data-selected\Patient_004_Masked Volume_2.nii.gz";
files = [file_name, file_name2, file_name3, file_name4];
scale = [1,1,10,10];
%
set(gcf,'color','w');
for i = 1:4
[X] = niftiread(files(i));
dicom_hist_new_text = [];
dicom_hist_new = reshape(X, [],1);
dicom_hist_new_text =[dicom_hist_new_text; dicom_hist_new]; 
dicom_hist_new_text(dicom_hist_new_text == 0) = [];
dicom_hist_new_text = dicom_hist_new_text/(scale(i)) ;
%dicom_hist_new_text = dicom_hist_new_text/length(dicom_hist_new_text);
%
hold on
%subplot(2,2,i)
histogram(dicom_hist_new_text,'Normalization','pdf')
end 
legend_string = ["3.9% fat", "14.7% fat", "22.0% fat", "29.9% fat"];
legend(legend_string,'AutoUpdate','off')
hold off
title("Fat Distrbution From ROIs")
xlabel("Fat %")
ylabel("Probability Density")

%
% the following line skip the name of the previous plot from the legend
%h.Annotation.LegendInformation.IconDisplayStyle = 'off';
xline(0, '-', {'Low'})
xline(6,'-', {'Mild'})
xline(17,'-', {'Moderate'})
xline(22,'-', {'High'})

