classdef tempScene < handle
    %Scene Constructs scene object
    %   All info and data for a given scene
    
  properties (Access = public)
      % PARAMS
      name
      height
      width
      focal_lat
      focal_lon
      radius
      year_count
      
      % Variables
      focal_pxid % pxid of the center pixel of the scene
      
      % Matrices

      lat_mat
      lon_mat
      watermask
      pxid_mat  % contains pxids 
      mxvi_mat  % contains mxvis at pxids
      mxvi_avg  % contains the average max ndvi over time span
      mxvi_sd % standard deviation at given pixel over time frame
      elev_mat % elevations
      elev_sd % standard deviation of elevations
      pearson_mat  % pearson correlations
      spearman_mat % spearman correlations

      
  end
  
  methods
    function s = tempScene(name, dims, latlon, rad, years, cols)
        %Scene class constructor
        %   Initializes all class member variables
        s.name = name;
        s.height = dims(1);
        s.width = dims(2);
        s.focal_lat = latlon(1);
        s.focal_lon = latlon(2);
        s.radius = rad;
        s.year_count = years;
        
    end  % Constructor
    
    function setFocalPixels(s, lat_vector, lon_vector, r, c)
      s.focal_pxid = get_pxid([s.focal_lat, s.focal_lon],... 
                              lat_vector, lon_vector, r, c);
    end  % setFocalPixels
    
    function setPXID(s, cols, wm)
      %setPXID defines matrix containing pxids and defines the watermask
      
      % Calculate how far the edges of the scene are from the focal pxid
      h = s.height / 2 - 1;
      w = s.width / 2 - 1;
      
      % Set the top left pxid as the start
      start_pxid = s.focal_pxid - w - (h * cols);
      cur_pxid = start_pxid;
      
      % Fill in the pxid matrix 
      for i = 1:s.height
        for j = 1:s.width
          s.pxid_mat(i,j) = cur_pxid;
          s.watermask(i,j) = wm(cur_pxid);
          % columnwise increment the pxid
          cur_pxid = cur_pxid + 1;
        end  % inner for 
        % row wise increment the pxid
        cur_pxid = start_pxid + cols * i;
      end  % outer for
    end  % setPXID
    
    function setLatLon(s, lats, lons)
      %setLatLon defines a matrix with all of the scene pixels lats / lons
      s.lat_mat = zeros(s.height, s.width);
      s.lon_mat = zeros(s.height, s.width);
      s.lat_mat(1:s.height, 1:s.width) =...
                lats( s.pxid_mat(1:s.height, 1:s.width));
      s.lon_mat(1:s.height, 1:s.width) =...
                lons( s.pxid_mat(1:s.height, 1:s.width));
    end  % setLatLon
    
    function setElev(s)
      %setElev sets matrices containing the elevations of each pixel
      for i = 1:s.height
        for j = 1:s.width
          lat = s.lat_mat(i,j);
          lon = s.lon_mat(i,j);
          cur = txsite('Name', 'cur', 'Latitude', lat, 'Longitude', lon);
          s.elev_mat(i,j) = elevation(cur);
        end  % inner for 
      end  % outer for
    end  % setElev
    
    function setMXVI(s, mxvis, year_count)
      %setMXVI defines pxid mat values
      %   Defines matrices with MXVI mats for each year
      %   Defines matrix with avg MXVI through all years
      %   Defines matrix with standard deviation of MXVI over all years
      
      % Set the yearly MXVIs for the scene
      s.mxvi_mat = NaN(year_count, s.height, s.width);
      s.mxvi_avg = zeros(s.height);
      s.mxvi_sd = zeros(s.width);
      for i = 1:s.height
        for j = 1:s.width
            px_ts = getTimeSeries(s, s.pxid_mat(i,j), year_count, mxvis);
            if ( s.watermask(i,j) == 0 )
              s.mxvi_mat(:,i,j) = px_ts;
              % Set the avg MXVI for all the years
              s.mxvi_avg(i,j) = mean(px_ts);
              % Set the standard deviation of MXVI between all years
              s.mxvi_sd(i,j) = std(px_ts);
            else 
              s.mxvi_sd(i,j) = NaN;
              s.mxvi_avg(i,j) = NaN;
            end
        end  % inner for
      end  % outer for
    end  % setMXVI
    
    function setSynchrony(s)
      %setSynchrony defines pearson, spearman, and elevation std
      
      s.elev_sd = zeros(s.height - (2*s.radius), s.width - (2*s.radius));
      s.pearson_mat = zeros(s.height - (2*s.radius), s.width - (2*s.radius));
      s.spearman_mat = zeros(s.height - (2*s.radius), s.width - (2*s.radius));
      % Calculate the synchrony and elevation std of the scene
      for i = s.radius + 1 : s.height - s.radius
        for j = s.radius + 1 : s.width - s.radius
          circleCalculations(s, i, j, s.radius)
        end  % inner for
      end  % outer for
    end  % setSynchrony
    
    
    function fig_3D = tiled3DLayout(s, dataPath) 
      %tiled3DLayout returns a figure with 3D matlab plots for the scene
      % The z axis of all maps represents elevation while MXVI, MXVI std,
      % Pearson and Spearman represent the xy axes of the maps and are
      % visually represented by the color overlay
      
      % initialize a tiled layout and add the scene name as the title
      fig_3D = tiledlayout(3,2)
      title(fig_3D, s.name);
      % elevation is always the z value
      zmat = s.elev_mat;
      % Surface Plot of elevation
      nexttile;
      surf(zmat, 'EdgeColor', 'none', 'FaceColor', 'interp');
      title('Elevation');
      % Standard Deviation of Elevation
      nexttile; 
      mesh(zmat, flipud(s.elev_sd), 'FaceColor', 'interp');
      title('Elevation');
      subtitle('Standard Deviation');
      % MXVI Plot
      nexttile;
      mesh(zmat, flipud(s.mxvi_avg), 'FaceColor', 'interp');
      title('Avg. MXVI');
      % Standard Deviation of MXVI 
      nexttile;
      mesh(zmat, flipud(s.mxvi_sd), 'FaceColor', 'interp');
      title('MXVI');
      subtitle('St. Dev Over Time');
      % Pearson
      nexttile;
      mesh(zmat, flipud(s.pearson_mat), 'FaceColor', 'interp');
      title('Pearson. Map')
      % Spearman Plot
      nexttile;
      mesh(zmat, flipud(s.spearman_mat), 'FaceColor', 'interp');
      title('Spearman Map');
      
      km_h = s.height / 4;
      km_w = s.width / 4;
      str_dimensions = append(' ', num2str(km_h), ' km x ',...
                              num2str(km_w), ' km');
      cd(dataPath);
      saveDir = 'Scene_3D_Figures';
      if not ( isfolder(saveDir) )
        mkdir(saveDir);
      end
      cd(saveDir);
      f_name = append(s.name, str_dimensions, '.fig');
      savefig(f_name);
    end  % tiled3DLayout
    
    function circleCalculations(s, focx, focy, rad)
      %circleCalculations calculates Spearman, Pearson, and elev std values
      % All of the calculations that compare focal pixels with nearby
      % pixels are calculated together here to avoid redundancy
      
      % initialize vector to hold elevs within radius of focal pixel
      elevs = double.empty;
      % initialize vector to hold correlations found from time series
      pearson_corrs = double.empty;
      spearman_corrs = double.empty;
      % count is what indexes each new value in the vectors
      count = 0;
      % define focal time series
      ts1 = squeeze(s.mxvi_mat(:, focx, focy));
      % runs for all points in bounding box of circle of radius r
      for curx = focx - rad : focx + rad
        for cury = focy - rad : focy + rad
          if sqrt((curx - focx)^2 + (cury - focy)^2) <= rad
            if (curx ~= focx && cury ~= focy)
              % Ignore correlation with itself
              % m.mxvi_mat(curx, cury) = nan;
              count = count + 1;
              % define elevation at point for std calculation
              elevs(count) = s.elev_mat(curx, cury);
              % define time series to compare
              ts2 = squeeze(s.mxvi_mat(:, curx, cury));
              pearson_corrs(count) = corr(ts1, ts2, 'Type', 'Pearson');
              spearman_corrs(count) = corr(ts1, ts2, 'Type', 'Spearman');
            end % inner ir
          end % outer if
        end % inner for
      end % outer for
      s.elev_sd(focx - rad, focy - rad) = std(elevs);
      s.pearson_mat(focx - rad, focy - rad) = mean(pearson_corrs, 'omitnan');
      s.spearman_mat(focx - rad, focy - rad) = mean(spearman_corrs, 'omitnan');
  
    end  % circleCalculations
    
    function normalizeMatrices(s)
      %normalizeMatrices trims all the matrices to the same size
      % Since Pearson and Spearman values are calculated using surrounding
      % pixels, all pixels < a distance of radius from the perimeter don't
      % have Pearson or Spearman values, the other maps must be trimmed to
      % match the Pearson and Spearman matrix dimensions
      start = s.radius + 1;
      rend = s.height - s.radius;
      cend = s.width - s.radius;
      
      s.lat_mat = s.lat_mat( start:rend, start:cend );
      s.lon_mat = s.lon_mat( start:rend, start:cend );
      s.pxid_mat = s.pxid_mat( start:rend, start:cend );
      s.mxvi_sd = s.mxvi_sd( start:rend, start:cend );
      s.mxvi_avg = s.mxvi_avg( start:rend, start:cend );
      s.elev_mat = s.elev_mat( start:rend, start:cend );

    end  % normalizeMatrices
    
    
  end  % methods
  
  
