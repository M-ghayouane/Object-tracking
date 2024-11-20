function frames = runTracker(vidReader, tracker, detectionHistory, interestingFrameInds)
vidReader.CurrentTime = 0; % Reset the video reader
ind = 0;
frameCount = 0;
frames = cell(1,numel(interestingFrameInds)-1);
vidPlayer = vision.DeployableVideoPlayer;
isPF = isParticleFilterUsed(tracker,detectionHistory);
while hasFrame(vidReader)
    % Read a video frame and detect objects in it.
    frame = readFrame(vidReader); % Read frame
    frameCount = frameCount + 1; % Increment frame count
    
    % Update the tracker
    if isLocked(tracker) || ~isempty(detectionHistory{frameCount})
        tracks = tracker(detectionHistory{frameCount}, frameCount);
    else
        tracks = objectTrack.empty;
    end

    % Add track information to the frame
    frame = insertTracksToFrame(frame, tracks);

    % Add particles to display
    if isPF
        for trackInd = 1:numel(tracks)
            % Get particles
            particles = getTrackFilterProperties(tracker, tracks(trackInd).TrackID, "Particles");
            positions = particles{1};
            positions = positions([1,3],:)';
            % Add particles on frame
            frame = insertMarker(frame, positions, "circle", Color = "yellow", Size = 1);
        end
    end

    % Add frame count in the top right corner
    frame = insertText(frame, [0,0], "Frame: " + frameCount, ...
        BoxColor = "black", TextColor = "yellow", BoxOpacity = 1);

    % Display Video
    step(vidPlayer,frame);

    % Grab interesting frames
    if frameCount == interestingFrameInds(ind+1)
        ind = ind + 1;
        frames{ind} = frame;
    end
end
end