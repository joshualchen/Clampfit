% debug version in convolution step, this is for real plotting
function displayGraph(input_x, input_y, point_locations, plot_figure)
    ax = findobj(plot_figure, 'type', 'axes');
    
    % insert surrounding values
    plot(ax, input_x, input_y, 'DisplayName', "current")
    hold on;
    for x = 1:length(point_locations)
        xline(point_locations(x),'--r')
    end
    title("Plot");
    xlabel("Time(us)");
    ylabel("Event Depth (A)");
    legend%('Location', 'eastoutside')
end