classdef DATA < handle
  
  properties (Access = public) 
    year_count
    rows  % of overall MODIS Data
    cols  % ||
    MXVI  % all MODIS values
    lats  % ||
    lons  % ||
    watermask % ||
    
    path  % path to base project directory
    code_path % path to matlab code directory
    data_path  % path to data directory
    results_path % path to data directory
    
    scenes  % scene objects for each scene
    maps    % map objects for each scene
    scene_count
  end  % properties
  
  methods
    function data = DATA(years, r, c, MXVI, lats, lons, watermask)
      data.year_count = years;
      data.rows = r;
      data.cols = c;
      data.MXVI = MXVI;
      data.lats = lats;
      data.lons = lons; 
      data.scenes = SCENE.empty; 
      data.watermask = watermask;
      data.maps = MAP.empty;
    end  % Constructor
    
    function setPaths(data, project_path, path_to_code, path_to_data, path_to_results)
      data.path = project_path;
      data.code_path = path_to_code;
      data.data_path = path_to_data;
      data.results_path = path_to_results;
    end  % setPaths
    
    function initScenes(data, names, dims, latlon, radius)
      data.scene_count = length(names);
      for i = 1:data.scene_count
        data.scenes(i) = SCENE(names(i), dims{i},...
                                   latlon{i}, radius,...
                                   data.year_count, data.cols);
        % Initialize the focal pixels of each scene
        setFocalPixels(data.scenes(i), data.lats, data.lons,...
                       data.rows, data.cols);             
      end  % for
    end  % initScenes
    
    function setScenes(data)
    %setScenes defines all properties of all scenes
    % defines focal PXID matrix
    % defines LatLon matrix
    % defines elevation and elevation std matrices
    % defines MXVI and MXVI std matrices
    % defines Pearson and Spearman matrices
    % normalizes all the matrices to the same size
      for i = 1:data.scene_count
        % Define the PXIDs of each scene
        setPXID(data.scenes(i), data.cols, data.watermask);
        % Define the lat and lon mats for each scene
        setLatLon(data.scenes(i), data.lats, data.lons);
        % Define the elevation mat for each scene
        setElev(data.scenes(i));
        % Define the MXVIs of the scene
        setMXVI(data.scenes(i), data.MXVI, data.year_count);
        % Calculate the synchrony
        setSynchrony(data.scenes(i));
        % Normalize the scene to equal dimensions
        normalizeMatrices(data.scenes(i));
        % Initialize map class for each scene
        setMap(data.scenes(i), data.results_path, data.code_path);
      end  % outer for 
    end  % setScenes
    
    function exportSceneData(data)
      %setSceneMaps calls setMap for each SCENE object
      % Generates 2D and 3D map figures and exports important results
            
      % Export scene names file for R
      scene_names = string.empty;
      scene_types = string.empty;
    
      for i = 1:data.scene_count
        scene_names(i) = data.scenes(i).name;
        mt = contains(scene_names(i), ("Mt" | "mt" | "Mount" | "mount" | "Mountain" | "mountain"));
        can = contains(scene_names(i), ("Canyon" | "canyon" | "Point" | "point"));
        val = contains(scene_names(i), ("Valley" | "valley"));
        mesa = contains(scene_names(i), ("Mesa" | "mesa" | "Plateau" | "plateau"));
        if (mt)
            scene_types(i) = "Mountain";
        elseif(can)
            scene_types(i) = "Canyon";
        elseif(val)
            scene_types(i) = "Valley";
        elseif(mesa)
            scene_types(i) = "Mesa";
        else 
            scene_types(i) = "Other";
        end % if
        exportResults(data.scenes(i), data.data_path);
      end  % for
      % Export scene names to text file
      cur = append(data.data_path, '/scene_names.txt');
      writematrix(scene_names, cur);
      % Export scene types to text file
      cur = append(data.data_path, 'scene_types.txt');
      writematrix(scene_types, cur);
      
    end  % exportSceneData
     
    function pxid = getPXID(row, col)
      pxid = ((row - 1) * c) + col;
    end  % end getPXID
    
  end  % methods
end  % classdef DATA