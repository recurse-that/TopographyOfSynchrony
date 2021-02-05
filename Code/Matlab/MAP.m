classdef MAP < handle
  
  properties(Access = public)
    scene
    data_path
    code_path
    maps2D_save_path
    scene_2D_save_path
    figs3D_save_path 
    
  end  % properties
  
  methods
    function m = MAP(cur_scene, path_to_data, path_to_code)
      m.scene = cur_scene;
      m.data_path = path_to_data;
      m.code_path = path_to_code;
      m.maps2D_save_path = append(path_to_data, '/Scene_2D_Maps');
      if ~exist(m.maps2D_save_path, 'dir')
        mkdir(m.maps2D_save_path);
      end  % if
      
      m.figs3D_save_path = append(path_to_data, '/Scene_3D_Figures');
      if ~exist(m.maps2D_save_path, 'dir')
        mkdir(m.figs3D_save_path);
      end  % if
      
      m.scene_2D_save_path = append(m.maps2D_save_path, '/', m.scene.name);
      if ~exist(m.scene_2D_save_path, 'dir')
        mkdir(m.scene_2D_save_path);
      end  % if
    end  % constructor
    
    function elev_fig = elev_fig(m)
      elev_fig = figure(1);
      temp = m.scene.elev_mat;

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
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
    end  % elev_fig
    function elev_sd_fig = elev_sd_fig(m)
      elev_sd_fig = figure(2);
      temp = m.scene.elev_sd;

      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])

      % Add title, labels, colorbar, and colormap
      title( "Elevation std" );
      colormap(parula(256));
      colorbar;
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
    end  % elev_sd_fig
    function avg_mxvi_fig = avg_mxvi_fig(m)
      avg_mxvi_fig = figure(3);
      
      temp1 = m.scene.mxvi_avg;
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
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
    end  % avg_mxvi_fig
    function mxvi_sd_fig = mxvi_sd_fig(m)
      mxvi_sd_fig = figure(4);
      temp = m.scene.mxvi_sd;

      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])

      % Add title, labels, colorbar, and colormap
      title( "MXVI std (temporal)" );
      colormap(parula(256));
      colorbar;
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
    end  % mxvi_sd_fig
    function pearson_fig = pearson_fig(m)
      % returns mxvi colormap for selected scene @ selected year
      pearson_fig = figure(5);
      
      temp1 = m.scene.pearson_mat;
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
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
      
    end
    function spearman_fig = spearman_fig(m)
      % returns mxvi colormap for selected scene @ selected year
      spearman_fig = figure(6); 
      
      temp1 = m.scene.spearman_mat;
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
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
      
    end
   
    function tiled_2D_fig = export_2D_maps(m)
      clf;
      exts = ["/Elevation.png", "/Elevation std.png",...
              "/MXVI Average.png", "/MXVI std.png", ...
              "/Pearson.png", "/Spearman.png", "/2DMaps.pdf"];
      dirs = strings( size(exts,1)-1, 1 );

      cur_dir = append(m.scene_2D_save_path, exts(1));
      dirs(1) = cur_dir;
      elev = elev_fig(m);
      export_fig(cur_dir, elev);
      % print(cur_dir);

      cur_dir = append(m.scene_2D_save_path, exts(2));
      dirs(2) = cur_dir;
      elev_sd = elev_sd_fig(m);
      export_fig(cur_dir, elev_sd);
      % print(cur_dir, '-png');
      
      cur_dir = append(m.scene_2D_save_path, exts(3));
      dirs(3) = cur_dir;
      mxvi_avg = avg_mxvi_fig(m);
      export_fig(cur_dir, mxvi_avg);
      % print(cur_dir, '-png');
      
      cur_dir = append(m.scene_2D_save_path, exts(4));
      dirs(4) = cur_dir;
      mxvi_sd = mxvi_sd_fig(m);
      export_fig(cur_dir, mxvi_sd);
      % print(cur_dir, '-png');
      
      cur_dir = append(m.scene_2D_save_path, exts(5));
      dirs(5) = cur_dir;
      pearson = pearson_fig(m);
      export_fig(cur_dir, pearson);
      % print(cur_dir, '-png');

      cur_dir = append(m.scene_2D_save_path, exts(6));
      dirs(6) = cur_dir;
      spearman = spearman_fig(m);
      export_fig(cur_dir, spearman);
      % print(cur_dir, '-png');

      cur_dir = append(m.scene_2D_save_path, exts(end));
      tiled_2D_fig = figure(7);
      tiles = imtile(dirs, 'Frames', 1:6, 'GridSize', [3,2], 'BorderSize', [5,10], 'BackgroundColor', 'white');

      tiled_im = imshow(tiles);
      title(m.scene.name);
      saveas(tiled_im, cur_dir);
      
      % print(tiled_fig, cur_dir, '-fillpage')
     
    end  % export_2D_maps
    function tiled_3D_fig = export_3D_figs(m) 
      clf;
      tiled_3D_fig = tiledlayout(3,2);
      title(tiled_3D_fig, m.scene.name);
      
      zmat = m.scene.elev_mat;
      
      % Surface Plot
      nexttile
      surf(zmat, 'EdgeColor', 'none', 'FaceColor', 'interp');
      title('Elevation');
      
      % Standard Deviation of Elevation
      nexttile
      mesh(zmat, flipud(m.scene.elev_sd), 'FaceColor', 'interp');
      title('Elevation');
      subtitle('Standard Deviation');
      
      % MXVI Plot
      nexttile
      mesh(zmat, flipud(m.scene.mxvi_avg), 'FaceColor', 'interp');
      title('Avg. MXVI');
      
      % Standard Deviation of MXVI 
      nexttile
      mesh(zmat, flipud(m.scene.mxvi_sd), 'FaceColor', 'interp');
      title('MXVI');
      subtitle('St. Dev Over Time');
      
      % Pearson
      nexttile
      mesh(zmat, flipud(m.scene.pearson_mat), 'FaceColor', 'interp');
      title('Pearson. Map');
      
      % Spearman Plot
      nexttile
      mesh(zmat, flipud(m.scene.spearman_mat), 'FaceColor', 'interp');
      title('Spearman Map');
      
      l = ( m.scene.height - (m.scene.radius*2) ) / 4;
      w = ( m.scene.width - (m.scene.radius*2) ) / 4;
      
      m.figs3D_save_path
      f_name = append(m.figs3D_save_path, '/', m.scene.name,...
                      num2str(l),'x', num2str(w));
      
      savefig(f_name);
    end  % export_3D_figs
      
  end  % methods
end  % classdef