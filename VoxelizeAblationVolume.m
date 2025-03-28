%Create a plot that shows the 
clear
close all

plot_Scatter = "FALSE";
plotAblation = "TRUE";


gold = [0.847058824	0.670588235	0.298039216];
blue = [0 0.4470 0.7410];
green = [0.4660 0.6740 0.1880];
%red = [0.6	0.239215686	0.105882353];
red = [1	0.0239215686	0.105882353];
orange = [0.8500 0.3250 0.0980];
purple = [0.4940 0.1840 0.5560];
black = [0	0	0];
cyan =	[0 1 1];
magenta	= [1 0 1];
yellow = [1 1 0];

colorsA = [gold; blue; green; red; orange; purple; black; cyan; magenta; yellow;  ...
    gold; blue; green; red; orange; purple; black];

%Create the Box Phantom Model
pVox.VoxSize = [100, 100, 100 ] ;
center = [0,0,0]- (pVox.VoxSize/2) ;
%Choose where to start and end 
strt = [0, 0, 0];
endd = [0,0,0];


pVox.points = [0 0 0; 0 0 0];
pVox.Volxelx = [ center(1) +  pVox.VoxSize(1)*strt(1) :pVox.VoxSize(1): pVox.VoxSize(1)*endd(1)  +  center(1)  ] ;
pVox.Volxely = [ center(2) +  pVox.VoxSize(2)*strt(2) :pVox.VoxSize(2): pVox.VoxSize(2)*endd(2)  +  center(2)  ] ;
pVox.Volxelz = [ center(3) +  pVox.VoxSize(3)*strt(3) :pVox.VoxSize(3): pVox.VoxSize(3)*endd(3)  +  center(3)  ] ;

intensity.spc = 1.5;

[intensity.X,intensity.Y,intensity.Z] = meshgrid( pVox.Volxelx : intensity.spc : abs(pVox.Volxelx),...
    pVox.Volxely : intensity.spc :abs(pVox.Volxely), ...
    pVox.Volxelz : intensity.spc :abs(pVox.Volxelz) ) ;
intensity.X = reshape(intensity.X, [],1);
intensity.Y = reshape(intensity.Y, [],1);
intensity.Z = reshape(intensity.Z, [],1);
intensity.a = 1;
intensity.b = 50;
intensity.I = (intensity.b-intensity.a).*rand(length(intensity.X),1) + intensity.a;

dimension = length(pVox.Volxelx : intensity.spc : abs(pVox.Volxelx));
%Plot 3D Scatter of Raw Image Data
if plot_Scatter == "TRUE"
    camlight 
%     figure()
    set(gcf,'color','w');
    %scatter3(PlotiNewText(:,2), PlotiNewText(:,3), PlotiNewText(:,4), .5 ,PlotiNewText(:,1)  )
    scatter3(intensity.X , intensity.Y , intensity.Z , 40 ,intensity.I, 'Filled' )
    %colormap('parula'); 
    colormap('jet')
    colorbar
    hold on 
    title( join(["Hypothetical Hetergenous", newline, "Liver Phantom Fat Quant"]), 'Fontsize', 14)
end 
%

    
plotAblation = "TRUE";
ModelRun = [ "Single Ablation" ] ;  


  
for angleIdx = 1:1  %1:N
    
    
Patient = ["Healthy";   "Low" ;  "Mild";   "Moderate";     "High"]; 
Angles = ["0"; "5"; "10"; "15"; "20"; "25"];
pj = 1;   
position = 1;     
selectfile = convertStringsToChars(Patient(pj)); 

