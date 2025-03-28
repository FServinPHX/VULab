function out = model
%
% matlab_001_915_mhz_COLLINS_Probe_Fatty_Tissue_with_tumor.m
%
% Model exported on Oct 4 2021, 11:32 by COMSOL 5.6.0.401.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Liver Project - Ablation - 2021\COMSOL\915 MHZ Collins Probe - 3D - With Tumor');

model.modelNode.create('comp1');

model.geom.create('geom1', 3);

model.mesh.create('mesh1', 'geom1');

model.physics.create('emw', 'ElectromagneticWaves', 'geom1');
model.physics.create('ht', 'BioHeat', 'geom1');

model.study.create('std1');
model.study('std1').feature.create('freq', 'Frequency');
model.study('std1').feature('freq').activate('emw', true);
model.study('std1').feature('freq').activate('ht', true);

model.geom('geom1').feature.create('imp1', 'Import');
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\MWA_liver_1\liver_cath_04092014.asm.1');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run('fin');

model.param.set('rho_blood', '1e3[kg/m^3]', 'Density, blood');
model.param.set('Cp_blood', '3639[J/(kg*K)]', 'Specific heat, blood');
model.param.set('omega_blood', '3.6e-3[1/s]', 'Blood perfusion rate');
model.param.set('T_blood', '37[degC]', 'Blood temperature');
model.param.set('eps_liver', '43.03', 'Relative permittivity, liver');
model.param.set('sigma_liver', '1.69[S/m]', 'Electric conductivity, liver');
model.param.set('k_liver', '0.56[W/(m*K)]', 'Thermal conductivity, liver');
model.param.set('eps_diel', '2.03', 'Relative permittivity, dielectric');
model.param.set('eps_cat', '2.6', 'Relative permittivity, catheter');
model.param.set('f', '2.45[GHz]', 'Microwave frequency');
model.param.set('P_in', '10[W]', 'Input microwave power');

model.selection.create('sel1', 'Explicit');
model.selection('sel1').set([1]);
model.selection.create('sel2', 'Explicit');
model.selection('sel2').set([2]);
model.selection.create('sel3', 'Explicit');
model.selection('sel3').set([3]);
model.selection.create('sel4', 'Explicit');
model.selection('sel4').all;
model.selection('sel4').set([4]);
model.selection('sel1').name('Explicit 1 Liver');
model.selection('sel2').name('Explicit 2 Catheter');
model.selection('sel3').name('Explicit 3 Dielectric');
model.selection('sel4').name('Explicit 4 Air');

model.material.create('mat1');
model.material('mat1').name('Liver');
model.material('mat1').propertyGroup('def').set('heatcapacity', '3540[J/(kg*K)]');
model.material('mat1').propertyGroup('def').set('density', '1079[kg/m^3]');
model.material('mat1').propertyGroup('def').set('thermalconductivity', {'0.52[W/(m*K)]' '0' '0' '0' '0.52[W/(m*K)]' '0' '0' '0' '0.52[W/(m*K)]'});
model.material('mat1').propertyGroup('def').set('a', '7.39e39');
model.material('mat1').propertyGroup('def').set('deltae', '2.577e5');
model.material('mat1').set('family', 'plastic');
model.material('mat1').propertyGroup('def').set('relpermittivity', {'eps_liver'});
model.material('mat1').propertyGroup('def').set('relpermeability', {'1'});
model.material('mat1').propertyGroup('def').set('electricconductivity', {'sigma_liver'});
model.material('mat1').selection.named('sel1');
model.material.create('mat2');
model.material('mat2').name('Air');
model.material('mat2').set('family', 'air');
model.material('mat2').propertyGroup('def').set('relpermeability', '1');
model.material('mat2').propertyGroup('def').set('relpermittivity', '1');
model.material('mat2').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.material('mat2').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.material('mat2').propertyGroup('def').set('electricconductivity', '0[S/m]');
model.material('mat2').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.material('mat2').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
model.material('mat2').propertyGroup('def').set('thermalconductivity', 'k(T[1/K])[W/(m*K)]');
model.material('mat2').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.material('mat2').propertyGroup('def').func.create('eta', 'Piecewise');
model.material('mat2').propertyGroup('def').func('eta').set('funcname', 'eta');
model.material('mat2').propertyGroup('def').func('eta').set('arg', 'T');
model.material('mat2').propertyGroup('def').func('eta').set('extrap', 'constant');
model.material('mat2').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.material('mat2').propertyGroup('def').func.create('Cp', 'Piecewise');
model.material('mat2').propertyGroup('def').func('Cp').set('funcname', 'Cp');
model.material('mat2').propertyGroup('def').func('Cp').set('arg', 'T');
model.material('mat2').propertyGroup('def').func('Cp').set('extrap', 'constant');
model.material('mat2').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.material('mat2').propertyGroup('def').func.create('rho', 'Analytic');
model.material('mat2').propertyGroup('def').func('rho').set('funcname', 'rho');
model.material('mat2').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.material('mat2').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/8.314/T');
model.material('mat2').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.material('mat2').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/8.314/T,pA)'; 'T' 'd(pA*0.02897/8.314/T,T)'});
model.material('mat2').propertyGroup('def').func.create('k', 'Piecewise');
model.material('mat2').propertyGroup('def').func('k').set('funcname', 'k');
model.material('mat2').propertyGroup('def').func('k').set('arg', 'T');
model.material('mat2').propertyGroup('def').func('k').set('extrap', 'constant');
model.material('mat2').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.material('mat2').propertyGroup('def').func.create('cs', 'Analytic');
model.material('mat2').propertyGroup('def').func('cs').set('funcname', 'cs');
model.material('mat2').propertyGroup('def').func('cs').set('args', {'T'});
model.material('mat2').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
model.material('mat2').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.material('mat2').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
model.material('mat2').propertyGroup('def').addInput('temperature');
model.material('mat2').propertyGroup('def').addInput('pressure');
model.material('mat2').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.material('mat2').propertyGroup('RefractiveIndex').set('n', '1');
model.material('mat2').set('family', 'air');
model.material('mat2').selection.named('sel4');
model.material.create('mat3');
model.material('mat3').selection.named('sel2');
model.material('mat3').propertyGroup('def').set('relpermittivity', {'eps_cat'});
model.material('mat3').propertyGroup('def').set('relpermeability', {'1'});
model.material('mat3').propertyGroup('def').set('electricconductivity', {'0'});
model.material('mat3').name('Catheter');
model.material.move('mat3', 1);
model.material.create('mat4');
model.material('mat4').selection.named('sel3');
model.material('mat4').propertyGroup('def').set('relpermittivity', {'eps_diel'});
model.material('mat4').propertyGroup('def').set('relpermeability', {'1'});
model.material('mat4').propertyGroup('def').set('electricconductivity', {'0'});
model.material.move('mat4', 2);
model.material('mat4').name('Dielectric');

model.physics('emw').prop('EquationForm').set('form', 1, 'Frequency');
model.physics('emw').prop('EquationForm').set('freq_src', 1, 'userdef');
model.physics('emw').prop('EquationForm').set('freq', 1, 'f');
model.physics('emw').feature.create('port1', 'Port', 2);
model.physics('emw').feature('port1').selection.set([18]);
model.physics('emw').feature('port1').set('PortType', 1, 'Coaxial');
model.physics('emw').feature('port1').set('PortExcitation', 1, 'on');
model.physics('emw').feature('port1').set('Pin', 1, 'P_in');
model.physics('emw').feature.create('sctr1', 'Scattering', 2);
model.physics('emw').feature('sctr1').set('WaveType', 1, 'SphericalWave');
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 53 54 55 56 57 58 59 60 61 62 63 64 65]);
model.physics('ht').selection.named('sel1');
model.physics('ht').prop('EquationForm').set('form', 1, 'Transient');
model.physics('ht').feature('bt1').set('IncludeDamageIntegralAnalysis', 1, '1');
model.physics('ht').feature('bt1').set('DamageIntegralForm', 1, 'EnergyAbsorption');
model.physics('ht').feature('bt1').feature('bh1').set('Cb', 1, 'Cp_blood');
model.physics('ht').feature('bt1').feature('bh1').set('omegab', 1, 'omega_blood');
model.physics('ht').feature('bt1').feature('bh1').set('rhobl', 1, 'rho_blood');

model.multiphysics.create('emh1', 'ElectromagneticHeatSource', 'geom1', 3);
model.multiphysics('emh1').selection.all;

model.mesh('mesh1').feature.create('ftet1', 'FreeTet');
model.mesh('mesh1').feature('ftet1').feature.create('size1', 'Size');
model.mesh('mesh1').feature('ftet1').feature('size1').set('custom', 'on');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmaxactive', 'on');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hminactive', 'on');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmax', '1.5[cm]');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmin', '.1[mm]');
model.mesh('mesh1').run;

model.study('std1').feature('freq').set('plist', 'f');
model.study('std1').feature('freq').set('physselection', 'emw');
model.study('std1').feature('freq').set('activate', {'emw' 'on' 'ht' 'off'});

model.physics('ht').prop('EquationForm').set('form', 1, 'Automatic');

model.study('std1').feature('freq').set('physselection', 'emw');
model.study('std1').feature('freq').set('activate', {'emw' 'on' 'ht' 'on'});
model.study('std1').feature('freq').set('physselection', 'emw');
model.study('std1').feature('freq').set('activate', {'emw' 'on' 'ht' 'off'});
model.study('std1').feature.create('time', 'Transient');
model.study('std1').feature('time').set('physselection', 'emw');
model.study('std1').feature('time').set('activate', {'emw' 'off' 'ht' 'on'});
model.study('std1').feature('time').set('tunit', 'min');
model.study('std1').feature('time').set('tlist', 'range(0,0.25,10)');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,10)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');

model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').name('Electric Field (emw)');
model.result('pg1').set('oldanalysistype', 'noneavailable');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('mslc1', 'Multislice');
model.result('pg1').feature('mslc1').set('oldanalysistype', 'noneavailable');
model.result('pg1').feature('mslc1').set('data', 'parent');
model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').name('Temperature (ht)');
model.result('pg2').set('oldanalysistype', 'noneavailable');
model.result('pg2').set('data', 'dset1');
model.result('pg2').feature.create('surf1', 'Surface');
model.result('pg2').feature('surf1').set('oldanalysistype', 'noneavailable');
model.result('pg2').feature('surf1').set('expr', 'T');
model.result('pg2').feature('surf1').set('colortable', 'ThermalLight');
model.result('pg2').feature('surf1').set('data', 'parent');
model.result.create('pg3', 'PlotGroup3D');
model.result('pg3').name('Isothermal Contours (ht)');
model.result('pg3').set('oldanalysistype', 'noneavailable');
model.result('pg3').set('data', 'dset1');
model.result('pg3').feature.create('iso1', 'Isosurface');
model.result('pg3').feature('iso1').set('oldanalysistype', 'noneavailable');
model.result('pg3').feature('iso1').set('expr', 'T');
model.result('pg3').feature('iso1').set('number', 10);
model.result('pg3').feature('iso1').set('colortable', 'ThermalLight');
model.result('pg3').feature('iso1').set('data', 'parent');
model.result('pg3').feature.create('arwv1', 'ArrowVolume');
model.result('pg3').feature('arwv1').set('oldanalysistype', 'noneavailable');
model.result('pg3').feature('arwv1').set('arrowlength', 'logarithmic');
model.result('pg3').feature('arwv1').set('color', 'gray');
model.result('pg3').feature('arwv1').set('data', 'parent');

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,10)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');

model.physics('emw').feature('sctr1').set('WaveType', 1, 'PlaneWave');

model.mesh('mesh1').feature.create('ftet2', 'FreeTet');
model.mesh('mesh1').feature.move('ftet2', 1);
model.mesh('mesh1').feature('ftet2').feature.create('size1', 'Size');
model.mesh('mesh1').feature('ftet2').feature('size1').selection.geom('geom1', 3);
model.mesh('mesh1').feature('ftet2').feature('size1').selection.named('sel3');
model.mesh('mesh1').feature('ftet2').feature('size1').set('custom', 'on');
model.mesh('mesh1').feature('ftet2').feature('size1').set('hmaxactive', 'on');
model.mesh('mesh1').feature('ftet2').feature('size1').set('hminactive', 'on');
model.mesh('mesh1').feature('ftet2').feature('size1').set('hmax', '.15[mm]');
model.mesh('mesh1').feature('ftet2').feature('size1').set('hmin', '.01[mm]');
model.mesh('mesh1').feature('ftet2').selection.geom('geom1', 3);
model.mesh('mesh1').feature('ftet2').selection.named('sel3');
model.mesh('mesh1').feature('ftet1').selection.geom('geom1', 3);
model.mesh('mesh1').feature('ftet1').selection.set([1 2 4]);
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmin', '.01[mm]');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmax', '1[cm]');
model.mesh('mesh1').run;

model.study('std1').feature('freq').set('physselection', 'emw');
model.study('std1').feature('freq').set('activate', {'emw' 'on' 'ht' 'on'});
model.study('std1').feature('freq').set('physselection', 'emw');
model.study('std1').feature('freq').set('activate', {'emw' 'on' 'ht' 'off'});
model.study('std1').feature('time').set('physselection', 'emw');
model.study('std1').feature('time').set('activate', {'emw' 'on' 'ht' 'on'});
model.study('std1').feature('time').set('physselection', 'emw');
model.study('std1').feature('time').set('activate', {'emw' 'off' 'ht' 'on'});

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,10)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result.dataset.create('cpl1', 'CutPlane');
model.result.dataset('cpl1').set('quickplane', 'xy');
model.result.dataset('cpl1').set('planetype', 'general');
model.result.dataset('cpl1').set('genmethod', 'threepoint');
model.result.dataset('cpl1').set('planetype', 'general');
model.result.dataset('cpl1').set('genmethod', 'pointnormal');

model.coordSystem.create('sys2', 'geom1', 'VectorBase');
model.coordSystem.remove('sys2');
model.coordSystem.create('sys2', 'geom1', 'Mapping');
model.coordSystem('sys2').set('frametype', 'geometry');
model.coordSystem.remove('sys2');
model.coordSystem('sys1').set('frametype', 'spatial');
model.coordSystem('sys1').set('reversenormal', 'off');

model.result.dataset('cpl1').set('planetype', 'quick');
model.result.dataset('cpl1').set('quickz', '-.26');
model.result.dataset('cpl1').run;
model.result.dataset('cpl1').set('planetype', 'general');
model.result.dataset('cpl1').set('genmethod', 'threepoint');
model.result.dataset('cpl1').set('planetype', 'quick');
model.result.dataset('cpl1').set('quickz', '-.265');
model.result.dataset('cpl1').run;
model.result.dataset('cpl1').set('quickz', '-.255');
model.result.dataset('cpl1').run;
model.result.create('pg4', 'PlotGroup2D');
model.result('pg4').run;
model.result('pg4').feature.create('surf1', 'Surface');
model.result('pg4').feature('surf1').set('expr', 'log10(comp1.emw.normE)');
model.result('pg4').run;
model.result('pg4').run;
model.result.duplicate('pg5', 'pg4');
model.result('pg5').run;
model.result('pg4').run;
model.result('pg4').name('2D Electric Field Norm');
model.result('pg5').run;
model.result('pg5').name('2D Temperature');
model.result('pg5').run;
model.result('pg5').feature('surf1').set('expr', 'T');
model.result('pg5').feature('surf1').set('unit', 'degC');
model.result('pg5').feature('surf1').set('colortable', 'ThermalLight');
model.result('pg5').run;
model.result('pg5').feature.create('con1', 'Contour');
model.result('pg5').feature('con1').set('expr', 'T');
model.result('pg5').feature('con1').set('unit', 'degC');
model.result('pg5').feature('con1').set('number', '10');
model.result('pg5').feature('con1').set('colortable', 'GrayScale');
model.result('pg5').run;
model.result.duplicate('pg6', 'pg5');
model.result('pg6').run;
model.result('pg6').name('2D Necrosis');
model.result('pg6').run;
model.result('pg6').feature('surf1').set('expr', 'ht.theta_d');
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').feature('con1').set('expr', 'ht.theta_d');
model.result('pg6').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg6').run;

