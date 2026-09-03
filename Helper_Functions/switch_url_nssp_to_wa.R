# This function was written to assist in the transition from NSSP-based API URLs to WA ESSENCE-based API URLs.
# There are only two arguments in the function:
#     - url: the NSSP API URL to convert to WA ESSENCE
#     - phi_datasource: defaults to FALSE; will only work if you have access to the PHI datasources in WA ESSENCE

#url <- "https://essence2.syndromicsurveillance.org/nssp_essence/api/dataDetails?datasource=va_hosp&startDate=01Oct25&filterDateRange=01Oct23&medicalGroupingSystem=essencesyndromes&userId=5099&sortDateRangeMax=01Oct23&dateconfig=18&filterDateRangeMax=01Oct23&endDate=25Oct25&percentParam=ccddCategory&hospFacilityType=emergency%20care&aqtTarget=TimeSeries&ccddCategory=cdc%20broad%20acute%20respiratory%20dd%20v1&ccddCategory=cdc%20covid-specific%20dd%20v1&ccddCategory=cdc%20influenza%20dd%20v1&ccddCategory=cdc%20respiratory%20syncytial%20virus%20dd%20v1&forceRefresh=true&geographySystem=hospital&detector=nodetectordetector&removeZeroSeries=True&timeResolution=weekly&hasBeenE=1&sortDateRange=01Oct23"

library(stringr)

switch_url_nssp_to_wa <- function(url, phi_datasource = FALSE) {
  
  # api_type <- str_extract(url, "(?<=api/).+(?=\\?)")
  datasource <- str_extract(url, "(?<=datasource=)(va_hosp|va_er)")
  if (is.na(datasource)) {
    print("Error: this datasource is not available in WA ESSENCE")
  } else if (phi_datasource==FALSE) {
    datasource_new <- datasource
  } else {
    datasource_new <- paste0(datasource,"_full")
  }
  
  if (!is.na(datasource)) {
    # update to WA ESSENCE instance
    url1 <- str_replace(url,"https://essence.syndromicsurveillance.org/nssp_essence|https://essence2.syndromicsurveillance.org/nssp_essence", "https://waessence.inductivehealth.com/ih_essence")
    # remove NSSP-designated site number
    url2 <- str_remove(url1, "Site=934&|site=934&")
    # remove NSSP-designated userId
    url3 <- str_remove(url2, "userId=[[:digit:]]+&")
    # remove state prefixes from regions
    url4 <- str_replace_all(url3,"geography=wa_|geography=WA_", "geography=")
    # update to PHI data source if indicated in function call
    url5 <- str_replace(url4, datasource, datasource_new)
    # if the datasource is patient location and WA residents were selected, use the new State Region filters bc there is no state filter
    if (datasource=="va_er") {
      url5 <- str_replace(url5, "geography=wa&|geography=WA&", "patientLocStateRegion=western%20wa&patientLocStateRegion=eastern%20wa&")
    } else{
      url5 <- url5
    }
  }
  
  
}




