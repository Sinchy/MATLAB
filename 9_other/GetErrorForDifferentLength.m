    
for i=1 : num_good   
        % display progress of loop

%         percent = parfor_progress;
%         showTimeToCompletion( percent/100, [], [], startTime );

        tracks = or3d_map.Data.tracks(or3d_map.Data.tracks(:,5) == c(i),:);
%          tracks = GetTracks(datapath, c(i));
        
        % get the track data for the ith track
        
        if size(tracks,1)<=(2*fitwidth+1)
            delete_index(1, i) = 1;
            continue;
        end
        
        % define the convolution kernel
%         Av = 1.0/(0.5*filterwidth^2 * ...
%             (sqrt(pi)*filterwidth*erf(fitwidth/filterwidth) - ...
%             2*fitwidth*exp(-fitwidth^2/filterwidth^2)));


        % position kernel
        fitl = 1:fitwidth;
        Av = 1./(2.*sum(exp(-(fitl.*fitl)./filterwidth^2))+1);
        rkernel = -fitwidth:fitwidth;
        rkernel = Av.*exp(-rkernel.^2./filterwidth^2);

        
        % velocity kernel


        fitl = 1:fitwidth;
        Av = 1./(2.*sum((fitl.*fitl).*exp(-(fitl.*fitl)./filterwidth^2)));
        vkernel = -fitwidth:fitwidth;
        vkernel = Av.*vkernel.*exp(-vkernel.^2./filterwidth^2);
        
        
        % acceleration kernel
        w = filterwidth;
        rwsq = 1./(w^2);
        coef = 2.*rwsq./(sqrt(pi).*w);
        
        fitl = -fitwidth:fitwidth;
        sumtsq = sum(fitl.*fitl);
        sumk = sum(coef.*(2.*fitl.*fitl.*rwsq-1)./exp(fitl.*fitl.*rwsq));
        sumktsq = sum(fitl.*fitl.*coef.*(2.*fitl.*fitl.*rwsq-1)./exp(fitl.*fitl.*rwsq));

        A = 2./(sumktsq - sumk.*sumtsq./(2*fitwidth));
        B = -A.*sumk./(2*fitwidth);
        
        
        akernel = -fitwidth:fitwidth;
        akernel = A.*coef.*(2.*akernel.^2.*rwsq-1)./exp(akernel.^2.*rwsq)+B;
        
        
                % loop over tracks
                
        x1 = conv(tracks(:,1),rkernel,'valid');
        y1 = conv(tracks(:,2),rkernel,'valid');
        z1 = conv(tracks(:,3),rkernel,'valid');
        xtmp = [x1,y1,z1];
        
        error0 = zeros(1, 3);
        for j = 1 : 3
            error0(j) = mean(abs(xtmp(:, j) - tracks(10:end-9, j)));
        end
        error = norm(error0);
        
        if error > std_error 
            delete_index(1, i) = 1;
            continue;
        end
        
        good_no = good_no + 1;
        error_good(good_no) = error;
        
        if good_no > no_good
            average_error = mean(error_good);
            deviate_error = std(error_good);
            std_error = average_error + 4 * deviate_error;
        end
        
        u1 = -conv(tracks(:,1),vkernel,'valid');
        v1 = -conv(tracks(:,2),vkernel,'valid');
        w1 = -conv(tracks(:,3),vkernel,'valid');
        utmp = [u1,v1,w1];
        
        ax = conv(tracks(:,1),akernel,'valid');
        ay = conv(tracks(:,2),akernel,'valid');
        az = conv(tracks(:,3),akernel,'valid');
        atmp = [ax,ay,az];
               
%         
%         x(pointer:pointer+size(xtmp,1)-1,:)=xtmp;
%         u(pointer:pointer+size(xtmp,1)-1,:)=utmp.*framerate;
%         a(pointer:pointer+size(xtmp,1)-1,:)=atmp.*framerate.*framerate;
%         
        
%         filter_data(pointer:pointer+size(u1,1)-1,:)=[xtmp,tracks(fitwidth+1:end-fitwidth,4:5),utmp.*framerate,atmp.*framerate.*framerate];
     
%         pointer=pointer+size(xtmp,1);

% use struct variable to make data sliced and processible by parfor
        filter_data_package{i, 1} = [xtmp,tracks(fitwidth+1:end-fitwidth,4:5),utmp.*framerate,atmp.*framerate.*framerate];
         
end