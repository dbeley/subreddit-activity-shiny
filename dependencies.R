list_of_packages = c(
  "RSQLite",
  "dbplyr",
  "dplyr",
  "lubridate",
  "lubridate",
  "readr",
  "scales",
  "shinyWidgets",
  "shinythemes",
  "tidyverse"
)

lapply(list_of_packages,
       function(x)
         if (!require(x, character.only = TRUE))
           install.packages(x))