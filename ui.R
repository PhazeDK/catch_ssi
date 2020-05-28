#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "CATCH"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Data", tabName = "data", icon = icon("list")),
      menuItem("Plots", tabName = "plot", icon = icon("chart-bar")),
      menuItem("Source", icon = icon("file-code-o"), href = "https://github.com/PhazeDK/catch_ssi"),
      menuItem("About", tabName = "about", icon = icon("question-circle"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              fluidRow(
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50), width=12
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "data",
              h2("Data")
      )
    )
  )
)
