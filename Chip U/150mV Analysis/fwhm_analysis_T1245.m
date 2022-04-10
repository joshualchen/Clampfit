n = 11;  % the number of bins
disp_mean = 1;
mean_val = "";
xlims = [0.005, 0.3];

files = dir;
T_data = cell(0, 12);
W_data = cell(0, 12);

% for x = 1:length(files)
%     name = files(x).name;
%     if endsWith(name, "events_complete.CSV") || endsWith(name, "events_complete.csv")
%         trace_name = extractBefore(name, "events_complete") + "current.csv";
%         trace = readmatrix(trace_name);
%         structure = readcell(name);
%         for i = 1:height(structure)
%             if not(ismissing(structure{i, 5})) && not(ismissing(structure{i, 11})) && not(ismissing(structure{i, 12})) && not(ismissing(structure{i, 13})) && not(ismissing(structure{i, 14})) && not(ismissing(structure{i, 15}))
%                 base = structure{i, 11};
%                 pos1 = [structure{i, 5}, structure{i, 11} - base];
%                 pos2 = [structure{i, 6}, structure{i, 12} - base];
%                 pos3 = [structure{i, 7}, structure{i, 13} - base];
%                 pos4 = [structure{i, 8}, structure{i, 14} - base];
%                 pos5 = [structure{i, 9}, structure{i, 15} - base];
%                 start_event = round(structure{i, 5} / 0.96); % index of start
%                 end_event = round(structure{i, 9} / 0.96);  % index of end
%                 pos6 = trace(start_event:end_event);
%                 pos7 = []; %linspace(structure{i, 5}/1000^2, structure{i, 9}/1000^2, length(pos8));
%                 pos8 = (pos3(1) - pos1(1))/1000;  % 3-1 dwell time
%                 pos9 = (pos4(1) - pos1(1))/1000;  % 4-1 dwell time
%                 pos10 = (pos5(1) - pos3(1))/1000;  % 5-3 dwell time
%                 pos11 = (pos2(1) - pos1(1))/1000;
%                 pos12 = (pos5(1) - pos4(1))/1000;
%                 if structure{i, 4} == 'T'
%                     T_data(end+1, :) = {pos1, pos2, pos3, pos4, pos5, pos6, pos7, pos8, pos9, pos10, pos11, pos12};
%                 elseif structure{i, 4} == 'W'
%                     W_data(end+1, :) = {pos1, pos2, pos3, pos4, pos5, pos6, pos7, pos8, pos9, pos10, pos11, pos12};
%                 end
%             end
%         end
%     end
% end
% 
% W_SiNx = cell2mat(W_data(:, 8));
% T_SiNx = cell2mat(T_data(:, 8));
% W_MoS2 = cell2mat(W_data(:, 10));
% T_MoS2 = cell2mat(T_data(:, 10));

figure(2)

subplot(2, 2, 1)  % W_SiNx
% get fwhm with histcounts
[counts,edges] = histcounts(log10(W_SiNx), n);
maxCounts = max(counts);
leftBin = find(counts > maxCounts/2, 1, 'first');
rightBin = find(counts > maxCounts/2, 1, 'last');
true_edges = 10.^edges;
fwhm = true_edges(rightBin+1) - true_edges(leftBin);
% Now plot with histfit
hh = histfit(log10(W_SiNx), n, 'Normal');
hh_bar_x = hh(1).XData;
hh_bar_y = hh(1).YData;
hh_line_x = hh(2).XData;
hh_line_y = hh(2).YData;
ybar = hh_bar_y;
bar(hh_bar_x, ybar/sum(ybar), 'BarWidth', 1)
hold on
plot(hh_line_x, hh_line_y/sum(ybar), 'r', 'LineWidth', 2)
if disp_mean == 1
    mean_val = mean(W_SiNx);
    xline(log10(mean_val), 'r', 'LineWidth', 2);
end
ax = gca;
labels_I_want = [0.01, 0.05, 0.1, 0.2, 0.3];
xticks(log10(labels_I_want));
xticklabels(labels_I_want);
xlim(log10(xlims))
ylim([0 0.3])
title("W Event SiNx Dwell Time, FWHM: " + fwhm + ", mean: " + mean_val)

