function [Ng, Tm, Tgeopot, Tmagnet] = graf_torques_igrf(t, data_orbit, data_out, Sim, Sat, Env)
% GRAF_TORQUES_IGRF Calculates and plots disturbance torques in the body frame.
%
% Inputs:
%   t: Time vector [s]
%   data_orbit: Orbital state matrix from propagation
%   data_out: Attitude state matrix from propagation
%   Sim: Simulation configuration structure
%   Sat: Satellite physical parameters structure
%   Env: Environmental models structure
% Outputs:
%   Ng, Tm: Gravity gradient and magnetic torque vectors [Nm]
%   Tgeopot, Tmagnet: Torque magnitudes [Nm]

% Structure unpacking
convenio = Sim.convenio;
Ix = Sat.Ix; Iy = Sat.Iy; Iz = Sat.Iz; Mresid = Sat.Mresid; G = Sat.G;
g = Env.g; h = Env.h; OrdM = Env.OrdM; gamma0 = Env.gamma0;

q = data_out(:,1:4);
omega = data_out(:,5:7);
reci = data_orbit(:,1:3);
veci = data_orbit(:,4:6);
DCM = quat2DCM(q);

% Physical constants
mu = 3.986e14;               % Earth gravitational parameter [km^3/s^2]
w_e = 7.272e-5;              % Earth angular velocity [rad/s]

Ng = zeros(length(t), 3);
Tm = zeros(length(t), 3);

if strcmp(convenio, '313')
    Reci2body = trasp(DCM); % ECI to Body transformation matrix

    for i = 1:length(t)
        eA = Reci2body(1,:,i);
        eB = Reci2body(2,:,i);
        eC = Reci2body(3,:,i);

        % Position vector projected onto body axes [m]
        rx = 1e3 * dot(reci(i,:), eA);
        ry = 1e3 * dot(reci(i,:), eB);
        rz = 1e3 * dot(reci(i,:), eC);
        R = norm([rx, ry, rz]);

        % Gravity gradient torque [Nm]
        Ng(i,1) = 3*mu / R^5 * (Iz - Iy) * ry * rz;
        Ng(i,2) = 3*mu / R^5 * (Ix - Iz) * rz * rx;
        Ng(i,3) = 3*mu / R^5 * (Iy - Ix) * rx * ry;

        % Transform position from ECI to ECEF
        Recef2eci = rot_matrix(w_e*t(i) + gamma0, 'Z');
        r_ecef = Recef2eci.' * reci(i,:).';
        [Bx_ecef, By_ecef, Bz_ecef] = geomagn_cartesian_field(r_ecef(1), r_ecef(2), r_ecef(3), g, h, OrdM);

        % Convert magnetic field from ECEF to Body and from nT to Tesla
        B_body = Reci2body(:,:,i) * Recef2eci * [Bx_ecef; By_ecef; Bz_ecef] * 1e-9;

        % Eddy current passive torque [Nm]
        Teddy = cross(G * cross(omega(i,:), B_body.').', B_body);

        % Total magnetic torque [Nm]
        Tm(i,:) = cross(Mresid, B_body.') + Teddy.';
    end

elseif strcmp(convenio, '321')
    Rlvlh2body = trasp(DCM);     % LVLH to Body transformation matrix
    Reci2body = zeros(3,3,length(t));

    for i = 1:length(t)
        % Unit vectors for ECI to LVLH transformation
        ex = veci(i,:) / norm(veci(i,:));
        ez = cross(reci(i,:),veci(i,:)) / norm(cross(reci(i,:),veci(i,:)));
        ey = cross(ez,ex) / norm(cross(ez,ex));
        Reci2lvlh = [ex.', ey.', ez.'];
        Reci2body(:,:,i) = Rlvlh2body(:,:,i) * Reci2lvlh;

        eA = Reci2body(1,:,i);
        eB = Reci2body(2,:,i);
        eC = Reci2body(3,:,i);

        rx = 1e3 * dot(reci(i,:), eA);
        ry = 1e3 * dot(reci(i,:), eB);
        rz = 1e3 * dot(reci(i,:), eC);
        R = norm([rx, ry, rz]);

        Ng(i,1) = 3*mu / R^5 * (Iz - Iy) * ry * rz;
        Ng(i,2) = 3*mu / R^5 * (Ix - Iz) * rz * rx;
        Ng(i,3) = 3*mu / R^5 * (Iy - Ix) * rx * ry;

        Recef2eci = rot_matrix(w_e*t(i) + gamma0, 'Z');
        r_ecef = Recef2eci.' * reci(i,:).';
        [Bx_ecef, By_ecef, Bz_ecef] = geomagn_cartesian_field(r_ecef(1), r_ecef(2), r_ecef(3), g, h, OrdM);

        B_body = Reci2body(:,:,i) * Recef2eci * [Bx_ecef; By_ecef; Bz_ecef] * 1e-9;
        Teddy = cross(G * cross(omega(i,:), B_body.').', B_body);
        Tm(i,:) = cross(Mresid, B_body.') + Teddy.';
    end
end

Tgeopot = vecnorm(Ng, 2, 2);
Tmagnet = vecnorm(Tm, 2, 2);

% Gravity gradient torque plot
figure;
plot(t, Ng(:,1), 'r', 'LineWidth', 1.2); hold on;
plot(t, Ng(:,2), 'g', 'LineWidth', 1.2);
plot(t, Ng(:,3), 'b', 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Moment (Nm)');
title('Gravity Gradient Torque');
legend('Nx', 'Ny', 'Nz');
grid on;

% Magnetic torque plot
figure;
plot(t, Tm(:,1), 'r', 'LineWidth', 1.2); hold on;
plot(t, Tm(:,2), 'g', 'LineWidth', 1.2);
plot(t, Tm(:,3), 'b', 'LineWidth', 1.2);
xlabel('Time (s)'); ylabel('Torque (Nm)');
title('Magnetic Torque');
legend('Tmx', 'Tmy', 'Tmz');
grid on;

% Perturbance magnitudes plot
figure;
plot(t, Tgeopot, 'Color', 'b', 'LineWidth', 1.2);
hold on;
plot(t, Tmagnet, 'Color', [1, 0.5, 0.5], 'LineWidth', 1.2);
xlabel('Time (s)');
ylabel('Moment (Nm)');
title('Perturbing Torques Magnitude');
legend('Gravity Gradient Torque', 'Magnetic Torque');
grid on;
end