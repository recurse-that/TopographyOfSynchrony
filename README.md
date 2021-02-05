# Topography Of Synchrony

Zai Erb, University Of Kansas
Daniel Reuman, University of Kansas

This repository provides tools to analyze the effects of unique topographical
features on the synchrony of vegetation

## Explanations
Matlab code reads your kml file and uses the MODIS satellite dataset to construct and analyze the effect of topography--anywhere in the United States--on annual max vegetation and how synchronous vegetation is to the surrounding area. Matlab also generates maps showing Elevation, Standard Deviation of Elevation (compared with the surrounding area), MXVI (annual maximum vegetation), standard deviation of MXVI (compared to all years with available data), and most importantly: Pearson and Spearman correlation of pixels with their surrounding pixels. 2D maps are exported as images, 3D maps are saved and can be interacted with within the matlab figure window. And finally the relevant values found / calculated are exported as csv files to be imported into R.
R Code performs modified ttest that account for spatial auto correlation



## Compile
### MATLAB
- Navigate to Code/Matlab and run exec.mlx
- You will be prompted to specify desired height, width, and radius of calculation for your scenes, I recommend starting with dimensions such as 50, 50, with a radius of ~5 and scale up from there depending on how powerful your machine is
### R
- After compiling your Matlab code




## Dependencies
### Core dependencies
Matlab License, Matlab R2020b, R, and latex

### Matlab Toolbox dependencies
Mapping Toolbox and Antennae Toolbox are required to run matlab code

### MODIS Dataset is required to compile matlab code
{r} [MODIS Dataset] (https://kars.ku.edu/media/downloads/Kastens/reuman/)

### Data requirements to view your own unique scenes
A sample "Simple Topographical Features.kml" file is provided in the data folder with the scenes I chose to focus on. If you want to look at your own unique scenes, you'll need to create a Google Earth project on the web, add markers to the project representing the center of your scenes; the names of these markers on the map will be the names of your scenes so make sure to name them appropriately, for example "Gunnison Point" or "Mount St. Helens". Once you have added the focal points of scenes you want to examine to the google earth project export the project as a kml file. Note that the kml file must be saved to the Data directory within the project folder and must be named "Simple Topographical Features.kml"

## Matlab
###

## Files
### +---Code
####  |   +---Matlab
##### |   |       READ.m
###### | | | @PRE: 'Data/ancillary_mat', 'Data/mxvi_mat', and 'Data/Simple Topographical Features.kml'
###### | | | @PARAMS: paths to data folder and 'Code/Matlab' folder
###### | | | @RUN: you are asked to input your custom scene dimensions (in pixels),
###### | | | @     your custom kml file data is read in and stored,
###### | | | @     MODIS datasets are read in and stored in a DATA object
###### | | | @POST: DATA object constructed containing all initialized SCENE objects
###### | | | @      and all relevant MODIS data and the focal pixel IDs for each

##### |   |       DATA.m
###### | | | @PRE: Initialized by READ class
###### | | | @PARAMS: Scene focal latlons from your kml file and MODIS datasets
###### | | | @RUN: Calls scene constructor and defines values of each scene
###### | | | @POST: All scene data, figures, and input are saved to proper folders

##### |   |       SCENE.m
###### | | | @PRE: Initialized within DATA class
###### | | | @PARAMS: Scene focal latlons and names from your kml file
###### | | | @        dimensions and radius provided by you during runtime.
###### | | | @RUN: Initializes scene with a name, dimensions, and a focal latlon coordinate
###### | | | @FUNCTIONS: Functions set each matrix for the scene including PXID, Elevation, MXVI, and calculate standard deviation of elevation and MXVI and calculate Pearson and Spearman correlation of each pixel in the scene
###### | | | @POST: DATA object contains fully defined scene objects for every scene

##### |   |       MAP.m
###### | | | @PRE: Represents a scene
###### | | | @PARAMS: fully defined scene object
###### | | | @RUN: Defines figures for each map and stores them as properties
###### | | | @FUNCTIONS: Export 2D and 3D figures to data folder
###### | | | @POST: a flexible and easily accessible map making and exporting object is defined for given scene

#### |   \---R
##### |           run.R
##### |           scatter_plotter.R

### Data
MODIS Satellite data set must be used for code to run smoothly. If using another
similar dataset some code will need to be modified.

### Google Earth KML File
- Must contain only individual points (NO LINES OR SHAPES)
- The name of your points in your Google Earth project will be the name of the scene and all output documents will be labelled according to this name

### Matlab
- Mapping toolbox and Antenna toolbox must be installed
- Run 'Code/Matlab/Dependencies.mlx' to enable addons and toolboxes
#### COMPILE
1. Setup Directories
  - In the parent directory
    - Make directory "Data"
    - Download MODIS Data in Data (LINK)
      - ancillary_mat
      - ancillary_tif
      - mxvi_mat
    - Confirm Working tree
  - Download your google earth project as a kml file with named markers at the
    center of each scene


2. Matlab -- Extract desired scenes and perform synchrony calculations
  - Execute run_mat.mlx from root directory in the matlab editor
    - See DEPENDENCIES for matlab
  - To create figures or export map images run .mlx files prepended with 'export'

3. R -- Analyze Results of synchrony calculations

## MORE DEPENDENCIES

- Must have matlab license

## INTERMEDIATE FILES


## PAPER  ##
- Extracting 2D maps for scenes
  - In matlab command window from the 'Code/Matlab/' folder call the following
