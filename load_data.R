library("readr")
library("dplyr")
library("lubridate")

df <- read.csv2("subreddits_subscribers_count.csv", sep = ',')
df <- df %>%
  mutate(
    Live.Users = as.integer(as.character(Live.Users)),
    Name = as.character(Name),
    Date = as.POSIXct(Date)
  ) %>%
  filter(Live.Users > 0) %>%
  filter(Date >= "2019-05-01") %>%
  mutate(
    Hour = hour(Date),
    Day = day(Date),
    Weekday = factor(
      weekdays(Date),
      levels = c(
        'lundi',
        'mardi',
        'mercredi',
        'jeudi',
        'vendredi',
        'samedi',
        'dimanche'
      )
    )
  )
