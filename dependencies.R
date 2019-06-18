list_of_packages = c(
  "tidyverse",
  "lubridate",
  "scales",
  "shinyWidgets",
  "shinythemes",
  "readr",
  "dplyr",
  "lubridate"
)

lapply(list_of_packages,
       function(x)
         if (!require(x, character.only = TRUE))
           install.packages(x))
