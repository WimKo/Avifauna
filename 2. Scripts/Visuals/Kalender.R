require(ggplot2)
require(lubridate)
require(data.table)

path=paste(getwd(), "/1. Data/Cleaned Data/Waarnemingen.RData", sep="")
load(file=path)
Soorten=c("Bergeend", "Bosruiter", "Fitis")

for (Soort in Soorten) {

path=paste(getwd(), "/1. Data/Cleaned Data/Waarnemingen.RData", sep="")
load(file=path)
  
Waarnemingen$Week=week(Waarnemingen$Datum)
Waarnemingen=as.data.frame(Waarnemingen)
Waarnemingen=data.table(Waarnemingen)

#Waarnemingen=Waarnemingen[Naam==Soort, list(Aantal=max(Aantal)), by=c("Datum", "Week", "Gebied")]
Waarnemingen=Waarnemingen[Naam==Soort, length(Aantal), by=Week]
Waarnemingen=rbind(Waarnemingen, data.frame(Week=1:52,V1=0))
Waarnemingen=Waarnemingen[, max(V1), by=Week]
Waarnemingen[V1==0, V1:=NA]         
          
p=ggplot()+geom_tile(data=Waarnemingen, aes(x=Week, y=1, fill=V1), colour="grey")+
  scale_fill_distiller(palette="OrRd", direction=2)+
  theme(legend.key = element_blank())+
  theme(panel.grid = element_blank())+
  scale_x_continuous(breaks = seq(0,11*52/12,52/12)+52/12/2, labels=c("Jan", "Feb", "Mar",
                                                               "Apr", "Mei", "Jun",
                                                               "Jul", "Aug", "Sept", 
                                                               "Okt", "Nov", "Dec"))+
  xlab(NULL)+
  ylab(NULL)+
  theme(axis.ticks.y=element_blank())+
  theme(axis.text.y = element_blank())+
  theme(panel.background = element_rect(fill = "white"))+
  theme(legend.position="none")


ggsave(file=paste(getwd(),"/3.Plots/Kalender/",Soort,".pdf", sep=""), width = 19, height = 2, units = "cm")
}