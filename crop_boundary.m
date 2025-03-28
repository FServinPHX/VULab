% boundary = [55,230,100,280,40,200];
% [new_data] = crop_boundary(new_data, boundary(1), boundary(2), boundary(3)...
%     ,boundary(4), boundary(5), boundary(6));
% min_x =  boundary(1);
% max_x =  boundary(2);
% min_y =  boundary(3);
% max_y = 

function [new_data] = crop_boundary(data, min_x, max_x, min_y, max_y, min_z, max_z)
for i = 1:length(data)
    if data(i,1) > max_x || data(i,1) < min_x
       data(i,1:end) = NaN;
    end 
    if data(i,2) > max_y || data(i,2) < min_y
       data(i,1:end) = NaN; 
    end 
    if data(i,3) > max_z || data(i,3) < min_z
       data(i,1:end) = NaN;
        %disp("Assigned")
    end 
end 
%data(data == NaN) = [];
data = rmmissing(data);
new_data = data;