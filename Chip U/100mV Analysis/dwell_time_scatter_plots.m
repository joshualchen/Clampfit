% Code to characterize the dwell times of the T and W events.
% All I need to do is loop through all of the events_complete sheets and
% pull out the dwell times and event depths for each type of event.
% Have a separate structure for T's and W's 

files = dir;
T_data = cell(0, 11);
W_data = cell(0, 11);

for x = 1:length(files)
    name = files(x).name;
    if endsWith(name, "events_complete.CSV") || endsWith(name, "events_complete.csv")
        trace_name = extractBefore(name, "events_complete") + "current.csv";
        trace = readmatrix(trace_name);
        structure = readcell(name);
        for i = 1:height(structure)
            if not(ismissing(structure{i, 5})) && not(ismissing(structure{i, 11})) && not(ismissing(structure{i, 12})) && not(ismissing(structure{i, 13})) && not(ismissing(structure{i, 14})) && not(ismissing(structure{i, 15}))
                base = structure{i, 11};
                pos1 = [structure{i, 5}, structure{i, 11} - base];
                pos2 = [structure{i, 6}, structure{i, 12} - base];
                pos3 = [structure{i, 7}, structure{i, 13} - base];
                pos4 = [structure{i, 8}, structure{i, 14} - base];
                pos5 = [structure{i, 9}, structure{i, 15} - base];
%                 if not(ismissing(structure{i, 10}))
%                     pos6 = [structure{i, 10}, structure{i, 16} - base];
%                 end
                pos6 = [];%[structure{i, 10}, structure{i, 16} - base];
                disp(i)
                start_event = round(structure{i, 5} / 0.96); % index of start
                end_event = round(structure{i, 9} / 0.96);  % index of end
                pos8 = trace(start_event:end_event);
                pos7 = linspace(structure{i, 5}/1000^2, structure{i, 9}/1000^2, length(pos8));
                pos9 = (pos3(1) - pos1(1))/1000;  % 3-1 dwell time
                pos10 = (pos4(1) - pos1(1))/1000;  % 4-1 dwell time
                pos11 = (pos5(1) - pos3(1))/1000;  % 5-3 dwell time
                if structure{i, 4} == 'T'
                    T_data(end+1, :) = {pos1, pos2, pos3, pos4, pos5, pos6, pos7, pos8, pos9, pos10, pos11};
                elseif structure{i, 4} == 'W'
                    W_data(end+1, :) = {pos1, pos2, pos3, pos4, pos5, pos6, pos7, pos8, pos9, pos10, pos11};
                end
            end
        end

    end
end

% Plot dwell time vs. depth for T events

figure(1)
T_dwell_times = cell2mat(T_data(:, 9));
T_depths = cell2mat(T_data(:, 10));
T_input_x = T_data(:, 7);
T_input_y = T_data(:, 8);
T_points = {};
for i = 1:height(T_data)
    vals = cell2mat(T_data(i, 1:6));
    x_locs = vals(1:2:12);
    T_points(end+1, :) = {x_locs/10^6};
end
clickableScatter(T_dwell_times, T_depths, T_input_x, T_input_y, T_points)
title("T Events -- Dwell Time vs. Maximum Current Depth")
ylabel("Current Depth (nA)")
xlabel("Dwell Time (ms)")

figure(1)
T_dwell_times = cell2mat(T_data(:, 9));
T_depths = cell2mat(T_data(:, 10));
scatter(T_dwell_times, T_depths);
title("T Events -- Dwell Time vs. Maximum Current Depth")
ylabel("Current Depth (nA)")
xlabel("Dwell Time (ms)")

% Plot dwell time vs. depth for W events

figure(1)
W_dwell_times = cell2mat(W_data(:, 9));
W_depths = cell2mat(W_data(:, 10));
scatter(W_dwell_times, W_depths);
%clickableScatter(W_dwell_times, W_depths, )
title("W Events -- Dwell Time vs. Point 4 Current Depth")
ylabel("Current Depth (nA)")
xlabel("Dwell Time (ms)")

figure(2) 
W_dwell_times = cell2mat(W_data(:, 11));
[counts,edges] = histcounts(log10(W_dwell_times), 10);
histogram(W_dwell_times, 10.^edges)
title("W Events Histogram -- 1-3 Dwell Time")
xlabel("Dwell Time (ms)")
set(gca,'xscale','log')
maxCounts = max(counts);
leftBin = find(counts > maxCounts/2, 1, 'first');
rightBin = find(counts > maxCounts/2, 1, 'last');
true_edges = 10.^edges;
fwhm = true_edges(rightBin) - true_edges(leftBin + 1);
disp(fwhm)

figure(3) 
T_dwell_times = cell2mat(T_data(:, 10));
[counts,edges] = histcounts(log10(T_dwell_times), 11);
histogram(T_dwell_times, 10.^edges)
title("T Events Histogram -- 1-4 Dwell Time")
xlabel("Dwell Time (ms)")
set(gca,'xscale','log')
maxCounts = max(counts);
leftBin = find(counts > maxCounts/2, 1, 'first');
rightBin = find(counts > maxCounts/2, 1, 'last');
true_edges = 10.^edges;
fwhm = true_edges(rightBin) - true_edges(leftBin + 1);
disp(fwhm)


figure(2) 
W_dwell_times = cell2mat(W_data(:, 11));
histogram(W_dwell_times)
title("W Events Histogram -- 1-3 Dwell Time")
xlabel("Dwell Time (ms)")

figure(2) 
T_dwell_times = cell2mat(T_data(:, 11));
histogram(T_dwell_times)
title("T Events Histogram -- 1-4 Dwell Time")
xlabel("Dwell Time (ms)")

