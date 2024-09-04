library(shiny)
library(plotly)
library(httr)
library(jsonlite)
library(xts)
# Load the FRED API key from fred_key.txt
api_key <- readLines("fred_key.txt")[1]

# Define API key and URLs
base_url <- "https://api.stlouisfed.org/fred/series/observations?series_id="

# Function to fetch and save data
fetch_and_save_data <- function() {
  message("Attempting to fetch employment data from FRED...")
  
  series_ids <- c("U6RATE", "UNRATE", "LNS14000012", "PAYEMS", "EMRATIO", "CES0500000003", "AWHNONAG", "JTSJOL", "JTSLDL", "CIVPART", "TEMPhELPS")
  data_list <- lapply(series_ids, function(id) {
    url <- sprintf("https://api.stlouisfed.org/fred/series/observations?series_id=%s&api_key=%s&file_type=json", id, api_key)
    response <- fromJSON(url)
    data <- as.xts(as.numeric(response$observations$value), order.by = as.Date(response$observations$date, format="%Y-%m-%d"))
    if(any(is.na(data))) {
      print(paste(data_name, "contains NA values"))
    }
    return(data)
  })
  names(data_list) <- series_ids
  print(str(data_list))
  save(data_list, file = "data/employment.RData")
  return(data_list)
}

# Load or refetch data function
load_or_fetch_data <- function() {
  data_file_path <- "data/employment.RData"
  if (file.exists(data_file_path) && (Sys.Date() - file.info(data_file_path)$mtime <= 1)) {
    load(data_file_path)
    message("Loaded employment data from employment.RData.")
    
  } else {
    data_list <- fetch_and_save_data()
  }
  return(data_list)
}

# Loading and plotting data
data_list <- load_or_fetch_data()

output_names <- c("U6RATE", "UNRATE", "LNS14000012", "PAYEMS", "EMRATIO", "CES0500000003", "AWHNONAG", "JTSJOL", "JTSLDL", "CIVPART", "TEMPhELPS")
names(data_list) <- output_names
for (output_name in output_names) {
  local({  # Use `local` to capture the current value of output_name in each iteration
    output_name_local <- output_name  # Local copy of the loop variable

    if (output_name == "UNRATE") {
      output[[output_name_local]] <- renderPlotly({
        unemployment_data_local <- list(
          Overall = data_list[["UNRATE"]],
          Youth = data_list[["LNS14000012"]]
        )
        if (is.null(unemployment_data_local$Youth)) {
          message("Youth unemployment data is not available.")
          unemployment_data_local$Youth <- xts::xts(NA, order.by = Sys.Date())
        }
        overall_unrate_df <- data.frame(Date = index(unemployment_data_local$Overall), Value = coredata(unemployment_data_local$Overall))
        youth_unrate_df <- data.frame(Date = index(unemployment_data_local$Youth), Value = coredata(unemployment_data_local$Youth))
        
        # Create the plot
        plot_ly() %>%
          add_lines(x = ~overall_unrate_df$Date, y = ~overall_unrate_df$Value, name = "Overall Unemployment Rate") %>%
          add_lines(x = ~youth_unrate_df$Date, y = ~youth_unrate_df$Value, name = "Youth Unemployment Rate") %>%
          layout(
            title = 'Unemployment Rates',
            xaxis = list(title = 'Year'),
            yaxis = list(title = 'Percentage')
          )
      })
    }
    else if (output_name_local != "LNS14000012") {
      output[[output_name_local]] <- renderPlotly({
        data <- data_list[[output_name_local]]
        
        if (is.null(data) || nrow(data) == 0) {
          cat(paste("Data for", output_name_local, "is empty or NULL.\n"))
          return(NULL)
        }
        
        # Convert xts to data frame for Plotly
        df <- data.frame(Date = index(data), Value = coredata(data))
        
        plot_ly(df, x = ~Date, y = ~Value, type = 'scatter', mode = 'lines', name = output_name_local) %>%
          layout(title = output_name_local, xaxis = list(title = "Date"), yaxis = list(title = "Value"))
      })
    }
  
  })
}