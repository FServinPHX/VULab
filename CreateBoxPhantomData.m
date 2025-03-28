
%Task : 

%1 Create a box using 
clear

cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021'

%Establish Colors (From Vanderbilt)
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

colors = [ blue; orange; gold; purple];
colors2 = [rgb("RoyalBlue") ; rgb("DarkOrange") ; rgb("DarkGoldenrod") ; rgb("Indigo")];
colorsA = [gold; blue; green; red; orange; purple; black; cyan; magenta; yellow;  ...
    gold; blue; green; red; orange; purple; black];


%Create the Box Phantom Model
pVox.VoxSize = [100, 100, 100 ] ;
center = [0,0,0]- (pVox.VoxSize/2) ;
% center = [0,0,0];
%Choose where to start and end 
strt = [0, 0, 0];
endd = [0,0,0];


pVox.points = [0 0 0; 0 0 0];
pVox.Volxelx = [ center(1) +  pVox.VoxSize(1)*strt(1) :pVox.VoxSize(1): pVox.VoxSize(1)*endd(1)  +  center(1)  ] ;
pVox.Volxely = [ center(2) +  pVox.VoxSize(2)*strt(2) :pVox.VoxSize(2): pVox.VoxSize(2)*endd(2)  +  center(2)  ] ;
pVox.Volxelz = [ center(3) +  pVox.VoxSize(3)*strt(3) :pVox.VoxSize(3): pVox.VoxSize(3)*endd(3)  +  center(3)  ] ;

intensity.spc = 2;

[intensity.X,intensity.Y,intensity.Z] = meshgrid( pVox.Volxelx : intensity.spc : abs(pVox.Volxelx),...
    pVox.Volxely : intensity.spc :abs(pVox.Volxely), ...
    pVox.Volxelz : intensity.spc :abs(pVox.Volxelz) ) ;
intensity.X = reshape(intensity.X, [],1);
intensity.Y = reshape(intensity.Y, [],1);
intensity.Z = reshape(intensity.Z, [],1);


%%%2 Create a fat distribution 
intensity.a = 0;
intensity.b = 1;
intensity.I = (intensity.b-intensity.a).*rand(length(intensity.X),1) + intensity.a;


%Instert fat sphere

%Create the centers of the fat Spheres

Center.spc = 25;
[Center.x, Center.y, Center.z]  = meshgrid( pVox.Volxelx : Center.spc  : abs(pVox.Volxelx),...
    pVox.Volxely : Center.spc  :abs(pVox.Volxely), ...
    pVox.Volxelz : Center.spc  :abs(pVox.Volxelz) ) ;
Center.x = reshape(Center.x, [], 1);
Center.y = reshape(Center.y, [], 1);
Center.z = reshape(Center.z, [], 1);

%Create a fat sphere for every Center
VoxelDataOG = [intensity.X , intensity.Y , intensity.Z, intensity.I];

True_Center = [120,167,140] ;
Center_sp = [ -10,-10,-10; -10,-10,10; 10,-10,-10; 10,-10,10;...
              -10, 10,-10; 10, 10,-10; -10, 10,10; 10, 10,10;];
VoxelDataOG = VoxelDataOG  + [ (50+120-95/2), (50+176-95/2), (140-95/2+50), 0];


for cI = 1:length( Center_sp ) 

% center =  [Center.x(cI), Center.y(cI), Center.z(cI)] ;
center = True_Center + Center_sp(cI,:);
radiusSrt = 12;
fatBegin = 22;
fatEnd = 35;

[exportData] = addSphereofFat(VoxelDataOG , radiusSrt, center, fatBegin, fatEnd ) ;

VoxelDataOG = exportData; 

end 


%exportData = exportData + [ (50+120-95/2), (50+176-95/2), (140-95/2+50), 0];
%%
%Plot 3D Scatter of Raw Image Data
figure()
set(gcf,'color','w');

%add_vals = [ (50+120-95/2) , (50+176-95/2), (50+140-95/2)]; 
add_vals = [0, 0, 0];

%scatter3(PlotiNewText(:,2), PlotiNewText(:,3), PlotiNewText(:,4), .5 ,PlotiNewText(:,1)  )
sz = abs( exportData(:,4)/mean(exportData(:,4)) )*2 + 2; 
scatter3( exportData(:,1)  , exportData(:,2) ,  exportData(:,3) , sz  ,  exportData(:,4) , 'Filled' )
hold on
scatter3( Center.x + add_vals(1)  , Center.y + add_vals(2) , Center.z + add_vals(3) , 'r',  'Filled')
colormap('jet'); 
colorbar
title( join(["Hypothetical Hetergenous", newline, " Liver Phantom Fat Quant"]), 'Fontsize', 14)
xlabel("X")
ylabel("Y")
zlabel("Z")
hold off

figure()
set(gcf,'color','w');
histogram( exportData(:,4),10,'Normalization','pdf','BinWidth',1, ...
         'FaceAlpha', .5, 'EdgeAlpha', 1 )
       
