source("R/libs.R")
source("R/helper.R")
source("R/data.R")

server = function(input, output, session) {

  covidSub = reactive({rbind(
    selectCovidData(covid_confirmed, input$country, input$date_start, input$date_end, "confirmed"),
    selectCovidData(covid_deaths, input$country, input$date_start, input$date_end, "deaths"),
#     selectCovidData(covid_recovered, input$country, input$date_start, input$date_end,  "recovered"),
    selectCovidData(covid_estimated, input$country, input$date_start, input$date_end, "estimated based on deaths"),
    selectCovidData(covid_sick, input$country, input$date_start, input$date_end, "currently sick")
  )})

  output$covid_globe = renderPlotly({
    covidGlobe(covid_sick_max)
  })

  output$covid_ts = renderPlotly({
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

    ggplotly(gg)
  })
}


ui = fluidPage(theme = shinythemes::shinytheme("superhero"),
  headerPanel("Coronavirus COVID-19"),

  mainPanel(
    fluidRow(
      plotly::plotlyOutput("covid_globe")
    ),
    fluidRow(
      column(width = 3,
        selectInput("country", "Country", c("World", as.character(sort(unique(covid_confirmed_raw$Country.Region)))), selected = "Germany"),
      ),
      column(width = 3,
        selectInput("date_start", "Start Date", sort(unique(covid_confirmed$date)), selected = min(covid_confirmed$date))
      ),
      column(width = 3,
        selectInput("date_end", "End Date", sort(unique(covid_confirmed$date)), selected = max(covid_confirmed$date))
      ),
      column(width = 12,
        plotly::plotlyOutput("covid_ts")
      )
    )
  )
)

shinyApp(ui = ui, server = server)
