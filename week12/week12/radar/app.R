library(shiny)
library(fmsb)

# Read the data
eafc_data <- read.csv("male_players.csv")

ui <- fluidPage(
  sidebarPanel(
  selectInput(
    inputId = "player_name",
    label = "Player:",
    choices = eafc_data$Name,
    selected = "Lionel Messi"
  )
))

# Create a main panel to display the radar chart
mainPanel(
  renderPlot({
    radarchart(selected_player())
    coord_polar(xlim = c(0, 100), ylim = c(0, 100))
    theme_bw()
    labs(title = "Radar Chart of FC24 Players", x = "Overall", y = "Attribute")
  })
)
server <- function(input, output) {
  

  
  # Create a reactive variable to store the selected player's data
  selected_player <- reactive({
    eafc_data %>%
      filter(Name == input$player_name) %>%
      select(Pace, Shooting, Passing, Dribbling, Defending, Physicality)
  })
  
  output$radarChart <- renderPlot({
    radarchart(selected_player())
    coord_polar(xlim = c(0, 100), ylim = c(0, 100))
    theme_bw()
    labs(title = "Radar Chart of FC24 Players", x = "Overall", y = "Attribute")
  })
}

shinyApp(ui = ui, server = server)
