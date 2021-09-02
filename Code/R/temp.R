# Set working directory to source file location 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Set working directory to projects root directory 
cur_wd = dirname( dirname( getwd() ) )
setwd(cur_wd)


install.packages('ggplot2')
install.packages("gridExtra")               # Install gridExtra package
library('ggplot2')
library('magrittr')
library("gridExtra")                        # Load gridExtra package

# pdf(file = "Results/ESDPlots2.pdf")
for ( i in 1:2 ) {
  
  # create input dataframe
  df_in <- read.csv(file_names[i])
  esd = df_in[,4]
  pearson = df_in[,7]
  spearman = df_in[,8]
  
  esd_max = round(max(esd)+5, digits = -1)
  esd_min = round(min(esd)-5, digits = -1)
  
  names(df_in) <- c("X_coord", "Y_coord", "Elevation", "Elevation_SD", "Avg_MXVI", "MXVI_SD", "Pearson", "Spearman")
  
  pearson_gg<- df_in %>% ggplot(aes(x = esd, y = pearson, z = spearman)) + 
    geom_point() +
    geom_smooth(method='lm')  +
    xlim(esd_min,esd_max) + 
    ylim(min(pearson), max(pearson)) +
    labs(title=expression("Pearson"~(rho)), x=expression("ESD"), y=expression(rho)) +
    coord_fixed(ratio = esd_max/(max(pearson) - min(pearson)), xlim = NULL, ylim = NULL)
  
  print(pearson_gg)
  
  
    
  
  
  # Open jpg in the save location 
  # jpeg( paste("Results/", scene_names[[i]], "/ESD.jpg", sep = "") )
  
  # Plot the ggplots side by side
  # grid.arrange(pearson_gg, spearman_gg, ncol = 2)          # Apply grid.arrange function

  # Close the save location
  # dev.off()
  
}  # End for 




spearman_gg<- df_in %>% ggplot(aes(x = esd, y = spearman)) + 
  geom_point() +
  geom_smooth(method='lm')  +
  xlim(0,esd_max) + 
  ylim(min(spearman), max(spearman)) +

  ggtitle(label = 'Spearman') + 
  coord_fixed(ratio = esd_max/(max(spearman) - min(spearman)), xlim = NULL, ylim = NULL)
