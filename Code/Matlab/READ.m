classdef READ < handle
  
  properties (Access = public)
    cur_path  % path to base directory
    code_path % path to code folder
    data_path % path to data folder
    workspace_vars_path  % path to folder where variables created during 
                         % runtime are stored
    pxh  % user input height for scenes
    pxw  % user input width for scenes
    rad  % user input radius for scene calculations
    allData  % object of type data
    
  end  % properties
  
  methods
    function r = READ(path, path_to_code, path_to_data)
      r.cur_path = path;
      r.code_path = path_to_code;
      r.data_path = path_to_data;
      r.workspace_vars_path = append(path_to_code, "workspaceVariables");
    
      cd(r.code_path);
      if ~exist(r.workspace_vars_path, 'dir')
        mkdir( r.workspace_vars_path );
      end
      setSceneSizes(r);
      setSceneValuesFromKML(r);
      % initialize DATA object from the read in MODIS data
      r.allData = readData(r, path_to_code);
    end  % constructor
    
    function setSceneSizes(r)
      % DEFAULT SCENE HEIGHT 
      prompt = "What is the desired scene height? (in pixels) ";
      r.pxh = input(prompt);
      % DEFAULT SCENE WIDTH
      prompt = "What is the desired scene width? (in pixels) ";
      r.pxw = input(prompt);
      % DEFAULT RADIUS FOR CALCULATION SYNCHRONY
      prompt = "Within what radius around each pixel would you like calculations to consider ";
      r.rad = input(prompt);
    end  % setSceneSizes
    
    function setSceneValuesFromKML(r)
      cd(r.data_path);
      % Set the path to read the kml file imported from google earth
      kml_file = append('Simple Topographical Features.kml');
      %% Read the kml file and save info 
      kml_struct = kml2struct(kml_file); 
      %% Cell arry to access values
      kml_cell = struct2cell(kml_struct);
      %% Table for viewing values
      kml_table = struct2table(kml_struct);

      % Initialize member variables
      m_scene_count = length(kml_struct);
      m_scene_names = string.empty;
      m_scene_latlons = cell(1,m_scene_count);
      m_scene_dims = cell(1,m_scene_count);


      % Add values for member variables
      for scene_i = 1:m_scene_count
          m_scene_names(scene_i) = kml_cell{2, scene_i};
          lon = kml_cell{4,scene_i};
          lat = kml_cell{5,scene_i};
          m_scene_latlons{scene_i} = [lat, lon];
          m_scene_dims{scene_i} = [r.pxh, r.pxw];
      end

      % Save the workspace variables needed to create scenes
      cd(r.code_path);
      % Save the scene count
      save( append(r.workspace_vars_path, '/scene_count.mat'), "m_scene_count" );
      % Save the scene names
      save( append(r.workspace_vars_path, '/scene_names.mat'), "m_scene_names" );
      % Save the scene latlons
      save( append(r.workspace_vars_path, '/scene_latlons.mat'), "m_scene_latlons");

      % Clear variables from workspace
      clearvars -regexp kml_ -except kml_table;
      clearvars scene_i lat lon prompt;
    end  % setSceneValuesFromKML;
    
    function data_obj = readData(r, path)
      cd(r.data_path);
      % load ancillary data
      addpath("ancillary_mat/.");

      % load the lats and lons
      load('modis_qkm_pixel_latlon.mat');
      load('modis_qkm_water_mask.mat', 'water1_land0');
      % add mxvi path 
      addpath("mxvi_mat/.");
      cd("mxvi_mat");

      m_year_count = 18;
      mxvi_vals = cell(18, 1);

      for year = 2002:2019
         if year == 2002
             load("Data/mxvi_mat/mxvi_2002.mat");
         elseif year == 2003
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2003.mat");
         elseif year == 2004
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2004.mat");
         elseif year == 2005
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2005.mat");
         elseif year == 2006
             clearvars mxvi; 
             load("Data/mxvi_mat/mxvi_2006.mat");
         elseif year == 2007               
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2007.mat");
         elseif year == 2008               
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2008.mat");
         elseif year == 2009
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2009.mat");
         elseif year == 2010
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2010.mat");
         elseif year == 2011
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2011.mat");
         elseif year == 2012
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2012.mat");
         elseif year == 2013
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2013.mat");
         elseif year == 2014
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2014.mat"); 
         elseif year == 2015
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2015.mat");
         elseif year == 2016
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2016.mat"); 
         elseif year == 2017
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2017.mat");
         elseif year == 2018
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2018.mat");
         elseif year == 2019
             clearvars mxvi;
             load("Data/mxvi_mat/mxvi_2019.mat");
         end  % elseif block
         mxvi_vals{year - 2001} = mxvi;

      end  % for year = 1:year_count
      clearvars year mxvi pxsz;
      clearvars -regexp cur_ temp_ ul;
      
      cd(path);
      % initialize data object
      data_obj = DATA(m_year_count, r, c,...
                        mxvi_vals, modis_qkm_pixel_lat,...
                        modis_qkm_pixel_lon, water1_land0);
      % initialize the scenes held by the data object
      initScenes(data_obj, m_scene_names, m_scene_dims,...
                 m_scene_latlons, r.rad);
    end  % readData
    
  end  % methods
  
end  % classdef
    
    
      
    
    