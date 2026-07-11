function init_conditions()
% INIT_CONDITIONS Defines and saves the initial state and parameters for the 6-DOF simulation.
%
% Inputs: 
%   None
% Outputs: 
%   Saves 'cond_inicial.mat' with epoch, orbital state, inertia, drag parameters, and integration limits.
%
% Note: Core variable names (e.g., y, m, d, hutc) MUST NOT be altered, as they are strict 
% dependencies for the data loading sequence in 'init_sim.m'.

% Epoch
[y, m, d, hutc] = deal(2013, 09, 25, 12);
convenio = '321';               % Select convention: Euler (313) or Tait-Bryan (321)
orbit_select = 'kepler';        % Select orbital vector type: Keplerian (kepler) [a,e,inc,RAAN,argperig,nu];
% or ECI state vector (vstate) [r, v]

% Initial position [km] and velocity [km/s] in the ECI frame
r0 = [6312.3, -3424.6, 1246.5];
v0 = [3.547, 6.440, -2.344];

% Data for the Envisat satellite:
% Keplerian parameters in km and sexagesimal degrees
[sma, ecc, inc, raan, argperig, nu] = deal(7141, 0, 98.4, 0, 0, 0);

% Depending on the orbit_select flag, compute the correct initial state vector
if strcmp(orbit_select,'vstate')
    disp('Using ECI state vector.');

elseif strcmp(orbit_select, 'kepler')
    disp('Using Keplerian orbital parameters.');
    [r0,v0] = kepler2vstate(sma,ecc,inc,raan,argperig,nu);
end

% Moments of inertia in principal body axes [kg*m^2]
Ix = 129180.25;
Iy = 124801.21;
Iz = 16979.74;

% Residual magnetic dipole moment of the orbiting body in principal axes [A*m^2]
Mresid = [0.0, 0, 0];

% Ballistic data for drag estimation
mass = 8211;        % Body mass [kg]
Cd = 3;             % Aerodynamic drag coefficient
Aref = 75;          % Reference area for aerodynamic calculation [m^2]

% Magnetic tensor [S*m^4]: dependent on material conductivity
G = [1.059, 0, 0; 0, 1.059, 0; 0, 0, 0.93515] * 1e6;

% Initial angles [rad]
psi0 = deg2rad(90);
theta0 = deg2rad(62);
phi0 = deg2rad(0);
q_0 = Eul2quat(psi0,theta0,phi0,convenio);

% Initial angular velocities in the Inertial frame (ECI) [rad/s]
omegax0 = deg2rad(1.2535);
omegay0 = deg2rad(0);
omegaz0 = deg2rad(2.3575);

% Initial angular velocities in the Body frame [rad/s]
Omega0 = [omegax0, omegay0, omegaz0];

% Orbit propagation time settings
t0 = 0;                  % Start time for data extraction [s]
paso = 0.3;              % Output time step [s]
tend = 1000;             % Propagation end time [s]

save('cond_inicial.mat');

end