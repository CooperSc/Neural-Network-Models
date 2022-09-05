% Prototype Creation
seed = rng("shuffle");
numSuperCategories = 3;
numPrototypes = 9;
prototypesPerCategory = numPrototypes/numSuperCategories;
numInputLines = 390;
LinesPerCategory = [45, 5, 30, 10, 15, 15];
Prototypes = zeros(numInputLines,numPrototypes);

% Create Prototypes
startingPoint = 0;
for i = 1 : numPrototypes
    Lines = LinesPerCategory((ceil(i/prototypesPerCategory) - 1)*2 + 1);
    Prototypes(startingPoint + 1:startingPoint + Lines, i) = 1;
    startingPoint = startingPoint + Lines;
    if (mod(i,numPrototypes/numSuperCategories) == 0)
        Lines = LinesPerCategory((ceil(i/prototypesPerCategory) - 1)*2 + 2);
        for j = i - prototypesPerCategory + 1 : i
            for k = 1 : prototypesPerCategory + 1
                if (mod(j,3) + 1 ~= k)
                     Prototypes(startingPoint + 1 + Lines * (k-1):startingPoint + k * Lines,j) = 1;
                end
            end
        end
     startingPoint = startingPoint + (nchoosek(prototypesPerCategory,2) + 1) * Lines;
    end
end



% Create Exemplar as Copies of Prototypes
numExemplars = 225;
%categoryProbabilities = [1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9,1/9]; %B1
%categoryProbabilities = [29/225,29/225,28/225,1/9,1/9,1/9,22/225,21/225,21/225]; %B2
categoryProbabilities = [41/225,39/225,34/225,27/225,1/9,20/225,14/225,13/225,12/225]; %B3
numCategories = numExemplars .* categoryProbabilities;
Exemplars = zeros(numInputLines,numExemplars);

for i = 0 : length(categoryProbabilities) - 1
    for j = sum(numCategories(1:i)) + 1 : sum(numCategories(1:i + 1))
        Exemplars(:,j) = Prototypes(:,i+1);
    end
end


% Perturb Exemplars with Noise
occlusion = 40/60; % off-noise
onIndices = zeros(60,9); 

for i = 1 : numPrototypes
    count = 1;
    for j = 1 : numInputLines
        if (Prototypes(j,i) == 1)
            onIndices(count,i) = j;
            count = count + 1;
        end
    end
end


for i = 1 : length(numCategories)
    for j = 1 : numCategories(i)
        offIndices = randperm(60,occlusion*60);
        for k = 1 : occlusion*60
            Exemplars(onIndices(offIndices(k),i),sum(numCategories(1:i-1)) + j) = 0;
        end
    end
end

expectationRandomVar = mean(Exemplars');  % Creation of E[X] using empirical mean



% Simulate Image of Exemplars
image(200*Exemplars);
