classdef DATA < handle
  
  properties (Access = public) 
    year_count
    rows
    cols
    MXVI
    lats
    lons
    watermask
    
    scenes
    scene_count
  end
  
  methods
    function data = DATA(years, r, c, MXVI, lats, lons, watermask)
      data.year_count = years;
      data.rows = r;
      data.cols = c;
      data.MXVI = MXVI;
      data.lats = lats;
      data.lons = lons; 
      data.scenes = tempScene.empty; 
      data.watermask = watermask;
    end  % Constructor
    
    function initScenes(data, names, dims, latlon, radius)
      data.scene_count = length(names);
      for i = 1:data.scene_count
        data.scenes(i) = tempScene(names(i), dims{i},...
                                   latlon{i}, radius,...
                                   data.year_count, data.cols);
        % Initialize the focal pixels of each scene
        setFocalPixels(data.scenes(i), data.lats, data.lons,...
                       data.rows, data.cols);             
      end  % for
    end  % initScenes
    
    function setScenes(data)
      for i = 1:data.scene_count
        % Define the PXIDs of each scene
        setPXID(data.scenes(i), data.cols);
        % Define the lat and lon mats for each scene
        setLatLon(data.scenes(i), data.lats, data.lons);
        % Define the elevation mat for each scene
        setElev(data.scenes(i));
        % Define the MXVIs of the scene
        setMXVI(data.scenes(i), data.MXVI, data.year_count);
        % Calculate the synchrony
        % setSynchrony(data.scenes(i));
        % Define the elevations of the the scene
      end  % outer for 
    end  % setScenes
    
    function pxid = getPXID(row, col)
      pxid = ((row - 1) * c) + col;
    end  % end getPXID
  end  % methods
end  % classdef DATA