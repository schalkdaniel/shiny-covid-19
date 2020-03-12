source("R/libs.R")
source("R/helper.R")

function(input, output, session) {


  covid_confirmed_raw = read.csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"))
  covid_deaths_raw = read.csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv"))
  covid_recovered_raw = read.csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv"))
  covid_confirmed = prepareCovidData(covid_confirmed_raw)
  covid_deaths = prepareCovidData(covid_deaths_raw)
  covid_recovered = prepareCovidData(covid_recovered_raw)

  covidSub = reactive({rbind(
    selectCovidData(covid_confirmed, input$country, input$date_start, "confirmed"),
    selectCovidData(covid_deaths, input$country, input$date_start, "deaths"),
    selectCovidData(covid_recovered, input$country, input$date_start, "recovered")
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
      ggtitle(paste0("Corona Progression in ", input$country)) +
      ggthemes::theme_tufte() +
      theme(text = element_text(size=20))

    plotly::ggplotly(gg)
  })

}
