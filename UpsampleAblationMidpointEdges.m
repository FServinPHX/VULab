function [ NewPoints ] = UpsampleAblationMidpointEdges( Pablation )


x1 = Pablation(:,1);
y1 = Pablation(:,2);
z1 = Pablation(:,3);

 newpoints=[ ]; 
for i=1:length(x1)
    
    [ dist, idx ] =  sort( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2) );
    
    %find the midpoint between the two closest points
    stop = 1;
    j = 3;
    newpoint = [];
    while  stop >0
        
        
        if dist(j) > 4 && dist(j) < 20
            I = idx(j);
            newpoint = [ (x1(i) + x1(I))/2,  (y1(i) + y1(I))/2,  (z1(i) + z1(I))/2  ]; 
        end 
        
        
        
        if j > 10
            stop = -1;
        end 
            
        j = j+1;
    end 

        
        
    newpoints=[ newpoints; newpoint] ;
    
    
    
end


NewPoints = [ Pablation; newpoints]; 
end 