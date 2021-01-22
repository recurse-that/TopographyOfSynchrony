classdef Scene < handle
    %Scene Constructs scene object
    %   All info and data for a given scene
    
  properties (Access = public)
      % PARAMS
      name
      focal_pxid
      buf
      radius
      year_count
      dim    % full dimensions
      idim   % inner dimensions
      
      % SET BY CLASS
      pxid_mat  % contains pxids 
      mxvi_mat  % contains mxvis at pxids
      mxvi_sd_mat % standard deviation at given pixel over time frame
      mxvi_avg  % contains the average max ndvi over time span
      pearson_mat  % pearson correlations
      spearman_mat % spearman correlations
      elev_mat % elevations
      elev_sd_mat % standard deviation of elevations
      geobounds  % outer latlon bounds
      igeobounds % inner latlon bounds
      watermask  % logical values representing water and land
      geo_axes   % geoaxes object that can be mapped to show satelite image
  end
    
  methods 
    % Constructors % 
    
    % calls set_pxid_mat and set_watermask
    function m_scene = Scene(name,focal_pxid, dims, buf, years, cols)
        %Scene class constructor
        %   Initializes all class member variables
        m_scene.name = name;
        m_scene.focal_pxid = focal_pxid;
        
        m_scene.buf = buf;
        m_scene.radius = buf - 1;
        
        m_scene.dim = [dims(1), dims(2)];
        m_scene.idim = [dims(1) - buf * 2, dims(2) - buf * 2];
        
        m_scene.year_count = years;

        m_scene.pxid_mat = nan(m_scene.dim);
        m_scene.elev_mat = zeros(m_scene.dim);
        m_scene.elev_sd_mat =  zeros(m_scene.idim);
        m_scene.mxvi_mat = nan( years, m_scene.dim(1), m_scene.dim(2) );
        m_scene.mxvi_avg = nan( m_scene.dim );
        m_scene.pearson_mat = nan( m_scene.idim );
        m_scene.spearman_mat = nan( m_scene.idim );
        m_scene.watermask = zeros( m_scene.dim(1), m_scene.dim(2), 'logical');
        m_scene.geo_axes = geoaxes;
       
        c = cols;
        set_pxid_mat(m_scene, c, dims(1), dims(2));
        set_watermask(m_scene);
        set_geo_axes(m_scene);
        
    end
   
    % Setters % 
    % Constructor Helpers
    function set_pxid_mat(m_scene, c, h, w)
      %set_pxid_mat defines pxid mat values
      %   Defines matrix with all pxids of the scene
      
      s_h = h / 2 - 1;
      s_w = w / 2 - 1;
       
      start_pxid = m_scene.focal_pxid - s_w - (s_h * c);
      cur_pxid = start_pxid;
    
      for i = 1:h
        for j = 1:w
          m_scene.pxid_mat(i,j) = cur_pxid;
          cur_pxid = cur_pxid + 1;
        end
        cur_pxid = start_pxid + c * i;
      end
    end
    function set_watermask(m_scene)
        load("ancillary_mat/modis_qkm_water_mask.mat", 'water1_land0');
        m_scene.watermask(1:end, 1:end) = water1_land0(m_scene.pxid_mat(1:end, 1:end));
    end
    function set_geo_axes(m_scene)
        load('ancillary_mat/modis_qkm_pixel_latlon.mat', 'modis_qkm_pixel_lat', 'modis_qkm_pixel_lon');
        start = m_scene.buf -1;
        rend = m_scene.dim(1) - start;
        cend = m_scene.dim(2) - start;
        pxid_bounds = m_scene.pxid_mat(start:rend, start:cend);
        latvec = modis_qkm_pixel_lat(pxid_bounds(:,:));
        lonvec = modis_qkm_pixel_lon(pxid_bounds(:,:));
        
        xmin = min(min(lonvec)); xmax = max(max(lonvec));
        ymin = min(min(latvec)); ymax = max(max(latvec));
        m_scene.igeobounds = [xmin, xmax, ymin, ymax];
        
        m_scene.geobounds(3) = modis_qkm_pixel_lat(m_scene.pxid_mat(1));
        m_scene.geobounds(4) = modis_qkm_pixel_lat(m_scene.pxid_mat(1, end));
        m_scene.geobounds(1) = modis_qkm_pixel_lon(m_scene.pxid_mat(1));
        m_scene.geobounds(2) = modis_qkm_pixel_lon(m_scene.pxid_mat(end, 1));
        
        gx = geoaxes;
        geoplot(gx,[ymin, ymax],[xmin, xmax],'g-*');
        m_scene.geo_axes = gx;
    end
    function set_elev_mat(m_scene)
