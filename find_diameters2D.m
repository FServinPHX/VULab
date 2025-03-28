 
%Finds the diameter of a data set. This method establishes three points
%that are have the maximum x, y, and z value. With these 'max' points,
%there are corresponding points with a minimum value in x, y, and z
%respectively. However, sometimes the absolute max and absolute minimum are
%not aligned. So when you try to the distance between the points if you do
%not make sure that they are almost in a straight line, you could
%accidentally capture a diagonal diameter. Ths code iterates through points
%to find a set of points that create a line to represent the diameter in
%the x,y,and z direction respectively

function [xyz_diam] = find_diameters2D(necrosis_points)
xyz_diam = [];
nec_points_1 = [];
nec_points_2 = [];
for n_d_p = 1:2
    poi = [1,2];
    poi2 = [2,1];
    
    nec_diam = sortrows(necrosis_points,poi(n_d_p));
    i_ndc = 1;
    i_prog = 1;
    err = 1;

    %the error makes sure that the points are < 3 degrees apart
    %Ablation Paper:  err > .03
    while err > .035

        nec_1 = nec_diam(i_ndc,:);
        nec_2 = nec_diam(end-i_prog,:);
        
        
        err1 = abs( ( nec_1(poi2(n_d_p))- nec_2(poi2(n_d_p)) )./ nec_1(poi2(n_d_p)) );
        err2 = abs( ( nec_1(poi2(n_d_p))- nec_2(poi2(n_d_p)) )./ nec_1(poi2(n_d_p)) );
        
%         err1 = abs( ( nec_1(poi2(n_d_p))- nec_2(poi2(n_d_p)) ) ) ;
%         err2 = abs( ( nec_1(poi2(n_d_p))- nec_2(poi2(n_d_p)) ) ) ;
        
        err = ( err1+err2 )/2;
        
        
        i_prog = i_prog +1;
        %if  no points are satisfied in the first 100 tries  then choose the
        %next furthest point.
        if i_prog > 100
            i_prog = 1; i_ndc = i_ndc + 1;
        end 
        
        
    end
    %
    diameter = sqrt( (nec_1(1)- nec_2(1)).^2 + (nec_1(2)- nec_2(2)).^2 )/10;
    xyz_diam = [ xyz_diam, diameter];
    
%     nec_points_1 = [nec_points_1; nec_1];
%     nec_points_2 = [nec_points_2;nec_2];
%
end 
