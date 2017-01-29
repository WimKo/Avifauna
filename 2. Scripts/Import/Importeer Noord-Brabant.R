
######################################################################################################
# Packages
######################################################################################################

require(maptools)
require(leaflet)
require(maptools)

######################################################################################################
# Laad data
######################################################################################################

path=paste(getwd(), "/1. Data/Raw Data/Observations/Noord-Brabant/Broedgevallen_van_vogels_p.shp", sep="")
Atlas_NBrabant <- readShapePoints(path)
proj4string(Atlas_NBrabant)=CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")
Atlas_NBrabant<-spTransform(Atlas_NBrabant,CRS("+proj=longlat"))

######################################################################################################
# Toon waarnemingen op kaart
######################################################################################################

p=leaflet() %>%
  addTiles(group = "OpenStreetMap") %>% 
  addCircles(data=Atlas_NBrabant[which(Atlas_NBrabant$NED_NAAM=="Zwarte specht"),], radius=100,   fillOpacity=1, stroke = FALSE)

if (plot_map==TRUE) {print(p)}

######################################################################################################
# Bewaar data
######################################################################################################

path=paste(getwd(), "/1. Data/Cleaned Data/Atlas_NBrabant.RData", sep="")
save(Atlas_NBrabant,file=path)
