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
