%Extracts the grid for the grid defined on
%http://www.vision.ee.ethz.ch/~cwengert/calibration_toolbox.php
%
%Input:         im      The image to process
%               show    0 to not display any information graphically
%               minArea The minimum area a grid dot occupies
%               maxArea The minimum area a grid dot occupies
%Output:        success 1 if everything went ok
%               stats   The processed blobs of this image
%               id0     The index of the main bar
%               id1     The index of the second main bar
%               searchPoints    The potential grid points
%
%
%Christian Wengert
%Computer Vision Laboratory
%ETH Zurich
%Sternwartstrasse 7
%CH-8092 Zurich
%www.vision.ee.ethz.ch/cwengert
%wengert@vision.ee.ethz.ch
%
% modified by M. Himpel 2016

function [success, stats, cnt, id0, id1, searchPoints] = gridextractor_Micha(im, show, minArea, maxArea, minEllipticity, maxEllipticity, minSolidity, min_BarSize, selectBarManually, markerDiameter, barMode)
    %crop image
    if(nargin==1)
        show=0;
    end
    success = 0;
    stats = [];
    cnt = 0;
    searchPoints = [];
    %Indices for main bars
    idx = [];
    ids = [];
    id0 = -1;
    id1 = -1;    
    x_ = [];
    X_ = [];    
    %Show the image
    if(show)
        if(isfloat(im))
             imshow(im/255.0,'Border','tight','InitialMagnification', 'fit' ),hold on;
        else
            imshow(im, 'Border','tight', 'InitialMagnification', 'fit'),hold on;
        end
    end
    %Get the size of the image
    [h,w,bpp] = size(im);
    if(h<=0 && w<=0)
        return
    end
    if(bpp==3)
        img = rgb2gray(im);
    else
        img = im;
    end
    

    %used to filter for ellipticity
