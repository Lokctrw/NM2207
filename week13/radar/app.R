library(shiny)
library(fmsb)
library(tidyverse)

eafc_data <- read.csv("male_players.csv") %>% select(Name, Nation, Club, Position, Overall, Pace, Shooting, Passing, Dribbling, Defending, Physicality)

# Define UI
ui <- fluidPage(
  titlePanel("Radar Chart of FC24 Players"),
  sidebarLayout(
    sidebarPanel(
      numericInput("player_number", "Player Number:", value = 12, min = 1, max = 15849),
      downloadButton("download_chart", "Download chart"),
    ),
    mainPanel(
      plotOutput("radarChart"),
    )
  )
)

# Define server
server <- function(input, output) {
  
  scores <- data.frame(
    row.names = c(eafc_data$X),
    Pace = c(eafc_data$Pace),
    Shooting = c(eafc_data$Shooting),
    Passing = c(eafc_data$Passing),
    Dribbling = c(eafc_data$Dribbling),
    Defending = c(eafc_data$Defending),
    Physicality = c(eafc_data$Physicality)
  )
  
  max_min <- data.frame(
    Pace = c(100, 0), Shooting = c(100, 0), Passing = c(100, 0),
    Dribbling = c(100, 0), Defending = c(100, 0), Physicality = c(100, 0)
  )
  
  rownames(max_min) <- c("Max", "Min")
  
  df <- rbind(max_min, scores)
  
  output$radarChart <- renderPlot({
    player_num <- input$player_number
    
    player_radarchart <- df[c("Max", "Min", as.character(player_num)), ]
    
    radarchart(
      player_radarchart,
      pcol = "purple", pfcol = scales::alpha("blue", 0.5), plwd = 2, plty = 1,
      cglcol = "grey", cglty = 2, cglwd = 2,
      title = "Player's Rating"
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
