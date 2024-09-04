# Include the common FRED functions
source("fred_utils.R")

# Define a function to fetch Consumer and Business Confidence data from FRED
fetch_confidence_data <- function() {
  message("Attempting to fetch Consumer and Business Confidence data from FRED...")
  
  # Fetching Consumer Confidence data
  consumer_confidence_series_id <- "UMCSENT"
  consumer_confidence_data <- fetch_fred_data(consumer_confidence_series_id)
  
  # Fetching Business Confidence data
  business_confidence_series_id <- "BSCICP03USM665S"
  business_confidence_data <- fetch_fred_data(business_confidence_series_id)
  
  # Combine the data into a list
  confidence_data <- list(
    ConsumerConfidence = consumer_confidence_data,
    BusinessConfidence = business_confidence_data
  )
  
  return(confidence_data)
}

# Attempt to load or update the Consumer and Business Confidence data
tryCatch({
  data_file_path <- "data/confidenceData.RData"
  if (file.exists(data_file_path) && file.size(data_file_path) > 0) {
    file_mod_time <- file.info(data_file_path)$mtime
    if (Sys.Date() - file_mod_time > 1) {  # Check if data is older than 1 day
      message("Confidence data is older than 1 day. Fetching new data...")
      confidence_data <- fetch_confidence_data()
      save(confidence_data, file = data_file_path)
    } else {
      load(data_file_path)
      message("Loaded Consumer and Business Confidence data from confidenceData.RData")
    }
  } else {
    confidence_data <- fetch_confidence_data()
    save(confidence_data, file = data_file_path)
    message("Fetched and saved new Consumer and Business Confidence data.")
  }
}, error = function(e) {
  message("Error in loading or updating Confidence data: ", e$message)
})
# Render the Consumer and Business Confidence plot using Plotly
output$confidencePlot <- renderPlotly({
  if (exists("confidence_data") && !is.null(confidence_data)) {
    
    # Convert xts objects to data frames
    consumer_confidence_df <- data.frame(
      Date = index(confidence_data$ConsumerConfidence),
      ConsumerConfidence = coredata(confidence_data$ConsumerConfidence)
    )
    
    business_confidence_df <- data.frame(
      Date = index(confidence_data$BusinessConfidence),
      BusinessConfidence = coredata(confidence_data$BusinessConfidence)
    )
    
    # Merge the two data frames by Date for comparison on the same plot
    combined_df <- merge(consumer_confidence_df, business_confidence_df, by = "Date", all = TRUE)
    
    # Create the plot with multiple series
    plot_ly() %>%
      add_lines(x = ~combined_df$Date, y = ~combined_df$ConsumerConfidence, name = "Consumer Confidence", line = list(color = 'blue')) %>%
      add_lines(x = ~combined_df$Date, y = ~combined_df$BusinessConfidence, name = "Business Confidence", line = list(color = 'green')) %>%
      layout(
        title = 'Consumer and Business Confidence Indexes',
        xaxis = list(title = 'Year'),
        yaxis = list(title = 'Index')
      )
  } else {
    plot_ly() %>%
      layout(
        title = 'No Consumer or Business Confidence data available',
        xaxis = list(title = 'Year'),
        yaxis = list(title = 'Index')
      )
  }
})
