function dcm_ef = extract_dcm(t, q, namefile)
% EXTRACT_DCM Converts attitude quaternions to Direction Cosine Matrices and exports to text.
%
% Inputs:
%   t: Time vector [s]
%   q: Nx4 quaternion matrix
%   namefile: Output filename
% Outputs:
%   dcm_ef: 3x3xN DCM stack

dcm_ef = quat2DCM(q);
file = fopen(namefile,'w');
fprintf(file, 'Direction Cosine Matrices\n');
fprintf(file, '%s\n', repmat('-',1,50));

for i = 1:length(t)
    fprintf(file,'Time %.5f s\n',t(i));
    for j = 1:3
        fprintf(file,'%15.5f  %15.5f  %15.5f\n',dcm_ef(j,:,i));
    end
    fprintf(file, '%s\n',repmat('-',1,50));
end
fclose(file);
end