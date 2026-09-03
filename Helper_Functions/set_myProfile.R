# This function is designed to automatically assigning the correct credentials whether the API is for WA ESSENCE or NSSP ESSENCE. 
# You must save and load your WA ESSENCE credentials as `myProfileWA.rda` (see the save_wa_essence_credentials.R script for instructions)
# You must save and load your NSSP ESSENCE credentials as `myProfileNSSP.rda` (see the save_nssp_essence_credentials.R script for instructions)

library(stringr)
load("~/myProfileNSSP.rda")
load("~/myProfileWA.rda")

set_myProfile <- function(api_url = url) {
  
  instance <- stringr::str_extract(api_url,"((?<=.com/)|(?<=.org/)).+(?=/api/)")
  myProfile <- switch (instance,
                       "ih_essence" = myProfileWA,
                       "nssp_essence" = myProfileNSSP
  )
  
  assign(x = "myProfile", value = myProfile, envir = .GlobalEnv)
  
}




