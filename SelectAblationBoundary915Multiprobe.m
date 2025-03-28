% %D:\Import To Matlab\
function [fileName ] = SelectAblationBoundary915Multiprobe( ProbePosition, Patient)

switch ProbePosition
    
    
case 1  %915 MHZ
    switch Patient 
        case 'Healthy'
            fileName = join(['D:\Import To Matlab\Box Phantom\MultiprobeRefined\Patient 05 Multiprobe\'...
                        'Results\Boundary BoxGeomPhantomMultiprobe_AandD_Full VascTree.csv' ]) ;
        case 'Low'
            fileName = join(['D:\Import To Matlab\Box Phantom\MultiprobeRefined\Patient 05 Multiprobe\'...
                        'Results\Boundary BoxGeomPhantomMultiprobe_AandC_Full VascTree.csv']) ;
        case 'Mild'
            fileName = join(['D:\Import To Matlab\Box Phantom\MultiprobeRefined\Patient 05 Multiprobe\'...
                        'Results\Boundary BoxGeomPhantomMultiprobe_BandC_Full VascTree.csv']);
        case 'Moderate'
            fileName = join(['D:\Import To Matlab\Box Phantom\MultiprobeRefined\Patient 05 Multiprobe\'...
                        'Results\Boundary BoxGeomPhantomMultiprobe_BandD_Full VascTree.csv']);
        case 'High'
            fileName = join([]);
    end

case 2  %2450 MHZ
    switch Patient 
        case 'Healthy'
            fileName = [];
        case 'Low'
            fileName = [];
        case 'Mild'
            fileName = [];
        case 'Moderate'
            fileName = [];
        case 'High'
            fileName = [];
    end 


case 3
    switch Patient      %BOX Simulation
        case 'Healthy'
            fileName = [];
        case 'Low'
            fileName = [];
        case 'Mild'
            fileName = [];
        case 'Moderate'
            fileName = [];
        case 'High'
            fileName = []; 
    end 


end
end 










