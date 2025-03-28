
%A is what you start off with (t), Z is what you get (t+1);
function [Vectors] = AIM3AblationVectorField( QuerryPointsOG, TargetPoint )


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
       
         
         %[dist, idx] = sort( sqrt((x - x1(i) ).^2+( y - y1(i) ).^2+( z - z1(i) ).^2), 'ascend'); 
         
         [dist, idx] = sort( sqrt((x1(i)-x ).^2+( y1(i)-x ).^2+( z1(i)-z ).^2), 'ascend'); 
         
         
         I = idx(2);     I2 = idx(3);     I3 = idx(4);      

         %triangulateMatrix  =  [ triangulateMatrix; I, I2, I3];   
%          nextPoint = [nextPoint; idx(1); idx(2)];
%          
          VectorI  = ( [ x1(i) , y1(i), z1(i) ] - [x(I) , y(I),  z(I) ]  );
%          VectorI2 = ( [x1(i) , y1(i), z1(i)] - [x(I2), y(I2), z(I2)]  );
%          VectorI3 = ( [x1(i) , y1(i), z1(i)] - [x(I3), y(I3), z(I3)]  );
%          
%          Vectors = [Vectors; (VectorI + VectorI2 + VectorI3)/3  ];
        
%          for j = 1:1
%              I =  idx(j + 1);
%              VectorI  = [ VectorI; [ x1(i) , y1(i), z1(i) ] - [x(I) , y(I),  z(I) ] ];                    
%          end 
         
          Vectors = [Vectors; VectorI ];
                       
end


end 