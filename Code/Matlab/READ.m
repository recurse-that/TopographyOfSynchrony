  classdef READ < handle
  
    properties (Access = public)
      cur_path  % path to base directory
      code_path % path to code folder
      data_path % path to data folder
      workspace_vars_path  % path to folder where variables created during 
                           % runtime are stored
      scene_count
      scene_names
      pxh  % user input height for scenes
      pxw  % user input width for scenes
      dims % cell array holding pxh and pxw for each scene
      rad  % user input radius for scene calculations
      latlons % focal latlons for each scene
      allData  % object of type data
    end  % properties
    
    methods
      function read = READ(path, path_to_code, path_to_data)
        %READ reads in user data and modis data
        % Initializes an object of type data usin  
        read.cur_path = path;
        read.code_path = path_to_code;
        read.data_path = path_to_data;
        read.workspace_vars_path = append(path_to_code, "workspaceVariables");
        
        % confirm we're in the correct directory
        cd(read.code_path);
        if ~exist(read.workspace_vars_path, 'dir')
          mkdir( read.workspace_vars_path );
        end
        setSceneSizes(read);
        setSceneValuesFromKML(read);
        % initialize DATA object from the read in MODIS data
        readData(read, read.latlons, read.dims, read.code_path);
      end  % constructor
        
      function setSceneSizes(read)
        % DEFAULT SCENE HEIGHT 
        prompt = "What is the desired scene height? (in pixels) ";
        read.pxh = input(prompt);
        % DEFAULT SCENE WIDTH
        prompt = "What is the desired scene width? (in pixels) ";
        read.pxw = input(prompt);
        % DEFAULT RADIUS FOR CALCULATION SYNCHRONY
        prompt = "Within what radius around each pixel would you like calculations to consider ";
        read.rad = input(prompt);
      end  % setSceneSizes
      
      function setSceneValuesFromKML(read)
        cd(read.data_path);
        % Set the path to read the kml file imported from google earth
        kml_file = append('Simple Topographical Features.kml');
        % Read the kml file and save info 
        kml_struct = kml2struct(kml_file); 
        % Cell arry to access values
        kml_cell = struct2cell(kml_struct);
        
        % Initialize member variables
        read.scene_count = length(kml_struct);
        read.scene_names = string.empty;
        read.latlons = cell(1,read.scene_count);
        read.dims = cell(1,read.scene_count);
        % Add values for member variables
        for scene_i = 1:read.scene_count
            read.scene_names(scene_i) = kml_cell{2, scene_i};
            lon = kml_cell{4,scene_i};
            lat = kml_cell{5,scene_i};
            read.latlons{scene_i} = [lat, lon];
            read.dims{scene_i} = [read.pxh, read.pxw];
        end  % for
        
        cd(read.code_path);
      end  % setSceneValuesFromKML
      
      function readData(read, scene_latlons, scene_dims, path)
        cd(read.data_path);
        % load ancillary data
        addpath("ancillary_mat/.");

        % load the lats and lons
        load('modis_qkm_pixel_latlon.mat');
        watermask = load('modis_qkm_water_mask_v2.mat', 'water1_land0_v2');
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
        read.allData = DATA(m_year_count, r, c,...
                          mxvi_vals, modis_qkm_pixel_lat,...
                          modis_qkm_pixel_lon, watermask);
        % set the paths for the data
        setPaths(read.allData, read.cur_path,...
                 read.code_path, read.data_path);
        % initialize the scenes held by the data object
        initScenes(read.allData, read.scene_names, scene_dims,...
                   scene_latlons, read.rad);
                 
                 
      end  % readData
       
    end  % methods
    
  end  % classdef