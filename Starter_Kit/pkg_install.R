
    # A polite helper for installing packages

    please_install <- function(pkgs, install_fun = install.packages){
    
      if(length(pkgs) == 0){
        return(invisible())
      }
      
      if(!interactive()){
        stop("Please run in interactive session", call. = FALSE)
      }

      title <- paste0(
        "Ok to install these packges?\n",
        paste("* ", pkgs, collapse = "\n")
      )
      
      ok <- menu(c("Yes", "No"), title = title) == 1

      if(!ok){
        return(invisible())
      }

    install_fun(pkgs)
    }

################################################################################
    # Do you have all the needed packages?

    tidytools <- c(
      "covr", "devtools", "rlang", "roxygen2", "shiny", "testthat",
      "purrr", "repurrrsive", "rstudioapi", "usethis", "tidyverse",
      "sp", "rgdal", "raster", "sf", "leaflet", "tmap"
    )
    
    #  You have...
    have <- rownames(installed.packages())
    
    #  You need...
    needed <- setdiff(tidytools, have)

    #  Install what you need and only what you need
    please_install(needed)
################################################################################
    #  End