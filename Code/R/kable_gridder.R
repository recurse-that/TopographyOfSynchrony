library(png)
library(grid)
library(gridExtra)

plot <- list()
plot[[1]] <- readPNG(table_png)
plot[[2]] <- readPNG(table_png)
plot[[3]] <- readPNG(table_png)
plot[[4]] <- readPNG(table_png)
plot[[5]] <- readPNG(table_png)
plot[[6]] <- readPNG(table_png)

grid.arrange(rasterGrob(plot1),rasterGrob(plot2),rasterGrob(plot2),
             rasterGrob(plot2), rasterGrob(plot2),rasterGrob(plot2),
             rasterGrob(plot1),rasterGrob(plot2),rasterGrob(plot2),
             rasterGrob(plot2), rasterGrob(plot2),rasterGrob(plot2),ncol=2)


layout(matrix(1:6,nr=3,byr=T))
for (j in 1:6) plot(plot[[j]])
