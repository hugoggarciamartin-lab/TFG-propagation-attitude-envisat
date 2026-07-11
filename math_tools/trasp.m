function A = trasp(M)
% TRASP Transposes each matrix in a 3D stack.
%
% Inputs:
%   M: 3x3xN matrix stack
% Outputs:
%   A: Transposed stack

A = zeros(size(M));
for i = 1:size(M, 3)
    A(:,:,i) = M(:,:,i).';
end
end