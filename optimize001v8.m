function error = optimize001v8(params)
%% Setup parameters
% tissue properties
s1a = num2str(abs(params(1)));
s1b = num2str(abs(params(2)));
e1a = num2str(abs(params(3)) + 1e-4);
e1b = num2str(abs(params(4)) + 1e-4);
c1a = num2str(abs(params(5)) + 1e-4);
c1b = num2str(abs(params(6)) + 1e-4);
c1c = num2str(abs(params(7)) + 1e-4);
k1a = num2str(abs(params(8)));
k1b = num2str(abs(params(9)));

% catheter properties
s2 = num2str(abs(params(10)));
e2 = num2str(abs(params(11)) + 1e-4);
c2 = num2str(abs(params(12)) + 1e-4);
k2 = num2str(abs(params(13)));

% cooling properties
htcoef = num2str(abs(params(14)));

if params(15) <= 270
    params(15) = 270;
elseif params(15) >= 315
    params(15) = 315;
end

Tprobe = num2str(abs(params(15)));

% thermal boundary
if params(16) <= 270
    params(16) = 270;
elseif params(16) >= 315
    params(16) = 315;
end

Tboundary = num2str(abs(params(16)));

%% mph Model Housekeeping
% Parameterization_2D_v8.m
%
% Model exported on Feb 9 2018, 13:41 by COMSOL 4.4.0.150.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\Jarrod\Google Drive\Work\MWA Deformation Phantom\Testingv8');

model.name('Parameterization_2D_v8.mph');

model.param.set('eps_diel', '2.03', 'Relative permittivity, dielectric');
model.param.set('eps_cat', '2.6', 'Relative permittivity, catheter');
model.param.set('f', '915[MHz]', 'Microwave frequency');
model.param.set('P_in', '60[W]', 'Input microwave power');
model.param.set('T_init', '300[K]', 'temperature, initial');
model.param.set('T_necro', '353[K]', 'temperature, necrosis');
model.param.set('time_step', '15 [s]', 'time, step');
model.param.set('time_end', '900[s]', 'time, end');

% establish geometry
model.param.set('w_tissue', '48', 'diameter, tissue');
model.param.set('h_tissue', '21.5', 'height minus probe depth, tissue');
model.param.set('d_probe', '54.5', 'depth, probe');


model.param.set('ATest', '1.88e41');
model.param.set('EATest', '2.8e5');

% probe cooling
model.param.set('htcoef', htcoef);
model.param.set('Tprobe', Tprobe);

% catheter properties
model.param.set('K2', k2);
model.param.set('S2', s2);
model.param.set('E2', e2);
model.param.set('C2', c2);

% tissue properties
model.param.set('C1a', c1a);
model.param.set('C1b', c1b);
model.param.set('C1c', c1c);
model.param.set('Ka', k1a);
model.param.set('Kb', k1b);
model.param.set('Sa', s1a);
model.param.set('Sb', s1b);
model.param.set('Ea', e1a);
model.param.set('Eb', e1b);

% boundary conditions
model.param.set('Tboundary', Tboundary);

model.modelNode.create('comp1');

model.geom.create('geom1', 2);
model.geom('geom1').axisymmetric(true);
model.geom('geom1').lengthUnit('mm');
model.geom('geom1').feature.create('pol1', 'Polygon');
model.geom('geom1').feature.create('pol2', 'Polygon');
model.geom('geom1').feature.create('pol3', 'Polygon');
model.geom('geom1').feature.create('pol4', 'Polygon');
model.geom('geom1').feature.create('pol5', 'Polygon');
model.geom('geom1').feature.create('pol6', 'Polygon');
model.geom('geom1').feature('pol1').name('Tissue');
model.geom('geom1').feature('pol1').set('x', '0,0,w_tissue, w_tissue, 0.895, 0.895');
model.geom('geom1').feature('pol1').set('y', '-1.785,-h_tissue, -h_tissue, d_probe, d_probe, 0');
model.geom('geom1').feature('pol2').name('Catheter Bottom');
model.geom('geom1').feature('pol2').set('x', '0,0,0.895,0.895,0.595,0.595');
model.geom('geom1').feature('pol2').set('y', '0.4,-1.785,0,8,8,0.4');
model.geom('geom1').feature('pol3').name('Dielectric');
model.geom('geom1').feature('pol3').set('x', '0.145,0.145,0.47,0.47');
model.geom('geom1').feature('pol3').set('y', 'd_probe,0.525,0.525,d_probe');
model.geom('geom1').feature('pol4').name('Air');
model.geom('geom1').feature('pol4').set('x', '0.47,0.47,0.595,0.595');
model.geom('geom1').feature('pol4').set('y', '10,8,8,10');
model.geom('geom1').feature('pol5').name('Catheter Top');
model.geom('geom1').feature('pol5').set('x', '0.895,0.895,0.595,0.595');
model.geom('geom1').feature('pol5').set('y', 'd_probe, 10,10, d_probe');
model.geom('geom1').feature('pol6').name('Catheter Window');
model.geom('geom1').feature('pol6').set('x', '0.895,0.895,0.595,0.595');
model.geom('geom1').feature('pol6').set('y', '10, 8, 8, 10');
model.geom('geom1').run;

