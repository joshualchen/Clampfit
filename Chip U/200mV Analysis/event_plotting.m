close all
clear all

TwoMHz1 = csvread('Scaffold_ChipC_1MKCl_1uM_dP_-300mV_20210713_150235_EXPORT_current.csv',1,0);
TimeMark = csvread('All points_Heteropore_-400mV_90bps_dZ_stat.csv', 1,0);
%% Merge Files 
TwoMHz = [TwoMHz1];

for i = 1:length(TimeMark)
    IMark{1,i} = [TwoMHz(TimeMark(i,5):TimeMark(i,6),1)];
end
EventMark = [];
for k = 1:length(TimeMark)
    EventMark = [EventMark; IMark{1,k}];
end

for i = 1:length(TimeMark)
    IMark{2,i} = [TwoMHz(TimeMark(i,3):TimeMark(i,4),1)];
end
DataMark = [];
for k = 1:length(TimeMark)
    DataMark = [DataMark; IMark{2,k}];
end

for i = 1:25
    figure(i)
    plot(TwoMHz(TimeMark(i,3):TimeMark(i,4),1))
    hold on
end

figure(length(TimeMark)+2)
bin_edges = 0:0.1:10;
histogram(DataMark(:,1),bin_edges);
fig_c = histc(DataMark(:,1),bin_edges);
hold on

figure(length(TimeMark)+1)
histogram(EventMark(:,1),bin_edges);
fig_c = histc(EventMark(:,1),bin_edges);
hold on

% set(gca,'yscale','log');
xlabel('Current (nA)');
ylabel('Counts');
title('All points');



% dlmwrite('All Data points_Heteropore_-400mV_90bps_dZ.csv', DataMark(:,1),'-append','coffset',0);