function data=load_pbp_file(ncfile)
    % Read basic data from Convair netCDF files for the 2021 SPICULE field
    % campaign or other NCAR GV/C130 campaigns.  Put all relevant data into 
    % a structure.
    %
    % See also holoDianostics_spicule.m and holoprep.m

    arguments
        ncfile string
        %refvar string = "none"
    end
    
    %% Get basic data in netCDF file
    % More variables are available.  See documentation or variable listing.
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
    %data.t = ncread(ncfile,'t');
    %data.lat = ncread(ncfile, 'lat');
    %data.lon = ncread(ncfile, 'lon');
    %data.alt = ncread(ncfile, 'alt');
end
