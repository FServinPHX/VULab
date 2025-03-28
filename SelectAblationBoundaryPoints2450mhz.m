

% %C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\
function [fileName ] = SelectAblationBoundaryPoints2450mhz( ProbePosition, Patient)

switch ProbePosition
    
    case 1
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe A - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosAHealthy_Tumor.csv";
                
            case 'Low'
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe A - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosAHigh_Tumor.csv";
                
            case 'Mild'
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe A - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosAMild_Tumor.csv";
                
            case 'Moderate'
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe A - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosAModerate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe A - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosAHigh_Tumor.csv";
                
        end
    case 2
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe B - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosB_Healthy_Tumor.csv";
                
            case 'Low'
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe B - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosB_Low_Tumor.csv";
                
            case 'Mild'
      
                fileName =  "D:\Import To Matlab\2.45 GHz\Probe B - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosB_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe B - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosB_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe B - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosB_Mild_Tumor.csv";
                
        end 
                          
    case 3
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_Healthy_Tumor.csv";
                
            case 'Low'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_Low_Tumor.csv";
                
                
            case 'Mild'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe C - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosC_High_Tumor.csv";
                
        end
       

    case 4
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_Healthy_Tumor.csv";
                
            case 'Low'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_LowFat_Tumor.csv";
                
            case 'Mild'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_MildFat_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_ModerateFat_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\Probe D - Tumor\Results\Boundary Liver05_2450mhz_HomogTissue_PosD_HighFat_Tumor.csv";
                
        end 
        
        
end



end 