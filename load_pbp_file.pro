FUNCTION load_pbp_file, fn, include_images=include_images
   ;Load the variables of a PBP file
   ;Can optionally load images if enough memory is available
   ;
   ;Example showing all particles with a timestamp of 66000 seconds:
   ;   data = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc', /include_images)
   ;   i = where(floor(data.time) eq 66000)
   ;   images = get_pbp_images(data, i)

   IF n_elements(include_images) eq 0 THEN include_images = 0

   ;Arrays are sometimes too big to use restorenc.pro routine.  Manually load data instead.
   ;More variables are available.  See documentation or variable listing in the files.
   ncid = ncdf_open(fn)
   info = ncdf_inquire(ncid)
   varlist = strarr(info.nvars)
   FOR i = 0, info.nvars-1 DO varlist[i] = (ncdf_varinq(ncid,i)).name
   ncdf_varget, ncid, 'time', time
   ncdf_varget, ncid, 'diam', diam
   ncdf_varget, ncid, 'arearatio', arearatio
   ncdf_varget, ncid, 'aspectratio', aspectratio
   ncdf_varget, ncid, 'startx', startx
   ncdf_varget, ncid, 'stopx', stopx
   ncdf_varget, ncid, 'starty', starty
   ncdf_varget, ncid, 'stopy', stopy
   out = {filename:fn, time:time, diam:diam, arearatio:arearatio, aspectratio:aspectratio, $
      startx:startx, stopx:stopx, starty:starty, stopy:stopy}

   ;Optional variables
   IF total(varlist eq 't') THEN BEGIN
      ncdf_varget, ncid, 't', t
      out = create_struct(out, 't', t)
   ENDIF
   IF total(varlist eq 'lat') THEN BEGIN
      ncdf_varget, ncid, 'lat', lat
      out = create_struct(out, 'lat', lat)
   ENDIF
   IF total(varlist eq 'lon') THEN BEGIN
      ncdf_varget, ncid, 'lon', lon
      out = create_struct(out, 'lon', lon)
   ENDIF
   IF total(varlist eq 'alt') THEN BEGIN
      ncdf_varget, ncid, 'alt', alt
      out = create_struct(out, 'alt', alt)
   ENDIF

   ncdf_close, ncid

   return, out
END
