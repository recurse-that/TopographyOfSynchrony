# Topography Of Synchrony

Zai Erb, University Of Kansas
Daniel Reuman, University of Kansas

This repository provides tools to analyze the effects of unique topographical
features on the synchrony of vegetation, and also can be used to reproduce the results of $insertTitle

## Explanations
Matlab code reads your kml file and uses the MODIS satellite dataset to construct and analyze the effect of topography--anywhere in the United States--on annual max vegetation and how synchronous vegetation is to the surrounding area. Matlab also generates maps showing Elevation, Standard Deviation of Elevation (compared with the surrounding area), MXVI (annual maximum vegetation), standard deviation of MXVI (compared to all years with available data), and most importantly: Pearson and Spearman correlation of pixels with their surrounding pixels. 2D maps are exported as images, 3D maps are saved and can be interacted with within the matlab figure window. And finally the relevant values found / calculated are exported as csv files to be imported into R.
R scripts perform modified ttests that account for spatial auto correlation.

## How to reproduce the results of the paper
### MATLAB
- Confirm dependencies[#Dependencies] below are met
- Confirm pwd() displays <userpath>/TopographyOfSynchrony/Code/Matlab then run exec.m in Code/Matlab
- You will be prompted to specify desired height, width, and radius of calculation (all in pixels) for your scenes. You must enter 100, 100, 10 when prompted
- The code may take several hours to run
- The code produces presentation quality maps and saves CSV files to be used in the R script that follows
### R
- After running your Matlab code run exec.R in <userpath>/TopographyOfSynchrony/Code/R
- It produces scatter plots, statistical results, and presentation quality synchrony tables for each scene
### PAPER
- Compiling Paper.Rmd and supmat.Rmd will generate the paper 

## Try your own scenes
- Confirm dependencies[#Dependencies] below are met
- To examine your own unique scenes you must replace the "Simple Topographical Features.kml" with a KML file exported from a google earth project
- The project must contain only individual points (NO LINES OR SHAPES)
- Selected points must be within the boundaries of the continental United States
- The KML file you export must replace the sample KML file I included in "<userpath>/TopographyOfSynchrony/Data/Simple Topographical Features.kml" for code to run without any changes
- The name of your points in your Google Earth project will be the name of the scene and all output documents will be labelled according to this name

## Dependencies
### Core dependencies
Matlab License, Matlab R2021b, R, and latex (tinytex preferred)
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

### Dependencies on Matlab add-ons
- [kml2struct](https://www.mathworks.com/matlabcentral/fileexchange/35642-kml2struct)
- [read_kml](https://www.mathworks.com/matlabcentral/fileexchange/13026-read_kml?s_tid=srchtitle)

### Dependencies on R packages
Note that all R package dependencies are installed by package_installer.R
- kableExtra
- knitr
- magick
- webshot
- SpatialPack
We offer no guarantee that these packages won't be updated in some way that makes them incompatible

### Dependencies on MODIS data
[MODIS Dataset](https://kars.ku.edu/media/downloads/Kastens/reuman/)
All of the following must be downloaded in the "Data" directory.
- ancillary_mat
- mxvi_mat

### Dependencies on system
If you are using ubuntu 20.04 you will need to run R_dependencies.sh before the kableExtra package can be used to generate tables
R_dependencies.sh ensures the linux packages necessary to use kableExtra are installed (the linux packages are not installed by default)
Note that R_dependencies.sh requires sudo permissions, if you don't want to use the provided script you can manually install the packages


### Additional Dependencies?
If you find additional dependencies were needed on your system, please let us know: erb.isaiah@ku.edu. The compilation process was tested by Erb on Ubuntu 20.10, using R version 4.0.3 and Rstudio version 1.4.1717. It has not been fully tested on Mac or Windows. This repository is made with the goal of relative ease of use for anyone that wants to examine unique topographic features in the United States. If all listed dependencies are met, minimal compilation errors should occur; however I cannot guarantee everything will work the first time on any machine with any given KML file you may pass in.