model.view.create('view2', 3);
model.view.create('view3', 3);
model.view.create('view4', 3);

model.material.create('mat1');
model.material('mat1').propertyGroup('def').func.create('pw1', 'Piecewise');
model.material('mat1').propertyGroup('def').func.create('pw2', 'Piecewise');
model.material('mat1').propertyGroup('def').func.create('pw3', 'Piecewise');
model.material('mat1').propertyGroup('def').func.create('pw4', 'Piecewise');
model.material('mat1').selection.set([1]);
model.material.create('mat2');
model.material('mat2').selection.set([2 5 6]);
model.material.create('mat3');
model.material('mat3').selection.set([3]);
model.material.create('mat4');
model.material('mat4').propertyGroup('def').func.create('eta', 'Piecewise');
model.material('mat4').propertyGroup('def').func.create('Cp', 'Piecewise');
model.material('mat4').propertyGroup('def').func.create('rho', 'Analytic');
model.material('mat4').propertyGroup('def').func.create('k', 'Piecewise');
model.material('mat4').propertyGroup('def').func.create('cs', 'Analytic');
model.material('mat4').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.material('mat4').selection.set([4]);

model.physics.create('emw', 'ElectromagneticWaves', 'geom1');
model.physics('emw').selection.set([1 3 4 5]);
model.physics('emw').feature.create('port1', 'Port', 1);
model.physics('emw').feature('port1').selection.set([8]);
model.physics('emw').feature.create('sctr1', 'Scattering', 1);
model.physics('emw').feature('sctr1').selection.set([2 16 18 23 24]);
model.physics.create('ht', 'BioHeat', 'geom1');
model.physics('ht').selection.set([1 2 5 6]);
model.physics('ht').feature.create('chf1', 'ConvectiveHeatFlux', 1);
model.physics('ht').feature('chf1').selection.set([5 14 15 17]);
model.physics('ht').feature.create('temp1', 'TemperatureBoundary', 1);
model.physics('ht').feature('temp1').selection.set([2 23 24]);

model.multiphysics.create('emh1', 'ElectromagneticHeatSource', 'geom1', 2);
model.multiphysics('emh1').selection.all;

model.mesh.create('mesh1', 'geom1');
model.mesh('mesh1').feature.create('ftri1', 'FreeTri');
model.mesh('mesh1').feature('ftri1').feature.create('size1', 'Size');
model.mesh('mesh1').feature('ftri1').feature.create('size2', 'Size');
model.mesh('mesh1').feature('ftri1').feature('size1').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ftri1').feature('size1').selection.set([2 3 4 5 6]);
model.mesh('mesh1').feature('ftri1').feature('size2').selection.geom('geom1', 2);
model.mesh('mesh1').feature('ftri1').feature('size2').selection.set([1]);

model.view('view1').axis.set('xmin', '-9.810916900634766');
model.view('view1').axis.set('ymin', '-16.627044677734375');
model.view('view1').axis.set('xmax', '79.43838500976562');
model.view('view1').axis.set('ymax', '42.980674743652344');
model.view('view3').set('scenelight', 'off');

