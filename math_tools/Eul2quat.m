function quater = Eul2quat(psi, theta, phi, convenio)
% EUL2QUAT Converts Euler (313) or Tait-Bryan (321) angles to quaternions.
%
% Inputs:
%   psi, theta, phi: Column vectors of angles [rad]
%   convenio: Char '313' or '321'
% Outputs:
%   quater: Nx4 quaternion matrix

psi = psi(:); theta = theta(:); phi = phi(:);
quater = zeros(length(psi), 4);

if strcmp(convenio, '321')
    for i = 1:length(psi)
        psi2 = psi(i)/2; theta2 = theta(i)/2; phi2 = phi(i)/2;
        q0 = cos(psi2)*cos(theta2)*cos(phi2) + sin(psi2)*sin(theta2)*sin(phi2);
        q1 = cos(psi2)*cos(theta2)*sin(phi2) - sin(psi2)*sin(theta2)*cos(phi2);
        q2 = cos(psi2)*sin(theta2)*cos(phi2) + sin(psi2)*cos(theta2)*sin(phi2);
        q3 = sin(psi2)*cos(theta2)*cos(phi2) - cos(psi2)*sin(theta2)*sin(phi2);
        q = [q0, q1, q2, q3];
        quater(i, :) = q / norm(q);
    end
elseif strcmp(convenio, '313')
    for i = 1:length(psi)
        q0 = cos(theta(i)/2) * cos((psi(i)+phi(i))/2);
        q1 = sin(theta(i)/2) * cos((psi(i)-phi(i))/2);
        q2 = sin(theta(i)/2) * sin((psi(i)-phi(i))/2);
        q3 = cos(theta(i)/2) * sin((psi(i)+phi(i))/2);
        q = [q0, q1, q2, q3];
        quater(i, :) = q / norm(q);
    end
else
    error('Convention not supported. Use "313" or "321".');
end
end