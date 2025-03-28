

% %C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL_DATA\ImageGuidedTherapy_4Placements\
function [fileName ] = SelectAblationBoundaryPointsNoTumor( ProbePosition, Patient)

switch ProbePosition
    
    case 1
        switch Patient 
            case 'Healthy'
                fileName = "D:\Import To Matlab\Probe A NT\Results\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_Pos2AHealthy_NoTumor.csv";
            case 'Low'
                fileName = "D:\Import To Matlab\Probe A NT\Results\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_Pos2ALow_NoTumor.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\Probe A NT\Results\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_Pos2AMild_NoTumor.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\Probe A NT\Results\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_Pos2AModerate_NoTumor.csv";
            case 'High'
                fileName = "D:\Import To Matlab\Probe A NT\Results\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_PosAHigh_NoTumor.csv";
        end
    case 2
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\Probe B NT\Results\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BHealthy_NoTumor.csv";
            case 'Low'
                fileName = "D:\Import To Matlab\Probe B NT\Results\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BLowFat_NoTumor.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\Probe B NT\Results\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BMildFat_NoTumor.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\Probe B NT\Results\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BModerate_NoTumor.csv";
            case 'High'
                fileName = "D:\Import To Matlab\Probe B NT\Results\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BHighFat_NoTumor.csv";
        end 
                          
    case 3
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\Probe C NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_Healthy_NoTumor.csv"; 
            case 'Low'
                fileName = "D:\Import To Matlab\Probe C NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_Low_NoTumor.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\Probe C NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_Mild_NoTumor.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\Probe C NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_Moderate_NoTumor.csv";
            case 'High'
                fileName = "D:\Import To Matlab\Probe C NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_High_NoTumor.csv";
        end
       

    case 4
        switch Patient 
            
            case 'Healthy'
                fileName = "D:\Import To Matlab\Probe D NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_Healthy_NoTumor.csv";
            case 'Low'
                fileName = "D:\Import To Matlab\Probe D NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_Low_NoTumor.csv";
            case 'Mild'
                fileName = "D:\Import To Matlab\Probe D NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_Mild_NoTumor.csv";
            case 'Moderate'
                fileName = "D:\Import To Matlab\Probe D NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_Moderate_NoTumor.csv";
            case 'High'
                fileName = "D:\Import To Matlab\Probe D NT\Results\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_High_NoTumor.csv";
        end 
        

               
end



end 



% 
% 
% switch ProbePosition
%     
%     case 1
%         switch Patient 
%             case 'Healthy'
%                 fileName = "D:\Import To Matlab\Probe A NT\Results\OlderData\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_Pos2AHealthy_NoTumor.csv";
%             case 'Low'
%                 fileName = "D:\Import To Matlab\Probe A NT\Results\OlderData\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_Pos2ALow_NoTumor.csv";
%             case 'Mild'
%                 fileName = "D:\Import To Matlab\Probe A NT\Results\OlderData\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_Pos2AMild_NoTumor.csv";
%             case 'Moderate'
%                 fileName = "D:\Import To Matlab\Probe A NT\Results\OlderData\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_Pos2AModerate_NoTumor.csv";
%             case 'High'
%                 fileName = "D:\Import To Matlab\Probe A NT\Results\OlderData\Boundary Liver05_915mhz_HomLiv_WTumor_TempDep_P_PosAHigh_NoTumor.csv";
%         end
%     case 2
%         switch Patient 
%             
%             case 'Healthy'
%                 fileName = "D:\Import To Matlab\Probe B NT\Results\OlderData\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BHealthy_NoTumor.csv";
%             case 'Low'
%                 fileName = "D:\Import To Matlab\Probe B NT\Results\OlderData\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BLowFat_NoTumor.csv";
%             case 'Mild'
%                 fileName = "D:\Import To Matlab\Probe B NT\Results\OlderData\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BMildFat_NoTumor.csv";
%             case 'Moderate'
%                 fileName = "D:\Import To Matlab\Probe B NT\Results\OlderData\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BModerate_NoTumor.csv";
%             case 'High'
%                 fileName = "D:\Import To Matlab\Probe B NT\Results\OlderData\Boundary Liver05_915mhz_HomogTissue_TempDep_Pos1BHighFat_NoTumor.csv";
%         end 
%                           
%     case 3
%         switch Patient 
%             
%             case 'Healthy'
%                 fileName = "D:\Import To Matlab\Probe C NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_Healthy_NoTumor.csv";
%             case 'Low'
%                 fileName = "D:\Import To Matlab\Probe C NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_Low_NoTumor.csv";
%             case 'Mild'
%                 fileName = "D:\Import To Matlab\Probe C NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_Mild_NoTumor.csv";
%             case 'Moderate'
%                 fileName = "D:\Import To Matlab\Probe C NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_Moderate_NoTumor.csv";
%             case 'High'
%                 fileName = "D:\Import To Matlab\Probe C NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos3c_High_NoTumor.csv";
%         end
%        
% 
%     case 4
%         switch Patient 
%             
%             case 'Healthy'
%                 fileName = "D:\Import To Matlab\Probe D NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_Healthy_NoTumor.csv";
%             case 'Low'
%                 fileName = "D:\Import To Matlab\Probe D NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_Low_NoTumor.csv";
%             case 'Mild'
%                 fileName = "D:\Import To Matlab\Probe D NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_Mild_NoTumor.csv";
%             case 'Moderate'
%                 fileName = "D:\Import To Matlab\Probe D NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_Moderate_NoTumor.csv";
%             case 'High'
%                 fileName = "D:\Import To Matlab\Probe D NT\Results\OlderData\Boundary Liver05_915mhzHomLivWTumorTempDepPos4D_High.csv";
%         end 
%         
% 
%                
% end