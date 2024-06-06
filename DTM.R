## 
LASfile <- system.file("extdata", "Topography.laz", package="lidR")
las <- readLAS(LASfile, select = "xyzc")
plot(las, size = 3, bg = "white")

##
dtm_tin <- rasterize_terrain(las, res = 1, algorithm = tin())
plot_dtm3d(dtm_tin, bg = "white")

## Export raster
library(terra)
writeRaster(dtm_tin,"dtm.tif")

## IDW
dtm_idw <- rasterize_terrain(las, algorithm = knnidw(k = 10L, p = 2))
plot_dtm3d(dtm_idw, bg = "white") 

## Kriging
dtm_kriging <- rasterize_terrain(las, algorithm = kriging(k = 40))
plot_dtm3d(dtm_kriging, bg = "white")

## spline
## load 19 sect alg.
dtm_mba <- rasterize_terrain(las, algorithm = mba())
plot_dtm3d(dtm_mba, bg = "white")

## Shading

