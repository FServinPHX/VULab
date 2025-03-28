

% %C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\
function [fileName ] = SelectAblationBoundaryPts2450mhzNoTumorV2( ProbePosition, Patient )

switch ProbePosition
    
    
 case 1
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\A - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosA_Healthy_Tumor.csv";
                
            case 'Low'
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\A - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosA_Low_Tumor.csv";
                
            case 'Mild'
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\A - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosA_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\A - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosA_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\A - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosA_High_Tumor.csv";
                
        end
    case 2
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\B - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosB_Healthy_Tumor.csv";
                
            case 'Low'
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\B - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosB_Low_Tumor.csv";
                
            case 'Mild'
      
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\B - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosB_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\B - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosB_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\B - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosB_High_Tumor.csv";
                
        end 
                          
    case 3
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\C- NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosC_Healthy_Tumor.csv";
                
            case 'Low'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\C- NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosC_Low_Tumor.csv";
                
            case 'Mild'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\C- NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosC_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\C- NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosC_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\C- NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosC_High_Tumor.csv";
                
        end
       

    case 4
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\D - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosD_Healthy_Tumor.csv";
                
            case 'Low'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\D - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosD_Low_Tumor.csv";
                
            case 'Mild'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\D - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosD_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\D - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosD_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\D - NT\Results\Boundary Liver05_2450mhz_NewPrb_Homog_PosD_High_Tumor.csv";
                
        end   
        
end



end 