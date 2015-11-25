function [xcoord, ycoord] = norm2coord(axishandle, x, y)
checkinputs(axishandle, x, y);

% The Position property of MATLAB's axes object is its position relative to
% the parent object. MATLAB's annotation objects can only be positioned 
% relative to a figure, uipanel, or uitab object so we have to use the size
% and position of the axes object to transform our absolute position in 
% the figure to XY coordinates of the axes object.

% Get axes position
olderthanR2014b = verLessThan('MATLAB', '8.4');  % Version flag to be used for calling correct syntax
if ~olderthanR2014b  % Choose correct syntax for accessing handle graphics
    oldunits = axishandle.Units;         % Get old units to revert to later
    axishandle.Units = 'Normalized';     % Set normalized units if not already
    axisposition = axishandle.Position;  % Get position in figure window
    axishandle.Units = oldunits;         % Revert unit change
else
    oldunits = get(axishandle, 'Units');
    set(axishandle, 'Units', 'Normalized');
    axisposition = get(axishandle, 'Position');
    set(axishandle, 'Units', oldunits);
end

axislimits = axis(axishandle);
axisdatawidth  = axislimits(2) - axislimits(1);
axisdataheight = axislimits(4) - axislimits(3);

% Normalize x values
xcoord = (x - axisposition(1))*(axisdatawidth/axisposition(3)) + axislimits(1);
% Normalize y values
ycoord = (y - axisposition(2))*(axisdataheight/axisposition(4)) + axislimits(3);

end

function checkinputs(axishandle, x, y)
olderthanR2014b = verLessThan('MATLAB', '8.4');  % Version flag to be used for calling correct syntax

% Make sure the object passed is an axes object
% Return true if it's a valid axes, false otherwise
if ~olderthanR2014b
    isaxes = ~isa(axishandle, 'matlab.graphics.axis.Axes');
    objtype = class(axishandle);
else
    try
        objtype = get(axishandle, 'Type');
        if strcmp(objtype, 'axes')
            isaxes = true;
        else
            isaxes = false;
        end
    catch
        objtype = 'N/A';
        isaxes = false;
    end
end
if ~isaxes
    err.message = sprintf('First input to function must be a MATLAB Axes object, not %s', objtype);
    err.identifier = 'coord2norm:InvalidObject';
    err.stack = dbstack('-completenames');
    error(err)
end

% Make sure there is something plotted on the axes, otherwise we can get
% negative normalized values, which do not make sense
% Return true if children are present, false otherwise
if ~olderthanR2014b % Choose correct syntax for accessing handle graphics
    childrenpresent = ~isempty(axishandle.Children);
else
    childrenpresent = ~isempty(get(axishandle, 'Children'));
end
if ~childrenpresent
    err.message = 'Data has not been plotted on input Axes object';
    err.identifier = 'norm2coord:NoDataPlotted';
    err.stack = dbstack('-completenames');
    error(err)
end

% Make sure XY arrays are not empty
if isempty(x) || isempty(y)
    err.message = 'XY arrays must not be empty';
    err.identifier = 'norm2coord:EmptyXYarray';
    err.stack = dbstack('-completenames');
    error(err)
end

% Make sure input XY data is normalized (between 0 and 1)
if max(x) > 1 || min(x) < 0 || max(y) > 1 || min(y) < 0
    if max(x) > 1 || min(x) < 0
        err.message = sprintf('Normalized X values must be between 0 and 1.\nX Range: [%.2f, %.2f]', min(x), max(x));
    elseif max(y) > 1 || max(y) < 0
        err.message = sprintf('Normalized Y values must be between 0 and 1.\nY Range: [%.2f, %.2f]', min(y), max(y));
    end
    err.identifier = 'norm2coord:DataNotNormalized';
    err.stack = dbstack('-completenames');
    error(err)
end

end
