#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)
library(rjson)
library(crosstalk)

source("load_data.R")

#url <- 'https://raw.githubusercontent.com/plotly/datasets/master/election.geojson'
#geojson <- rjson::fromJSON(file=url)
#url2<- "https://raw.githubusercontent.com/plotly/datasets/master/election.csv"
#df <- read.csv(url2)
 
#dk_map <- fromJSON(file="https://raw.githubusercontent.com/moestrup/covid19/master/test.json")
#dk_map <- fromJSON(file="https://raw.githubusercontent.com/PhazeDK/catch3/master/data/municipalities.geojson.json")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  covid_data_highlight <- reactive({
    highlight_key(covid_data, ~name)
  })
  
  output$widget <- renderUI({
    filter_select("region", "Region", covid_data_highlight(), ~region)
  })
  
  output$map <- renderPlotly({
    g <- list(
      fitbounds = "locations",
      projection = list(type = "mercator"),
      visible = FALSE,
      projection_rotation=list(lon=0, lat=0, roll=0)
    )

    plot_ly(covid_data_highlight()) %>%
      #filter(date == max(date)) %>% 
      add_trace(
        type="choropleth",
        geojson=dk_map,
        locations=~name,
        z=~cases_per_100K,
        colorscale="Viridis",
        featureidkey="properties.name"
      ) %>% layout(
        geo = g
      ) %>% 
      highlight('plotly_click', selected = attrs_selected(opacity = 0.5))
  })
  
  output$plot <- renderPlotly({
    # plot_ly(covid_data_highlight()) %>% 
    #   add_lines(x = ~date, y = ~cases_per_100K)
    vars <- c("tests_per_100K", "vases_per_100K")
    
    gg <- ggplot(covid_data_highlight()) +
      geom_line(aes(date, cases_per_100K, group = name), color='blue', alpha=0.5) +
      theme_bw()
    
    gg <- ggplotly(gg, text = c("name", "x", "y"))
    
    gg2 <- ggplot(covid_data_highlight()) +
      geom_line(aes(date, cases_growth_per_day_per_100K, group = name), color='red', alpha=0.5) +
      theme_bw()
    
    gg2 <- ggplotly(gg2, text = c("name", "x", "y"))

    gg3 <- ggplot(covid_data_highlight()) +
      geom_line(aes(date, tests_per_100K, group = name), color='orange', alpha=0.5) +
      theme_bw()
    
    gg3 <- ggplotly(gg3, text = c("name", "x", "y"))
    
    gg4 <- ggplot(covid_data_highlight()) +
      geom_line(aes(date, tests_growth_per_day_per_100K, group = name), color='green', alpha=0.5) +
      theme_bw()
    
    gg4 <- ggplotly(gg4, text = c("name", "x", "y"))
    
    
    
    subplot(gg, gg2, gg3, gg4, nrows=4, shareX = TRUE) %>% 
      layout(
        xaxis = list(rangeslider = list(type = "date"))
        ) %>%
      highlight("plotly_click", persistent = TRUE)
  })

})
