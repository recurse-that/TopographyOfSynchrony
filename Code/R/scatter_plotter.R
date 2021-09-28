# Create folder for plots within Results folder
path_name = paste(results_path, 'Plots', sep='/')
dir.create(path_name, showWarnings = FALSE)
# Elevation Scatter Plots
pdf_name = paste(path_name, 'ElevPlots.pdf', sep='/')
pdf(file = pdf_name)
for (i in 1:scene_count) {
  setwd(cur_wd)
  df_in <- read.csv(file_names_in[i])
  elev = df_in[,3]
  pearson = df_in[,7]
  spearman = df_in[,8]
  par(mfrow=c(2,1))
  plot( elev, pearson, main = scene_names[i], pch = 19, cex = 0.5)
  plot( elev, spearman, main = scene_names[i], pch = 19, cex = 0.5 )
  setwd(code_path)
}
dev.off()

# Elevation Standard Deviation Scatter Plots
pdf_name = paste(path_name, 'ESDPlots.pdf', sep='/')
pdf(file = pdf_name)
for (i in 1:scene_count) {
  setwd(cur_wd)
  df_in <- read.csv(file_names_in[i])
  esd = df_in[,4]
  pearson = df_in[,7]
  spearman = df_in[,8]
  par(mfrow=c(2,1))
  plot( esd, pearson, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  plot( esd, spearman, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  setwd(code_path)
}
dev.off()

# MXVI Scatter Plots
pdf_name = paste(path_name, 'MXVIPlots.pdf', sep='/')
pdf(file = pdf_name)
for (i in 1:scene_count) {
  setwd(cur_wd)
  df_in <- read.csv(file_names_in[i])
  mxvi = df_in[,5]
  pearson = df_in[,7]
  spearman = df_in[,8]
  par(mfrow=c(2,1))
  plot( mxvi, pearson, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  plot( mxvi, spearman, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  setwd(code_path)
}
dev.off()


# MXVI Standard Deviation Scatter Plots
pdf_name = paste(path_name, 'MXVISDPlots.pdf', sep='/')
pdf(file = pdf_name)
for (i in 1:scene_count) {
  setwd(cur_wd)
  df_in <- read.csv(file_names_in[i])
  msd = df_in[,6]
  pearson = df_in[,7]
  spearman = df_in[,8]
  par(mfrow=c(2,1))
  plot( msd, pearson, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  plot( msd, spearman, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  setwd(code_path)
}
dev.off()
