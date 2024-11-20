function detectorObjects = setupDetectorObjects(minBlobArea)
% Create System objects for foreground detection and blob analysis

detectorObjects.detector = vision.ForegroundDetector(NumGaussians = 3, ...
    NumTrainingFrames = 40, MinimumBackgroundRatio = 0.7);

detectorObjects.blobAnalyzer = vision.BlobAnalysis(BoundingBoxOutputPort = true, ...
    AreaOutputPort = true, CentroidOutputPort = true, MinimumBlobArea = minBlobArea);
end