function DynamicOverlapAndCheck(path,tracks, cam, VSCpath, frame_range)
figure; duration = 10;

for i = frame_range(1) : frame_range(2) - duration
    Overlapandcheck(path,tracks, cam, VSCpath, [i i + duration]);
    pause(0.001);
end

end

