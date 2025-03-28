

%Create the Box Phantom Model
%VoxSize = [100, 100, 100 ] ;


function [ QuerryPointsOG, Points_To_Volume]  = CreateRegularGrid( VoxSize , intensitySpc )



%Create the Box Phantom Model
% Step 1: Generate a 3D spherical point cloud shell
num_points = 1000;
theta = 2 * pi * rand(num_points, 1);
phi = acos(2 * rand(num_points, 1) - 1);
radius = 30;
x = radius * sin(phi) .* cos(theta);
y = radius * sin(phi) .* sin(theta);
z = radius * cos(phi);
points = [x y z];



    %Create the Box Phantom Model
    %VoxSize = [100, 100, 100 ] ;
    center = [0,0,0]- (VoxSize/2) ;
    %Choose where to start and end 
    strt = [0, 0, 0];
    endd = [0,0,0];
    
    
    pVox.points = [0 0 0; 0 0 0];
    pVox.Volxelx = [ center(1) +  VoxSize(1)*strt(1) :VoxSize(1): VoxSize(1)*endd(1)  +  center(1)  ] ;
    pVox.Volxely = [ center(2) +  VoxSize(2)*strt(2) :VoxSize(2): VoxSize(2)*endd(2)  +  center(2)  ] ;
    pVox.Volxelz = [ center(3) +  VoxSize(3)*strt(3) :VoxSize(3): VoxSize(3)*endd(3)  +  center(3)  ] ;
    
    
    
    [intensity.X,intensity.Y,intensity.Z] = meshgrid( pVox.Volxelx : intensitySpc : abs(pVox.Volxelx),...
        pVox.Volxely : intensitySpc :abs(pVox.Volxely), ...
        pVox.Volxelz : intensitySpc :abs(pVox.Volxelz) ) ;
    intensity.X = reshape(intensity.X, [],1);
    intensity.Y = reshape(intensity.Y, [],1);
    intensity.Z = reshape(intensity.Z, [],1);
    intensity.a = 1;
    intensity.b = 50;
    intensity.I = (intensity.b-intensity.a).*rand(length(intensity.X),1) + intensity.a;
    
    dimension = length(pVox.Volxelx : intensitySpc : abs(pVox.Volxelx));




    %
         
        TargetPoints = points ;
        QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
        center = [0,0,0];
        [ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  center ) ; 
        %
        %
        distancesIn = distances;
        distancesIn(distancesIn > 0) = nan;
        [filtered_coords, filtered_intensities] = Global_remove_nan_intensity(QuerryPointsOG, distancesIn);
        %
        %
        distances(distances >0) = 1;
        distances(distances <0) = -1;
    
    
        Volume = (4/3) * pi * radius^3; 
        Points_To_Volume = Volume/ length(filtered_coords);
        Volume = round( (Volume/1000), 2);



end 