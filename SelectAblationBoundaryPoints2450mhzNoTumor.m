

% %C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\
function [fileName ] = SelectAblationBoundaryPoints2450mhzNoTumor( ProbePosition, Patient)

switch ProbePosition
    
    case 1
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe A - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1AHealthy_NT.csv";
            
            case 'Low'
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe A - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1ALow_NT.csv";
            
            case 'Mild'
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe A - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1AMild_NT.csv";
            
            case 'Moderate'
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe A - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1AModerate_NT.csv";
            
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe A - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1AHigh_NT.csv";
        
        end
    case 2
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe B - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1BHealthy_NoTumor.csv";
                
            case 'Low'
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe B - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1BLow_NoTumor.csv";
                
            case 'Mild'
      
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe B - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1BMild_NoTumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe B - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1BModerate_NoTumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe B - NT\Results\Boundary Liver05_2450mhz_HomogTissue_Pos1BHighFat_NoTumor.csv";
                
        end 
                          
    case 3
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_Healthy_NT.csv";
                
            case 'Low'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_Low_NT.csv";
                
                
            case 'Mild'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_Mild_NT.csv";
            
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_Moderate_NT.csv";
            
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_High_NT.csv";
        
        end
       

    case 4
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_Healthy_NT.csv";
            
            case 'Low'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_Low_NT.csv";
            
            case 'Mild'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_Mild_NT.csv";
            
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_Moderate_NT.csv";
            
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - NT\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_High_NT.csv";
        
        end 
        
        
end



end 