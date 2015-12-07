# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(leaflet)
require(DT)
require(dashboard)
library(scales)

shinyServer(function(input, output) {
  
  kpi_1 <- reactive({input$KPI1})
  kpi_2 <- reactive({input$KPI2})
  kpi_3 <- reactive({input$KPI3})
  kpi_4 <- reactive({input$KPI4})
  kpi_5 <- reactive({input$KPI5})
  kpi_6 <- reactive({input$KPI6})
  kpi_7 <- reactive({input$KPI7})
  kpi_reg <- reactive({input$reg})
  types <- reactive({input$types})
  
  
  seattle_crimes <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from SEATTLE_CRIMES"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_alm3657', PASS='orcl_alm3657', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
  
  
  df1 <- eventReactive(input$clicks1, {
    m6 <- seattle_crimes %>% select(PRECINCT, CRIME_TYPE, STAT_VALUE) %>% group_by(PRECINCT, CRIME_TYPE) %>% summarise(stat = sum(STAT_VALUE)) %>% mutate(mean = ifelse(CRIME_TYPE == "Assault", kpi_1(), 
  ifelse(CRIME_TYPE == "Burglary",kpi_2() , 
 ifelse(CRIME_TYPE == "Homicide", kpi_3(), 
 ifelse(CRIME_TYPE == "Larceny-Theft", kpi_4(), 
 ifelse(CRIME_TYPE == "Motor Vehicle Theft", kpi_5(), 
 ifelse(CRIME_TYPE == "Rape", kpi_6(), kpi_7()))))))) %>% mutate(kpi = ifelse(stat >= mean, 'Above', 'Below')) 
 
  })
  
  output$distPlot1 <- renderPlot({             
    plot <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_discrete() +
      labs(title=isolate(input$title)) +
      labs(x=paste("CRIME TYPE"), y=paste("PRECINCT")) +
      layer(data=df1(), 
            mapping=aes(x=CRIME_TYPE, y=PRECINCT, label=stat), 
            stat="identity", 
            stat_params=list(), 
            geom="text",
            geom_params=list(colour="black", vjust=2), 
            position=position_identity()
      ) +
      layer(data=df1(), 
            mapping=aes(x=CRIME_TYPE, y=PRECINCT, fill=kpi), 
            stat="identity", 
            stat_params=list(), 
            geom="tile",
            geom_params=list(alpha = 0.5), 
            position=position_identity()
      )
    plot
    })
  
  ##PLOT 2
  df2 <- eventReactive(input$clicks2,{
    g1 <- seattle_crimes %>% select(CRIME_TYPE, STAT_VALUE, DATE1) 
    g2 <- grep(kpi_reg(), g1$DATE1, perl=TRUE, value=FALSE) %>% g1[., c('CRIME_TYPE', 'STAT_VALUE', 'DATE1')] %>% group_by(DATE1, CRIME_TYPE) %>% summarize(stat= sum(STAT_VALUE))
  })
  
  output$distPlot2 <- renderPlot(height=500, width=800, {
    plot1 <- ggplot() + 
      coord_cartesian() + 
      scale_x_discrete() +
      scale_y_continuous() +
      facet_grid(.~CRIME_TYPE, labeller=label_both) + 
      labs(title='Incidents per Crime') +
      labs(x="Date", y=paste("Number of Incidents")) +
      layer(data = df2(), 
            mapping = aes(x=DATE1, y=as.numeric(stat), fill = DATE1), 
            stat="identity", 
            stat_params=list(), 
            geom="bar",
            geom_params=list(colour="blue", hjust=-0.5), 
            position=position_identity()) +
      geom_text(data = df2(), aes(x=DATE1, y=as.numeric(stat), ymax=stat, label=stat, angle = 90, hjust=ifelse(sign(stat)>0, 1, 0))) + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) +scale_fill_brewer(palette="Spectral")
    
  plot1
  })
  
  # Begin code for Third Tab:
  df3 <- eventReactive(input$clicks3,{seattle <- seattle_crimes %>% select(CRIME_TYPE,STAT_VALUE ) %>% filter(CRIME_TYPE %in% types()) %>% group_by(CRIME_TYPE) %>% summarize(stat = n_distinct(CRIME_TYPE), stat = sum(STAT_VALUE))})
  
  output$distPlot3 <- renderPlot(height=300, width=500, {
    plot3 <-ggplot(df3(), aes(x="", y=stat, fill=CRIME_TYPE))+
      geom_bar(width = 1, stat = "identity") + 
      coord_polar("y", start=0) +
      theme_minimal()+
      theme(
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid=element_blank(),
        axis.ticks = element_blank(),
        plot.title=element_text(size=14, face="bold")
      )+
      theme(axis.text.x=element_blank())
    
    plot3
})
  
})
