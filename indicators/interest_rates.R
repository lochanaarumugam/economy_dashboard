
source("fred_utils.R")

# Define a function to fetch Inflation data from FRED
fetch_interest_rate <- function() {
  message("Attempting to fetch Interest Rates data from FRED...")
  # Fetching Federal Funds Rate data
  
  series_id <- "DFF"
  fed_funds_data <- fetch_fred_data(series_id)
  
  # Fetching 10-Year Treasury Yield data
  
  series_id <- "GS10"
  treasury_yield_data <- fetch_fred_data(series_id)
  
  # Combine and return the data
  interest_rates_data <- cbind(FedFunds = fed_funds_data, TreasuryYield = treasury_yield_data)
  return(interest_rates_data)
}

# Attempt to load or update data
tryCatch({
  data_file_path <- "data/interest_rates.RData"
  if (file.exists(data_file_path) && file.size(data_file_path) > 0) {
    file_mod_time <- file.info(data_file_path)$mtime
    if (Sys.Date() - file_mod_time > 1) {  
      message("Data is older than a day. Fetching new data...")
      interest_rates_data <- fetch_interest_rate()
      save(interest_rates_data, file = data_file_path)
    } else {
      load(data_file_path)
      message("Loaded Interest Rates data from interest_rates.RData.")
    }
  } else {
    interest_rates_data <- fetch_interest_rate()
    save(interest_rates_data, file = data_file_path)
    message("Fetched and saved new Interest Rates data.")
  }
}, error = function(e) {
  message("Error in loading or updating data: ", e$message)
})


# Render the Interest Rates plot with monthly data
output$interestRatePlot <- renderDygraph({

  dygraph(interest_rates_data, main = "Interest Rates (Monthly)") %>%
    dySeries("FedFunds", label = "Federal Funds Rate") %>%
    dySeries("TreasuryYield", label = "10-Year Treasury Yield") %>%
    dyOptions(colors = c("blue", "red")) %>%
    dyAxis("x", drawGrid = FALSE, axisLabelFormatter = 'function(d) {
            var date = new Date(d);
            return date.getFullYear() + "-" + ("0" + (date.getMonth() + 1)).slice(-2);
          }')

})