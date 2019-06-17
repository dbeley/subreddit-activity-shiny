library("shinyWidgets")
library("shinythemes")

ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Subreddit live users count"),
  conditionalPanel("input.plot_type == 'base'",
                   plotOutput("subredditPlot", height = '550px')) ,
  conditionalPanel("input.plot_type == 'summary'",
                   plotOutput("meanplot", height = '550px')) ,
  fluidRow(
    hr(),
    helpText(
      "Data extracted with the help of github:dbeley/subreddit-tracker."
    ),
    column(
      2,
      radioButtons(
        "plot_type",
        label = h3("Graph type"),
        choices = list("Raw data" = 'base', "Summary" = 'summary'),
        selected = 'base'
      )
    ),
    column(3,
           h4("Subreddits"),
           uiOutput("subreddits_picker")),
    column(3,
           h4("Date"),
           uiOutput("date_input")),
    column(
      3,
      conditionalPanel(
        "input.plot_type == 'base'",
        h4("Smooth Lines"),
        checkboxInput("smoothing", label = "Enable smoothing", value =
                        FALSE),
        sliderInput(
          "smoothing_force",
          "Smoothing span:",
          min = 0.01,
          max = 0.2,
          value = 0.01,
          step = 0.005
        )
      ),
      conditionalPanel(
        "input.plot_type == 'summary'",
        h4("Summary"),
        radioButtons(
          "radiobut",
          label = "Summary Type",
          c(
            "Week Summary" = "WeekSummary",
            "Weekday" = "Weekday",
            "Day" = "Day",
            "Hour" = "Hour"
          )
        )
      )
    )
  )
)
