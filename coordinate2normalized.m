function [xnorm, ynorm] = coordinate2normalized(axishandle, x, y)
checkinputs(axishandle, x, y);
olderthanR2014b = verLessThan('MATLAB', '8.4'); % Global version flag to be used for calling correct syntax

set(axishandle, 'Units', 'Normalized');
axisposition = get(axishandle, 'Position'); % Get position in figure window
axislimits = axis(axishandle);

axisdatawidth  = axislimits(2) - axislimits(1);
axisdataheight = axislimits(4) - axislimits(3);

% Normalize x values
xnorm = (x - axislimits(1))*(axisposition(3)/axisdatawidth) + axisposition(1);
% Normalize y values
ynorm = (y - axislimits(3))*(axisposition(4)/axisdataheight) + axisposition(2);
end

function checkinputs(axishandle, x, y)
olderthanR2014b = verLessThan('MATLAB', '8.4'); % Global version flag to be used for calling correct syntax

% Make sure the object passed is an Axes object
if ~isa(axishandle, 'matlab.graphics.axis.Axes')
    err.message = sprintf('First input to function must be a MATLAB Axes object, not %s', class(axishandle));
    err.identifier = 'coordinate2normalized:InvalidObject';
    err.stack = dbstack('-completenames');
    error(err)
end

% Make sure there is something plotted on the Axes, otherwise we can get
% negative normalized values, which do not make sense
% Return true if children are present, false otherwise
if ~olderthanR2014b % Choose correct syntax
    childrenpresent = ~isempty(axishandle.Children);
else
    childrenpresent = ~isempty(get(axishandle, 'Children'));
end
if ~childrenpresent
    err.message = 'Data has not been plotted on input Axes object';
    err.identifier = 'coordinate2normalized:NoDataPlotted';
    err.stack = dbstack('-completenames');
    error(err)
end

% Make sure XY arrays are not empty
if isempty(x) || isempty(y)
    err.message = 'XY arrays must not be empty';
    err.identifier = 'coordinate2normalized:EmptyXYarray';
    err.stack = dbstack('-completenames');
    error(err)
end
end
