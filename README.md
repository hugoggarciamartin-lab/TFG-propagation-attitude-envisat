# TFG-propagation-attitude-envisat

## System Overview
This repository contains a 6-Degrees-of-Freedom (6-DOF) numerical simulation environment for spacecraft orbit and attitude propagation. Designed with strict modularity, it models a rigid body (e.g., Envisat) subjected to complex environmental perturbations. The architecture strictly segregates the mathematical plant from configuration and telemetry, ensuring deterministic execution and supporting software traceability requirements.

## Mathematical Baseline & Physical Models
The simulation is grounded in the following validated physics models:
* **Geopotential:** Spherical harmonics expansion using the EGM-96 model to simulate gravity gradient perturbations.
* **Geomagnetism:** IGRF-14 model utilized for residual magnetic dipole and passive Eddy current torques.
* **Aerodynamics:** Exponential atmospheric density model for aerodynamic drag estimation based on orbital altitude.
* **Kinematics:** Quaternion-based attitude integration to strictly prevent gimbal lock, coupled with automated transformations to Euler (3-1-3) and Tait-Bryan (3-2-1) angles.

## System Architecture
The codebase follows a strictly segregated directory structure to isolate critical dynamics from non-critical data processing:

* `/config`: Initialization scripts and static parameter packaging (satellite inertia, environmental epochs).
* `/core`: The critical mathematical plant. Contains the numerical integrator (`ode89`) and the coupled orbital/attitude dynamic equations.
* `/math_tools`: Independent, stateless algebraic and coordinate transformation utilities (e.g., DCM generation, Keplerian to Cartesian state vectors).
* `/post_processing`: Non-critical telemetry extraction, 3D attitude animation, and disturbance torque visualization.
* `/assets`: External dependencies, including STL files for 3D rendering.

## Prerequisites
* MATLAB (Tested on standard distributions; no specialized toolboxes strictly required for core propagation).
* Validation of `.mat` data files (EGM-96 and IGRF-14 coefficients) located in the `/config` directory.

## Execution
The system is orchestrated entirely through the root script. Do not execute individual sub-modules directly.

1. Clone the repository and navigate to the root directory in MATLAB.
2. Run the master orchestrator:
   ```matlab
   main