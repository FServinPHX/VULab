

% %D:\Import To Matlab\
function [fileName ] = SelectAblationBoundaryPoints(  PatientNum )


dirName = "D:\Import To Matlab\Box Phantom\MultiprobeRefined\T_ThetaD_Electric Field\Results\" ;

Files= ["All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_UN_Refined_4.95mmSpace.csv";
        "All ArrPoints BoxPhantomMultiprobe_TrueBeef0Degrees_Refined_9.9mmSpc.csv";
        "All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_UN_Refined_14.95mmSpace.csv" ;
        "All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_UN_Refined_19.8mmSpace.csv" ;
        "All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined_24.75.csv" ;
        "All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined_29.7.csv" ;
        "All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined_34.65.csv";
        "All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined_39.6.csv";
        "All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined_44.55.csv";
        "All ArrPoints BoxGeomPhantomMultiprobe_TrueBeef0Degrees_Refined_54.45.csv" ;];





fileName = fullfile( [ convertStringsToChars(dirName), convertStringsToChars(Files(1)) ]) ;

end 

%'     D:\Import To Matlab\Probe A Twin Box    '