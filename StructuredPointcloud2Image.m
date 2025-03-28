function I = TriangulateMatrix( intensity, dimensionx, dimensiony, dimensionz )

% x = P(:,1);
% y = P(:,2);
% z =P(:,3);
% intensity = distances;
% C = unique(z) ; 
% dimensionx = dimension;
% dimensiony = dimension;
% dimensionz = dimension; 

I = zeros(dimensionx, dimensiony, dimensionz); 
index = 1; 
for zi = 1:dimensionz
    
    for xi = 1:dimensionx

        for yi = 1:dimensiony
           
            %index = (zi-1)*dimensionz + (x1-1)*dimensionx + dimensiony;
            
            I(xi,yi,zi) = intensity(index); 
            index = index+1; 
            
        end 
    end 
end 



end 
        
        













% end 