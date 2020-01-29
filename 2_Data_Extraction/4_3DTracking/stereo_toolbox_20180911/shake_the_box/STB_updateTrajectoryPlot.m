function [ tracks ] = STB_updateTrajectoryPlot(tracks)
% create a new plot or handle the existing plots

figHnd = findobj('tag', 'trajPlot');
axHnd  = findobj('tag', 'trajAx');

if isempty(figHnd)
    figHnd = figure( 'tag', 'trajPlot' );
    axHnd = axes('tag', 'trajAx'); axis equal; hold on;
    xlabel('x (mm)');
    ylabel('y (mm)');
    zlabel('z (mm)');
    view(20,20);
end

for k = 1:size(tracks,2)
    if isempty(tracks(k).plotHandle)
        tracks(k).plotHandle = plot3(axHnd,tracks(k).position(:,1),tracks(k).position(:,2) ,tracks(k).position(:,3) );
    else
        try
        col = get(tracks(k).plotHandle, 'Color');
        catch 
            keyboard
        end
        delete(tracks(k).plotHandle);
        tracks(k).plotHandle = plot3(axHnd,tracks(k).position(:,1),tracks(k).position(:,2) ,tracks(k).position(:,3), 'Color', col );           
    end
end

end

