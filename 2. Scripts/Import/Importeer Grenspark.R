
######################################################################################################
# Packages
######################################################################################################

require(rgdal)
require(leaflet)

######################################################################################################
# Laad data
######################################################################################################

path=paste(getwd(), "/1. Data/Raw Data/Observations/Broedvogels Grenspark/GrensparkBRV_1985-2014.shp", sep="")
Grenspark <- readOGR(path, "GrensparkBRV_1985-2014")
Grenspark=spTransform(Grenspark, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
Grenspark$jaar=as.factor(Grenspark$jaar)


######################################################################################################
# Toon waarnemingen op kaart
######################################################################################################

p=leaflet() %>% 
  addTiles(group = "Grenspark") %>% 
  addCircles(data=Grenspark, radius=10)

if (plot_map==TRUE) {print(p)}


######################################################################################################
# Bewaar data
######################################################################################################

path=paste(getwd(), "/1. Data/Cleaned Data/Grenspark.RData", sep="")
save(Grenspark,file=path)
