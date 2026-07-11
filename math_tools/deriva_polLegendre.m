function dPleg = deriva_polLegendre(n, m, var)
% DERIVA_POLLEGENDRE Computes the analytical derivative of the associated Legendre polynomial (non-normalized).
%
% Inputs:
%   n: Degree of the polynomial
%   m: Order of the polynomial
%   var: Evaluation variable (x = cos(theta))
% Outputs:
%   dPleg: Analytical derivative

if n == 0
    dPleg = zeros(size(var));
    return;
end

Pn = legendre(n, var);
P_n_m = Pn(m + 1, :);

if (n - 1) >= m
    Pn_1 = legendre(n - 1, var);
    P_n_1_m = Pn_1(m + 1, :);
else
    P_n_1_m = zeros(size(var));
end

dPleg = zeros(size(var));
reg = abs(var) < 1;
sing = abs(var) == 1;

dPleg(reg) = (n * var(reg) .* P_n_m(reg) - (n + m) * P_n_1_m(reg)) ./ (var(reg).^2 - 1);

if any(sing) && m == 0
    dPleg(sing) = 0.5 * n * (n + 1) .* var(sing);
end
end