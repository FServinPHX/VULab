


clear
clc


StartingPlacement = readtable("D:\Import To Matlab\Aim 3_ProbePlacements\Matlab_ML_COMSOL_Placement.csv");
InportData = table2array(StartingPlacement);
params = InportData(1,:);


for i = 1:1

    Theta1 = num2str((params(1)));
    Psi1   = num2str((params(2)));
    X_Tip1 = num2str((params(3)));
    Y_Tip1 = num2str((params(4)));
    Z_Tip1 = num2str((params(5)));
    Theta2 = num2str((params(6)));
    Psi2   = num2str((params(7)));
    X_Tip2 = num2str((params(8)));
    Y_Tip2 = num2str((params(9)));
    Z_Tip2 = num2str((params(10)));
    
    
    
    
    % Call simplex minimization
    [Model] = ML_InputProbe_Test(params);
    
    ModelName = join([ "Experiment ", num2str(i) ,"Theta1 ", Theta1, "   Psi1", Psi1,...
                        "Theta2 ", Theta2, "   Psi2", Psi2]);

end 

