function [vel_jet, vel_meanflow, J] = JetVel(flowrate_jet, flowrate_total, num_jets)
% jet diameter: 5 mm
rad_jet = 5 / 2 / 1000; %unit: m
vel_jet = flowrate_jet / ( pi * rad_jet ^ 2 * num_jets);
% square : 2x2 cm^2, 52
vel_meanflow = (flowrate_total - flowrate_jet) / ( 52 * 2 * 2 / 100 ^ 2);
J = flowrate_jet / (flowrate_total - flowrate_jet);
end

