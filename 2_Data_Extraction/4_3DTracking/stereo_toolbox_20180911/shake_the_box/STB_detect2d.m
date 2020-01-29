function [ pos2d ] = STB_detect2d( STB_params, I_res, frameNo )
% This function detects 2d positions in given residual images as utput from
% STB_getResidualImage.m.
for camNo = 1:length(I_res)
    I_bp = bpass(double(I_res{camNo}), STB_params.detect2d.lNoise, STB_params.detect2d.lObject);
    
    % apply threshold to
    pkfnd_out = pkfnd(I_bp, STB_params.detect2d.threshold, STB_params.detect2d.lObject);
    
    if isempty(pkfnd_out) % if no particles could be found in that image
        pos = [];
    else
        pos = cntrd(double(I_res{camNo}), pkfnd_out, STB_params.detect2d.lObject, 0);
    end
    try
    pos2d{camNo} = pos(:,1:2);
    catch 
        keyboard
    end
end

% write 2d positions to file
for camNo = 1:length(I_res)
    pos2d_out(1:size(pos2d{camNo},1),camNo*2-1:camNo*2) = pos2d{camNo};
end

fmask = STB_params.detect2d.output2dFilemask;
dlmwrite(sprintf(fmask,frameNo), pos2d_out);

end

