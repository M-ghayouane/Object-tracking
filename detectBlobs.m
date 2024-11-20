function [centroids, bboxes] = detectBlobs(detectorObjects, frame)
% Expected uncertainty (noise) for the blob centroid.

% Detect foreground.
mask = detectorObjects.detector.step(frame);

% Apply morphological operations to remove noise and fill in holes.
mask = imopen(mask, strel(rectangle = [6, 6]));
mask = imclose(mask, strel(rectangle = [50, 50]));
mask = imfill(mask, "holes");

% Perform blob analysis to find connected components.
[~, centroids, bboxes] = detectorObjects.blobAnalyzer.step(mask);
end