# graphTypeInput <- function(id, label = "Graph Type") {
#   ns <- NS(id)
#   
#   radioButtons(
#     ns("plot_type"),
#     label = label,
#     choices = list("Raw data" = 'base', "Summary" = 'summary'),
#     selected = 'base'
#   )
# }
# 
# graphType <- function(input, output, session) {
#   
# }