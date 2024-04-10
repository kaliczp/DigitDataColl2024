## https://www.r-project.org/
## CRAN telepítéshez
install.packages("lidR")
library(lidR)
las <- readLAS("RAW_LiDAR_01.las")
print(las)
## Kisebb fájl
las <- readLAS("RAW_LiDAR_01.las", select = "xyz")
## ugyan az, mint a print las
las
las <-  readLAS("RAW_LiDAR_01.las", filter = "-keep_first -drop_z_below 170 -drop_z_above 200")
las_check(las)
plot(las)

plot(las, color = "ScanAngleRank", bg = "white", axis = TRUE, legend = TRUE)

plot(las, color = "Intensity", breaks = "quantile", bg = "white")

## Cross section
p1 <- c(357937.8, 5324058)
p2 <- c(359664.8, 5326529)

las_tr <- clip_transect(las, p1, p2, width = 4, xz = TRUE)
plot(las_tr)

install.packages("ggplot2")
library(ggplot2)

ggplot(las_tr@data, aes(X,Z, color = Z)) + 
  geom_point(size = 0.5) + 
  coord_equal() + 
  theme_minimal() +
  scale_color_gradientn(colours = height.colors(50))

## Osztályozás
las <- classify_ground(las, algorithm = pmf(ws = 5, th = 3))

## Osztályozás mintafájllal
LASfile <- system.file("extdata", "Topography.laz", package="lidR")
las <- readLAS(LASfile, select = "xyzrn")
las <- classify_ground(las, algorithm = pmf(ws = 5, th = 3))
plot(las)

plot(las, color = "Classification", size = 3, bg = "white") 

?classify_ground
?pmf
?util_makeZhangParam
util_makeZhangParam()

## Own parameter
ujPar <- util_makeZhangParam(
       b = 2,
       dh0 = 1,
       dhmax = 3,
       s = 1,
       max_ws = 20,
       exp = TRUE
     )
las <- readLAS(LASfile, select = "xyzrn")
las <- classify_ground(las, algorithm = pmf(ujPar$ws,ujPar$th))
plot(las, color = "Classification")

## Count points
summary(as.factor(las$Classification))

