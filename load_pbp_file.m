function data = load_pbp_file(ncfile, start, count, options)
% Load the vector variables of a particle-by-particle file 
% into memory.  Optionally load the image array into memory for increased 
% performance.
%
% Input arguments:
%    ncfile: The netCDF filename containing OAP or CPI images
%    start: Particle start index to begin reading
%    count: Number of particles to read in
%    'starttime': Time to begin file read (overrides start/count)
%    'stoptime':  Time to stop file read (overrides count)
%    'loadimage': Boolean flag to load images to memory (default=1)
%
% Output structure:
%    vector data as indicated in code below.  Many more variables are
%    available for various instruments.
%
% Example 1: Display all particles with a timestamp of 66000 seconds, and
% put them into the array 'images'.
%    hvps = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc');
%    images = get_pbp_images(hvps, 'second', 66000);
%
% Example 2: As above, but only load 2000 seconds of data to save memory.
%    hvps = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc',...
%       'starttime', 65000, 'stoptime', 67000);
%    images = get_pbp_images(hvps, 'second', 66000);

arguments
    ncfile string
    start double = 1
    count double = Inf
    options.loadimage single = 1
    options.starttime = []
    options.stoptime = []
end

% File check
if ~exist(ncfile, 'file')
    disp('File not available');
    data = 0;
    return
end

% Get new start and count values if starttime/stoptime are specified
if ~isempty(options.starttime)
    time = ncread(ncfile, 'time');
    dummy = find(time >= options.starttime);
    start = dummy(1);
    stop = dummy(end);
    count = stop-start+1;
end
if ~isempty(options.stoptime)
    dummy = find(time <= options.stoptime);
    stop = dummy(end);
    count = stop-start+1;
end

% Get basic data in netCDF file
% More variables are available.  See documentation or variable listing in the files.
data.flightdate = ncreadatt(ncfile, '/', 'FlightDate');
data.project = ncreadatt(ncfile, '/', 'PROJECT');
data.probetype = ncreadatt(ncfile, '/', 'PROBETYPE');
data.filename = ncfile;

data.time = ncread(ncfile, 'time', start, count);
data.diam = ncread(ncfile, 'diam', start, count);
data.arearatio = ncread(ncfile, 'arearatio', start, count);
data.aspectratio = ncread(ncfile, 'aspectratio', start, count);
data.startx = ncread(ncfile, 'startx', start, count);
data.stopx = ncread(ncfile, 'stopx', start, count);
data.starty = ncread(ncfile, 'starty', start, count);
data.stopy = ncread(ncfile, 'stopy', start, count);
data.t = ncread(ncfile, 't', start, count);
data.lat = ncread(ncfile, 'lat', start, count);
data.lon = ncread(ncfile, 'lon', start, count);
data.alt = ncread(ncfile, 'alt', start, count);

% Load image if flagged
if options.loadimage
    info = ncinfo(ncfile);   % Need array width from dimension(2)
    imstart = [1 max(data.starty(1), 1)];
    imcount = [info.Dimensions(2).Length data.stopy(end)-data.starty(1)+1];
    data.image = ncread(ncfile, 'image', imstart,  imcount);
end

% Adjust y-index if a new start value has been applied
if start > 1
    offset = data.starty(1);
    data.starty = data.starty-offset+1;
    data.stopy = data.stopy-offset+1;
end
end