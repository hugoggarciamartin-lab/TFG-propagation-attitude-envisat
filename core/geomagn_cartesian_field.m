function [Bx_ecef, By_ecef, Bz_ecef] = geomagn_cartesian_field(xecef, yecef, zecef, g, h, N)
% GEOMAGN_CARTESIAN_FIELD Computes ECEF magnetic field components using IGRF-14 spherical harmonics.
%
% Inputs: 
%   xecef, yecef, zecef: Cartesian position arrays in ECEF [km]
%   g, h: Harmonic coefficient matrices [nT]
%   N: Maximum degree of harmonic expansion
% Outputs: 
%   Bx_ecef, By_ecef, Bz_ecef: Cartesian magnetic field components in ECEF [nT]

Bx_ecef = zeros(length(xecef),1);
By_ecef = zeros(length(xecef),1);
Bz_ecef = zeros(length(xecef),1);
a = 6371;                           

for i = 1:length(xecef)
    xe = xecef(i); ye = yecef(i); ze = zecef(i);
    r = sqrt(xe^2 + ye^2 + ze^2);
    theta = acos(ze / r);
    phi = atan2(ye, xe);

    dV_dr = 0;
    dV_dtheta = 0;
    dV_dphi = 0;

    for n = 1:N
        % Vectorization over order 'm'
        m = (0:n)';
        
        gn = g(n+1, 1:n+1)';
        hn = h(n+1, 1:n+1)';
        
        cos_m_phi = cos(m * phi);
        sin_m_phi = sin(m * phi);
        
        Pleg_all = legendre(n, cos(theta), 'sch');
        
        ddPleg_all = zeros(n+1, 1);
        for idx = 1:(n+1)
            ddPleg_all(idx) = deriva_polLegendre(n, m(idx), cos(theta)); 
        end
        
        factor_a = (a/r)^(n+1);
        harmonics = gn .* cos_m_phi + hn .* sin_m_phi;
        harmonics_dphi = -gn .* sin_m_phi + hn .* cos_m_phi;
        
        dV_dr = dV_dr - (n+1) * (a/r^2) * factor_a * sum(harmonics .* Pleg_all);
        dV_dtheta = dV_dtheta + a * factor_a * sum(harmonics .* ddPleg_all) * (-sin(theta));
        dV_dphi = dV_dphi + a * factor_a * sum(m .* harmonics_dphi .* Pleg_all);
    end

    B_r = - dV_dr;
    B_theta = - dV_dtheta/r;
    B_phi = - dV_dphi/(r*sin(theta));
    
    Resf2cart = esf2cart_matrix(phi, theta);
    Becef = Resf2cart * [B_r; B_theta; B_phi];
    Bx_ecef(i) = Becef(1); By_ecef(i) = Becef(2); Bz_ecef(i) = Becef(3);
end
end