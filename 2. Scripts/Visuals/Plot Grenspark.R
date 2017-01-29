


Soorten=c("Bergeend", "Fitis", "Bosruiter")

for (Soort in Soorten) {
  
  load(paste(getwd(), "/3.Plots/OSM/Grenspark.RData", sep=""))
  
  path=paste(getwd(), "/1. Data/Cleaned Data/Grenspark.RData", sep="")
  load(file=path)

  Grenspark=as.data.frame(Grenspark)
  Grenspark$jaar=as.numeric(as.character(Grenspark$jaar))
  Grenspark=Grenspark[which(Grenspark$jaar %in% 2009:2013),]

  p=p+
    geom_point(data=Grenspark[which(Grenspark$bvr_soort==Soort),], aes(x=coords.x1, y=coords.x2, colour=as.factor(jaar)), size=0.5)+
    theme(legend.key = element_blank())+
    scale_colour_brewer("Jaar", palette="BrBG")
  ggsave(file=paste(getwd(),"/3.Plots/Grenspark/",Soort,".pdf", sep=""), width = 25/20*8, height = 8, units = "cm")

}