function [indices,allocation] = allocation(neuronCount,Prototypes,weightVector,timestep,firingThreshold)

allocation = zeros(length(Prototypes(1,:)),1);
indices = zeros(neuronCount,length(Prototypes(1,:)));

for i = 1 : length(allocation)
    for l = 1 : neuronCount
        if (dot(Prototypes(:,i),weightVector(l,:,timestep)) > firingThreshold)
            allocation(i) = allocation(i) + 1;
            indices(l,i) = 1;
        end
    end
end

end
