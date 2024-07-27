function data = load_pbp_file(ncfile, loadimage)
% Load the vector variables of a particle-by-particle file 
% into memory.  Optionally load the image array into memory for increased 
% performance.
%
% Input arguments:
%    ncfile: The netCDF filename containing OAP or CPI images
%    loadimage: Boolean flag to load images to memory (default=1)
%
% Output structure:
%    vector data as indicated in code below.  Many more variables are
%    available for various instruments.
%
% Example: Display all particles with a timestamp of 66000 seconds, and
% put them into the array 'images'.
%    hvps = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc');
%    images = get_pbp_images(hvps, 'second', 66000);

arguments
    ncfile string
    loadimage single = 1
end

%% Get basic data in netCDF file
% More variables are available.  See documentation or variable listing in the files.
data.flightdate = ncreadatt(ncfile, '/', 'FlightDate');
data.project = ncreadatt(ncfile, '/', 'PROJECT');
data.probetype = ncreadatt(ncfile, '/', 'PROBETYPE');
data.filename = ncfile;
data.time = ncread(ncfile,'time');
data.diam = ncread(ncfile,'diam');
data.arearatio = ncread(ncfile,'arearatio');
data.aspectratio = ncread(ncfile,'aspectratio');
data.startx = ncread(ncfile,'startx');
data.stopx = ncread(ncfile,'stopx');
data.starty = ncread(ncfile,'starty');
data.stopy = ncread(ncfile,'stopy');
data.t = ncread(ncfile,'t');
data.lat = ncread(ncfile, 'lat');
data.lon = ncread(ncfile, 'lon');
data.alt = ncread(ncfile, 'alt');

% Load image if flagged, may be very large
if loadimage
    data.image = ncread(ncfile, 'image');
end

end
