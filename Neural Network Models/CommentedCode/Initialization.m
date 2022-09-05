

%%% Parameters

% Network Parameters
neuronCount = 90; % number of postsynaptic neurons
firingRateLimit = 0.05;  % upper bound firing rate at which synaptogenesis stops
firingRateLimitLower = 0.045; % lower firing rate at which synaptogenesis restarts after stopping
inhibitionLimit = 0.05; % percent of neurons allowed through by the competitive inhibition (ranked by excitation)
epsilon = 0.0003; % rate constant for moving averager that affects weight values
alpha = 0.99^(1/100); % rate constant for moving average that determines the firing rate
gamma = 0.00001; % probability to randomly generate synapse between an available presynaptic and postsynaptic neuron
initialConnections = 1; % initial number of random synapses between presynaptic and postsynaptic neurons
initialSynapticWeight = 0.3; % initial weight value of synapses
sheddingThreshold = 0.2; % weight value at which synapses get shed
scalingExpectedRandomVariable = 1; % scaling for the E[X] regularization term

% Training Parameters
epochsPresented = 2000; % number of times the entire set of inputs are shown to the network
stabilityCriterion = 2000; % number of epochs with no shedding required for a neuron to be stable
stabilityPercentage = 0.9; % percent of neurons stable for defined convergence
samplingRate = 10; % frequency (in terms of number of epochs) for which data will be sampled 


% Neuron Vectors
neuronFires = false(neuronCount,1); % Binary vector of neurons firing: Z(t)
neuronAverageFiringRate = zeros(neuronCount,1); % Vector of neuron average firing rate: Zbar(t)
neuronExcitation = zeros(neuronCount,1); % Vector of neuron excitation: Y(t)
weightVector = zeros(neuronCount,numInputLines,1);  % Vector of synaptic weights: w(t)
neuronConnections = false(neuronCount,numInputLines,1); % Binary vector of synaptic connections: c(t)

% Neuron Tracking Vectors
sheddingChange = zeros(epochsPresented*numExemplars,1);
sheddingTracker = zeros(neuronCount,1);
sheddingOverTime = false(neuronCount,epochsPresented*numExemplars);
synaptogenesisChange = zeros(epochsPresented*numExemplars,1);
neuronAverageFiringRateTracker = zeros(neuronCount,epochsPresented + 1);
weightVectorTracker = zeros(neuronCount,numInputLines,epochsPresented/samplingRate + 1);  
neuronConnectionsTracker = false(neuronCount,numInputLines,epochsPresented/samplingRate + 1);

% Miscallaneous Variables for Instantiation of Program
bernoulliRandomVariables = false(neuronCount,numInputLines); % Used to generate new synapses probabilistically
rateLimitCheck = false(neuronCount,1);
synaptogenesisIndices = 1;
scaling = 1;
expectationRandomVar = scalingExpectedRandomVariable * expectationRandomVar;
