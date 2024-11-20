function MotionBasedMultiObjectTrackingExample()
% Create System objects used for reading video, detecting moving objects
% and displaying the results.
obj = setupSystemObjects();
tracks = initializeTracks(); % Create an empty array of tracks.
nextId = 1; % ID of the next track
