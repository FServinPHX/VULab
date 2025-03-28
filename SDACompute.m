function [distancesGT, distancesTumorInt] = SDACompute( GroundTruthPTx, Expt,  InterogatePts, BndPtsin, BndPtsout  )

            Expt.PointsIn =  Expt.TumPointsIn;
            Expt.PointOut = Expt.TumPointOut;
            % Calculate the signed distance to agreement between the two point clouds
            %signed distance to agreement between All Ablation points
            %inside the tumor
            x1 = BndPtsin(:,1);
            y1 = BndPtsin(:,2);
            z1 = BndPtsin(:,3);

            x2 =InterogatePts(:,1);
            y2 =InterogatePts(:,2);
            z2 =InterogatePts(:,3);
%           %outde the tumor
      
            distancesGT = [];
           
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2)).*-1;
                distancesGT=[ distancesGT,dist] ;
            end
            
            x1 = BndPtsout(:,1);
            y1 = BndPtsout(:,2);
            z1 = BndPtsout(:,3);            
            
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2));
                 distancesGT=[ distancesGT,dist] ;
            end
            
            
            %%SDA TUMOR!!!
            % Calculate the signed distance to agreement between the two point clouds
            %signed distance to agreement between All Ablation points
            %inside the tumor
            x1 = Expt.PointsIn(:,1);
            y1 = Expt.PointsIn(:,2);
            z1 = Expt.PointsIn(:,3);

            x2 = GroundTruthPTx(:,1);
            y2 = GroundTruthPTx(:,2);
            z2 = GroundTruthPTx(:,3);
%           %outde the tumor
      
            distancesTumorInt = [];
           
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2)).*-1;
                distancesTumorInt=[ distancesTumorInt,dist] ;
            end
            
            x1 =  Expt.PointOut(:,1);
            y1 =  Expt.PointOut(:,2);
            z1 =  Expt.PointOut(:,3);            
            
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2));
                 distancesTumorInt=[ distancesTumorInt,dist] ;
            end    
            
end          
            
            