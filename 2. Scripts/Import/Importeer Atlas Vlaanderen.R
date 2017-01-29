
######################################################################################################
# Packages
######################################################################################################

require(finch)
require(data.table)
require(leaflet)

######################################################################################################
# Laad data
######################################################################################################

path=paste(getwd(),"/1. Data/Raw Data/Observations/Atlas 2000-2002/dwca-broedvogel-atlas-occurrences-v1.4.zip", sep="")
Atlas_Vlaanderen <- dwca_read(input=path, read=TRUE)
Atlas_Vlaanderen=rbindlist(Atlas_Vlaanderen$data)

print(head(Atlas_Vlaanderen))


Atlas_Vlaanderen=Atlas_Vlaanderen[, list(Naam=vernacularName, 
                                         Datum=eventDate,
                                         Aantal=individualCount,
                                         Regio=verbatimLocality,
                                         Waarnemer=recordedBy,
                                         Lat=decimalLatitude,
                                         Lon=decimalLongitude,
                                         Hok=verbatimCoordinates,
                                         Coordinaten=as.factor(georeferenceRemarks),
                                         Status=as.factor(behavior))]

######################################################################################################
# Toon waarnemingen op kaart
######################################################################################################

p=leaflet() %>% 
  addTiles(group = "OpenStreetMap") %>% 
  addCircles(data=Atlas_Vlaanderen, weight = 1, group = "Waarnemingen", color="black", opacity=0.5) 

if (plot_map==TRUE) {print(p)}

######################################################################################################
# Bewaar data
######################################################################################################

path=paste(getwd(), "/1. Data/Cleaned Data/Atlas_Vlaanderen.RData", sep="")
save(Atlas_Vlaanderen,file=path)
