install.packages("kableExtra", dependencies = TRUE)
install.packages("magick")

# Set working directory to source file location 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Set working directory to projects root directory 
cur_wd = dirname( dirname( getwd() ) )
setwd(cur_wd)

# index each of the scene names 
temp_scene_names <- read.csv("Data//m_scene_names.txt", header = FALSE, sep = ',')
temp_scene_types <- read.csv("Data//m_scene_types.txt", header = FALSE, sep = ',')

# Define scene count
scene_count = length(temp_scene_names)

# Concatenate the to path with the file names for each scene data file 
file_names_in = c()
file_names_out = c()
scene_names = c()
scene_types = c()

# Grab all the scene names to find the files
for ( i in 1:scene_count ) {
  # initiate placeholder for CSV input files
  file_names_in[i] <- paste('Data//Scene_CSVs//', temp_scene_names[[i]], '.txt', sep = '')
  # Create results directories for each scene
  file_names_out[i] <- paste('Data//', temp_scene_names[[i]], 'results.png', sep = '')
  dir.create(paste("Results/", temp_scene_names[[i]], sep = ""))
  # Extract the scene names into character vectors
  scene_names[i] <- as.character(temp_scene_names[[i]])
  scene_types[i] <- as.character(temp_scene_types[[i]])
}

# Remove initial scene indexing arrays
rm(temp_scene_names, temp_scene_types)

# Create placeholders for the results that will be calculated
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


# library with modified ttest
library('SpatialPack')
# Calculate P and R Values
for ( i in 1:scene_count ) {
  # create input dataframe
  df_in <- read.csv(file_names_in[i])
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

code_path = paste(cur_wd, "Code",'R', sep='/')
data_path = paste(cur_wd, "Data", sep='/')
results_path = paste(cur_wd, "Results", sep='/')
save_path = paste(data_path, "stats.txt", sep='/')

# Combine the results for pearson and spearman calculations
pearson_results = cbind(elev_pearson_P, elev_pearson_corr, 
                        esd_pearson_P, esd_pearson_corr, 
                        mxvi_pearson_P, mxvi_pearson_corr, 
                        msd_pearson_P, msd_pearson_corr)

spearman_results = cbind(elev_spearman_P, elev_spearman_corr, 
                        esd_spearman_P, esd_spearman_corr, 
                        mxvi_spearman_P, mxvi_spearman_corr, 
                        msd_spearman_P, msd_spearman_corr)


results <- data.frame(id <- 1:scene_count,
                      names <- scene_names,
                      types <- scene_types)
colnames(results) <- c("id", "scene", "type")

pearson_results <- cbind(results, pearson_results)
spearman_results <- cbind(results, spearman_results)


source(paste(code_path,"kable_maker.R",sep="/"))
library(kableExtra)
library(magick)

for (i in 1:scene_count) {
  kable_maker(i, scene_names, pearson_results, spearman_results)
}

for (i in 1:scene_count) {
  # Create and save tables for each of the scenes
  html_tbl_fname = paste(results_path,scene_names[scene_index],"html_tbl.html")
  table_png = paste(results_path,scene_names[scene_index],"tbl.png",sep='/')
  
  P_p_vals <- c(pearson_results$elev_pearson_P[scene_index],
                pearson_results$esd_pearson_P[scene_index],
                pearson_results$mxvi_pearson_P[scene_index],
                pearson_results$msd_pearson_P[scene_index])
  P_p_vals <- round(P_p_vals, digits = 4)
  
  P_corr_vals <- c(pearson_results$elev_pearson_corr[scene_index],
                   pearson_results$esd_pearson_corr[scene_index],
                   pearson_results$mxvi_pearson_corr[scene_index],
                   pearson_results$msd_pearson_corr[scene_index])
  P_corr_vals <- round(P_corr_vals, digits = 4)
  
  S_p_vals <- c(spearman_results$elev_spearman_P[scene_index],
                spearman_results$esd_spearman_P[scene_index],
                spearman_results$mxvi_spearman_P[scene_index],
                spearman_results$msd_spearman_P[scene_index])
  S_p_vals <- round(S_p_vals, digits = 4)
  
  S_corr_vals <- c(spearman_results$elev_spearman_corr[scene_index],
                   spearman_results$esd_spearman_corr[scene_index],
                   spearman_results$mxvi_spearman_corr[scene_index],
                   spearman_results$msd_spearman_corr[scene_index])
  S_corr_vals <- round(S_corr_vals, digits = 4)
  
  df <- data.frame(PP <- P_p_vals,
                   PR <- P_corr_vals,
                   SP <- S_p_vals,
                   SR <- S_corr_vals)
  
  rownames(df) <- c("Elevation", "Elevation SD", "MXVI", "MXVI SD")
  colnames(df) <- c('P', 'R', 'P', 'R')
  
  
  kbl(df)
  
  # < 0.05 p vals
  
  
  df %>%
    kbl(caption = scene_names[scene_index], booktabs = T) %>%
    kable_paper("striped", full_width = F) %>%
    kable_classic(full_width = F) %>%
    add_header_above(c(" " = 1, "Pearson" = 2, "Spearman" = 2)) %>%
    column_spec(1, color = "black", background="#bfbfbf") %>%
    column_spec(2, color = ifelse(P_p_vals[1:4] < 0.05, "white", "black"),
                background = ifelse(P_p_vals[1:4] < 0.05, "blue", "white")) %>%
    column_spec(3, color = ifelse(P_p_vals < 0.05, "white", "black"),
                background = ifelse(P_p_vals < 0.05, ifelse(P_corr_vals<0, "red", "blue"), "white")) %>%
    column_spec(4, color = ifelse(S_p_vals[1:4] < 0.05, "white", "black"),
                background = ifelse(S_p_vals[1:4] < 0.05, "blue", "white")) %>%
    column_spec(5, color = ifelse(S_p_vals < 0.05, "white", "black"), 
                background = ifelse(S_p_vals < 0.05, ifelse(S_corr_vals<0, "red", "blue"), "white")) %>%
    save_kable(file = table_png, zoom=1.5)
  
  library(webshot)
  webshot(html_tbl_fname, table_png)
}


#TODO: Create and save pretty tables for each of the scenes

#TODO: Group the tables created by scenes 

#TODO: Group the grouped tables into one figure file 

#TODO: Create example synchrony figure



write.csv(pearson_results, save_path)
write.csv(spearman_results, save_path)

