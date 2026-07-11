function [ax_ecef, ay_ecef, az_ecef] = geopoten_ecef_cartesian(xecef, yecef, zecef, C, S, N)
% GEOPOTEN_ECEF_CARTESIAN Computes ECEF gravitational acceleration using EGM-96 spherical harmonics.
%
% Inputs: 
%   xecef, yecef, zecef: Cartesian position arrays in ECEF [km]
%   C, S: Harmonic coefficient matrices
%   N: Maximum degree of harmonic expansion
% Outputs: 
%   ax_ecef, ay_ecef, az_ecef: Cartesian gravitational acceleration components in ECEF [km/s^2]

ax_ecef = zeros(length(xecef),1);
ay_ecef = zeros(length(xecef),1);
az_ecef = zeros(length(xecef),1);
Rearth = 6371;                      
mu = 3.986e5;                       

for i = 1:length(xecef)
    xe = xecef(i); ye = yecef(i); ze = zecef(i);
    r = sqrt(xe^2 + ye^2 + ze^2);
    theta = acos(ze / r);
    phi = atan2(ye, xe);

    dU_dr = - mu / r^2;
    dU_dtheta = 0;
    dU_dphi = 0;

    for n = 1:N
        % Vectorization over order 'm' to eliminate the inner loop
        m = (0:n)';
        
        Cn = C(n+1, 1:n+1)';
        Sn = S(n+1, 1:n+1)';
        
        cos_m_phi = cos(m * phi);
        sin_m_phi = sin(m * phi);
        
        % Schmidt semi-normalized Legendre polynomials
        Pleg_all = legendre(n, cos(theta), 'sch');
        
        % Derivative computation
        ddPleg_all = zeros(n+1, 1);
        for idx = 1:(n+1)
            ddPleg_all(idx) = deriva_polLegendre(n, m(idx), cos(theta)); 
        end
        
        factor_R = (Rearth/r)^n;
        harmonics = Cn .* cos_m_phi + Sn .* sin_m_phi;
        harmonics_dphi = -Cn .* sin_m_phi + Sn .* cos_m_phi;
        
        % Matrix summation
        dU_dr = dU_dr - (mu/r^2) * (n+1) * factor_R * sum(harmonics .* Pleg_all);
        dU_dtheta = dU_dtheta + (mu/r) * factor_R * sum(harmonics .* ddPleg_all) * (-sin(theta));
        dU_dphi = dU_dphi + (mu/r) * factor_R * sum(m .* harmonics_dphi .* Pleg_all);
    end

    g_r = - dU_dr;
    g_theta = - dU_dtheta/r;
    g_phi = - dU_dphi/(r*sin(theta));
    
    Resf2cart = esf2cart_matrix(phi, theta);
    g_ecef = Resf2cart * [g_r; g_theta; g_phi];
    ax_ecef(i) = g_ecef(1); ay_ecef(i) = g_ecef(2); az_ecef(i) = g_ecef(3);
end
end