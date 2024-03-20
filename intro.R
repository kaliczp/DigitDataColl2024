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
