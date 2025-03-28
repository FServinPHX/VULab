clear
close all
% semi axis parameters
a = 50;       % x-axis 
b = 50;       % y-axis
c = 50;     % z-axis

%Parametrisation
%
%  To reach each point of the ellipsoide we need two angle:
%  phi   ∈ [0,2𝜋]
%  theta ∈ [0, 𝜋]
% 
%  But since we only need half of an ellipsoide we can set
%  theta ∈ [0,𝜋/2]

%Dome 
[theta,phi] = ndgrid(linspace(0,pi/2,25),linspace(0,2*pi,25));
x = a*sin(theta).*cos(phi);
y = b*sin(theta).*sin(phi);
z = c*cos(theta);



%Bottom
[theta,phi] = ndgrid(linspace(0,pi/2,15),linspace(0,2*pi,15));
x2 = a*sin(theta).*cos(phi);
y2 = b*sin(theta).*sin(phi);
z2 = c*cos(theta).*0;


%plot
% surf(x,y,z)
% axis equal
% 
% hold on

x = reshape(x,[],1);
y = reshape(y,[],1);
z = reshape(z,[],1);
x2 = reshape(x2,[],1);
y2 = reshape(y2,[],1);
z2 = reshape(z2,[],1);

xa = [x;x2];
ya = [y; y2];
za = [z;z2];
P = [xa, ya, za]; 

k = boundary(P, 0);
pt = trisurf( k ,xa,ya,za, 20, 'EdgeColor',...
                      rgb('Black'), 'EdgeAlpha', .5, 'FaceAlpha',.9 );
                  
axis equal

