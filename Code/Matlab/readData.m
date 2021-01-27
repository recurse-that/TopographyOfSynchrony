cd(dataPath);
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