%ModelRun = [ "Multiprobe" ] ;    

    switch ModelRun
        %%% 915 Mhz Tumor Naive Models
        case  "915 Mhz Tumor Naive"
            fileName = SelectAblationBoundaryPointsNoTumor( position , selectfile ) ;    
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Tumor Naive';


        %%% 915 Mhz Digital Twin Models    
        case "915 Mhz Digital Twin"
            fileName = SelectAblationBoundaryPoints( position , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\915 Digital Twin';


        %%% 2450 Mhz Tumor Naive Models
        case "2450 Mhz Tumor Naive"   
            %fileName = SelectAblationBoundaryPoints2450mhzNoTumor( position , selectfile ) ;
            fileName = SelectAblationBoundaryPts2450mhzNoTumorV2( position , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Tumor Naive V2';

        %%% 2450 Mhz Digital Twin Models
        case "2450 Mhz Digital Twin"
            fileName = SelectAblationBoundaryPoints2450mhzV2( position , selectfile ) ;
            resultsDir = 'D:\Import To Matlab\Volume and Diameter\2.45 GHz Digital Twin V2';    
        
        case "Single Ablation"
             fileName = "D:\Import To Matlab\Box Phantom\Single Antennae Ablation\Results\Boundary BoxGeomPhantom_TrueBeefAblation_SingleAblation60W.csv";
             
        case "Multiprobe"
             Angle = Angles(exprmt);
             fileName = SelectMultiAblationBoundaryPoints915mhz( position, Angle);
    end 
    

    disp(fileName)
    BoundaryPoints.og = readtable(fileName);
    BoundaryPointsMatrix =  table2array(BoundaryPoints.og(:,:));
    idx = 15*4:15*4;
     for j = 1:length(idx)

            itime = idx(j);
            X = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 1) );
            X(X == 0) = [];
            Y = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 2) );
            Y(Y == 0) = [];
            Z = BoundaryPointsMatrix(2:end, ((itime-1)*3 + 3) );
            Z(Z == 0) = [];
            Y = Y +3;
            BoundaryPoints.new = [X,Y,Z];
     end 

    %AblationCenter = mean([X,Y,Z]);  
    P = [ BoundaryPoints.new(:,1) ,  BoundaryPoints.new(:,2), BoundaryPoints.new(:,3)];
    newCenter =  [0 , 0 , 0] - mean(P);
    X2 = P(:,1) + newCenter(1);
    Y2 = P(:,2) + newCenter(2);
    Z2 = P(:,3) + newCenter(3);
    X = X2;
    Y = Y2;
    Z = Z2;
    %------------------------------------------------------------------------------------%

    TargetPoints = [X2,Y2,Z2];        QuerryPointsOG = [intensity.X , intensity.Y , intensity.Z];
    center = [0,0,0];
    [ distances ] = SDAVectorTarget( TargetPoints ,   QuerryPointsOG,  center ) ; 
    
    distancesIn = distances;
    distancesIn(distancesIn > 0) = nan;
    
    distances(distances >0) = 1;
    distances(distances <0) = -1;
    
    
    
    k = find(distances>0);
    

    % PLOT THE RESULTS
    %figure( (pj)*2  )
    if plotAblation == "TRUE"
        
        figure()
        set(gcf,'color','w');                
        %Find the triangulation of the Interogation Boundary Points 
        P = QuerryPointsOG;

        plot3( TargetPoints(:,1) , TargetPoints(:,2), TargetPoints(:,3), '.', 'Color', rgb('Red'),...
            'MarkerSize', 20)  
        hold on 

        s = repmat(.5, length(P(:,1)), 1); 
        scatter3( P(:,1) , P(:,2) ,P(:,3), s,  distancesIn )          
        colormap jet
        hc=colorbar;
        hc.FontSize = 18;
        %         title(hc,'mm', 'FontSize', 20);
        title( 'SDA_{T-A}', 'Fontsize', 20)
        C=caxis;
        axis equal
        hold on
    
    end 

 end 
   
    %------------------------------------------------------------------------------------%
    x = P(:,1);
    y = P(:,2);
    z =P(:,3);
    intensity = distances;
    C = unique(z) ; 
    dimensionx = dimension;
    dimensiony = dimension;
    dimensionz = dimension; 
    
    I = StructuredPointcloud2Image( intensity, dimensionx, dimensiony, dimensionz );
    

    



%%

DimEn = size(I);

for zi = 1:DimEn(3)
   
   set(gcf,'color','w');        
   currentI = I(:,:, zi);              
   imagesc(currentI)
   colorbar
   colormap jet
   title( join(['Image', num2str(zi) ]) )
   
   pause(.15)
   
    
end 
