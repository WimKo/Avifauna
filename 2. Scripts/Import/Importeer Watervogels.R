
######################################################################################################
# Packages
######################################################################################################

require(finch)
require(data.table)
require(leaflet)

######################################################################################################
# Laad data
######################################################################################################

path=paste(getwd(),"/1. Data/Raw Data/Observations/Watervogels/dwca-watervogels-occurrences-v3.3.zip", sep="")
Watervogels <- dwca_read(input=path, read=TRUE)
Watervogels=rbindlist(Watervogels$data)

print(head(Watervogels))


Watervogels=Watervogels[, list(Naam=vernacularName, 
                               Datum=eventDate,
                               Aantal=individualCount,
                               Regio=verbatimLocality,
                               Waarnemer=recordedBy,
                               Lat=decimalLatitude,
                               Lon=decimalLongitude,
                               Coordinaten=as.factor(georeferenceRemarks),
                               Gemeente=as.factor(municipality))]

######################################################################################################
# Toon waarnemingen op kaart
######################################################################################################

p=leaflet() %>% 
  addTiles(group = "OpenStreetMap") %>% 
  addCircles(data=Watervogels, weight = 1, group = "Waarnemingen", color="black", opacity=0.5) 

if (plot_map==TRUE) {print(p)}

######################################################################################################
# Bewaar data
######################################################################################################

path=paste(getwd(), "/1. Data/Cleaned Data/Watervogels.RData", sep="")
save(Watervogels,file=path)
