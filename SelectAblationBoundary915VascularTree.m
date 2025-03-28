

% %D:\Import To Matlab\
function [fileName ] = SelectAblationBoundary915VascularTree( ProbePosition, Patient)

switch ProbePosition
    
    
    case 1  %915 MHZ
        switch Patient 
            case 'Healthy'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_915_WTumor_A_HealthyFullVascularTree.csv" ;
            case 'Low'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_915_WTumor_A_HealthyFullVascularTree_Refined.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_915_WTumor_A_HealthyFullVascularTree_perf0152.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_915_WTumor_A_HealthyFullVascularTree_perf032.csv";
            case 'High'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_915_WTumor_A_HealthyFullVascularTree_BoxPhantom.csv";
        end

    case 2  %2450 MHZ
        switch Patient 
            case 'Healthy'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosB_Healthy_VascTree.csv" ;
            case 'Low'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosA_Healthy_Tumor_Refined.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_2450mhz_HetTisTum_PosA_Healthy_perf0152.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosA_Healthy_Tumor_perf032.csv";
            case 'High'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_2450mhz_NewPrb_HetTis_PosA_Healthy_Tumor_Box.csv";
        end 
        

    case 3
        switch Patient      %BOX Simulation
            case 'Healthy'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_915_WTumor_A_HealthyFullVascularTree_Box_perf0152.csv";
            case 'Low'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_915_WTumor_A_HealthyFullVascularTree_Box_perf032.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_2450mhz_Het_PosA_HealthyTum_Box_perf0152.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_2450mhz_Het_PosA_HealthyTum_Box_perf032.csv";
            case 'High'
                fileName = "D:\Import To Matlab\FullVascularTree\Results\Boundary Liver05_2450mhz_Het_PosA_HealthyTum_Box_perf032.csv"; 
        end 


end
end 

























