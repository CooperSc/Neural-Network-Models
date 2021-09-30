%%% Initialization

% Network Parameters
neuronCount = 2000;
firingRateLimit = 0.09; %0.1 for B
epsilon = 0.01;
alpha = 0.95; %0.99 for B
gamma = 0.01;
initialConnections = 1;
initialSynapticWeight = 0.2;
sheddingThreshold = 0.01;
firingThreshold = 3.0; %0.8 for B
epochLength = 10;
epochsPresented = 4000;
stabilityCriterion = 200;
samplingRate = 1;


% Neuron Vectors
neuronFires = zeros(neuronCount,2);%epochLength * numExemplars + 1); %zj(k,t)
neuronAverageFiringRate = zeros(neuronCount,2);%epochLength * numExemplars + 1); %zbarj(t)
neuronExcitation = zeros(neuronCount,2);%,epochLength * numExemplars + 1); %yj(t)
weightVector = zeros(neuronCount,numInputLines,2);%,epochLength * numExemplars + 2);  %wij(t)
neuronConnections = zeros(neuronCount,numInputLines,2);%,epochsPresented + 1);
sheddingChange = zeros(epochsPresented + 1,1);
synaptogenesisChange = zeros(epochsPresented + 1,1);
neuronFiring = zeros(neuronCount,1001);

%neuronFiresTracker = zeros(neuronCount,epochsPresented + 1); %zj(k,t)
%neuronAverageFiringRateTracker = zeros(neuronCount,epochsPresented + 1); %zbarj(t)
%neuronExcitationTracker = zeros(neuronCount,epochsPresented + 1); %yj(t)
weightVectorTracker = zeros(neuronCount,numInputLines,epochsPresented/samplingRate + 1);  %wij(t)
neuronConnectionsTracker = zeros(neuronCount,numInputLines,epochsPresented/samplingRate + 1);

