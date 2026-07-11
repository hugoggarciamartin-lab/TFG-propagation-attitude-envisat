function DCM = quat2DCM(q)
% QUAT2DCM Converts a quaternion list to Direction Cosine Matrices.
%
% Inputs:
%   q: Nx4 quaternion matrix
% Outputs:
%   DCM: 3x3xN Direction Cosine Matrix stack

DCM = zeros(3, 3, size(q, 1));
for i = 1:size(q, 1)
        qi = q(i, :) / norm(q(i, :));
        q0 = qi(1); q1 = qi(2); q2 = qi(3); q3 = qi(4);
        DCM(:,:,i) = [q0^2+q1^2-q2^2-q3^2, 2*(q1*q2-q0*q3), 2*(q1*q3+q0*q2);
                2*(q1*q2+q0*q3), q0^2-q1^2+q2^2-q3^2, 2*(q2*q3-q0*q1);
                2*(q1*q3-q0*q2), 2*(q2*q3+q0*q1), q0^2-q1^2-q2^2+q3^2];
end
end