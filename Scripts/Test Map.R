require(rgdal)

path=paste(getwd(), "/Input/Mapbox/features.json", sep="")
Polygons = readOGR(path, "OGRGeoJSON",  require_geomType="wkbPolygon")
Roads = readOGR(path, "OGRGeoJSON",  require_geomType="wkbLineString")

plot(Roads, col="red")
plot(Polygons, add=TRUE)
