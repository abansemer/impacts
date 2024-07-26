NASA IMPACTS full cloud particle imagery (2020, 2022, 2023)
===========================================================

Data Download (425 GB for entire dataset):
https://app.globus.org/file-manager?origin_id=62c21b98-b06d-46f4-8695-94d89800ab0f&origin_path=%2F


Description
===========================================================
All files are in netCDF format, with one file per probe per flight.  Probes include the Hawkeye CPI, Hawkeye 2D-S
(horizontal and vertical arrays), HVPS-3 (A=horizontal, B=vertical), and a standalone 2D-S (horizontal and vertical
arrays).

Images are stored as two-dimensional byte arrays.  Optical array probes (2D-S and HVPS3) have a fixed image width of
128 elements, and an unlimited image length.  High resolution imagery (Hawkeye CPI) has a variable image width and
height.

Use the 'startx', 'stopx', 'starty', and 'stopy' variable to extract individual images from the image array.  This can
be done by loading the entire image into memory (if possible), or by using the 'start' and 'count' arguments available
in netCDF read routines.

Individual particle metrics and environmental data are stored in one-dimensional arrays.  See the netCDF attributes for
detailed variable descriptions and units.


How to read
===========================================================
These files can be read with any netCDF utility.  Example routines in Matlab and IDL are provided in this repository
as a guide.  A 'load' routine loads the one-dimensional data to memory, and then a 'read' routine reads selected
particles.  If the files are small enough and sufficient memory is available, then the load step may be bypassed by
reading the entire two-dimensional image array to memory.

Matlab (find and display the largest particle in the file):
>> data = load_pbp_file("IMPACTS_HVPS3B-P3_20220213_allimages_v01.nc");
>> [~, imax] = max(data.diam);      %Particle index to read
>> im = get_single_pbp_image(data, imax);

IDL (read all particles with a timestamp of 66000 seconds):
   data = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc', /include_images)
   i = where(floor(data.time) eq 66000)
   images = get_pbp_images(data, i)
