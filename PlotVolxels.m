%%
%Plotting the voxels for Scanner 1
clear 

gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];



center = [0,0,0];
pVox.VoxSize = [2.0883, 2.0883, 3 ] ;
%Choose where to start and end 
strt = [-2, 0, -1];
endd = [0,1,0];


pVox.points = [0 4 0; -4 1 0];
pVox.Volxelx = [ center(1) +  pVox.VoxSize(1)*strt(1) :pVox.VoxSize(1): pVox.VoxSize(1)*endd(1)  +  center(1)  ] ;
pVox.Volxely = [ center(2) +  pVox.VoxSize(2)*strt(2) :pVox.VoxSize(2): pVox.VoxSize(2)*endd(2)  +  center(2)  ] ;
pVox.Volxelz = [ center(3) +  pVox.VoxSize(3)*strt(3) :pVox.VoxSize(3): pVox.VoxSize(3)*endd(3)  +  center(3)  ] ;

%plotcube( EDGES , ORIGIN , ALPHA  , COLOR 
%e.g.  plotcube([5 5 5],[ 2 2 2],.8,[1 0 0]);
for zi = 1:length(pVox.Volxelz)
    for j = 1:length(pVox.Volxely)
        for i = 1:length(pVox.Volxelx)
            
            pVox.xc = pVox.Volxelx(i);
            pVox.yc = pVox.Volxely(j);
            pVox.zc = pVox.Volxelz(zi);
            
            plotcube( pVox.VoxSize ,[ pVox.xc pVox.yc pVox.zc] , .1, green );
            hold on
            
        end 
    end
end 

set(gcf,'color','w');
set(gca,'FontSize',14)

plot3(pVox.points(:,1), pVox.points(:,2), pVox.points(:,3), '.', 'MarkerSize',30 )
hold off

text( pVox.points(1,1), pVox.points(1,2), pVox.points(1,3), ...
    "Patient 1",'FontSize',16)
text( pVox.points(2,1), pVox.points(2,2), pVox.points(2,3), ...
    "Patient 2",'FontSize',16)


title("Final Alignment of Patients From Scanner 1") 
xlabel("X (mm)")
ylabel("Y (mm) ")
zlabel("Z (mm)")
axis vis3d equal;
camlight;
lighting phong;


%%

clear 

gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
red = [0.6	0.239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];



center = [-10,-51,0];
pVox.VoxSize = [2.0883, 2.0883, 3 ] ;
%Choose where to start and end 
strt = [-2, -2, -1];
endd = [-1,0,0];

%Patient Points 
pVox.points = [-11 -51 0; -12 -54 0];

pVox.Volxelx = [ center(1) +  pVox.VoxSize(1)*strt(1) :pVox.VoxSize(1): pVox.VoxSize(1)*endd(1)  +  center(1)  ] ;
pVox.Volxely = [ center(2) +  pVox.VoxSize(2)*strt(2) :pVox.VoxSize(2): pVox.VoxSize(2)*endd(2)  +  center(2)  ] ;
pVox.Volxelz = [ center(3) +  pVox.VoxSize(3)*strt(3) :pVox.VoxSize(3): pVox.VoxSize(3)*endd(3)  +  center(3)  ] ;

%plotcube( EDGES , ORIGIN , ALPHA  , COLOR 
%e.g.  plotcube([5 5 5],[ 2 2 2],.8,[1 0 0]);
for zi = 1:length(pVox.Volxelz)
    for j = 1:length(pVox.Volxely)
        for i = 1:length(pVox.Volxelx)
            
            pVox.xc = pVox.Volxelx(i);
            pVox.yc = pVox.Volxely(j);
            pVox.zc = pVox.Volxelz(zi);
            
            plotcube( pVox.VoxSize ,[ pVox.xc pVox.yc pVox.zc] , .1, gold );
            hold on
            
        end 
    end
end 

set(gcf,'color','w');
set(gca,'FontSize',14)

plot3(pVox.points(:,1), pVox.points(:,2), pVox.points(:,3), '.', 'MarkerSize',30 )
hold off

text( pVox.points(1,1), pVox.points(1,2), pVox.points(1,3), ...
    "Patient 3",'FontSize',16)
text( pVox.points(2,1), pVox.points(2,2), pVox.points(2,3), ...
    "Patient 4",'FontSize',16)


title("Final Alignment of Patients From Scanner 2") 
xlabel("X (mm)")
ylabel("Y (mm) ")
zlabel("Z (mm)")
axis vis3d equal;
camlight;
lighting phong;

