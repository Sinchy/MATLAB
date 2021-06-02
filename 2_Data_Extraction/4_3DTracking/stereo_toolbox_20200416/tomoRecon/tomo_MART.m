function basisFunction = tomo_MART(I_rec, basisFunction, mu )
% This function is the implementation of the MART-algorithm as given in
% G.E. Elsinga et al., Exp Fluids (2006) 41:933-947



%% preparations
for k = 1:length(I_rec)
     I_rec{k}(I_rec{k}<median(I_rec{k})+1) = 0;
    I_rec{k} = (double(I_rec{k})./255)';
   %I_rec{k} = (double(I_rec{k}))';
end

%% processing
% fprintf(1,'Camera ');
% for camNo = 1:4
%     fprintf(1,'%i: ',camNo);
%     % for EVERY pixel of camera
%     
%     for indPixelLoop = 1:size(wCoeff,2)
%         fprintf(1,'pixel %08d',indPixelLoop);
%         
%         
%         contributingVoxels = wCoeff(camNo,indPixelLoop).voxels;
%         
%         pixIntens = I_rec{camNo}(wCoeff(camNo,indPixelLoop).pixel);
%         % for every voxel, that constitutes to this pixel
%         
%         sumOfParticipants = sum( basisFunction(contributingVoxels).*...
%             wCoeff(camNo,indPixelLoop).coeffs);
%         
%         if sumOfParticipants == 0
%             basisFunction(contributingVoxels) = 0;
%         else
%             voxCounter = 1;
%             
%             for indVoxel = reshape(contributingVoxels, 1, [])
%                 % go for MART!
%                 wij = wCoeff(camNo,indPixelLoop).coeffs(voxCounter) ;
%                 
%                 basisFunction(indVoxel) = basisFunction(indVoxel) * ...
%                     ( pixIntens / sumOfParticipants ) ^( mu * wij );
%                 
%                 voxCounter = voxCounter +1;
%             end
%             
%         end
%         fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
%     end
%     fprintf(1,'\b\b\b');
% end
% 
% fprintf(1,'\b\b\b\b\b\b\b');

fprintf(1,'Camera ');
for camNo = 1:4
    fprintf(1,'%i: ',camNo);
    % for EVERY pixel of camera
    wCoeff = load(sprintf('wij%d.mat',camNo));
    switch camNo
        case 1
            wCoeff = wCoeff.wij1;
        case 2
            wCoeff = wCoeff.wij2;
        case 3
            wCoeff = wCoeff.wij3;
        case 4
            wCoeff = wCoeff.wij4;
    end

    for indPixelLoop = 1:size(wCoeff,2)
        fprintf(1,'pixel %08d',indPixelLoop);
        
        
        contributingVoxels = wCoeff(indPixelLoop).voxels;
        
        pixIntens = I_rec{camNo}(wCoeff(indPixelLoop).pixel);
        % for every voxel, that constitutes to this pixel
        
        sumOfParticipants = sum( basisFunction(contributingVoxels).*...
            wCoeff(indPixelLoop).coeffs);
        
        if sumOfParticipants == 0
            basisFunction(contributingVoxels) = 0;
        else
            voxCounter = 1;
            
            for indVoxel = reshape(contributingVoxels, 1, [])
                % go for MART!
                wij = wCoeff(indPixelLoop).coeffs(voxCounter) ;
                
                basisFunction(indVoxel) = basisFunction(indVoxel) * ...
                    ( pixIntens / sumOfParticipants ) ^( mu * wij );
                
                voxCounter = voxCounter +1;
            end
            
        end
        fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b\b\b\b');
    end
    fprintf(1,'\b\b\b');
    clear wCoeff;
end

fprintf(1,'\b\b\b\b\b\b\b');

end


