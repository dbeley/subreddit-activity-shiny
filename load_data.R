# sqlite backend
# con <- DBI::dbConnect(SQLite(), "subreddit_tracker.db")
con <- DBI::dbConnect(SQLite(), "/home/david/Disque500Go2/Données/subreddit_tracker.db")
sqldf <- tbl(con, "measures")

# csv backend
# df <- read.csv2("subreddits_subscribers_count.csv", sep = ',')
# df <- df %>%
#   mutate(
#     Live_Users = as.integer(as.character(Live_Users)),
#     Name = as.character(Name),
#     Date = as.POSIXct(Date)
#   ) %>%
#   filter(Live_Users > 0) %>%
#   filter(Date >= "2019-05-01") %>%
#   mutate(
#     Hour = hour(Date),
#     Day = day(Date),
#     Weekday = factor(
#       weekdays(Date),
#       levels = c(
#         'lundi',
#         'mardi',
#         'mercredi',
#         'jeudi',
#         'vendredi',
#         'samedi',
#         'dimanche'
#       )
#     )
#   )