load(file="Heide.RDATA")
path=paste(getwd(), "/1. Data/Cleaned Data/Grenspark.RData", sep="")
path=paste(getwd(), "/1. Data/Cleaned Data/Atlas_Vlaanderen.RData", sep="")
load(file=path)
path=paste(getwd(), "/1. Data/Cleaned Data/Gemeentegrenzen.RData", sep="")
load(file=path)


Gemeentegrenzen=Gemeentegrenzen[which(Gemeentegrenzen$NAAM %in% c("Essen", "Kalmthout", "Wuustwezel", "Kapellen", "Brasschaap")),]
Gemeentegrenzen=fortify(Gemeentegrenzen)


Soort='Bosruiter'

Atlas_Vlaanderen=as.data.frame(Atlas_Vlaanderen)
Atlas_Vlaanderen=Atlas_Vlaanderen[which(Atlas_Vlaanderen$Regio =="Noorderkempen" & 
                                          Atlas_Vlaanderen$Coordinaten=="coordinates are centroid of 5x5km grid square"),]

p=ggplot()+
  geom_polygon(data=Gemeentegrenzen, aes(x = long, y = lat, group = id), colour="grey", fill="white", alpha=0)+
  geom_point(data=Atlas_Vlaanderen[which(Atlas_Vlaanderen$Naam==Soort),], aes(x=Lon, y=Lat, size=Aantal))+
  theme(legend.key = element_blank())+
  theme(panel.grid = element_blank())+
  theme(axis.title = element_blank())+
  theme(axis.ticks = element_blank())+
  theme(axis.text = element_blank())+
  theme(panel.background = element_rect(fill = "white"))
ggsave(file=paste(getwd(),"/3.Plots/Atlas/",Soort,".pdf", sep=""), width = 25/20*8, height = 7, units = "cm")
