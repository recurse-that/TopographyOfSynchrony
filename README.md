# Topography Of Synchrony

Zai Erb, University Of Kansas
Daniel Reuman, University of Kansas

This repository provides tools to analyze the effects of unique topographical
features on the synchrony of vegetation

## Explanations
Matlab code is responsible for generating scene files to be exported for statistical analyses in R
R Code performs modified ttest that account for spatial auto correlation 

## Files
### +---Code
#### |   +---Matlab
##### |   |       DATA.m
PRE: Called as a class object with data from MODIS .mat files as arguments
PARAMS: Provided by MODIS datasets, a google earth kml file, and a user inputted radius
RUN: Calls scene constructor and defines values of each scene
POST: All scene data, figures, and input are saved to proper folders
#### |   \---R
##### |           run.R
##### |           scatter_plotter.R

## Compile
MATLAB
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


## Dependencies

### Data
MODIS Satellite data set must be used for code to run smoothly. If using another
similar dataset some code will need to be modified.

### Google Earth KML File
Must contain only individual points that are named according to the indicated
scene

### Matlab
- Mapping toolbox and Antenna toolbox must be installed
- Run 'Code/Matlab/Dependencies.mlx' to enable addons and toolboxes


## MORE DEPENDENCIES

- Must have matlab license

## INTERMEDIATE FILES


## PAPER  ##
- Extracting 2D maps for scenes
  - In matlab command window from the 'Code/Matlab/' folder call the following