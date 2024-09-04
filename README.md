
# Economic Indicators Dashboard

This R Shiny application provides a comprehensive dashboard to explore various economic indicators such as GDP, inflation rates, employment statistics, interest rates, trade balances, consumer and business confidence, housing market data, and government debt levels. The dashboard utilizes several powerful visualization libraries to present the data in an interactive and user-friendly format.

## Features

  1. **Interactive Charts**: Leveraging dygraphs and plotly for dynamic data visualization.
  2. **Comprehensive Economic Metrics**: Tabs for GDP, inflation, employment statistics, and more..
  3. **User-Friendly Interface**: Built with shinydashboard for a clean layout and easy navigation.
  

## Requirements

To run the app locally, the following libraries and dependencies must be installed:

- `shiny`
- `dplyr`
- `ggplot2`
- `FactoMineR`
- `factoextra`
- `cluster`
- `tidyr`
- `plotly`
- `ggdendro`
- `scales`
- `xts`

You can install the necessary R packages by running:

```R
install.packages(c("shiny", "dplyr", "ggplot2", "FactoMineR", "factoextra", "cluster", "tidyr", "plotly", "ggdendro", "scales", "xts"))
```

## Data Source

The economic data is sourced from the **Federal Reserve Economic Data (FRED)** system using the `load_or_update_fred_data()` function. The app expects the data files to be stored locally in the `data/` folder and loaded using the FRED series IDs.

Ensure that the `fred_utils.R` script is available to handle data loading from FRED.

## Usage

### Running the App Locally

To run the Shiny app locally, follow these steps:

1. Clone or download this repository to your local machine.
2. Ensure that all necessary libraries are installed.
3. Place the economic data in the `data/` directory as expected by the app.
4. Source the `fred_utils.R` file to allow for data loading and updating.
5. Run the app by executing the following in your R console:

```R
shiny::runApp('path/to/your/app/folder')
```


## Project Structure

```
.
├── data/                   # Folder containing the local data files (e.g., gdp.RData, inflation.RData)
├── fred_utils.R            # Helper script for loading or updating data from FRED
├── ui.R                    # Main Shiny UI script
├── server.R                # Main Shiny server script
├── README.md               # This README file
```
You have to create an APIKey with FRED and update the "fred_key.txt" file.

## License

© Lochana Arumugam, 2024. All rights reserved. This project is intended for personal or academic use only. Commercial use or redistribution is prohibited without explicit permission.

## Author

- **Lochana Arumugam**  
Feel free to reach out for questions, suggestions, or collaboration opportunities.
