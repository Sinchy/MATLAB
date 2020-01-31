function MyCheckTime(StartTime,itmax,MaxTime)

% This function checks the length of simuation time.

if ((StartTime) < 3)
   fprintf('\n Error: StartTime < 3! \n');
   fprintf(' Press Ctrl+C to terminate! \n');
   pause(99);
end

if ((StartTime+itmax+2) > MaxTime)
   fprintf('\n Error: (StartTime+itmax) > (MaxTime-2)! \n');
   fprintf(' Press Ctrl+C to terminate! \n');
   pause(99);
end

end

