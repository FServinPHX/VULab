        
function [patchPlot,center,radii,v  ] = PlotEllispeNew(x, y, z)

% p3 = plot3( x, y, z, '.k','MarkerSize',1);
% alpha(p3,.2)

[center, radii , evecs, v, chi2 ] = ellipsoid_fit_new( [ x, y, z ], '' );



mind = min( [ x y z ] );
maxd = max( [ x y z ] );
nsteps = 50;
step = ( maxd - mind ) / nsteps;
[ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ),...
    linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ),...
    linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
          2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
          2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
patchPlot = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );

end 
        