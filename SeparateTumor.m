function [ TumorPoints ] = SeparateTumor(center, numProbe, tumorCloud)

% Output:
% * center    -  ellispoid or other conic center coordinates [xc; yc; zc]
% * radii     -  ellipsoid or other conic radii [a; b; c]


switch numProbe
    case 4
        TumorPoints.one = [];
        TumorPoints.two = [];
        TumorPoints.three = [];
        TumorPoints.four = [];

        for i = 1:length(tumorCloud)
            %If the points are larger than 

            if  tumorCloud(i,1) < center(1) && tumorCloud(i,3) > center(3) 
                TumorPoints.one = [TumorPoints.one;...
                    tumorCloud(i,:)];

            elseif tumorCloud(i,1) > center(1) && tumorCloud(i,3) > center(3) 
                TumorPoints.two = [TumorPoints.two;...
                    tumorCloud(i,:)];

            elseif tumorCloud(i,1) < center(1) && tumorCloud(i,3) < center(3) 
                TumorPoints.three = [TumorPoints.three;...
                    tumorCloud(i,:)];

            elseif tumorCloud(i,1) > center(1) && tumorCloud(i,3) < center(3) 
                TumorPoints.four = [TumorPoints.four;...
                    tumorCloud(i,:)];


            end
        end
    case 3

        TumorPoints.one = [];
        TumorPoints.two = [];
        TumorPoints.three = [];
        
        for  i = 1:length(tumorCloud)
            
            line1 = center(3) + 1*tumorCloud(i,1);
            line2 = center(3) - 1*tumorCloud(i,1);
            
            %Tumor one 
            if  tumorCloud(i,1) < center(1) && tumorCloud(i,3) > center(3) 
                TumorPoints.one = [TumorPoints.one;...
                    tumorCloud(i,:)];
            elseif tumorCloud(i,1) < center(1) && tumorCloud(i,3) > line1
                TumorPoints.one = [TumorPoints.one;...
                    tumorCloud(i,:)];
                
            %Tumor two
            elseif tumorCloud(i,1) > center(1) && tumorCloud(i,3) > center(3) 
                TumorPoints.two = [TumorPoints.two;...
                    tumorCloud(i,:)]; 
            elseif tumorCloud(i,1) > center(1) && tumorCloud(i,3) > line2 
                TumorPoints.two = [TumorPoints.two;...
                    tumorCloud(i,:)]; 

                
            %Tumor 3
            else 
                TumorPoints.three = [TumorPoints.three;...
                    tumorCloud(i,:)];             
            end 
            
        end 



end 

end