
######################################################################################################
# Packages
######################################################################################################

require(rgdal)
require(leaflet)

######################################################################################################
# Laad data
######################################################################################################

path=paste(getwd(), "/1. Data/Raw Data/Grenzen/Gemeentegrenzen/Refgem.shp", sep="")
Gemeentegrenzen <- readOGR(path, "Refgem")
Gemeentegrenzen=spTransform(Gemeentegrenzen, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

######################################################################################################
# Toon waarnemingen op kaart
######################################################################################################

p=leaflet() %>% 
  addTiles(group = "OpenStreetMap") %>% 
  addPolygons(data=Gemeentegrenzen,
              weight = 4, 
              stroke=TRUE, color="White", 
              opacity=1,
              group = "Gebieden")

if (plot_map==TRUE) {print(p)}

######################################################################################################
# Bewaar data
######################################################################################################

path=paste(getwd(), "/1. Data/Cleaned Data/Gemeentegrenzen.RData", sep="")
save(Gemeentegrenzen,file=path)
