



%function plot_dicom_slices(dicom_file, slice_orientation)

slice_orientation = 'axial'; 
FileList = 3;
iCreateVideo = "TRUE";


switch FileList
        
    case 1
            dicom_file = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Ablation Phantom Study\MRI IMAGES\Moore_20240716-2\Moore_20240716-2\DICOM\Moore_20240716-2.02.01.13-11-32.WIP_3D_MPRAGE_(VUIIS).01.DCM";
            VideName = "3D_MPRAGE   _1"; 
    case 2
            dicom_file = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Ablation Phantom Study\MRI IMAGES\Moore_20240716-2\Moore_20240716-2\DICOM\Moore_20240716-2.03.01.13-15-18.WIP_3D_TFE_(VUIIS).01.DCM";
            VideName = "3D_MPRAGE   _2"; 
    case 3
            dicom_file = "C:\Users\servinf\Documents\1.0 Vanderbilt\1.0 Dr. Miga Lab\Liver Ablation Phantom Study\MRI IMAGES\Moore_20240716-2\Moore_20240716-2\DICOM\Moore_20240716-2.04.01.13-19-12.WIP_3D_MPRAGE_(VUIIS).01.DCM";
            VideName = "3D_MPRAGE   _3"; 
end 


  if iCreateVideo == "TRUE"
            Video_Dir = "D:\VideoFiles\Beef Ablation Study\";
            Video_FileName = join([  "MRI IMAGE", "   ", slice_orientation, "   ",...
                                          VideName,'.avi']);
            Video_FileName = convertStringsToChars(Video_FileName);
            Video_fullfile = fullfile(Video_Dir, Video_FileName);
            videoWriter = VideoWriter(Video_fullfile); %// initialize the VideoWriter object
            videoWriter.FrameRate = 2.0;
            videoWriter.Quality = 100; % High quality video
            open(videoWriter);
        end



    % Load the DICOM image
    vol = dicomread(dicom_file);
    info = dicominfo(dicom_file);
    
    % Get the dimensions of the volume
    [x, y, z] = size(vol);
    
    % Create a figure for plotting
    figure;

    % Switch statement to choose the slice orientation
    switch slice_orientation
        case 'axial'
            for i = 1:z
                % Extract the ith axial slice
                slice = squeeze(vol(:,:,i));
                
                % Plot the slice
                imagesc(slice);
                colormap gray;
                axis equal;
                axis tight;
                title(['Axial Slice Number: ', num2str(i)]);
                
                % Pause to display the image
                pause(0.25);

                    if iCreateVideo == "TRUE"
                        Frame = getframe(gcf) ;                
                        writeVideo(videoWriter,Frame)  
                    end 
            end
            
        case 'coronal'
            for i = 1:y
                % Extract the ith coronal slice
                slice = squeeze(vol(:,i,:));
                
                % Plot the slice
                imagesc(slice);
                colormap gray;
                axis equal;
                axis tight;
                title(['Coronal Slice Number: ', num2str(i)]);
                
                % Pause to display the image
                pause(0.25);

                    if iCreateVideo == "TRUE"
                        Frame = getframe(gcf) ;                
                        writeVideo(videoWriter,Frame)  
                    end                 
            end
            
        case 'sagittal'
            for i = 1:x
                % Extract the ith sagittal slice
                slice = squeeze(vol(i,:,:));

                % Plot the slice
                imagesc(slice);
                colormap gray;
                axis equal;
                axis tight;
                title(['Sagittal Slice Number: ', num2str(i)]);
                
                % Pause to display the image
                pause(0.25);

                    if iCreateVideo == "TRUE"
                        Frame = getframe(gcf) ;                
                        writeVideo(videoWriter,Frame)  
                    end                 
            end
            
        otherwise
            error('Invalid slice orientation. Choose ''axial'', ''coronal'', or ''sagittal''.');
    end
%

        if iCreateVideo == "TRUE" 
            close(videoWriter); 
            disp("Video Complete")
            disp(videoWriter.Filename  )
        end  







