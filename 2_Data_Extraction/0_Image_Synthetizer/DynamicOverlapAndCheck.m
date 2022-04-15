function DynamicOverlapAndCheck(path,tracks, cam, VSCpath, frame_range)
fig = figure; duration = 10;
% key = 'rightarrow';
current_frame = 1;
playback = 0;
ps = 0;
% playforward = 1;
warning('off','all')
while(1)
for i = current_frame : frame_range(2) - duration
    Overlapandcheck(path,tracks, cam, VSCpath, [i i + duration]);
    figure(fig)
    pause(0.01);
    key = get(fig, 'CurrentKey');
    if ~strcmp(key ,'rightarrow')  % if not play forward
        if strcmp(key ,'leftarrow') 
            current_frame = i;
            playback = 1;
            break;
        end
        if strcmp(key ,'space') 
            current_frame = i;
            ps = 1;
            break;
        end
    end
end

if playback
   for i = current_frame : -1: 1
        Overlapandcheck(path,tracks, cam, VSCpath, [i i + duration]);
         figure(fig)
    pause(0.01);
    key = get(fig, 'CurrentKey');
        if ~strcmp(key ,'leftarrow') % if not play backward
            if strcmp(key ,'rightarrow')
                current_frame = i;
                playback = 0;
                break;
            end
            if strcmp(key ,'space') 
                current_frame = i;
                ps = 1;
            break;
        end
        end
    end
end

if ps
    figure(fig)
    pause(0.01);
    key = get(fig, 'CurrentKey');
    if ~strcmp(key ,'space')  % if not play forward
        if strcmp(key ,'rightarrow') 
            ps = 0;
%             break;
        end
        if strcmp(key ,'leftarrow') 
            playback = 1;
            ps = 0;
%             break;
        end
    end
end

end
end
