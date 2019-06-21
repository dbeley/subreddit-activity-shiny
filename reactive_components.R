df_subredditPlot_reactive <- reactive({
  df %>%
    filter(Name %in% input$subreddits) %>%
    filter(Date > input$dateRange[1] &
             Date <= (input$dateRange[2] + 1))
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
      df %>%
        filter(Name %in% input$subreddits) %>%
        filter(Date > input$dateRange[1] &
                 Date <= (input$dateRange[2] + 1)) %>%
        group_by(Name, Weekday) %>%
        summarise(average = mean(Live.Users)),
      aes(
        x = Weekday,
        y = average,
        group = Name,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )
    ) +
      geom_line(size = 1.2, key_glyph = draw_key_label) +
      ylab("Average Live Users") +
      labs(colour = "Subreddits") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  }
  else if (input$summaryType == "Hour") {
    ggplot(
      df %>%
        filter(Name %in% input$subreddits) %>%
        filter(Date > input$dateRange[1] &
                 Date <= (input$dateRange[2] + 1)) %>%
        group_by(Name, Hour) %>%
        summarise(average = mean(Live.Users)),
      aes(
        x = Hour,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )
    ) +
      geom_line(size = 1.2, key_glyph = draw_key_label) +
      ylab("Average Live Users") +
      labs(colour = "Subreddits") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  }
  else if (input$summaryType == "Day") {
    ggplot(
      df %>%
        filter(Name %in% input$subreddits) %>%
        filter(Date > input$dateRange[1] &
                 Date <= (input$dateRange[2] + 1)) %>%
        group_by(Name, Day) %>%
        summarise(average = mean(Live.Users)),
      aes(
        x = Day,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )
    ) +
      geom_line(size = 1.2, key_glyph = draw_key_label) +
      ylab("Average Live Users") +
      labs(colour = "Subreddits") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))
  }
  else if (input$summaryType == "WeekSummary") {
    ggplot(
      df %>%
        filter(Name %in% input$subreddits) %>%
        filter(Date > input$dateRange[1] &
                 Date <= (input$dateRange[2] + 1)) %>%
        group_by(Name, Weekday, Hour) %>%
        summarise(average = mean(Live.Users)),
      aes(
        x = Hour,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )
    ) +
      geom_line(size = 1.2, key_glyph = draw_key_label) +
      ylab("Average Live Users") +
      labs(colour = "Subreddits") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1))  +
      facet_grid( ~ Weekday)
  }
})