function f_drag = drag_exp(Cd,mass,Aref,reci,veci)
% Calcula el drag atmosférico con un modelo de densidad atmosférica y sin considerar el cambio en la actitud
% Se emplea una altitud base de 300 km

% Entradas: 
%   Cd: coeficiente de resistencia aerodinámico [adimensional]
%   mass: masa del objeto [kg]
%   Aref: superifice de referencia del objeto [m^2]
%   reci: vector de posición del centro de masas del objeto en ECI [km]
%   veci: vector de velocidad del centro de masas del objeto en ECI [km/s]
% Salidas:
%   f_drag: vector de fuerza específica causada por la presencia de drag [km/s^2]

Rearth = 6371;                  % Radio medio terrestre [km]
norm(reci);                     % Módulo de la distancia al centro de masas de la Tierra
height = norm(reci) - Rearth;   % Altura orbital [km]
h0 = 250;                       % Altura de referencia [km]
rho0 = 7.248*10^-11;            % Densidad del aire a la altura de referencia [kg/m^3]
H = 45.546;                     % Altura de escala [km]
rho = rho0 * exp(- (height - h0) / H);
f_drag = - 0.5 * Cd * rho * norm(veci) * veci * Aref / mass * 1e3;

end