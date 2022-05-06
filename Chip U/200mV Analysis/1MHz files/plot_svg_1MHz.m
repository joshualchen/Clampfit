% INDICATE BELOW WHICH SPREADSHEETS TO USE
% trace_file = uigetfile('*.csv');
% trace is the full current trace (one column)
trace = readmatrix(trace_file);
shift = 525;

%start_ind = 280642;
%end_ind = 280898;
%old_trace_length = 2619802;

new_start_ind = start_ind + shift;
new_end_ind = end_ind + shift;

% new_start_ind = round(length(trace)/old_trace_length * start_ind);
% new_end_ind = round(length(trace)/old_trace_length * end_ind);


event = trace(new_start_ind:new_end_ind) - trace(new_start_ind);


x_vals = linspace(0, (end_ind - start_ind) * 0.96, length(event));

figure(1)
plot(x_vals, event, 'LineWidth', 1.5)
title('200mV dsDNA W Events @ 1MHz')
xlabel('Time (us)')
ylabel('Current Depth (nA)')
ylims = ylim;
top = ylims(2);
bottom = top - 8;
ylim([bottom, top])
%xlim([1050, 1200])
