<<<<<<< HEAD
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
- Platform: x86_64-pc-linux-gnu
- OS: linux-gnu
- Matlab version
- R version 3.6.3
- R studio version 1.4.1717

### Dependencies on Matlab toolboxes
- [Antennae Toolbox](https://www.mathworks.com/products/antenna.html)
- [Image Processing Toolbox](https://www.mathworks.com/products/image.html)
- [Mapping Toolbox](https://www.mathworks.com/products/mapping.html)
- [Statistics and Machine Learning Toolbox](https://www.mathworks.com/products/statistics.html)

### Dependencies on matlab add-ons
- [kml2struct](https://www.mathworks.com/matlabcentral/fileexchange/35642-kml2struct)
- [read_kml](https://www.mathworks.com/matlabcentral/fileexchange/13026-read_kml?s_tid=srchtitle)

### Dependencies on R packages
Note that all R package dependencies are installed by package_installer.R
- kableExtra
- knitr
- magick
- webshot
- SpatialPack

### Dependencies on system
If you are using ubuntu 20.04 you will need to run R_dependencies.sh before the kableExtra package can be used to generate tables

### Dependencies on data
[MODIS Dataset](https://kars.ku.edu/media/downloads/Kastens/reuman/)
All of the following must be downloaded in the "Data" directory.
- ancillary_mat
- mxvi_mat

#### Data requirements to view your own unique scenes
A sample "Simple Topographical Features.kml" file is provided in the data folder with the scenes I chose to focus on. If you want to look at your own unique scenes, you'll need to create a Google Earth project on the web, add markers to the project representing the center of your scenes; the names of these markers on the map will be the names of your scenes so make sure to name them appropriately, for example "Gunnison Point" or "Mount St. Helens". Once you have added the focal points of scenes you want to examine to the google earth project export the project as a kml file. Note that the kml file must be saved to the Data directory within the project folder and must be named "Simple Topographical Features.kml"

##### More dependencies on Google Earth kml file
- The project must contain only individual points (NO LINES OR SHAPES)
- Selected points must be within the boundaries of the continental United States.
- The KML file you export must replace the sample KML file I included in "Data/Simple Topographical Features.kml" for code to compile without any changes.
- The name of your points in your Google Earth project will be the name of the scene and all output documents will be labelled according to this name

### Additional Dependencies?
If you find additional dependencies were needed on your system, please let us know: erb.isaiah@ku.edu. he compilation process was tested by Erb on Ubuntu 20.10, Arch Linux Kernel Version 5.10.3, and Windows 10 using R version 4.0.3 and Rstudio version
