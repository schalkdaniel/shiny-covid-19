source("R/libs.R")
source("R/helper.R")

covid_confirmed_raw = read.csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"))
covid_deaths_raw = read.csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv"))
covid_recovered_raw = read.csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv"))

mortality_rate = 3.4 / 100

covid_confirmed = prepareCovidData(covid_confirmed_raw)
covid_deaths = prepareCovidData(covid_deaths_raw)
covid_recovered = prepareCovidData(covid_recovered_raw)

covid_estimated = covid_deaths
covid_estimated$nbr = covid_estimated$nbr / mortality_rate

covid_sick = covid_confirmed
covid_sick$nbr = covid_sick$nbr - covid_recovered$nbr

server = function(input, output, session) {

  covidSub = reactive({rbind(
    selectCovidData(covid_confirmed, input$country, input$date_start, "confirmed"),
    selectCovidData(covid_deaths, input$country, input$date_start, "deaths"),
    selectCovidData(covid_recovered, input$country, input$date_start, "recovered"),
    selectCovidData(covid_estimated, input$country, input$date_start, "estimated based on deaths"),
    selectCovidData(covid_sick, input$country, input$date_start, "currently sick")
  )})

  output$covid_ts = plotly::renderPlotly({
    df = covidSub()
    gg = ggplot(data = df, aes(x = date, y = nbr, color = type)) +
      geom_point() +
      geom_line() +
      # geom_smooth() +
      xlab("") +
      ylab("") +
      ylim(0, max(df$nbr)) +
      labs(color = "") +
      ggtitle(label = paste0("Corona Progression in ", input$country)) +
      ggthemes::theme_tufte() +
      theme(text = element_text(size=20))

    plotly::ggplotly(gg)
  })
}


ui = fluidPage(theme = shinythemes::shinytheme("superhero"),
  headerPanel("Coronavirus COVID-19"),
  fluidRow(
    column(width = 3,
      selectInput("country", "Country", c("World", as.character(sort(unique(covid_confirmed_raw$Country.Region)))), selected = "Germany"),
    ),
    column(width = 3,
      selectInput("date_start", "Start Date", sort(unique(covid_confirmed$date)), selected = min(covid_confirmed$date))
    ),
  ),
  mainPanel(
    plotly::plotlyOutput("covid_ts")
  )
)

shinyApp(ui = ui, server = server)
