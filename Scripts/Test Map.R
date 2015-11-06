require(rgdal)

path=paste(getwd(), "/Input/Mapbox/features.json", sep="")
map = readOGR(path, "OGRGeoJSON",  require_geomType="wkbPolygon")
plot(map)
