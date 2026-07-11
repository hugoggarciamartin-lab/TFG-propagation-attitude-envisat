% Orquestador Principal de Simulación 6-DOF
clear; clc; close all;
tic;

% Configuración de rutas
addpath('config');
addpath('core');
addpath('math_tools');
addpath('post_processing');
addpath('assets');

% Inicialización y carga de datos
disp('Loading configuration...');
[Sat, Env, Sim, init_orb, init_att] = init_sim();

% Propagación de Órbita y Actitud (Núcleo Crítico)
disp('Exectuting Numerical Propagator...');
[t, data_orbit, data_out, Sim] = run_propagator(Sat, Env, Sim, init_orb, init_att);

% Post-procesado y Telemetría
disp('Creating Figures and Visualizations');
telem_analysis(t, data_orbit, data_out, Sat, Env, Sim);

% Tiempo de ejecución
optime = toc;
disp('--------------------------------------------------');
disp(['Simulation ended. Total Time: ', num2str(optime), ' seconds']);