model.name('liver_core_2.mph');

model.result('pg6').run;

model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\MWA_liver_1\liver_cath_04092014.asm.2');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').feature('imp1').set('unit', 'source');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\MWA_liver_1\nice_liver_cath.asm.1');
model.geom('geom1').feature('imp1').importData;

model.name('liver_core_2.mph');

model.geom('geom1').feature.remove('imp1');
model.geom('geom1').feature.create('imp1', 'Import');
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\MWA_liver_1\liver_cath_04092014.asm.3');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run('fin');

model.selection('sel3').all;
model.selection('sel3').set([4]);
model.selection('sel4').all;
model.selection('sel4').set([4]);
model.selection('sel4').all;
model.selection('sel4').set([3]);

model.physics('emw').feature('port1').selection.set([43]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 25 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65]);

model.mesh('mesh1').run('ftet2');
model.mesh('mesh1').feature('ftet1').selection.all;
model.mesh('mesh1').feature('ftet1').selection.named('sel3');
model.mesh('mesh1').feature('ftet1').selection.all;
model.mesh('mesh1').feature('ftet1').selection.set([1 2 3]);
model.mesh('mesh1').run;

model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,10)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg4').run;
model.result.create('pg7', 'PlotGroup2D');
model.result('pg7').run;
model.result.remove('pg7');
model.result.dataset.create('cpl2', 'CutPlane');
model.result.dataset('cpl2').set('quickplane', 'xy');
model.result.dataset('cpl2').set('planetype', 'quick');
model.result('pg1').run;
model.result('pg4').run;
model.result('pg4').set('data', 'cpl2');
model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').set('data', 'cpl2');
model.result('pg5').run;
model.result('pg6').run;
model.result('pg6').set('data', 'cpl2');
model.result('pg6').run;
model.result('pg4').run;
model.result('pg4').set('allowtableupdate', false);
model.result('pg4').set('title', 'Time=10 min Surface: log10(comp1.emw.normE)');
model.result('pg4').set('xlabel', '');
model.result('pg4').set('ylabel', '');
model.result('pg4').feature('surf1').set('rangeunit', '');
model.result('pg4').feature('surf1').set('rangecolormin', -0.3500630225370916);
model.result('pg4').feature('surf1').set('rangecolormax', 5.3660257289301585);
model.result('pg4').feature('surf1').set('rangecoloractive', 'off');
model.result('pg4').feature('surf1').set('rangedatamin', -0.3500630225370916);
model.result('pg4').feature('surf1').set('rangedatamax', 5.3660257289301585);
model.result('pg4').feature('surf1').set('rangedataactive', 'off');
model.result('pg4').feature('surf1').set('rangeactualminmax', [-0.3500630225370916 5.3660257289301585]);
model.result('pg4').set('renderdatacached', false);
model.result('pg4').set('allowtableupdate', true);
model.result('pg4').set('renderdatacached', true);
model.result('pg5').run;
model.result('pg6').run;
model.result('pg5').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').set('allowtableupdate', false);
model.result('pg5').set('title', 'Time=10 min Surface: Temperature (degC) Contour: Temperature (degC)');
model.result('pg5').set('xlabel', '');
model.result('pg5').set('ylabel', '');
model.result('pg5').feature('surf1').set('rangeunit', 'degC');
model.result('pg5').feature('surf1').set('rangecolormin', 34.84587000736953);
model.result('pg5').feature('surf1').set('rangecolormax', 98.20797929488208);
model.result('pg5').feature('surf1').set('rangecoloractive', 'off');
model.result('pg5').feature('surf1').set('rangedatamin', 34.84587000736953);
model.result('pg5').feature('surf1').set('rangedatamax', 98.20797929488208);
model.result('pg5').feature('surf1').set('rangedataactive', 'off');
model.result('pg5').feature('surf1').set('rangeactualminmax', [34.84587000736953 98.20797929488208]);
model.result('pg5').set('renderdatacached', false);
model.result('pg5').set('allowtableupdate', true);
model.result('pg5').set('renderdatacached', true);
model.result('pg6').run;
model.result('pg5').run;
model.result('pg4').run;
model.result.duplicate('pg7', 'pg4');
model.result('pg7').run;
model.result('pg7').run;
model.result('pg7').feature('surf1').set('expr', 'emw.normE');
model.result('pg7').run;
model.result('pg7').run;
model.result.remove('pg7');
model.result('pg1').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg6').run;

model.name('liver_core_2.mph');

model.result('pg6').run;

model.param.set('P_in', '20[W]');

model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,10)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg4').run;
model.result('pg6').run;
model.result.export.create('data1', 'Data');
model.result.export('data1').set('solnum', {'41'});
model.result.export('data1').set('timeinterp', 'on');
model.result.export('data1').set('t', '10');
model.result.export('data1').setIndex('expr', 'T', 0);
model.result.export('data1').setIndex('unit', 'degC', 0);
model.result.export('data1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\Double_ablation\temp.csv');
model.result.export('data1').run;

model.name('liver_core_2.mph');

model.geom('geom1').feature.remove('imp1');
model.geom('geom1').run('');
model.geom('geom1').feature.create('imp1', 'Import');
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\Case_MWA_logan\asm0001.asm.2');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run('fin');
model.geom('geom1').run('fin');

model.selection('sel1').set([1]);
model.selection('sel2').set([2]);
model.selection('sel3').set([4]);
model.selection('sel4').all;
model.selection('sel4').set([3]);

model.physics('emw').feature('port1').selection.set([45]);

model.param.set('P_in', '45[W]');

model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 25 26 27 52 53 54 55 56 57 58 59 60 61]);

model.mesh('mesh1').feature('ftet1').feature('size1').selection.named('sel1');
model.mesh('mesh1').feature('ftet2').feature('size1').selection.all;
model.mesh('mesh1').feature('ftet2').feature('size1').selection.set([2 3 4]);
model.mesh('mesh1').feature('ftet2').feature('size1').selection.named('sel3');
model.mesh('mesh1').feature('ftet2').feature('size1').selection.all;
model.mesh('mesh1').feature('ftet2').feature('size1').selection.set([3 4]);
model.mesh('mesh1').feature('ftet1').feature('size1').selection.all;
model.mesh('mesh1').feature('ftet1').feature('size1').selection.set([1 2]);
model.mesh('mesh1').feature('ftet2').selection.all;
model.mesh('mesh1').feature('ftet2').selection.set([3 4]);
model.mesh('mesh1').feature('ftet1').selection.all;
model.mesh('mesh1').feature('ftet1').selection.set([1 2]);
model.mesh('mesh1').run;

model.study('std1').feature('time').set('tlist', 'range(0,0.25,15)');

model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,15)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('iso1').set('unit', 'degC');
model.result('pg3').feature('iso1').set('levelmethod', 'levels');
model.result('pg3').feature('iso1').set('levels', '50');
model.result('pg3').run;
model.result('pg3').feature('iso1').set('data', 'dset1');
model.result('pg3').run;
model.result('pg3').feature('iso1').set('levels', '60');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', '61', 0);
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', '61', 0);
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg3').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;

model.geom('geom1').feature.remove('imp1');
model.geom('geom1').run('');
model.geom('geom1').feature.create('imp1', 'Import');
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\Case_MWA_logan\asm0001.asm.3');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run('fin');

model.selection('sel1').set([1]);
model.selection('sel2').set([2]);
model.selection('sel3').set([4]);
model.selection('sel4').all;
model.selection('sel4').set([3]);

model.mesh('mesh1').feature('ftet2').selection.all;
model.mesh('mesh1').feature('ftet2').selection.set([3 4]);
model.mesh('mesh1').feature('ftet1').selection.all;
model.mesh('mesh1').feature('ftet1').selection.set([1 2]);

model.physics('emw').feature('port1').selection.set([83]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 63 64 65 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140]);

model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\Case_MWA_logan\asm0001.asm.4');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').runPre('fin');
model.geom('geom1').run('fin');

model.selection('sel1').set([1]);
model.selection('sel2').set([2]);
model.selection('sel3').set([4]);
model.selection('sel4').all;
model.selection('sel4').set([3]);

model.physics('emw').feature('port1').selection.set([72]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 52 53 54 70 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122]);

model.mesh('mesh1').feature('ftet1').selection.set([1 2]);
model.mesh('mesh1').feature('ftet2').feature('size1').selection.all;
model.mesh('mesh1').feature('ftet2').feature('size1').selection.set([3 4]);
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmin', '.001[mm]');
model.mesh('mesh1').current('ftet1');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmin', '.0001[mm]');
model.mesh('mesh1').current('ftet1');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmin', '.00001[mm]');
model.mesh('mesh1').current('ftet1');

model.geom('geom1').feature.remove('imp1');
model.geom('geom1').run('');
model.geom('geom1').feature.create('imp1', 'Import');
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\Case_MWA_logan\asm0001.asm.5');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run('fin');

model.selection('sel1').set([1]);
model.selection('sel2').set([2]);
model.selection('sel3').all;
model.selection('sel3').set([4]);
model.selection('sel4').all;
model.selection('sel4').set([3]);

model.mesh('mesh1').feature('ftet1').feature('size1').set('hmin', '.01[mm]');
model.mesh('mesh1').run;
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').selection.set([1 2]);
model.mesh('mesh1').feature('ftet1').selection.set([1 2]);
model.mesh('mesh1').feature('ftet2').selection.all;
model.mesh('mesh1').feature('ftet2').selection.set([3 4]);
model.mesh('mesh1').run;

model.physics('emw').feature('port1').selection.set([46]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 26 27 28 50 51 52 53 54 55 56 57 58 59 60 61]);

model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,15)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg6').run;
model.result.export('data1').set('timeinterp', 'off');
model.result.export('data1').set('solnum', {'61'});
model.result('pg6').run;
model.result('pg6').run;
model.result.export('data1').setIndex('expr', 'ht.theta_d', 1);
model.result.export('data1').run;
model.result.export('data1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\Case_MWA_logan\temp_thetad.csv');
model.result.export('data1').run;

model.name('core_lref_06042014.mph');

model.result('pg1').run;

model.geom('geom1').feature.remove('imp1');
model.geom('geom1').run('');
model.geom('geom1').feature.create('imp1', 'Import');
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\0415-AblZoneData\model_liver_coords.asm.1');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').runPre('fin');
model.geom('geom1').runPre('fin');
model.geom('geom1').run;

model.selection('sel1').set([1]);
model.selection('sel2').set([2]);
model.selection('sel3').set([3]);
model.selection('sel4').all;
model.selection('sel4').set([4]);

model.physics('emw').feature('port1').selection.set([92]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 40 41 42 43 44 45 55 56 57 58 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 93 94 95 96 97 98 99 100 101 102 103 104 105 106]);

model.mesh('mesh1').feature('ftet1').selection.all;
model.mesh('mesh1').feature('ftet1').selection.set([1 2]);
model.mesh('mesh1').feature('ftet2').selection.all;
model.mesh('mesh1').feature('ftet2').selection.set([3 4]);
model.mesh('mesh1').run;

model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,15)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg3').run;
model.result.export('data1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\0415-AblZoneData\temp_thetad_liver_coords.csv');
model.result.export('data1').run;

model.name('core_lref_06042014.mph');

model.result('pg3').run;
model.result('pg3').run;

model.name('core_cref_07292014.mph');

model.geom('geom1').feature.remove('imp1');
model.geom('geom1').feature.create('imp1', 'Import');
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Jarrod\Documents\Education\Graduate\Comsol\0415-AblZoneData\model_cath_coords.asm.3');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run;

model.selection('sel1').set([1]);
model.selection('sel3').set([4]);
model.selection('sel4').set([]);
model.selection('sel4').all;
model.selection('sel4').set([3]);

model.geom('geom1').runPre('fin');
model.geom('geom1').runPre('fin');

model.physics('emw').feature('port1').selection.set([]);
model.physics('emw').feature('sctr1').selection.set([]);
model.physics('emw').feature('port1').selection.set([74]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 54 55 56 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 101 102 103 104 105 106]);

model.mesh('mesh1').run;

model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature.create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').feature.create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');

model.shape('shape1').feature('shfun1');

model.sol('sol1').feature.create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,15)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature.create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').feature.create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').feature.create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg6').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').feature('surf1').set('titletype', 'custom');
model.result('pg5').run;
model.result('pg5').set('titletype', 'custom');
model.result('pg5').set('solutionintitle', 'off');
model.result('pg5').set('descriptionintitle', 'on');
model.result('pg5').set('unitintitle', 'on');
model.result('pg5').set('typeintitle', 'off');
model.result('pg5').run;
model.result('pg5').feature('surf1').set('typeintitle', 'off');
model.result('pg5').feature('surf1').set('descriptionintitle', 'off');
model.result('pg5').feature('surf1').set('unitintitle', 'off');
model.result('pg5').run;
model.result('pg5').feature('con1').set('colorlegend', 'off');

model.label('core_cref_07292014.mph');

model.comments(['Core cref 07292014\n\n']);

model.result('pg5').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg3').run;

model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Frank\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL WORK\Comsol\0415-AblZoneData\model_cath_coords.asm.3');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run('fin');

model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notlistsolnum', {'1'});
model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolnumhide', 'off');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('listsolnum', {'1'});
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solnumhide', 'off');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');
model.study('std1').feature('freq').set('notlistsolnum', 1);
model.study('std1').feature('freq').set('notsolnum', '1');
model.study('std1').feature('freq').set('listsolnum', 1);
model.study('std1').feature('freq').set('solnum', '1');
model.study('std1').feature('time').set('notlistsolnum', 1);
model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('listsolnum', 1);
model.study('std1').feature('time').set('solnum', 'auto');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,15)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('se1').create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notlistsolnum', {'1'});
model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolnumhide', 'off');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('listsolnum', {'1'});
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solnumhide', 'off');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('notlistsolnum', {'1'});
model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('control', 'time');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').feature('v2').set('listsolnum', {'1'});
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '5', 0);
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '61', 0);
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', 'interp', 0);
model.result('pg2').run;
model.result('pg3').run;
model.result('pg3').setIndex('looplevel', '9', 0);
model.result('pg3').run;
model.result('pg3').setIndex('looplevel', '21', 0);
model.result('pg3').run;
model.result('pg3').setIndex('looplevel', '59', 0);
model.result('pg3').run;

model.view('view1').set('geomhidestatus', 'hide');

model.label('core_cref_07292014_base.mph');

