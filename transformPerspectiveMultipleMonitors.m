function [coord3new] = transformPerspectiveMultipleMonitors(coord3)
% Perspective transform for all or any of up to 4 monitors placed at
% the cardinal points of the compass around the animal.
% (These are easy as you just flip and/or invert the x and y coords before
% transforming).
% Based on the virmen built-in 'transformPerspectiveMex', adapted to accomodate the
% multiple monitors and the appropriate transform for each one.
% Tom Wills, 2016-08-01.

% The following are the critical parameters for perspective transform:
%---------------------------------------------------------------------
% Get aspect ratio of window
aspectRatio = 1920/1080;  

% viewing parameters
s = 1.8;  % Emperically, 1.8 seems to work for the CAVE set up with monitors of size 1920/1080pix, 20/30cm.
p = 1;

% Remap the outputs, if necessary (to deal monitors in awkward orders in (MS) Windows).
% Default is 1=ahead, 2=left, 3=behind, 4=right.
% remapOutputInd = [3 1 4 2];  % [3 4 1 2] is for the 1D VR setup - send the behind output to the main monitor.

% Set up variables.
% ------------------
% inputs
ncols = size(coord3,2);
% outputs
coord3new = zeros(3, ncols, 4);


% Create 4 different viewpoints for 4 monitors (at cardinal points of compass)
% ----------------------------------------------------------------------------
coord3 = repmat( coord3, [1 1 4] );   % First, replicate the input coords x4.
% dim1=1: look ahead, no transform necessary

% dim3=2: look left
coord3([1 2],:,2) =  coord3([2 1],:,2);
coord3(2,:,2)     = -coord3(2,:,2);

% dim3=3: look behind.
coord3(2,:,3) = -coord3(2,:,3);

% dim3=4: look right.
coord3([1 2],:,4) =  coord3([2 1],:,4);
coord3(1,:,4)     = -coord3(1,:,4);



% perspective transformation
% --------------------------
% (Assign transformed coords to temp variables, because we still have to clip invisible points, below ..)
xMonTemp = s .* coord3(1,:,:) ./ coord3(2,:,:);  % monitor x value.
yMonTemp = s .* coord3(3,:,:) ./ coord3(2,:,:);  % monitor y value



% clip vertices that are not visible ('behind' each viewpoint)
% ------------------------------------------------------------
visInd = coord3(2,:,:) > 0;            % visInd marks the vertices behind each viewpoint.
coord3new(3,:,:) = double( visInd );   % in 3rd row of output, 1=vertex visible, 0=vertex invisible.

% 'clip' invisible vertices (set them to be at the edge of the monitor).
[xSign,zSign] = deal( ones(1,ncols,4) .* -1 );
xSign( coord3(1,:,:)>0 ) = 1;
zSign( coord3(3,:,:)>0 ) = 1;
xClipped = p .* xSign .* aspectRatio;
yClipped = p .* zSign;

% Set the invisible points to the clipped values in the x and y monitor coords, and assign to output.
xMonTemp(~visInd) = xClipped(~visInd);
yMonTemp(~visInd) = yClipped(~visInd);
coord3new(1,:,:) = xMonTemp;
coord3new(2,:,:) = yMonTemp;

% Remap the output order
% coord3new = coord3new(:,:,remapOutputInd);


