function [ NewPoints ] = UpsampleAblationMidpoint( Pablation )


x1 = Pablation(:,1);
y1 = Pablation(:,2);
z1 = Pablation(:,3);

 newpoints=[ ]; 
 
 
 
 
 
for i=1:length(x1)
    
    [ dist, idx ] =  sort( sqrt((x1(i)-x1).^2+(y1(i)-y1).^2+(z1(i)-z1).^2) );
    
    %find the midpoint between the two closest points
    stop = 1;
    j = 1;
    newpoint = [];
    while  stop >0
        
        
        if dist(j) > 1 && dist(j) < 5
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


% scatter3( x1, y1, z1,'b', 'filled');
% axis equal
% pause(1)
% hold on
% scatter3( newpoints(:,1) , newpoints(:,2) , newpoints(:,3), 'r', 'filled');
% % pause(1)
% % scatter3( NewPoints(:,1) , NewPoints(:,2) , NewPoints(:,3), 'g', 'filled');




