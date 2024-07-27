FUNCTION get_pbp_images, data, particleindex, show_images=show_images
   ;FUNCTION to retrieve multiple images in the PBP structure 'data' with index 'i'
   ;with option to show images to a graphics window.
   ;
   ;Example showing all particles with a timestamp of 66000 seconds:
   ;   data = load_pbp_file('IMPACTS_HVPS3B-P3_20200224_allimages_v01.nc', /include_images)
   ;   i = where(floor(data.time) eq 66000)
   ;   images = get_pbp_images(data, i)

   IF n_elements(show_images) eq 0 THEN show_images = 1

   ;Check if have OAP or other probe by checking the stopx values (always the same for OAP)
   haveoap = 1
   IF min(data.stopx[particleindex]) ne max(data.stopx[particleindex]) THEN haveoap = 0

   ;Initialize the array to hold images
   image = []  ;For OAPs
   IF not(haveoap) THEN image = bytarr(1000, 100000)
   ypos = 0   ;Y-posistion for non-OAP data

   ;Get each image individually
   FOR i = 0, n_elements(particleindex)-1 DO BEGIN
      currentimage = get_single_pbp_image(data, particleindex[i])

      ;Add image to array for OAPs (or single images)
      IF haveoap THEN image = [[image], [currentimage]]
      IF not(haveoap) THEN BEGIN
         ;Non-OAP
         s = size(currentimage, /dim)
         IF ypos+s[1] ge 100000 THEN BEGIN
            print, 'Too many images, stopping at ' + string(i, format='(i0)')
            i = 99999999
         ENDIF ELSE BEGIN
            image[0:s[0]-1, ypos:ypos+s[1]-1] = currentimage
            ypos += (s[1]+1)  ;Move to next y-position
         ENDELSE
      ENDIF
   ENDFOR

   IF not(haveoap) THEN image = image[*, 0:ypos]

   ;Show a page of images in a series of vertical strips
   IF show_images THEN BEGIN
      iwindow = 0
      window, iwindow, xsize=1000, ysize=1000
      s = size(image, /dim)

      ;Plot strips of 1000 pixels at a time
      ypos = 0    ;Strip y-position
      FOR i = 0, s[1]/1000 DO BEGIN
         ;Extract strip
         strip = image[*, i*1000:((i+1L)*1000-1)<(s[1]-1)]
         stripwidth = max(where(total(strip, 2) gt 0))
         strip = strip[0:stripwidth, *]

         ;Check if new window needed
         IF (ypos+stripwidth) ge 1000 THEN BEGIN
            iwindow++
            window, iwindow, xsize=1000, ysize=1000
            ypos = 0   ;Reset y-position
         ENDIF
         IF haveoap THEN strip = (1-strip)*200  ;Better colors for OAPs
         tv, transpose(strip), 0, 1000-ypos-stripwidth-5
         ypos += (stripwidth + 5)

         ;Exit loop if 5+ windows
         IF iwindow ge 5 THEN BEGIN
             i = 99999999
             print, 'Too many images to show, returning.'
          ENDIF
      ENDFOR
   ENDIF

   return, image
END
