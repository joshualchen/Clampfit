% characterize_events.m
% create a GUI that allows you to loop through the events indicated by
% clampfit, and using the SHIFT + T, W, V, U buttons, etc. can "label"
% these different events that can be put back into the events spreadsheet.

% IMPORTANT: to make the code not complicated, you must finish marking the
% locations of the events all in one go, can't save and then come back.

% BUTTON LEGEND:
% LEFT & RIGHT buttons: move between events
% UP & DOWN buttons: jump between events
% ANY capital letter: categorizes the event into that letter. Saves to
% excel.
% BACKSPACE: resets category to "Uncategorized". Saves to excel.
% 0 (zero): see multiple plots at the same time. Will order the ones of the
% same category first, and then add in the others. Maximum of 27 plots (if
% there are more, then will be cut off.
% a & d keys: move the red line left and right by one time step
% s & w keys: move the red line left and right by 5 time steps (as denoted
% by the parameter t_length
% SPACE: place a red line down as a first point. Also saves to excel.
% - (minus): remove the last red line. Saves to excel.
% ENTER: Save the events to excel sheet.

% INDICATE BELOW WHICH SPREADSHEETS TO USE
trace_file = uigetfile('*.csv');
structure_file = extractBefore(trace_file, '_current.csv') + "_events_complete.csv"; % MAY NEED TO CHANGE THE ENDING HERE TO GET RIGHT EVENTS SPREADSHEET
% trace is the full current trace (one column)
trace = readmatrix(trace_file);
plot(trace)
% structure is the event indices spreadsheet from Clampfit
structure = readcell(structure_file);


% if excel is 3 cols, add in 4th, 5th, and 6th
if width(structure) == 3 % If it hasn't been processed before
    structure(:, 4) = {'Uncategorized'};
    structure(:, 5) = {[]}; % add a fifth column for time values
    structure(:, 6) = {[]}; % add a sixth column for current values
% if excel is 4 cols, add in the 5th and 6th columns
elseif width(structure) == 4 % if only the category has been selected
    structure(:, 5) = {[]}; % add a fifth column for time values
    structure(:, 6) = {[]}; % add a sixth column for current values
% if excel is more than 4 (if it has red lines), consolidate into structure
elseif width(structure) > 4 % if there are values, we need to consolidate
    structure_width = width(structure);
    loc_length = (structure_width - 4)/2;
    t_locs = 5:4+loc_length;
    val_locs = 5+loc_length:4+2*loc_length;
    structure_copy = structure;
    structure(:, 5:structure_width) = [];  %remove all of the values of structure
    % loop through, count the number of value locs
    for i = 1:height(structure_copy)
        t_and_missing = structure_copy(i, t_locs);
        val_and_missing = structure_copy(i, val_locs);
        t_vals = cell2mat(t_and_missing(~cellfun(@ismissing,t_and_missing)));
        current_vals = cell2mat(val_and_missing(~cellfun(@ismissing,val_and_missing)));
        structure(i, 5) = {t_vals};
        structure(i, 6) = {current_vals};
    end
end
    
% define the event data limits and other data
event_data_lims = [1, height(structure)];
x = 1;
global increase;
increase = 0;
step_length = round(range(event_data_lims)/10); % for jumping event values
% make the last mark the current placement, unless empty
if not(isempty(structure{x, 5}))
    t = structure{x, 5}(end);
else
    t = 1000*(structure{x, 2} + 0.1); % the position of time after trigger
end 
t_length = 5; % the multiplier for how many spots to jump

figure('Name', structure_file, 'NumberTitle', 'off');

% initialize plot
redraw(x, structure, trace, t);

while true
    
    try
        waitforbuttonpress;
    catch
        return
    end
    value = double(get(gcf, 'CurrentCharacter'));
    if isempty(value)
        % if another button is pressed that doesn't have logical scalar
        % value, then just skip the rest
    elseif value == 30
        %if up button is pressed
        if withinBounds(x+step_length, event_data_lims(1), event_data_lims(end))
            x = x + step_length;
        end
        % make the last mark the current placement, unless empty
        if not(isempty(structure{x, 5}))
            t = structure{x, 5}(end);
        else
            t = 1000*(structure{x, 2} + 0.1);
        end
        redraw(x, structure, trace, t);
    elseif value == 31
        %if down button is pressed
        if withinBounds(x-step_length, event_data_lims(1), event_data_lims(end))
            x = x - step_length;
        end
        % make the last mark the current placement, unless empty
        if not(isempty(structure{x, 5}))
            t = structure{x, 5}(end);
        else
            t = 1000*(structure{x, 2} + 0.1);
        end
        redraw(x, structure, trace, t);
    elseif value == 29
        %if right button is pressed
        if withinBounds(x+1, event_data_lims(1), event_data_lims(end))
            x = x + 1;
        end
        % make the last mark the current placement, unless empty
        if not(isempty(structure{x, 5}))
            t = structure{x, 5}(end);
        else
            t = 1000*(structure{x, 2} + 0.1);
        end
        redraw(x, structure, trace, t);
    elseif value == 28
        %if left button is pressed
        if withinBounds(x-1, event_data_lims(1), event_data_lims(end))
            x = x - 1;
        end
        % make the last mark the current placement, unless empty
        if not(isempty(structure{x, 5}))
            t = structure{x, 5}(end);
        else
            t = 1000*(structure{x, 2} + 0.1);
        end
        redraw(x, structure, trace, t);
    elseif value >= 65 && value <= 90
        %if any capital letter is pressed
        category = char(value);
        structure{x, 4} = category;
        redraw(x, structure, trace, t);
        writecell(structure, structure_file);
        disp('Saved to excel file.');
    elseif value == 13
        %if enter is pressed, write the stored structure into the excel sheet
        writecell(structure, structure_file);
        disp('Saved to excel file.');
    elseif value == 8
        % if backspace is pressed, reset the category to "Uncategorized"
        structure{x, 4} = 'Uncategorized';
        redraw(x, structure, trace, t);
        writecell(structure, structure_file);
        disp('Saved to excel file.');
    elseif value == 97
        % if a is pressed, red line moves left
        if withinBounds(t - 0.96, 1000*structure{x, 2}, 1000*structure{x, 3} + increase * 0.96)
            t = t - 0.96;
        end
        redraw(x, structure, trace, t);
    elseif value == 100
        % if d is pressed, red line moves right
        if withinBounds(t + 0.96, 1000*structure{x, 2}, 1000*structure{x, 3} + increase * 0.96)
            t = t + 0.96;
        end
        redraw(x, structure, trace, t);
    elseif value == 119
        % if w is pressed, red line moves right by t_length steps
        if withinBounds(t + t_length * 0.96, 1000*structure{x, 2}, 1000*structure{x, 3} + increase * 0.96)
            t = t + t_length * 0.96;
        end
        redraw(x, structure, trace, t);
    elseif value == 115
        % if s is pressed, red line moves left by t_length steps
        if withinBounds(t - t_length * 0.96, 1000*structure{x, 2}, 1000*structure{x, 3} + increase * 0.96)
            t = t - t_length * 0.96;
        end
        redraw(x, structure, trace, t);
    elseif value == 101
        % if e is pressed, red line moves right by t_length * 10 steps
        if withinBounds(t + t_length * 0.96 * 10, 1000*structure{x, 2}, 1000*structure{x, 3} + increase * 0.96)
            t = t + t_length * 0.96 * 10;
        end
        redraw(x, structure, trace, t);
    elseif value == 113
        % if q is pressed, red line moves left by t_length * 10 steps
        if withinBounds(t - t_length * 0.96 * 10, 1000*structure{x, 2}, 1000*structure{x, 3} + increase * 0.96)
            t = t - t_length * 0.96 * 10;
        end
        redraw(x, structure, trace, t);
    elseif value == 32
        % if space is pressed, red line is marked, as well as the value
        structure{x, 5}(end+1) = t;
        structure{x, 6}(end+1) = trace(round(t / 0.96)); % get the current value
        redraw(x, structure, trace, t);
        writecell(structure, structure_file);
        disp('Saved to excel file.');
    elseif value == 45
        %if - button is pressed, get rid of last red line
        if not(isempty(structure{x, 5}))
            structure{x, 5}(end) = [];
            structure{x, 6}(end) = [];
        end
        redraw(x, structure, trace, t);
        writecell(structure, structure_file);
        disp('Saved to excel file.');
    elseif value == 48
        %if zero is pressed, plot all of the events in windows
        if get(gcf, 'Number') > 1
            disp('Closing all events...')
            close all
            redraw(x, structure, trace, t);
            disp('All events closed.')
        else
            disp('Plotting events...')
            if height(structure) <= 27
                indices = 1:height(structure);
            else
                % get current category
                category = structure(x, 4);
                indices = find(strcmp(structure(:, 4), category));
                num_found = length(indices);
                if num_found <= 27
                    others = find(not(strcmp(structure(:, 4), category)));
                    indices = [indices; others];
                end
            end
            
            % making sure that we don't have more than 27 values
            if length(indices) >= 27
                indices = indices(1:26);
            end
            for i = 1:length(indices)
                figure(indices(i))
                redraw(indices(i), structure, trace, []) % IT"S BECAUSE THE t HERE IS THE SAME t FOR EVERYTHING
            end
            autoArrangeFigures()
            disp('All events plotted.')
        end
    end
end

% Redraw takes in the event number (which row), the event spreadsheet
% structure, and the entire trace. RETURNS new spreadsheet.
function redraw(num, structure, trace, t)
    % need to extract: background, event, letter, category
    global increase;
    letter = structure{num, 1};
    
    start_ind = round(structure{num, 2} * 1000 / 0.96);
    end_ind = round(structure{num, 3} * 1000 / 0.96);
    
    background = trace(start_ind:end_ind+increase);  % ADDED increase HERE
    trigger_time = 0.1;
    trigger = round(trigger_time * 1000 / 0.96); % units in points
    category = structure{num, 4};
    x_vals = 1000 * linspace(structure{num, 2}, structure{num, 3} + increase * 0.96 / 1000, length(background)); % units in ms
    
    % get the point at t to plot (and check)
    t_ind = round(t / 0.96);
    current_val = trace(t_ind);
    
    % Plot the event, background, and have a place to show letter and
    % category (title?)
    hold off;
    plot(x_vals, background, 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 1.5);
    hold on;
    plot(x_vals(1+trigger:end-trigger-increase), background(1+trigger:end-trigger-increase), 'Color', 'k', 'LineWidth', 1.5);  % ADDED 30 HERE
    
    % plot red line as well as existing lines
    for ind = 1:length(structure{num, 5})
        xline(structure{num, 5}(ind), 'r');
        plot(structure{num, 5}(ind), structure{num , 6}(ind),'r.')
    end
    if not(isempty(t))
        xline(t, '--r');
        plot(t, current_val, 'r*')
    end
    
    title("Event #" + num + ", Letter: " + letter + ", Category: " + category);
    xlabel("Time (μs)")
    ylabel("Current Depth (nA)");
    %xlim([x_vals(1), x_vals(end)]); % MIGHT NEED TO CHANGE THIS SO IT"S CONSISTENT
    %ylim([2.5 5]); % might need to check this
    %daspect([100 1 1])
end


function bool = withinBounds(val, min, max)
    if val < min || val > max
        bool = 0;
    else
        bool = 1;
    end
end