% HELPER FUNCTIONS
end  % classdef

  function px_ts = getTimeSeries(s, pxid, year_count, mxvis)
      px_ts = double.empty;
      for year = 1:year_count
        cur_ts = mxvis{year}(pxid);
        cur_ts = double(cur_ts) * 0.0001;
        px_ts(year) = cur_ts;
      end  % for 
  end  % end getTimeSeries
  
  function closest_pxid = get_pxid(latlon, lat_vector, lon_vector, r, c)

    closest_diff = zeros(1,2);
    at_index1 = [lat_vector(1), lon_vector(1)];
    closest_diff(1,1) = get_gcd(latlon, at_index1);

    closest_pxid = 1; 
    for i = 1:r*c
        cur_latlon = [lat_vector(i), lon_vector(i)];
        closest_diff(1,2) = get_gcd(latlon, cur_latlon);
        if ( closest_diff(1,2) <= closest_diff(1,1) )
            closest_diff(1,1) = closest_diff(1,2);
            closest_pxid = i;
        end  % end if
    end  % end for 
  end  % get_pxid
  
  function gcdist = get_gcd(loc1, loc2)
    r = 360/(2*pi);
    loc1 = loc1 / r;
    loc2 = loc2 / r;
    dist_lon = loc1(1) - loc2(1);
    dist_lat = loc1(2) - loc2(2);
    a = (sin(dist_lat/2))^2+cos(loc1(2))*cos(loc2(2))*(sin(dist_lon/2))^2;

    gcdist = 2 * atan2(sqrt(a), sqrt(1 - a));
    multiplier = 6370;
    
    gcdist = multiplier * gcdist;
  end  % get_gcd
  