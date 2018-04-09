# Programming4GIS
Materials and resources related to Geography 491/489 at The University of Montana

This repository only reflects those topics covered in the 4 lectures concerning R.

## This Repository

This repository stores the course materials, labs and supporting information for the R portion of programming for GIS.  To use this repository run the code for the StarterKit outlined below and then try the code in folders Vector Data, Rasters and Spatial_Viz.

## Why GitHub?

Because it is great!  If you have questions, feature requests or find bugs in the code here you can let me know about it using the Issues tab above.  You could even fix it yourself and submit a pull request to help keep the code up to date and running smoothly.  Of course you can clone all of the code here to use in your own projects and this type of thing is highly encouraged.  

Git is a great tool for version control and GitHub among others have made it easier to use and added lots of value.  Check out the add-ins, Projects, Wiki and more.  

## Cheat Sheets

https://www.rstudio.com/resources/cheatsheets/

## TidyVerse - a way of life

https://www.tidyverse.org/

## Simple Features

https://github.com/r-spatial/sf
*See Vignettes at:*
https://cran.r-project.org/web/packages/sf

## Need to know packages
The usual suspects...a few of the more useful packages for getting going with GIS in R

- [sp](https://cran.r-project.org/web/packages/sp/index.html)
- [raster](https://cran.r-project.org/web/packages/raster/index.html)
- [rgdal](https://cran.r-project.org/web/packages/rgdal/index.html)
  - And related
    - [gdalUtils](https://cran.r-project.org/web/packages/gdalUtils/index.html)
    - [GDAL](http://www.gdal.org/) not an R package, but software
- [rgeos](https://cran.r-project.org/web/packages/rgeos/index.html)
  - And related
    - [GEOS](https://trac.osgeo.org/geos)
- [maptools](https://cran.r-project.org/web/packages/maptools/index.html)
- [tmaps](https://cran.r-project.org/web/packages/tmap/index.html)
- [leaflet](https://rstudio.github.io/leaflet/)

If you want to load most of these files try using the Starter_Kit:
```R
#  If needed install devtools
#install.packages(devtools)

devtools::source_url("https://raw.githubusercontent.com/Huh/Programming4GIS/master/Starter_Kit/pkg_install.R")

```

**Anytime we want to learn about a topic in R we can use the task views located at https://cran.r-project.org/web/views/**

[Check out the spatial task view!](https://cran.r-project.org/web/views/Spatial.html)

## R can be used with external programs/languages
- Call Python from R with https://github.com/rstudio/reticulate for example
- Or try using R with other open source tools like GRASS or ...https://geostat-course.org/content/get-training-r-osgeo

## A simple(ish) introduction to spatial data in R

Check out [http://www.rspatial.org/](http://www.rspatial.org/) for a comprehensive *introduction* to working with spatial data in R.

# Play
Plotting Spatial Data in R
================
Joe Smith

-   [Review: kinds of spatial data](#review-kinds-of-spatial-data)
    -   [1) raster](#raster)
    -   [2) vector](#vector)
-   [Plotting spatial data with Base R](#plotting-spatial-data-with-base-r)
    -   [Reprojecting vector data](#reprojecting-vector-data)
    -   [Raster data](#raster-data)
    -   [Reprojecting raster data in R](#reprojecting-raster-data-in-r)
-   [Getting serious: making better maps with tmap](#getting-serious-making-better-maps-with-tmap)
-   [Getting interactive: tmap view mode](#getting-interactive-tmap-view-mode)

Review: kinds of spatial data
-----------------------------

### 1) raster

Raster data are spatial data stored in a grid. Examples include Digital Elevation Models (DEM), spatially-interpolated climate or weather data (e.g., PRISM, DAYMET, WorldClim), or model predictions extrapolated across space (e.g., predictions of occupancy, abundance, density). The R package [raster](https://cran.r-project.org/web/packages/raster/index.html) is all that is needed for most raster data handling in R.

### 2) vector

Vector data are data represented by points, lines, and polygons. Shapefiles, KMLs, and GeoJSONs are common formats used to represent geographic vector data. The R package [sp](https://cran.r-project.org/web/packages/sp/index.html) handles most vector data needs in R. Other helpful functions can be found in the [rgeos](https://cran.r-project.org/web/packages/rgeos/rgeos.pdf) package, where tools similar to those found in the ArcGIS Analysis Toolbox (e.g., clip, union, buffer).

Plotting spatial data with Base R
---------------------------------

First, we'll load [tmap](https://cran.r-project.org/web/packages/tmap/index.html), which we'll use later to make some nice-looking maps. Here, we're just going to load it because it has some "example" spatial data we can plot.

``` r
library(sp)
library(tmap)
data(World)
data(metro)
```

Both datasets, "World" and "metro," are vector datasets. We'll use Base R to plot these so you can see what they look like:

``` r
plot(World)
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-2-1.png)

``` r
plot(metro, pch=16, cex=0.5)
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-2-2.png)

Neat, but I want them on the same map. Let's try this:

``` r
plot(World)
plot(metro, pch=16, cex=0.5, add=T)
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-3-1.png)

I used the argument 'pch=16' to specify the symbol that I wanted to use for metro areas, a filled circle. More plotting characters can be found by [googling it](https://www.google.com/search?q=R+plotting+characters). The argument 'cex=0.5' controls the symbol size.

Our metropolitan areas didn't show up. Why not? Usually it's because the coordinate reference systems (CRS) of the datasets don't match.

``` r
proj4string(World)
```

    ## [1] "+proj=eck4 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs +towgs84=0,0,0"

``` r
proj4string(metro)
```

    ## [1] "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"

Herein lies a fundamental difference between making maps in R (especially base R) and making maps in ArcGIS. R doesn't 'project on the fly,' so you're responsible for lining everything up by getting all your datasets projected into a common CRS. The mapping functions in the tmap package have some project-on-the-fly functionality, but it's best to get your layers in a common CRS anyway because *most* of the functions you will use to process spatial data demand it.

### Reprojecting vector data

For this example, it doesn't matter what CRS we use, just as long as all of our datasets share the same one. We'll use the CRS from metro. To reproject vector data, we use the function sp::spTransform. The first argument is the dataset we want to reproject ("transform"), the second argument is the CRS, which needs to be cast into the CRS class. We'll call this reprojected dataset "world" (lower-case w).

``` r
world <- spTransform(World, CRS(proj4string(metro)))
```

Now try plotting again:

``` r
plot(world)
plot(metro, pch = 16, cex = 0.5, add = T)
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-6-1.png)

Base R is very flexible and you can make very sophisticated, visually attractive maps with it. It'll just take a lot of code to get it looking right.

### Raster data

Base R can also plot raster data. Let's take a look at a common type of raster data that's freely available: climate data. [WorldClim](http://worldclim.org/version2) has some basic data like average monthly precipitation and temperature, as well as a suite of "bioclimatic variables" that can be useful for predicting species distributions, etc. We'll download the bioclimatic variables and look at a few of them.

``` r
library(raster)

# create temporary directory
td <- tempdir()

# create a temporary file
tf <- tempfile(tmpdir = td, fileext = ".zip")

# download the bioclimatic variable from the WorldClim website and put it in
# the temporary file
download.file("http://biogeo.ucdavis.edu/data/worldclim/v2.0/tif/base/wc2.0_10m_bio.zip", 
    tf)

# get names of files in .zip file
fname <- unzip(tf, list = T)$Name

# unzip them, put them in the temporary directory
unzip(tf, files = fname, exdir = td, overwrite = T)

# read them with raster::raster() and place into list
raster.list <- lapply(list.files(td, pattern = ".tif", full.names = T), function(x) raster(x))

# compress that list of rasters into a multi-band image ('RasterBrick') with
# raster::brick()
bio <- do.call(brick, raster.list)

class(bio)
```

    ## [1] "RasterBrick"
    ## attr(,"package")
    ## [1] "raster"

We now have a "RasterBrick" containing all the bioclimatic variables as layers or bands.

``` r
nlayers(bio)
```

    ## [1] 19

``` r
names(bio)
```

    ##  [1] "wc2.0_bio_10m_01" "wc2.0_bio_10m_02" "wc2.0_bio_10m_03"
    ##  [4] "wc2.0_bio_10m_04" "wc2.0_bio_10m_05" "wc2.0_bio_10m_06"
    ##  [7] "wc2.0_bio_10m_07" "wc2.0_bio_10m_08" "wc2.0_bio_10m_09"
    ## [10] "wc2.0_bio_10m_10" "wc2.0_bio_10m_11" "wc2.0_bio_10m_12"
    ## [13] "wc2.0_bio_10m_13" "wc2.0_bio_10m_14" "wc2.0_bio_10m_15"
    ## [16] "wc2.0_bio_10m_16" "wc2.0_bio_10m_17" "wc2.0_bio_10m_18"
    ## [19] "wc2.0_bio_10m_19"

Maybe you're interested in precipitation. According to the WorldClim website:

-   BI012 = Annual Precipitation
-   BIO13 = Precipitation of Wettest Month
-   BIO14 = Precipitation of Driest Month
-   BIO15 = Precipitation Seasonality (Coefficient of Variation).

These correspond to layers 12 through 15, so let's subset our RasterBrick to just those layers and take a look at them.

``` r
precip <- bio[[12:15]]
class(precip)
```

    ## [1] "RasterBrick"
    ## attr(,"package")
    ## [1] "raster"

``` r
plot(precip)
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-9-1.png)

The colors are alright, but they can be easily changed. The function colorRampPalette is a convenient and flexible way to make interpolated color ramps for continuous data like these.

``` r
precip.colors <- colorRampPalette(c("#fc8d59", "#ffffbf", "#4575b4"), bias = 4)
plot(precip, col = precip.colors(100))
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-10-1.png)

### Reprojecting raster data in R

Reprojecting raster data requires a different function than that used on vector data. Unsurprisingly, it's found in the raster package, raster::projectRaster. The same function is used whether you're dealing with a single layer/band (a RasterLayer) or a multi-layer RasterStack or RasterBrick.

``` r
precip <- projectRaster(precip, crs = CRS(proj4string(world)))
```

Now let's add the country boundaries and metro areas,

``` r
plot(precip[[1]], col = precip.colors(100))
lines(world, lwd = 0.25, col = "grey50")
points(metro, cex = 0.8 * (metro$pop2010/max(metro$pop2010)))
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-12-1.png)

Getting serious: making better maps with tmap
---------------------------------------------

[tmap](https://cran.r-project.org/web/packages/tmap/index.html) works much like ggplot.

``` r
tm_shape(precip) +
  tm_raster(col="wc2.0_bio_10m_12", title="Annual precipitation", palette=precip.colors(100), n=100, legend.show = F) +
tm_shape(world) +
  tm_borders("grey35", lwd=0.5) +
tm_shape(metro) +
  tm_symbols(size="pop2010", title.size="Metro population", col="black", shape=1, scale=0.5)
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-13-1.png)

Now if we want to plot the same basic map but display multiple attributes in different panels, just pass a vector of raster layer names to the "col" argument in tm\_raster().

Recall that these can be accessed with names():

``` r
names(precip)
```

    ## [1] "wc2.0_bio_10m_12" "wc2.0_bio_10m_13" "wc2.0_bio_10m_14"
    ## [4] "wc2.0_bio_10m_15"

``` r
tm_shape(precip) +
  tm_raster(col=names(precip), palette=precip.colors(100), n=100, legend.show = F) +
tm_shape(world) +
  tm_borders("grey35", lwd=0.5) +
tm_shape(metro) +
  tm_symbols(size="pop2010", title.size="Metro population", col="black", shape=1, scale=0.5)
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-15-1.png)

To change aspects of the general appearance of the map, use the function tm\_layout

``` r
tm_shape(precip) +
  tm_raster(col=names(precip), palette=precip.colors(100), n=100, legend.show = F) +
  tm_facets(free.scales=T) +
tm_shape(world) +
  tm_borders("grey35", lwd=0.5) +
tm_shape(metro) +
  tm_symbols(size="pop2010", title.size="Metro population", col="black", shape=1, scale=0.5) +
tm_layout(bg.color="grey80",
          legend.bg.color="white",
          legend.outside=T,
          legend.outside.position="right",
          panel.labels=c("Annual Precipitation",
                         "Precipitation of Wettest Month",
                         "Precipitation of Driest Month",
                         "Precipitation Seasonality (CV)"),
          panel.label.bg.color="white")
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-16-1.png)

Say we want to change the frame of our map to only show Africa. This can easily be done by specifying the bbox (bounding box) using tmaptools::bb(). First, let's have a look at the world dataset to see how we can subset this SpatialPolygonsDataFrame to Africa.

``` r
head(world)
```

    ##    iso_a3                 name           sovereignt     continent
    ## 2     AFG          Afghanistan          Afghanistan          Asia
    ## 3     AGO               Angola               Angola        Africa
    ## 5     ALB              Albania              Albania        Europe
    ## 8     ARE United Arab Emirates United Arab Emirates          Asia
    ## 9     ARG            Argentina            Argentina South America
    ## 10    ARM              Armenia              Armenia          Asia
    ##          subregion    area  pop_est pop_est_dens gdp_md_est gdp_cap_est
    ## 2    Southern Asia  652860 28400000     43.50090      22270    784.1549
    ## 3    Middle Africa 1246700 12799293     10.26654     110300   8617.6635
    ## 5  Southern Europe   27400  3639453    132.82675      21810   5992.6588
    ## 8     Western Asia   83600  4798491     57.39822     184300  38407.9078
    ## 9    South America 2736690 40913584     14.95003     573900  14027.1261
    ## 10    Western Asia   28470  2967004    104.21510      18770   6326.2469
    ##                      economy              income_grp life_exp well_being
    ## 2  7. Least developed region           5. Low income     48.7   4.758381
    ## 3  7. Least developed region  3. Upper middle income     51.1   4.206092
    ## 5       6. Developing region  4. Lower middle income     76.9   5.268937
    ## 8       6. Developing region 2. High income: nonOECD     76.5   7.196803
    ## 9    5. Emerging region: G20  3. Upper middle income     75.9   6.441067
    ## 10      6. Developing region  4. Lower middle income     74.2   4.367811
    ##         HPI
    ## 2  36.75366
    ## 3  33.20143
    ## 5  54.05118
    ## 8  31.77827
    ## 9  54.05504
    ## 10 46.00319

Conveniently, there's a column called "continent" to which we can apply a logical statement to subset the data, like so:

``` r
tm_shape(precip, bbox=tmaptools::bb(world[world$continent == "Africa",], ext=1.1)) +
  tm_raster(col=names(precip), palette=precip.colors(100), n=100, legend.show = F) +
  tm_facets(free.scales=T) +
tm_shape(world) +
  tm_borders("grey35", lwd=0.5) +
tm_shape(metro) +
  tm_symbols(size="pop2010", title.size="Metro population", col="black", shape=1, scale=0.75) +
tm_layout(bg.color="grey80",
          legend.bg.color="white",
          legend.outside=T,
          legend.outside.position="right",
          panel.labels=c("Annual Precipitation",
                         "Precipitation of Wettest Month",
                         "Precipitation of Driest Month",
                         "Precipitation Seasonality (CV)"),
          panel.label.bg.color="white")
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-18-1.png)

Getting interactive: tmap view mode
-----------------------------------

Note: the following is modified only slightly from the vignette "tmap-modes" (see vignette("tmap-modes", package="tmap"))

Static maps are fine, but the world is going interactive (for example, see this [this](https://www.gapminder.org/tools/) or [this](https://archive.nytimes.com/www.nytimes.com/interactive/2009/03/10/us/20090310-immigration-explorer.html?_r=1)).

There are a growing number of tools that facilitate the production of interactive figures, including maps, in R. The tmap package uses Leaflet to implement interactive maps; this feature is accessed by switching into "view mode."

First we'll make a static map, but this time we'll assign it to an object instead of simply printing it.

``` r
metro$growth <- (metro$pop2020 - metro$pop2010) / (metro$pop2010 * 10) * 100

mapWorld <- tm_shape(world) +
    tm_polygons("income_grp", palette="-Blues", contrast=.7, id="name", title="Income group") +
    tm_shape(metro) +
    tm_bubbles("pop2010", col = "growth", 
               border.col = "black", border.alpha = .5, 
               style="fixed", breaks=c(-Inf, seq(0, 6, by=2), Inf),
               palette="-RdYlBu", contrast=1, 
               title.size="Metro population", 
               title.col="Growth rate (%)", id="name") + 
    tm_style_gray() +
    tm_format_World()
```

To plot, just print the declared variable mapWorld:

``` r
mapWorld
```

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-20-1.png)

The current mode can be obtained and set with the function tmap\_mode:

``` r
tmap_mode("view")
```

    ## tmap mode set to interactive viewing

Now the mode is set to view, we can interactively view it by printing it again:

``` r
mapWorld
```

    ## Legend for symbol sizes not available in view mode.

![](spatial_data_mapping_files/figure-markdown_github/unnamed-chunk-22-1.png)

In interactive mode, a leaflet widget is created and shown. If you want to change or extend the widget, you can use the function tmap\_leaflet to obtain the leaflet widget object, and use leafletâs own functions to adjust it.
