function [image, collage] = get_pbp_images(data, options)
% Retrieve multiple cloud particle images in the PBP structure 'data' and 
% show them in a graphics window. Size, time, and temperature criteria can 
% be defined to filter particles.
%
% Input arguments:
%   data: An already-loaded PBP dataset from load_pbp_file.m
%   'starttime': Start time (seconds from midnight)
%   'stoptime': Stop time (seconds from midnight)
%   'second': Only show particles from this second (seconds from midnight)
%   'minsize': Minimum particle size (microns)
%   'maxsize': Maximum particle size (microns)
%   'mint': Minimum temperature (degrees C)
%   'maxt': Maximum temperature (degrees C)
%   'particleindex': Predetermined array of particle indexes to save/show
%   'collagewidth': Width of display/output collage (pixels)
%   'noplot':  Disable display after particles are retrieved
%
% Output variables:
%   image: a cell array of particle images that meet all criteria
%   collage: a 2-dimensional array containing the particle images
%
% Example 1: Display all HVPS particles with a timestamp of 66000 and 66001
% seconds, and put them into separate arrays.
%
%   hvps = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc');
%   images1 = get_pbp_images(hvps, 'second', 66000);
%   images2 = get_pbp_images(hvps, 'second', 66001);
%
% Example 2: Display all CPI particles between -15 and -16 degrees C, and
% above 500 microns in size.  Then show the first image separately.
%
%   cpi = load_pbp_file('IMPACTS_CPI-P3_20200224_allimages_v01.nc');
%   images = get_pbp_images(cpi, 'maxt', -15, 'mint', -16, 'minsize', 500);
%   imshow(images{1})


arguments
    data
    options.particleindex = []  % For already-determined particle indexes
    options.starttime = []  % Start/stop time in seconds from midnight
    options.stoptime = []
    options.second = []     % Specify a single second to display
    options.minsize = []    % Min/max particle size in microns
    options.maxsize = []
    options.mint = []       % Min/max temperature in degrees Celsius
    options.maxt = []
    options.collagewidth {mustBeNumeric} = 1200
    options.noplot {mustBeNumeric} = 0
end

% Get particle indexes based on optional criteria
plottitle = [char(data.flightdate) ' ' char(data.probetype)]; % Initialize plot title
particleindex = options.particleindex;

if isscalar(options.second)
    particleindex = find(floor(data.time) == options.second);
    plottitle = [plottitle ' Time: ' num2str(options.second)];
end

if isscalar(options.starttime)
    if isempty(particleindex); particleindex = 1:1:length(data.time); end
    f = find(data.time(particleindex) >= options.starttime);
    particleindex = particleindex(f);
    plottitle = [plottitle ' Start: ' num2str(options.starttime)];
end

if isscalar(options.stoptime)
    if isempty(particleindex); particleindex = 1:1:length(data.time); end
    f = find(data.time(particleindex) <= options.stoptime);
    particleindex = particleindex(f);
    plottitle = [plottitle ' Stop: ' num2str(options.stoptime)];
end

if isscalar(options.minsize)
    if isempty(particleindex); particleindex = 1:1:length(data.time); end
    f = find(data.diam(particleindex) >= options.minsize);
    particleindex = particleindex(f);
    plottitle = [plottitle ' MinSize: ' num2str(options.minsize)];
end

if isscalar(options.maxsize)
    if isempty(particleindex); particleindex = 1:1:length(data.time); end
    f = find(data.diam(particleindex) <= options.maxsize);
    particleindex = particleindex(f);
    plottitle = [plottitle ' MaxSize: ' num2str(options.maxsize)];
end

if isscalar(options.mint)
    if isempty(particleindex); particleindex = 1:1:length(data.time); end
    f = find(data.t(particleindex) >= options.mint);
    particleindex = particleindex(f);
    plottitle = [plottitle ' MinT: ' num2str(options.mint)];
end

if isscalar(options.maxt)
    if isempty(particleindex); particleindex = 1:1:length(data.time); end
    f = find(data.t(particleindex) <= options.maxt);
    particleindex = particleindex(f);
    plottitle = [plottitle ' MaxT: ' num2str(options.maxt)];
end

% User info
disp(plottitle);
disp(['Number of images: ' num2str(length(particleindex))]);

% Determine if have OAP or other probe by checking the stopx values (always the same for OAP)
if min(data.stopx) == max(data.stopx)
    haveoap = 1;
else
    haveoap = 0;
end

nimages = length(particleindex);

% Get each image individually and put into cell array
image = cell(nimages, 1);
for i = 1:nimages
    image{i} = get_single_pbp_image(data, particleindex(i));
end

% Make a 2-D image collage for display
% Get the total linear x distance to guess a reasonable xmax to achieve 
% a square-ish image
xtot = 0;
for i = 1:nimages
    [xroi, ~] = size(image{i});
    xtot = xtot+xroi;
end

%Initialize the collage image
collage = [];
xc = 2;      %Start at 2 to have a border
yc = 2;
xmax = sqrt(nimages) * xtot/nimages * 2; %sqrt(xtot)*4;
ymax = 1;   %This will increment when xc > xmax

% If options.collagewidth is given, then use for a fixed x-width (after
% transposition)
if options.collagewidth > 0
    initlength = 5000;   %Initialize to this size, but can grow beyond
    xmax = options.collagewidth;
    %Initialize width so it is exact
    collage = zeros(options.collagewidth, initlength);
end

% Fill collage with images
for i = 1:nimages
    roi = image{i}';   % Transpose so OAP images line up
    
    % Change color for better view if OAP
    if haveoap
        roi = (roi * 200) + 55;
    else
        roi = 255-roi;
    end

    % Get size
    [xroi, yroi] = size(roi);
    % Check if will exceed column width
    if xc+xroi > xmax
        xc = 2;                % Reset x-position to top (with 1 pixel pad)
        yc = yc + ymax + 1;    % Advance y-position to next column
        ymax = 1;              % Reset largest y-size
    end

    % Add the image to the collage
    collage(xc:xc+xroi-1, yc:yc+yroi-1) = roi;
    xc = xc + xroi + 1;        % Increment position for next roi
    ymax = max(ymax, yroi);    % Keep track of largest y-size for next column   
end

% Crop to size if needed
if (options.collagewidth > 0) && ((yc+ymax+1) < initlength)
    collage = collage(:, 1:(yc+ymax+1));
end

%Transpose and make colors work
collage = transpose(255-collage)/255;

%Make figure
if options.noplot == 0
    imageViewer(collage, "InitialMagnification", 100);
end

end

        