model.geom('geom1').runPre('fin');
model.geom('geom1').runPre('fin');
model.geom('geom1').run('fin');
model.geom('geom1').lengthUnit('mm');
model.geom('geom1').scaleUnitValue(true);
model.geom('geom1').run('fin');
model.geom('geom1').run('fin');
model.geom('geom1').run('fin');
model.geom('geom1').run('fin');
model.geom('geom1').run('fin');
model.geom('geom1').run('fin');
model.geom('geom1').run('fin');
model.geom('geom1').run('fin');
model.geom('geom1').feature('imp1').set('filename', 'C:\Users\Frank\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL WORK\Comsol\0415-AblZoneData\cath_assembly.asm.1');
model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run('imp1');
model.geom('geom1').create('mov1', 'Move');
model.geom('geom1').feature('mov1').set('displx', '-10');
model.geom('geom1').feature('mov1').set('disply', '10');
model.geom('geom1').feature('mov1').set('displz', '10');
model.geom('geom1').run('imp1');
model.geom('geom1').feature('mov1').selection('input').set({'imp1.CATH_ASSEMBLYcatheter_prt_6catheter_prtCATHETER'});
model.geom('geom1').runPre('fin');
model.geom('geom1').run('imp1');
model.geom('geom1').feature('mov1').set('keep', 'on');
model.geom('geom1').run('mov1');
model.geom('geom1').feature.remove('mov1');
model.geom('geom1').run('fin');
model.geom('geom1').run('imp1');
model.geom('geom1').create('imp2', 'Import');
model.geom('geom1').feature('imp2').set('filename', 'C:\Users\Frank\Documents\1.0 Vanderbilt\Dr. Miga Lab\mDIXON_liverfatquant\Slicer3D Models\Liver_Shape.stl');
model.geom('geom1').feature('imp2').set('facepartition', 'manual');
model.geom('geom1').feature('imp2').importData;
model.geom('geom1').run('imp2');
model.geom('geom1').create('mov1', 'Move');
model.geom('geom1').feature('mov1').selection('input').set({'imp1'});
model.geom('geom1').feature('mov1').set('displz', '100');
model.geom('geom1').feature('mov1').set('disply', '100');
model.geom('geom1').feature('mov1').set('displx', '100');
model.geom('geom1').feature('mov1').set('keep', 'on');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('keep', 'off');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('displz', '250');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('displz', '150');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('disply', '150');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('disply', '200');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('disply', '250');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('displx', '125');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('disply', '300');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('disply', '250');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('disply', '220');
model.geom('geom1').run('mov1');
model.geom('geom1').feature('mov1').set('displx', '140');
model.geom('geom1').run('mov1');
model.geom('geom1').run;

model.material('mat1').selection.set([1]);
model.material('mat3').selection.set([2 3]);
model.material('mat4').selection.set([7 8]);
model.material('mat2').selection.set([5]);
model.material('mat4').selection.set([4 6 7 8]);

model.physics('emw').feature('port1').selection.set([74]);
model.physics('emw').feature('sctr1').selection.all;
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116]);
model.physics('emw').feature.create('pec2', 'PerfectElectricConductor', 2);
model.physics('emw').feature('pec2').selection.set([58 59 60 61 64 65 67 68 72]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116]);
model.physics('emw').feature.move('sctr1', 3);
model.physics('emw').feature.move('pec2', 3);
model.physics('ht').feature.create('bt2', 'BiologicalTissue', 3);
model.physics('ht').feature('bt2').selection.all;
model.physics('ht').feature('bt2').selection.set([1 2 3 4 5 6 7 8]);
model.physics('ht').selection.all;
model.physics('ht').feature.remove('bt2');
model.physics('ht').selection.set([1 2 3 4 5 6 7 8]);
model.physics('ht').selection.all;
model.physics('ht').selection.named('sel1');
model.physics('ht').selection.set([1]);

model.mesh('mesh1').run;
model.mesh('mesh1').automatic(true);
model.mesh('mesh1').current('ftet1');
model.mesh('mesh1').feature('size').set('hauto', '1');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('size').set('hauto', '2');
model.mesh('mesh1').run;

model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notlistsolnum', {'1'});
model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolnumhide', 'off');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('listsolnum', {'1'});
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solnumhide', 'off');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');
model.study('std1').feature('freq').set('notlistsolnum', 1);
model.study('std1').feature('freq').set('notsolnum', '1');
model.study('std1').feature('freq').set('listsolnum', 1);
model.study('std1').feature('freq').set('solnum', '1');
model.study('std1').feature('time').set('notlistsolnum', 1);
model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('listsolnum', 1);
model.study('std1').feature('time').set('solnum', 'auto');

model.sol('sol1').feature.remove('t1');
model.sol('sol1').feature.remove('v2');
model.sol('sol1').feature.remove('st2');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'f'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'Hz'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'auto');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'comp1_E'});
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').create('st2', 'StudyStep');
model.sol('sol1').feature('st2').set('study', 'std1');
model.sol('sol1').feature('st2').set('studystep', 'time');
model.sol('sol1').create('v2', 'Variables');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('control', 'time');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.25,15)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'pg1');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobal', 0.001);
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_T' 'global' 'comp1_ht_alpha' 'global' 'comp1_E' 'global'});
model.sol('sol1').feature('t1').set('atol', {'comp1_T' '1e-3' 'comp1_ht_alpha' '1e-3' 'comp1_E' '1e-3'});
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('maxorder', 2);
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').create('se1', 'Segregated');
model.sol('sol1').feature('t1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('t1').feature('se1').create('ss1', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('segvar', {'comp1_T'});
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subdamp', 1);
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('subjtech', 'minimal');
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('t1').feature('i1').set('prefuntype', 'left');
model.sol('sol1').feature('t1').feature('i1').set('rhob', 20);
model.sol('sol1').feature('t1').feature('i1').set('itrestart', 50);
model.sol('sol1').feature('t1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('prefun', 'gmg');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('mcasegen', 'any');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('iter', 2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('linerelax', 0.2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('seconditer', 2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('relax', 0.5);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sl1').set('iter', 2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sl1').set('linerelax', 0.2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sl1').set('seconditer', 2);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sl1').set('relax', 0.5);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('se1').feature('ss1').set('linsolver', 'i1');
model.sol('sol1').feature('t1').feature('se1').create('ss2', 'SegregatedStep');
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('segvar', {'comp1_ht_alpha'});
model.sol('sol1').feature('t1').feature('se1').feature('ss2').set('linsolver', 'dDef');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolvertype', 'solnum');
model.study('std1').feature('time').set('notlistsolnum', {'1'});
model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').set('notsolnumhide', 'off');
model.study('std1').feature('time').set('notstudyhide', 'on');
model.study('std1').feature('time').set('notsolhide', 'on');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solvertype', 'solnum');
model.study('std1').feature('time').set('listsolnum', {'1'});
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('solnumhide', 'off');
model.study('std1').feature('time').set('initstudyhide', 'on');
model.study('std1').feature('time').set('initsolhide', 'on');

model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol1').feature('v2').set('notlistsolnum', {'1'});
model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('v2').set('control', 'time');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('solvertype', 'solnum');
model.sol('sol1').feature('v2').set('listsolnum', {'1'});
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg4').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg6').run;
model.result('pg5').run;
model.result('pg3').run;
model.result('pg3').setIndex('looplevel', '45', 0);
model.result('pg3').setIndex('looplevel', '2', 0);
model.result('pg3').setIndex('looplevel', '9', 0);
model.result('pg3').run;
model.result('pg3').set('showhiddenobjects', 'on');
model.result('pg3').run;
model.result('pg3').setIndex('looplevel', '10', 0);
model.result('pg3').run;
model.result('pg3').set('data', 'cpl1');
model.result('pg3').run;
model.result('pg3').set('data', 'cpl2');
model.result('pg3').run;
model.result('pg3').set('data', 'dset1');
model.result('pg3').run;
model.result('pg2').run;
model.result('pg6').run;
model.result('pg6').set('data', 'cpl1');
model.result('pg1').run;
model.result('pg1').set('frametype', 'mesh');
model.result('pg1').run;
model.result('pg1').setIndex('looplevel', '2', 0);
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '53', 0);
model.result('pg2').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('iso1').setIndex('looplevel', '45', 0);
model.result('pg3').run;
model.result('pg3').run;
model.result.create('pg7', 'PlotGroup3D');
model.result('pg7').run;
model.result('pg7').label('Temperature');
model.result('pg6').run;
model.result('pg7').run;
model.result('pg7').label('Temperature_contour');
model.result('pg7').create('slc1', 'Slice');
model.result('pg7').run;
model.result('pg5').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg7').run;
model.result('pg7').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg2').create('slc1', 'Slice');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature.remove('slc1');
model.result('pg2').run;
model.result('pg7').run;
model.result.remove('pg7');
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').create('slc1', 'Slice');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature('slc1').set('expr', 'ht.normE');
model.result('pg2').run;
model.result('pg2').feature('slc1').set('expr', 'emw.normE');
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature('slc1').set('data', 'dset1');
model.result('pg2').feature('slc1').set('expr', 'emw.normE');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature.remove('slc1');
model.result('pg2').run;
model.result.dataset('dset1').set('solution', 'none');
model.result.dataset('dset1').run;
model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg6').run;
model.result('pg3').run;
model.result.move('pg3', 1);
model.result('pg3').set('showlegends', true);

model.sol('sol1').updateSolution;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg1').run;
model.result.dataset.create('dset2', 'Solution');
model.result.dataset('dset2').set('solution', 'sol1');
model.result.create('pg7', 'PlotGroup3D');
model.result('pg7').label('Electric Field (emw) 1');
model.result('pg7').set('data', 'dset2');
model.result('pg7').set('oldanalysistype', 'noneavailable');
model.result('pg7').set('solvertype', 'none');
model.result('pg7').set('solnum', 1);
model.result('pg7').set('showlooplevel', {'off' 'off' 'off'});
model.result('pg7').set('frametype', 'spatial');
model.result('pg7').set('oldanalysistype', 'noneavailable');
model.result('pg7').set('data', 'dset2');
model.result('pg7').feature.create('mslc1', 'Multislice');
model.result('pg7').feature('mslc1').set('oldanalysistype', 'noneavailable');
model.result('pg7').feature('mslc1').set('solvertype', 'none');
model.result('pg7').feature('mslc1').set('data', 'parent');
model.result.numerical.create('gev1', 'EvalGlobal');
model.result.numerical('gev1').label('S-parameter, S11dB (emw)');
model.result.numerical('gev1').set('data', 'dset2');
model.result.numerical('gev1').set('expr', 'emw.S11dB');
model.result.create('pg8', 'PlotGroup3D');
model.result('pg8').label('Temperature (ht) 1');
model.result('pg8').set('data', 'dset2');
model.result('pg8').set('oldanalysistype', 'noneavailable');
model.result('pg8').set('solvertype', 'none');
model.result('pg8').set('solnum', 1);
model.result('pg8').set('showlooplevel', {'off' 'off' 'off'});
model.result('pg8').set('oldanalysistype', 'noneavailable');
model.result('pg8').set('data', 'dset2');
model.result('pg8').feature.create('surf1', 'Surface');
model.result('pg8').feature('surf1').set('oldanalysistype', 'noneavailable');
model.result('pg8').feature('surf1').set('solvertype', 'none');
model.result('pg8').feature('surf1').set('expr', 'T');
model.result('pg8').feature('surf1').set('colortable', 'ThermalLight');
model.result('pg8').feature('surf1').set('data', 'parent');
model.result.create('pg9', 'PlotGroup3D');
model.result('pg9').label('Isothermal Contours (ht) 1');
model.result('pg9').set('data', 'dset2');
model.result('pg9').set('oldanalysistype', 'noneavailable');
model.result('pg9').set('solvertype', 'none');
model.result('pg9').set('solnum', 1);
model.result('pg9').set('showlooplevel', {'off' 'off' 'off'});
model.result('pg9').set('oldanalysistype', 'noneavailable');
model.result('pg9').set('data', 'dset2');
model.result('pg9').feature.create('iso1', 'Isosurface');
model.result('pg9').feature('iso1').set('oldanalysistype', 'noneavailable');
model.result('pg9').feature('iso1').set('solvertype', 'none');
model.result('pg9').feature('iso1').set('expr', 'T');
model.result('pg9').feature('iso1').set('number', 10);
model.result('pg9').feature('iso1').set('colortable', 'ThermalLight');
model.result('pg9').feature('iso1').set('data', 'parent');

model.sol('sol1').runAll;

model.result('pg7').run;
model.result('pg7').set('allowtableupdate', false);
model.result('pg7').set('title', 'Time=0 min Multislice: Electric field norm (V/m)');
model.result('pg7').set('hasbeenplotted', true);
model.result('pg7').feature('mslc1').set('rangeunit', 'V/m');
model.result('pg7').feature('mslc1').set('rangecolormin', 7.021486098361648E-79);
model.result('pg7').feature('mslc1').set('rangecolormax', 1.57666039318124E-74);
model.result('pg7').feature('mslc1').set('rangecoloractive', 'off');
model.result('pg7').feature('mslc1').set('rangedatamin', 7.021486098361648E-79);
model.result('pg7').feature('mslc1').set('rangedatamax', 1.57666039318124E-74);
model.result('pg7').feature('mslc1').set('rangedataactive', 'off');
model.result('pg7').feature('mslc1').set('rangeactualminmax', [7.021486098361648E-79 1.57666039318124E-74]);
model.result('pg7').feature('mslc1').set('hasbeenplotted', true);
model.result('pg7').set('renderdatacached', false);
model.result('pg7').set('allowtableupdate', true);
model.result('pg7').set('renderdatacached', true);
model.result.table.create('evl3', 'Table');
model.result.table('evl3').comments('Interactive 3D values');
model.result.table('evl3').label('Evaluation 3D');
model.result.table('evl3').addRow([101.65409028838364 200.30084823093262 147.54971990591906 1.5360859697289431E-75]);

model.geom('geom1').run('imp1');
model.geom('geom1').runPre('fin');

model.sol('sol1').run('s1');

model.result('pg7').run;

model.mesh('mesh1').feature('size').set('hauto', '1');
model.mesh('mesh1').run;
model.mesh('mesh1').run('size');
model.mesh('mesh1').run;

model.label('core_cref_07292014_base.mph');

model.sol('sol1').runAll;

model.result('pg7').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg3').run;
model.result('pg1').run;
model.result('pg1').run;
model.result('pg1').set('data', 'dset2');
model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').set('data', 'dset2');
model.result('pg3').set('solnum', '5');
model.result('pg3').run;
model.result('pg3').set('data', 'dset2');

model.mesh('mesh1').automatic(true);

model.label('core_cref_07292014_base_fine.mph');

model.result('pg6').run;
model.result('pg7').run;
model.result('pg2').run;
model.result('pg2').run;

model.mesh('mesh1').feature('ftet1').selection.geom('geom1');
model.mesh('mesh1').current('ftet1');

model.geom('geom1').feature('imp1').importData;
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.05');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.5');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.6');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.5');
model.geom('geom1').run('imp2');
model.geom('geom1').run;
model.geom('geom1').feature('imp2').set('minareaplane', '0.005');
model.geom('geom1').run('imp2');
model.geom('geom1').run('imp2');
model.geom('geom1').run('imp2');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.05');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.005');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.05');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.5');
model.geom('geom1').run('imp2');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.05');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('planarangle', '0.7');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('facecleanup', '0.1');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('facecleanup', '0.5');
model.geom('geom1').run('imp2');
model.geom('geom1').run('fin');

