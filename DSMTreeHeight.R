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
