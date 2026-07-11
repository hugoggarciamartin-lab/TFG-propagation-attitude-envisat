function [Sat, Env, Sim, init_orb, init_att] = init_sim()
% INIT_SIM Initializes simulation, environment, and satellite configuration structures.
%
% Outputs:
%   Sat: Structure containing satellite physical parameters (inertia, magnets, etc.)
%   Env: Structure containing environmental models (geopotential, geomagnetism, time)
%   Sim: Structure containing simulation settings (time span, tolerances)
%   init_orb: Initial orbital state vector [r0, v0]
%   init_att: Initial attitude state vector [q0, Omega0]

% Load initial conditions and data files
init_conditions();
load('cond_inicial.mat');

% Environment Structure (Env)
Env.gamma0 = gmst(y, m, d, hutc);

coef_geomagn14();
load('coef_geomagn14.mat');
Env.g = g; Env.h = h; Env.OrdM = OrdM;

coef_egm96_10();
load('coef_egm96_10.mat');
Env.C = C; Env.S = S; Env.OrdG = OrdG;

% Satellite Structure (Sat)
Sat.Cd = Cd; Sat.mass = mass; Sat.Aref = Aref;
Sat.Ix = Ix; Sat.Iy = Iy; Sat.Iz = Iz;
Sat.Mresid = Mresid; Sat.G = G;

% Simulation Structure (Sim)
Sim.tspan = t0:paso:tend;
Sim.t0 = t0; Sim.tend = tend;
Sim.convenio = convenio;
Sim.options = odeset('RelTol', 1e-8, 'AbsTol', 1e-10, 'Stats', 'on');

% Initial State Vectors
init_orb = [r0, v0];
init_att = [q_0, Omega0];

disp(['IGRF-14 model order and degree: ', num2str(OrdM)]);
disp(['EGM96 model order and degree: ', num2str(OrdG)]);
end