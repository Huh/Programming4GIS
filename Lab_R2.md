Spatial Programming R2
================
Josh Nowak
April 2, 2018

``` r
require(sp)
```

    ## Loading required package: sp

``` r
require(raster)
```

    ## Loading required package: raster

``` r
require(tidyr)
```

    ## Loading required package: tidyr

    ## 
    ## Attaching package: 'tidyr'

    ## The following object is masked from 'package:raster':
    ## 
    ##     extract

``` r
require(dplyr)
```

    ## Loading required package: dplyr

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:raster':
    ## 
    ##     intersect, select, union

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

### Recipe part 2 - Programming and design patterns

In general we want to distill problems to their simplest form. This may not results in a simple solution, but it will be the simplest.

Imagine we want to build xy points for a number of individuals and then calculate a home range, i.e. kernel density, on those points. Let's say we have 20 animals that we want to perform this procedure on. How do we proceed?

Simplify the problem to one individual...

``` r
build_xy <- function(npts, center_x, noise_x, center_y, noise_y){
  
  xs <- rnorm(npts, center_x, noise_x)
  ys <- rnorm(npts, center_y, noise_y)
  
  out <- tibble::tibble(
    x = xs,
    y = ys
  )
  
return(out)
}
```

Nice and clean, no extra steps and useful in other projects, likely.

Ok, so we can make it spatial, but spatial things are a little harder to work with. How about we hold off on being spatial as long as possible. Let's create some data...

``` r
ind_dat <- tibble::tibble(
  ID = 1:20,
  Npts = round(runif(20, 3, 22))
  )

ind_dat
```

    ## # A tibble: 20 x 2
    ##       ID  Npts
    ##    <int> <dbl>
    ##  1     1    22
    ##  2     2    14
    ##  3     3    13
    ##  4     4     9
    ##  5     5    15
    ##  6     6     5
    ##  7     7    17
    ##  8     8    21
    ##  9     9    11
    ## 10    10     9
    ## 11    11     9
    ## 12    12    13
    ## 13    13    15
    ## 14    14     6
    ## 15    15    16
    ## 16    16    20
    ## 17    17    22
    ## 18    18     6
    ## 19    19     6
    ## 20    20     9

Each individual now has an ID and some number of points associated with it. Now we want to apply our function to create xy data to each individual.

``` r
ind_dat <- tibble::tibble(
  ID = 1:20,
  Npts = round(runif(20, 3, 22))
  ) %>%
  group_by(ID) %>%
  do(xy = build_xy(.$Npts, center_x = -115, noise_x = 100, center_y = 45, noise_y = 50))

ind_dat
```

    ## Source: local data frame [20 x 2]
    ## Groups: <by row>
    ## 
    ## # A tibble: 20 x 2
    ##       ID                xy
    ##  * <int>            <list>
    ##  1     1 <tibble [15 x 2]>
    ##  2     2  <tibble [6 x 2]>
    ##  3     3 <tibble [18 x 2]>
    ##  4     4 <tibble [14 x 2]>
    ##  5     5  <tibble [8 x 2]>
    ##  6     6 <tibble [14 x 2]>
    ##  7     7  <tibble [3 x 2]>
    ##  8     8 <tibble [14 x 2]>
    ##  9     9 <tibble [11 x 2]>
    ## 10    10 <tibble [18 x 2]>
    ## 11    11 <tibble [18 x 2]>
    ## 12    12 <tibble [22 x 2]>
    ## 13    13  <tibble [4 x 2]>
    ## 14    14  <tibble [8 x 2]>
    ## 15    15  <tibble [9 x 2]>
    ## 16    16 <tibble [19 x 2]>
    ## 17    17  <tibble [4 x 2]>
    ## 18    18 <tibble [13 x 2]>
    ## 19    19 <tibble [20 x 2]>
    ## 20    20 <tibble [12 x 2]>

That was cool, but now we have theis weird listcol *xy* and we would prefer to just have long data. Try tidyr::unnest...

``` r
ind_dat <- tibble::tibble(
  ID = 1:20,
  Npts = round(runif(length(ID), 3, 22))
  ) %>%
  group_by(ID) %>%
  do(xy = build_xy(.$Npts, center_x = -115, noise_x = 100, center_y = 45, noise_y = 50)) %>%
  unnest

ind_dat
```

    ## # A tibble: 243 x 3
    ##       ID          x           y
    ##    <int>      <dbl>       <dbl>
    ##  1     1 -118.14535  16.8945095
    ##  2     1  -45.31896  -1.6917813
    ##  3     1  -43.77496  -0.7425934
    ##  4     1 -211.97527  34.9252815
    ##  5     1  -68.17588 -35.2749158
    ##  6     1   51.13305  68.5298571
    ##  7     1 -156.64710  70.0322808
    ##  8     1  -54.52092 -31.1634750
    ##  9     1 -297.81000  50.9903923
    ## 10     1 -194.92276  46.7242968
    ## # ... with 233 more rows

Very cool, now we have long data and we have created data in a very simple and flexible fashion. How might we also build this to have a different home range center for each individual?

