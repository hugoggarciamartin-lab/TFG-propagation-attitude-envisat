function odesys = ecs_attitude(t, estado, Sat, Env, Sim)
% ECS_ACTITUD Computes attitude dynamics including gravitational gradient and magnetic torques.
%
% Inputs:
%   t: Time [s]
%   estado: Attitude state [quaternions; angular velocities]
%   Sat: Satellite structure (Ix, Iy, Iz, Mresid, G)
%   Env: Environment structure (gamma0, g, h, OrdM)
%   Sim: Simulation structure (convenio, rinterp, vinterp)
% Outputs:
%   odesys: Attitude state derivatives [dQ_dt; domega_dt]

Ix = Sat.Ix; Iy = Sat.Iy; Iz = Sat.Iz; Mresid = Sat.Mresid; G = Sat.G;
gamma0 = Env.gamma0; g = Env.g; h = Env.h; OrdM = Env.OrdM;
convenio = Sim.convenio; rinterp = Sim.rinterp; vinterp = Sim.vinterp;

q = estado(1:4);
q = q / norm(q);
omega = estado(5:7);

reci = rinterp(t);
veci = vinterp(t);
mu = 3.986e14; w_e = 7.2921150e-5;

% Quaternion derivative
dQ_dt = [0.5*(-q(2)*omega(1) - q(3)*omega(2) - q(4)*omega(3));
    0.5*(q(1)*omega(1) - q(4)*omega(2) + q(3)*omega(3));
    0.5*(q(4)*omega(1) + q(1)*omega(2) - q(2)*omega(3));
    0.5*(-q(3)*omega(1) + q(2)*omega(2) + q(1)*omega(3))];

% Coordinate transformation ECI to Body
dcm = quat2DCM(q.');
if strcmp(convenio, '313')
    Reci2body = trasp(dcm);
else
    Rlvlh2body = trasp(dcm);
    ex = veci / norm(veci);
    ez = cross(reci, veci) / norm(cross(reci, veci));
    ey = cross(ez, ex) / norm(cross(ez, ex));
    Reci2body = Rlvlh2body * [ex.'; ey.'; ez.'];
end

% Perturbation torques
[rx, ry, rz] = deal(1e3 * dot(reci.', Reci2body(1,:)), ...
    1e3 * dot(reci.', Reci2body(2,:)), ...
    1e3 * dot(reci.', Reci2body(3,:)));
Rn = norm([rx, ry, rz]);
Ng = [3*mu/Rn^5 * (Iz - Iy) * ry * rz;
    3*mu/Rn^5 * (Ix - Iz) * rz * rx;
    3*mu/Rn^5 * (Iy - Ix) * rx * ry];

% Magnetic torque
Recef2eci = rot_matrix(w_e*t + gamma0, 'Z');
[Bx, By, Bz] = geomagn_cartesian_field(dot(Recef2eci(:,1), reci), dot(Recef2eci(:,2), reci), dot(Recef2eci(:,3), reci), g, h, OrdM);
B_body = Reci2body * Recef2eci * [Bx; By; Bz] * 1e-9;
Tm = cross(Mresid, B_body.') + cross(G * cross(omega, B_body.').', B_body);

% Angular acceleration
domega_dt = [omega(2)*omega(3)*((Iy - Iz)/Ix) + (Ng(1) + Tm(1))/Ix;
    omega(1)*omega(3)*((Iz - Ix)/Iy) + (Ng(2) + Tm(2))/Iy;
    omega(1)*omega(2)*((Ix - Iy)/Iz) + (Ng(3) + Tm(3))/Iz];

odesys = [dQ_dt; domega_dt];
end