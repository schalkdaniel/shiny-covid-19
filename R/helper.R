prepareCovidData = function (covid_raw)
{
  covid_long = tidyr::gather(covid_raw, key = "date", value = "nbr", dplyr::starts_with("X"))
  covid_long$date = substring(covid_long$date, 2, nchar(covid_long$date))
  covid_long$date = as.Date(x = covid_long$date, format = "%m.%d.%y")

  return (covid_long)
}

selectCovidData = function (covid_long, country, date_start, date_end, type)
{
  if (country == "world") {
    tmp = covid_long
  } else {
    tmp = covid_long[covid_long$Country.Region == country,]
  }
  if (length(unique(covid_long$Country.Region)) > 1) {
    tmp = tmp %>% group_by(date) %>% summarize(Country.Region = Country.Region[1], nbr = sum(nbr))
  }
  tmp = tmp[(tmp$date >= date_start) & (tmp$date <= date_end),]
  tmp$type = type

  return (tmp)
}

covidGlobe = function (df)
{
  # Set country boundaries as light grey
  l = list(color = "white", width = 0.5)

  # Specify map projection and options
  g = list(
    showframe = FALSE,
    showcoastlines = FALSE,
    projection = list(type = 'orthographic'),
    resolution = '100',
    showcountries = TRUE,
    countrycolor = '#d1d1d1',
    showocean = TRUE,
#     oceancolor = '#c9d2e0',
    oceancolor = 'rgba(1,1,1,0.2)',
    showlakes = TRUE,
    lakecolor = '#99c0db',
    showrivers = FALSE,
    bgcolor = 'transparent'
  )

  p = plot_geo(df, width = 800, height = 800) %>%
    add_trace(
      z = ~nbr,
      color = ~nbr,
      colors = 'Reds',
      text = ~Country.Region,
      locations = ~CODE,
      marker = list(line = l),
      showscale = FALSE) %>%
    colorbar(title = 'Currently Infected') %>%
    layout(
      title = '',
      geo = g,
      plot_bgcolor = 'transparent',
      paper_bgcolor = 'transparent'
    ) %>%
    config(displayModeBar = FALSE)

  return (p)
}
