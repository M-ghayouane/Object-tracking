function meas = cvmeas2d(state, varargin)
% Measurement model for 2d constant velocity
meas3d = cvmeas(state,varargin{:});
meas = meas3d(1:2,:);
end