%       start = m_scene.buf;
      start = 1;
%       rend = m_scene.idim(1) + start;
      rend = m_scene.dim(1);
%       cend = m_scene.idim(2) + start;
      cend = m_scene.dim(2);
      load('ancillary_mat/modis_qkm_pixel_latlon.mat', ...
           'modis_qkm_pixel_lat', 'modis_qkm_pixel_lon');
      for i = start:rend
        for j = start:cend
          lat = modis_qkm_pixel_lat(m_scene.pxid_mat(i,j));
          lon = modis_qkm_pixel_lon(m_scene.pxid_mat(i,j));
          cur = txsite('Name', 'cur', 'Latitude', lat, 'Longitude', lon);
          % elev = elevation(cur) * unitsratio('ft
          m_scene.elev_mat(i - start + 1, j - start + 1) = elevation(cur);
        end  % inner for
      end  % outer for
    end
    function set_elev_sd(m_scene)
      for i = m_scene.buf + 1 : m_scene.idim(1) + m_scene.buf
        for j = m_scene.buf + 1 : m_scene.idim(2) + m_scene.buf
          m_scene.elev_sd_mat(i - m_scene.buf,j - m_scene.buf) = circ_dev(m_scene, i, j, m_scene.buf-1);
        end  % end inner for
      end  % end outer for
      m_scene.elev_sd_mat = m_scene.elev_sd_mat(1:m_scene.idim(1), 1:m_scene.idim(2));
    end

    % MXVI Setters
    function set_mxvi_mat(m_scene, year, mxvi_vector)
      %set_mxvi_mat defines mxvi mat values
      %   Defines matrix with all mxvi values from the pxid values in
      %   pxid_mat using water_mask and mxvi vector for given year
      for i = 1:m_scene.dim(1)
        for j = 1:m_scene.dim(2)
          if m_scene.watermask(i, j) == 0  % if not covered by water
              px_val = double( mxvi_vector(m_scene.pxid_mat(i,j)) ) * 0.0001;
              m_scene.mxvi_mat(year, i, j) =  px_val;
          end
        end % inner for
      end % outer for
      
      set_mxvi_avg(m_scene);
      % m_scene.mxvi_mat = double(mxvi_vector(m_scene.pxid_mat)) * 0.0001;
    end %set_mxvi
    function set_mxvi_avg(m_scene)
        mean_ = mean(get_mxvi_mat(m_scene), 'omitnan');
        m_scene.mxvi_avg = squeeze(mean_(1, :, : ));
    end
    function set_mxvi_sd(m_scene)
      for i = m_scene.buf + 1 : m_scene.idim(1) + m_scene.buf
        for j = m_scene.buf + 1 : m_scene.idim(2) + m_scene.buf
          m_scene.mxvi_sd_mat(i - m_scene.buf, j-m_scene.buf) = time_dev(m_scene, i, j);
        end  % end inner for
      end  % end outer for
      m_scene.mxvi_sd_mat = m_scene.mxvi_sd_mat(1:m_scene.idim(1), 1:m_scene.idim(2));
    end
    % Correlation Setters 
    function set_corr_mat(m_scene)
      %set_corr_mat sets the correlation matrix using cross correlations
      %  Creates the default correlation matrix by calling the 
      ovr_corr(m_scene);
    end
    function ovr_corr(m_scene)
      for focx = m_scene.buf+1 : size(m_scene.mxvi_mat, 2) - m_scene.buf
        for focy = m_scene.buf+1 : size(m_scene.mxvi_mat, 3) - m_scene.buf
          px_syncs = circ_corr(m_scene, focx, focy, m_scene.radius);
          m_scene.pearson_mat(focx-m_scene.buf, focy-m_scene.buf) = px_syncs(1);
          m_scene.spearman_mat(focx-m_scene.buf, focy-m_scene.buf) = px_syncs(2);
        end % inner for
      end % outer for
    end % sync
    function px_synchrony = circ_corr(m_scene, focx, focy, rad)
    %Called to calculate average correlation coefficient of focal px with
    %surrounding px within radius rad
    % define empty matrix of size equal to bounding box of circle of radius r
    % around focal point
    % args (mat of size year_count by h by w, focal x, focal y, radius)
      pearson_corrs = double.empty;
      spearman_corrs = double.empty;
      count = 0;
      % define focal time series
      ts1 = squeeze(m_scene.mxvi_mat(:, focx, focy));
      % runs for all points in bounding box of circle of radius r
      
      for curx = focx - rad : focx + rad
        for cury = focy - rad : focy + rad
          if sqrt((curx - focx)^2 + (cury - focy)^2) <= rad
            if (curx ~= focx && cury ~= focy)
              % Ignore correlation with itself
              % m_scene.mxvi_mat(curx, cury) = nan;
           
              count = count + 1;
              % define time series to compare
              ts2 = squeeze(m_scene.mxvi_mat(:, curx, cury));
              pearson_corrs(count) = corr(ts1, ts2, 'Type', 'Pearson');
              spearman_corrs(count) = corr(ts1, ts2, 'Type', 'Spearman');
            end % inner ir
          end % outer if
        end % inner for
      end % outer for
      pearson = mean(pearson_corrs, 'omitnan');
      spearman = mean(spearman_corrs, 'omitnan');
      px_synchrony = [pearson, spearman];
    end % sync
    function px_elev_sd = circ_dev(m_scene, focx, focy, rad) 
      elevs = double.empty;
      count = 0; 
      % Check values within square of width = rad
      for curx = focx - rad : focx + rad
        for cury = focy - rad : focy + rad
          % If within the circle 
          if sqrt((curx - focx)^2 + (cury - focy)^2) <= rad
            count = count + 1;
            % set value in vector to corresponding elevation
            elevs(count) = m_scene.elev_mat(curx, cury); 
          end % inner if
        end % inner for 
      end % outer for for 
      % calculate sd of px's elev with surrounding px elevs
      px_elev_sd = std( elevs );
    end
    function px_mxvi_sd = time_dev(m_scene, x, y)
      % Record the values for each year at given pixel 
      mxvis = squeeze(m_scene.mxvi_mat(:, x, y));
      % Return the standard deviation at that pixel
      px_mxvi_sd = std( mxvis );
    end
    
    % Getters %

  
    % Figures %
    function cur_fig = tiled_layout(m_scene) 
      cur_fig = tiledlayout(3,2)
      title(cur_fig, m_scene.name);
      
      zmat = get_elev_mat(m_scene);
      
      % Surface Plot
      nexttile;
      surf(zmat, 'EdgeColor', 'none', 'FaceColor', 'interp');
      title('Elevation');
      
      % Standard Deviation of Elevation
      nexttile; 
      mesh(zmat, flipud(m_scene.elev_sd_mat), 'FaceColor', 'interp');
      title('Elevation');
      subtitle('Standard Deviation');
      
      % MXVI Plot
      nexttile;
      mesh(zmat, flipud(m_scene.mxvi_avg), 'FaceColor', 'interp');
      title('Avg. MXVI');
      
      % Standard Deviation of MXVI 
      nexttile;
      mesh(zmat, flipud(m_scene.mxvi_sd_mat), 'FaceColor', 'interp');
      title('MXVI');
      subtitle('St. Dev Over Time');
      
      % Pearson
      nexttile;
      mesh(zmat, flipud(m_scene.pearson_mat), 'FaceColor', 'interp');
      title('Pearson. Map');
      
      % Spearman Plot
      nexttile;
      mesh(zmat, flipud(m_scene.spearman_mat), 'FaceColor', 'interp');
      title('Spearman Map');
      
      l = m_scene.idim(1) / 4;
      w = m_scene.idim(2) / 4;
      
      d = date;
      p = append('run_results/', d, '/');
      
      f_name = append(p, m_scene.name, num2str(l), 'x', num2str(w));
      if not( isfolder(p) )
        mkdir( p );
      end
      
      savefig(f_name);
    end
    function cur_fig = select_fig_run(m_scene, choice)
      if choice == 1 
        cur_fig = avg_mxvi_fig;
      elseif choice == 2 
        cur_fig = pearson_fig(m_scene);
      elseif choice == 3
        cur_fig = spearman_fig(m_scene);
      elseif choice == 4
        cur_fig = elev_fig(m_scene);
      end
    end
    function avg_mxvi_fig = avg_mxvi_fig(m_scene)
      avg_mxvi_fig = figure(2);
      
      temp1 = m_scene.mxvi_avg;
      % Replace outliers by modifying means
      temp = filloutliers(temp1, 'nearest', 'mean');
      % Rescale values to range from 0 to 1 
      temp = rescale(temp);
      
      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])
      
      % Add title, labels, colorbar, and colormap
      title( "Average MXVI" )
      colorbar
      colormap(parula(256))
      cur_height = num2str( round(m_scene.idim(1) / 4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round(m_scene.idim(2) / 4) );
      ylabel( append(cur_width, "km") );
    end
    function pearson_fig = pearson_fig(m_scene)
      % returns mxvi colormap for selected scene @ selected year
      pearson_fig = figure(3);
      
      temp1 = m_scene.pearson_mat;
      % Replace outliers by modifying means
      temp = filloutliers(temp1, 'nearest', 'mean');
      % Rescale values to range from 0 to 1 
      temp = rescale(temp);
      
      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])
      
      % Add title, labels, colorbar, and colormap
      title( "Pearson Map" )
      colorbar
      colormap(parula(256))
      cur_height = num2str( round(m_scene.idim(1) / 4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round(m_scene.idim(2) / 4) );
      ylabel( append(cur_width, "km") );
      
    end
    function spearman_fig = spearman_fig(m_scene)
      % returns mxvi colormap for selected scene @ selected year
      spearman_fig = figure(4); 
      
      temp1 = m_scene.spearman_mat;
      % Replace outliers by modifying means
      temp = filloutliers(temp1, 'nearest', 'mean');
      % Rescale values to range from 0 to 1 
      temp = rescale(temp);
      
      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])
      
      % Add title, labels, colorbar, and colormap
      title( "Spearman Map" )
      colorbar
      colormap(parula(256))
      cur_height = num2str( round(m_scene.idim(1) / 4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round(m_scene.idim(2) / 4) );
      ylabel( append(cur_width, "km") );
      
    end
    function elev_fig = elev_fig(m_scene)
      elev_fig = figure(1);
      temp = m_scene.elev_mat / 3.281;
      for i = 1 : m_scene.idim(1)
        for j = 1 :m_scene.idim(2)
          if m_scene.watermask( i + m_scene.buf, j + m_scene.buf) 
            temp(i, j) = nan;
          end  % end inner if
        end  % end inner for
      end % end outer for
           
      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])
      
      % Add title, labels, colorbar, and colormap
      title( "Elevation Map" );
      colormap(parula(256));
      colorbar;
      cur_height = num2str( round(m_scene.idim(1) / 4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round(m_scene.idim(2) / 4) );
      ylabel( append(cur_width, "km") );
    end
    function tiled_fig = export_figs(m_scene)
        
        dir = append("Data/2D_maps/", m_scene.name);
        % mkdir(dir);
        exts = ["/avg_mxvi.png", "/pearson.png", "/spearman.png", "/elev.png",...
                "/tiled.pdf"];
        dirs = strings( size(exts,1)-1, 1 );
       
        cur_dir = append(dir, exts(1));
        dirs(1) = cur_dir
        avg_mxvi = avg_mxvi_fig(m_scene);
        export_fig(cur_dir, avg_mxvi);
        
        cur_dir = append(dir, exts(2));
        dirs(2) = cur_dir
        pearson = pearson_fig(m_scene);
        export_fig(cur_dir, pearson);
        
        cur_dir = append(dir, exts(3));
        dirs(3) = cur_dir
        spearman = spearman_fig(m_scene);
        export_fig(cur_dir, spearman);
        
        cur_dir = append(dir, exts(4));
        dirs(4) = cur_dir
        elev = elev_fig(m_scene);
        export_fig(cur_dir, elev);
        
        cur_dir = append(dir, exts(end));
        tiled_fig = figure(5)
        tiles = imtile(dirs, 'Frames', 1:4, 'GridSize', [2,2], 'BorderSize', [5,10], 'BackgroundColor', 'white');
        
        imshow(tiles);
        title(m_scene.name);
        tiled_fig = dirs;
        % export_fig(tiled_fig, cur_dir, '-pdf'); 
        % tiles = dirs;
    end
    function cropped_tiles = import_figs(m_scene, dirs, border_crop)
        fname = append("/tiled", num2str(m_scene.idim(1) - border_crop),...
                       'x', num2str(m_scene.idim(2) - border_crop), 'pxs.pdf');
        rect = [ border_crop, border_crop,...
                 m_scene.idim(1) - border_crop,...
                 m_scene.idim(2) - border_crop ];
        for i = 1:size(dirs, 1)-1
          img = imshow(dirs(i));
          crops(i) = imcrop(img, rect);
        end
        cropped_tiles = crops;
        export_fig(cropped_tiles, append("run/figs/", m_scene_name, fname), '-pdf');
    end
    
    % Getters %
    function mxvi_mat = get_mxvi_mat(m_scene)
      %get_mxvi_mat returns mxvi_mats for all years
      b = m_scene.buf;
      h = m_scene.dim(1);
      w = m_scene.dim(2);
      ih = m_scene.idim(1);
      iw = m_scene.idim(2);
      yr = m_scene.year_count;
      mxvi_mat = ones(yr, ih, iw);
      mxvi_mat(1:yr, 1:end, 1:end) = m_scene.mxvi_mat(1:yr, b+1 : h-b, b+1 : w-b);
    end
    function mxvi_mat = get_mxvi_year(m_scene, year)
        %get_mxvi_year returns mxvi mat at a specific year
        temp = get_mxvi_mat(m_scene);
        mxvi_mat = squeeze( temp(year, :, : ) );
    end
    function inner_mat = get_elev_mat(m_scene)
      inner_mat = m_scene.elev_mat( m_scene.buf + 1 : m_scene.idim(1) + m_scene.buf, m_scene.buf + 1 : m_scene.idim(2) + m_scene.buf )  
    end
    function pearson_mat = get_pearson_mat(m_scene)
      %get_coor_mat returns the correlation matrix with the adjusted 0 to 1
      %range
      pearson_mat = adjust_range(m_scene);
    end
   
    function export_csv(m_scene) 
      big_mat = zeros( m_scene.idim(1) * m_scene.idim(2) , 8);
      width = m_scene.idim(2);
      for i = 1:m_scene.idim(1)
        for j = 1:m_scene.idim(2)
          index = (i-1) * (width) + (j);
          % X coord
          big_mat(index, 1) = i;
          % Y coord
          big_mat(index, 2) = j;
          % Elevation 
          big_mat(index, 3) = m_scene.elev_mat(i,j);
          % Elevation stdev
          big_mat(index, 4) = m_scene.elev_sd_mat(i,j);
          % MXVI 
          big_mat(index, 5) = m_scene.mxvi_avg(i,j);
          % MXVI stdev
          big_mat(index, 6) = m_scene.mxvi_sd_mat(i,j);
          % Pearson 
          big_mat(index, 7) = m_scene.pearson_mat(i, j);
          % Spearman
          big_mat(index, 8) = m_scene.spearman_mat(i,j);

        end  % inner for
      end  % outer for
      
      d = date;
      p = append('output_data/csv_files', d, '/');
      % f_name = append(p, m_scene.name);
      f_name = append('output_data/csv_files/', m_scene.name);
      writematrix(big_mat, f_name);
    end
  end  % end methods
end  % end classdef



