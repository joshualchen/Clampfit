% create histograms that take in the trace_file & structure_file and will
% return the histograms of each trace
clear; clc;

% PARAMETERS OF CHIP C FOR THEORETICAL DEPTHS
mV = 400;
N = 1;
tT = 0.6;
dT = 6.5;
tB = 20;
dB = 20;
DNA = "ds";
output = calculate_All_Depths(mV, N, tT, dT, tB, dB, DNA);
% [I_Total, I_Tblocked, I_Bblocked, I_TBblocked, I_T2blocked, I_B2blocked, I_T2Bblocked, I_TB2blocked, I_T2B2blocked]

% INDICATE BELOW WHICH SPREADSHEETS TO USE
trace_file = uigetfile('*.csv');
structure_file = extractBefore(trace_file, '_current.csv') + "_events_complete.csv";
% trace is the full current trace (one column)
trace = readmatrix(trace_file);
% structure is the event indices spreadsheet from Clampfit
structure = readcell(structure_file);

% First tally up the amount of each type of tracing
category_list = structure(:, 4);

figure(1)
[U,~,X] = unique(category_list);
cnt = histc(X,1:numel(U));
bar(cnt)
set(gca,'xticklabel',U)
xtickangle(-45)
title('Amount of each type of event')

% All points histogram for the entire trace
figure(2)
subplot(1, 1, 1)
histogram(trace)
for x = output
    xline(x);
end
title('All points histogram for full trace')

% All points histograms for EACH EVENT TYPE
for i = 3:length(cnt)+2
    type = U{i - 2};
    figure(i)  % Look at the histogram current depth data
    subplot(2, 1, 1)
    [running_events, running_background] = get_Hist(type, trace, structure);   % get all the data for that type
    histogram(running_background);
    title("Histogram of Event Datapoints for "+type);
    subplot(2, 1, 2)
    plot(running_background)
    title("Appended Events for "+type)
end

% figure(length(TimeMark)+2)
% bin_edges = 0:0.1:10;
% histogram(DataMark(:,1),bin_edges);
% fig_c = histc(DataMark(:,1),bin_edges);
% hold on
% 
% figure(length(TimeMark)+1)
% histogram(EventMark(:,1),bin_edges);
% fig_c = histc(EventMark(:,1),bin_edges);
% hold on

% Need to accumulate a different structure 

function [running_events, running_background] = get_Hist(type, trace, structure)
    trigger_time = 0.1;
    running_events = [];
    running_background = [];

    for num = 1:height(structure)
        if structure{num, 4} == type
            start_ind = round(structure{num, 2} * 1000 / 0.96);
            end_ind = round(structure{num, 3} * 1000 / 0.96);
            background = trace(start_ind:end_ind);
            trigger = round(trigger_time * 1000 / 0.96);
            event = background(1+trigger:end-trigger);
            running_events = [running_events; event];
            running_background = [running_background; background];
        end
    end
end