function data_ef = extract_efem(t, q, omega, namefile)
% EXTRACT_EFEM Exports ephemeris data (quaternions and angular velocities) to text.
%
% Inputs:
%   t: Time vector [s]
%   q: Nx4 quaternion matrix
%   omega: Nx3 angular velocity matrix [deg/s]
%   namefile: Output filename
% Outputs:
%   data_ef: Concatenated Nx7 data matrix

data_ef = [q, omega];
file = fopen(namefile, 'w');
fprintf(file, 'EPHEMERIS\n');
fprintf(file, '%-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n', ...
  'Time (s)', 'q0', 'q1', 'q2','q3', 'ω_x (°/s)', 'ω_y (°/s)', 'ω_z (°/s)');
fprintf(file, '%s\n', repmat('-', 1, 120));

for j = 1:length(t)
  fprintf(file, '%-15.3f %-15.3f %-15.3f %-15.3f %-15.3f %-15.3f %-15.3f %-15.3f\n', ...
    t(j), data_ef(j, 1), data_ef(j, 2), data_ef(j, 3), ...
    data_ef(j, 4), data_ef(j, 5), data_ef(j, 6), data_ef(j, 7));
end
fclose(file);
end