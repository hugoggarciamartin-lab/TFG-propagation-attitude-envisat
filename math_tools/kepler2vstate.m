function [reci, veci] = kepler2vstate(sma, ecc, inc, raan, argperig, nu)
% KEPLER2VSTATE Converts Keplerian orbital elements to ECI state vectors.
%
% Inputs:
%   sma, ecc, inc, raan, argperig, nu: Orbital parameters
% Outputs:
%   reci: Position vector in ECI [km]
%   veci: Velocity vector in ECI [km/s]

mu = 3.986e5;
inc = deg2rad(inc); raan = deg2rad(raan); argperig = deg2rad(argperig); nu = deg2rad(nu);
p = sma * (1 - ecc^2);
h = sqrt(mu * p);
r_c = p / (1 + ecc * cos(nu));
r_p = [r_c * cos(-nu); r_c * sin(-nu); 0];
v_p = [-(mu/h) * sin(-nu); (mu/h) * (ecc + cos(-nu)); 0];
R = [cos(raan), -sin(raan), 0; sin(raan), cos(raan), 0; 0, 0, 1] * ...
    [1, 0, 0; 0, cos(inc), -sin(inc); 0, sin(inc), cos(inc)] * ...
    [cos(argperig), -sin(argperig), 0; sin(argperig), cos(argperig), 0; 0, 0, 1];
reci = (R * r_p).';
veci = (R * v_p).';
end