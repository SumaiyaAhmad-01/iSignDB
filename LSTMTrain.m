function [net,options,layers]=LSTMTrain(XTrain,YTrain)

%%
numObservations = numel(XTrain);

%get the sequence length from each observation

for i=1:numObservations
    sequence = XTrain{i};
    sequenceLengths(i) = size(sequence,2);
end

%sort the sequence length and get the index in 'idx' so that the Xtrain and 
%YTrain can be sorted accordingly
[sequenceLengths,idx] = sort(sequenceLengths);
XTrain = XTrain(idx);
YTrain = YTrain(idx);


miniBatchSize = 3;
inputSize =228;
numHiddenUnits = 90;
numClasses = 2;
%%
layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer
    ];
%%

maxEpochs = 100;


options = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'GradientThreshold',0.5, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'LearnRateDropFactor',0.1,...
    'LearnRateSchedule','piecewise',...
    'SequenceLength','longest', ...
    'Verbose',0,...
    'Shuffle','never',...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,options);

end