


function [xtname, Ytname, yPred_Name, pVoxVoxSize, QuerryPointsOG_Import,  chunk_size, maskTypeNum, VideoName, export_DIR] =  Aim3MachineLearningCaseSelection(CaseSelect)




switch CaseSelect
    case 1
        xtname =  "D:\Import To Matlab\01. Machine Learning Models Data\1 ___X_test_Data_  Binary   Mask   Distances.csv";
        Ytname =  "D:\Import To Matlab\01. Machine Learning Models Data\1___y_test_Data_  Binary   Mask   Distances.csv";
        yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\1___all_predictions_Binary_Mask_  Distances.csv";
        %yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\all_predictions_Binary_Mask_  Distances II.csv";
        pVoxVoxSize = [80, 80, 80 ] ;
        chunk_size = 68921;
        maskTypeNum = 1; 
        VideoName = "Distances";
        export_DIR = "TRUE"   ;
        
    case 2
        xtname =  "D:\Import To Matlab\01. Machine Learning Models Data\2___X_test_Data_  Binary   Mask    I.csv";
        Ytname =  "D:\Import To Matlab\01. Machine Learning Models Data\2___y_test_Data_  Binary   Mask    I.csv";
        yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\2___all_predictions_  Binary  Mask   I.csv" ;
        pVoxVoxSize = [80, 80, 80 ] ;
        chunk_size = 68921;
        maskTypeNum = 2; 
        VideoName = "Binary  Mask   I";
        export_DIR = "TRUE"   ;
    case 3
        xtname = "D:\Import To Matlab\01. Machine Learning Models Data\3___X_test_Data_ Binary Mask _ Distances  __ptII.csv";
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\3___y_test_Data_ Binary Mask _ Distances  __ptII.csv";
        yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\3___all_predictions_   Binary Mask _ Distances  __ptII.csv"  ;
        chunk_size = 132651;
        pVoxVoxSize = [100, 100, 100 ] ;
        maskTypeNum = 1; 
        VideoName = "Distances  __ptII";
        export_DIR = "TRUE"   ;

    case 4
        % SCALED DATA
        xtname = "D:\Import To Matlab\01. Machine Learning Models Data\6___X_Test  Binary Mask_Distances Transformer_I.csv" ;
        Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\6___y_Test  Binary Mask_Distances Transformer_I.csv" ;
        yPred_Name = "D:\Import To Matlab\01. Machine Learning Models Data\6___all_predictions__  Binary Mask_Distances Transformer_I.csv";
        
        pVoxVoxSize = [100, 100, 100 ] ;
        maskTypeNum = 1; 
        VideoName = "Binary Mask_Distances Transformer_I";
        export_DIR = "FALSE"   ;

        PointsFile = readmatrix( "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances__Early\Early_Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ); 
        QuerryPointsOG_Import = PointsFile(:,1:3);
        chunk_size = length(QuerryPointsOG_Import);


    case 5
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\7___X_Test  Binary Mask _ Distances  __ptII Transformer_I.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\7___y_Test  Binary Mask _ Distances  __ptII Transformer_I.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\7___all_predictions__  Binary Mask _ Distances  __ptII Transformer_I.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName = "Binary Mask _ Distances  __ptII Transformer_I";
         export_DIR = "FALSE"   ;           

        %PointsFile = readmatrix( "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances__Early\Early_Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ); 
        %QuerryPointsOG_Import = PointsFile(:,1:3);
        %chunk_size = length(QuerryPointsOG_Import);

    case 6
         % Scrambled  DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\8___X_Test  Binary Mask _ Distances Mid to Late Ablation Structured Grid _ Transformer.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\8___y_Test  Binary Mask _ Distances Mid to Late Ablation Structured Grid _ Transformer.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\8___all_predictions__  Binary Mask _ Distances Mid to Late Ablation Structured Grid _ Transformer.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName = " Distances __MID__ Ablation Structured Grid ";
         export_DIR = "FALSE"   ;      

         PointsFile = readmatrix( "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances__Early\Early_Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ); 
         QuerryPointsOG_Import = PointsFile(:,1:3);
         chunk_size = length(QuerryPointsOG_Import);

    case 7
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\8___X_Test  Binary Mask _ Distances Mid to Late Ablation Structured Grid _ Transformer.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\8___y_Test  Binary Mask _ Distances Mid to Late Ablation Structured Grid _ Transformer.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\8___all_predictions__Binary Mask _ Distances Mid to Late Ablation Structured Grid  _10 epochs_ Transformer.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName = " Distances __MID__ Ablation Structured Grid ";
         export_DIR = "FALSE"   ;    

         PointsFile = readmatrix( "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances__Early\Early_Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ); 
         QuerryPointsOG_Import = PointsFile(:,1:3);
         chunk_size = length(QuerryPointsOG_Import);

     case 8
         % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\9___X_Test  Binary Mask _ Distances Early to Mid Ablation Structured Grid _ Transformer.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\9___y_Test  Binary Mask _ Distances Early to Mid Ablation Structured Grid _ Transformer.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\9___all_predictions__Binary Mask _ Distances Early to Mid Ablation Structured Grid _10 epochs_ Transformer.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName = "Distances __EARLY__ Ablation Structured Grid _10 epochs";
         export_DIR = "FALSE"   ;   


         PointsFile = readmatrix( "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances__Early\Early_Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ); 
         QuerryPointsOG_Import = PointsFile(:,1:3);
         chunk_size = length(QuerryPointsOG_Import);

     case 9
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\10___X_Test  Binary Mask _ Electric Field Early to Mid Ablation Structured Grid _ Transformer.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\10__y_Test  Binary Mask _ Electric Field to Mid Ablation Structured Grid _ Transformer.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\10___all_predictions__Binary Mask _ Electric Field to Mid Ablation Structured Grid _2 epochs_ Transformer.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 3; 
         VideoName = "Electric Field __EARLY__ Ablation Structured Grid _ Transformer";
         export_DIR = "FALSE"   ;   


         PointsFile = readmatrix("D:\Import To Matlab\COMSOL__Structured Grid__Electric_Field__Early\Early_Electric Field Mask_Experiment  2   __Theta1  0.1    Psi1  -108     __Theta2  22.5    Psi2  -173.6.csv"); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 100000; 

    case 10
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\13___X_Test  Arrhenius___ MID Ablation Structured Grid _ Transformer__TRUE.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\13___y_Test  Arrhenius___ MID Ablation Structured Grid _ Transformer__TRUE.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\10___all_predictions__Binary Mask _ Electric Field to Mid Ablation Structured Grid _2 epochs_ Transformer.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 3; 
         VideoName = "Electric Field __MID__ Ablation Structured Grid _2 epochs_ Transformer";
         export_DIR = "FALSE"   ;   

         PointsFile = readmatrix("D:\Import To Matlab\COMSOL__Structured Grid__Electric_Field__Early\Early_Electric Field Mask_Experiment  2   __Theta1  0.1    Psi1  -108     __Theta2  22.5    Psi2  -173.6.csv"); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 100000; 


     case 11
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\14___X_Test  Distances__EARLY Ablation Structured Grid _ Transformer__TRUE.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\14___y_Test  Distances__EARLY Ablation Structured Grid _ Transformer__TRUE.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\14__  all_predictions_Arrhenius EARLY Binary Mask _ Distances _ 6 epochs_ Transformer  TRUE.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName = "Arrhenius EARLY Binary Mask _ Distances _ 6 epochs_ Transformer  TRUE ";
         export_DIR = "FALSE"   ;   


         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances__Early\Early_Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ;
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         %scaleData = 1; 

     case 12
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\15___X_Test  Distances__MID Ablation Structured Grid _ Transformer__TRUE.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\15___y_Test  Distances__MID Ablation Structured Grid _ Transformer__TRUE.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\15__  all_predictions_Arrhenius MID Binary Mask _ Distances _ 6 epochs_ Transformer  TRUE.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName = "Arrhenius MID Binary Mask _ Distances _ 6 epochs_ Transformer  TRUE";
         export_DIR = "FALSE"   ;   


         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances___Mid\Mid_Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv"   ;
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         %scaleData = 1;


      case 13
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\16___X_Test  Distances__LATE Ablation Structured Grid _ Transformer__TRUE.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\16___y_Test  Distances__LATE Ablation Structured Grid _ Transformer__TRUE.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\16__  all_predictions_Arrhenius LATE Binary Mask _ Distances _ 6 epochs_ Transformer  TRUE.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName = "Arrhenius LATE Binary Mask _ Distances _ 6 epochs_ Transformer  TRUE ";
         export_DIR = "FALSE"   ;   


         PointsFileName =  "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances___Late\Late_Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ;
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         %scaleData = 1;       


      case 14
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\17___X_Test  Electric Field__ EARLY  1_100000 _ Transformer__TRUE.csv";
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\17___y_Test  Electric Field__ EARLY  1_100000 _ Transformer__TRUE.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\17__  all_predictions_Electric Field__ EARLY  1_100000 _ Transformer__TRUE.csv";
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 3; 
         VideoName = "Electric Field__ EARLY  1_100000 _ Transformer__TRUE";
         export_DIR = "FALSE"   ;   

         
         PointsFileName = "D:\Import To Matlab\COMSOL__Structured Grid__Electric_Field__Early\Early_Electric Field Mask_Experiment  2   __Theta1  0.1    Psi1  -108     __Theta2  22.5    Psi2  -173.6.csv";
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 100000;        

    case 15
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\19___X_Test COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances Transformer__TORCH.csv" ;
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\19___y_Test COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances Transformer__TORCH.csv" ;
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\19-All Predictions_model Pytorch Distances_2 EPOCH  .csv" ;
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'Distances_model Pytorch Distances_2 EPOCH';
         export_DIR = "FALSE"   ;   

         
         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances\Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ;
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;      



     case 16
        % Scrambled DATA
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\19___X_Test COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances Transformer__TORCH.csv" ;
         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\18___y_Test COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances Transformer__TORCH.csv" ;
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\18-All Predictions_model Pytorch Distances_10 EPOCH  .csv" ;
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'Distances_model Pytorch Distances_10 EPOCH';
         export_DIR = "FALSE"   ;   

         
         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances\Distance Mask_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv" ;
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;   



     case 17

         xtname =  "D:\Import To Matlab\01. Machine Learning Models Data\20___X_Test COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII Transformer__TORCH.csv"
         Ytname =  "D:\Import To Matlab\01. Machine Learning Models Data\20___y_Test COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\20-All Predictions_model Pytorch Distances_2 EPOCH  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'MKII Distances_model Pytorch Distances_2 EPOCH';
         export_DIR = "FALSE"   ;   

         
         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1\0degree_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;   



     case 18

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\21___y_Test COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\21___X_Test COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\21-All Predictions_model Pytorch Distances_10 EPOCH  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'MKII Distances_model Pytorch Distances_10 EPOCH';
         export_DIR = "FALSE"   ;   

         
         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1\0degree_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;   


         %STAR
     case 19

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\22___y_Test group_1 Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\22___X_Test group_1 Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\22-All Predictions_model Pytorch Distances_10 EPOCH__Part2  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'MKII Distances_model Pytorch Distances_10 EPOCH__ Part II';
         export_DIR = "FALSE"   ;   

         
         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1\0degree_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;   


     case 20

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\25___y_Test_EARLY group_1__Early Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\25___X_Test_EARLY group_1__Early Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\25-All Predictions_model Pytorch SDA_Distances_EARLY_20 EPOCH__Part2  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'MKII Distances_model Pytorch Distances_Early_20 EPOCH__ Part II';
         export_DIR = "FALSE"   ;   

         
         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1__Early\Early_0degree_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;     

       case 21

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\26___y_Test_EARLY group_1___Late Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\26___X_Test_EARLY group_1___Late Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\26-All Predictions_model Pytorch SDA_Distances_Late_18 EPOCH__Part2  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'MKII Distances_model Pytorch Distances_Late_18 EPOCH__ Part II_2';
         export_DIR = "FALSE"   ;   

         
         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Late\Late_0degree_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;        


       case 22

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\27___y_Test_EARLY group_1___Mid Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\27___X_Test_EARLY group_1___Mid Transformer__TORCH.csv";
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\27-All Predictions_model Pytorch SDA_Distances_Middle_23 EPOCH__Part2  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'MKII Distances_model Pytorch Distances_MIDDLE_23 EPOCH__ Part II_2';
         export_DIR = "FALSE"   ;   

         
         PointsFileName ="D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  


       case 23

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\29___y_Test_EARLY group_2___1Minute Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\29___X_Test_EARLY group_2___1Minute Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\29-All Predictions_model Pytorch SDA_Distances_1 min_20 EPOCH__Part3  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'All Predictions_model Pytorch SDA_Distances_1 min_20 EPOCH__Part3  ';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  



       case 24

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\30___y_Test_EARLY group_2___3Minute Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\30___X_Test_EARLY group_2___3Minute Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\30All Predictions_model Pytorch SDA_Distances__3min_model_epoch_13  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  '30All Predictions_model Pytorch SDA_Distances__3min_model_epoch_13  ';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  



       case 25

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\31___y_Test_EARLY group_2___5Minute Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\31___X_Test_EARLY group_2___5Minute Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\31All Predictions_model Pytorch SDA_Distances__5min_model_epoch_19  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  '31All Predictions_model Pytorch SDA_Distances__5min_model_epoch_19  ';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  



       case 26

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\32___y_Test_EARLY group_2___7Minute Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\32___X_Test_EARLY group_2___7Minute Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\32All Predictions_model Pytorch SDA_Distances__7Minute model_epoch_20  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  '32All Predictions_model Pytorch SDA_Distances__7Minute model_epoch_20  ';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  




       case 27

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\33___y_Test_EARLY group_2___10Minute Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\33___X_Test_EARLY group_2___10Minute Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\33All Predictions_model Pytorch SDA_Distances_PT_II_10minute_model_epoch_20  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  '33All Predictions_model Pytorch SDA_Distances_PT_II_10minute_model_epoch_20  ';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  


       case 28

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\34___y_Test_EARLY group_2___12Minute Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\34___X_Test_EARLY group_2___12Minute Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\34All Predictions_model Pytorch SDA_Distances_PT_II_12minute_model_epoch_8  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  'MKII Distances_model Pytorch Distances_MIDDLE_23 EPOCH__ Part II_2';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  



       case 29

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\35___X_Test_EARLY group_2___12Minute Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\35___y_Test_EARLY group_2___12Minute Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\35All Predictions_model Pytorch SDA_Distances_PT_II_15minute_model_epoch_20  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  '35All Predictions_model Pytorch SDA_Distances_PT_II_15minute_model_epoch_20  ';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  


       case 30

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\36___y_Test_EARLY group_1 resampled All Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\36___X_Test_EARLY group_1 resampled All Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\36All Predictions_model Pytorch SDA_Distances_PT Three_(PT II Resampled)_model_epoch_12  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  '35All Predictions_model Pytorch SDA_Distances_PT_II_15minute_model_epoch_20  ';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  



       case 31

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\37___y_Test_EARLY group_1 resampled All Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\37___X_Test_EARLY group_1 resampled All Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\37All Predictions_model Pytorch SDA_Distances_PT Three (Actual Part Three)_model_epoch_20  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  '37All Predictions_model Pytorch SDA_Distances_PT Three (Actual Part Three)_model_epoch_20';
         export_DIR = "FALSE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptII\group_1___Mid\Middle_Points.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  




       case 32

         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\38___y_Test_EARLY group_1 resampled All Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\38___X_Test_EARLY group_1 resampled All Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\38All Predictions_model Pytorch SDA_Distances_PT Four (Actual Part Four)_model_epoch_8  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
         VideoName =  '38All Predictions_model Pytorch SDA_Distances_PT Four (Actual Part Four)_model_epoch_8';
         export_DIR = "TRUE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIV\0degree_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  


       case 33



         Ytname = "D:\Import To Matlab\01. Machine Learning Models Data\39___y_Test_EARLY group_1 resampled All Transformer__TORCH.csv"
         xtname = "D:\Import To Matlab\01. Machine Learning Models Data\39___X_Test_EARLY group_1 resampled All Transformer__TORCH.csv"
         yPred_Name =  "D:\Import To Matlab\01. Machine Learning Models Data\39All Predictions_model Pytorch SDA_Distances_PT Four (Actual Part Four)_model_epoch_19  .csv"
         chunk_size = 132651;
         pVoxVoxSize = [100, 100, 100 ] ;
         maskTypeNum = 1; 
        % Extract the last part of the split path
        % Use fileparts to extract the base filename and discard the extension
        [~, VideoName, ~] = fileparts(yPred_Name);
        VideoName = char(VideoName)
        %
        export_DIR = "TRUE"   ;   

         PointsFileName = "D:\Import To Matlab\COMSOL Pointcloud ML_ALL Data   Binary Mask _ Distances  __ptIV\0degree_All ArrPoints Experiment  1   __Theta1  0.1    Psi1  -144     __Theta2  22.5    Psi2  -173.6    All.csv"
         PointsFile = readmatrix(PointsFileName); 
         QuerryPointsOG_Import = PointsFile(:,1:3);     
         chunk_size = length(QuerryPointsOG_Import);

         scaleData = 1;  



end 


end 
