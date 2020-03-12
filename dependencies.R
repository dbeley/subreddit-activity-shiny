list_of_packages = c(
  "RSQLite",
  # "dbplyr",
  "dplyr",
  "forcats",
  "ggplot2",
  "lubridate",
  "scales",
  "shiny",
  "shinyWidgets",
  "shinythemes",
  "tibble"
)

lapply(list_of_packages,
       function(x)
         if (!require(x, character.only = TRUE))
           install.packages(x))