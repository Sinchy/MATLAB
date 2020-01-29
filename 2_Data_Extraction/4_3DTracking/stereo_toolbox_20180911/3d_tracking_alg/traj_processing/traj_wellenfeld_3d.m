function [D , DN , DS] = traj_wellenfeld_3d(tracks,minLen,coord,width,s,G)

% 3D-Wellenfeld-Analyse anhand von Hilbert-analysierten Daten. Die 
% entsprechende Größe wird dabei auf ein 3D-Gitter interpoliert. Eingabe:
% TRACKS: Trajektoriensatz
% MINLEN: Mindestlänge der Trajektorien
% COORD: zu untersuchende Koordinate: 1->x , 2->y, 3->z
% WIDTH: Filterbreite um Daten zu zero-mean-en 
%                                       (Beispielempfehlung: width=17)
% S: Zu untersuchende Eigenschaft: 4->inst. Amplitude, 7-> inst. Frequenz
% G: Gittergenauigkeitsfaktor: 
%       G=1 -> unverändert  
%       G>1 -> Verfeinerung des Gitters (Beispielempfehlung: G=2)

% Output:
% D - Datenmatrix
% DN - Matrix mit Anzahl der beitragenden Partikelpositionen für die
% Gitterpunkte
% DS - Matrix mit der Standardabweichung der Matrix D

%--------------------------------------------------------------------------
%     Copyright (C) 2014 Carsten Killer (killer@physik.uni-greifswald.de)
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
if nargin < 6
    disp('Input arguments missing');
    return;
end

%% Zu kurze Trajektorien rausfiltern
tracks_lang = traj_filterLen(tracks, minLen);

%% Hilbert-Analyse durchführen
result_hilbert=traj_hilbert(tracks_lang,coord,1,180,width);

%% Berechnung des Gitters

extr=zeros(length(tracks_lang),6);
tracks_tmp=cell(length(tracks_lang),1);

for i=1:length(tracks_lang)
    tracks_tmp{i}(:,1:3)=G.*tracks_lang{i}(:,12:14);
    extr(i,1) = floor(min(tracks_tmp{i}(:,1)));   %min(x)
    extr(i,2) = floor(min(tracks_tmp{i}(:,2)));   %min(y)
    extr(i,3) = floor(min(tracks_tmp{i}(:,3)));   %min(z)
    extr(i,4) = ceil(max(tracks_tmp{i}(:,1)));    %max(x)
    extr(i,5) = ceil(max(tracks_tmp{i}(:,2)));    %max(y)
    extr(i,6) = ceil(max(tracks_tmp{i}(:,3)));    %max(z)
end

mmin=min(extr);
mmax=max(extr);

%endpunkte des gitters
absminx=mmin(1);
absminy=mmin(2);
absminz=mmin(3);
absmaxx=mmax(4);
absmaxy=mmax(5);
absmaxz=mmax(6);

%gittervektoren
nx = absminx:1:absmaxx; 
ny = absminy:1:absmaxy;
nz = absminz:1:absmaxz;

