m5 <- seattle_crimes %>% select(PRECINCT, CRIME_TYPE, STAT_VALUE) %>% group_by(PRECINCT, CRIME_TYPE) %>% summarise(stat = sum(STAT_VALUE)) 
aggregate(m5[, 3], list(m5$CRIME_TYPE), mean)

m6 <- seattle_crimes %>% select(PRECINCT, CRIME_TYPE, STAT_VALUE) %>% group_by(PRECINCT, CRIME_TYPE) %>% summarise(stat = sum(STAT_VALUE)) %>% mutate(mean = 
ifelse(CRIME_TYPE == "Assault", 2483, 
ifelse(CRIME_TYPE == "Burglary", 8559 , 
ifelse(CRIME_TYPE == "Homicide", 29, 
ifelse(CRIME_TYPE == "Larceny-Theft", 27852, 
ifelse(CRIME_TYPE == "Motor Vehicle Theft", 4678, 
ifelse(CRIME_TYPE == "Rape", 124, 1931))))))) %>% mutate(kpi = ifelse(stat >= mean, 'Above', 'Below'))

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title='Crime Type Incidents') +
  labs(x=paste("CRIME TYPE"), y=paste("PRECINCT")) +
  layer(data=m6, 
        mapping=aes(x=CRIME_TYPE, y=PRECINCT, label=stat), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", vjust=2), 
        position=position_identity()
  ) +
  layer(data=m6, 
        mapping=aes(x=CRIME_TYPE, y=PRECINCT, fill=kpi), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=.5), 
        position=position_identity()
  )
