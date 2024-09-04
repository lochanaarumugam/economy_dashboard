# Include the common FRED functions
source("fred_utils.R")

# Set file path and series ID for Housing Market data (e.g., Housing Starts)
housing_market_data_file_path <- "data/housingMarket.RData"
housing_market_series_id <- "HOUST"  # Change this to another series if needed

# Load or update Housing Market data
housing_market_data <- load_or_update_fred_data(housing_market_series_id, housing_market_data_file_path)

# Ensure the data is in a format that ggplot2 can work with (data frame with Date and Value)
if (!is.null(housing_market_data)) {
  # Convert xts object to a data frame if necessary
  housing_market_df <- data.frame(
    Date = index(housing_market_data),
    HousingStarts = as.numeric(housing_market_data)
  )
  
  # Render the Housing Market chart using ggplot2 and ggplotly for interactivity
  output$housingMarketPlot <- renderPlotly({
    p <- ggplot(housing_market_df, aes(x = Date, y = HousingStarts)) +
      geom_line(color = "orange") +  # Line chart for Housing Market data
      labs(title = "Housing Starts",
           x = "Date",
           y = "Number of Housing Starts (in thousands)") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels for readability
    
    ggplotly(p)  # Convert ggplot to interactive plotly chart
  })
  
} else {
  output$housingMarketPlot <- renderText("No Housing Market data available")
}
