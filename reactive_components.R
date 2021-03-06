# df_subredditPlot_reactive_csv <- reactive({
#   df %>%
#     filter(Name %in% input$subreddits) %>%
#     filter(Date > input$dateRange[1] &
#              Date <= (input$dateRange[2] + 1))
# })
max_Date <- sqldf %>%
    select(Date) %>%
    collect() %>%
    top_n(1) %>%
    head(1) %>%
    mutate(Date = ymd(format(ymd_hm(Date), "%Y-%m-%d"))) %>%
    pull(Date)

df_subredditPlot_reactive_sqlite <- reactive({
  sqldf %>%
    filter(Name %in% !!input$subreddits) %>%
    filter(Date > !!input$dateRange[1] &
             Date <= !!(input$dateRange[2] + 1)) %>%
    collect() %>%
    
    mutate(Live_Users = as.integer(Live_Users),
          # Date = as.POSIXct(Date)) %>%
          Date = ymd_hm(Date),
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
            )))
})

plot_subredditPlot_reactive <- reactive({
  if (input$smoothing) {
    geom_smooth(
      size = 1.2,
      span = input$smoothing_force,
      se = FALSE,
      method = 'loess'
      # key_glyph=draw_key_label
    )
  }
  else {
    geom_line(size = 1.2, key_glyph = draw_key_label)
  }
})

plot_meanPlot_reactive <- reactive({
  if (input$summaryType == "Weekday") {
    ggplot(
      df_subredditPlot_reactive_sqlite() %>%
        group_by(Name, Weekday) %>%
        summarise(average = mean(Live_Users)),
      aes(
        x = Weekday,
        y = average,
        group = Name,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )
    ) +
      geom_line(size = 1.2, key_glyph = draw_key_label) +
      labs(y = "Average Live Users", colour = "Subreddits") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  }
  else if (input$summaryType == "Hour") {
    ggplot(
      df_subredditPlot_reactive_sqlite() %>%
        group_by(Name, Hour) %>%
        summarise(average = mean(Live_Users)),
      aes(
        x = Hour,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )
    ) +
      geom_line(size = 1.2, key_glyph = draw_key_label) +
      labs(y = "Average Live Users", colour = "Subreddits") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  }
  else if (input$summaryType == "Day") {
    ggplot(
      df_subredditPlot_reactive_sqlite() %>%
        group_by(Name, Day) %>%
        summarise(average = mean(Live_Users)),
      aes(
        x = Day,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )
    ) +
      geom_line(size = 1.2, key_glyph = draw_key_label) +
      labs(y = "Average Live Users", colour = "Subreddits") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  }
  else if (input$summaryType == "WeekSummary") {
    ggplot(
      df_subredditPlot_reactive_sqlite() %>%
        group_by(Name, Weekday, Hour) %>%
        summarise(average = mean(Live_Users)),
      aes(
        x = Hour,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )
    ) +
      geom_line(size = 1.2, key_glyph = draw_key_label) +
      labs(y = "Average Live Users", colour = "Subreddits") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))  +
      facet_grid( ~ Weekday)
  }
})