model.mesh('mesh1').feature('size').set('hauto', '3');
model.mesh('mesh1').automatic(true);
model.mesh('mesh1').autoMeshSize(4);
model.mesh('mesh1').feature('ftet1').feature.create('size1', 'Size');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', 5);
model.mesh('mesh1').feature('ftet1').feature('size1').selection.geom('geom1', 3);
model.mesh('mesh1').feature('ftet1').feature('size1').selection.set([2 3 4 5 6 7 8]);
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '3');
model.mesh('mesh1').current('ftet1');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '2');
model.mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg7').run;
model.result('pg2').run;
model.result('pg2').set('data', 'dset2');
model.result('pg2').run;
model.result('pg2').set('solnum', '45');
model.result('pg2').run;
model.result('pg2').set('solnum', '1');
model.result('pg2').run;
model.result('pg1').run;

model.geom('geom1').feature('imp2').set('planarangle', '0.8');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('facecleanup', '0.7');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('facecleanup', '0.9');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('facecleanup', '0.5');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('facecleanup', '0.2');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('facecleanup', '0.01');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('facecleanup', '0.1');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.5');
model.geom('geom1').run('imp2');
model.geom('geom1').feature('imp2').set('minareaplane', '0.05');
model.geom('geom1').runPre('fin');
model.geom('geom1').run;

model.mesh('mesh1').feature('size').set('hauto', '3');
model.mesh('mesh1').run('size');
model.mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg1').run;

model.sol('sol1').run('t1');

model.result('pg1').run;

model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '1');
model.mesh('mesh1').run('ftet1');
model.mesh('mesh1').feature('ftet1').feature('size1').selection.set([1 2 3 4 5 6 7 8]);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').set('allowtableupdate', false);
model.result('pg3').set('title', 'Isosurface: Temperature (degC) Arrow Volume: Total heat flux');
model.result('pg3').set('hasbeenplotted', true);
model.result('pg3').feature('iso1').set('hasbeenplotted', true);
model.result('pg3').feature('arwv1').set('scale', 2380.152402106821);
model.result('pg3').feature('arwv1').set('scaleactive', false);
model.result('pg3').feature('arwv1').set('hasbeenplotted', true);
model.result('pg3').set('renderdatacached', false);
model.result('pg3').set('allowtableupdate', true);
model.result('pg3').set('renderdatacached', true);
model.result('pg3').setIndex('looplevel', '21', 0);
model.result('pg3').run;
model.result('pg3').setIndex('looplevel', '5', 0);
model.result('pg3').run;
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '3', 0);
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '5', 0);
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '9', 0);
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '21', 0);
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '33', 0);
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;

model.label('core_cref_07292014_base_fine_mesh_specific.mph');

model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '25', 0);
model.result('pg2').run;
model.result('pg2').setIndex('looplevel', '33', 0);
model.result('pg2').run;
model.result('pg3').run;
model.result('pg3').create('con1', 'Contour');
model.result('pg3').run;
model.result('pg3').feature('iso1').set('data', 'dset2');
model.result('pg3').feature('iso1').set('solnum', '33');
model.result('pg3').run;
model.result('pg3').feature('iso1').set('colortable', 'ThermalEquidistant');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature('iso1').set('data', 'parent');
model.result('pg3').run;
model.result('pg3').setIndex('looplevel', '9', 0);
model.result('pg3').setIndex('looplevel', '34', 0);
model.result('pg3').setIndex('looplevel', '33', 0);
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').create('slc1', 'Slice');
model.result('pg2').feature('slc1').set('quickplane', 'xy');
model.result('pg2').run;
model.result('pg4').run;
model.result('pg2').run;
model.result('pg2').feature.remove('slc1');
model.result('pg2').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg6').run;
model.result('pg6').feature('surf1').set('cutplane', 'cpl1');
model.result('pg6').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg6').run;
model.result('pg8').run;
model.result('pg9').run;
model.result('pg9').run;
model.result('pg9').run;
model.result('pg9').setIndex('looplevel', '29', 0);
model.result('pg9').setIndex('looplevel', '33', 0);
model.result('pg9').run;
model.result('pg8').run;
model.result('pg8').setIndex('looplevel', '33', 0);
model.result('pg8').run;
model.result('pg7').run;
model.result('pg8').run;
model.result('pg9').run;
model.result('pg8').run;
model.result('pg9').run;
model.result('pg8').run;
model.result('pg2').run;
model.result('pg5').run;
model.result('pg5').set('xlabelactive', 'on');
model.result('pg4').run;
model.result('pg9').run;
model.result('pg8').run;
model.result('pg9').run;
model.result('pg8').run;
model.result('pg9').run;
model.result('pg8').run;
model.result('pg8').run;
model.result('pg8').run;
model.result('pg8').create('vol1', 'Volume');
model.result('pg8').feature.remove('vol1');
model.result('pg8').run;
model.result('pg8').create('vol1', 'Volume');
model.result('pg8').feature.remove('vol1');
model.result('pg8').run;
model.result.create('pg10', 'PlotGroup3D');
model.result('pg10').run;
model.result('pg10').label('3D Plot Group _Temperature_Slices');
model.result('pg10').set('data', 'dset2');
model.result('pg10').create('mslc1', 'Multislice');
model.result('pg10').feature('mslc1').set('expr', 'T');
model.result('pg10').feature('mslc1').set('data', 'dset2');
model.result('pg10').feature('mslc1').setIndex('looplevel', '53', 0);
model.result('pg10').run;
model.result('pg10').feature('mslc1').set('colortable', 'Thermal');
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg5').run;
model.result('pg6').run;
model.result('pg10').run;
model.result('pg8').run;
model.result('pg9').run;
model.result('pg10').run;
model.result('pg10').feature('mslc1').set('multiplanexmethod', 'number');
model.result('pg10').feature('mslc1').set('xnumber', '2');
model.result('pg10').feature('mslc1').set('ynumber', '2');
model.result('pg10').feature('mslc1').set('znumber', '2');
model.result('pg10').run;
model.result('pg10').feature('mslc1').active(false);
model.result('pg10').run;

model.modelNode.create('comp2');

model.geom.create('geom2', 2);
model.geom('geom2').axisymmetric(true);

model.mesh.create('mesh2', 'geom2');

model.modelNode.remove('comp2');

model.result('pg10').run;
model.result('pg10').set('allowtableupdate', false);
model.result('pg10').set('title', 'Time=15 min');
model.result('pg10').set('hasbeenplotted', true);
model.result('pg10').set('renderdatacached', false);
model.result('pg10').set('allowtableupdate', true);
model.result('pg10').set('renderdatacached', true);

model.geom('geom1').run('mov1');
model.geom('geom1').feature.create('wp1', 'WorkPlane');
model.geom('geom1').feature('wp1').set('unite', true);
model.geom('geom1').feature.remove('wp1');

model.result('pg2').run;
model.result('pg10').run;
model.result.create('pg11', 'PlotGroup2D');
model.result('pg11').run;
model.result.remove('pg11');
model.result('pg10').run;
model.result('pg10').create('slc1', 'Slice');
model.result('pg10').feature('slc1').set('expr', 'T');
model.result('pg10').feature('slc1').set('data', 'dset2');
model.result('pg10').feature('slc1').set('planetype', 'general');
model.result('pg10').feature('slc1').set('genmethod', 'threepoint');
model.result('pg10').feature('slc1').set('planetype', 'quick');
model.result('pg10').feature('slc1').set('quickxmethod', 'coord');
model.result('pg10').feature('slc1').set('quickx', '120');
model.result('pg10').run;
model.result('pg10').feature('slc1').active(false);
model.result('pg10').run;
model.result('pg10').run;
model.result('pg10').feature('mslc1').active(true);
model.result('pg10').run;
model.result('pg10').feature('mslc1').set('xnumber', '1');
model.result('pg10').feature('mslc1').set('ynumber', '1');
model.result('pg10').feature('mslc1').set('znumber', '1');
model.result('pg10').feature('mslc1').set('multiplanexmethod', 'coord');
model.result('pg10').feature('mslc1').set('multiplaneymethod', 'coord');
model.result('pg10').feature('mslc1').set('multiplanezmethod', 'coord');
model.result('pg10').feature('mslc1').set('xcoord', '140');

model.geom('geom1').measureFinal.selection.geom('geom1');
model.geom('geom1').measureFinal.selection.geom('geom1');
model.geom('geom1').measureFinal.selection.allGeom;
model.geom('geom1').measureFinal.selection.geom('geom1');
model.geom('geom1').measureFinal.selection.allGeom;
model.geom('geom1').measureFinal.selection.geom('geom1');
model.geom('geom1').measureFinal.selection.allGeom;
model.geom('geom1').measureFinal.selection.geom('geom1');
model.geom('geom1').measureFinal.selection.allGeom;
model.geom('geom1').run;
model.geom('geom1').measure.selection.init;
model.geom('geom1').measure.selection.set({'imp2(1)' 'mov1(1)' 'mov1(2)' 'mov1(3)'});
model.geom('geom1').measure.selection.init;
model.geom('geom1').measure.selection.set({'mov1(1)'});

model.result('pg10').run;
model.result('pg10').feature('mslc1').set('ycoord', '220');
model.result('pg10').feature('mslc1').set('zcoord', '150');
model.result('pg10').run;
model.result('pg10').feature('mslc1').setIndex('looplevel', '29', 0);
model.result('pg10').run;

model.material('mat4').selection.set([7 8]);
model.material('mat3').selection.set([2 3 4 6]);

model.sol('sol1').updateSolution;

model.result('pg1').run;
model.result('pg10').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg10').run;

model.geom('geom1').run('mov1');
model.geom('geom1').feature.create('wp1', 'WorkPlane');
model.geom('geom1').feature('wp1').set('unite', true);
model.geom('geom1').feature('wp1').set('quickplane', 'yz');
model.geom('geom1').feature('wp1').set('quickx', '120');
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('quickx', '150');
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('quickx', '140');
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('quickplane', 'yz');
model.geom('geom1').feature('wp1').set('displ', {'10' '0'});
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('displ', {'0' '0'});
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('displ', {'0' '10'});
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('displ', {'80' '10'});
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('displ', {'80' '20'});
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('displ', {'80' '30'});
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('rot', '180');
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('rot', '90');
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('rot', '0');
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('displ', {'0' '0'});
model.geom('geom1').run('wp1');
model.geom('geom1').feature('wp1').set('quickorigin', 'global');
model.geom('geom1').feature('wp1').set('quickaxis', 'natural');
model.geom('geom1').run('wp1');

model.modelNode.create('comp2');

model.geom.create('geom2', 2);

model.mesh.create('mesh2', 'geom2');

model.geom('geom2').create('cro1', 'CrossSection');
model.geom('geom2').runPre('fin');
model.geom('geom2').runPre('fin');
model.geom('geom2').runPre('fin');
model.geom('geom1').feature('wp1').set('workplane3d', true);
model.geom('geom2').lengthUnit('cm');
model.geom('geom2').lengthUnit('mm');
model.geom('geom2').runPre('fin');
model.geom('geom2').run('cro1');
model.geom('geom2').feature.remove('cro1');
model.geom('geom2').create('cro1', 'CrossSection');
model.geom('geom2').runPre('fin');
model.geom('geom2').run;

model.modelNode.remove('comp2');

model.result('pg2').run;
model.result('pg2').set('allowtableupdate', false);
model.result('pg2').set('title', 'Time=8 min Surface: Temperature (K)');
model.result('pg2').set('hasbeenplotted', true);
model.result('pg2').feature('surf1').set('rangeunit', 'K');
model.result('pg2').feature('surf1').set('rangecolormin', 306.93394310160926);
model.result('pg2').feature('surf1').set('rangecolormax', 306.9340499426318);
model.result('pg2').feature('surf1').set('rangecoloractive', 'off');
model.result('pg2').feature('surf1').set('rangedatamin', 306.93394310160926);
model.result('pg2').feature('surf1').set('rangedatamax', 306.9340499426318);
model.result('pg2').feature('surf1').set('rangedataactive', 'off');
model.result('pg2').feature('surf1').set('rangeactualminmax', [306.93394310160926 306.9340499426318]);
model.result('pg2').feature('surf1').set('hasbeenplotted', true);
model.result('pg2').set('renderdatacached', false);
model.result('pg2').set('allowtableupdate', true);
model.result('pg2').set('renderdatacached', true);
model.result.table('evl3').addRow([151.34502834886825 229.33210530441767 187.23052904105438 306.9340201774337]);
model.result('pg10').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').set('data', 'dset1');
model.result('pg6').run;
model.result('pg6').set('data', 'cpl2');
model.result('pg6').run;
model.result.dataset.create('cpl3', 'CutPlane');
model.result.dataset('cpl3').set('quickx', '120');
model.result.dataset('cpl3').set('data', 'dset2');
model.result.dataset('cpl3').run;
model.result.dataset('cpl3').set('quickx', '140');
model.result.dataset('cpl3').run;
model.result('pg6').run;
model.result('pg6').set('data', 'cpl3');
model.result('pg6').run;
model.result('pg5').run;
model.result('pg5').set('data', 'cpl3');
model.result('pg5').run;
model.result('pg6').run;
model.result('pg5').run;
model.result('pg6').run;
model.result('pg5').run;
model.result('pg10').run;
model.result('pg10').run;
model.result('pg9').run;
model.result('pg1').run;
model.result('pg3').run;
model.result('pg4').run;
model.result('pg4').set('data', 'cpl3');
model.result('pg4').run;

model.physics('emw').selection.set([1 2 3 4 5 6 7 8]);
model.physics('emw').selection.all;
model.physics('emw').selection.set([1 2 3 4 5 6 7 8]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 47 48 49 50 51 52 53 54 55 56 57 60 61 62 63 64 65 66 67 68 71 72 73 74 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109]);
model.physics('emw').feature('sctr1').selection.remove([59]);
model.physics('emw').feature('sctr1').selection.remove([58]);
model.physics('emw').feature('sctr1').selection.remove([67]);
model.physics('emw').feature('sctr1').selection.remove([68]);
model.physics('emw').feature('sctr1').selection.remove([73]);
model.physics('emw').feature('sctr1').selection.remove([71]);
model.physics('emw').feature('sctr1').selection.remove([67]);
model.physics('emw').feature('sctr1').selection.remove([74]);
model.physics('emw').feature('pec2').selection.set([54 55 56 58 60 61 63 64 67 73 74]);
model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 47 48 49 50 51 52 53 54 55 56 60 61 62 63 64 65 66 72 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109]);
model.physics('emw').feature('pec2').selection.set([54 55 56 57 58 60 61 62 67 68 71 72 73 74 75]);
model.physics('emw').feature.move('pec2', 4);

model.label('core_cref_07292014_base_fine_mesh_specific.mph');

model.mesh('mesh1').feature('ftet1').feature('size1').selection.set([2 3 4 5 6 7 8]);
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '2');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '3');
model.mesh('mesh1').current('ftet1');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '2');
model.mesh('mesh1').feature('ftet1').feature('size1').set('custom', 'on');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmaxactive', 'off');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hminactive', 'on');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmin', '0.5');
model.mesh('mesh1').current('ftet1');
model.mesh('mesh1').feature('ftet1').feature('size1').set('custom', 'off');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('size').set('hauto', '4');
model.mesh('mesh1').run;
model.mesh('mesh1').run;
model.mesh('mesh1').feature('size').set('hauto', '5');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('table', 'semi');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('table', 'default');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('table', 'cfd');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('table', 'default');
model.mesh('mesh1').run;

