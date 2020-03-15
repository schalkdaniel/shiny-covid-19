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



helper_sick = read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')
helper_sick$GDP..BILLIONS. = NULL
helper_sick$COUNTRY = as.character(helper_sick$COUNTRY)
helper_sick$COUNTRY[helper_sick$COUNTRY == "United States"] = "US"

covid_sick_max = covid_sick %>%
  group_by(Country.Region) %>%
  summarize(nbr = nbr[which.max(date)]) %>%
  left_join(helper_sick, by = c("Country.Region" = "COUNTRY"))

