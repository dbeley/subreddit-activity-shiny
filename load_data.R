library("readr")
library("dplyr")
library("lubridate")

con <- DBI::dbConnect(RSQLite::SQLite(), "subreddit_tracker.db")
sqldf <- tbl(con, "measures")