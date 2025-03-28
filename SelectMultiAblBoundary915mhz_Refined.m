
function [fileName ] = SelectMultiAblBoundary915mhz_Refined( ProbePosition, Angle)


switch ProbePosition
    
     case 1
        switch Angle 
            case '0'
                    fileName = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined.csv"; 
            case '5'                
                    fileName = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef5Degrees_Refined.csv";
            case '10'
                     fileName = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef10Degrees_Refined.csv";                
            case '15'                
                    fileName = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef15Degrees_Refined.csv";        
            case '20'        
                    fileName = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef20Degrees_Refined.csv";
            case '25'   
                    fileName = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef25Degrees_Refined.csv";                
        end 
end 




end 