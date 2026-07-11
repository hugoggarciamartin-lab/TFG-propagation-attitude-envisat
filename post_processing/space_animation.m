function space_animation(modelo_stl, t_anim, dcm)
% SPACE_ANIMATION Animates the spacecraft attitude in 3D using STL models.
%
% Inputs:
%   modelo_stl: Path to the STL file (string)
%   t_anim: Total animation duration [s]
%   dcm: 3x3xN Direction Cosine Matrix stack

% Load the STL model
model = stlread(modelo_stl);

% Extract vertices and faces
if isa(model, 'triangulation')
    F = model.ConnectivityList;
    V = model.Points;
else
    error('The STL file format is invalid. Ensure it imports as a triangulation object.');
end

% Center the model at the origin based on its Center of Gravity (CG)
CG = mean(V, 1);
V = V - CG;

% Initialize the figure
fig = figure('Color', 'w', 'NumberTitle', 'off', 'Name', '3D Attitude Animation');
hold on; axis equal; grid on;
xlabel('X'); ylabel('Y'); zlabel('Z'); view(3); % Isometric view

% Render the model
objeto = patch('Faces', F, 'Vertices', V, 'FaceColor', [0.6 0.6 0.6], 'EdgeColor', [0.2 0.2 0.2], 'FaceAlpha', 1);

% Enhance lighting for depth perception
camlight headlight;
camlight left;
lighting gouraud;
material shiny;

% Configure camera parameters
campos([60 85 50]);
camtarget([0 0 0]); % Point towards the origin

% Animate using the DCM matrices
for i = 1:size(dcm, 3)
    if ~isvalid(fig)
        break; % Stop if the user closes the window
    end

    % Rotate the model vertices
    Vrotate = (dcm(:,:,i) * V.').';
    objeto.Vertices = Vrotate;

    % Refresh the figure
    drawnow;
    pause(t_anim / size(dcm, 3) * 0.01);
end
end