model.sol('sol1').updateSolution;

model.result('pg1').run;
model.result('pg9').run;
model.result('pg8').run;
model.result('pg7').run;
model.result('pg10').run;

model.physics('emw').selection.all;
model.physics('emw').selection.set([1 2 3 4 5 6 7 8]);

model.study('std1').feature('time').set('tlist', 'range(0,0.25,5)');
model.study('std1').feature('freq').set('probesel', 'none');

model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '3');
model.mesh('mesh1').current('ftet1');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '2');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('size').set('hauto', '6');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('size').set('hauto', '5');

model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 47 48 49 50 51 52 53 54 55 56 60 61 62 63 64 65 66 72 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 105 106 107 108 109]);
model.physics('emw').feature('sctr1').set('IncidentField', 'NoIncidentField');

model.mesh('mesh1').feature('size').set('hauto', '3');
model.mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg6').run;
model.result('pg7').run;
model.result('pg8').run;
model.result('pg10').run;
model.result('pg10').setIndex('looplevel', '3', 0);
model.result('pg10').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg8').run;
model.result('pg8').run;
model.result('pg8').setIndex('looplevel', '4', 0);
model.result('pg8').run;
model.result('pg8').setIndex('looplevel', '9', 0);
model.result('pg8').run;
model.result('pg9').run;
model.result('pg9').setIndex('looplevel', '4', 0);
model.result('pg9').run;
model.result('pg9').run;
model.result('pg10').run;
model.result('pg9').run;
model.result('pg10').run;
model.result('pg10').feature('mslc1').setIndex('looplevel', '4', 0);
model.result('pg10').run;
model.result('pg10').feature('mslc1').set('xcoord', '120');
model.result('pg10').run;
model.result('pg10').feature('mslc1').set('xcoord', '140');
model.result('pg10').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg9').run;
model.result('pg10').run;
model.result('pg5').run;

model.study('std1').feature('time').set('tlist', 'range(0,0.25,10)');

model.sol('sol1').updateSolution;

model.result('pg1').run;
model.result('pg5').run;

model.sol('sol1').runAll;

model.result('pg1').run;

model.label('core_cref_07292014_base_fine_mesh_specific.mph');

model.physics('emw').feature('pec2').selection.set([54 55 56 57 58 60 61 62 67 68 71 72 73 74 75]);

model.view('view1').set('geomhidestatus', 'hide');

model.physics('emw').feature('pec2').selection.set([21 54 55 56 57 58 60 61 62 67 68 71 72 73 74 75]);

model.view('view1').set('geomhidestatus', 'ignore');

model.physics('emw').feature('pec2').selection.set([48 49 50 53 54 55 56 57 58 59 60 61 62 67 68 71 72 73 74 75]);

model.label('core_cref_07292014_base_fine_mesh_specific.mph');

model.result('pg1').run;
model.result('pg3').run;
model.result('pg9').run;
model.result('pg9').setIndex('looplevel', '41', 0);
model.result('pg9').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', '41', 0);
model.result('pg6').run;
model.result('pg7').run;
model.result('pg8').run;
model.result('pg9').run;
model.result('pg9').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg9').run;
model.result('pg9').run;
model.result('pg10').run;
model.result('pg9').run;
model.result('pg9').create('vol1', 'Volume');
model.result('pg9').feature.remove('vol1');
model.result('pg9').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg6').run;
model.result('pg10').run;
model.result('pg10').run;
model.result('pg10').run;
model.result('pg10').create('vol1', 'Volume');
model.result('pg10').feature.remove('vol1');
model.result('pg10').run;
model.result('pg10').run;
model.result('pg10').run;
model.result('pg9').run;
model.result('pg9').run;
model.result('pg9').run;
model.result('pg10').run;
model.result.create('pg11', 'PlotGroup3D');
model.result('pg11').run;
model.result('pg11').label('Isothermal_Necrosis');
model.result('pg11').create('iso1', 'Isosurface');
model.result('pg6').run;
model.result('pg11').run;
model.result('pg11').feature('iso1').set('expr', 'ht.theta_d');
model.result('pg11').run;
model.result('pg11').set('data', 'dset2');
model.result('pg11').set('solnum', '26');
model.result('pg11').run;
model.result('pg11').set('solnum', '41');
model.result('pg11').run;
model.result('pg11').run;
model.result('pg11').run;
model.result('pg11').run;
model.result('pg11').feature('iso1').set('number', '25');
model.result('pg11').run;
model.result('pg11').feature('iso1').set('number', '5');
model.result('pg11').run;

model.material('mat4').selection.geom('geom1', 1);
model.material('mat4').selection.geom('geom1', 0);

model.physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 47 48 49 50 51 52 53 54 55 56 60 61 62 63 64 65 66 72 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 100 101 102 103 104 105 106 107 108 109]);

model.mesh('mesh1').feature('size').set('hauto', '2');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '1');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('size').set('hauto', '1');
model.mesh('mesh1').run;

model.material('mat4').selection.geom('geom1', 3);
model.material('mat4').selection.set([7 8]);

model.mesh('mesh1').feature('size').set('hauto', '2');
model.mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result.dataset('dset1').set('solution', 'none');
model.result.export('data1').set('filename', 'C:\Users\Frank\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL WORK\Comsol\Exported Data\temp_thetad_liver_coords.csv');
model.result.export('data1').run;
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', '41', 0);
model.result('pg6').run;

model.label('core_cref_07292014_base_fine_mesh_specific_3_29_2021.mph');

model.result('pg6').run;

model.material('mat1').selection.set([]);

model.result('pg6').run;
model.result('pg8').run;
model.result('pg10').run;
model.result('pg5').run;
model.result.export('data1').setIndex('expr', 'ht', 2);
model.result.export('data1').setIndex('expr', 'ht.alphanecr', 2);
model.result.export('data1').setIndex('expr', 'ht.theta_d_sm', 3);
model.result('pg6').feature('surf1').set('expr', 'ht.theta_d_sm');
model.result('pg6').run;
model.result('pg6').feature('surf1').set('expr', 'ht.alpha');
model.result('pg6').run;
model.result('pg6').feature('surf1').set('expr', 'ht.theta_d');
model.result('pg6').run;

model.label('core_cref_07292014_base_fine_mesh_specific_3_29_2021.mph');

model.mesh('mesh1').feature('size').set('hauto', '1');
model.mesh('mesh1').run;

model.material('mat1').selection.set([1]);

model.label('core_cref_07292014_base_fine_mesh_specific_3_29_2021.mph');

model.setGroupByType(false);
model.component('comp1').setGroupByType(false);

model.component('comp1').physics('emw').setGroupBySpaceDimension(false);
model.component('comp1').physics('ht').setGroupBySpaceDimension(false);

model.component('comp1').mesh('mesh1').autoBuildNew(true);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').run;

model.result('pg5').run;

model.study('std1').setGenPlots(true);
model.study('std1').setGenConv(true);
model.study('std1').setStoreSolution(true);
model.study('std1').setPlotUndefVals(true);

model.sol('sol1').runAll;

model.result('pg5').setIndex('looplevel', 7, 0);
model.result('pg5').setIndex('looplevel', 8, 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 24, 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 'interp', 0);
model.result('pg5').setIndex('looplevel', 41, 0);
model.result('pg5').run;
model.result('pg6').setIndex('looplevel', 13, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 41, 0);
model.result('pg6').run;

model.label('core_cref_07292014_base_fine_mesh_specific_3_29_2021.mph');

model.result('pg5').run;
model.result.export('data1').setIndex('expr', '', 2);
model.result.export('data1').setIndex('expr', '', 3);
model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\temp_thetad_liver_coords.csv');
model.result.export('data1').run;
model.result.export('data1').run;

model.sol('sol1').updateSolution;

model.result.export('data1').run;
model.result.export('data1').set('data', 'dset2');
model.result.export('data1').run;

model.label('core_cref_07292014_base_fine_mesh_specific_3_29_2021.mph');

model.component('comp1').func.create('int1', 'Interpolation');
model.component('comp1').func('int1').setIndex('table', 'cloud', 0, 0);
model.component('comp1').func('int1').setIndex('table', 1, 0, 1);
model.component('comp1').func('int1').set('source', 'file');
model.component('comp1').func('int1').set('filename', 'Random_data2.txt');
model.component('comp1').func('int1').importData;
model.component('comp1').func('int1').setIndex('funcs', 'cloud', 0, 0);
model.component('comp1').func('int1').set('argunit', 'm');
model.component('comp1').func('int1').set('fununit', 'f');
model.component('comp1').func('int1').createPlot('pg12');
model.component('comp1').func('int1').set('fununit', '1');

model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'0.52[W/(m*K)]-.3*abs(cloud(x,y,z))[W/(m*K)]'});

model.sol('sol1').runAll;

model.result('pg6').run;

model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'0.52[W/(m*K)]-.3*(abs(cloud(x,y,z))[W/(m*K)]+1)'});

model.sol('sol1').runAll;

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'3540[J/(kg*K)]-1191*(abs(cloud(x,y,z))+1)[J/(kg*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'0.52[W/(m*K)]'});

model.sol('sol1').runAll;

model.result('pg5').run;

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'3540[J/(kg*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'1079[kg/m^3]-168*(cloud(x,y,z)+1)[kg/m^3]'});

model.sol('sol1').runAll;

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\whole_liver_heterogenous_density.csv');
model.result.export('data1').run;

model.label('whole_liver_07292014_base_fine_mesh_specific_3_29_2021-heterogenous-density.mph');

model.component('comp1').physics('emw').feature('wee1').set('minput_temperature_src', 'fromCommonDef');

model.component('comp1').material('mat1').propertyGroup('def').set('density', {'1079[kg/m^3]'});

model.component('comp1').physics('emw').feature('wee1').set('editModelInputs', true);
model.component('comp1').physics('emw').feature('wee1').set('minput_frequency_src', 'root.freq');
model.component('comp1').physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 47 48 49 50 51 52 53 54 55 56 60 61 62 63 64 65 66 72 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109]);
model.component('comp1').physics('emw').feature('sctr1').set('WaveType', 'SphericalWave');

model.param.set('P_in', '10[W]');

model.sol('sol1').runAll;

model.result('pg5').run;
model.result('pg6').run;

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'3540[J/(kg*K)]-(3540-2348)*(abs(cloud(x,y,z)/cloud(x,y,z)))[J/(kg*K)]'});

model.sol('sol1').runAll;

model.result('pg5').run;

model.label('whole_liver_07292014_base_fine_mesh_specific_3_29_2021-heterogenous-heat_capacity_v2.mph');

model.result('pg5').run;
model.result('pg5').set('filenameintitle', true);
model.result('pg5').set('solutionintitle', true);
model.result('pg5').run;
model.result('pg6').run;

model.label('whole_liver_07292014_base_fine_mesh_specific_3_29_2021-heterogenous-heat_capacity_v2.mph');

model.component('comp1').physics('emw').feature('pec2').selection.set([48 49 50 53 54 55 56 57 58 59 60 61 62 67 68 71 72 73 74 75]);

model.result('pg5').run;
model.result('pg4').run;
model.result('pg7').run;

model.component('comp1').geom('geom1').feature('imp2').set('type', 'mesh');
model.component('comp1').geom('geom1').feature('imp2').set('meshfilename', 'C:\Users\Frank\Documents\1.0 Vanderbilt\Dr. Miga Lab\mDIXON_liverfatquant\Slicer3D Models\Liver_Shape.stl');

model.component.create('mcomp1', 'MeshComponent');

model.geom.create('mgeom1', 3);
model.geom('mgeom1').lengthUnit('mm');

model.mesh.create('mpart1', 'mgeom1');

model.component('comp1').geom('geom1').feature('imp2').set('mesh', 'mpart1');

model.mesh('mpart1').create('imp1', 'Import');
model.mesh('mpart1').feature('imp1').set('filename', 'C:\Users\Frank\Documents\1.0 Vanderbilt\Dr. Miga Lab\mDIXON_liverfatquant\Slicer3D Models\Liver_Shape.stl');

model.component('comp1').geom('geom1').feature('imp2').set('meshfilename', '');

model.mesh('mpart1').run;

model.component('comp1').geom('geom1').feature('imp2').importData;
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').feature('imp2').set('type', 'stlvrml');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run;

model.component('comp1').geom('geom1').feature('imp2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\Liver_001_v2_smooth_remesh.stl');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'3540[J/(kg*K)]'});

model.component('comp1').physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 12 14 15 16 17 18 19 20 21 22 23 27 28 29 30 31 32 33 39 43]);

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg4').run;
model.result('pg5').run;

model.label('whole_liver_07292014_base_fine_mesh_specific_3_29_2021-heterogenous-heat_capacity_v2_liver_001.mph');

model.result('pg2').setIndex('looplevel', 2, 0);
model.result('pg2').run;
model.result('pg5').run;

model.component('comp1').geom('geom1').runPre('mov1');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displz', 120);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 120);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').autoBuildNew(false);
model.component('comp1').mesh('mesh1').autoBuildNew(true);
model.component('comp1').mesh('mesh1').run;

model.component('comp1').geom('geom1').feature('mov1').set('displz', 140);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 130);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg5').run;
model.result.dataset('cpl3').set('quickx', 130);
model.result('pg5').run;

model.param.set('eps_liver', '69');
model.param.set('sigma_liver', '.487[S/m]');
model.param.set('Cp_blood', '3617[J/(kg*K)]');

model.sol('sol1').updateSolution;

model.result('pg5').run;

model.component('comp1').geom('geom1').feature('mov1').set('disply', 200);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 210);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg2').run;
model.result('pg5').run;
model.result('pg6').run;

