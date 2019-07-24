function P = InputTensor2BSplineFeatureMatrix(inputTensor,m,d)
% Convert input tensor to B-spline feature matrix
% inputTensor: # of trials * time interval window * # of neurons
% m: # of B-Spline knots, resolution
% d: B-Spline order, default 2 or 3
% Author: Xiwei She

% Get tensor dimension
[NP,L,N] = size(inputTensor);

% Generate B-splines
b = bspline(d+1,m+2,L);
Nb = m+d+1;

P = zeros(NP,Nb*N);

for i = 1:NP
    PSpike = squeeze(inputTensor(i,:,:))';
    PSplineM = PSpike*b;
    PSplineV = reshape(PSplineM',Nb*N,1)';
    P(i,:) = PSplineV;
end


