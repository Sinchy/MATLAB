function DynamicOverlapAndCheck(path,tracks, radius, cam, VSCpath, frame_range)
fig = figure; duration =0 ;
% key = 'rightarrow';
current_frame = frame_range(1);
playback = 0;
ps = 0;
% playforward = 1;
warning('off','all')
while(1)
for i = current_frame : frame_range(2) - duration
    Overlapandcheck(path,tracks, radius,  cam, VSCpath, [i i + duration]);
    figure(fig)
    
    pause(0.005);
    key = get(fig, 'CurrentKey');
    title([num2str(i/5) 'ms']);
     pause(0.005);
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
    if i == frame_range(2) - duration
        current_frame = frame_range(1);
    end
end

if playback
   for i = current_frame : -1: 1
        Overlapandcheck(path,tracks, radius, cam, VSCpath, [i i + duration]);
         figure(fig)
    pause(0.005);
    key = get(fig, 'CurrentKey');
    title([num2str(i/5) 'ms']);
     pause(0.005);
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
