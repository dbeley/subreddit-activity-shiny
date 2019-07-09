# Install dependencies
source("dependencies.R")

library("RSQLite")
library("forcats")
library("ggplot2")
library("lubridate")
library("scales")
library("shinyWidgets")
library("shinythemes")
library("tibble")

source("load_data.R")
source("load_subreddits.R")

# Compare subreddits names in the database against the choices available in the UI
# sqlite
sub_dataset <- sqldf %>% select(Name) %>% collect() %>% unique() %>% deframe()
# csv
# sub_dataset <- unique(df$Name)

sub_list <- unlist(subreddits)
diff <- list(setdiff(sub_list, sub_dataset), setdiff(sub_dataset, sub_list))

# Only keep subreddits presents in the dataframe
subreddits <- lapply(subreddits, function(x) x[!x %in% diff[[1]]])
subreddits <- lapply(subreddits, function(x) x[!x %in% diff[[2]]])

theme_set(theme_minimal() + theme(text = element_text(size = 18)))

server <- function(input, output) {
  source("reactive_components.R", local = TRUE)
  output$subredditsPicker <- renderUI({
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
  
  output$dateInput <- renderUI({
    dateRangeInput(
      'dateRange',
      label = 'Choose a time range',
      start = Sys.Date() - 7,
      end = Sys.Date(),
      min = "2019-05-15",
      max = Sys.Date(),
      format = "dd/mm/yyyy",
      startview = 'week',
      language = 'fr',
      weekstart = 1
    )
  })
  
  output$subredditPlot <- renderPlot({
    df_subredditPlot_reactive_sqlite() %>%
    # df_subredditPlot_reactive_csv() %>%
      ggplot(aes(
        x = Date,
        y = Live_Users,
        colour = fct_reorder(Name, Live_Users, .desc = TRUE)
      )) +
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
      )) +
      plot_subredditPlot_reactive()
  })
  
  output$meanPlot <- renderPlot({
    plot_meanPlot_reactive()
  })
}

ui <- fluidPage(
  theme = shinytheme("flatly"),
  # theme = shinytheme("simplex"),
  titlePanel("Subreddit live users count"),
  helpText(
    "All dates values use the UTC+1 time zone."
  ),
  hr(),
  conditionalPanel(
    "input.plotType == 'base'",
    plotOutput("subredditPlot", height = '550px')
  ),
  conditionalPanel(
    "input.plotType == 'summary'",
    plotOutput("meanPlot", height = '550px')
  ),
  hr(),
  fluidRow(
    column(
      2,
      offset = '0.2',
      align = 'center',
      radioButtons(
        "plotType",
        label = h4("Graph type"),
        choices = list("Raw data" = 'base', "Summary" = 'summary'),
        selected = 'base'
      )
    ),
    column(3,
           h4("Subreddits"),
           uiOutput("subredditsPicker")),
    column(3,
           h4("Date"),
           uiOutput("dateInput")),
    column(
      3,
      conditionalPanel(
        "input.plotType == 'base'",
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
        "input.plotType == 'summary'",
        h4("Summary"),
        radioButtons(
          "summaryType",
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