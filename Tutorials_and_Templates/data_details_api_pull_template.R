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

load("~/myProfileWA.rda") # see the save_wa_essence_credentials.R script for instructions
load("~/myProfileNSSP.rda") # see the save_nssp_essence_credentials.R script for instructions

# params ----
start_date <- as.Date(Sys.Date()-30) # use Sys.Date() or "YYYY-MM-DD"
end_date <- as.Date(Sys.Date()) # use Sys.Date() or "YYYY-MM-DD"
url <- "https://essence2.syndromicsurveillance.org/nssp_essence/api/dataDetails?datasource=va_hosp&startDate=9Dec2025&medicalGroupingSystem=essencesyndromes&userId=5099&endDate=9Mar2026&percentParam=noPercent&hospFacilityType=emergency%20care&aqtTarget=DataDetails&ccddCategory=cdc%20broad%20acute%20respiratory%20dd%20v1&geographySystem=hospitalregion&detector=probrepswitch&timeResolution=daily&hasBeenE=1" # copy/paste directly from ESSENCE, date and field changes will happen in the next steps
## OPTIONAL specify data details fields ----
## use when you plan to only pull certain fields rather than the whole table
## see the ESSENCE data dictionary > ESSENCE API and Data Details tab > column B "API URL Name" 
## https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fwww.cdc.gov%2Fnssp%2Fbiosense%2Fdocs%2FNSSP-Data-Dictionary-508.xlsx&wdOrigin=BROWSELINK 
## comment out if you don't want to specify, below are some examples
## always pull C_BioSense_ID (or EssenceID) otherwise the API will dedup on the selected fields which will result in fewer visits than are actually in the ESSENCE result
select_fields <- c("C_BioSense_ID", "Date", "CCDDcategory_flat") # comma separated, each field in their own quotes
select_fields_url <- paste0("&field=",paste(select_fields, collapse = "&field=")) # do not edit here
if (exists("select_fields")) {
  if (str_detect(str_to_lower(select_fields_url), "c_biosense_id|essenceid")) {
    url_new <- paste0(url,select_fields_url)
  } else {
    print("Error: Unique visit ID (either C_BioSense_ID or EssenceID) not detected in select_fields. Please add one to avoid API deduplication bug.")
  }
} else {
  url_new <- url
}


# pull data ----
set_credentials(url_new)
data_raw <- Rnssp::get_essence_data(url_new, start_date = start_date, end_date = end_date)

# clean data ----
data <- data_raw %>% # add whatever cleaning/aggregating steps you need here
  mutate(Date = as.Date(Date, format = "%m/%d/%Y"), #reformat Date so R will treat it as a Date, give it the "old" format (mm/dd/YYYY, coded as %m/%d/%Y) so it knows how to read it to the Date format (YYYY-mm-dd)
         COVID = str_detect(CCDDcategory_flat, "CDC COVID-Specific DD v1"), # use the CCDDcategory_flat field to search for other CCDD categories the visit matched to
         Influenza = str_detect(CCDDcategory_flat, "CDC Influenza DD v1")) 
