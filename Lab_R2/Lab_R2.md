Spatial Programming Lab
================
Josh Nowak
April 2, 2018

``` r
require(adehabitatHR)
require(sp)
require(raster)
require(purrr)
require(tidyr)
require(dplyr)
```

### Recipe part 2 - Programming and design patterns

In general we want to distill problems to their simplest form. This may not results in a simple solution, but it will hopefully be the simplest. In addition, the tools in R and specifically the tidyverse work best when we have long data. Long data can be defined by each row of your data being a single observation and each column a variable. See [this link](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html) for a more complete definition.

### Using dplyr

[Cheat Sheet is here](https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf)

The R package dplyr was written to simplify your life. If you adopt the conventions of the package your code will likely be quite a bit neater, more efficient, faster and easier to read. The package is not sliced bread, but it generally prevents us from adopting numerous syntaxes and styles within a single script.

A nice introduction (in the form of a vignette) can be found at [this link.](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html)

The packages author, Hadley Wickham, likes to discuss the grammar of data. The analogy helps us think about how the package is organized. We use verbs to do things.

### Main Verbs

1.  filter (and slice)
    -   filters out the desired values or eliminates undesirable data, i.e. subsetting
    -   slice differs in that it allows one to select rows by position (e.g. 34)
    -   works on rows
    -   base R functions - subset, \[
2.  arrange
    -   orders the data according to the values in one or more columns
    -   base R functions - order, sort
3.  select (rename)
    -   allows the user to select certain columns or delete them using a negative sign
    -   works on columns
    -   base R functions - \[, $
4.  distinct
    -   finds unique values within a column or tbl\_df
    -   works on a column, columns or and entire tbl\_df
    -   base R functions - duplicated, unique
5.  mutate (transmute, mutate\_\*)
    -   changes the values within a column or adds a new column
    -   transmute is different in that it retains only the modified columns
    -   base R functions - replace, \[
6.  summarise (summarise\_\*)
    -   computes summary statistics over some index or indices, multiple values become one
    -   logical statements usually work within a column, but the effect is on the entire tbl\_df
    -   base R functions - tapply, loops
7.  sample\_n (sample\_frac)
    -   allows subsetting of data randomly by row or fraction of the whole
    -   works on the entire tbl\_df by selecting certain rows
    -   base R functions - sample and \[ or subset
8.  group\_by (rowwise)
    -   groups your data by the values in one or more columns
    -   rowwise differs in that it groups each row as a unique entity
    -   works on columns
    -   base R functions - none, but similar things are accomplished using split followed by lapply or simply a loop over unique values in a column
9.  do
    -   used to perform arbitrary computations (e.g. custom function) that can return a tbl\_df or any other R object, but if the result is not a data frame the results will be stored in a list
    -   can work on any portion of the data or the entire tbl\_df
    -   base R functions - typically this type of operation would be done using a loop or a member of the apply family

In addition to the verbs we also have some helpers.

### Helpers

-   n, count, n\_distinct, tally
-   groups, group\_inidices, group\_size
-   lead, lag
-   nth, first, last

#### Databases

dplyr has pretty extensive abilities to connect to databases, but they are beyond the scope of this document. I just want you to be aware that they exist.

Example
-------

Let us start by creating some data.

``` r
x <- tibble::tibble(
  ID = rep(letters[1:5], each = 5),
  Sex = rep(sample(c("M", "F"), 5, replace = T), each = 5),
  Status = 1,
  Year = rep(2011:2015, 5)
)
```

We should discuss what was done above and why it worked.

#### Excercises Part 1 (5 pts each)

-   Do an operation that returns all the data from before 2013

``` r
x %>%
  filter(Year < 2013)
```

    ## # A tibble: 10 x 4
    ##       ID   Sex Status  Year
    ##    <chr> <chr>  <dbl> <int>
    ##  1     a     M      1  2011
    ##  2     a     M      1  2012
    ##  3     b     M      1  2011
    ##  4     b     M      1  2012
    ##  5     c     F      1  2011
    ##  6     c     F      1  2012
    ##  7     d     F      1  2011
    ##  8     d     F      1  2012
    ##  9     e     F      1  2011
    ## 10     e     F      1  2012

-   Now return all the data in 2014

``` r
x %>%
  filter(
    Year == 2014,
    Sex == "M"
  )
```

    ## # A tibble: 2 x 4
    ##      ID   Sex Status  Year
    ##   <chr> <chr>  <dbl> <int>
    ## 1     a     M      1  2014
    ## 2     b     M      1  2014

-   Now return the data for Males in 2014
-   Return the data for Males in 2014, but report only the number of observations of each animal
-   How many animals of each sex were surveyed in each year Option \#1

``` r
x %>%
  group_by(Year) %>%
  summarise(
    N_ind = n_distinct(ID)  
  )
```

    ## # A tibble: 5 x 2
    ##    Year N_ind
    ##   <int> <int>
    ## 1  2011     5
    ## 2  2012     5
    ## 3  2013     5
    ## 4  2014     5
    ## 5  2015     5

Option \#2

``` r
count(x, Year)
```

    ## # A tibble: 5 x 2
    ##    Year     n
    ##   <int> <int>
    ## 1  2011     5
    ## 2  2012     5
    ## 3  2013     5
    ## 4  2014     5
    ## 5  2015     5

-   What are the unique values of the ID column and how many observations per (Hint: ?dplyr::n())
-   Sort the result from the previous step in descending order (Hint: ?dplyr::arrange())
-   Change all the values of Status to 2 where Sex is Male using group\_by and mutate

#### Excercises part 2 (3 pts each)

``` r
xx <- data.frame(ID = rep(letters[1:5], each = 3),
                 Value = c(rnorm(14), NA),
                 Year = rep(c(2010:2012), 5))
```

-   What is the mean of Values for each ID

``` r
xx %>%
  group_by(ID) %>%
  summarise(
    Mu = mean(Value, na.rm = T)  
  )
```

    ## # A tibble: 5 x 2
    ##       ID         Mu
    ##   <fctr>      <dbl>
    ## 1      a -0.8395573
    ## 2      b  0.2521053
    ## 3      c -0.2229684
    ## 4      d  0.1953036
    ## 5      e -0.3045622

-   What is the mean of Value for each ID in 2011
-   What is the sum of Value by Year

Now, extend these examples to a spatial context.

### Part 3

I thought this was about spatial data!!! It is, but dplyr is a particularly good example of how you should interact with code. If we are going to be *programming* for GIS then we should be thinking about design, ease of use and the patterns we will use to design our code and workflows. Below we begin by simulating data, using dplyr like operations and ideals.

**Ideals**

1.  Simplify the problem to its smallest/simplest part
2.  Keep data long
3.  Write functions that do one thing
4.  Wrap simple solution in some form of loop

Imagine we want to simulate xy points for a number of individuals. Let's say we have 20 animals that we want to perform this procedure on, each animal has a different home range center. How do we proceed?

***Keep it simple and build up incrementally***

#### Simulate xy points for one individual

Simplify the problem to one individual and just worry about the first task, simulate xy data for an individual.

``` r
build_xy <- function(npts, center_x, noise_x, center_y, noise_y){
  #  Drawing from 2 independent normals assumes that individuals move in the x
  #   and y planes independently, seems reasonable

  xs <- rnorm(npts, center_x, noise_x)
  ys <- rnorm(npts, center_y, noise_y)
  
  out <- tibble::tibble(
    x = xs,
    y = ys
  )
  
return(out)
}
```

Nice and clean, no extra steps and useful in other projects, likely. This function simulates the xy data for a single individual and returns a tibble of x and y coordinates as class numeric.

You may be wondering why the above is not spatial. Spatial objects are a little harder to work with and often unnecessary. How about we hold off on being spatial as long as possible. Let's create some individuals and try our function. Below we will create a tibble with individual ID for 20 animals and to make the example more realistic why don't we vary the number of points for each inidividual.

``` r
ind_dat <- tibble::tibble(
  ID = 1:20,
  Npts = round(runif(20, 50, 100))
)

ind_dat
```

    ## # A tibble: 20 x 2
    ##       ID  Npts
    ##    <int> <dbl>
    ##  1     1    54
    ##  2     2    64
    ##  3     3    67
    ##  4     4    89
    ##  5     5    97
    ##  6     6    87
    ##  7     7    87
    ##  8     8    87
    ##  9     9    98
    ## 10    10    72
    ## 11    11    88
    ## 12    12    87
    ## 13    13    56
    ## 14    14    76
    ## 15    15    58
    ## 16    16    57
    ## 17    17    90
    ## 18    18    66
    ## 19    19    61
    ## 20    20    87

Each individual now has an ID and some number of points associated with it. Now we want to apply our function to create xy data to each individual.

``` r
ind_dat <- tibble::tibble(
  ID = 1:20,
  Npts = round(runif(20, 50, 100))
  ) %>%
  group_by(ID) %>%
  do(xy = build_xy(
    .$Npts, 
    center_x = -115, 
    noise_x = 2, 
    center_y = 45, 
    noise_y = 2
  ))

ind_dat
```

    ## Source: local data frame [20 x 2]
    ## Groups: <by row>
    ## 
    ## # A tibble: 20 x 2
    ##       ID                 xy
    ##  * <int>             <list>
    ##  1     1  <tibble [93 x 2]>
    ##  2     2  <tibble [96 x 2]>
    ##  3     3  <tibble [96 x 2]>
    ##  4     4  <tibble [90 x 2]>
    ##  5     5  <tibble [91 x 2]>
    ##  6     6 <tibble [100 x 2]>
    ##  7     7  <tibble [61 x 2]>
    ##  8     8  <tibble [53 x 2]>
    ##  9     9  <tibble [65 x 2]>
    ## 10    10  <tibble [88 x 2]>
    ## 11    11  <tibble [79 x 2]>
    ## 12    12  <tibble [54 x 2]>
    ## 13    13  <tibble [72 x 2]>
    ## 14    14  <tibble [78 x 2]>
    ## 15    15  <tibble [51 x 2]>
    ## 16    16  <tibble [80 x 2]>
    ## 17    17  <tibble [79 x 2]>
    ## 18    18  <tibble [76 x 2]>
    ## 19    19  <tibble [84 x 2]>
    ## 20    20  <tibble [92 x 2]>

#### Make data long

That was cool, but now we have this weird listcol *xy* and we would prefer to just have long data. Try tidyr::unnest...

``` r
ind_dat <- tibble::tibble(
  ID = 1:20,
  Npts = round(runif(20, 50, 100))
  ) %>%
  group_by(ID) %>%
  do(xy = build_xy(
    .$Npts, 
    center_x = -115, 
    noise_x = 2, 
    center_y = 45, 
    noise_y = 2
  )) %>%
  unnest

ind_dat
```

    ## # A tibble: 1,484 x 3
    ##       ID         x        y
    ##    <int>     <dbl>    <dbl>
    ##  1     1 -117.9024 49.00802
    ##  2     1 -116.5415 45.12276
    ##  3     1 -113.8572 46.03616
    ##  4     1 -114.0114 43.55863
    ##  5     1 -114.1586 41.27875
    ##  6     1 -114.7080 43.86735
    ##  7     1 -110.4709 45.58324
    ##  8     1 -115.6175 44.82738
    ##  9     1 -117.1609 46.27330
    ## 10     1 -114.0286 46.38805
    ## # ... with 1,474 more rows

Very cool, now we have long data and we have created data in a very simple and flexible fashion. How might we also build this to have a different home range (i.e. activity) center for each individual?

``` r
ind_dat <- tibble::tibble(
  ID = 1:20,
  Npts = round(runif(length(ID), 50, 100)),
  x_center = runif(length(ID), -120, -110),
  y_center = runif(length(ID), 40, 48)
  ) %>%
  group_by(ID, x_center, y_center) %>%
  do(xy = 
    build_xy(
      .$Npts, 
      center_x = .$x_center, 
      noise_x = 2, 
      center_y = .$y_center, 
      noise_y = 2
    )
  ) %>%
  unnest

ind_dat
```

    ## # A tibble: 1,455 x 5
    ##       ID  x_center y_center         x        y
    ##    <int>     <dbl>    <dbl>     <dbl>    <dbl>
    ##  1     1 -115.0953 43.30289 -116.0953 45.17671
    ##  2     1 -115.0953 43.30289 -116.2318 41.69516
    ##  3     1 -115.0953 43.30289 -118.4702 42.68340
    ##  4     1 -115.0953 43.30289 -114.6054 46.45707
    ##  5     1 -115.0953 43.30289 -115.0749 39.93164
    ##  6     1 -115.0953 43.30289 -114.0481 41.27973
    ##  7     1 -115.0953 43.30289 -116.1466 44.57237
    ##  8     1 -115.0953 43.30289 -116.3995 43.65304
    ##  9     1 -115.0953 43.30289 -113.8198 43.81599
    ## 10     1 -115.0953 43.30289 -117.0842 41.65583
    ## # ... with 1,445 more rows

We are using group\_by to sort of temporarily arrange data in chunks by ID. Another way to do this is using the purrr package and the map functions. These will likely be useful to you when stringing together several spatial operations and when working with lists. An example call to purr might look like:

``` r
mtcars %>%
  split(.$cyl) %>% # from base R
  map(~ lm(mpg ~ wt, data = .)) %>%
  map(summary)
```

    ## $`4`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -4.1513 -1.9795 -0.6272  1.9299  5.2523 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)   39.571      4.347   9.104 7.77e-06 ***
    ## wt            -5.647      1.850  -3.052   0.0137 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 3.332 on 9 degrees of freedom
    ## Multiple R-squared:  0.5086, Adjusted R-squared:  0.454 
    ## F-statistic: 9.316 on 1 and 9 DF,  p-value: 0.01374
    ## 
    ## 
    ## $`6`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Residuals:
    ##      Mazda RX4  Mazda RX4 Wag Hornet 4 Drive        Valiant       Merc 280 
    ##        -0.1250         0.5840         1.9292        -0.6897         0.3547 
    ##      Merc 280C   Ferrari Dino 
    ##        -1.0453        -1.0080 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)   
    ## (Intercept)   28.409      4.184   6.789  0.00105 **
    ## wt            -2.780      1.335  -2.083  0.09176 . 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.165 on 5 degrees of freedom
    ## Multiple R-squared:  0.4645, Adjusted R-squared:  0.3574 
    ## F-statistic: 4.337 on 1 and 5 DF,  p-value: 0.09176
    ## 
    ## 
    ## $`8`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2.1491 -1.4664 -0.8458  1.5711  3.7619 
    ## 
    ## Coefficients:
    ##             Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)  23.8680     3.0055   7.942 4.05e-06 ***
    ## wt           -2.1924     0.7392  -2.966   0.0118 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.024 on 12 degrees of freedom
    ## Multiple R-squared:  0.423,  Adjusted R-squared:  0.3749 
    ## F-statistic: 8.796 on 1 and 12 DF,  p-value: 0.01179

Instead of grouping the above code splits the data into a list by the column "cyl" and then fits a linear regression for each group and finally calls summary on the model fits. This workflow could work just as well for spatial data.

Check that each individual has a unique home range center by summarizing to the distinct values

``` r
ind_dat %>%
  group_by(ID) %>%
  distinct(x_center, y_center, .keep_all = F)
```

    ## # A tibble: 20 x 3
    ## # Groups:   ID [20]
    ##       ID  x_center y_center
    ##    <int>     <dbl>    <dbl>
    ##  1     1 -115.0953 43.30289
    ##  2     2 -119.4799 43.63657
    ##  3     3 -119.7606 46.18959
    ##  4     4 -116.3026 42.97501
    ##  5     5 -113.6979 47.40414
    ##  6     6 -111.6698 45.98204
    ##  7     7 -110.3428 40.84698
    ##  8     8 -118.0021 41.10094
    ##  9     9 -113.6662 46.83736
    ## 10    10 -114.6398 44.43339
    ## 11    11 -116.3914 47.55188
    ## 12    12 -117.3767 47.48251
    ## 13    13 -116.5864 46.03444
    ## 14    14 -116.9369 46.09071
    ## 15    15 -114.5748 40.57688
    ## 16    16 -112.7342 41.43013
    ## 17    17 -111.4364 45.92087
    ## 18    18 -113.4662 47.13700
    ## 19    19 -113.1832 42.25604
    ## 20    20 -116.3541 47.48449

Next we want to make our data spatial, let's build a function to make our data spatial. Again think about solving this problem for one individual, but in a fairly general way.

``` r
    hr_spdf <- function(x, id, prj){
      #  A function to create a spatial points data frame from a data.frame
      #  Takes a data frame containing coordinates of points defined by 
      #   x|longitude and y|latitude, the column of the id of the group and 
      #   a proj4string that defines the spatial projection
      #  Returns a spatial points data frame object
      #  See spatialreference.org for proj4string definitions
      
      out <-  
        sp::SpatialPointsDataFrame(
          select(x, 
            grep("^x$|^long", colnames(x), ignore.case = T),
            grep("^y$|^lat", colnames(x), ignore.case = T)),
          data = data.frame(ID = id),
          proj4string = CRS(prj)      
        )

    return(out)
    }
```

Let's try our function on one animal

``` r
tst_dat <- ind_dat %>%
  filter(ID == 1) %>%
  select(x, y, ID)

tst_sp <- hr_spdf(
  tst_dat, 
  id = dplyr::select(tst_dat, ID), 
  prj = '+proj=longlat +datum=WGS84'
)

tst_sp
```

    ## class       : SpatialPointsDataFrame 
    ## features    : 58 
    ## extent      : -118.9684, -111.1177, 39.93164, 48.56183  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 1
    ## names       : ID 
    ## min values  :  1 
    ## max values  :  1

Now if we want to apply our function to multiple animals we can just call our function.

``` r
multi_xy <- ind_dat %>%
  select(x, y, ID) %>%
  hr_spdf(
    id = .$ID,
    prj = '+proj=longlat +datum=WGS84'
  )

multi_xy
```

    ## class       : SpatialPointsDataFrame 
    ## features    : 1455 
    ## extent      : -124.5041, -105.5754, 35.02126, 53.10226  (xmin, xmax, ymin, ymax)
    ## coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 
    ## variables   : 1
    ## names       : ID 
    ## min values  :  1 
    ## max values  : 20

1.  Why did that last chunk of code work? Why didn't we have to call group\_by? How would the result have changed if we did call group\_by first? (5 points)
2.  Simulate data for 10 animals and add a randomly assigned sex to each individual. Make the males move more than females when simulating data. (5 points)
3.  Summarize the movements by calculating the mean of each sex to prove that your simulation code had the desired effect. (5 points)

*Please create a markdown document in the html format for submission. *