``` r
ind_dat <- tibble::tibble(
  ID = 1:20,
  Npts = round(runif(length(ID), 3, 22)),
  x_center = runif(length(ID), -120, -110),
  y_center = runif(length(ID), 40, 48),
  ) %>%
  group_by(ID, x_center, y_center) %>%
  do(xy = 
    build_xy(
      .$Npts, 
      center_x = .$x_center, 
      noise_x = 100, 
      center_y = .$y_center, 
      noise_y = 50
    )
  ) %>%
  unnest

ind_dat
```

    ## # A tibble: 241 x 5
    ##       ID  x_center y_center          x           y
    ##    <int>     <dbl>    <dbl>      <dbl>       <dbl>
    ##  1     1 -116.5649 44.91363   33.26890 114.1238802
    ##  2     1 -116.5649 44.91363 -148.22607 112.6150303
    ##  3     1 -116.5649 44.91363 -186.79500  -7.0955884
    ##  4     1 -116.5649 44.91363 -148.38656 101.3514759
    ##  5     1 -116.5649 44.91363 -148.96445  49.3438917
    ##  6     1 -116.5649 44.91363 -131.32075 144.0934359
    ##  7     1 -116.5649 44.91363 -228.89789  59.9005621
    ##  8     1 -116.5649 44.91363  -82.64087 -26.8848754
    ##  9     1 -116.5649 44.91363   17.56623  -0.6078249
    ## 10     1 -116.5649 44.91363 -172.32190  14.7650661
    ## # ... with 231 more rows

Check that each individual has a unique home range center

``` r
ind_dat %>%
  group_by(ID) %>%
  distinct(x_center, y_center, .keep_all = F)
```

    ## # A tibble: 20 x 3
    ## # Groups:   ID [20]
    ##       ID  x_center y_center
    ##    <int>     <dbl>    <dbl>
    ##  1     1 -116.5649 44.91363
    ##  2     2 -117.0803 45.88738
    ##  3     3 -119.4278 40.20834
    ##  4     4 -117.3447 46.78451
    ##  5     5 -114.1243 41.67742
    ##  6     6 -112.4067 42.50219
    ##  7     7 -110.5424 47.42410
    ##  8     8 -112.5126 40.60730
    ##  9     9 -112.7366 44.20065
    ## 10    10 -119.2280 41.54125
    ## 11    11 -112.1013 43.47009
    ## 12    12 -116.7323 47.76950
    ## 13    13 -112.0787 47.45159
    ## 14    14 -114.1062 44.42730
    ## 15    15 -110.2516 40.84976
    ## 16    16 -118.1798 44.59837
    ## 17    17 -116.8238 42.15687
    ## 18    18 -112.1745 41.97171
    ## 19    19 -117.9458 41.62367
    ## 20    20 -113.9443 42.23665

Nice! Ok, now we want to calculate the home range center for each individual. Let's simplify the problem to a single individual.

``` r
    hr_kud <- function(x, ...){
      #  A function to calculate kernel utilization distributions of single 
      #   animals or groups of animals
      #  Takes a spatial points data frame and if desired additional arguments 
      #   to pass to adehabitatHR::kernelUD
      #  Returns estUD object
      #  Intended to be called from within hr_wrapper
      #  Example Call: 
      #   hr_kud(xy, grid = 200, same4all = T)
      #  For more information on options see adehabitatHR documentation
      #  https://cran.r-project.org/web/packages/adehabitatHR/index.html

      out <- try(adehabitatHR::kernelUD(x, ...))

    return(out)
    }
```

Looks like we need a new package adehabitatHR, install the package. If we type `?adehabitatHR::kernelUD` we see that the first argument to kernelUD must be of class SpatialPoints, so we need a function to change our xy data to a spatial object.

``` r
    hr_spdf <- function(x, id, prj){
      #  A function to create a spatial points data frame from a data.frame
      #  Takes a data frame containing coordinates of points defined by 
      #   x|longitude and y|latitude, the column of the id of the group and 
      #   a proj4string that defines the spatial projection
      #  Returns a spatial points data frame object
      #  See spatialreference.org for proj4string definitions
      
      out <- sp::SpatialPointsDataFrame(
        select(x, 
          grep("^x|^longitude", colnames(x), ignore.case = T),
          grep("^y|^latitude", colnames(x), ignore.case = T)),
        data = as.factor(id),
        proj4string = CRS(prj)      
      )

    return(out)
    }
```

The workflow then is something like - build xy - make xy spatial - calculate home range kernel

Let's try it for one animal

``` r
tst_dat <- tibble::tibble(
  ID = 1,
  Npts = round(runif(length(ID), 3, 22)),
  x_center = runif(length(ID), -120, -110),
  y_center = runif(length(ID), 40, 48),
  ) %>%
  group_by(ID, x_center, y_center) %>%
  do(xy = 
    build_xy(
      .$Npts, 
      center_x = .$x_center, 
      noise_x = 100, 
      center_y = .$y_center, 
      noise_y = 50
    )
  ) %>%
  unnest %>%
  ungroup

#tst_sp <- hr_spdf(tst_dat, id = dplyr::select(tst_dat, ID), prj = '+proj=longlat +datum=WGS84')
#tst_kud <- hr_kud(tst_sp, grid = 200, same4all = T)
```
