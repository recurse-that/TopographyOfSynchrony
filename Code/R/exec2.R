# Set working directory to source file location 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Set working directory to projects root directory 
cur_wd = dirname( dirname( getwd() ) )
setwd(cur_wd)

# index each of the scene names 
scene_names <- read.delim("Data//m_scene_names.txt", header = FALSE, sep = ',')

# Define scene count
scene_count = length(scene_names)

# Concatenate the to path with the file names for each scene data file 
CSV_fnames = c()
for ( i in 1:scene_count ) {
  CSV_fnames[i] <- paste('Data//Scene_CSVs//', scene_names[[i]], '.txt', sep = '')
}

# Create results directories for each scene
file_names_out = c()
for ( i in 1:scene_count ) {
  file_names_out[i] <- paste('Data//', scene_names[i], 'results.png', sep = '')
  dir.create(paste("Results/", scene_names[[i]], sep = ""))
}


elev_pearson_P <- c()
elev_pearson_corr <- c()

elev_spearman_P <- c()
elev_spearman_corr <- c()

esd_pearson_P <- c()
esd_pearson_corr <- c()

esd_spearman_P <- c()
esd_spearman_corr <- c()

mxvi_pearson_P <- c()
mxvi_pearson_corr <- c()

mxvi_spearman_P <- c()
mxvi_spearman_corr <- c()

msd_pearson_P <- c()
msd_pearson_corr <- c()

msd_spearman_P <- c()
msd_spearman_corr <- c()


# libary with modified ttest
library('SpatialPack')
# Calculate P and R Values
for ( i in 1:2 ) {
  # create input dataframe
  df_in <- read.csv(CSV_fnames[i])
  names(df_in) <- c("X_coord", "Y_coord", "Elevation", "Elevation_SD", "Avg_MXVI", "MXVI_SD", "Pearson", "Spearman")
  
  # initialize current scene inputn m 
  coords = df_in[,c(1,2)]
  elev = df_in[,3]
  esd = df_in[,4]
  mxvi = df_in[,5]
  msd = df_in[,6]
  pearson = df_in[,7]
  spearman = df_in[,8]
  
  # Pearson vs Elevation
  temp = modified.ttest( elev, pearson, coords )
  elev_pearson_P[i] = temp$p.value
  elev_pearson_corr[i] = temp$corr
  
  temp = modified.ttest( elev, spearman, coords )
  elev_spearman_P[i] = temp$p.value
  elev_spearman_corr[i] = temp$corr
  
  temp = modified.ttest( esd, pearson, coords )
  esd_pearson_P[i] = temp$p.value
  esd_pearson_corr[i] = temp$corr
  
  temp = modified.ttest( esd, spearman, coords )
  esd_spearman_P[i] = temp$p.value
  esd_spearman_corr[i] = temp$corr
  
  temp = modified.ttest( mxvi, pearson, coords )
  mxvi_pearson_P[i] = temp$p.value
  mxvi_pearson_corr[i] = temp$corr
  
  temp = modified.ttest( mxvi, spearman, coords )
  mxvi_spearman_P[i] = temp$p.value
  mxvi_spearman_corr[i] = temp$corr
  
  temp = modified.ttest( msd, pearson, coords )
  msd_pearson_P[i] = temp$p.value
  msd_pearson_corr[i] = temp$corr
  
  temp = modified.ttest( msd, spearman, coords )
  msd_spearman_P[i] = temp$p.value
  msd_spearman_corr[i] = temp$corr
  
} # end for