model.component('comp1').geom('geom1').feature('imp2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\liver_002_v2_smooth_remesh.stl');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('wp1');
model.component('comp1').geom('geom1').create('rot1', 'Rotate');
model.component('comp1').geom('geom1').feature('rot1').selection('input').init;
model.component('comp1').geom('geom1').feature('rot1').selection('input').set({'imp2'});
model.component('comp1').geom('geom1').feature('rot1').set('rot', 90);
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 10);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 180);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('axistype', 'y');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 90);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 270);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('axistype', 'z');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 180);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 90);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 0);
model.component('comp1').geom('geom1').feature('rot1').set('axistype', 'x');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 10);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 20);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('axistype', 'y');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('axistype', 'z');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 45);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 0);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').runPre('rot1');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 90);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 180);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 280);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 360);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('axistype', 'y');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 270);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('axistype', 'x');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 10);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 20);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('specify', 'eulerang');
model.component('comp1').geom('geom1').feature('rot1').set('eulerang', [10 0 0]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('eulerang', [10 10 0]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('eulerang', [10 10 10]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('eulerang', [40 10 0]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('eulerang', [0 10 0]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('eulerang', [0 20 0]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('eulerang', [0 0 0]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').feature.remove('rot1');
model.component('comp1').geom('geom1').run('wp1');
model.component('comp1').geom('geom1').feature('imp2').set('faceangle', 220);
model.component('comp1').geom('geom1').run('imp1');
model.component('comp1').geom('geom1').feature('imp2').set('faceangle', 100);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('imp2').set('neighangle', 30);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('imp2').set('facepartition', 'auto');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('imp2').set('facepartition', 'manual');
model.component('comp1').geom('geom1').feature('imp2').set('planarangle', 0.1);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('imp2').set('faceangle', 120);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('imp2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\liver_002_v3_smooth_remesh.stl');
model.component('comp1').geom('geom1').feature('imp2').importData;
model.component('comp1').geom('geom1').feature('imp2').set('neighangle', 20);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('imp2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\liver_002_v4_smooth_remesh.stl');
model.component('comp1').geom('geom1').feature('imp2').importData;
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 120);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').material('mat3').selection.set([2 3 4 6]);

model.component('comp1').physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 9 10 11 13 14 15 16 17 18 19 20 21 22 26 27 28 29 30 31 32 38 42 43]);

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg2').setIndex('looplevel', 5, 0);
model.result('pg2').run;
model.result('pg5').run;
model.result('pg1').run;
model.result.dataset('cpl3').set('quickx', 120);
model.result('pg5').run;

model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('imp2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\liver_004_smoothed_v3.stl');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 200);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 100);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 175);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displz', 160);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displz', 140);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 120);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 150);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 150);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 140);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 160);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 150);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 175);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displz', 150);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displz', 160);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 150);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').physics('emw').feature('sctr1').selection.set([2 3 4 5 6 7 8 9 10 11 13 14 15 16 17 18 19 20 21 22 26 27 28 29 30 31 32 38]);

model.param.set('P_in', '20[W]');

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 17, 0);
model.result('pg5').run;
model.result.dataset('cpl3').set('quickx', 150);
model.result('pg5').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.param.set('P_in', '45[W]');

model.component('comp1').geom('geom1').run('wp1');
model.component('comp1').geom('geom1').create('rot1', 'Rotate');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 180);
model.component('comp1').geom('geom1').feature.move('rot1', 2);
model.component('comp1').geom('geom1').runPre('rot1');
model.component('comp1').geom('geom1').feature('rot1').selection('input').set({'imp1'});
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 120);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 135);
model.component('comp1').geom('geom1').feature('mov1').set('displz', 145);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run;

model.study('std1').feature('time').set('tlist', 'range(0,0.25,15)');

model.sol('sol1').runAll;

model.result('pg5').setIndex('looplevel', 61, 0);
model.result('pg5').run;
model.result.dataset('cpl3').set('quickx', 135);
model.result('pg5').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.param.set('sigma_liver', '.362[S/m]');
model.param.set('eps_liver', '52.2');

model.component('comp1').material('mat1').propertyGroup('def').set('activationenergy', {'21951'});
model.component('comp1').material('mat1').propertyGroup('def').set('frequencyfactor', {'5.18039e39'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'0.427[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'1029[kg/m^3]'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'3184[J/(kg*K)]'});

model.sol('sol1').runAll;

model.result('pg5').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_homogenous_fat.mph');

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\whole_liver_base_fine_mesh_specific_v2_liver_004_homogenous_fat.csv');
model.result.export('data1').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_homogenous_fat.mph');

model.result('pg5').run;
model.result('pg6').setIndex('looplevel', 61, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 21, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 9, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 2, 0);
model.result('pg6').run;

model.component('comp1').material('mat1').propertyGroup('def').set('frequencyfactor', {'7.39E+39'});
model.component('comp1').material('mat1').propertyGroup('def').set('activationenergy', {'257700'});

model.sol('sol1').runAll;

model.result('pg6').setIndex('looplevel', 61, 0);
model.result('pg6').run;
model.result('pg5').run;

model.component('comp1').mesh('mesh1').stat.setQualityMeasure('skewness');
model.component('comp1').mesh('mesh1').stat.selection.geom('geom1', 3);
model.component('comp1').mesh('mesh1').stat.selection.set([2 3 4]);
model.component('comp1').mesh('mesh1').stat.selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').stat.selection.set([27]);

model.result('pg6').setIndex('looplevel', 17, 0);
model.result('pg6').run;
model.result.table.create('evl2', 'Table');
model.result.table('evl2').comments('Interactive 2D values');
model.result.table('evl2').label('Evaluation 2D');
model.result.table('evl2').addRow([104.18595886230469 147.05368041992188 0.9999594937916603], [0 0 0]);
model.result('pg6').run;
model.result('pg6').set('lastinputmode', 'evaluate');
model.result('pg6').set('inputmode', 'linefirst');
model.result('pg6').set('linefirst', [103.77360534667969 157.362548828125 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.774 157.363; 144.172 184.866]);
model.result('pg6').set('cutlinedshash', -1184677555);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linefirst', [103.15507507324219 134.88925170898438 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.155 134.889; 144.172 184.866]);
model.result('pg6').set('cutlinedshash', 1274598994);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linefirst', [103.15507507324219 154.47605895996094 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.155 154.476; 144.172 184.866]);
model.result('pg6').set('cutlinedshash', -689279894);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linefirst', [105.83537292480469 156.33164978027344 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [105.834 156.332; 144.172 184.866]);
model.result('pg6').set('cutlinedshash', -983600971);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').run;
model.result('pg6').set('lastinputmode', 'linefirst');
model.result('pg6').set('inputmode', 'linesecond');
model.result('pg6').set('linesecond', [103.77360534667969 135.92013549804688 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [105.834 156.332; 103.774 135.919]);
model.result('pg6').set('cutlinedshash', -1186670385);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').run;
model.result('pg6').set('lastinputmode', 'linesecond');
model.result('pg6').set('inputmode', 'linefirst');
model.result('pg6').set('linefirst', [103.56742858886719 156.12547302246094 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.566 156.125; 103.774 135.919]);
model.result('pg6').set('cutlinedshash', -1098244277);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('lastinputmode', 'linefirst');
model.result('pg6').set('inputmode', 'evaluate');
model.result('pg6').set('lastinputmode', 'evaluate');
model.result('pg6').set('inputmode', 'linefirst');
model.result('pg6').set('linefirst', [103.56742858886719 136.53866577148438 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.566 136.538; 103.774 135.919]);
model.result('pg6').set('cutlinedshash', 865634611);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linefirst', [102.53654479980469 156.74400329589844 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [102.537 156.744; 103.774 135.919]);
model.result('pg6').set('cutlinedshash', 762550321);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linefirst', [104.18595886230469 156.74400329589844 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [104.186 156.744; 103.774 135.919]);
model.result('pg6').set('cutlinedshash', -1294576439);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').setIndex('looplevel', 41, 0);
model.result('pg6').run;
model.result('pg6').set('linefirst', [103.79002380371094 156.88339233398438 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.79 156.883; 103.774 135.919]);
model.result('pg6').set('cutlinedshash', -1826696709);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('lastinputmode', 'linefirst');
model.result('pg6').set('inputmode', 'evaluate');
model.result.table('evl2').addRow([95.75496673583984 159.56173706054688 0.7787999854860181], [0 0 0]);
model.result('pg6').run;
model.result('pg6').set('lastinputmode', 'evaluate');
model.result('pg6').set('inputmode', 'linefirst');
model.result('pg6').set('linefirst', [103.64122772216797 129.57907104492188 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 103.774 135.919]);
model.result('pg6').set('cutlinedshash', -183677550);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').run;
model.result('pg6').set('lastinputmode', 'linefirst');
model.result('pg6').set('inputmode', 'linesecond');
model.result('pg6').set('linesecond', [102.22765350341797 163.87686157226562 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 102.227 163.877]);
model.result('pg6').set('cutlinedshash', 161064582);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg5').feature('surf1').set('colortable', 'Rainbow');
model.result('pg5').run;
model.result('pg6').set('linesecond', [107.65875244140625 142.37564086914062 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 107.659 142.376]);
model.result('pg6').set('cutlinedshash', 15301737);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linesecond', [102.67404174804688 161.4217071533203 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 102.674 161.422]);
model.result('pg6').set('cutlinedshash', -955872132);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linesecond', [101.9300537109375 128.38870239257812 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 101.93 128.389]);
model.result('pg6').set('cutlinedshash', -1007355951);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linesecond', [103.41802978515625 163.80245971679688 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 103.418 163.8]);
model.result('pg6').set('cutlinedshash', 1305135819);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linesecond', [109.66752624511719 135.38217163085938 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 109.668 135.382]);
model.result('pg6').set('cutlinedshash', -18470904);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linesecond', [101.63246154785156 155.6186065673828 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 101.632 155.619]);
model.result('pg6').set('cutlinedshash', 356919372);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linesecond', [99.99568939208984 161.4217071533203 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 99.9957 161.422]);
model.result('pg6').set('cutlinedshash', -852259532);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linesecond', [107.733154296875 153.98184204101562 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 107.733 153.982]);
model.result('pg6').set('cutlinedshash', 1589679783);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('linesecond', [101.33486938476562 163.207275390625 -1]);
model.result.dataset('cln1').set('method', 'twopoint');
model.result.dataset('cln1').set('genpoints', [103.641 129.579; 101.334 163.207]);
model.result('pg6').set('cutlinedshash', 1451121411);
model.result('pg13').set('data', 'cln1');
model.result('pg6').set('cutlinepgds', 'cln1');
model.result('pg6').set('lastinputmode', 'linesecond');
model.result('pg6').set('inputmode', 'evaluate');
model.result.table('evl2').addRow([101.9300537109375 129.8766632080078 0.8030652688575521], [0 0 0]);
model.result.table('evl2').addRow([102.67404174804688 128.8350830078125 0.7180741857182603], [0 0 0]);
model.result.table('evl2').addRow([101.63246154785156 125.71034240722656 0.43634031584576016], [0 0 0]);
model.result.table('evl2').addRow([101.9300537109375 165.14163208007812 0.3321529130665043], [0 0 0]);
model.result.table('evl2').addRow([102.6868896484375 126.55848693847656 46.40873539539509], [0 0 0]);
model.result.table('evl2').addRow([102.37635040283203 163.82351684570312 46.363944878543656], [0 0 0]);
model.result.table('evl2').addRow([107.96607971191406 129.50863647460938 48.535106780742154], [0 0 0]);
model.result.table('evl2').addRow([107.96607971191406 129.35336303710938 48.275771543471855], [0 0 0]);
model.result.table('evl2').addRow([108.27662658691406 129.50863647460938 48.362798124896095], [0 0 0]);
model.result.table('evl2').addRow([108.27662658691406 129.50863647460938 48.362798124896095], [0 0 0]);
model.result.table('evl2').addRow([108.27662658691406 129.50863647460938 48.362798124896095], [0 0 0]);
model.result.table('evl2').addRow([108.27662658691406 129.50863647460938 48.362798124896095], [0 0 0]);
model.result.table('evl2').addRow([108.27662658691406 130.28500366210938 49.657551666838124], [0 0 0]);

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'3540[J/(kg*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'1079[kg/m^3]'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'69'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'.362[S/m]'});

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_homogenous_fat.mph');

model.result('pg6').run;
model.result('pg5').setIndex('looplevel', 40, 0);
model.result('pg5').setIndex('looplevel', 41, 0);
model.result('pg5').run;

model.component('comp1').geom('geom1').feature('mov1').set('disply', 130);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_homogenous_fat.mph');

model.component('comp1').physics('ht').feature('init1').set('Tinit', '310.15[K]');

model.sol('sol1').runAll;

model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'0.487[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'0.52[W/(m*K)]'});

model.sol('sol1').runAll;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg4').setIndex('looplevel', 41, 0);
model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 4, 0);
model.result('pg5').setIndex('looplevel', 3, 0);
model.result('pg5').run;
model.result.export('data1').run;
model.result.export('data1').run;
model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\whole_liver_base_fine_mesh_specific_v2_liver_004.csv');
model.result.export('data1').run;
model.result('pg5').setIndex('looplevel', 41, 0);
model.result('pg5').run;
model.result('pg6').run;
model.result('pg6').feature('surf1').set('rangecoloractive', true);
model.result('pg6').feature('surf1').set('rangecolormin', 0.25);
model.result('pg6').feature('surf1').set('resolution', 'finer');
model.result('pg6').feature('surf1').set('smooth', 'everywhere');
model.result('pg6').run;
model.result('pg6').feature('con1').set('resolution', 'extrafine');
model.result('pg6').feature('con1').set('smooth', 'material');
model.result('pg6').run;
model.result.table('evl2').addRow([106.39929962158203 113.94818878173828 0.33074670926125305], [0 0 0]);
model.result('pg6').feature('con1').set('resolution', 'coarse');
model.result('pg6').run;
model.result('pg6').feature('surf1').set('resolution', 'normal');
model.result('pg6').run;
model.result('pg6').feature('surf1').set('resolution', 'coarse');
model.result('pg6').run;
model.result('pg6').feature('surf1').set('smooth', 'everywhere');
model.result('pg6').feature('surf1').set('threshold', 'manual');
model.result('pg6').feature('surf1').set('thresholdvalue', 0.5);
model.result('pg6').run;
model.result('pg6').feature('surf1').set('recover', 'pprint');
model.result('pg6').run;
model.result('pg6').feature('surf1').set('thresholdvalue', 0.7);
model.result('pg6').run;
model.result('pg6').feature('con1').set('threshold', 'manual');
model.result('pg6').feature('con1').set('thresholdvalue', 0.5);
model.result('pg6').run;
model.result.table('evl2').addRow([112.5300521850586 119.45233154296875 0.4272625368368232], [0 0 0]);
model.result.table('evl2').addRow([114.15210723876953 120.9585189819336 0.5022491610212894], [0 0 0]);
model.result.table('evl2').addRow([110.44456481933594 120.03163146972656 0.4887558089749287], [0 0 0]);
model.result('pg6').feature('con1').set('resolution', 'norefine');
model.result('pg6').run;
model.result('pg6').feature('con1').set('resolution', 'normal');
model.result('pg6').run;
model.result('pg6').feature('con1').set('number', 5);
model.result('pg6').run;
model.result('pg6').feature('con1').set('number', 10);
model.result('pg6').run;
model.result('pg6').feature('surf1').set('wireframe', true);
model.result('pg6').run;
model.result('pg6').feature('surf1').set('wireframe', false);
model.result('pg6').run;
model.result('pg6').feature('surf1').set('resolution', 'normal');
model.result('pg6').run;
model.result('pg6').feature('con1').set('legendtype', 'filled');
model.result('pg6').run;
model.result('pg6').feature('con1').set('smooth', 'everywhere');
model.result('pg6').feature('con1').set('thresholdvalue', 0.9);
model.result('pg6').run;
model.result('pg6').feature('con1').set('thresholdvalue', '.95');
model.result('pg6').run;
model.result.table('evl2').addRow([93.74922180175781 143.91253662109375 0.8187814169819436], [0 0 0]);
model.result.table('evl2').addRow([134.75814819335938 144.9474639892578 0.7053121127430857], [0 0 0]);
model.result.table('evl2').addRow([136.9573516845703 144.9474639892578 0.4201229876146178], [0 0 0]);
model.result.table('evl2').addRow([136.31053161621094 144.55935668945312 0.4769072259588063], [0 0 0]);

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg6').run;
model.result.table('evl2').addRow([111.86041259765625 118.16876983642578 0.41287835178184895], [0 0 0]);
model.result('pg6').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result.dataset.create('cpt1', 'CutPoint2D');
model.result.dataset('cpt1').set('pointx', 130);
model.result.dataset('cpt1').set('pointy', 130);
model.result.dataset('cpt1').set('data', 'cpl3');
model.result.dataset('cpt1').set('pointx', '124, 124, 124, 124, 124, 124, 124, 124');
model.result.dataset('cpt1').set('pointy', '140,135, 130, 125, 150, 155 , 160, 165');
model.result('pg1').set('windowtitle', 'Graphics');
model.result('pg3').set('windowtitle', 'Graphics');
model.result('pg12').set('windowtitle', 'Graphics');
model.result('pg11').set('windowtitle', 'Graphics');
model.result('pg10').set('windowtitle', 'Graphics');
model.result('pg9').set('windowtitle', 'Graphics');
model.result('pg8').set('windowtitle', 'Graphics');
model.result('pg7').set('windowtitle', 'Graphics');
model.result('pg6').set('windowtitle', 'Graphics');
model.result('pg5').set('windowtitle', 'Graphics');
model.result('pg4').set('windowtitle', 'Graphics');
model.result('pg2').set('windowtitle', 'Graphics');
model.result('pg13').set('window', 'window1');
model.result('pg13').set('data', 'cpt1');
model.result('pg13').set('window', 'window1');
model.result('pg13').feature('lngr1').set('expr', 'T');
model.result('pg13').feature('lngr1').set('unit', 'degC');
model.result('pg13').feature('lngr1').set('legend', true);
model.result('pg13').set('window', 'window1');
model.result('pg13').set('titletype', 'custom');
model.result('pg13').set('filenameintitle', true);
model.result('pg13').set('window', 'window1');
model.result('pg13').feature.remove('lngr1');
model.result('pg13').set('window', 'window1');
model.result('pg13').create('ptgr1', 'PointGraph');
model.result('pg13').feature('ptgr1').set('expr', 'T');
model.result('pg13').feature('ptgr1').set('unit', 'degC');
model.result('pg13').feature('ptgr1').set('legend', true);
model.result('pg13').set('window', 'window1');
model.result('pg13').run;
model.result('pg13').feature('ptgr1').set('linewidth', 3);
model.result('pg13').feature('ptgr1').set('legendmethod', 'manual');
model.result('pg13').feature('ptgr1').setIndex('legends', '(124, 140) - 5 mm down', 0);
model.result('pg13').feature('ptgr1').setIndex('legends', '(124, 135)  - 10 mm down', 1);
model.result('pg13').feature('ptgr1').setIndex('legends', '(124, 130) - 15 mm down', 2);
model.result('pg13').feature('ptgr1').setIndex('legends', '(124, 125) - 20 mm down', 3);
model.result('pg13').feature('ptgr1').setIndex('legends', '(124, 150)  - 5 mm up', 4);
model.result('pg13').feature('ptgr1').setIndex('legends', '(124, 155) - 10 mm up', 5);
model.result('pg13').feature('ptgr1').setIndex('legends', '(124, 160) - 15 mm up', 6);
model.result('pg13').feature('ptgr1').setIndex('legends', '(124, 165) - 20 mm up', 7);
model.result('pg13').set('window', 'window1');
model.result('pg13').run;
model.result('pg13').set('window', 'window1');

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');
model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg13').set('window', 'window1');
model.result.export.create('plot1', 'pg13', 'ptgr1', 'Plot');
model.result.export('plot1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\004_temps.csv');
model.result.export('plot1').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 61, 0);
model.result('pg6').run;
model.result.table('evl2').addRow([110.18193054199219 164.56301879882812 0.9687141108742138], [0 0 0]);
model.result.table('evl2').addRow([110.18193054199219 158.94671630859375 0.9999559963963086], [0 0 0]);
model.result.table('evl2').addRow([110.18193054199219 160.55137634277344 0.9999929944314228], [0 0 0]);
model.result.table('evl2').addRow([110.18193054199219 162.42349243164062 0.9967700031984653], [0 0 0]);
model.result.table('evl2').addRow([109.11215209960938 164.29559326171875 0.9662659887644399], [0 0 0]);
model.result.table('evl2').addRow([109.11215209960938 165.09791564941406 0.953815887479936], [0 0 0]);
model.result.table('evl2').addRow([109.64704132080078 166.97003173828125 0.913187465541312], [0 0 0]);
model.result.table('evl2').addRow([108.84471130371094 167.77235412597656 0.8523589167265765], [0 0 0]);
model.result.table('evl2').addRow([108.84471130371094 168.57467651367188 0.8172604579405294], [0 0 0]);
model.result.table('evl2').addRow([108.84471130371094 169.6444549560547 0.789363948264599], [0 0 0]);

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg5').setIndex('looplevel', 61, 0);
model.result('pg5').run;
model.result.dataset.create('cpl4', 'CutPlane');
model.result.dataset('cpl4').set('quickx', 120);
model.result.dataset('cpl4').set('quickplane', 'xz');
model.result.dataset('cpl4').set('quicky', 120);
model.result.dataset('cpl4').set('data', 'dset2');
model.result.duplicate('pg14', 'pg5');
model.result('pg14').set('data', 'cpl4');
model.result('pg14').run;
model.result('pg14').feature('surf1').set('colortable', 'ThermalLight');
model.result('pg14').run;
model.result.export.create('plot2', 'pg14', 'surf1', 'Plot');
model.result.export('plot2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\004_temps_surface.csv');
model.result.export('plot2').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');
model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\COMSOL_DATA_245_GHZ_Material_parameters\whole_liver_base_fine_mesh_specific_v2_liver_004_245.csv');

model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'1.69[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'43'});

model.sol('sol1').updateSolution;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg6').run;
model.result.table('evl2').addRow([108.77842712402344 165.63177490234375 0.9365953711130117], [0 0 0]);

model.sol('sol1').updateSolution;

model.result('pg6').run;
model.result.table('evl2').addRow([107.87567138671875 165.45123291015625 0.9326061826587599], [0 0 0]);
model.result.table('evl2').addRow([110.94505310058594 166.8956298828125 0.9110197536374367], [0 0 0]);
model.result.table('evl2').addRow([110.94505310058594 168.34005737304688 0.8124230638418919], [0 0 0]);
model.result.export('data1').run;
model.result('pg5').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg6').run;

model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').contribute('physics/emw', true);
model.component('comp1').mesh('mesh1').run;

model.study('std1').setGenPlots(false);
model.study('std1').setGenPlots(true);
model.study('std1').setStoreSolution(false);
model.study('std1').setPlotUndefVals(false);

model.sol('sol1').runAll;

model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 61, 0);
model.result('pg6').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg6').run;
model.result('pg6').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg6').run;
model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\COMSOL_DATA_245_GHZ_Material_parameters\whole_liver_base_fine_mesh_specific_v2_liver_004_245_recompute.csv');

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg5').setIndex('looplevel', 61, 0);
model.result('pg5').run;
model.result('pg6').run;
model.result('pg4').run;
model.result('pg4').setIndex('looplevel', 61, 0);
model.result('pg4').run;
model.result('pg4').set('data', 'cpl4');
model.result('pg4').run;
model.result('pg4').set('data', 'cpl3');
model.result('pg4').run;

