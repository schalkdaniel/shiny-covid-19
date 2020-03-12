prepareCovidData = function (covid_raw)
{
  covid_long = tidyr::gather(covid_raw, key = "date", value = "nbr", dplyr::starts_with("X"))
  covid_long$date = substring(covid_long$date, 2, nchar(covid_long$date))
  covid_long$date = as.Date(x = covid_long$date, format = "%m.%d.%y")

  return (covid_long)
}

selectCovidData = function (covid_long, country, date_start, type)
{
  tmp = covid_long[covid_long$Country.Region == country,]
  if (length(unique(covid_long$Country.Region)) > 1) {
    tmp = tmp %>% group_by(date) %>% summarize(Country.Region = Country.Region[1], nbr = sum(nbr))
  }
  tmp = tmp[tmp$date >= date_start,]
  tmp$type = type

  return (tmp)
}
