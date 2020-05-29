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

source("load_data.R")

#url <- 'https://raw.githubusercontent.com/plotly/datasets/master/election.geojson'
#geojson <- rjson::fromJSON(file=url)
#url2<- "https://raw.githubusercontent.com/plotly/datasets/master/election.csv"
#df <- read.csv(url2)
 
#dk_map <- fromJSON(file="https://raw.githubusercontent.com/moestrup/covid19/master/test.json")
#dk_map <- fromJSON(file="https://raw.githubusercontent.com/PhazeDK/catch3/master/data/municipalities.geojson.json")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$map <- renderPlotly({
      g <- list(
        fitbounds = "locations",
        projection = list(type = "mercator"),
        visible = FALSE,
        projection_rotation=list(lon=0, lat=0, roll=0)
      )

      fig <- plot_ly() 
      fig <- fig %>% add_trace(
        type="choropleth",
        geojson=dk_map,
        locations=kommuneareal$id,
        z=kommuneareal$areal,
        colorscale="Viridis",
        featureidkey="id"
      ) %>% layout(
        geo = g
      )
    })

})
