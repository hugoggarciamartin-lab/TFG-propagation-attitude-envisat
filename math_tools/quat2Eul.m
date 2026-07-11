function angles = quat2Eul(q, convenio)
% QUAT2EUL Converts quaternions to Tait-Bryan (321) or Euler (313) angles.
%
% Inputs:
%   q: Nx4 quaternion matrix
%   convenio: Char '313' or '321'
% Outputs:
%   angles: Nx3 angle matrix [rad]

angles = zeros(size(q, 1), 3);
for i = 1:size(q, 1)
    qi = q(i, :) / norm(q(i, :));
    q0 = qi(1); q1 = qi(2); q2 = qi(3); q3 = qi(4);
    if strcmp(convenio, '321')
        angles(i, :) = [atan2(2*(q1*q2+q0*q3), q0^2+q1^2-q2^2-q3^2), ...
            -asin(2*(q1*q3-q0*q2)), ...
            atan2(2*(q2*q3+q0*q1), q0^2-q1^2-q2^2+q3^2)];
    elseif strcmp(convenio, '313')
        angles(i, :) = [atan2(2*(q0*q2+q1*q3), -2*(q2*q3-q0*q1)), ...
            acos(q0^2-q1^2-q2^2+q3^2), ...
            atan(2*(q1*q3-q0*q2)/2*(q0*q1+q2*q3))];
    end
end
end