function [filtered_data, k] = find_unique_boundary(x,y,z, alpha)


k = boundary(x, y, z, alpha);
k = reshape( k, [], 1 );
k = unique(k);

filtered_data = [ x(k), y(k), z(k) ];

end 