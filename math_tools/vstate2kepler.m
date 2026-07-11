function [a, ecc, inc, raan, argperig, nu] = vstate2kepler(r,v)
% Convierte un vector de estado de 6 coordenadas en sus 6 parametros
% keplerianos correspondientes: [a, e, inc, raan, argperig, nu]
% Entradas: 
%   r - vector posición del cuerpo en órbita [km]
%   v - vector velocidad del cuerpo en órbita [km/s]
% Salidas: 
%   a - semieje mayor de la órbita (km)
%   e - excentricidad
%   inc -inclinación del plano orbital (º)
%   raan - ascensión recta del nodo ascendente (º)
%   arperig - arguemnto del perigeo (º)
%   nu - anomalía verdadera (º)

        mu = 3.986*10^5;                        % Parametro gravitacional (km^3/s^2)
        h_v = cross(r,v);                       % Vector del momento angular
        e_v = (1/mu)*cross(v,h_v) - r/norm(r);  % Vector de Laplace
        ecc = norm(e_v);                        % Excentricidad de la orbita
        E = 0.5*(norm(v))^2 - mu/norm(r);       % Energia mecanica de la orbita
        
        % Obtenemos el semieje mayor a
        if E < 0
            a = (norm(h_v))^2 / (mu*(1 - ecc^2));
            % Órbita Elíptica
         elseif E == 0
            a = Inf;
            % Órbita parabólica
            return
        elseif E > 0
            a = - mu/(2*E);
            % Órbita hiperbólica
        end

        % Obtenemos la inclinación del plano orbital
        inc = rad2deg(acos(h_v(3)/norm(h_v)));

        % Obtenemos el RAAN
        n = cross(h_v,[0;0;1])/norm(cross(h_v,[0;0;1]));
        
        if norm(n) ~= 0
            raan = rad2deg(acos(dot([1;0;0],n)));
            if h_v(2) < 0
                raan = 360 - raan;              % Correcion del valor del coseno pues no puede ser negativo [0, 2*pi]
            end
        else
            raan = 0;
        end
      
        % Obtenemos el argumento del perigeo
        if ecc > 0                    % Obita elpitica
            argperig = rad2deg(acos(dot(e_v,n)/ecc));

            if e_v(3) < 0                     % Cuando el perigeo se da por debajo del plano XY se aplica correccion
                argperig = 360 - argperig;
            end
        else
            argperig = 0;           % Orbita cirular
        end

        % Obtenemos la anomalia verdadera
        
        if ecc > 0
            nu = rad2deg(acos(dot(e_v,r)/norm(dot(e_v,r))));
            if dot(e_v,r) < 0                               % Cuando el coseno es negativo se aplica correcion
                nu = 360 - nu;
            end
            
        else
            ecc = 1e-10;
            
        end
end