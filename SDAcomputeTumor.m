function [distances, distancesTumor  ] = SDAcomputeTumor(BndPtsin, TumorPoints, BndPtsout,...
                                         TumPointsIn, AblationPoints ,TumPointOut )


            % Calculate the signed distance to agreement between the two point clouds
            %signed distance to agreement between All Ablation points
            %inside the tumor
            x1 = BndPtsin(:,1);
            y1 = BndPtsin(:,2);
            z1 = BndPtsin(:,3);

            x2 = TumorPoints(:,1);
            y2 = TumorPoints(:,2);
            z2 = TumorPoints(:,3);
%           %outde the tumor
      
            distances = [];
           
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2)).*-1;
                distances=[ distances,dist] ;
            end
            
            x1 = BndPtsout(:,1);
            y1 = BndPtsout(:,2);
            z1 = BndPtsout(:,3);            
            
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2));
                 distances=[ distances,dist] ;
            end
            
            
            %%SDA TUMOR!!!
            % Calculate the signed distance to agreement between the two point clouds
            %signed distance to agreement between All Ablation points
            %inside the tumor
            x1 = TumPointsIn(:,1);
            y1 = TumPointsIn(:,2);
            z1 = TumPointsIn(:,3);

            x2 = AblationPoints(:,1);
            y2 = AblationPoints(:,2);
            z2 = AblationPoints(:,3);
%           %outde the tumor
      
            distancesTumor = [];
           
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2)).*-1;
                distancesTumor=[ distancesTumor,dist] ;
            end
            
            x1 =  TumPointOut(:,1);
            y1 =  TumPointOut(:,2);
            z1 =  TumPointOut(:,3);            
            
            for i=1:length(x1)
                [dist]=min(sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2));
                 distancesTumor=[ distancesTumor,dist] ;
            end   
            
            
            
end 