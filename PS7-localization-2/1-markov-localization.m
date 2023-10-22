pTransition = [
    0   0   0   0   0
    0  .05  .1 .05  0
    0   .1  .4  .1  0
    0  .05  .1 .05  0
    0   0   0   0   0  ];

getPLocalTransition = @(localCoordinate) ...
    pTransition(localCoordinate(1) + 3, localCoordinate(2) + 3);

calcPTransition = @(x_t, u_t, x_tm1) ...
    getPLocalTransition(max([-2, -2], min([2, 2], x_t - (x_tm1 + u_t))));
plotPredictionUpdate(calcPTransition);

%% ------------------------------ %%
% PART 2 - Measurement update

calcPMeasurement = @(Z, M, pTrueDetection, pFalseDetection)...
    prod(prod(Z .* (1 - pFalseDetection) + (1 - Z) .* pFalseDetection) .* (1 - M * (1 - pTrueDetection) + M .* (1 - pTrueDetection)));

worldRows = 3;
worldCols = 3;
% Calculate lPerception matrix
lPerception = zeros(worldRows, worldCols);

for i = 1:worldRows
    for j = 1:worldCols
        x = [i, j];
        lPerception(i, j) = calcPMeasurement(Z, getVisibleSubMap(x, Mglobal), pTrueDetection, pFalseDetection);
    end
end

plotMeasurementUpdate(calcPMeasurement);

%% ------------------------------ %%
% PART 3 - Filter loop

rng(1) % important for technical reasons
U = [ 1 -1 3 4 ]; % an artificial input sequence
% applyPredictionUpdate returns the predicted state:
applyPredictionUpdate = @(bel, u_t) [bel '.PU(' num2str(u_t) ')'];
% readSensor returns the current sensor's reading:
readSensor = @() [ 'Z(' num2str(round(20*rand())) ')' ];
% applyMeasurementUpdate returns the state updated by the measurements:
applyMeasurementUpdate = @(sensorReading, belBar) [ belBar '.MU(' sensorReading ')' ];
bel = 'PRIOR';
%%%%%%%%%%% PLEASE DON'T CHANGE ANYTHING ABOVE THIS LINE %%%%%%%%%%%
for u_t = U
    belBar = applyPredictionUpdate(bel, u_t);
    bel = applyMeasurementUpdate(readSensor(), belBar);
end
plotFilterLoop(bel);