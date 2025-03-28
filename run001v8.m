%% Set initial parameter values
% tissue properties
s1a = 0.35;
s1b = 0.35;

e1a = 20;
e1b = 20;

c1a = 4.5e3;
c1b = 4.5e3;
c1c = 4.5e3;

k1a = 1.3;
k1b = 1.3;

% catheter properties
s2 = 0;
e2 = 2;
c2 = 2.6e3;
k2 = 1.1;

% cooling properties
htcoef = 1.1e3;
Tprobe = 295;

% edge boundary condition
Tboundary = 295;

% store parameters
params = [s1a s1b e1a e1b c1a c1b c1c k1a k1b s2 e2 c2 k2 htcoef Tprobe Tboundary];

%% Call simplex minimization
options = optimset('Display','iter','MaxFunEvals', 5000, 'TolFun', 1e-2, 'TolX', 1e-2);
[x, fval] = fminsearch(@optimize001v8, params, options);

