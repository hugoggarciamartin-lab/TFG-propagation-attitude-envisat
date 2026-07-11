function [t, data_orbit, data_out, Sim_out] = run_propagator(Sat, Env, Sim, init_orb, init_att)
% RUN_PROPAGATOR Executes numerical integration of the coupled 6-DOF dynamics.
%
% Inputs:
%   Sat, Env, Sim: Configuration structures
%   init_orb, init_att: Initial state vectors
% Outputs:
%   t: Time vector
%   data_orbit: Orbital state matrix
%   data_out: Attitude state matrix
%   Sim_out: Updated simulation structure with interpolation functions

% Orbit Propagator
[torbit, data_orbit] = ode89(@(t, estado_orb) ecs_orbit(t, estado_orb, Env, Sat), ...
    Sim.tspan, init_orb, Sim.options);

% Generate interpolation functions for attitude dynamics
Sim_out = Sim;
Sim_out.rinterp = @(t) interp1(torbit, data_orbit(:,1:3), t).';
Sim_out.vinterp = @(t) interp1(torbit, data_orbit(:,4:6), t).';

% Attitude Propagator
[t, data_out] = ode89(@(t, estado) ecs_attitude(t, estado, Sat, Env, Sim_out), ...
    Sim.tspan, init_att, Sim.options);
end