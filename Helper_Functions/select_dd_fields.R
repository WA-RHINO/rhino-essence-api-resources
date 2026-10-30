# This function will modify the data details API to only include the fields included in the "fields" argument.
## see the ESSENCE data dictionary > ESSENCE API and Data Details tab > column B "API URL Name" 
## https://view.officeapps.live.com/op/view.aspx?src=https%3A%2F%2Fwww.cdc.gov%2Fnssp%2Fbiosense%2Fdocs%2FNSSP-Data-Dictionary-508.xlsx&wdOrigin=BROWSELINK 

# The default id_field is "C_BioSense_ID" and does not need to be specified when calling the function unless you want to use "EssenceID" instead. This is required otherwise the API will deduplicate the results only on the other fields pulled and return too few visits. 

select_dd_fields <- function(url, id_field = "C_BioSense_ID", fields = NULL) {
  
  if(str_detect(url, "dataDetails", negate = TRUE)) stop("incorrect API type, must be data details")
  
  select_fields <- c(id_field, fields) 
  select_fields_url <- paste0("&field=",paste(select_fields, collapse = "&field="))
  
  if (str_detect(str_to_lower(select_fields_url), "c_biosense_id|essenceid", negate = TRUE)) stop("unique visit ID (either C_BioSense_ID or EssenceID) not detected")
  
  url_new <- paste0(url,select_fields_url)
  return(url_new)
  
}

## Example:
# url <- "https://essence2.syndromicsurveillance.org/nssp_essence/api/dataDetails?datasource=va_hosp&startDate=9Dec2025&medicalGroupingSystem=essencesyndromes&userId=5099&endDate=9Mar2026&percentParam=noPercent&hospFacilityType=emergency%20care&aqtTarget=DataDetails&ccddCategory=cdc%20broad%20acute%20respiratory%20dd%20v1&geographySystem=hospitalregion&detector=probrepswitch&timeResolution=daily&hasBeenE=1" # copy/paste directly from ESSENCE, date and field changes will happen in the next steps
# 
# url_new <- select_dd_fields(url = url, fields = c("Date", "CCDDcategory_flat"))