model.param.set('sigma_liver', '1.69[S/m]');
model.param.set('eps_liver', '43');
model.param.set('k_liver', '0.52[W/(m*K)]');

model.result('pg5').run;
model.result.table('evl2').addRow([111.14170837402344 166.93319702148438 0.9173940541361074], [0 0 0]);
model.result.table('evl2').addRow([111.51161193847656 165.45358276367188 0.995546123797137], [0 0 0]);
model.result.table('evl2').addRow([110.95675659179688 166.10092163085938 0.9467793700459087], [0 0 0]);
model.result.table('evl2').addRow([110.58685302734375 166.10092163085938 0.9407657609841339], [0 0 0]);
model.result.export('data1').run;
model.result('pg6').setIndex('looplevel', 41, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 37, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 33, 0);
model.result('pg6').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.component('comp1').geom('geom1').feature('mov1').set('disply', 140);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').automatic(false);
model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg6').setIndex('looplevel', 61, 0);
model.result('pg6').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');
model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result.export('data1').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg13').set('window', 'window1');
model.result('pg13').run;
model.result('pg5').run;
model.result.dataset('cpt1').set('pointx', '133, 133, 133, 133, 133, 133, 133, 133');
model.result('pg13').set('window', 'window1');
model.result('pg13').run;
model.result.table('evl2').addRow([132.0063018798828 143.98306274414062 257.34008694644535], [0 0 0]);
model.result.table('evl2').addRow([132.05860900878906 143.99179077148438 257.55977521457976], [0 0 0]);
model.result.table('evl2').addRow([132.16322326660156 143.98306274414062 257.84881089606046], [0 0 0]);
model.result.table('evl2').addRow([183.79534912109375 159.48907470703125 37.00624600393653], [0 0 0]);
model.result.table('evl2').addRow([131.85641479492188 143.8430633544922 255.6408658391511], [0 0 0]);
model.result.table('evl2').addRow([131.85641479492188 143.8430633544922 255.6408658391511], [0 0 0]);
model.result.table('evl2').addRow([131.85641479492188 143.8430633544922 255.6408658391511], [0 0 0]);

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004.mph');

model.result('pg5').run;
model.result.dataset('cpt1').set('pointx', '132, 132, 132, 132, 132, 132, 132, 132');
model.result('pg6').run;
model.result('pg13').set('window', 'window1');
model.result('pg13').run;
model.result.table('evl2').addRow([83.33192443847656 121.94770812988281 37.83048362100621], [0 0 0]);
model.result.export('plot1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\004_temps_245.csv');
model.result.export('plot1').run;

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'3400[J/(kg*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'0.51[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'49'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'.86[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'1050[kg/m^3]'});

model.param.set('P_in', '60[W]');
model.param.set('rho_liver', '1050   [kg/m^3]');
model.param.descr('rho_liver', 'Desnity Liver');
model.param.set('cp_liver', '3400  [J/(kg*K)]');
model.param.descr('cp_liver', 'Heat Capacity at a Constant Pressure');
model.param.set('rho_liver', '1050   [kg/m^3]', 'Desnity Liver');
model.param.set('rho_liver', '1050   [kg/m^3]');
model.param.descr('rho_liver', 'Desnity Liver');
model.param.set('cp_liver', '3400  [J/(kg*K)]', 'Heat Capacity at a Constant Pressure');
model.param.set('cp_liver', '3400  [J/(kg*K)]');
model.param.descr('cp_liver', 'Heat Capacity at a Constant Pressure');
model.param.set('k_liver', '0.52  [W/(m*K)]');
model.param.set('sigma_liver', '1.69  [S/m]');
model.param.set('k_liver', '0.51  [W/(m*K)]');
model.param.set('sigma_liver', '.86  [S/m]');
model.param.set('eps_liver', '49.03');
model.param.set('Cp_blood', '3639[J/(kg*K)]');
model.param.set('f', '915 [MHz]');
model.param.set('P_in', '60  [W]');

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'cp_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'rho_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'0.51[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'eps_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'sigma_liver'});

model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').autoMeshSize(3);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').autoMeshSize(2);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').autoMeshSize(4);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').autoMeshSize(2);
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.component('comp1').mesh('mesh1').autoMeshSize(1);
model.component('comp1').mesh('mesh1').run;

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\COMSOL_DATA_245_GHZ_Material_parameters\_liver_004_915_MHZ_Deshazer.csv');
model.result('pg6').run;
model.result('pg5').run;
model.result.table('evl2').addRow([91.64076232910156 152.638427734375 0.9999999999999999], [0 0 0]);
model.result.table('evl2').addRow([83.04130554199219 151.5464324951172 1], [0 0 0]);
model.result.table('evl2').addRow([80.17481994628906 141.1724853515625 0.9998405714591708], [0 0 0]);
model.result('pg6').setIndex('looplevel', 41, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 17, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 1, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 5, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 7, 0);
model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 61, 0);
model.result('pg6').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_915_mhz_Deshazer.mph');

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\COMSOL_DATA_245_GHZ_Material_parameters\liver_004_915_MHZ_Deshazer.csv');
model.result.export('data1').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_915_mhz_Deshazer.mph');

model.param.set('eps_liver', '46.8');
model.param.set('sigma_liver', '.861  [S/m]');
model.param.set('k_liver', '0.520  [W/(m*K)]');

model.sol('sol1').runAll;

model.result.export('data1').run;

model.component('comp1').mesh('mesh1').autoMeshSize(2);
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg6').run;
model.result('pg6').setIndex('looplevel', 26, 0);
model.result('pg6').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_915_mhz_Deshazer.mph');

model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 130);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 139);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').runPre('fin');

model.component('comp1').mesh('mesh1').run('size4');
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result.export('data1').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_915_mhz_Deshazer.mph');

model.result.dataset('cpl4').set('quicky', 136);
model.result('pg14').setIndex('looplevel', 61, 0);
model.result('pg14').run;
model.result('pg14').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg14').run;
model.result.export('plot2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\004_temps_surface_915_MHZ.csv');
model.result.export('plot2').run;
model.result.export('plot2').run;
model.result.export('plot2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Temps\004_temps_surface_915_MHZ.csv');
model.result.export('plot2').run;
model.result.export.create('data2', 'cpl4', 'Data');
model.result.export('data2').setIndex('expr', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Temps\004_homogenous_fat_temps_surface_915_MHZ.csv', 0);
model.result.export('data2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Temps\004_homogenous_fat_temps_surface_915_MHZ.csv');
model.result.export('data2').setIndex('expr', 'emw.Qh', 0);
model.result.export('data2').run;
model.result.export('data2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Temps\004__Power_Dissipation_surface_915_MHZ.csv');
model.result.export('data2').run;
model.result.export('plot2').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_915_mhz_Deshazer.mph');

model.result('pg14').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_915_mhz_Deshazer.mph');

model.component('comp1').physics('ht').feature('bt1').feature('tdam1').set('TransformationModel', 'TemperatureThreshold');

model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\COMSOL_DATA_245_GHZ_Material_parameters\liver_004_915_MHZ_Deshazerr_temp_threshold.csv');
model.result.export('data1').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_915_mhz_Deshazer.mph');

model.component('comp1').physics('ht').create('temp1', 'TemperatureBoundary', 2);
model.component('comp1').physics('ht').feature('temp1').selection.set([1 2 3 4 5 41]);
model.component('comp1').physics('ht').feature('temp1').set('T0', '310.15[K]');

model.param.set('eps_cat', '1');

model.component('comp1').physics('ht').feature('bt1').feature('tdam1').set('TransformationModel', 'ArrheniusKinetics');

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Tumor_Collins\liver_004_915_MHZ_Deshazer.csv');
model.result.export('data1').run;

model.label('whole_liver_base_fine_mesh_specific_v2_liver_004_915_mhz_Deshazer.mph');

model.result('pg4').run;

model.component('comp1').physics('emw').feature('sctr1').selection.set([2 3 4 5 6 7 8 9 10 11 12 15 16 17 18 19 20 21 22 23 24 28 29 30 31 32 33 34 35 38 40 41]);

model.result('pg6').run;

model.component('comp1').mesh('mesh1').run;

model.component('comp1').physics('emw').create('sctr2', 'Scattering', 2);
model.component('comp1').physics('emw').feature.remove('sctr2');

model.component('comp1').geom('geom1').feature('imp1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL\COMSOL_PROBE.mphbin');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 125);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').material('mat2').selection.set([7]);
model.component('comp1').material('mat4').selection.set([9 10]);

