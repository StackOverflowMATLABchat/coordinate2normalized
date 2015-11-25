function [xnorm, ynorm] = coord2norm(axishandle, x, y)
%COORD2NORM Normalize coordinates from data space to axes parent container
% COORD2NORM(axishandle, x, y) takes input XY coordinates, relative to the
% axes object axishandle, and normalizes them to the parent container of
% axishandle. This is useful for functions like annotation, where the input 
% XY coordinates are normalized to the parent container of the plotting
% axes object and not to the data being plotted. axishandle must be a valid
% MATLAB axes object (HG2) or handle (HG1).
%
% COORD2NORM returns discrete arrays xnorm and ynorm of the same size as
% the input XY coordinate arrays.
%
% Example:
%
%    myaxes = axes();
%    x = -10:10;
%    y = x.^2;
%    plot(x, y);
%
%    [normx, normy] = coord2norm(myaxes, [x(1) x(2)], [y(1) y(2)]);
%    annotation('arrow', normx, normy);
%
% See also ANNOTATION, PLOT, AXES, FIGURE

checkinputs(axishandle, x, y);

% The Position property of MATLAB's axes object is its position relative to
% the parent object. MATLAB's annotation objects can only be positioned 
% relative to a figure, uipanel, or uitab object so we have to use the size
% and position of the axes object to transform the axes XY coordinates to
% an absolute position relative to the parent container.

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

% Normalize X values
xnorm = (x - axislimits(1))*(axisposition(3)/axisdatawidth) + axisposition(1);
% Normalize Y values
ynorm = (y - axislimits(3))*(axisposition(4)/axisdataheight) + axisposition(2);

end

function checkinputs(axishandle, x, y)
olderthanR2014b = verLessThan('MATLAB', '8.4');  % Version flag to be used for calling correct syntax

% Make sure the object passed is an axes object
% Return true if it's a valid axes, false otherwise
if ~olderthanR2014b % Choose correct syntax for accessing handle graphics
    isaxes = isa(axishandle, 'matlab.graphics.axis.Axes');
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
    err.identifier = 'coord2norm:NoDataPlotted';
    err.stack = dbstack('-completenames');
    error(err)
end

% Make sure XY arrays are not empty
if isempty(x) || isempty(y)
    err.message = 'XY arrays must not be empty';
    err.identifier = 'coord2norm:EmptyXYarray';
    err.stack = dbstack('-completenames');
    error(err)
end
end
