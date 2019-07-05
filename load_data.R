con <- DBI::dbConnect(SQLite(), "subreddit_tracker.db")
sqldf <- tbl(con, "measures")