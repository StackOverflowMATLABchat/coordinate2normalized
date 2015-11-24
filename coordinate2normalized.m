function [xnorm, ynorm] = coordinate2normalized(axishandle, x, y)
set(axishandle, 'Units', 'Normalized');
axisposition = get(axishandle, 'Position'); % Get position in figure window
axislimits = axis(axishandle);

axisdatawidth  = axislimits(2) - axislimits(1);
axisdataheight = axislimits(4) - axislimits(3);

% Get x position
xnorm = (x - axislimits(1))*(axisposition(3)/axisdatawidth) + axisposition(1);
ynorm = (y - axislimits(3))*(axisposition(4)/axisdataheight) + axisposition(2);
end