model.material('mat1').name('Liver');
model.material('mat1').propertyGroup('def').func('pw1').set('pieces', {'0' '0.95' 'C1a'; '0.95' '0.98' 'C1b'; '0.98' '2' 'C1c'});
model.material('mat1').propertyGroup('def').func('pw1').set('argunit', 'comp1.ht.theta_d');
model.material('mat1').propertyGroup('def').func('pw1').set('fununit', 'J/(kg*K)');
model.material('mat1').propertyGroup('def').func('pw1').set('smoothzone', '0.015');
model.material('mat1').propertyGroup('def').func('pw1').set('smooth', 'cont');
model.material('mat1').propertyGroup('def').func('pw1').set('funcname', 'C_test');
model.material('mat1').propertyGroup('def').func('pw1').set('arg', 'comp1.ht.theta_d');
model.material('mat1').propertyGroup('def').func('pw2').set('pieces', {'0' '1' 'Ka'; '1' '1000' 'Kb'});
model.material('mat1').propertyGroup('def').func('pw2').set('argunit', 'comp1.ht.theta_d');
model.material('mat1').propertyGroup('def').func('pw2').set('fununit', 'W/(m*K)');
model.material('mat1').propertyGroup('def').func('pw2').set('smoothzone', '.01');
model.material('mat1').propertyGroup('def').func('pw2').set('smooth', 'cont');
model.material('mat1').propertyGroup('def').func('pw2').set('funcname', 'k_test');
model.material('mat1').propertyGroup('def').func('pw2').set('arg', 'comp1.ht.theta_d');
model.material('mat1').propertyGroup('def').func('pw3').set('pieces', {'0' '1' 'Ea'; '1' '1000' 'Eb'});
model.material('mat1').propertyGroup('def').func('pw3').set('argunit', 'comp1.ht.theta_d');
model.material('mat1').propertyGroup('def').func('pw3').set('fununit', '1');
model.material('mat1').propertyGroup('def').func('pw3').set('smoothzone', '.01');
model.material('mat1').propertyGroup('def').func('pw3').set('smooth', 'cont');
model.material('mat1').propertyGroup('def').func('pw3').set('funcname', 'e_test');
model.material('mat1').propertyGroup('def').func('pw3').set('arg', 'comp1.ht.theta_d');
model.material('mat1').propertyGroup('def').func('pw4').set('pieces', {'0' '1' 'Sa'; '1' '1000' 'Sb'});
model.material('mat1').propertyGroup('def').func('pw4').set('argunit', 'comp1.ht.theta_d');
model.material('mat1').propertyGroup('def').func('pw4').set('fununit', 'S/m');
model.material('mat1').propertyGroup('def').func('pw4').set('smoothzone', '.01');
model.material('mat1').propertyGroup('def').func('pw4').set('smooth', 'cont');
model.material('mat1').propertyGroup('def').func('pw4').set('funcname', 's_test');
model.material('mat1').propertyGroup('def').func('pw4').set('arg', 'comp1.ht.theta_d');
model.material('mat1').propertyGroup('def').set('heatcapacity', 'C_test(comp1.ht.theta_d)');
model.material('mat1').propertyGroup('def').set('density', '1079[kg/m^3]');
model.material('mat1').propertyGroup('def').set('thermalconductivity', {'k_test(comp1.ht.theta_d)' '0' '0' '0' 'k_test(comp1.ht.theta_d)' '0' '0' '0' 'k_test(comp1.ht.theta_d)'});
model.material('mat1').propertyGroup('def').set('a', 'ATest');
model.material('mat1').propertyGroup('def').set('deltae', 'EATest');
model.material('mat1').propertyGroup('def').set('relpermittivity', {'e_test(comp1.ht.theta_d)' '0' '0' '0' 'e_test(comp1.ht.theta_d)' '0' '0' '0' 'e_test(comp1.ht.theta_d)'});
model.material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat1').propertyGroup('def').set('electricconductivity', {'s_test(comp1.ht.theta_d)' '0' '0' '0' 's_test(comp1.ht.theta_d)' '0' '0' '0' 's_test(comp1.ht.theta_d)'});
model.material('mat2').name('Catheter');
model.material('mat2').propertyGroup('def').set('relpermittivity', {'E2' '0' '0' '0' 'E2' '0' '0' '0' 'E2'});
model.material('mat2').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat2').propertyGroup('def').set('electricconductivity', {'S2' '0' '0' '0' 'S2' '0' '0' '0' 'S2'});
model.material('mat2').propertyGroup('def').set('heatcapacity', 'C2');
model.material('mat2').propertyGroup('def').set('density', '1079[kg/m^3]');
model.material('mat2').propertyGroup('def').set('a', 'ATest');
model.material('mat2').propertyGroup('def').set('deltae', '1e20');
model.material('mat2').propertyGroup('def').set('thermalconductivity', {'K2' '0' '0' '0' 'K2' '0' '0' '0' 'K2'});
model.material('mat3').name('Dielectric');
model.material('mat3').propertyGroup('def').set('relpermittivity', {'eps_diel' '0' '0' '0' 'eps_diel' '0' '0' '0' 'eps_diel'});
model.material('mat3').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat3').propertyGroup('def').set('electricconductivity', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.material('mat4').name('Air');
model.material('mat4').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.material('mat4').propertyGroup('def').func('eta').set('arg', 'T');
model.material('mat4').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.material('mat4').propertyGroup('def').func('Cp').set('arg', 'T');
model.material('mat4').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.material('mat4').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/8.314/T');
model.material('mat4').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.material('mat4').propertyGroup('def').func('rho').set('plotargs', {'pA' '0' '1'; 'T' '0' '1'});
model.material('mat4').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/8.314/T,pA)'; 'T' 'd(pA*0.02897/8.314/T,T)'});
model.material('mat4').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.material('mat4').propertyGroup('def').func('k').set('arg', 'T');
model.material('mat4').propertyGroup('def').func('cs').set('args', {'T'});
model.material('mat4').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
model.material('mat4').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.material('mat4').propertyGroup('def').func('cs').set('plotargs', {'T' '0' '1'});
model.material('mat4').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
model.material('mat4').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat4').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat4').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.material('mat4').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.material('mat4').propertyGroup('def').set('electricconductivity', {'0[S/m]' '0' '0' '0' '0[S/m]' '0' '0' '0' '0[S/m]'});
model.material('mat4').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.material('mat4').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
model.material('mat4').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
model.material('mat4').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.material('mat4').propertyGroup('def').addInput('temperature');
model.material('mat4').propertyGroup('def').addInput('pressure');
model.material('mat4').propertyGroup('RefractiveIndex').set('n', '');
model.material('mat4').propertyGroup('RefractiveIndex').set('ki', '');
model.material('mat4').propertyGroup('RefractiveIndex').set('n', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.material('mat4').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});

