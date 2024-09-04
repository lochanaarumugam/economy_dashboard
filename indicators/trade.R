library(jsonlite)
library(ggplot2)

# Include the common FRED functions
source("fred_utils.R")

# Set file path for Trade Balance data
trade_balance_data_file_path <- "data/tradeBalance.RData"
trade_balance_series_id <- "BOPGSTB"

# Load or update Trade Balance data
trade_balance_data <- load_or_update_fred_data(trade_balance_series_id, trade_balance_data_file_path)
trade_balance_df <- data.frame(
  Date = index(trade_balance_data),
  TradeBalance = as.numeric(trade_balance_data)
)

output$tradeBalancePlot <- renderPlotly({
  # Convert Trade Balance from millions to billions
  trade_balance_df$TradeBalance <- trade_balance_df$TradeBalance / 1000
  
  p <- ggplot(trade_balance_df, aes(x = Date, y = TradeBalance, fill = TradeBalance > 0)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = c("red", "green"), labels = c("Deficit", "Surplus")) +  # Custom fill colors
    labs(title = "Trade Balance: Goods and Services",
         x = "Date",
         y = "Trade Balance (Billions of Dollars)") +  # Updated label to show 'Billions'
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels for readability
  
  ggplotly(p)  # Convert ggplot to interactive plotly chart
})
