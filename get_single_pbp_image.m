function image = get_single_pbp_image(data, i)
% Read a single image from a netCDF PBP file of index 'i'
%
% Input arguments:
%   data: An already-loaded PBP dataset from load_pbp_file.m
%   i: Index of particle to read
%
% Output variables:
%   image: particle image
%
% Example:
%   hvps = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc');
%   image1 = get_single_pbp_image(hvps, 10000)
%   image2 = get_single_pbp_image(hvps, 20000)

if isfield(data, 'image')
    % Extract from memory if already loaded (fast)
    image = data.image(data.startx(i)+1:data.stopx(i)+1, ...
        data.starty(i)+1:data.stopy(i)+1);
else
    % Read from netCDF file if not in memory (slow)
    start = [data.startx(i) data.starty(i)] + 1;  %+1 for Matlab-style indexing
    count = [data.stopx(i)-data.startx(i)+1 data.stopy(i)-data.starty(i)+1];
    image = ncread(data.filename, 'image', start, count);
end

end
    