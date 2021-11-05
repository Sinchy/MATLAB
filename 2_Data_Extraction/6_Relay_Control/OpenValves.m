function OpenValves(valveID_open)
board1 = serialport("COM5",19200, "Timeout",1); %1~30
configureTerminator(board1,"CR");
board2 = serialport("COM6",19200, "Timeout",1); %31~58
configureTerminator(board2,"CR");
board3 = serialport("COM4",19200, "Timeout",1); %59~88
configureTerminator(board3,"CR");
load valveID_on_bd.mat

ind1_open = ismember(valve_on_bd1, valveID_open);
ind1_open_h = binaryVectorToHex(ind1_open');
ind2_open = ismember(valve_on_bd2, valveID_open);
ind2_open_h = binaryVectorToHex(ind2_open');
ind3_open = ismember(valve_on_bd3, valveID_open);
ind3_open_h = binaryVectorToHex(ind3_open');

display("Board1: relay writeall " + num2str(ind1_open_h));
display(flip(valve_on_bd1(ind1_open)'))
writeline(board1, "relay writeall " + lower(num2str(ind1_open_h)));
display("Board2: relay writeall " + num2str(ind2_open_h));
display(flip(valve_on_bd2(ind2_open)'))
writeline(board2, "relay writeall " + lower(num2str(ind2_open_h)));
display("Board3: relay writeall " + num2str(ind3_open_h));
display(flip(valve_on_bd3(ind3_open)'))
writeline(board3, "relay writeall " + lower(num2str(ind3_open_h)));

clear board1 board2 board3
end

