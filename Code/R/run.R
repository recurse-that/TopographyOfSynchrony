# Package for modified.ttest
install.packages("SpatialPack")
# Package for easy formatted table images
install.packages("kableExtra")
install.packages("htmltools")
install.packages("magick")
install.packages("ztable")

# Package for %>% function
insstall.packages("magittr")
library("magrittr")

# set directory 
setwd("G:/Documents/TopographyOfSynchrony")

# index each of the scene names 
scene_names <- read.delim("Data//m_scene_names.txt", header = FALSE, sep = ',')

# Concatenate the to path with the file names for each scene data file 
file_names = c()
for ( i in 1:10 ) {
  file_names[i] <- paste('Data//Scene_CSVs//', scene_names[i], '.txt', sep = '')
}

# Filename to be exported to
file_names_out = c()
for ( i in 1:10 ) {
  file_names_out[i] <- paste('Data//', scene_names[i], 'results.png', sep = '')
}

## 
m_scene_count = 10
a <- matrix(NA, 4, 4)
rownames(a) <- c("Elevation", "Elevation StD", "MXVI", "MXVI StD")
scenes_out <-  rep(list(a), m_scene_count)

# libary with modified ttest
library('SpatialPack')

# Calculate P and R Values
for ( i in 1:10 ) {
  # create input dataframe
  df_in <- read.csv(file_names[i])
  names(df_in) <- c("X_coord", "Y_coord", "Elevation", "Elevation_SD", "Avg_MXVI", "MXVI_SD", "Pearson", "Spearman")
  
  # initialize current scene input
  coords = df_in[,c(1,2)]
  elev = df_in[,3]
  esd = df_in[,4]
  mxvi = df_in[,5]
  msd = df_in[,6]
  pearson = df_in[,7]
  spearman = df_in[,8]
  
  # Pearson vs Elevation
  temp = modified.ttest( elev, pearson, coords )
  scenes_out[[ i ]][1,1] = temp$p.value
  scenes_out[[ i ]][1,2] = temp$corr
  
  # Spearman vs Elevation 
  temp = modified.ttest( elev, spearman, coords )
  scenes_out[[ i ]][1,3] = temp$p.value
  scenes_out[[ i ]][1,4] = temp$corr
  
  # Pearson vs Elevation SD
  temp = modified.ttest( esd, pearson, coords )
  scenes_out[[ i ]][2,1] = temp$p.value
  scenes_out[[ i ]][2,2] = temp$corr
  
  # Spearman vs Elevation SD
  temp = modified.ttest( esd, spearman, coords )
  scenes_out[[ i ]][2,3] = temp$p.value
  scenes_out[[ i ]][2,4] = temp$corr
  
  # Pearson vs MXVI 
  temp = modified.ttest( mxvi, pearson, coords )
  scenes_out[[ i ]][3,1] = temp$p.value
  scenes_out[[ i ]][3,2] = temp$corr
  
  # Spearman vs MXVI 
  temp = modified.ttest( mxvi, spearman, coords )
  scenes_out[[ i ]][3,3] = temp$p.value
  scenes_out[[ i ]][3,4] = temp$corr
  
  # Pearson vs MXVI SD
  temp = modified.ttest( msd, pearson, coords )
  scenes_out[[ i ]][4,1] = temp$p.value
  scenes_out[[ i ]][4,2] = temp$corr
  
  # Spearman vs MXVI SD
  temp = modified.ttest( msd, spearman, coords )
  scenes_out[[ i ]][4,3] = temp$p.value
  scenes_out[[ i ]][4,4] = temp$corr
  
} # end for



# Set libraries to make tables
library("htmlTable")
library("ztable")


# make a lists for the ztables
ztable_list <- vector(mode = "list", length = 10)

# Set options so the htmlTables appear in the viewer
options(ztable.type="viewer")

cur_scene <- (scenes_out[[i]])

cur_df <- data.frame(cur_scene)
names(cur_df) <- c('PVal', 'RVal', 'PVal', 'RVal')
row.names(cur_df) <- c("Elevation", "Elevation Std", "MXVI", "MXVI Std")

t <- rbind(scenes_out[[1]], scenes_out[[2]], scenes_out[[3]], scenes_out[[4]],
          scenes_out[[5]], scenes_out[[6]], scenes_out[[7]], scenes_out[[8]],
          scenes_out[[9]], scenes_out[[10]])

colnames(t) <- c('PVal1', 'RVal1', 'PVal2', 'RVal2')

rgroup = c(scene_names[1], scene_names[2], scene_names[3],
           scene_names[4], scene_names[5], scene_names[6],
           scene_names[7], scene_names[8], scene_names[9],
           scene_names[10])
n.rgroup = c(4,4,4,4,4,4,4,4,4,4)

cgroup = c("Pearson","Spearman")
n.cgroup=c(2,2)

setwd("G:/Documents/TopographyOfSynchrony/Results")
pdf(file = "G:/Documents/TopographyOfSynchrony/Results/RandP_vals.pdf")

z <- ztable(t, align="ccccccc") %>%
  addCellColor(condition = PVal1 <= 0.05, cols = PVal1, bg="pinegreen", color = "white") %>%
  addCellColor(condition = PVal2 <= 0.05, cols = PVal2, bg="pinegreen", color = "white") %>%
  addCellColor(condition = RVal1 >= 0.00, cols = RVal1, bg="blue", color = "white") %>%
  addCellColor(condition = RVal1 < 0.00 , cols = RVal1, bg="red", color = "white") %>%
  addCellColor(condition = RVal2 >= 0.00 , cols = RVal2, bg="blue", color = "white") %>%
  addCellColor(condition = RVal2 < 0.00 , cols = RVal2, bg="red", color = "white") %>%
  addCellColor(condition = PVal1 >= 0.05 , cols = RVal1, bg="white", color = "black") %>%
  addCellColor(condition = PVal2 >= 0.05 , cols = RVal2, bg="white", color = "black") %>%
  addrgroup(rgroup=rgroup,n.rgroup=n.rgroup,cspan.rgroup=1, bg = "gray") %>%
  addcgroup(cgroup=cgroup,n.cgroup=n.cgroup) %>%
  vlines(z,type=1)
z

