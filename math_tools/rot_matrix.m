function R = rot_matrix(angle, eje)
% ROT_MATRIX Generates elementary rotation matrices.
%
% Inputs:
%   angle: Rotation angle [rad]
%   eje: Rotation axis ('X', 'Y', 'Z')
% Outputs:
%   R: 3x3 rotation matrix

if strcmp(eje,'X')

    R = [1      0           0;
        0  cos(angle) -sin(angle);
        0  sin(angle)  cos(angle)];

elseif strcmp(eje,'Y')

    R = [cos(angle)  0  sin(angle);
        0        1       0;
        -sin(angle)  0  cos(angle)];


elseif strcmp(eje, 'Z')

    R = [cos(angle) -sin(angle)  0;
        sin(angle)  cos(angle)  0;
        0          0       1];


else
    error('Elige un giro adecuado: X , Y , Z');

end

end