% Prototype Creation
numPrototypes = 5;
numInputLines = 80;
LinesPerPrototype = numInputLines/numPrototypes;
Prototypes = zeros(numInputLines,numPrototypes);

for i = 0 : numPrototypes - 1
    for j = (i * LinesPerPrototype + 1): ((i+1) * LinesPerPrototype)
        Prototypes(j,i+1) = 1;
    end
end

% Exemplar Creation
numExemplars = 100;
categoryProbabilites = [0.1,0.15,0.2,0.25,0.3];
numCategories = numExemplars .* categoryProbabilites;
Exemplars = zeros(numInputLines,numExemplars);

for i = 0 : length(categoryProbabilites) - 1
    for j = sum(numCategories(1:i)) + 1 : sum(numCategories(1:i + 1))
        Exemplars(:,j) = Prototypes(:,i+1);
    end
end


% Noise Creation
occlusion = 0.25;
onNoise = 6/64;
for i = 0 : length(categoryProbabilites) - 1
    for j = sum(numCategories(1:i)) + 1 : sum(numCategories(1:i + 1))
        occlusionIndices = randperm(numInputLines / numPrototypes,numInputLines * occlusion / numPrototypes) + i * numInputLines / numPrototypes;
        onNoiseIndices = mod(randperm(numInputLines - numInputLines / numPrototypes,onNoise * (numInputLines - numInputLines / numPrototypes)) + (i+1) * numInputLines / numPrototypes,numInputLines);
        for k = 1 : length(occlusionIndices)
            Exemplars(occlusionIndices(k),j) = 0;
        end
        for k = 1 : length(onNoiseIndices)
            if (onNoiseIndices(k) == 0)
                onNoiseIndices(k) = 80;
            end
            Exemplars(onNoiseIndices(k),j) = 1;
        end
    end
end

expectationRandomVar = mean(Exemplars');  % Creation of E[X] using empirical mean



% Simulate Image of Exemplars
image(200*Exemplars);
