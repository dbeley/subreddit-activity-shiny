list_of_packages = c(
  "shiny",
  "shinyWidgets",
  "shinythemes",
  "RSQLite",
  "dbplyr",
  "dplyr",
  "lubridate",
  "scales",
  "ggplot2",
  "forcats"
)

lapply(list_of_packages,
       function(x)
         if (!require(x, character.only = TRUE))
           install.packages(x))