model.physics('emw').prop('EquationForm').set('freq_src', 'userdef');
model.physics('emw').prop('EquationForm').set('form', 'Frequency');
model.physics('emw').prop('EquationForm').set('freq', 'f');
model.physics('emw').feature('port1').set('Pdep', '48.3');
model.physics('emw').feature('port1').set('PortType', 'Coaxial');
model.physics('emw').feature('port1').set('PortExcitation', 'on');
model.physics('emw').feature('port1').set('Pin', 'P_in');
model.physics('ht').feature('bt1').set('td', '1');
model.physics('ht').feature('bt1').set('DamageIntegralForm', 'EnergyAbsorption');
model.physics('ht').feature('bt1').set('IncludeDamageIntegralAnalysis', '1');
model.physics('ht').feature('bt1').set('Td', 'T_necro');
model.physics('ht').feature('bt1').set('Tn', 'T_necro');
model.physics('ht').feature('bt1').feature('bh1').set('Tb', 'T_init');
model.physics('ht').feature('init1').set('T', 'T_init');
model.physics('ht').feature('chf1').set('Text', 'Tprobe');
model.physics('ht').feature('chf1').set('h', 'htcoef');
model.physics('ht').feature('temp1').set('T0', 'Tboundary');

model.mesh('mesh1').feature('ftri1').feature('size1').set('custom', 'on');
model.mesh('mesh1').feature('ftri1').feature('size1').set('hminactive', true);
model.mesh('mesh1').feature('ftri1').feature('size1').set('hmaxactive', true);
model.mesh('mesh1').feature('ftri1').feature('size1').set('hmin', '2.4e-5 [mm]');
model.mesh('mesh1').feature('ftri1').feature('size1').set('hmax', '0.15 [mm]');
model.mesh('mesh1').feature('ftri1').feature('size2').set('custom', 'on');
model.mesh('mesh1').feature('ftri1').feature('size2').set('hminactive', true);
model.mesh('mesh1').feature('ftri1').feature('size2').set('hmaxactive', true);
model.mesh('mesh1').feature('ftri1').feature('size2').set('hmin', '2.4e-5 [mm]');
model.mesh('mesh1').feature('ftri1').feature('size2').set('hmax', '0.5[mm]');
model.mesh('mesh1').run;

