%this function saves numeric data in a text file
%created by Ricardo Mejia-Alvarez.
%University of Illinois at Urbana-Champaign
%Urbana, IL. 06/11/2010

function saverappend(folResults,filename,heading,data)

name = strcat(folResults,filename);        
dlmwrite(name,heading,'delimiter','','newline','pc','-append')
dlmwrite(name,data,'delimiter','\t','newline','pc','-append')
end