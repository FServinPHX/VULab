

function [outputPoints] = rotateZalongPoint( Points, angle, center )
% Variables
% Points = n * 3
% center = 1*3
R = rotz(angle);

outputPoints = (R*(Points') )' ;

outputPoints = outputPoints + ( center - mean(outputPoints)  )  ;

end 