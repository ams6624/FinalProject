require(lubridate)

g1 <- seattle_crimes %>% select(CRIME_TYPE, STAT_VALUE, DATE1) 

g2 <- grep("3$", g1$DATE1, perl=TRUE, value=FALSE) %>% g1[., c('CRIME_TYPE', 'STAT_VALUE', 'DATE1')] %>% group_by(DATE1, CRIME_TYPE) %>% summarize(stat= sum(STAT_VALUE))

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  facet_grid(.~CRIME_TYPE, labeller=label_both) + 
  labs(title='2013 Incidents per Crime') +
  labs(x="Date", y=paste("Number of Incidents")) +
  layer(data = g2, 
               mapping = aes(x=DATE1, y=as.numeric(stat), fill = DATE1), 
                stat="identity", 
                stat_params=list(), 
                geom="bar",
                geom_params=list(colour="blue", hjust=-0.5), 
                position=position_identity()) +
  geom_text(data = g2, aes(x=DATE1, y=as.numeric(stat), ymax=stat, label=stat, angle = 90, hjust=ifelse(sign(stat)>0, 1, 0))) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +scale_fill_brewer(palette="Spectral")

