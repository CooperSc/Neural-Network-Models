function [] = plotNeuronConnections(neuronConnections,index)
plot(squeeze(sum(neuronConnections(index,:,:))));
end

