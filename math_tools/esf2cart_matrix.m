function Resf2cart = esf2cart_matrix(lambda, theta)
% ESF2CART_MATRIX Converts spherical coordinates to Cartesian transformation matrix.
%
% Inputs:
%   lambda: Longitude [rad]
%   theta: Colatitude [rad] (90 - lat)
% Outputs:
%   Resf2cart: Transformation matrix from spherical (r, theta, lambda) to Cartesian (x, y, z)

e_r = [cos(lambda)*sin(theta); sin(lambda)*sin(theta); cos(theta)];
e_theta = [cos(lambda)*cos(theta); sin(lambda)*cos(theta); -sin(theta)];
e_lambda = [-sin(lambda); cos(lambda); 0];

Resf2cart = [e_r, e_theta, e_lambda];
end