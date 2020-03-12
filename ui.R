fluidPage(theme = shinytheme("superhero"),
  headerPanel("Coronavirus COVID-19"),
  sidebarPanel(
    selectInput("country", "Country", sort(unique(covid_confirmed_raw$Country.Region)), selected = "Germany"),
    selectInput("date_start", "Start Date", sort(unique(covid_confirmed$date)), selected = min(covid_confirmed$date))
  ),
  mainPanel(
    plotly::plotlyOutput("covid_ts")
  )
)
