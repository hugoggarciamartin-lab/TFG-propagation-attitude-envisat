function theta0 = gmst(y, m, d, hutc)
% GMST Calculates the Greenwich Mean Sidereal Time angle.
%
% Inputs:
%   y, m, d, hutc: Date and UTC time components
% Outputs:
%   theta0: Sidereal time angle [rad]

if m <= 2
    m = m + 12;
    y = y - 1;
end
JD = floor(367*y) - floor((7*(y + floor((m+9)/12)))/4) + floor((275*m)/9) + d + (hutc/24) + 1721013.5;
Tut1 = (JD - 2451545) / 36525;
theta_GMST = 280.46061837 + 360.98564736629*(JD - 2451545) + 0.000387933*Tut1^2 - (Tut1^3/38710000);
theta_GMST = mod(theta_GMST, 360);
if theta_GMST < 0, theta_GMST = theta_GMST + 360; end
theta0 = deg2rad(theta_GMST);
end