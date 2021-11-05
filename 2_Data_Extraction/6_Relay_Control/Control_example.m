ncd=serial('COM8'); % assign serial port object
set(ncd, 'BaudRate', 115200); % set BaudRate to 9600
set(ncd, 'Parity', 'none'); % set Parity Bit to None
set(ncd, 'DataBits', 8); % set DataBits to 8
set(ncd, 'StopBit', 1); % set StopBit to 1
%display the properties of serial port object in MATLAB Window
disp(get(ncd,{'Type','Name','Port','BaudRate','Parity','DataBits','StopBits'}));
fopen(ncd);           % Open Serial Port Object
fwrite(ncd,254);      % ProXR Header Byte 
fwrite(ncd,108);      % Turn on Relay 1
fwrite(ncd,1);        % in Relay Bank 1
disp(fread(ncd,1));   % Read Confirmation Data
disp('Relay Is On');  % Tell User Relay has Activated
pause(1);             % Short Delay (not required) 
fwrite(ncd,254);      % ProXR Header Byte
fwrite(ncd,100);      % Turn off Relay 1
fwrite(ncd,1);        % in Relay Bank 1
disp(fread(ncd,1));   % Read Confirmation Data
disp('Relay Is OFF'); % Tell User Relay has Activated
fclose(ncd);          % Close Serial Port Object