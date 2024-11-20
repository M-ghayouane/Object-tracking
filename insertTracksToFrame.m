function frame = insertTracksToFrame(frame, tracks)
numTracks = numel(tracks);
boxes = zeros(numTracks, 4);
ids = zeros(numTracks, 1, "int32");
predictedTrackInds = zeros(numTracks, 1);
for tr = 1:numTracks
    % Get bounding boxes.
    boxes(tr, :) = tracks(tr).ObjectAttributes.BoundingBox;
    boxes(tr, 1:2) = (tracks(tr).State(1:2:3))'-boxes(tr,3:4)/2;

    % Get IDs.
    ids(tr) = tracks(tr).TrackID;

    if tracks(tr).IsCoasted
        predictedTrackInds(tr) = tr;
    end
end

predictedTrackInds = predictedTrackInds(predictedTrackInds > 0);

% Create labels for objects that display the predicted rather
% than the actual location.
labels = cellstr(int2str(ids));

isPredicted = cell(size(labels));
isPredicted(predictedTrackInds) = {' predicted'};
labels = strcat(labels, isPredicted);

% Draw the objects on the frame.
frame = insertObjectAnnotation(frame, "rectangle", boxes, labels, ...
    TextBoxOpacity = 0.5);
end