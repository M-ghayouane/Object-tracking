function pf = initcv2dpf(detection)
%INITCV2DPF Filter initialization function 2D constant velocity particle filter
% PF = INITCV2DPF(DETECTION) initialized PF, a trackingPF, filter using
% DETECTION, and objectDetection object. PF uses a 2D constant velocity
% measurement model.
%
% The function follows similar steps as initcvpf, but uses the knowledge
% that the measurement is the position in rectangular coordinates.

classToUse = class(detection.Measurement);

% Create Process Noise matrix
scaleAccel = ones(1, classToUse);
Q = eye(2, classToUse) * scaleAccel;

% Store measurement properties
n = numel(detection.Measurement);
if isscalar(detection.MeasurementNoise)
    measurementNoise = detection.MeasurementNoise * eye(n,n,classToUse);
else
    measurementNoise = cast(detection.MeasurementNoise,classToUse);
end

% Number of particles
numParticles = 1000;

%% Initialize the particle filter in Rectangular frame using state and state covariance
posMeas = detection.Measurement(:);
velMeas = zeros(n,1,classToUse);
posCov = cast(detection.MeasurementNoise,classToUse);
velCov = eye(n,n,classToUse);

H1d = cast([1 0], classToUse);
Hpos = blkdiag(H1d, H1d);                       % position = Hpos * state
Hvel = [zeros(2,1,classToUse),Hpos(:,1:end-1)]; % velocity = Hvel * state
state = Hpos' * posMeas(:) + Hvel' * velMeas(:);
stateCov = Hpos' * posCov * Hpos + Hvel' * velCov * Hvel;
% Measurement related properties are not set for invalid detection.
pf = trackingPF(@constvel,@cvmeas2d,state, NumParticles = numParticles, ...
    StateCovariance = stateCov, ProcessNoise = Q, ...
    MeasurementNoise = measurementNoise, HasAdditiveProcessNoise = false);
setMeasurementSizes(pf,n,n);
end