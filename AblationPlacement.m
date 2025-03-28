

function [ tform ] = AblationPlacement(center, radii, numProbe)

switch numProbe
    case  4  
          BoundaryPoints.tMat = [ ( radii(2)*(sqrt(2)) ),...
                0,...
                ( radii(2)*(sqrt(2)) ) ];
        
        %create a matrix to add to the original data points. Every case is a
        %new hypotherical probe
           tform = [0, 0, 0; 0, 0, BoundaryPoints.tMat(3);...
                  BoundaryPoints.tMat(1),0,BoundaryPoints.tMat(3),...
                  BoundaryPoints.tMat(1), 0, 0];

 

    case 3
          BoundaryPoints.tMat = [ ( radii(2) ),...
                0,...
                ( radii(2) ) ];
        
        %create a matrix to add to the original data points. Every case is a
        %new hypotherical probe
        tform = [0 ,0 , 0; 0, 0, BoundaryPoints.tMat(3);...
            BoundaryPoints.tMat(1)/2,0,BoundaryPoints.tMat(3)/2];

end 


end 