%     minEllipticity = 1.00;  %these variables are now set by the GUI
%     maxEllipticity = 14;
%     minSolidity = 0.60;
%     min_BarSize = 4000;
     %Used to filter by closeness to border->to close to border cannot be
     %correct
    borderRect = [0+30, 0+30, w-30, h-30];
    
    x0 = w/2;
    y0 = h/2;    
    imc = im;
    for i=1:w
        for j=1:h
            r = sqrt((x0-i)*(x0-i) + (y0-j)*(y0-j));
            if(r>160)
                imc(j,i) = 0;
            end
        end
    end
    
    %Rather median filter
    imb = medfilt2(img,[3 3]);              

    %Threshold
    % typical size that flatens the markes out:
    filterSize = round(markerDiameter*3);
    filterSigma = round(markerDiameter/2);
    
    h1 = fspecial('gaussian',filterSize, filterSigma);
    imf= (imfilter(im, h1));

    % create binary image with markers and orientation bars coloured white
    se = strel('disk',round(markerDiameter/10));
    medianFilterSize = round(markerDiameter/3);
    imt = ( imclose(medfilt2(im<imf,[medianFilterSize medianFilterSize]), se) );
    
    %Label
    iml = bwlabel(imt,8);
    %Extract features
    stats=regionprops(iml,'Centroid','Area','Orientation','MajorAxisLength','MinorAxisLength','ConvexHull','BoundingBox','Solidity');
    
    % Use bandpass-method to compude centroids:
    J = im;
    J = double(J)./255;
    J = J(:,:,1);
    J = 1-J;
    % get an estimate for the size of the markers
    % est_size_of_marker = round(  median([stats.MajorAxisLength])  );
    est_size_of_marker = markerDiameter;
    % be sure to get an odd number (bpass.m likes that!)
    if mod(est_size_of_marker,2) == 0 , est_size_of_marker=est_size_of_marker+1; end;
    % warning in case of crappy results
    % if est_size_of_marker<10 || est_size_of_marker>50 , display('Curious median marker size detected. Please Check.'); end;
    K = bpass(J,3,est_size_of_marker);
    for k = 1:length(stats)
        centers_temp = stats(k).Centroid;
        cnt_bpass = cntrd(K, round(centers_temp), 31);
        if ~isempty(cnt_bpass)
            stats(k).Centroid = cnt_bpass(1:2);
        end
    end
      
        
    %Extract values and put them into vectors, just makes it easier
    areas = [stats.Area];
    pts = [stats.Centroid];
    ptsx = pts(1:2:end);
    ptsy = pts(2:2:end);
    majors = [stats.MajorAxisLength];
    minors = [stats.MinorAxisLength];    
    solidity = [stats.Solidity];        
    
    %Now get the two major things
    cnt = 0;
    for i=1:length(stats)
        %Filter on closeness to border
        if(stats(i).Centroid(1)>borderRect(1) & stats(i).Centroid(1)<borderRect(3) & stats(i).Centroid(2) > borderRect(2) & stats(i).Centroid(2) <borderRect(4))
            %Filter area
            if(areas(i)>minArea & areas(i)<maxArea & solidity(i) > minSolidity )  
                idx = [idx;i];                
                %Filter on ellipticity
                if((majors(i)/minors(i))>minEllipticity & (majors(i)/minors(i))<maxEllipticity & areas(i)>min_BarSize)
                    if(show)
                        plot(stats(i).Centroid(1),stats(i).Centroid(2),'r+')
                    end
                    ids = [ids;i];
                    cnt = cnt+1;
                    %Delete it from searchPoints, serves as an ellipticity
                    %filter!
                    idx(end) = [];
                end
            end
        end
    end
    %Show area filtered blobs
    if(show)        
          for i=1:length(idx)
            plot(stats(idx(i)).Centroid(1),stats(idx(i)).Centroid(2),'go')                
          end
    end
    

        %Extract the main bars
        if selectBarManually==1, cnt=3; end % to enter the manual-loop below
        if(cnt==2)
            if(areas(ids(1))>areas(ids(2)))
                id0 = ids(1); id1 = ids(2);
            else
                id0 = ids(2); id1 = ids(1);
            end
            
            % look for the barMode setting and switch if neccessary
            [ id0, id1 ] = barModeSwitcher( stats, barMode, id0, id1 );
            
            %Test angle between main lines
            dir0 = (stats(id1).Centroid-stats(id0).Centroid);
            dir0 = dir0/norm(dir0);
            %get the orientation of main bar
            orientation = stats(id0).Orientation;
            y = tand(orientation);
            dir90 = [-1,y];
            dir90 = dir90/norm(dir90);
            %Check angle
            theta = acos((dir0*dir90')/(norm(dir0)*norm(dir90)))/pi*180;
            if(theta<30 | theta>150)
                 disp('gridextractor:: Could not find both main bars, bar-count = 1. ')
                 stats = [];
                 searchPoints = [];
                 success = 0;
                 cnt = 0;
                 id0 = 0;
                 id1 = 0;                    
            else            
                searchPoints = [areas(idx);...
                                ptsx(idx);...
                                ptsy(idx)];  
                success = 1;
                if(show)
                    text(stats(id0).Centroid(1)+5,stats(id0).Centroid(2)+5,'0','Color','m');
                    text(stats(id1).Centroid(1)+5,stats(id1).Centroid(2)+5,'1','Color','m');
                end
            end
            
        elseif(cnt>2)
            if selectBarManually==0
%                 disp('gridextractor:: Found too many possible candidates, trying to choose the correct ones')            
%                 %get the two blobs that are closest to each other!
%                 a = [];
%                 xb = [];
%                 %Sort by Area 
%                 for i=1:length(ids)
%                     xb = [xb, [stats(ids(i)).Centroid(1);stats(ids(i)).Centroid(2)]];
%                     if(xb(1,i) > 50 | xb(1,i) < (w-50) | xb(2,i) > 50 | xb(2,i) < (h-50))
%                         a = [a;stats(ids(i)).Area];
%                     else 
%                         a = [a;-1];
%                     end
%                 end 
% 
%                 [a,ixxx] = sort(a);
%                 %Take the two biggest ones
%                 id0 = ids(ixxx(end));
%                 id1 = ids(ixxx(end-1));  
                
                %get the two blobs that are closest to the center
                closeness=[];
                sorted_by_closeness = [];
                center_of_image = [w/2 h/2];
                for i=1:length(ids)
                    closeness(i)=norm(center_of_image - stats(ids(i)).Centroid);
                end
                sorted_by_closeness = sortrows([closeness' ids],1);
                sorted_by_closeness = sorted_by_closeness(:,2)';
                

                % expect: the larger bar has greater ellipticity
                % TODO: identify bars by existence of intersection when
                %       enlarging
                if ((majors(sorted_by_closeness(1)))/minors(sorted_by_closeness(1)))>((majors(sorted_by_closeness(2)))/minors(sorted_by_closeness(2)))
                    id0 = sorted_by_closeness(1);
                    id1 = sorted_by_closeness(2);
                else
                    id0 = sorted_by_closeness(2);
                    id1 = sorted_by_closeness(1);
                end
                
                % look for the barMode setting and switch if neccessary
                [ id0, id1 ] = barModeSwitcher( stats, barMode, id0, id1 );
                
            else
                %here the manual bar selection begins
                [mouseX mouseY] = ginput(2);
                centroids = cat(1, stats.Centroid);
                id0 = find(abs(centroids(:,1) - mouseX(1))<10 & abs(centroids(:,2) - mouseY(1))<10);
                id1 = find(abs(centroids(:,1) - mouseX(2))<10 & abs(centroids(:,2) - mouseY(2))<10);
                
                if (length(id0)~=1) || (length(id1)~=1)
                    display('more than two bars match the clicks');
                    return;
                end
                
            end
             %Directions
%             if selectBarManually==0
%                     dir0 = (stats(id1).Centroid-stats(id0).Centroid);
%                     dir0 = dir0/norm(dir0);
%                     %get the orientation of main bar
%                     orientation = stats(id0).Orientation;    
%                     y = tand(orientation);   
%                     dir90 = [-1,y];
%                     dir90 = dir90/norm(dir90);
%                     %Check angle
%                     theta = acos((dir0*dir90')/(norm(dir0)*norm(dir90)))/pi*180;
%                     if(theta<60 | theta>120)
%                         id1 = ids(ixxx(end-2));  
%                         %Test again
%                         dir0 = (stats(id1).Centroid-stats(id0).Centroid);
%                         dir0 = dir0/norm(dir0);
%                         %get the orientation of main bar
%                         orientation = stats(id0).Orientation;
%                         y = tand(orientation);
%                         dir90 = [-1,y];
%                         dir90 = dir90/norm(dir90);
%                         %Check angle
%                         theta = acos((dir0*dir90')/(norm(dir0)*norm(dir90)))/pi*180;
%                         if(theta<60 | theta>120)
%                              disp('gridextractor:: Could not find both main bars, bar-count = 1. ')
%                              stats = [];
%                              searchPoints = [];
%                              success = 0;
%                              cnt = 0;
%                              id0 = 0;
%                              id1 = 0;                    
%                         end
%                     end
%             end
            if(show)
                text(stats(id0).Centroid(1)+5,stats(id0).Centroid(2)+5,'0','Color','y');
                text(stats(id1).Centroid(1)+5,stats(id1).Centroid(2)+5,'1','Color','y');
            end
            cnt = 2;
            success = 1;
            searchPoints = [areas(idx);...
                            ptsx(idx);...
                            ptsy(idx)];         
        else
            disp('gridextractor:: Could not find both main bars, bar-count = 1. ')
            stats = [];
            searchPoints = [];
            success = 0;
            cnt = 0;
            id0 = 0;
            id1 = 0;  
        end    
     
%         disp('gridextractor:: Problems extracting the main bars. Please verify whether it is visible in this image.')
% %         s = lasterror;
% %         disp(['gridextractor:: ' s.message ' in function ' s.stack.name ' in ' s.stack.file ' @line ' num2str(s.stack.line)])
%         stats = [];
%         searchPoints = [];
%         success = 0;
%         cnt = 0;
%         id0 = 0;
%         id1 = 0;

    

