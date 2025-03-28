

% %D:\Import To Matlab\
function [fileName ] = SelectAblationBoundaryDTwin915Box( ProbePosition, Patient)

switch ProbePosition
    
    case 1
        switch Patient 
            case 'Healthy'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_HealthyBox.csv" ;
            case 'Low'
                fileName ="D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_LowBox.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_MildBox.csv";
            case 'Moderate'
                fileName ="D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_ModerateBox.csv";
            case 'High'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_HighBox.csv";
        end

     case 2
        switch Patient 
            case 'Healthy'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_HealthyBox_150.csv";
            case 'Low'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_HealthyBox_150.csv";
            case 'Mild'
                fileName =  "D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_MildBox.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_ModerateBox.csv"; 
            case 'High'
                fileName = "D:\Import To Matlab\Probe A Twin Box\Results\Boundary Liver05_915mhz_TempDep_Pos1A_HighFatBox_200.csv";
        end           
end
end 

%'     D:\Import To Matlab\Probe A Twin Box    '