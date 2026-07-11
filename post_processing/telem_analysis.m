function telem_analysis(t, data_orbit, data_out, Sat, Env, Sim)
% TELEM_ANALYSIS Post-processes results, exports telemetry, and generates visualizations.
%
% Inputs:
%   t: Time vector [s]
%   data_orbit: Orbital state matrix
%   data_out: Attitude state matrix
%   Sat, Env, Sim: Configuration structures

% Extract raw data
reci = data_orbit(:,1:3);
q = data_out(:,1:4);
omega = rad2deg(data_out(:,5:7));
angles = rad2deg(quat2Eul(q, Sim.convenio));

% Export results
extract_efem(t, q, omega, 'file1.txt');
extract_dcm(t, q, 'file2.txt');

% Compute perturbation torques
[Ng, Tm, ~, ~] = graf_torques_igrf(t, data_orbit, data_out, Sim, Sat, Env);

% --- Figure Generation ---
figure;
plot(t./3600, vecnorm(omega,2,2), "Color", [1.0, 0.5, 0.0], 'Linewidth', 1.5);
title('Angular velocity magnitude \omega');
xlabel('Time (hours)'); ylabel('\omega (\circ/s)'); grid on;

figure;
plot(t./3600, omega, 'LineWidth', 1.2);
title('Angular velocities \omega');
xlabel('Time (hours)'); ylabel('\omega (\circ/s)');
legend('\omega_x', '\omega_y', '\omega_z', 'Location', 'southeast'); grid on;

figure;
plot(t, q, 'LineWidth', 1.2);
title('Quaternions');
xlabel('Time (s)'); ylabel('Component');
legend('q_0', 'q_1', 'q_2', 'q_3'); grid on;

figure;
plot(t./60, angles(:,1), 'b', 'LineWidth', 1.2); hold on;
plot(t./60, angles(:,2), 'r', 'LineWidth', 1.2);
plot(t./60, angles(:,3), 'g', 'LineWidth', 1.2);
title('Tait-Bryan / Euler angles');
xlabel('Time (min)'); ylabel('Angle (\circ)');
legend('\psi (Yaw/Prec)', '\theta (Pitch/Nut)', '\phi (Roll/Rot)');
grid on; hold off;

figure;
plot3(reci(:,1), reci(:,2), reci(:,3), 'LineWidth', 1.2);
title('Perturbed Orbit');
xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)'); grid on;

% 3D Animation
tint = linspace(Sim.t0, Sim.tend, length(t)*10).';
matrix_dcm = quat2DCM(interp1(t, q, tint, 'spline'));
space_animation('envisat_stl.stl', Sim.tend - Sim.t0, matrix_dcm);
end