
######################################################################################################
# Packages
######################################################################################################

require(finch)
require(data.table)
require(leaflet)

######################################################################################################
# Laad data
######################################################################################################

path=paste(getwd(),"/1. Data/Raw Data/Observations/SOVON/dwca-bmp_data.zip", sep="")
SOVON <- dwca_read(input=path, read=TRUE)
SOVON=rbindlist(SOVON$data)

print(head(SOVON))


SOVON=SOVON[, list(Naam=vernacularName, 
                                         Jaar=year,
                                         Aantal=individualCount,
                                         Regio=locality,
                                         Lat=decimalLatitude,
                                         Lon=decimalLongitude)]
SOVON=SOVON[Regio=="De Matjens"]

######################################################################################################
# Toon waarnemingen op kaart
######################################################################################################

p=leaflet() %>% 
  addTiles(group = "OpenStreetMap") %>% 
  addCircles(data=SOVON, weight = 1, group = "Waarnemingen", color="black", opacity=0.5) 

if (plot_map==TRUE) {print(p)}

######################################################################################################
# Bewaar data
######################################################################################################

path=paste(getwd(), "/1. Data/Cleaned Data/SOVON.RData", sep="")
save(SOVON,file=path)
