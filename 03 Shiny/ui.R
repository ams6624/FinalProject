#ui.R
require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(title = "Seattle States"
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Crosstab", tabName = "crosstab", icon = icon("th")),
      menuItem("Barchart", tabName = "barchart", icon = icon("bar-chart-o")),
      menuItem("PieChart", tabName = "piechart", icon = icon("pie-chart"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(
        tabName = "crosstab",
        fluidRow(
          box(
        sliderInput("KPI1", "Mean Assaults:", 
                    min = 1, max = 2483,  value = 2483),
        sliderInput("KPI2", "Mean Burglary:", 
                    min = 1, max = 8559,  value = 8559),
        sliderInput("KPI3", "Mean Homicide:", 
                    min = 1, max = 29,  value = 29),
        sliderInput("KPI4", "Mean Larceny-Theft:", 
                    min = 1, max = 27852,  value = 27852),
        sliderInput("KPI5", "Mean Motor Vehicle Theft:", 
                    min = 1, max = 4678,  value = 4678),
        sliderInput("KPI6", "Mean Rape:", 
                    min = 1, max = 124,  value = 124),
        sliderInput("KPI7", "Mean Robbery:", 
                    min = 1, max = 1931,  value = 1931)),
        box(
          textInput(inputId = "title", 
                  label = "Crosstab",
                  value = "CrossTab Seattle Crime"),
        actionButton(inputId = "clicks1",  label = "Click me"),
        plotOutput("distPlot1"))
      )),
      
      # Second tab content
      tabItem(tabName = "barchart",
              actionButton(inputId = "clicks2",  label = "Click me"),
              radioButtons(inputId = "reg", label = "Year", choices = c("2008" = "8$", "2009" = "9$", "2010" = "0$", "2011" = "1$" , "2012" = "2$", "2013" = "3$"), selected = "2013"),
              plotOutput("distPlot2")
              
      ),
      
      # Third tab content
      tabItem(tabName = "piechart",
              fluidRow(
                box(actionButton(inputId = "clicks3",  label = "Click me"),
                    checkboxGroupInput(inputId = "types", label = "Crime Types", choices = c("Larceny-Theft", "Assault", "Robbery", "Burglary", "Motor Vehicle Theft", "Rape", "Homicide"), selected = "Burglary")),
                
                box(title = "Bar Chart", background = "light-blue",plotOutput("distPlot3"))
              )
      )
    )
  )
)
