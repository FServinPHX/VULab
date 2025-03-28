

% %C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\
function [fileName ] = SelectAblationBoundaryPoints2450mhzV2( ProbePosition, Patient)

switch ProbePosition
    
    case 1
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_A -T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosA_Healthy_Tumor.csv";
                
            case 'Low'
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\_A -T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosA_Low_Tumor.csv";
                
            case 'Mild'
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\_A -T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosA_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\_A -T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosA_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_A -T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosA_High_Tumor.csv";
                
        end
    case 2
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_B - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosB_Healthy_Tumor.csv";
                
            case 'Low'
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\_B - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosB_Low_Tumor.csv";
                
            case 'Mild'
      
                fileName =  "D:\Import To Matlab\2.45 GHz\New Probe\_B - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosB_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_B - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosB_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_B - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosB_High_Tumor.csv";
                
        end 
                          
    case 3
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_C - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosC_Healthy_Tumor.csv";
                
            case 'Low'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_C - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosC_Low_Tumor.csv";
                
            case 'Mild'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_C - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosC_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_C - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosC_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_C - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosC_High_Tumor.csv";
                
        end
       

    case 4
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_D - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosD_Healthy_Tumor.csv";
                
            case 'Low'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_D - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosD_Low_Tumor.csv";
                
            case 'Mild'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_D - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosD_Mild_Tumor.csv";
                
            case 'Moderate'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_D - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosD_Moderate_Tumor.csv";
                
            case 'High'
                fileName = "D:\Import To Matlab\2.45 GHz\New Probe\_D - T\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosD_High_Tumor.csv";
                
        end 
        
        
end



end 