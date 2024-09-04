source("fred_utils.R")

# Define a function to fetch Government Debt data from FRED
fetch_govt_debt_data <- function() {
  message("Attempting to fetch Government Debt data from FRED...")
  
  # Fetching Total Public Debt
  series_id <- "GFDEBTN"
  total_debt_data <- fetch_fred_data(series_id)
  
  # Fetching Debt Held by the Public
  series_id <- "FYGFDPUN"
  public_debt_data <- fetch_fred_data(series_id)
  
  # Fetching Debt to GDP Ratio
  series_id <- "GFDEGDQ188S"
  debt_gdp_data <- fetch_fred_data(series_id)
  
  # Combine the data into a list
  govt_debt_data <- list(
    TotalDebt = total_debt_data,
    PublicDebt = public_debt_data,
    DebtToGDP = debt_gdp_data
  )
  
  return(govt_debt_data)
}

# Attempt to load or update the Government Debt data
tryCatch({
  data_file_path <- "data/govtDebt.RData"
  if (file.exists(data_file_path) && file.size(data_file_path) > 0) {
    file_mod_time <- file.info(data_file_path)$mtime
    if (Sys.Date() - file_mod_time > 1) {  # Check if data is older than 1 day
      message("Government Debt data is older than 1 day. Fetching new data...")
      govt_debt_data <- fetch_govt_debt_data()
      save(govt_debt_data, file = data_file_path)
    } else {
      load(data_file_path)
      message("Loaded Government Debt data from govtDebt.RData")
    }
  } else {
    govt_debt_data <- fetch_govt_debt_data()
    save(govt_debt_data, file = data_file_path)
    message("Fetched and saved new Government Debt data.")
  }
}, error = function(e) {
  message("Error in loading or updating Government Debt data: ", e$message)
})
# Render the Government Debt plot using Plotly
output$govtDebtPlot <- renderPlotly({
  if (exists("govt_debt_data") && !is.null(govt_debt_data)) {
    
    # Convert each xts object to a data frame
    total_debt_df <- data.frame(Date = index(govt_debt_data$TotalDebt), Value = coredata(govt_debt_data$TotalDebt) / 1e6)  # Convert to trillions
    public_debt_df <- data.frame(Date = index(govt_debt_data$PublicDebt), Value = coredata(govt_debt_data$PublicDebt) / 1e6)  # Convert to trillions
    debt_gdp_df <- data.frame(Date = index(govt_debt_data$DebtToGDP), Value = coredata(govt_debt_data$DebtToGDP))  # Percentage, no conversion
    
    # Create the plot with multiple series
    plot_ly() %>%
      add_lines(x = ~total_debt_df$Date, y = ~total_debt_df$Value, name = "Total Public Debt (Trillions)", line = list(color = 'purple')) %>%
      add_lines(x = ~public_debt_df$Date, y = ~public_debt_df$Value, name = "Public Debt (Trillions)", line = list(color = 'orange')) %>%
      add_lines(x = ~debt_gdp_df$Date, y = ~debt_gdp_df$Value, name = "Debt to GDP Ratio (%)", line = list(color = 'blue', dash = 'dash')) %>%
      layout(
        title = 'Government Debt: Total Public Debt, Public Debt, and Debt to GDP Ratio',
        xaxis = list(title = 'Year'),
        yaxis = list(title = 'Debt (Trillions of Dollars)', overlaying = 'y'),
        yaxis2 = list(title = 'Debt to GDP Ratio (%)', side = 'right', overlaying = 'y')
      )
  } else {
    plot_ly() %>%
      layout(
        title = 'No Government Debt data available',
        xaxis = list(title = 'Year'),
        yaxis = list(title = 'Debt (Trillions of Dollars)')
      )
  }
})
