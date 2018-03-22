		#  Spatial Points Data Frame - Example
		#  Josh Nowak
		#  08/2015
################################################################################
		#  Load packages
		require(sp)
		require(rgdal)
		require(dplyr)
################################################################################
		#  Simulate some data
		xy_dat <- data.frame(ID = 1:10,
								Year = sample(2012:2014, 10, replace = T),
								y = runif(10, 44, 47),
								x = runif(10, -117, -115))
								
		#  Real data is messy, so let's insert an NA and change one coordinate 
		#  to some unrealistic number
		xy_dat$x[3] <- NA
		xy_dat$y[5] <- 400
			
################################################################################
		#  Define projection
		#  To find the definitions go to http://spatialreference.org/
		#  The definition we need is called a proj4string, in the case of WGS84
		#  we can just write
		
		p4s <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
		
		#  Note the above is giving the details of each projection parameter 
		#  just like in ArcGIS
		
		#  The character representation of the projection is not quite enough,
		#  it needs to be of class CRS and we do that with the CRS function
		#  CRS = Coordinate Reference System
		p4s_crs <- CRS(p4s)
		
		#  Before we can create our spatial object we have to be sure that 
		#  there are no NA's in the x or y coordinates and that the coordinates
		#  are reasonable
		
		#  Filter out the na values in x and y
		xy <- xy_dat %>% filter(!is.na(x) & !is.na(y))
		
		#  To filter based on reasonable values I typically go to Google Earth 
		#  and manually find the values, but if you have a reference shapfile
		#  for the study area you can get the xmin, xmax, ymin and ymax using
		#  the bbox function.  
		#  In this case let's say our study area is within -117:-115 and 44:47
		
		xy_sub <- xy %>% filter((x > -117 & x < -115) & (y > 44 & y < 47))
		
		#  At this point we need our data to be a data.frame and the classes of
		#  the columns should not be POSIX*...simple classes only (e.g. numeric,
		#  character)
		dat_df <- xy_sub %>% select(ID, Year) %>% as.data.frame()
		
		#  Now because we are breaking everything into little pieces, we should
		#  create an object holding the x and y values, must be a matrix
		xy <- xy_sub %>% select(x, y) %>% as.matrix()
		
		#  And now build the spatial object
		xy_sp <- SpatialPointsDataFrame(xy, proj4string = p4s_crs, 
			data = dat_df)
			
################################################################################
		#  End
		
		