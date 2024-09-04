# app.R
library(shiny)
library(shinydashboard)

# Source the UI and Server components
source("ui.R")
source("server.R")

# Run the Shiny App
shinyApp(ui = ui, server = server)