model.study.create('std1');
model.study('std1').feature.create('ftrans', 'FrequencyTransient');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('ftrans').set('initstudyhide', 'on');
model.study('std1').feature('ftrans').set('initsolhide', 'on');
model.study('std1').feature('ftrans').set('notstudyhide', 'on');
model.study('std1').feature('ftrans').set('notsolhide', 'on');

model.result.dataset.create('rev1', 'Revolve2D');
model.result.dataset.create('rev2', 'Revolve2D');
model.result.dataset.create('rev3', 'Revolve2D');
model.result.dataset.create('rev4', 'Revolve2D');
model.result.create('pg1', 'PlotGroup2D');
model.result.create('pg3', 'PlotGroup2D');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg3').feature.create('surf1', 'Surface');

model.study('std1').feature('ftrans').set('tlist', 'range(0,time_step,time_end)');
model.study('std1').feature('ftrans').set('freq', 'f');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').name('Compile Equations: Frequency-Transient');
model.sol('sol1').feature('st1').set('studystep', 'ftrans');
model.sol('sol1').feature('v1').set('control', 'ftrans');
model.sol('sol1').feature('t1').set('complex', true);
model.sol('sol1').feature('t1').set('control', 'ftrans');
model.sol('sol1').feature('t1').set('tlist', 'range(0,time_step,time_end)');
model.sol('sol1').feature('t1').set('maxorder', '2');
model.sol('sol1').feature('t1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_T' 'comp1_E' 'comp1_Sparam1'});
model.sol('sol1').runAll;

model.result.dataset('rev1').set('startangle', '90');
model.result.dataset('rev1').set('revangle', '180');
model.result.dataset('rev2').set('startangle', '-90');
model.result.dataset('rev2').set('revangle', '225');
model.result.dataset('rev3').set('startangle', '-90');
model.result.dataset('rev3').set('revangle', '225');
model.result.dataset('rev4').set('startangle', '-90');
model.result.dataset('rev4').set('revangle', '225');
model.result('pg1').name('Temperature Map');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').feature('surf1').set('descr', 'Temperature');
model.result('pg1').feature('surf1').set('expr', 'T');
model.result('pg1').feature('surf1').set('unit', 'K');
model.result('pg3').name('Isothermal Contours (ht)');
model.result('pg3').feature('surf1').set('descr', 'Fraction of necrosed tissue');
model.result('pg3').feature('surf1').set('rangedatamax', '1');
model.result('pg3').feature('surf1').set('expr', 'ht.theta_d');
model.result('pg3').feature('surf1').set('rangedataactive', 'on');
model.result('pg3').feature('surf1').set('rangedatamin', '0.3');
model.result('pg3').feature('surf1').set('unit', '');

%% Get model contour
[meshstats, meshdata] = mphmeshstats(model);
p = meshdata.vertex;
t = double(meshdata.elem{2});
t = t + ones(size(t));
t(4,:) = 1:length(t);
u = mphinterp(model, 'ht.theta_d', 'coord', p);
u = u(end,:);

h = pdecont(p,t,u, [0.3 0.3]);
axis equal
X=get(h(1),'XData');
Y=get(h(1),'Ydata');
close all

for i = 1:length(X)
    if Y(i) >-1.75 && X(i) <=1.5
        Y(i) = Inf;
        X(i) = Inf;
    end
end

Y(X==Inf) = [];
X(X==Inf) = [];

X(isnan(X)) = [];
Y(isnan(Y)) = [];
%% Get true contour
load('001_contour.mat')

%% Calculate error
[~, d] = knnsearch([xn' yn'],[X' Y']);
error = sum(d.^2);
