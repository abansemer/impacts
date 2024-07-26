FUNCTION get_single_pbp_image, data, i
   ;FUNCTION to retrieve a single image in a PBP file 'data' with index 'i'
   ;
   ;Example showing all particles with a timestamp of 66000 seconds:
   ;   data = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc')
   ;   i = 1000
   ;   image = get_single_pbp_image(data, i)

   ;If image array is already loaded in memory just extract the image and return
   IF total(tag_names(data) eq 'IMAGE') THEN BEGIN
      currentimage = data.image[data.startx[i]:data.stopx[i], data.starty[i]:data.stopy[i]]
      return, currentimage
   ENDIF

   ;If images are not loaded, then open the netCDF file and get it from there
   ncid = ncdf_open(data.filename)

   ;Get image from netCDF file
   countx = data.stopx[i] - data.startx[i] + 1
   county = data.stopy[i] - data.starty[i] + 1
   ncdf_varget, ncid, 'image', currentimage, count=[countx, county], $
      offset=[data.startx[i], data.starty[i]]

   ;Close netCDF file
   ncdf_close, ncid

   return, currentimage
END
