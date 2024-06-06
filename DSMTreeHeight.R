library(lidR)
library(ggplot2)
LASfile <- system.file("extdata", "MixedConifer.laz", package ="lidR")
las <- readLAS(LASfile)
plot(las, size = 3, bg = "white")

chm <- rasterize_canopy(las, res = 1, algorithm = p2r())
col <- height.colors(25)
plot(chm, col = col)

chm <- rasterize_canopy(las, res = 0.5, algorithm = p2r())
plot(chm, col = col)

chm <- rasterize_canopy(las, res = 0.5, algorithm = p2r(subcircle = 0.15))
plot(chm, col = col)

chm <- rasterize_canopy(las, res = 0.5, p2r(0.2, na.fill = tin()))
plot(chm, col = col)

chm2 <- rasterize_canopy(las, res = 0.5, algorithm = dsmtin())
plot(chm, col = col)

plot(chm - chm2)

## Új fájl
LASfile <- system.file("extdata", "Topography.laz", package = "lidR")
las2 <- readLAS(LASfile)
las2 <- normalize_height(las2, algorithm = tin())
plot(las2, size = 3, bg = "white")

chm <- rasterize_canopy(las2, res = 0.5, algorithm = dsmtin())
plot(chm, col = col)

chm <- rasterize_canopy(las2, res = 0.5, algorithm = dsmtin(max_edge = 8))
plot(chm, col = col)

# The first layer is a regular triangulation
layer0 <- rasterize_canopy(las, res = 0.5, algorithm = dsmtin())

# Triangulation of first return above 10 m
above10 <- filter_poi(las, Z >= 10)
layer10 <- rasterize_canopy(above10, res = 0.5, algorithm = dsmtin(max_edge = 1.5))

# Triangulation of first return above 20 m
above20 <- filter_poi(above10, Z >= 20)
layer20 <- rasterize_canopy(above20, res = 0.5, algorithm = dsmtin(max_edge = 1.5))

# The final surface is a stack of the partial rasters
dsm <- layer0
dsm[] <- pmax(as.numeric(layer0[]), as.numeric(layer10[]), as.numeric(layer20[]), na.rm = T)

layers <- c(layer0, layer10, layer20, dsm)
names(layers) <- c("Base", "Layer10m", "Layer20m", "pitfree")
plot(layers, col = col)

## With pitfree
chm <- rasterize_canopy(las, res = 0.5, pitfree(thresholds = c(0, 10, 20), max_edge = c(0, 1.5)))
plot(chm, col = col)

## pitfreee max edge
chm <- rasterize_canopy(las, res = 0.5, pitfree(max_edge = c(0, 2.5)))
plot(chm, col = col)

chm <- rasterize_canopy(las, res = 0.5, pitfree(subcircle = 0.15))
plot(chm, col = col)

## terra post proc
fill.na <- function(x, i=5) { if (is.na(x)[i]) { return(mean(x, na.rm = TRUE)) } else { return(x[i]) }}
w <- matrix(1, 3, 3)

chm <- rasterize_canopy(las, res = 0.5, algorithm = p2r(subcircle = 0.15), pkg = "terra")
filled <- terra::focal(chm, w, fun = fill.na)
smoothed <- terra::focal(chm, w, fun = mean, na.rm = TRUE)

chms <- c(chm, filled, smoothed)
names(chms) <- c("Base", "Filled", "Smoothed")
plot(chms, col = col)
