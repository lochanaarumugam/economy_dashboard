source("fred_utils.R")
gdp_data_file_path <- "data/gdp.RData"
gdp_series_id <- "GDP"

gdp_data <- load_or_update_fred_data(gdp_series_id, gdp_data_file_path)

# Render the GDP plot
output$gdpPlot <- renderDygraph({
  if (exists("gdp_data") && !is.null(gdp_data)) {
    dygraph(gdp_data, main = "Real GDP") %>%
      dyOptions(fillGraph = TRUE, colors = "blue")
  } else {
    dygraph(NULL, main = "No GDP data available") %>%
      dyOptions(colors = "red")
  }
})
