classdef MAP < handle
  
  properties(Access = public)
    scene  % scene the map represents
    data_path
    code_path
    maps2D_save_path
    scene_2D_save_path
    figs3D_save_path 
    
    elev_map
    elev_sd_map
    avg_mxvi_map
    mxvi_sd_map
    pearson_map
    spearman_map
    
    tiled_2D_layout
    tiled_3D_layout
    
  end  % properties
  
  methods
    function m = MAP(cur_scene, path_to_data, path_to_code)
      %MAP constructor creates folders for maps to be exported to
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
    
    function elev_fig(m)
      %elev_fig returns a 2D elevation map
      % exports returned figure as a jpeg
      
      temp = m.scene.elev_mat;

      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])

      % Add title, labels, colorbar, and colormap
      title( "Elevation" );
      colormap(parula(256));
      colorbar;
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
      
    end  % elev_fig
    function elev_sd_fig(m)
      %elev_sd_fig returns a 2D elevation standard deviation map 
      
      % elev_sd_fig = figure(2);
      temp = m.scene.elev_sd;

      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])

      % Add title, labels, colorbar, and colormap
      title( "Elevation SD" );
      colormap(parula(256));
      colorbar;
      cur_height = num2str(round((m.scene.height - (m.scene.radius*2))/4));
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
    end  % elev_sd_fig
    function avg_mxvi_fig(m)
      %avg_mxvi_fig returns a 2D Average MXVI map
      
      temp = m.scene.mxvi_avg;
      
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
    function mxvi_sd_fig(m)
      %mxvi_sd_fig returns a 2D MXVI standard deviation map
      temp = m.scene.mxvi_sd;

      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])

      % Add title, labels, colorbar, and colormap
      title( "MXVI SD (temporal)" );
      colormap(parula(256));
      colorbar;
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
    end  % mxvi_sd_fig
    function pearson_fig(m)
      %pearson_fig returns mxvi colormap for selected scene @ selected year
      
      temp = m.scene.pearson_mat;
      
      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])
      
      % Add title, labels, colorbar, and colormap
      title( "Synchrony (Pearson)" )
      colorbar
      colormap(parula(256))
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );
    end  % pearson_fig
    function spearman_fig(m)
      %spearman_fig returns mxvi colormap for selected scene @ selected year
      
      temp = m.scene.spearman_mat;
      
      % Create image for temp
      h = imagesc(temp);
      % Set nan values to transparent
      set(h, 'alphadata', ~isnan(temp))
      % Make the background color white
      set(gca,'color', 'white', 'XTick', [], 'YTick', [])
      
      % Add title, labels, colorbar, and colormap
      title( "Synchrony (Spearman)" )
      colorbar
      colormap(parula(256))
      cur_height = num2str( round( (m.scene.height - (m.scene.radius*2))/4) );
      xlabel( append(cur_height, "km") );
      cur_width = num2str( round( (m.scene.width - (m.scene.radius*2))/4) );
      ylabel( append(cur_width, "km") );

    end  % spearman_fig
    
    function elev_sd_v_pearson(m)
        clf;
        zmat = m.scene.elev_sd;
        mesh(zmat, m.scene.pearson_mat, 'FaceColor', 'interp');
    end  % elev_sd_v_pearson
   
    function indexer(m, i) 
      %indexer calls one of the above fig constructors depending on param i
      % This allows figures to be generated within a for loop
      if i == 1
        m.elev_map = figure(i);
        % set(m.elev_map,'DataAspectRatio', [1 1 1]);
        elev_fig(m);
      elseif i == 2
        m.elev_sd_map = figure(i);
        % set(gca,'DataAspectRatio', [1 1 1]);
        elev_sd_fig(m);
      elseif i == 3
        m.avg_mxvi_map = figure(i);
        % set(gca,'DataAspectRatio', [1 1 1]);
        avg_mxvi_fig(m);
      elseif i == 4
        m.mxvi_sd_map = figure(i);
        % set(gca,'DataAspectRatio', [1 1 1]);
        mxvi_sd_fig(m);
      elseif i == 5
        m.pearson_map = figure(i);
        % set(gca,'DataAspectRatio', [1 1 1]);
        pearson_fig(m);
      else
        m.spearman_map = figure(i);
        % set(gca,'DataAspectRatio', [1 1 1]);
        spearman_fig(m);
      end  % if else block
    end  % indexer
    function export_individual_2D_maps(m)
      %export_individual_2D_maps saves each 2D map to its own jpeg file
      
      clf;
      % Index save path names
      all_save_paths = ["/ElevationMap.jpg",...
                        "/ElevationStandardDeviationMap.jpg",...
                        "/MXVIAverageMap.jpg",...
                        "/MXVIStandardDeviationMap.jpg",...
                        "/PearsonMap.jpg",...
                        "/SpearmanMap.jpg"];
      for i = 1 : length(all_save_paths)                 
        cur_path = append( m.scene_2D_save_path, all_save_paths(i) );
        figure(i);
        indexer(m, i);
        saveas(gcf, cur_path);
      end  % for 
    end  % export_individual_2D_maps
    
    function export_tiled_2D_maps(m)
      %export_tiled_2D_maps exports all 2D maps together on the same page
      
      % initialize tiled layout
      cf = figure(1);
      set(gca, 'DataAspectRatio', [1 1 1]);
      m.tiled_2D_layout = tiledlayout(cf, 3, 2);
      title(m.tiled_2D_layout, m.scene.name);
      
      
      % Top left tile (Elevation)
      nexttile(m.tiled_2D_layout);
      axis square;
      elev_fig(m);

      % Top right tile (Elevation SD)
      nexttile(m.tiled_2D_layout);
      axis square;
      elev_sd_fig(m);
      % Middle left tile (Average MXVI)
      nexttile(m.tiled_2D_layout);
      axis square;
      avg_mxvi_fig(m);
      % Middle right tile (MXVI SD)
      nexttile(m.tiled_2D_layout);
      axis square;
      mxvi_sd_fig(m);
      % Bottom left tile (Pearson)
      nexttile(m.tiled_2D_layout);
      axis square;
      pearson_fig(m);
      % Bottom right tile (Spearman)
      nexttile(m.tiled_2D_layout);
      axis square;
      spearman_fig(m);
      
      % Export the tiled fig as a jpeg
      cur_path = append(m.scene_2D_save_path, "/AllMapsTiled.pdf");
      print(cur_path, '-dpdf', '-fillpage');
      
    end  % export_tiled_2D_maps

    function export_tiled_3D_maps(m) 
      %export_tiled_3D_maps makes a tiled layout of 3D map figures 
      % All matrices are plotted against elevation
      clf;
      m.tiled_3D_layout = tiledlayout(3,2);
      title(m.tiled_3D_layout, m.scene.name);
      
      zmat = m.scene.elev_mat;
      
      % Surface Plot
      nexttile(m.tiled_3D_layout);
      surf(zmat, 'EdgeColor', 'none', 'FaceColor', 'interp');
      title('Elevation');
      
      % Standard Deviation of Elevation
      nexttile(m.tiled_3D_layout);
      mesh(zmat, flipud(m.scene.elev_sd), 'FaceColor', 'interp');
      title('Elevation');
      subtitle('Standard Deviation');
      
      % MXVI Plot
      nexttile(m.tiled_3D_layout);
      mesh(zmat, flipud(m.scene.mxvi_avg), 'FaceColor', 'interp');
      title('Avg. MXVI');
      
      % Standard Deviation of MXVI 
      nexttile(m.tiled_3D_layout);
      mesh(zmat, flipud(m.scene.mxvi_sd), 'FaceColor', 'interp');
      title('MXVI');
      subtitle('St. Dev Over Time');
      
      % Pearson
      nexttile(m.tiled_3D_layout);
      mesh(zmat, flipud(m.scene.pearson_mat), 'FaceColor', 'interp');
      title('Pearson. Map');
      
      % Spearman Plot
      nexttile(m.tiled_3D_layout);
      mesh(zmat, flipud(m.scene.spearman_mat), 'FaceColor', 'interp');
      title('Spearman Map');
      
      % Specify the figure size in the file name
      l = ( m.scene.height - (m.scene.radius*2) ) / 4;
      w = ( m.scene.width - (m.scene.radius*2) ) / 4;
      
      % Save the figure
      cur_path = append(m.figs3D_save_path, '/', m.scene.name,...
                      num2str(l),'x', num2str(w));
      
      savefig(cur_path);
    end  % export_tiled_3D_maps
      
    
  end  % methods
end  % classdef