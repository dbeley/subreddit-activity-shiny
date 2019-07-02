list_of_packages = c(
  "tidyverse",
  "lubridate",
  "scales",
  "shinyWidgets",
  "shinythemes",
  "readr",
  "dplyr",
  "lubridate",
  "dbplyr",
  "RSQLite"
)

lapply(list_of_packages,
       function(x)
         if (!require(x, character.only = TRUE))
           install.packages(x))