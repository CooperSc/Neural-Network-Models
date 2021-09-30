function covMatrixNeurons = createCovMatrix(Exemplars,numInputLines,neuronCount,neuronConnections)
covMatrix = cov(Exemplars');
covMatrixNeurons = zeros(numInputLines,numInputLines,neuronCount);
for i = 1 : neuronCount
   neuronCovMat = (covMatrix .* neuronConnections(i,:,end))' .* neuronConnections(i,:,end);
   neuronCovMat = nonzeros(neuronCovMat);
   connectionsSize = sqrt(length(neuronCovMat));
   neuronCovMat = reshape(neuronCovMat,[connectionsSize, connectionsSize]);
   covMatrixNeurons(1:connectionsSize,1:connectionsSize,i) =  neuronCovMat;
end
end


