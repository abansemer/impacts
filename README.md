NASA IMPACTS full cloud particle imagery (2020, 2022, 2023)
===========================================================

## Data download
425 GB for entire dataset  
https://app.globus.org/file-manager?origin_id=62c21b98-b06d-46f4-8695-94d89800ab0f&origin_path=%2F

## Description
All files are in netCDF format, with one file per probe per flight.  Probes include:
   - Hawkeye CPI
   - Hawkeye 2D-S (horizontal and vertical arrays)
   - HVPS-3 (A=horizontal, B=vertical)
   - Standalone 2D-S (horizontal and vertical arrays)  

Images are stored as two-dimensional byte arrays.  Optical array probes (2D-S and HVPS3) have a fixed image width of
128 elements, and an unlimited image length.  High resolution imagery (Hawkeye CPI) has a variable image width and
height for each particle.

Use the 'startx', 'stopx', 'starty', and 'stopy' variables to extract individual images from the main image array.
This can be done by loading the entire image into memory (if possible), or by using the 'start' and 'count' arguments
available in netCDF read routines.

Individual particle metrics and environmental data are stored in one-dimensional arrays, and vary by instrument.  See
the netCDF attributes in each file for detailed variable descriptions and units.


## How to read
These files can be read with any netCDF utility.  Routines for extracting and displaying particles in Matlab and IDL
are provided in this repository.  In these examples, a 'load' routine loads the one-dimensional data to memory, and
then a 'read' routine reads and displays the selected particles.

### Matlab  
  **Example 1:** Display all HVPS particles with a timestamp of 66000 and 66001
  seconds, and put them into separate arrays.

     hvps = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc');
     images1 = get_pbp_images(hvps, 'second', 66000);
     images2 = get_pbp_images(hvps, 'second', 66001);

  **Example 2:** As above, but only load 2000 seconds of data to save memory.
  
     hvps = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc',...
        'starttime', 65000, 'stoptime', 67000);
     images = get_pbp_images(hvps, 'second', 66000);

  **Example 3:** Display all CPI particles between -15 and -16 degrees C, and
  above 500 microns in size.  Then show the first image separately.

     cpi = load_pbp_file('IMPACTS_CPI-P3_20200224_allimages_v01.nc');
     images = get_pbp_images(cpi, 'maxt', -15, 'mint', -16, 'minsize', 500);
     imshow(images{1})


### IDL  
   **Example 1:** Read all particles with a timestamp of 66000 seconds.
   
      data = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc', /include_images)
      i = where(floor(data.time) eq 66000)
      images = get_pbp_images(data, i)
