## code to prepare `BOM_Warning` dataset goes here

bom_warning_string <-
   paste("The author of this function provides the code as is, and is free to",
   "use, but takes no responsibility for how this code is used and assumes the",
   "user has done their due diligence in understanding the copyright assigned to",
   "BOM weather data.",
   "Data is not to be used for third parties unless the user (you) is a",
   "registered user with The Bureau of Meterology.",
   "Read more at the BOM website: \n",
   "           http://www.bom.gov.au/other/copyright.shtml \n",
   "           http://reg.bom.gov.au/catalogue/data-feeds.shtml#obs-state \n",
   "           http://reg.bom.gov.au/other/disclaimer.shtml \n"
   )

usethis::use_data(bom_warning_string, overwrite = TRUE)
