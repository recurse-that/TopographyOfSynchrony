# Topography Of Synchrony

Zai Erb, University Of Kansas
Daniel Reuman, University of Kansas

This repository provides tools to analyze the effects of unique topographical
features on the synchrony of vegetation

## Explanations
Matlab code reads your kml file and uses the MODIS satellite dataset to construct and analyze the effect of topography--anywhere in the United States--on annual max vegetation and how synchronous vegetation is to the surrounding area. Matlab also generates maps showing Elevation, Standard Deviation of Elevation (compared with the surrounding area), MXVI (annual maximum vegetation), standard deviation of MXVI (compared to all years with available data), and most importantly: Pearson and Spearman correlation of pixels with their surrounding pixels. 2D maps are exported as images, 3D maps are saved and can be interacted with within the matlab figure window. And finally the relevant values found / calculated are exported as csv files to be imported into R.
R Code performs modified ttests that account for spatial auto correlation

## Before compiling
- To examine your own unique scenes you must replace the "Simple Topographical Features.kml" with a KML file exported from a google earth project. (See the  [dependencies](#data-requirements-to-view-your-own-unique-scenes) section for more info on how to create a KML with your very own scenes) 
- Confirm futher dependencies[#dependencies] 

## How to compile
### MATLAB
- run exec.mlx in Code/Matlab, making sure your current  folder is the base directory when you run.
- You will be prompted to specify desired height, width, and radius of calculation (all in pixels) for your scenes. I recommend starting with 100 by 100 with radius = 10.
### R
- After compiling your Matlab code run exec.R in Code/R


## Dependencies
### Core dependencies
Matlab License, Matlab R2020b, R, and latex (tinytex preferred)

### Dependencies on Matlab
#### Dependencies on mathworks license and toolboxes
- Valid matlab license
- Mapping Toolbox 
- Antennae Toolbox
- Statistics and machine learning toolbox
- Image processing toolbox (to save maps)
#### Dependencies on add-ons
- kml2struct function


### Dependencies on data
{r} [MODIS Dataset] (https://kars.ku.edu/media/downloads/Kastens/reuman/)
All of the following must be downloaded in the "Data" directory.
- ancillary_mat
- ancillary_tif
- mxvi_mat

#### Data requirements to view your own unique scenes
A sample "Simple Topographical Features.kml" file is provided in the data folder with the scenes I chose to focus on. If you want to look at your own unique scenes, you'll need to create a Google Earth project on the web, add markers to the project representing the center of your scenes; the names of these markers on the map will be the names of your scenes so make sure to name them appropriately, for example "Gunnison Point" or "Mount St. Helens". Once you have added the focal points of scenes you want to examine to the google earth project export the project as a kml file. Note that the kml file must be saved to the Data directory within the project folder and must be named "Simple Topographical Features.kml"

##### More dependencies on Google Earth kml file
- The project must contain only individual points (NO LINES OR SHAPES)
- Selected points must be within the boundaries of the continental United States.
- The KML file you export must replace the sample KML file I included in "Data/Simple Topographical Features.kml" for code to compile without any changes. 
- The name of your points in your Google Earth project will be the name of the scene and all output documents will be labelled according to this name

### Additional Dependencies? 
If you find additional dependencies were needed on your system, please let us know: erb.isaiah@ku.edu. he compilation process was tested by Erb on Ubuntu 20.10, Arch Linux Kernel Version 5.10.3, and Windows 10 using R version 4.0.3 and Rstudio version ___. It has not been fully tested on Mac. This repository is made with the goal of relative ease of use for anyone that wants to examine unique topographic features in the United States. If all listed dependencies are met, minimal compilation errors should occur; however I cannot guarantee everything will work the first time on any machine with any given KML file you may pass in. The workflow of the repository is shown below and comments in the code should help to resolve any minor issues. 


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


## PAPER  ##
- Extracting 2D maps for scenes
  - In matlab command window from the 'Code/Matlab/' folder call the following