model.component('comp1').physics('emw').feature('port1').selection.set([46 47 66 69]);
model.component('comp1').physics('emw').feature('sctr1').selection.set([2 3 4 5 14 31 51 62 109]);
model.component('comp1').physics('emw').feature('pec2').active(false);
model.component('comp1').physics('ht').selection.set([1]);

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg4').run;
model.result('pg5').run;

model.component('comp1').physics('emw').selection.set([1 4 6 7 8 9 10]);

model.component('comp1').material('mat3').selection.set([2 3 4 9 10]);

model.sol('sol1').runAll;

model.result('pg5').run;
model.result('pg5').run;
model.result('pg4').run;
model.result('pg5').setIndex('looplevel', 2, 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 61, 0);
model.result('pg5').run;

model.sol('sol1').runAll;

model.result('pg5').run;

model.component('comp1').physics('emw').selection.set([1 2 3 4 5 6 7 8 9 10]);

model.component('comp1').material('mat3').selection.set([2 3 4 5 9 10]);

model.component('comp1').physics('emw').selection.set([1 2 3 4 5 7 9 10]);

model.component('comp1').material('mat1').selection.set([1]);

model.sol('sol1').runAll;

model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 21, 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 37, 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 61, 0);
model.result('pg5').run;

model.component('comp1').physics('emw').selection.set([1 2 4 7 9 10]);
model.component('comp1').physics('ht').selection.set([1 3 5]);

model.component('comp1').material('mat3').propertyGroup('def').set('relpermittivity', {});
model.component('comp1').material('mat3').propertyGroup('def').set('relpermeability', {});
model.component('comp1').material('mat3').propertyGroup('def').set('electricconductivity', {});
model.component('comp1').material('mat3').propertyGroup('def').set('relpermittivity', {'eps_cat'});
model.component('comp1').material('mat3').propertyGroup('def').set('relpermeability', {'1'});
model.component('comp1').material('mat3').propertyGroup('def').set('electricconductivity', {'0'});
model.component('comp1').material('mat3').propertyGroup('def').set('thermalconductivity', {'K2'});
model.component('comp1').material('mat3').propertyGroup('def').set('density', {'1079[kg/m^3]'});
model.component('comp1').material('mat3').propertyGroup('def').set('heatcapacity', {'C2'});
model.component('comp1').material('mat3').propertyGroup('def').set('frequencyfactor', {'ATest'});
model.component('comp1').material('mat3').propertyGroup('def').set('activationenergy', {'1e30'});

model.param.set('T_init', '310.15 [K]');
model.param.descr('T_init', 'temperature, initial');
model.param.set('T_necro', '353[K]');
model.param.descr('T_necro', 'temperature, necrosis');
model.param.set('time_step', '15 [s]');
model.param.descr('time_step', 'time, step');
model.param.set('time_end', '900[s]');
model.param.descr('time_end', 'time, end');
model.param.set('w_tissue', '48');
model.param.descr('w_tissue', 'diameter, tissue');
model.param.set('h_tissue', '26.8844');
model.param.descr('h_tissue', 'height minus probe depth, tissue');
model.param.set('d_probe', '55.9356');
model.param.descr('d_probe', 'depth, probe');
model.param.set('K1', '0.272580976267724');
model.param.descr('K1', '');
model.param.set('S1', '0.187626600378728');
model.param.descr('S1', '');
model.param.set('E1', '60.9122091900363');
model.param.descr('E1', '');
model.param.set('C1', '1417.02563272972');
model.param.descr('C1', '');
model.param.set('ATest', '1.88e41 [1/s]');
model.param.descr('ATest', '');
model.param.set('EATest', '2.8e5 [J/mol]');
model.param.descr('EATest', '');
model.param.set('htcoef', '980');
model.param.descr('htcoef', '');
model.param.set('T_probe', '293.15');
model.param.descr('T_probe', '');
model.param.set('K2', '1');
model.param.descr('K2', '');
model.param.set('S2', '0');
model.param.descr('S2', '');
model.param.set('E2', '2');
model.param.descr('E2', '');
model.param.set('C2', '2030');
model.param.descr('C2', '');
model.param.set('T_init', '310.15 [K]', 'temperature, initial');
model.param.set('T_init', '310.15 [K]');
model.param.descr('T_init', 'temperature, initial');
model.param.set('T_necro', '353[K]', 'temperature, necrosis');
model.param.set('T_necro', '353[K]');
model.param.descr('T_necro', 'temperature, necrosis');
model.param.set('time_step', '15 [s]', 'time, step');
model.param.set('time_step', '15 [s]');
model.param.descr('time_step', 'time, step');
model.param.set('time_end', '900[s]', 'time, end');
model.param.set('time_end', '900[s]');
model.param.descr('time_end', 'time, end');
model.param.set('w_tissue', '48', 'diameter, tissue');
model.param.set('w_tissue', '48');
model.param.descr('w_tissue', 'diameter, tissue');
model.param.set('h_tissue', '26.8844', 'height minus probe depth, tissue');
model.param.set('h_tissue', '26.8844');
model.param.descr('h_tissue', 'height minus probe depth, tissue');
model.param.set('d_probe', '55.9356', 'depth, probe');
model.param.set('d_probe', '55.9356');
model.param.descr('d_probe', 'depth, probe');
model.param.set('K1', '0.272580976267724');
model.param.descr('K1', '');
model.param.set('S1', '0.187626600378728');
model.param.descr('S1', '');
model.param.set('E1', '60.9122091900363');
model.param.descr('E1', '');
model.param.set('C1', '1417.02563272972');
model.param.descr('C1', '');
model.param.set('ATest', '1.88e41 [1/s]');
model.param.descr('ATest', '');
model.param.set('EATest', '2.8e5 [J/mol]');
model.param.descr('EATest', '');
model.param.set('htcoef', '980');
model.param.descr('htcoef', '');
model.param.set('T_probe', '293.15');
model.param.descr('T_probe', '');
model.param.set('K2', '1');
model.param.descr('K2', '');
model.param.set('S2', '0');
model.param.descr('S2', '');
model.param.set('E2', '2');
model.param.descr('E2', '');
model.param.set('C2', '2030');
model.param.descr('C2', '');

model.sol('sol1').runAll;

model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 61, 0);
model.result('pg5').run;
model.result.table('evl2').addRow([112.59426879882812 134.72300720214844 111.61035222285359], [0 0 0]);

model.component('comp1').material('mat2').selection.set([6 7 8]);

model.component('comp1').physics('emw').selection.set([1 2 4 6 7 8 9 10]);

model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg5').run;

model.component('comp1').physics('emw').selection.set([1 2 4 6 9 10]);

model.component('comp1').mesh('mesh1').run;

model.component('comp1').material('mat2').selection.set([7]);

model.component('comp1').physics('emw').selection.set([1 2 4 7 9 10]);

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 35, 0);
model.result('pg5').run;

model.component('comp1').physics('ht').create('hf1', 'HeatFluxBoundary', 2);
model.component('comp1').physics('ht').feature('hf1').selection.set([29 30 37 38 41 42 76 81]);
model.component('comp1').physics('ht').selection.set([1 3 4 5]);
model.component('comp1').physics('ht').feature('hf1').selection.set([29 30 33 34 37 38 41 42 76 81 86 91 96 101 105 106]);
model.component('comp1').physics('ht').feature('hf1').set('HeatFluxType', 'ConvectiveHeatFlux');
model.component('comp1').physics('ht').feature('hf1').set('h', 'htcoef');
model.component('comp1').physics('ht').feature('hf1').set('Text', 'T_probe');

model.sol('sol1').runAll;

model.result('pg5').run;
model.result('pg3').run;
model.result('pg3').setIndex('looplevel', 5, 0);
model.result('pg3').run;
model.result('pg3').feature('con1').set('expr', 'T');
model.result('pg3').feature('con1').set('unit', 'degC');
model.result('pg3').run;
model.result('pg5').feature('con1').set('number', 20);
model.result('pg5').run;

model.component('comp1').physics('ht').feature('temp1').set('T0', 295.25);
model.component('comp1').physics('ht').feature('init1').set('Tinit', 'T_init');

model.sol('sol1').runAll;

model.result('pg4').run;
model.result('pg5').run;

model.component('comp1').physics('ht').feature('bt1').feature('bh1').set('Tb', 'T_init');

model.component('comp1').material('mat1').propertyGroup('def').set('frequencyfactor', {'ATest'});
model.component('comp1').material('mat1').propertyGroup('def').set('activationenergy', {'EATest'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'C1'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'1079[kg/m^3]'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('frequencyfactor', {'ATest'});
model.component('comp1').material('mat1').propertyGroup('def').set('activationenergy', {'EATest'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'eps_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'sigma_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'C1'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'1079[kg/m^3]'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('frequencyfactor', {'ATest'});
model.component('comp1').material('mat1').propertyGroup('def').set('activationenergy', {'EATest'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'eps_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'sigma_liver'});

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 61, 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevel', 53, 0);
model.result('pg5').run;

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'cp_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'rho_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('frequencyfactor', {'7.39E+39'});
model.component('comp1').material('mat1').propertyGroup('def').set('activationenergy', {'257700'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'eps_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'sigma_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', {'cp_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', {'rho_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('frequencyfactor', {'7.39E+39'});
model.component('comp1').material('mat1').propertyGroup('def').set('activationenergy', {'257700'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'eps_liver'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'sigma_liver'});
model.component('comp1').material('mat3').propertyGroup('def').set('frequencyfactor', {'7.39E+39'});

model.sol('sol1').runAll;

model.result('pg5').run;
model.result('pg6').setIndex('looplevel', 61, 0);
model.result('pg6').run;

model.param.set('k_liver', '.271   [W/(m*K)]');
model.param.set('sigma_liver', '.634 [S/m]');
model.param.set('eps_liver', '36.20');

model.sol('sol1').runAll;

model.component('comp1').geom('geom1').run('wp1');
model.component('comp1').geom('geom1').create('sph1', 'Sphere');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [135 130 145]);
model.component('comp1').geom('geom1').feature('sph1').set('r', 10);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [135 125 145]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [135 129 145]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [135 120 145]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [135 119 145]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [135 118 145]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').feature('sph1').active(false);
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('sph1').active(true);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat5', 'Common');
model.component('comp1').material('mat5').label('Tumor 915 MHZ - Deshazer');
model.component('comp1').material('mat5').propertyGroup('def').set('heatcapacity', '3400[J/(kg*K)]');
model.component('comp1').material('mat5').propertyGroup('def').set('density', '1050[kg/m^3]');
model.component('comp1').material('mat5').propertyGroup('def').set('thermalconductivity', {'.624[W/(m*K)]' '0' '0' '0' '.624[W/(m*K)]' '0' '0' '0' '.624[W/(m*K)]'});
model.component('comp1').material('mat5').propertyGroup('def').set('frequencyfactor', '7.39E+39');
model.component('comp1').material('mat5').propertyGroup('def').set('activationenergy', '257700');
model.component('comp1').material('mat5').propertyGroup('def').set('relpermittivity', {'55.7' '0' '0' '0' '55.7' '0' '0' '0' '55.7'});
model.component('comp1').material('mat5').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat5').propertyGroup('def').set('electricconductivity', {'1.24[S/m]' '0' '0' '0' '1.24[S/m]' '0' '0' '0' '1.24[S/m]'});
model.component('comp1').material('mat5').set('groups', {});
model.component('comp1').material('mat5').set('family', 'plastic');
model.component('comp1').material('mat5').selection.set([2]);

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg4').run;
model.result('pg6').run;

model.param.set('eps_liver', '46.8');
model.param.set('sigma_liver', '.861 [S/m]');
model.param.set('k_liver', '.521   [W/(m*K)]');

model.sol('sol1').runAll;

model.label('004_915_mhz_COLLINS_Probe_Healthy_Tissue_with_tumor .mph');

model.component('comp1').geom('geom1').feature('sph1').active(false);
model.component('comp1').geom('geom1').feature('imp2').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\Liver_001_v2_smooth_remesh.stl');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displz', 140);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('displx', 120);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 170);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 180);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 181);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 182);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('mov1').set('disply', 176);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').material('mat5').selection.set([]);

model.component('comp1').physics('emw').feature('sctr1').selection.set([1 2 3 4 5 6 7 8 17 112]);
model.component('comp1').physics('ht').feature('temp1').selection.set([1 2 3 4 5 6 7 8 112]);
model.component('comp1').physics('ht').feature('hf1').selection.set([32 33 36 37 40 41 44 45 79 84 89 94 99 104 108 109]);

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.param.set('k_liver', '.461  [W/(m*K)]');
model.param.set('sigma_liver', '.831 [S/m]');
model.param.set('eps_liver', '45.4');

model.sol('sol1').runAll;

model.component('comp1').geom('geom1').feature('sph1').active(true);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [120 118 140]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [120 176 140]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [120 170 140]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [120 171 140]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('sph1').set('pos', [120 169 140]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.label('001_915_mhz_COLLINS_Probe_Fatty_Tissue_with_tumor.mph');

model.sol('sol1').runAll;

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Tumor_Collins\liver_001_915_MHZ_Collins_Deshazer.csv');
model.result.export('data1').run;

model.label('001_915_mhz_COLLINS_Probe_Fatty_Tissue_with_tumor.mph');

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Tumor_Collins\liver_001_Fatty_915_MHZ_Collins_Deshazer.csv');
model.result.export('data1').run;
model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\915_MHZ_Tumor_Collins\liver_001_Fatty_915_MHZ_Collins_Deshazer_with_tumor.csv');
model.result.export('data1').run;

model.label('001_915_mhz_COLLINS_Probe_Fatty_Tissue_with_tumor.mph');

model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params - With Tumor\liver_001_915_Fatty_MHZ_Collins_Deshazer_with_tumor.csv');
model.result('pg6').run;
model.result.dataset('cpl3').set('quickx', 120);
model.result('pg4').run;
model.result.export('data1').set('filename', 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\COMSOL_DATA\COMSOL 3D MODELS\915_MHZ_Models_COLINS_Probe_Deshzaer_Params - With Tumor\liver_001_915_MHZ_Fatty_Collins_Deshazer_with_tumor.csv');
model.result.export('data1').run;

model.label('001_915_mhz_COLLINS_Probe_Fatty_Tissue_with_tumor.mph');

model.component('comp1').physics('ht').feature('temp1').set('T0', 'T_init');
model.component('comp1').physics('ht').feature('bt1').set('minput_strainreferencetemperature', 'T_init');
model.component('comp1').physics('ht').prop('PhysicalModelProperty').set('Tref', 'T_init');
model.component('comp1').physics('emw').feature('wee1').set('minput_temperature_src', 'userdef');
model.component('comp1').physics('emw').feature('wee1').set('minput_temperature', 'T_init');

model.param.set('omega_blood', '.017 [1/s]');

model.sol('sol1').runAll;

model.result('pg6').run;

model.label('001_915_mhz_COLLINS_Probe_Fatty_Tissue_with_tumor.mph');

model.result.export('data1').run;

model.label('001_915_mhz_COLLINS_Probe_Fatty_Tissue_with_tumor.mph');

out = model;
