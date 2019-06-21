

df_reactive <- reactive({
  df %>%
    filter(Name %in% input$subreddits) %>%
    filter(Date > input$dateRange[1] &
             Date <= (input$dateRange[2] + 1))
})

subredditPlot_reactive <- reactive({
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

df_meanPlot_reactive <- reactive({
  if (input$radiobut == "Weekday") {
    df_reactive() %>%
      group_by(Name, Weekday) %>%
      summarise(average = mean(Live.Users))
  }
  else if (input$radiobut == "Hour") {
    df_reactive() %>%
      group_by(Name, Hour) %>%
      summarise(average = mean(Live.Users))
  }
  else if (input$radiobut == "Day") {
    df_reactive() %>%
      group_by(Name, Day) %>%
      summarise(average = mean(Live.Users))
  }
  else if (input$radiobut == "WeekSummary") {
    df_reactive() %>%
      group_by(Name, Weekday, Hour) %>%
      summarise(average = mean(Live.Users))
  }
})

plot_meanPlot_reactive <- reactive({
  if (input$radiobut == "Weekday") {
      ggplot(don,
             aes(
               x = Weekday,
               y = average,
               group = Name,
               colour = fct_reorder(Name, average, .desc = TRUE)
             ))
  }
  else if (input$radiobut == "Hour") {
      ggplot(don, aes(
        x = Hour,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      ))
  }
  else if (input$radiobut == "Day") {
        ggplot(don, aes(
        x = Day,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      ))}
  else if (input$radiobut == "WeekSummary") {
    ggplot(don, aes(
      x = Hour,
      y = average,
      colour = fct_reorder(Name, average, .desc = TRUE)))
    }
})