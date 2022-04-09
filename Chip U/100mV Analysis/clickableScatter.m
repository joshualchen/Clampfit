% CLICKABLESCATTER Like scatter(), but allows meta-data to be present for each point
% such that when you click a point something shows to the right of it. The general
% format is:
%
%  h = clickableScatter(x, y, metaData, ...)
%
% Any additional parameters that you can pass to scatter(), for example, a string 
% with line specifications like 'bx' or a 'Color' parameter, or a size 
% for each point, can be passed after the metaData parameter and will be passed
% directly to scatter().
%

function h = clickableScatter(x, y, input_x, input_y, point_locations, varargin)  
  % If figure is at the default size (e.g., was just opened), resize it to be twice
  % as wide to fit two subplots nicely
  pos = get(gcf, 'Position');
  defPos = get(0, 'DefaultFigurePosition');
  if pos(3)==defPos(3) && pos(4)==defPos(4)
    set(gcf, 'Position', [pos(1) pos(2) pos(3)*1.4 pos(4)*0.75]);
  end
  set(gcf, 'Color', [1 1 1]);
  
  % Draw initial scatter
  if isempty(varargin) %if empty, all the points are the same color 
      varargin = {'b'};
  end %if not empty, we establish a colorbar and call it
  h = subplot(1,2,1); hold off;
  s = scatter(x,y,25,varargin{:},'x');
  %set(gca, 'FontName', 'Courier New', 'FontSize', 10);
  hold on;
  
  %figure out difference in scaling between x & y axes
  x_range = range(x);
  y_range = range(y);
  factor = y_range/x_range;
  
  % Set up click handlers
  set(gca,'ButtonDownFcn', @Click_Callback);
  set(get(gca,'Children'),'ButtonDownFcn', @Click_Callback);
  curPlot = 0;

  % What to do when an item is clicked
  function Click_Callback(~,~)
    % Get the location that was clicked on
    cP = get(gca,'Currentpoint');
    cx = cP(1,1); 
    cy = cP(1,2);
    
    % Find nearest point
    diffValues = factor*(cx-x).^2 + (cy-y).^2;
    [~,minValue] = min(diffValues);
    
    % Plot a new point on top of it
    if curPlot ~= 0
      delete(curPlot);
    end
    curPlot = plot(x(minValue), y(minValue), 'rx', 'LineWidth', 1.5);%, 'MarkerSize', 10);
    
    % Now figure out what to show on the other subplot
    curH = subplot(1,2,2); 
    hold off;
    % basically, minValue gives us the index of the cat2_data we want
    % all we need is to put in an array of all of the inputs
    % need to get the actual index from mydata (col 7) somehow
    
    displayGraph(input_x{minValue}, input_y{minValue}, point_locations{minValue}, curH);
    disp(minValue)
    % above: minValue: the index for CAT2_DATA
    % above: input{minValue}: the correct input for that value
    % need to get the ACTUAL index, which is listed in row 7
  end
end

