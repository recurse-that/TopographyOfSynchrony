# Elevation Scatter Plots
pdf(file = paste(results_path, "ElevPlots.pdf"))
for (i in 1:scene_index) {
  df_in <- read.csv(file_names_in[i])
  elev = df_in[,3]
  pearson = df_in[,7]
  spearman = df_in[,8]
  par(mfrow=c(2,1))
  plot( elev, pearson, main = scene_names[i], pch = 19, cex = 0.5)
  plot( elev, spearman, main = scene_names[i], pch = 19, cex = 0.5 )
}
dev.off()

# Elevation Standard Deviation Scatter Plots
pdf(file = paste(results_path, "ESDPlots.pdf"))
for (i in 1:scene_index) {
  df_in <- read.csv(file_names_in[i])
  esd = df_in[,4]
  pearson = df_in[,7]
  spearman = df_in[,8]
  par(mfrow=c(2,1))
  plot( esd, pearson, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  plot( esd, spearman, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
}
dev.off()

# MXVI Scatter Plots
pdf(file = paste(results_path, "MXVIPlots.pdf"))
for (i in 1:scene_index) {
  df_in <- read.csv(file_names_in[i])
  mxvi = df_in[,5]
  pearson = df_in[,7]
  spearman = df_in[,8]
  par(mfrow=c(2,1))
  plot( mxvi, pearson, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  plot( mxvi, spearman, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
}
dev.off()


# MXVI Standard Deviation Scatter Plots
pdf(file = paste(results_path, "MXVISDPlots.pdf"))
for (i in 1:scene_index) {
  df_in <- read.csv(file_names_in[i])
  msd = df_in[,6]
  pearson = df_in[,7]
  spearman = df_in[,8]
  par(mfrow=c(2,1))
  plot( msd, pearson, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
  plot( msd, spearman, type = "p", main = scene_names[i], pch = 19, cex = 0.5 )
}
dev.off()
