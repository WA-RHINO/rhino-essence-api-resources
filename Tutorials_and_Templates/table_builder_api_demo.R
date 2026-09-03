# Table Builder APIs ----
# this is a quick example to see the difference between the CSV and JSON options and what percents look like

library(Rnssp) # devtools::install_github("cdcgov/Rnssp")
load("~/myProfileWA.rda") # see the save_wa_essence_credentials.R script for instructions
myProfile <- myProfileWA

# CSV ----
# Think of this as "wide" data

## Count ----
# The column names will be whatever filters you selected for your column field
url_csv_count <- "https://waessence.inductivehealth.com/ih_essence/api/tableBuilder/csv?datasource=va_hosp&startDate=16Jan2026&medicalGroupingSystem=essencesyndromes&userId=5099&endDate=16Apr2026&percentParam=noPercent&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20broad%20acute%20respiratory%20dd%20v1&ccddCategory=cdc%20covid-specific%20dd%20v1&ccddCategory=cdc%20influenza%20dd%20v1&ccddCategory=cdc%20respiratory%20syncytial%20virus%20dd%20v1&geographySystem=hospitalregion&detector=probrepswitch&timeResolution=daily&hasBeenE=1&rowFields=timeResolution&columnField=ccddCategory"
df_csv_count <- get_essence_data(url_csv_count)
View(df_csv_count)

## Percent ----
# The percentages will be where the column name are the selected filters for your column field
# The numerator for each will include the phrase "Data Count"
# The denominator for each will include the phrase "All Count"
url_csv_percent <- "https://waessence.inductivehealth.com/ih_essence/api/tableBuilder/csv?datasource=va_hosp&startDate=16Jan2026&medicalGroupingSystem=essencesyndromes&userId=5099&endDate=16Apr2026&percentParam=ccddCategory&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20broad%20acute%20respiratory%20dd%20v1&ccddCategory=cdc%20covid-specific%20dd%20v1&ccddCategory=cdc%20influenza%20dd%20v1&ccddCategory=cdc%20respiratory%20syncytial%20virus%20dd%20v1&geographySystem=hospitalregion&detector=probrepswitch&timeResolution=daily&hasBeenE=1&rowFields=timeResolution&columnField=ccddCategory"
df_csv_percent <- get_essence_data(url_csv_percent)
View(df_csv_percent)

# JSON ----
# Think of this as "long" data

## Count ----
# Your column field will be its own column here, filtered to what you filtered them to in your query
url_json_count <- "https://waessence.inductivehealth.com/ih_essence/api/tableBuilder?datasource=va_hosp&startDate=16Jan2026&medicalGroupingSystem=essencesyndromes&userId=5099&endDate=16Apr2026&percentParam=noPercent&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20broad%20acute%20respiratory%20dd%20v1&ccddCategory=cdc%20covid-specific%20dd%20v1&ccddCategory=cdc%20influenza%20dd%20v1&ccddCategory=cdc%20respiratory%20syncytial%20virus%20dd%20v1&geographySystem=hospitalregion&detector=probrepswitch&timeResolution=daily&hasBeenE=1&rowFields=timeResolution&columnField=ccddCategory"
df_json_count <- get_essence_data(url_json_count)
View(df_json_count)

## Percent ----
# Each row and column will appear twice, once with the field name, once with the field name and " raw"
# Counter intuitively, count=percent
# This is the more manageable way to work with the percent data
url_json_percent <- "https://waessence.inductivehealth.com/ih_essence/api/tableBuilder?datasource=va_hosp&startDate=16Jan2026&medicalGroupingSystem=essencesyndromes&userId=5099&endDate=16Apr2026&percentParam=ccddCategory&hospFacilityType=emergency%20care&aqtTarget=TableBuilder&ccddCategory=cdc%20broad%20acute%20respiratory%20dd%20v1&ccddCategory=cdc%20covid-specific%20dd%20v1&ccddCategory=cdc%20influenza%20dd%20v1&ccddCategory=cdc%20respiratory%20syncytial%20virus%20dd%20v1&geographySystem=hospitalregion&detector=probrepswitch&timeResolution=daily&hasBeenE=1&rowFields=timeResolution&columnField=ccddCategory"
df_json_percent <- get_essence_data(url_json_percent)
View(df_json_percent)
