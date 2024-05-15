LASfile <- system.file("extdata", "Topography.laz", package="lidR")
las <- readLAS(LASfile)
plot(las, size = 3, bg = "white")

gnd <- filter_ground(las)
plot(gnd, size = 3, bg = "white", color = "Classification")

## DTM norm
dtm <- rasterize_terrain(las, 1, knnidw())
plot(dtm, col = gray(1:50/50))

nlas <- las - dtm
plot(nlas, size = 4, bg = "white")

hist(filter_ground(nlas)$Z, # csak talajpont kiválasztás
     breaks = seq(-0.6, 0.6, 0.01), ## -0.6-tól 0.01 közökkel osztályok
     main = "", xlab = "Elevation") # Szépítés

## Point clud norm
nlas <- normalize_height(las, knnidw())
hist(filter_ground(nlas)$Z, breaks = seq(-0.6, 0.6, 0.01), main = "", xlab = "Elevation")
summary(filter_ground(nlas)$Z)
