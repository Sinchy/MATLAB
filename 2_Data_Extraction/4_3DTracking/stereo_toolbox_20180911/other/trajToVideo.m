function [ mov ] = trajToVideo(tracks, limits, fileName)
% make a video from trajectories

frameRange = traj_getFrameRange(tracks);

loopIdx = 1;



for frameNo = frameRange(1):frameRange(end)
    pos3 = traj_getPositionsByFrame(tracks, frameNo);
    subplot(2,1,1)
    plot3(pos3(:,1), pos3(:,2), pos3(:,3), 'b.');
    axis equal;
    xlabel('x (mm)');
    ylabel('y (mm)');
    zlabel('z (mm)');
    xlim(limits.x);
    ylim(limits.y);
    zlim(limits.z);
    view([0 90]);
    
    subplot(2,1,2)
    plot3(pos3(:,1), pos3(:,2), pos3(:,3), 'b.');
    axis equal;
    xlabel('x (mm)');
    ylabel('y (mm)');
    zlabel('z (mm)');
    view([0 0]);
    
    ax = gca;
    ax.Units = 'pixels';
    xlim(limits.x);
    ylim(limits.y);
    zlim(limits.z);
    ax.Units = 'pixels';
    pos = ax.Position;
    marg = 10;
    %rect = [-marg, -marg, pos(3)+marg, pos(4)-2*marg];
    
    mov(loopIdx) = getframe(gcf);

    hold off
    loopIdx = loopIdx+1;
end

v = VideoWriter(fileName);
open(v);
writeVideo(v, mov);
close(v);

end

