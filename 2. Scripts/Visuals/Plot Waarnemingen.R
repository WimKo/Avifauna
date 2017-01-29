require(ggplot2)
require(data.table)
load(paste(getwd(), "/3.Plots/OSM/Noorderkempen.RData", sep=""))
load(paste(getwd(), "/1. Data/Cleaned Data/Gemeentegrenzen.RData", sep=""))
load(paste(getwd(), "/1. Data/Cleaned Data/Waarnemingen.RData", sep=""))
###############################################################################
#
#######################################################

Gemeentegrenzen=Gemeentegrenzen[which(Gemeentegrenzen$NAAM %in% c("Essen", "Kalmthout", "Wuustwezel", "Kapellen", "Brasschaat", "Brecht")),]
points=SpatialPoints(data[,c("lon","lat")])
proj4string(points)=proj4string(Gemeentegrenzen)
test=over(points, Gemeentegrenzen)

data$In=test$OIDN
data[which(is.na(data$In)==FALSE),"In"]=1
data[which(is.na(data$In)==TRUE),"In"]=0

check=data.table(data)
check=check[, max(In), by=id]
check=check[V1==1,id]

data=data[data$id %in% check,]


Gemeentegrenzen=fortify(Gemeentegrenzen)
Waarnemingen=as.data.frame(Waarnemingen)

Soorten=c("Fitis", "Bosruiter", "Bergeend", "Grasmus")

for (Soort in Soorten) {

p=ggplot()+ 
  geom_polygon(data=data[which(data$tag=="forest"),], aes(x=lon, y=lat, group=id),  fill="#2ca25f",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="wood"),],  aes(x=lon, y=lat, group=id), fill="#2ca25f",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="conservation"),], aes(x=lon, y=lat, group=id),  fill="#2ca25f",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="heath"),],   aes(x=lon, y=lat, group=id),fill="#f7fcb9",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="grass"),],  aes(x=lon, y=lat, group=id), fill="#FAF0BE",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="meadow"),],  aes(x=lon, y=lat, group=id), fill="#FAF0BE",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="farm"),],  aes(x=lon, y=lat, group=id), fill="#FAF0BE",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="grass"),],  aes(x=lon, y=lat, group=id), fill="#FAF0BE",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="orchard"),], aes(x=lon, y=lat, group=id),  fill="#FAF0BE",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="sand"),],   aes(x=lon, y=lat, group=id),fill="#ffeda0",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="water"),],  aes(x=lon, y=lat, group=id), fill="#a6bddb",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="residential"),],  aes(x=lon, y=lat, group=id), fill="#FFC1CC",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="farm"),],  aes(x=lon, y=lat, group=id), fill="#FAF0BE",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="farmland"),],  aes(x=lon, y=lat, group=id), fill="#FAF0BE",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="farmyard"),],  aes(x=lon, y=lat, group=id), fill="#FAF0BE",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="cemetery"),],  aes(x=lon, y=lat, group=id), fill="#FAF0BE",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="industrial"),],  aes(x=lon, y=lat, group=id), fill="#FFC1CC",  size=0.5, alpha=0.5)+
  theme(panel.grid = element_blank())+
  theme(axis.title = element_blank())+
  theme(axis.ticks = element_blank())+
  theme(axis.text = element_blank())+
  theme(panel.background = element_rect(fill = "white"))+
  geom_point(data=Waarnemingen[which(Waarnemingen$Naam==Soort),], aes(x=Lon, y=Lat), size=0.05, colour="#FE6F5E")+
  #geom_path(data=Gemeentegrenzen, aes(x = long, y = lat, group = id), colour="grey", size=0.5)+
  coord_map(xlim = c(4.376163, 4.632626),ylim = c(51.324819 , 51.48459))

#ggsave(file=paste(getwd(), "/3.Plots/OSM/Noorderkempen.pdf", sep=""), width = 15, height = 15, units = "cm")

ggsave(file=paste(getwd(),"/3.Plots/Waarnemingen/",Soort,".pdf", sep=""), width = 25/20*8, height = 8, units = "cm")
}