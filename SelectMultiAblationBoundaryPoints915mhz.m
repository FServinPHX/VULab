




function [fileName ] = SelectMultiAblationBoundaryPoints915mhz( ProbePosition, Angle)


switch ProbePosition
    
     case 1
        switch Angle 
            case '0'
                    fileName = "D:\Import To Matlab\Box Phantom\Multiprobe\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef0Degrees.csv"; 
            case '5'                
                    fileName = "D:\Import To Matlab\Box Phantom\Multiprobe\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef05Degrees.csv";
            case '10'
                     fileName = "D:\Import To Matlab\Box Phantom\Multiprobe\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef10Degrees.csv";                
            case '15'                
                    fileName = "D:\Import To Matlab\Box Phantom\Multiprobe\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef15Degrees.csv";        
            case '20'        
                    fileName = "D:\Import To Matlab\Box Phantom\Multiprobe\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef20Degrees.csv";
            case '25'   
                    fileName = "D:\Import To Matlab\Box Phantom\Multiprobe\Results\Boundary BoxGeomPhantomMultiprobe_TrueBeef25Degrees.csv";                
        end 
end 




end 