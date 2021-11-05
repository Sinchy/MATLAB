board1 = serialport("COM5",19200, "Timeout",1); %1~30
configureTerminator(board1,"CR");
board2 = serialport("COM6",19200, "Timeout",1); %31~58
configureTerminator(board2,"CR");
board3 = serialport("COM4",19200, "Timeout",1); %59~88
configureTerminator(board3,"CR");

%%
while(1)
writeline(board1, "relay writeall 00000000");
pause(1)
writeline(board1, "relay writeall ffffffff");
pause(1)
end
%%
clear board1
%%
while(1)
writeline(board1, "relay writeall 00000000");
pause(1)
writeline(board1, "relay writeall ffffffff");
pause(1)
end
%%
clear board1