R package raincpc: Obtain and Analyze Rainfall data from the Climate Prediction Center (CPC)
========================================================

The Climate Prediction Center's ([CPC](www.cpc.ncep.noaa.gov)) daily rainfall data for the entire world, 1979 - present & 50-km resolution, is one of the few high quality and long-term observation-based rainfall products available for free. Data is available at CPC's [ftp site](ftp.cpc.ncep.noaa.gov/precip/CPC_UNI_PRCP/GAUGE_GLB/). 

Some issues with size/format of the CPC data:
* there are too many files (365/366 files per year * 34 years, separate folder for each year)
* each file has 360 rows and 720 columns
* file naming conventions have changed over time - one format prior to 2006 and couple of different formats afterwards
* file formats have changed over time - gzipped files prior to 2008 and plain binary files afterwards
* downloading multiple files simultaneously from the CPC ftp site, using wget, does not seem to work properly
* there is no software/code readily available to easily process/visualize the data

R package `raincpc`:
* Data for anytime period during 1979-present can be downloaded and processed
* Just two functions required: one to download the data (`cpc_get_rawdata`) and another to process the downloaded data (`cpc_read_rawdata`)
* Making spatial maps using the processed data is easy, via ggplot

Here are some examples.

Invoke required libraries.


```r
library(raincpc)

library(ggplot2)
library(reshape2)
```


Rainfall during the last week of November 2013.


```r
# obtain data
cpc_get_rawdata(2013, 11, 24, 2013, 11, 24)
# process data
noreaster <- cpc_read_rawdata(2013, 11, 24)
```


Re-orient data for plotting.


```r
# function to flip a matrix upside down (change CPC orientation from S-N to
# N-S)
Fn_Flip_Matrix_Rows <- function(mat) {
    return(mat[nrow(mat):1, ])
}
# function to rotate a matrix 90 degress clockwise for plotting only used to
# counteract the 'image' function default behavior
Fn_Rotate_Matrix <- function(mat) {
    return(t(mat)[, nrow(mat):1])
}

noreaster <- Fn_Rotate_Matrix(Fn_Flip_Matrix_Rows(noreaster))
```


Global rainfall map.


```r
gfx_map <- ggplot(data = melt(noreaster))
gfx_map <- gfx_map + geom_raster(aes(Var1, Var2, fill = value))
gfx_map <- gfx_map + theme(axis.text = element_blank(), axis.ticks = element_blank())
gfx_map <- gfx_map + labs(x = NULL, y = NULL, fill = "Rain (mm/day)")
gfx_map <- gfx_map + ggtitle("Rainfall During Noreaster of Nov 2013")

png("gfx_noreaster.png", width = 800, height = 650)
plot(gfx_map)
garbage <- dev.off()
```


![figure 1] [fig1]

[fig1]: gfx_noreaster.png "figure 1" 
