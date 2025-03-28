

% %D:\Import To Matlab\
function [fileName ] = SelectAblationBoundaryDTwin2450Box( ProbePosition, Patient)

switch ProbePosition
    
    
    case 1
        switch Patient 
            case 'Healthy'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary 005_2450_mhz_HetTissue_Pos_A_Healthy_BoxLiver.csv" ;
            case 'Low'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary 005_2450_mhz_HetTissue_Pos_A_LowFat_BoxLiver.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary 005_2450_mhz_HetTissue_Pos_A_MildFat_BoxLiver.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary 005_2450_mhz_HetTissue_Pos_A_ModerateFat_BoxLiver.csv";
            case 'High'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary 005_2450_mhz_HetTissue_Pos_A_HighFat_BoxLiver.csv";
        end

        

               
end
end 

%'     D:\Import To Matlab\Probe A Twin Box    '