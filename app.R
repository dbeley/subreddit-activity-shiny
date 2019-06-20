source("dependencies.R")
source("load_data.R")
source("load_subreddits.R")

# diff <- setdiff(unlist(subreddits), unique(df$Name))

library("tidyverse")
library('scales')
library("shinyWidgets")
library("shinythemes")

theme_set(theme_minimal() + theme(text = element_text(size = 18)))

server <- function(input, output) {
  output$subreddits_picker <- renderUI({
    pickerInput(
      inputId = "subreddits",
      label = "Select one or more",
      choices = subreddits,
      options = list(
        `actions-box` = TRUE,
        `live-search` = TRUE,
        size = 20
      ),
      multiple = TRUE,
      selected = c(
        "france",
        "de",
        "italy",
        "spain",
        "unitedkingdom",
        "belgium"
      )
    )
  })
  
  output$date_input <- renderUI({
    dateRangeInput(
      'dateRange',
      label = 'Choose a time range',
      start = Sys.Date() - 7,
      end = Sys.Date(),
      min = "2019-05-01",
      max = Sys.Date(),
      format = "dd/mm/yyyy",
      startview = 'week',
      language = 'fr',
      weekstart = 1
    )
  })
  output$subredditPlot <- renderPlot({
    if (input$smoothing) {
      df %>%
        filter(Name %in% input$subreddits) %>%
        filter(Date > input$dateRange[1] &
                 Date <= input$dateRange[2]) %>%
        ggplot(aes(
          x = Date,
          y = Live.Users,
          colour = fct_reorder(Name, Live.Users, .desc = TRUE)
        )) +
        ylab("Live Users") +
        labs(colour = "Subreddits") +
        theme(legend.position = "right") +
        theme(legend.key.height = unit(2, "line")) +
        geom_smooth(
          size = 1.2,
          span = input$smoothing_force,
          se = FALSE,
          method = 'loess'
          # key_glyph=draw_key_label
        ) +
        scale_x_datetime(breaks = pretty_breaks(20),
                         date_labels = "%a %d %b %H:%M") +
        theme(axis.text.x = element_text(
          angle = 25,
          vjust = 1.0,
          hjust = 1.0
        ))
    }
    else {
      df %>%
        filter(Name %in% input$subreddits) %>%
        filter(Date > input$dateRange[1] &
                 Date <= input$dateRange[2]) %>%
        ggplot(aes(
          x = Date,
          y = Live.Users,
          colour = fct_reorder(Name, Live.Users, .desc = TRUE)
        )) +
        geom_line(size = 1.2, key_glyph=draw_key_label) +
        ylab("Live Users") +
        labs(colour = "Subreddits") +
        theme(legend.position = "right") +
        theme(legend.key.height = unit(2, "line")) +
        scale_x_datetime(breaks = pretty_breaks(20),
                         date_labels = "%a %d %b %H:%M") +
        theme(axis.text.x = element_text(
          angle = 25,
          vjust = 1.0,
          hjust = 1.0
        ))
    }
  })
  
  output$meanplot <- renderPlot({
    if (input$radiobut == "Weekday") {
      don = df %>%
        filter(Name %in% input$subreddits) %>%
        filter(Date > input$dateRange[1] &
                 Date <= input$dateRange[2]) %>%
        group_by(Name, Weekday) %>%
        summarise(average = mean(Live.Users))
      
      ggplot(don,
             aes(
               x = Weekday,
               y = average,
               group = Name,
               colour = fct_reorder(Name, average, .desc = TRUE)
             )) +
        geom_line(size = 1.2, key_glyph=draw_key_label) +
        ylab("Average Live Users") +
        labs(colour = "Subreddits") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    }
    else if (input$radiobut == "Hour") {
      don = df %>%
        filter(Name %in% input$subreddits) %>%
        filter(Date > input$dateRange[1] &
                 Date <= input$dateRange[2]) %>%
        group_by(Name, Hour) %>%
        summarise(average = mean(Live.Users))
      
      ggplot(don, aes(
        x = Hour,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )) +
        geom_line(size = 1.2, key_glyph=draw_key_label) +
        ylab("Average Live Users") +
        labs(colour = "Subreddits") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    }
    else if (input$radiobut == "Day") {
      don = df %>%
        filter(Name %in% input$subreddits) %>%
        # filter(Name %in% c('france', 'de', 'italy')) %>%
        filter(Date > input$dateRange[1] &
                 Date <= input$dateRange[2]) %>%
        group_by(Name, Day) %>%
        summarise(average = mean(Live.Users))
      
      ggplot(don, aes(
        x = Day,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )) +
        geom_line(size = 1.2, key_glyph=draw_key_label) +
        ylab("Average Live Users") +
        labs(colour = "Subreddits") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))
    }
    else if (input$radiobut == "WeekSummary") {
      don = df %>%
        filter(Name %in% input$subreddits) %>%
        # filter(Name %in% c('france', 'de', 'italy')) %>%
        filter(Date > input$dateRange[1] &
                 Date <= input$dateRange[2]) %>%
        group_by(Name, Weekday, Hour) %>%
        summarise(average = mean(Live.Users))
      
      ggplot(don, aes(
        x = Hour,
        y = average,
        colour = fct_reorder(Name, average, .desc = TRUE)
      )) +
        geom_line(size = 1.2, key_glyph=draw_key_label) +
        ylab("Average Live Users") +
        labs(colour = "Subreddits") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1))  +
        facet_grid( ~ Weekday)
    }
  })
}

ui <- fluidPage(
  theme = shinytheme("flatly"),
  # theme = shinytheme("simplex"),
  titlePanel("Subreddit live users count"),
  helpText(
    "Data extracted with the help of github:dbeley/subreddit-tracker."
  ),
  hr(),
  conditionalPanel(
    "input.plot_type == 'base'",
    plotOutput("subredditPlot", height = '550px')
  ),
  conditionalPanel(
    "input.plot_type == 'summary'",
    plotOutput("meanplot", height = '550px')
  ),
  hr(),
  fluidRow(
    column(
      2,
      offset = '0.2',
      align = 'center',
      # graphTypeInput("plot_type")
      radioButtons(
        "plot_type",
        label = h4("Graph type"),
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
            "Day of the Month" = "Day",
            "Hour" = "Hour"
          )
        )
      )
    )
  )
)

shinyApp(ui = ui, server = server)