xlim([0 45])
% ylim([0 .22])
title(join(["Sampled Fat Distrbution"]) ) 
xline(0, '-') %{'Low'}, 'LabelOrientation', 'horizontal')
xline(6,'-')  %{'Mild'},'LabelOrientation', 'horizontal')
xline(17,'-') %{'Moderate'},'LabelOrientation', 'horizontal')
xline(23,'-') %{'High'},'LabelOrientation',  'horizontal')
txt = ["Low","Mild","Moderate","High"];

text([0+6/2-1, 6+(17-6)/2-1,17,23+(35-23)/2-2], [.21,.21,.21,.21]+(.5-.22) ,txt)
hold off
%%

%transform  the fat distribution into a 
calculate_parameters = "T";
iNewText = exportData;
singlFatVal = "T";
writeParameters = "T";
patient = "22_35_SparseFatPercent"; 
fatPercent = 15;

if strcmp(calculate_parameters,"T") %calculate_parameters == "T"
%     intensityScale = [1,1,10,10];
    iVal = double( iNewText(:,4) );
    %%I_new__Cp = (1-(I_val/100))*3400+(I_val/100)*2348;
    %I_new__k_iso = (1-(I_val/100))*.52 +(I_val/100)*.21;
    iNewKIso = ( (.52-.21)*exp(-0.0547*iVal) + .21 ) ;
    %iNewKIso = ( (.47-.21)*exp(-0.0547*iVal) + .21 ) ;
    
    %iNewEr = (1-(iVal/100))*46.8+(iVal/100)*10.8;
    iNewEr = ( (46.8-11.3)*exp(-0.01144*iVal) + 11.3 ) ;
    %iNewEr = ( (36.2-11.3)*exp(-0.01144*iVal) + 11.3 ) ;
    
    %iNewEc = (1-(iVal/100))*.861+(iVal/100)*.11;
    iNewEc =  ( (.861-.11)*exp(-0.0116*iVal) + .11 ) ;
    %iNewEc =  ( (.68-.11)*exp(-0.0116*iVal) + .11 ) ;
    
    %ec = ( (.861-.11)*exp(-0.06859*fat_percent) + .11 ) ;

    
    %COMPEMSATE For the fact that blood perfusion overestimates for fat
    %concentration above 20;
    if fatPercent > 20
        %Create an entirely different perfussion parameter
        iValperf = zeros(length(iVal), 1);
            for qq = 1:length(iVal)
                if iVal(qq) == 0
                    iValperf(qq) = iVal(qq);
                else 
                    iValperf(qq) = iVal(qq)+ (fatPercent - 20)*1.6;
            end 



            end 
        
    else 
        iValperf = iVal;
    end
    %iNewPerf = ( (.025-.011)*exp(-0.040609*iVal) + .011 ) ;
     iNewPerf = ( (.018-.011)*exp(-0.040609*(iValperf)) + .011 ) ;    


    disp(' Created K_iso, E_r, E_c')

end

if strcmp(singlFatVal,"T")
    disp("  ")
    disp( join(["Fat_Percent ", num2str(fatPercent) ]) )
    disp( join(["K_iso", num2str( ( (.52-.21)*exp(-0.0546*fatPercent) + .21 )  )]) )
    disp( join(["Electrical Conductivity", num2str( ( (.861-.11)*exp(-0.0116*fatPercent) + .11 )  )]) )
    disp( join(["Permittivity", num2str( ( (46.8-11.3)*exp(-0.01144*fatPercent) + 11.3 )       ) ]) )   
    disp( join(["Perfusion", num2str( ( (.018-.011)*exp(-0.040609*(fatPercent)) + .011 )   ) ]) )
end 




%%Write Interpolated Data clouds for liver models (in this case Patient
%%001)
if strcmp(writeParameters,"T") %writeParameters == "T"
    %convert the patient choice to a string
    
%     if strcmp(singlFatVal,"T")
%         patient = patient_name;
%     else 
%         patient = num2str(patient);
%     end 
    
    
    cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\Fat_cloud_txt\Box_Phantom\'
    
    INewTextWrite  =[iNewText(:, 1:3), iNewKIso];
    thermCondName = join(['BoxPhantom', patient, '_thermal_conductivity.txt']);
    fileID = fopen(thermCondName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    %
    INewTextWrite  =[iNewText(: , 1:3), iNewEr];
    permittivityName = join(['BoxPhantom', patient, '_Permittivity.txt']);
    fileID = fopen(permittivityName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    %
    INewTextWrite  =[iNewText(:, 1:3), iNewEc];
    electCondName = join(['BoxPhantom', patient , '_Electrical Conductivity.txt']) ;
    fileID = fopen(electCondName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %5.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    
    
    
    INewTextWrite  =[iNewText(:, 1:3), iNewPerf];
    iNewPerfName = join(['BoxPhantom', patient, '_Blood_Perfusion.txt']);
    fileID = fopen(iNewPerfName,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
    
    
    
    INewTextWrite  =[iNewText(:, 1:3), iVal];
    fatIntensity = join(['BoxPhantom', patient, '_fat_intensity.txt']);
    fileID = fopen(fatIntensity,'w');
    %fprintf(fileID,'%6s %12s\n','x','exp(x)');
    fprintf(fileID,'%4.2f, %4.2f, %4.2f, %4.5f\n',INewTextWrite');
    fclose(fileID);
end

%%