subplot(2, 2, 2)  % T_SiNx
% get fwhm with histcounts
[counts,edges] = histcounts(log10(T_SiNx), n);
maxCounts = max(counts);
leftBin = find(counts > maxCounts/2, 1, 'first');
rightBin = find(counts > maxCounts/2, 1, 'last');
true_edges = 10.^edges;
fwhm = true_edges(rightBin+1) - true_edges(leftBin);
% Now plot with histfit
hh = histfit(log10(T_SiNx), n, 'Normal');
hh_bar_x = hh(1).XData;
hh_bar_y = hh(1).YData;
hh_line_x = hh(2).XData;
hh_line_y = hh(2).YData;
ybar = hh_bar_y;
bar(hh_bar_x, ybar/sum(ybar), 'BarWidth', 1)
hold on
plot(hh_line_x, hh_line_y/sum(ybar), 'r', 'LineWidth', 2)
if disp_mean == 1
    mean_val = mean(T_SiNx);
    xline(log10(mean_val), 'r', 'LineWidth', 2);
end
ax = gca;
labels_I_want = [0.01, 0.05, 0.1, 0.2, 0.3];
xticks(log10(labels_I_want));
xticklabels(labels_I_want);
xlim(log10(xlims))
ylim([0 0.3])
title("T Event SiNx Dwell Time, FWHM: " + fwhm + ", mean: " + mean_val)

subplot(2, 2, 3)  % W_MoS2
% get fwhm with histcounts
[counts,edges] = histcounts(log10(W_MoS2), n);
maxCounts = max(counts);
leftBin = find(counts > maxCounts/2, 1, 'first');
rightBin = find(counts > maxCounts/2, 1, 'last');
true_edges = 10.^edges;
fwhm = true_edges(rightBin+1) - true_edges(leftBin);
% Now plot with histfit
hh = histfit(log10(W_MoS2), n, 'Normal');
hh_bar_x = hh(1).XData;
hh_bar_y = hh(1).YData;
hh_line_x = hh(2).XData;
hh_line_y = hh(2).YData;
ybar = hh_bar_y;
bar(hh_bar_x, ybar/sum(ybar), 'BarWidth', 1)
hold on
plot(hh_line_x, hh_line_y/sum(ybar), 'r', 'LineWidth', 2)
if disp_mean == 1
    mean_val = mean(W_MoS2);
    xline(log10(mean_val), 'r', 'LineWidth', 2);
end
ax = gca;
labels_I_want = [0.01, 0.05, 0.1, 0.2, 0.3];
xticks(log10(labels_I_want));
xticklabels(labels_I_want);
xlim(log10(xlims))
ylim([0 0.3])
title("W Event MoS2 Dwell Time, FWHM: " + fwhm + ", mean: " + mean_val)

subplot(2, 2, 4)  % T_MoS2
% get fwhm with histcounts
[counts,edges] = histcounts(log10(T_MoS2), n);
maxCounts = max(counts);
leftBin = find(counts > maxCounts/2, 1, 'first');
rightBin = find(counts > maxCounts/2, 1, 'last');
true_edges = 10.^edges;
fwhm = true_edges(rightBin+1) - true_edges(leftBin);
% Now plot with histfit
hh = histfit(log10(T_MoS2), n, 'Normal');
hh_bar_x = hh(1).XData;
hh_bar_y = hh(1).YData;
hh_line_x = hh(2).XData;
hh_line_y = hh(2).YData;
ybar = hh_bar_y;
bar(hh_bar_x, ybar/sum(ybar), 'BarWidth', 1)
hold on
plot(hh_line_x, hh_line_y/sum(ybar), 'r', 'LineWidth', 2)
if disp_mean == 1
    mean_val = mean(T_MoS2);
    xline(log10(mean_val), 'r', 'LineWidth', 2);
end
ax = gca;
labels_I_want = [0.01, 0.05, 0.1, 0.2, 0.3];
xticks(log10(labels_I_want));
xticklabels(labels_I_want);
xlim(log10(xlims))
ylim([0 0.3])
title("T Event MoS2 Dwell Time, FWHM: " + fwhm + ", mean: " + mean_val)

