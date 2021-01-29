# Topography Of Synchrony

Zai Erb, University Of Kansas
Daniel Reuman, University of Kansas

This repository provides tools to analyze the effects of unique topographical
features on the synchrony of vegetation

## Explanations
Matlab code is responsible for generating scene files to be exported for statistical analyses in R
R Code performs modified ttest that account for spatial auto correlation 



## Compile
### MATLAB
- Navigate to Code/Matlab and run exec.mlx
- You will be prompted to specify desired height, width, and radius of calculation for your scenes
#### NOTE: I reccomend you start with dimensions such as 50, 50, with a radius of ~5 and scale up from there depending on how powerful your machine is
### R 
- After compiling your matlab code 




## Dependencies
### Core dependencies 
Matlab License, Matlab R2020b, R, and latex

### Matlab Toolbox dependencies
Mapping Toolbox and Antennae Toolbox are required to run matlab code

### MODIS Dataset is required to compile matlab code
{r} [MODIS Dataset] (https://kars.ku.edu/media/downloads/Kastens/reuman/)

### Data requirements to view your own unique scenes
A sample "Simple Topographical Features.kml" file is provided in the data folder with the scenes I chose to focus on. If you want to look at your own unique scenes, you'll need to create a google earth project on the web then add markers to your project where you want the center of each of your scenes to be (name the points appropriately). Once you have a completed google earth project export it as a kml to the Data directory and replace the file "Simple Topographical Features.kml" with your new kml.

The

## Matlab 
### 

## Files
### +---Code
#### |   +---Matlab
##### |   |       DATA.m
###### ||| @PRE: Called as a class object with data from MODIS .mat files as arguments
###### @PARAMS: Provided by MODIS datasets, a google earth kml file, and a user inputted radius
###### @RUN: Calls scene constructor and defines values of each scene
###### @POST: All scene data, figures, and input are saved to proper folders

##### |   |       SCENE.m
##### |   |       setSceneSizes.m
###### @RUN: Allows the user to define the desired height, width, and radius (for calculations)
##### |   |       setSceneValuesFromKML.m
###### @PRE: KML file downloaded from google earth project must be in the Data directory (see dependencies)
###### @RUN: Defines names and latlon coordinates to be passesd to the scene class constructor
##### |   |       readData.m
###### @RUN: Defines yearly MXVI values and loads ancillary mat data 



#### |   \---R
##### |           run.R
##### |           scatter_plotter.R

### Data
MODIS Satellite data set must be used for code to run smoothly. If using another
similar dataset some code will need to be modified.

### Google Earth KML File
Must contain only individual points that are named according to the indicated
scene

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