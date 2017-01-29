require(osmar)

api <- osmsource_api()
box <- corner_bbox(4.3964, 51.3771, 4.4548, 51.4219)
Map1 <- get_osm(box, source = api)


box <- corner_bbox(4.3425, 51.3739, 4.4182, 51.4281)
Map2 <- get_osm(box, source = api)


box <- corner_bbox(4.3921, 51.3631, 4.4598, 51.3937)
Map3 <- get_osm(box, source = api)

Results=list(Map1, Map2, Map3)

save(Results, file=paste(getwd(), "/1. Data/Raw Data/Grenzen/OSM/OSM.RDATA", sep=""))
