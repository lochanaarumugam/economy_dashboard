library(shinydashboard)
library(dygraphs)
library(plotly)
library(ggplot2)

ui <- dashboardPage(
  dashboardHeader(title = "Economic Indicator Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("GDP", tabName = "gdp", icon = icon("chart-line")),
      menuItem("Inflation", tabName = "inflation", icon = icon("tachometer-alt")),
      menuItem("(Un)Employment", tabName = "employment", icon = icon("user-friends")),
      menuItem("Interest Rates", tabName = "interest_rates", icon = icon("percent")),
      menuItem("Trade Balance", tabName = "trade", icon = icon("balance-scale")),
      menuItem("C/B Confidence", tabName = "confidence", icon = icon("smile")),
      menuItem("Housing Market", tabName = "housing_market", icon = icon("home")),
      menuItem("Government Debt", tabName = "government_debt", icon = icon("money-check-alt"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "gdp", fluidRow(box(title = "GDP", width = 12, dygraphOutput("gdpPlot")))),
      tabItem(tabName = "inflation", fluidRow(box(title = "Inflation", width = 12, plotlyOutput("inflationPlot")))),
      tabItem(tabName = "employment",
              fluidRow(
                box(title = "U-6 Unemployment Rate", width = 6, plotlyOutput("U6RATE")),
                box(title = "Long-Term Unemployment Rate", width = 6, plotlyOutput("UNRATE")),
                box(title = "Nonfarm Payroll Employment", width = 6, plotlyOutput("PAYEMS")),
                box(title = "Employment-Population Ratio", width = 6, plotlyOutput("EMRATIO")),
                box(title = "Average Hourly Earnings", width = 6, plotlyOutput("CES0500000003")),
                box(title = "Average Weekly Hours", width = 6, plotlyOutput("AWHNONAG")),
                box(title = "JOLTS Job Openings", width = 6, plotlyOutput("JTSJOL")),
                box(title = "Quits Rate", width = 6, plotlyOutput("JTSLDL")),
                box(title = "Labor Force Participation Rate", width = 6, plotlyOutput("CIVPART")),
                box(title = "Temporary Employment", width = 6, plotlyOutput("TEMPhELPS"))
              )
      ),
      tabItem(tabName = "interest_rates", fluidRow(box(title = "Interest Rates", width = 12, dygraphOutput("interestRatePlot")))),
      tabItem(tabName = "trade", fluidRow(box(title = "Trade Balance", width = 12, plotlyOutput("tradeBalancePlot")))),
      
      tabItem(tabName = "confidence", fluidRow(box(title = "Consumer/Business Confidence", width = 12, plotlyOutput("confidencePlot")))),
      tabItem(tabName = "housing_market", fluidRow(box(title = "Housing Market", width = 12, plotlyOutput("housingMarketPlot")))),
      tabItem(tabName = "government_debt", fluidRow(box(title = "Government Debt", width = 12, plotlyOutput("govtDebtPlot"))))
    )
  )
)