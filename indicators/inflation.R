source("fred_utils.R")

# Define a function to fetch Inflation data from FRED
fetch_inflation_data <- function() {
  message("Attempting to fetch CPI and PPI data from FRED...")
  
  # Fetching CPI data
  
  series_id <- "CPIAUCSL"
  cpi_data <- fetch_fred_data(series_id)
  
  # Fetching PPI data
  
  series_id <- "PPIACO"
  ppi_data <- fetch_fred_data(series_id)
  
  # Combine the data
  inflation_data <- list(CPI = cpi_data, PPI = ppi_data)
  return(inflation_data)
}

# Attempt to load or update the Inflation data
tryCatch({
  data_file_path <- "data/inflation.RData"
  if (file.exists(data_file_path) && file.size(data_file_path) > 0) {
    file_mod_time <- file.info(data_file_path)$mtime
    if (Sys.Date() - file_mod_time > 1) {  # Check if data is older than 1 day
      message("Inflation data is older than 1 day. Fetching new data...")
      inflation_data <- fetch_inflation_data()
      save(inflation_data, file = data_file_path)
    } else {
      load(data_file_path)
      message("Loaded Inflation data from inflation_data.RData")
    }
  } else {
    inflation_data <- fetch_inflation_data()
    save(inflation_data, file = data_file_path)
    message("Fetched and saved new CPI and PPI data.")
  }
}, error = function(e) {
  message("Error in loading or updating Inflation data: ", e$message)
})


# Render the Inflation plot using Plotly
output$inflationPlot <- renderPlotly({
  if (exists("inflation_data") && !is.null(inflation_data)) {
    
    # Convert CPI and PPI xts objects to data frames
    cpi_df <- data.frame(Date = index(inflation_data$CPI), Value = coredata(inflation_data$CPI))
    ppi_df <- data.frame(Date = index(inflation_data$PPI), Value = coredata(inflation_data$PPI))
    
    # Create the plot
    plot_ly() %>%
      add_lines(x = ~cpi_df$Date, y = ~cpi_df$Value, name = "CPI") %>%
      add_lines(x = ~ppi_df$Date, y = ~ppi_df$Value, name = "PPI") %>%
      layout(
        title = 'Inflation Rate (CPI and PPI)',
        xaxis = list(title = 'Year'),
        yaxis = list(title = 'Index')
      )
  } else {
    plot_ly() %>%
      layout(
        title = 'No Inflation data available',
        xaxis = list(title = 'Year'),
        yaxis = list(title = 'Index')
      )
  }
})
