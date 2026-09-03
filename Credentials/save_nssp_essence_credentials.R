# This script is useful if you need to save and/or update your NSSP credentials and want to save it as "myProfileNSSP" instead of the default "myProfile" for use with the `set_credentials` function
# Remember to use your NSSP credentials here
library(Rnssp)

myProfileNSSP <- Rnssp::create_profile()
save(myProfileNSSP, file = "~/myProfileNSSP.rda")