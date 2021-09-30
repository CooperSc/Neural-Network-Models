clear;
InputCreation;
Initialization;


% Initial Connections Setup
for i = 1 : neuronCount
    randSynapse = randperm(numInputLines,initialConnections);
    for j = 1 : length(randSynapse)
        weightVector(i,randSynapse(j),1) = initialSynapticWeight;
        weightVector(i,randSynapse(j),2) = initialSynapticWeight;
        neuronConnections(i,randSynapse(j),1) = 1;
        neuronConnections(i,randSynapse(j),2) = 1;
    end
end
weightVectorTracker(:,:,1) = weightVector(:,:,1);


%%% Presentations
timestep = 2;
tic
for i = 1 : epochsPresented

    if (i > stabilityCriterion && sum(sheddingChange((i - (stabilityCriterion - 1)):i + 1)) == 0)
            break;
    end
    
    if (mod(i,100) == 0)
        disp(i);
        toc;
    end
    
    for j = 1 : epochLength
        
        Indices = randperm(numExemplars,numExemplars);

        for k = 1 : numExemplars
            
            %timestep = k + 1 + (j - 1) * numExemplars;
            timestep = 1;
                
            % Determine Excitation/Firing
            neuronExcitation(:,timestep) = weightVector(:,:,timestep) * Exemplars(:,Indices(k));
            neuronFires(:,timestep) = neuronExcitation(:,timestep) > firingThreshold;
            neuronFiring(:,k + 1 + (j - 1) * numExemplars) = neuronFires(:,timestep);
            
            % Zbar moving Averager
             %neuronAverageFiringRate(:,timestep) = neuronAverageFiringRate(:,timestep) * alpha + (1 - alpha) * neuronFires(:,timestep); %changed from timestep - 1

            % Associative Modification
             modificationRule = Exemplars(:,Indices(k))' - expectationRandomVar - weightVector(:,:,timestep);
             modificationRule = modificationRule .* neuronExcitation(:,timestep);
             modificationRule = modificationRule * epsilon .* neuronConnections(:,:,timestep); %changed from i
             weightVector(:,:,timestep) = weightVector(:,:,timestep) + modificationRule; %changed from timestep + 1
        end
    end
    
    neuronAverageFiringRate(:,timestep) = neuronAverageFiringRate(:,timestep) * alpha + (1 - alpha)/1000 .* sum(neuronFiring(:,2:1001)')';
    
    % Synaptogenesis
    bernoulliRandomVariables = rand(neuronCount, numInputLines) < gamma;
    rateLimitCheck = neuronAverageFiringRate(:,timestep) < firingRateLimit;
    synaptogenesis = bernoulliRandomVariables .* rateLimitCheck .* abs((neuronConnections(:,:,timestep) - 1)); %changed from i
    neuronConnections(:,:,timestep) = neuronConnections(:,:,timestep) + synaptogenesis; %changed from i
    weightVector(:,:,timestep) = weightVector(:,:,timestep) + initialSynapticWeight * synaptogenesis; %changed from timestep + 1
    synaptogenesisChange(i) = sum(sum(synaptogenesis));
    
    % Shedding Rule
    shedding = (weightVector(:,:,timestep) < sheddingThreshold) .* neuronConnections(:,:,timestep); %changed from i
    neuronConnections(:,:,timestep) = neuronConnections(:,:,timestep) - shedding; %changed from i
    weightVector(:,:,timestep) =  weightVector(:,:,timestep) - (weightVector(:,:,timestep) .* shedding); %changed from timestep + 1
    sheddingChange(i) = sum(sum(shedding));
    
    % Track Vectors & Reset Timestep Vectors
%     neuronFiresTracker(:,i) = mean(neuronFires(:,:)')'; 
%     neuronAverageFiringRateTracker(:,i) = mean(neuronAverageFiringRate(:,:)'); 
%     neuronExcitationTracker(:,i) = mean(neuronExcitation(:,:)');
%     weightVectorTracker(:,:,i) = mean(weightVector(:,:,:),3);  
%     
%     neuronFires(:,1) = neuronFires(:,end); 
%     neuronFires(:,2) = neuronFires(:,end);
%     neuronAverageFiringRate(:,1) = neuronAverageFiringRate(:,end); 
%     neuronAverageFiringRate(:,2) = neuronAverageFiringRate(:,end); 
%     neuronExcitation(:,1) = neuronExcitation(:,end); 
%     neuronExcitation(:,2) = neuronExcitation(:,end); 
%     
%     weightVector(:,:,1) = weightVector(:,:,end);  
%     weightVector(:,:,2) = weightVector(:,:,end);  

      if (mod(i,samplingRate) == 0)
        weightVectorTracker(:,:,i/samplingRate + 1) = weightVector(:,:,timestep);
        neuronConnectionsTracker(:,:,i/samplingRate + 1) = neuronConnections(:,:,timestep);
      end
end


% Create Output Statistics
[indices,Allocation] = allocation(neuronCount,Prototypes,weightVector,timestep,firingThreshold);
covMatrixNeurons = createCovMatrix(Exemplars,numInputLines,neuronCount,neuronConnections);














