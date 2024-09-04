# server.R
library(shiny)
library(httr)
library(jsonlite)
library(xts)
library(dygraphs)
        
server <- function(input, output) {
  # Source individual indicator files
  source("indicators/gdp.R", local = TRUE)
  source("indicators/employment.R", local = TRUE)
  source("indicators/inflation.R", local = TRUE)
  source("indicators/interest_rates.R", local = TRUE)
  source("indicators/trade.R", local = TRUE)
  source("indicators/confidence.R", local = TRUE)
  source("indicators/housing_market.R", local = TRUE)
  source("indicators/government_debt.R", local = TRUE)
}
