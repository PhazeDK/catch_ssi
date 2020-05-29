#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shinydashboard)
library(plotly)

dashboardPage(
  dashboardHeader(title = "CATCH"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Data", tabName = "data", icon = icon("list")),
      menuItem("Plots", tabName = "plot", icon = icon("chart-bar")),
      menuItem("About", tabName = "about", icon = icon("question-circle")),
      menuItem("Source Code", icon = icon("code"), href = "https://github.com/PhazeDK/catch_ssi")
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "catch_ssi.css")
    ),
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "Map",
                  plotlyOutput("map", height="600px"),
                  width=6
                ),
                box(
                  title = "Plot",
                  plotlyOutput("plot", height="600px"),
                  width=6
                )
              ),
              fluidRow(
                box(
                  htmlOutput("widget")
                )
              )
      ),
      tabItem(tabName = "data",
              h2("Data")
      )
    )
  )
)
