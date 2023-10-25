#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

eafc_data <- read.csv("male_players.csv")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("search_query", "Search:")
    ),
    mainPanel(
      DT::dataTableOutput("search_result_table")
    )
  )
)

server <- function(input, output) {
  searchData <- reactive({
    result <- eafc_data[grep(input$search_query, eafc_data$"Name", ignore.case = TRUE), ]
    return(result)
  })
  
  output$search_result_table <- DT::renderDataTable({
    searchData()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
