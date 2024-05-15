LASfile <- system.file("extdata", "Topography.laz", package="lidR")
las <- readLAS(LASfile)
plot(las, size = 3, bg = "white")
