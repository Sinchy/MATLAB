function RandomOpenValve(num_valve, time)
valveId = [1:88];
while(1)
    disp("---------------------------------------------------------------")
    valveID_open = randsample(valveId,num_valve);
    OpenValves(valveID_open);
    pause(time);
end
end

