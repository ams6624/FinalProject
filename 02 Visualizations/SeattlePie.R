require(ggplot2)
require(dplyr)

seattle <- seattle_crimes %>% select(CRIME_TYPE,STAT_VALUE ) %>% group_by(CRIME_TYPE) %>% summarize(stat = n_distinct(CRIME_TYPE), stat = sum(STAT_VALUE))

bp<- ggplot(seattle, aes(x="", y=stat, fill=CRIME_TYPE))+
  geom_bar(width = 1, stat = "identity") + 
  coord_polar("y", start=0)

library(scales)
blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

bp +  blank_theme + theme(axis.text.x=element_blank())
