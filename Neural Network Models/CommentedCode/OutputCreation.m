%%% Setup

clear;
InputCreationB; % Generates sample space
Initialization; % Sets up variables and parameter settings

% Initial Connections Setup
for i = 1 : neuronCount
    randSynapse = randperm(numInputLines,initialConnections);
    for j = 1 : length(randSynapse)
        weightVector(i,randSynapse(j)) = initialSynapticWeight + 0.001*rand(1);
        neuronConnections(i,randSynapse(j)) = 1;
    end
end
weightVectorTracker(:,:,1) = weightVector(:,:);


%%% Network Simulation

tic
for i = 1 : epochsPresented
    
    % Stability Condition Check
    if (i > stabilityCriterion)
        if (sum(sheddingTracker > stabilityCriterion*numExemplars) >= stabilityPercentage * neuronCount)
            break;
        end
    end
    
    % Timing Output for checking Model Efficiency
    if (mod(i,1000) == 0)
        disp(i);
        toc;
    end
        
        Indices = randperm(numExemplars,numExemplars); % permute exemplars that are shown to the model per epoch
        
        
        for k = 1 : numExemplars
                
            % Determine Excitation and Firing Using Competitive Network
            neuronExcitation = weightVector(:,:) * Exemplars(:,Indices(k));
            sortedExcitation = sort(neuronExcitation);
            inhibitionThreshold = sortedExcitation(end-round(neuronCount * inhibitionLimit * scaling));
            competitiveNeurons = neuronExcitation > inhibitionThreshold;
            neuronFires = competitiveNeurons;
            
            % Associative Modification
            weightVector(:,:) = weightVector(:,:) + ((Exemplars(:,Indices(k))' - expectationRandomVar - weightVector(:,:)) .* (neuronExcitation./sum(weightVector(:,:),2)) * epsilon .* neuronConnections(:,:)) .* competitiveNeurons; 
            
            % Firing Rate Update
            neuronAverageFiringRate = neuronAverageFiringRate * alpha + (1-alpha) * neuronFires;
            
            % Synaptogenesis
            bernoulliRandomVariables(synaptogenesisIndices) = 0;
            synaptogenesisIndices = randperm(neuronCount*numInputLines,poissrnd(numInputLines*neuronCount*gamma));
            bernoulliRandomVariables(synaptogenesisIndices) = 1;
            LowerLimitCheck =  (neuronAverageFiringRate(:) .* abs(rateLimitCheck-1)) > (firingRateLimitLower * scaling);
            rateLimitCheck = neuronAverageFiringRate(:) < (firingRateLimit * scaling) - LowerLimitCheck;
            synaptogenesis = bernoulliRandomVariables .* rateLimitCheck .* abs((neuronConnections(:,:) - 1)); 
            neuronConnections(:,:) = neuronConnections(:,:) + synaptogenesis; 
            weightVector(:,:) = weightVector(:,:) + initialSynapticWeight * synaptogenesis; 
            
            % Shedding Rule
            shedding = (weightVector(:,:) < sheddingThreshold) .* neuronConnections(:,:); 
            neuronConnections(:,:) = neuronConnections(:,:) - shedding; 
            weightVector(:,:) =  weightVector(:,:) .* neuronConnections(:,:); 
            sheddingChange(k + 1 + (i-1) * numExemplars) = sum(sum(shedding));
            
            % Tracking Vectors (presentation timescale)
            synaptogenesisChange(k + 1 + (i-1) * numExemplars) = sum(sum(synaptogenesis));
            sheddingTracker = sheddingTracker .* (sum(shedding,2) == 0) + (sum(shedding,2) == 0);
            sheddingOverTime(:,k + 1 + (i-1) * numExemplars) = (sum(shedding,2) > 0);
        end
    
    
    % Tracking Vectors (epoch timescale)
      neuronAverageFiringRateTracker(:,i) = neuronAverageFiringRate;
      if (mod(i,samplingRate) == 0)
        weightVectorTracker(:,:,i/samplingRate + 1) = weightVector(:,:);
        neuronConnectionsTracker(:,:,i/samplingRate + 1) = neuronConnections(:,:);
      end
end


% Create Output Statistics
clear inhibition; 
clear categories;
clear indices;
clear Allocation;
[inhibition,categories,indices,Allocation] = allocation(neuronCount,Prototypes,Exemplars,weightVector,1,numCategories,inhibitionLimit);
covMatrixNeurons = createCovMatrix(Exemplars,numInputLines,neuronCount,neuronConnections);













