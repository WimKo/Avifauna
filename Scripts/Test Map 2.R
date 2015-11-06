require(rgdal)
require(leaflet)
require(htmltools)

path=paste(getwd(), "/Input/Mapbox/features.json", sep="")
Polygons = readOGR(path, "OGRGeoJSON",  require_geomType="wkbPolygon")
Roads = readOGR(path, "OGRGeoJSON",  require_geomType="wkbLineString")



factpal <- colorFactor(topo.colors(40), Polygons$title)

p=leaflet(data=Polygons) %>% 
  addPolygons(weight = 2, color =~factpal(title)) %>% 
  addLegend(pal = factpal, values = ~title, opacity = 1)
print(p)


#write.csv2(Polygons$title,"Polygons_titles.csv")
Type=read.csv2("Polygons_titles.csv")

Polygons$Type=Type$Type


factpal <- colorFactor(rainbow(5), Polygons$Type)

p=leaflet(data=Polygons) %>% 
  addPolygons(weight = 4, fillColor =~factpal(Type), stroke=TRUE, color="White", popup = ~htmlEscape(title)) %>% 
  addLegend(pal = factpal, values = ~Type, opacity = 1) 

print(p)
