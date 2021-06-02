function [tracks_new] = traj_singleview(tracks,out,tracks_with_predictions)

% show 2 subplots with (1) 3d-trajectory and (2) zero-mean plots of single
% coordinates x,y,z. By pressing Return you advance to the next trajectory.

% Optional: keep only those trajectories, that you want to. Just click to 
% any random place in the figure for the trajectories you want to keep.

%--------------------------------------------------------------------------
%     Copyright (C) 2016 Michael Himpel (himpel@physik.uni-greifswald.de)
%     
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------

if nargin < 2; out=0; end;
if nargin < 3; tracks_with_predictions = []; doPred = 0; end;
if nargin == 3; doPred=1; end;

for i=1:length(tracks); 
    if size(tracks{i},1)>10
        subplot(3,1,1)
        plot3(tracks{i}(:,12), tracks{i}(:,13), tracks{i}(:,14), '-'); 
        title(['Trajectory ',int2str(i)])
        axis equal tight; xlabel('x'); ylabel('y'); zlabel('z');
        
        subplot(3,1,2); hold off
        plot(tracks{i}(:,6), tracks{i}(:,12) , 'b-');hold on;
        if doPred
            plot(tracks_with_predictions(i).frames,tracks_with_predictions(i).prediction(:,1),'bo');
        end
        
        plot(tracks{i}(:,6), tracks{i}(:,13), '-','Color','r');
        if doPred
            plot(tracks_with_predictions(i).frames,tracks_with_predictions(i).prediction(:,2),'ro');
        end
        plot(tracks{i}(:,6), tracks{i}(:,14), '-','Color','k');
        if doPred
            plot(tracks_with_predictions(i).frames,tracks_with_predictions(i).prediction(:,3),'ko');
        end
        if doPred
            plot(tracks_with_predictions(i).frames,tracks_with_predictions(i).cost(:),'-gd');
        end
        legend('x','predX','y','predY','z','predZ','Cost');
        
        
        subplot(3,1,3)
        Va = tracks{i}(:,13) - mean(tracks{i}(:,13));
        Va = sgolayfilt(Va,2,9);
        Fs=260 ; % insert here your frequency sampling in Hz
        L=length(Va);
        NFFT = 2^nextpow2(L);
        Y  = fft(Va,NFFT)/L;
        f = Fs/2*linspace(0,1,NFFT/2+1);
        
        plot(f,2*abs(Y(1:NFFT/2+1)))
        title('Single-Sided Amplitude Spectrum of y(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|')
        set(gca,'XLIM',[0 50]);
        
        
        if out==0;
           % [~]=ginput;
           pause;
        else
            tmp=ginput;
            if length(tmp==1)
                gut(i)=1;
            else
                gut(i)=0;
            end
            clear tmp
        end
    end
end; 

% if output of picked trajectories is wanted -> build new array
if out==1
    c=1;                    %counting
    for i=1:length(gut);
        if gut(i)==1;
            tracks_new{c}=tracks{i};
            c=c+1;
        end
    end
end
