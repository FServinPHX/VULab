



   function [transformed_Ablation] =     transformPointCloud_Aim3(pointCloud, theta, psi, centralPoint)
           
   
            P = pointCloud;
            R = rotx( -90  );
            %R = rotx( 0  );
            C = [R*P']' ; 
            P = C -  mean(C);

            %rotate along the y-axis
            R2 = roty( 0 );
            C = [R2*P']' ; 
            P = C -  mean(C);

            newCenter =  [0 , 0 , 0] - mean(P);
            X2 = P(:,1) + newCenter(1);
            Y2 = P(:,2) + newCenter(2);
            Z2 = P(:,3) + newCenter(3);
            X = X2;
            Y = Y2;
            Z = Z2;
            
            
            psi2 =   [ psi  ];
            theta2 = [ theta ]; 
            %rearrange the points
            YP =  YawPitch(psi2, theta2); 
            P = [X,  Y, Z ];
            C = [YP*P']' ; 
            P = C -  mean(C);
            %AblationCenter = mean([X,Y,Z]); 
            newCenter =  mean(P) - [ 0 , 0 , 0] ;
            X2 = P(:,1) + newCenter(1)+ centralPoint(1);
            Y2 = P(:,2) + newCenter(2)+ centralPoint(2);   
            Z2 = P(:,3) + newCenter(3);

            transformed_Ablation = [X2, Y2,  Z2];
            
   end               