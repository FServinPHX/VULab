
%A is what you start off with (t), Z is what you get (t+1);
function [Vectors] = AIM3AblationVectorFieldLinked( QuerryPointsOG, TargetPoint )


x = TargetPoint(:,1);
y = TargetPoint(:,2);
z = TargetPoint(:,3);

x1 = QuerryPointsOG(:,1);
y1 = QuerryPointsOG(:,2);
z1 = QuerryPointsOG(:,3);


nextPoint = [];
Vectors = [];
VectorI = [];
for i=1:length(x1)
         

         %triangulateMatrix  =  [ triangulateMatrix; I, I2, I3];   
%          nextPoint = [nextPoint; idx(1); idx(2)];
%          
        VectorI  = ( [ x1(i) , y1(i), z1(i) ] - [x(i) , y(i),  z(i) ]  );
        magnitude = norm(VectorI);  % Calculate the magnitude of the vector

        
        % If the magnitude exceeds 5, find the nearesst point
        if magnitude > 5
            [dist, idx] = sort( sqrt((x1(i)-x ).^2+( y1(i)-x ).^2+( z1(i)-z ).^2), 'ascend'); 
             I = idx(2);     I2 = idx(3);     I3 = idx(4);   
             VectorI  = ( [ x1(i) , y1(i), z1(i) ] - [x(I) , y(I),  z(I) ]  );            
        end
    
        
          Vectors = [Vectors; VectorI ];
                       
end


end 