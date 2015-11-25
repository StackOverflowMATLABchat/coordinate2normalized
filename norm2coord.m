function [xcoord, ycoord] = norm2coord(axishandle, x, y)
checkinputs(axishandle, x, y);

set(axishandle, 'Units', 'Normalized');
axisposition = get(axishandle, 'Position'); % Get position in figure window
axislimits = axis(axishandle);

axisdatawidth  = axislimits(2) - axislimits(1);
axisdataheight = axislimits(4) - axislimits(3);

% Normalize x values
xcoord = (x - axisposition(1))*(axisdatawidth/axisposition(3)) + axislimits(1);
% Normalize y values
ycoord = (y - axisposition(2))*(axisdataheight/axisposition(4)) + axislimits(3);
end

function checkinputs(axishandle, x, y)
% Make sure the object passed is an Axes object
if ~isa(axishandle, 'matlab.graphics.axis.Axes')
    err.message = sprintf('First input to function must be a MATLAB Axes object, not %s', class(axishandle));
    err.identifier = 'norm2coord:InvalidObject';
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
