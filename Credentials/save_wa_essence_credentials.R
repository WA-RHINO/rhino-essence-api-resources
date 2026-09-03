# This script adapts the Rnssp credentials management to include the API token that is required for using the WA ESSENCE APIs
# Refer back to the email you received previously for the API information that will be asked for toward the end of this script

library(Rnssp)

# Alter credential creation to store and use API key
IHCredentials <- R6::R6Class(
  "NSSPCredentials",
  private = list(
    ..username = NSSPContainer$new(NULL),
    ..password = NSSPContainer$new(NULL),
    ..apikey = NSSPContainer$new(NULL),
    ..__ = NSSPContainer$new(stringi::stri_rand_strings(1, 1024, pattern = "[A-Za-z0-9*-+=/_$@.?!%|;:#~<>()[]\`\']"))
  ),
  public = list(
    initialize = function(username = NULL, password = NULL, apikey = NULL) {
      if (!missing(username)) {
        private$..username <- NSSPContainer$new(safer::encrypt_string(username, key = private$..__$value, ascii = FALSE))
      }
      if (!missing(password)) {
        private$..password <- NSSPContainer$new(safer::encrypt_string(password, key = private$..__$value, ascii = FALSE))
      }
      if (!missing(apikey)) {
        private$..apikey <- NSSPContainer$new(safer::encrypt_string(apikey, key = private$..__$value, ascii = FALSE))
      }
    },
    
    get_api_response = function(url) {
      if (is.null(private$..password$value)) {
        assertions::assert_string(url)
        res <- httr::GET(url)
      } else {
        assertions::assert_string(url)
        res <- url %>%
          httr::GET(., httr::authenticate(
            private$..username$value %>% safer::decrypt_string(., private$..__$value),
            private$..password$value %>% safer::decrypt_string(., private$..__$value)),
            httr::add_headers('api-key' = private$..apikey$value %>% safer::decrypt_string(., private$..__$value))
          )
      }
      res$request$options$userpwd <- ""
      cli::cli_alert_info(httr::http_status(res$status_code)$message)
      return(res)
    },
    
    get_api_data = function(url, fromCSV = FALSE, ...) {
      assertions::assert_string(url)
      apir <- self$get_api_response(url)
      if(apir$status_code == 200){
        if(any("data.frame" %in% class(httr::content(apir)))){
          return(httr::content(apir))
        }
        apir %>% {
          if (fromCSV) {
            httr::content(., by = "text/csv") %>% readr::read_csv(...)
          } else {
            httr::content(., as = "text") %>% jsonlite::fromJSON()
          }
        }
      }
    },
    
    get_api_graph = function(url, file_ext = ".png") {
      assertions::assert_string(url)
      graph <- tempfile(fileext = file_ext)
      apir <- url %>%
        httr::GET(., httr::authenticate(
          private$..username$value %>% safer::decrypt_string(., private$..__$value),
          private$..password$value %>% safer::decrypt_string(., private$..__$value)),
          httr::add_headers('api-key' = private$..apikey$value %>% safer::decrypt_string(., private$..__$value)), 
          httr::write_disk(graph, overwrite = TRUE))
      apir$request$options$userpwd <- ""
      cli::cli_alert_info(httr::http_status(apir$status_code)$message)
      list("api_response" = apir, "graph" = graph)
    }
  )
)

myProfileWA <- IHCredentials$new(username = askme("Enter your ESSENCE username: "),
                                 password = askme("Enter your API Password"),
                                 apikey = askme("Enter your ESSENCE API key: ")) 
save(myProfileWA, file = "~/myProfileWA.rda")