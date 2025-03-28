


model = ModelUtil.create('Model');

model.modelPath('D:\COMSOL Models\ML_Test');

model.label('ML_Test_Solve.mph');

model.comments(['Core cref 07292014\n\n']);


model.result.export('data1').set('expr', {'T' 'ht.theta_d' '' ''});
model.result.export('data1').set('unit', {'degC' '1' '' ''});
model.result.export('data1').set('descr', {'Temperature' 'Fraction of necrosed tissue' '' ''});
model.result.export('data1').set('filename', 'D:\Import To Matlab\Box Phantom\MultiprobeRefined\BoxGeomPhantomMultiprobe_TrueBeef5Degrees_UN_Refined.csv');
model.result.export('data1').set('smooth', 'internal');
model.result.export('data1').set('separator', ',');
% model.result.export('data2').set('data', 'cpl4');
% model.result.export('data2').set('expr', {'emw.Qh'});
% model.result.export('data2').set('unit', {'W/m^3'});
% model.result.export('data2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Temps\004__Power_Dissipation_surface_915_MHZ.csv');
% model.result.export('data2').set('smooth', 'internal');
% model.result.export('data2').set('separator', ',');
% model.result.export('data2').set('descr', {'Temperature'});


model.result.export('data1').run
end 