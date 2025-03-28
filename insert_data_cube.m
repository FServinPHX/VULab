% data = data_input;
% center_x = 100;
% center_y = 100;
% center_z = 100;
% 
% x_length = 10;
% y_length = 10;
% z_length = 10;
% 
% slice_x = 2.56;
% slice_y = 2.56;
% slice_z = 3;


function [newData] = insert_data_cube(data,centerX,centerY,centerZ,xLength,yLength,zLength,assignedValue)

if yLength > 70
    y_length_2 = 70;
else 
    y_length_2 = yLength;
end 

%%%This is changed to produce a data cube that only captutes half of the
%%%fat
for i = 1:length(data)
    %Whole Cube 
    %data(i,1) < centerX + xLength && data(i,1) > centerX - xLength
    %Half Cube
    %data(i,1) < centerX && data(i,1) > centerX - xLength
    if data(i,1) < centerX && data(i,1) > centerX - xLength
        if data(i,2) < centerY + yLength  && data(i,2) > centerY -  y_length_2
            if data(i,3) < centerZ + zLength && data(i,3) > centerZ - zLength
                data(i,4) = assignedValue;
                %disp("Assigned")
            end 
        end 
    end 
end 
newData = data;