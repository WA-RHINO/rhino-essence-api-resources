# load packages, credentials, functions ----
## CRAN packages ----
library(dplyr)
library(stringr)
library(tidyr)
library(lubridate)
## GitHub packages and functions ----
library(Rnssp) # devtools::install_github("cdcgov/Rnssp")
### get_longterm_data() 
source("https://raw.githubusercontent.com/sara-chronister/synchron/refs/heads/main/R/get_longterm_data.R")
### detect_elements() provide a vector of terms/codes you want to search for, the field you want to search in, and an optional group name for if any of the terms are found, returns a data frame with a 0/1 variable for each term-field pairing plus the group name if included
source("https://raw.githubusercontent.com/sara-chronister/synchron/refs/heads/main/R/detect_elements.R")
source("https://raw.githubusercontent.com/WA-RHINO/rhino-essence-api-resources/refs/heads/main/Helper_Functions/set_myProfile.R")
source("https://raw.githubusercontent.com/WA-RHINO/rhino-essence-api-resources/refs/heads/main/Helper_Functions/select_dd_fields.R")

load("~/myProfileWA.rda") # see the save_wa_essence_credentials.R script for instructions
load("~/myProfileNSSP.rda") # see the save_nssp_essence_credentials.R script for instructions

# params ----
start_date <- as.Date(Sys.Date()-30) # use Sys.Date() or "YYYY-MM-DD"
end_date <- as.Date(Sys.Date()) # use Sys.Date() or "YYYY-MM-DD"
url <- "https://waessence.inductivehealth.com/ih_essence/api/dataDetails?datasource=va_hosp&startDate=1Aug2026&medicalGroupingSystem=essencesyndromes&userId=5099&csrfPreventionSalt=vfamY1Hbw3WEsDNTJ5Jv&endDate=30Oct2026&percentParam=noPercent&hospFacilityType=emergency%20care&aqtTarget=DataDetails&ccddCategory=cdc%20broad%20acute%20respiratory%20dd%20v1&geographySystem=hospital&detector=probrepswitch&timeResolution=daily&hasBeenE=1" # copy/paste directly from ESSENCE, date and field changes will happen in the next steps
## OPTIONAL select data details fields, comment out if you need all fields ----
url <- select_dd_fields(url, fields = c("Date", "CCDDcategory_flat")) # will automatically include C_BioSense_ID

# pull data ----
set_myProfile(url)
data_raw <- Rnssp::get_essence_data(url, start_date = start_date, end_date = end_date)

# clean data ----
data <- data_raw %>% # add whatever cleaning/aggregating steps you need here
  mutate(Date = as.Date(Date, format = "%m/%d/%Y"), #reformat Date so R will treat it as a Date, give it the "old" format (mm/dd/YYYY, coded as %m/%d/%Y) so it knows how to read it to the Date format (YYYY-mm-dd)
         COVID = str_detect(CCDDcategory_flat, "CDC COVID-Specific DD v1"), # use the CCDDcategory_flat field to search for other CCDD categories the visit matched to
         Influenza = str_detect(CCDDcategory_flat, "CDC Influenza DD v1")) 
