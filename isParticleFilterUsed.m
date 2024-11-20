function isPF = isParticleFilterUsed(tracker, detectionHistory)
isemptyCell = cellfun(@(d) isempty(d), detectionHistory);
ind = find(~isemptyCell, 1, "first");
filter = tracker.FilterInitializationFcn(detectionHistory{ind}{1});
isPF = isa(filter, "trackingPF");
end