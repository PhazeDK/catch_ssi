if(!exists('load_data_R')){
  library(rjson)
  library(jsonlite)
  library(tidyverse)
  library(lubridate)
  
  dk_map <- rjson::fromJSON(file="https://raw.githubusercontent.com/moestrup/covid19/master/test.json")
  
  kommuneareal <- read.csv(url("https://raw.githubusercontent.com/PhazeDK/catch3/master/data/kommuneareal.csv"),
                           encoding="UTF-8", stringsAsFactors=FALSE, header = TRUE)
  
  kommunekoder <- read.csv(url("https://raw.githubusercontent.com/PhazeDK/catch3/master/data/kommunekoder.csv"),
                           encoding="UTF-8", stringsAsFactors=FALSE, header = TRUE)
  
  for (row in 1:nrow(kommunekoder)) {
    if (kommunekoder[row, "NIVEAU"] == 1) {
      current_reg_name = kommunekoder[row, "TITEL"]
    }
    
    if (kommunekoder[row, "NIVEAU"] == 2) {
      current_landsdel_name = kommunekoder[row, "TITEL"]
    }
    
    if (kommunekoder[row, "NIVEAU"] == 3) {
      kommunekoder[row, "region"] <- current_reg_name
      kommunekoder[row, "landsdel"] <- current_landsdel_name
    }
  }
  
  kommunekoder <- kommunekoder %>% filter(NIVEAU == 3) %>% transmute(id = KODE, region, landsdel)
  
  covid_data_input <- jsonlite::fromJSON("https://api.covid19data.dk:443/ssi_cases_municipalities") %>% mutate(
    date = as_date(date, format="%Y-%m-%d"),
    id = mun_code
  ) %>% arrange(date, id)
  
  covid_data <- 
    covid_data_input %>%
      filter(!is.na(mun_code)) %>% 
      left_join(kommunekoder, by=c("id")) %>%
      left_join(kommuneareal, by=c("id")) %>%
      group_by(id) %>%
      arrange(date) %>%
      transmute(
        date,
        name = mun_name,
        cases,
        tests,
        region,
        population,
        region,
        diff_date = date - lag(date),
        cases_growth = cases - lag(cases),
        tests_growth = tests - lag(tests),
        population_100K = population / 100000,
        pop_density = population / areal,
        cases_growth_per_day = cases_growth / as.numeric(diff_date, unit="days"),
        cases_growth_per_100K = cases_growth / (population/100000),
        cases_per_100K = cases / (population/100000),
        cases_growth_per_day_per_100K = cases_growth_per_day / (population / 100000),
        tests_per_100K = tests / (population/100000),
        tests_growth_per_day = tests_growth / as.numeric(diff_date, unit="days"),
        tests_growth_per_100K = tests_growth / (population/100000),
        tests_growth_per_day_per_100K = tests_growth_per_day / (population/100000)
      ) %>%
      ungroup()
  
  
  load_data_R<-T
}