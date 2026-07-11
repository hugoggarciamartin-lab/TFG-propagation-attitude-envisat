function odesys = ecs_orbit(t, estado_orb, Env, Sat)
% ECS_ORBIT Computes orbital dynamics perturbed by EGM96 geopotential and atmospheric drag.
%
% Inputs:
%   t: Time [s]
%   estado_orb: Orbital state [position; velocity]
%   Env: Environment structure (gamma0, C, S, OrdG)
%   Sat: Satellite structure (Cd, mass, Aref)
% Outputs:
%   odesys: Orbital state derivatives [velocity; acceleration]

gamma0 = Env.gamma0; C = Env.C; S = Env.S; OrdG = Env.OrdG;
Cd = Sat.Cd; mass = Sat.mass; Aref = Sat.Aref;

reci = estado_orb(1:3);
veci = estado_orb(4:6);
w_e = 7.2921150e-5;

% Coordinate transformation ECI to ECEF
Recef2eci = rot_matrix(w_e*t + gamma0, 'Z');
recef = Recef2eci.' * reci;

% Geopotential accelerations (EGM-96)
[ax_ecef, ay_ecef, az_ecef] = geopoten_ecef_cartesian(recef(1), recef(2), recef(3), C, S, OrdG);
feci_geo = Recef2eci * [ax_ecef; ay_ecef; az_ecef];

% Atmospheric drag
f_drag = drag_exp(Cd, mass, Aref, reci, veci);

% Total acceleration
acceci = - feci_geo + f_drag;

odesys = zeros(6,1);
odesys(1:3) = veci;
odesys(4:6) = acceci;
end