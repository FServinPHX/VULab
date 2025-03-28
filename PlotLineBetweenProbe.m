function [ midpoints ] = PlotLineBetweenProbe(  e1, e2 ) 

midpoints = []; 
for start = 1:2
    
    switch start
        case 1 
            line1 = e1;
            line2 = e2;
        case 2
            line1 = e2;
            line2 = e1;
    end 

    x1 = line1(:,1);
    y1 = line1(:,2);
    z1 = line1(:,3);

    x2 = line2(:,1);
    y2 = line2(:,2);
    z2 = line2(:,3);

     distances=[ ]; 
    for i=1:length(x1)

        [ dist, Index] =  min( sqrt((x1(i)-x2).^2+(y1(i)-y2).^2+(z1(i)-z2).^2) );
        distances=[ distances; dist, i,  Index ] ;
        
    end

    %Find the points that are closest to each other
    [distancesort, I] = sort(distances(:,1));
    Is = distances(:,2) ;
    Indexes = distances(:,3) ;

    distancesNew = [ distances(I), Indexes(I), Is(I)];

    %Fing the midpoints 
    arr = 1:5:200; 
    for k = 1:1

            j = arr(k);
            I1 = distancesNew(j,2);
            I2 =  distancesNew(j,3);
            A = [ x1(I1), y1(I1), z1(I1) ];
            B = [ x2(I2), y2(I2), z2(I2) ];     

            n = 40;
            X = [A; B];
            t = linspace(0, 1, n+1);
            points = interp1([0 1], X, t);  
            midpoints = [midpoints; points]; 
    end 


end 