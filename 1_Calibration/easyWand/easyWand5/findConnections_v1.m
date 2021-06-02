function [c,l] = findConnections_v1(s,e,m,d)

% function [c,l] = findConnections_v1(s,e,m,d)
%
% Finds the shortest paths or sequences that connect s to e where s and e are the
% start and end points in a sequence and the connections of the sequence
% are given by binary 2D array m. This program will return connection
% sequences up to depth d where d <= 2.  d=1 means consider sequences with
% one intervening node, d=2 means consider sequences with 2 intervening
% nodes.
%
% Outputs are c, a cell array where each cell contains a valid connection
% sequence and l, the number of steps in each connection chain.
%
% Ty Hedrick, 20150-06-19

% Possible Approaches
% 1) determine the set of all possible paths, search through it for valid
% ones.  Concern: the set of all possible paths is n! where n is the number
% of nodes; this grows rather rapidly and will run out of RAM well before
% being able to deal with larger groups of cameras, e.g. 20+.  It might be
% possible to formulate this as a sort of traveling salseman problem and
% solve it using the linear programming portion of the optimization
% toolbox.
%
% 2) try and find the shortest path for each node and return only that one,
% might be difficult to write a truly general algorithm for this - it will
% be necessary to specify how deep we're going to go to look for a
% connection.

% initialize output
c{1}=NaN;
l(1)=[NaN];


% check for the zero length connection
if m(s,e)==true
  c{1}=e;
  l(1)=0;
  return
end

% check for 1-step connections
% get a list of what s does connect to
s2=find(m(s,:)==true);
cnt=1;
for i=s2
  if m(i,e)==true
    c{cnt}=[i,e];
    l(cnt)=1;
    cnt=cnt+1;
    return
  end
end
if cnt>1 | d==1
  return
end

% check for 2-step connections
% get a list of what s does connect to
s2=find(m(s,:)==true);
cnt=1;
for i=s2
  % get a list of what s2 connects to
  mm=m(i,:);
  mm(s)=0;
  mm(i)=0;
  
  s3=find(mm==true);
  
  for j=s3
    if m(j,e)==true
      c{cnt}=[i,j,e];
      l(cnt)=2;
      cnt=cnt+1;
    end
  end
end

  

