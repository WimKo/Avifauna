
######################################################################################################
# Packages
######################################################################################################

require(rgdal)
require(leaflet)

######################################################################################################
# Laad data
######################################################################################################

#Waarnemingen2007=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_1990-01-01_2007-12-31.csv", sep=""))
Waarnemingen2008=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2008-01-01_2008-12-31.csv", sep=""))
Waarnemingen2009=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2009-01-01_2009-12-31.csv", sep=""))
Waarnemingen2010=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2010-01-01_2010-12-31.csv", sep=""))
Waarnemingen2011=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2011-01-01_2011-12-31.csv", sep=""))
Waarnemingen2012=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2012-01-01_2012-12-31.csv", sep=""))
Waarnemingen2013=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2013-01-01_2013-12-31.csv", sep=""))
Waarnemingen2014=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2014-01-01_2014-12-31.csv", sep=""))
Waarnemingen2015=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2015-01-01_2015-12-31.csv", sep=""))
Waarnemingen2016=read.csv2(file=paste(getwd(),"/1. Data/Raw Data/Observations/Waarnemingen.be/", "werkgroep_1213_2016-01-01_2016-12-31.csv", sep=""))

Waarnemingen=rbind(Waarnemingen2008,
                  Waarnemingen2009,
                  Waarnemingen2010,
                  Waarnemingen2011,
                  Waarnemingen2012,
                  Waarnemingen2013,
                  Waarnemingen2014,
                  Waarnemingen2015,
                  Waarnemingen2016)

Waarnemingen$Datum=as.Date(Waarnemingen$Datum, "%d/%m/%Y")

Waarnemingen <- SpatialPointsDataFrame(coords=Waarnemingen [, c("Lon", "Lat")], data=Waarnemingen)
proj4string(Waarnemingen) <-"+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

######################################################################################################
# Toon waarnemingen op kaart
######################################################################################################

p=leaflet() %>% 
  addTiles(group = "OpenStreetMap") %>% 
  addCircles(data=Waarnemingen, weight = 1, group = "Waarnemingen", color="black", opacity=0.5) 

if (plot_map==TRUE) {print(p)}

######################################################################################################
# Bewaar data
######################################################################################################

path=paste(getwd(), "/1. Data/Cleaned Data/Waarnemingen_All.RData", sep="")
save(Waarnemingen,file=path)

Waarnemingen=Waarnemingen[which(Waarnemingen$Soortgroep=="birds"),]

path=paste(getwd(), "/1. Data/Cleaned Data/Waarnemingen.RData", sep="")
save(Waarnemingen,file=path)
