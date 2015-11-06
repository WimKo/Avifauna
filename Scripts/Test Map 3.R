

require(rgdal)
require(leaflet)
require(htmltools)

Observations=read.csv2(file=paste(getwd(),
                                  "/Input/Observations/Waarnemingen.be/", 
                                  "test.csv", 
                                  sep=""))

Observations=Observations[which(Observations$Naam=="Wulp"),]
Observations <- SpatialPointsDataFrame(coords=Observations [, c("Lat", "Lon")], data=Observations)


Polygons = readOGR(paste(getwd(), "/Input/Mapbox/features.json", sep=""), "OGRGeoJSON",  require_geomType="wkbPolygon")

proj4string(Observations)

proj4string(Polygons) <-proj4string(Observations)

Observations$Gebied2=sp::over(Observations, Polygons[, c("title")])$title


Count=aggregate(Aantal~Gebied2 , FUN=length, data=Observations)


Polygons$Count=Count[match(Polygons$title, Count$Gebied2), "Aantal"]


#factpal <- colorFactor(rainbow(5), Polygons$Count)
binpal <- colorBin("RdPu", Polygons$Count, 6, pretty = FALSE)

p=leaflet(data=Polygons) %>% 
  addPolygons(weight = 4, fillColor =~binpal(Count), stroke=TRUE, color="White", popup = ~htmlEscape(title)) %>% 
  addLegend(pal = binpal, values = ~Count, opacity = 1) 

print(p)
