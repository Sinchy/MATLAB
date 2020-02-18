%this function saves numeric data in a text file
%created by Ricardo Mejia-Alvarez. Urbana, IL. 07/16/08

function saver(folResults,filename,heading,data)

mkdir(folResults)

name = strcat(folResults,filename);        
dlmwrite(name,heading,'delimiter','','newline','pc')
dlmwrite(name,data,'delimiter','\t','newline','pc','-append')
end