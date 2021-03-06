% INDICATE BELOW WHICH SPREADSHEETS TO USE
trace_file = uigetfile('*.csv');
structure_file = extractBefore(trace_file, '_current.csv') + "_events_complete_T.csv"; % MAY NEED TO CHANGE THE ENDING HERE TO GET RIGHT EVENTS SPREADSHEET
% trace is the full current trace (one column)
trace = readmatrix(trace_file);
% structure is the event indices spreadsheet from Clampfit
structure = readcell(structure_file);
add_amount = 0;

nums = [8];
%nums = [26, 33, 40, 57];

running_trace = [];

for num = nums
    start_ind = round(structure{num, 2} * 1000 / 0.96)-add_amount;
    disp("Start ind: " + start_ind)
    end_ind = round(structure{num, 3} * 1000 / 0.96)+add_amount;
    disp("End in: " + end_ind)
    old_trace_length = length(trace);
    disp("Total trace length: " + length(trace))
    disp("Trace File: " + trace_file)
    baseline = structure{num, 11};
    background = trace(start_ind:end_ind) - baseline;
    running_trace = [running_trace; background];
end

x_vals = linspace(0, length(running_trace) * 0.96, length(running_trace));

figure(2)
plot(x_vals, running_trace, 'LineWidth', 1.5)
title('200mV dsDNA W Events')
xlabel('Time (us)')
ylabel('Current Depth (nA)')
set(gcf, 'position', [500, 300, 560, 420])
%xlim([450, 700])
ylim([-6, 2])