% Datenmatrix
D = zeros(length(nx),length(ny),length(nz));
% Matrix zum Mitzählen der Einträge auf einem Gitterpunkt (für spätere
% Mittelwertbildung
DN = zeros(length(nx),length(ny),length(nz));
% Matrix für STD-Berechnung
DS=zeros(length(nx),length(ny),length(nz));
    
%% Daten aufs Gitter bringen

%Schleife durch alle Trajektorien
for i=1:length(tracks_tmp);
    %schleife durch alle Zeitpunkte einer Trajektorie
    for j=1:size(result_hilbert{i},1)

        %finde (links) benachbarte gitterpunkte
        lx = floor(tracks_tmp{i}(j+width,1)); 
        ly = floor(tracks_tmp{i}(j+width,2)); 
        lz = floor(tracks_tmp{i}(j+width,3)); 

        %index (links) benachbarter gitterpunkte
        ilx = lx+1-absminx;
        ily = ly+1-absminy;
        ilz = lz+1-absminz;
        
        %abstand zum eigentlichen punkt(1D)
        dx = tracks_tmp{i}(j+width,1)-lx;
        dy = tracks_tmp{i}(j+width,2)-ly;
        dz = tracks_tmp{i}(j+width,3)-lz;
        
        % den dichteren Nachbarn auswählen (das geht noch besser)
        if dx <0.5
            indfx=ilx;
        else
            indfx=ilx+1;
        end
        if dy <0.5
            indfy=ily;
        else
            indfy=ily+1;
        end        
        if dz <0.5
            indfz=ilz;
        else
            indfz=ilz+1;
        end
        
        % nur frequenzen mitnehmen, die im realistischen bereich liegen
        if ((s==7 && result_hilbert{i}(j,s) < 20 && result_hilbert{i}(j,s) > 0) || s==4)
            % Wert auf dichtesten Gitterpunkt setzen
            D(indfx,indfy,indfz) = D(indfx,indfy,indfz) + result_hilbert{i}(j,s);         
            % Anzahl der Werte an dem Punkt merken, damit richtiger Mittelwert gebildet werden kann.
            DN(indfx,indfy,indfz) = DN(indfx,indfy,indfz) + 1;
        end
    end
end 

%für Mittelwertbildung muss noch dividiert werden
D = D./DN;
%NaNs 0 setzen zum Darstellen mit Isosurface
D(isnan(D))=0;

%jetzt nochmal durch alle Trajektorien für die STD-Berechnung
for i=1:length(tracks_tmp);
    %schleife durch alle Zeitpunkte einer Trajektorie
    for j=1:size(result_hilbert{i},1)

        %finde (links) benachbarte gitterpunkte
        lx = floor(tracks_tmp{i}(j+width,1)); 
        ly = floor(tracks_tmp{i}(j+width,2)); 
        lz = floor(tracks_tmp{i}(j+width,3)); 

        %index (links) benachbarter gitterpunkte
        ilx = lx+1-absminx;
        ily = ly+1-absminy;
        ilz = lz+1-absminz;
        
        %abstand zum eigentlichen punkt(1D)
        dx = tracks_tmp{i}(j+width,1)-lx;
        dy = tracks_tmp{i}(j+width,2)-ly;
        dz = tracks_tmp{i}(j+width,3)-lz;
        
        % den dichteren Nachbarn auswählen (das geht noch besser)
        if dx <0.5
            indfx=ilx;
        else
            indfx=ilx+1;
        end
        if dy <0.5
            indfy=ily;
        else
            indfy=ily+1;
        end        
        if dz <0.5
            indfz=ilz;
        else
            indfz=ilz+1;
        end
        
        %nur frequenzen mitnehmen, die im realistischen bereich liegen
        if ((s==7 && result_hilbert{i}(j,s) < 20 && result_hilbert{i}(j,s) > 0) || s==4)
            %quadrierte Differenz zum Mittelwert aufsummieren
            DS(indfx,indfy,indfz) = DS(indfx,indfy,indfz) + (result_hilbert{i}(j,s) - D(indfx,indfy,indfz))^2;         
        end
    end
end 

DS=DS./(DN-1);  %Quadratsummen durch n-1 dividieren
DS=sqrt(DS);    %wurzel -> jetzt ist die standardabweichung fertig
DS(isnan(DS))=0; %etwaige NaNs entfernen (falls DN=1 war)

%% Plotting Isosurfaces

if s==7
    % frequenzen
    figure;
    LEVELS = [7 9 11 13];
    TRANSP = [0.08 0.12 0.2 0.3];
    cmap = colormap(jet(length(LEVELS)));
    hold on;
    for j=1:length(LEVELS)
        lev=LEVELS(j);
        fv = isosurface(1:size(D,2), 1:size(D,1), 1:size(D,3), D, lev);
        patch(fv, 'facealpha', TRANSP(j), 'edgecolor', 'none', 'facecolor', cmap(lev==LEVELS,:));
    end;
    title(['Instantane Frequenz: Farblevels ',int2str(LEVELS)])
    view(100,5); box on; grid on;  %xlim([0 17]); ylim([0 12]); zlim([0 12]);
    xlabel('y (mm)'); ylabel('x (mm)'); zlabel('z(mm)'); 

    % freq. std
    figure;
    LEVELS = [1 2 4 7];
    TRANSP = [0.08 0.12 0.2 0.3];
    hold on;
    for j=1:length(LEVELS)
        lev=LEVELS(j);
        fv = isosurface(1:size(DS,2), 1:size(DS,1), 1:size(DS,3), DS, lev);
        patch(fv, 'facealpha', TRANSP(j), 'edgecolor', 'none', 'facecolor', cmap(lev==LEVELS,:));
    end
    title(['STD(Instantane Frequenz): Farblevels ',int2str(LEVELS)])
    view(100,5); box on; grid on;  %xlim([0 17]); ylim([0 12]); zlim([0 12]);
    xlabel('y (mm)'); ylabel('x (mm)'); zlabel('z(mm)'); 
end

if s==4
    % amplituden
    figure;
    LEVELS = [0.02 0.1 0.2 0.3];
    TRANSP = [0.1 0.15 0.2 0.3];
    cmap = colormap(jet(length(LEVELS)));
    hold on;
    for j=1:length(LEVELS)
        lev=LEVELS(j);
        fv = isosurface(ny,nx,nz, D, lev);
        patch(fv, 'facealpha', TRANSP(j), 'edgecolor', 'none', 'facecolor', cmap(lev==LEVELS,:));
    end;  
    title(['Instantane Amplitude: Farblevels ',num2str(LEVELS)])
    view(100,5); box on; grid on;  %xlim([0 17]); ylim([0 12]); zlim([0 12]);
    xlabel('y (mm)'); ylabel('x (mm)'); zlabel('z(mm)'); 
    set(gca,'linewidth',1,'fontsize',16)
    hold on; 
    for i=1:length(tracks_tmp) 
        plot3(tracks_tmp{i}(:,2),tracks_tmp{i}(:,1),tracks_tmp{i}(:,3),'color',[0.3 0.3 0.3]); 
    end

    % amplituden std
    figure;
    LEVELS = [0.01 0.03 0.06 0.15];
    TRANSP = [0.08 0.12 0.2 0.3];  
    hold on;
    for j=1:length(LEVELS)
        lev=LEVELS(j);
        fv = isosurface(ny,nx,nz, DS, lev);
        patch(fv, 'facealpha', TRANSP(j), 'edgecolor', 'none', 'facecolor', cmap(lev==LEVELS,:));
    end;
    title(['STD(Instantane Amplitude): Farblevels ',num2str(LEVELS)])
    view(100,5); box on; grid on;  %xlim([0 17]); ylim([0 12]); zlim([0 12]);
    xlabel('y (mm)'); ylabel('x (mm)'); zlabel('z(mm)'); 
end
