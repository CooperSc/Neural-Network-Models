function [a,b,covMatrix] = getCovMatrix(fullMatrix,neuronIndex)
    mat = squeeze(fullMatrix(:,:,neuronIndex));
    dimension = sqrt(numel(nonzeros(mat)));
    covMatrix = mat(1:dimension,1:dimension);
    [a,b] = eig(covMatrix);
end

% for i = 1 : 2000
% [a,b,c] = getCovMatrix(covMatrixNeurons,i);
% count = 0;
% for j = 1 : length(a)
% if (a(j,end))
% count = count + 1;
% end
% end
% if (count ~= length(a))
% disp(i)
% end
% end