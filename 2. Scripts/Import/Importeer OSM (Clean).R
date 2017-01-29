require(osmar)
require(ggplot2)
require(data.table)
require(leaflet)
require(htmltools)
require(mapproj)

##############################################################################################################
# Conversion Function
#############################################################################################################


Convert_Map=function(Map) {
  
  Nodes_attrs=Map$nodes$attrs
  
  Ways_tags=Map$ways$tags
  Ways_attrs=Map$ways$attrs
  Ways_refs=Map$ways$refs
  
  Relations_tags=Map$relations$tags
  Relations_attrs=Map$relations$attrs
  Relations_refs=Map$relations$refs
  Relations_refs=Relations_refs[which(Relations_refs$role=="outer"),]
  
  Ways_tags=Ways_tags[c(which(Ways_tags$k=="natural"),which(Ways_tags$k=="landuse")),]
  Relations_tags=Relations_tags[c(which(Relations_tags$k=="natural"),which(Relations_tags$k=="landuse")),]
  
  Ways_refs$lon=Nodes_attrs[match(Ways_refs$ref, Nodes_attrs$id), "lon"]
  Ways_refs$lat=Nodes_attrs[match(Ways_refs$ref, Nodes_attrs$id), "lat"]
  Ways_refs$tag=as.character(Ways_tags[match(Ways_refs$id, Ways_tags$id), "v"])
  
  Ways_refs$Multi_id=Relations_refs[match(Ways_refs$id, Relations_refs$ref), "id"]
  Ways_refs$Multi_tag=Relations_tags[match(Ways_refs$Multi_id, Relations_tags$id), "v"]
  
  Ways_refs[which(is.na(Ways_refs$tag)==TRUE), "tag"]=as.character(Ways_refs[which(is.na(Ways_refs$tag)==TRUE), "Multi_tag"])
  
  data=Ways_refs[which(is.na(Ways_refs$tag)==FALSE),]
  data
}
##############################################################################################################
# Load Maps and convert to format
#############################################################################################################

load(paste(getwd(), "/1. Data/Raw Data/Grenzen/OSM/OSM.RDATA", sep=""))
data1 <- Convert_Map(Results[[1]])
data2 <- Convert_Map(Results[[2]])
data3 <- Convert_Map(Results[[3]])

z=Results[[1]]$ways$tags

data=unique(rbind(data1,data2,data3))

hw_ids <- find(Results[[1]], way(tags(k == "surface")))
hw_ids <- find_down(Results[[1]], way(hw_ids))
hw <- subset(Results[[1]], ids = hw_ids)
hw_line1 <- as_sp(hw, "lines")

plot(hw_line1)

hw_ids <- find(Results[[2]], way(tags(k == "surface")))
hw_ids <- find_down(Results[[2]], way(hw_ids))
hw <- subset(Results[[2]], ids = hw_ids)
hw_line2 <- as_sp(hw, "lines")

plot(hw_line2)

hw_ids <- find(Results[[3]], way(tags(k == "surface")))
hw_ids <- find_down(Results[[3]], way(hw_ids))
hw <- subset(Results[[3]], ids = hw_ids)
hw_line3 <- as_sp(hw, "lines")

plot(hw_line3)

##############################################################################################################
# Filter Grenspark
#############################################################################################################

Grenspark <- as_sp(Results[[2]], "polygons")
Grenspark=Grenspark[which(Grenspark$id==71293206), ]

points=SpatialPoints(data[,c("lon","lat")])
proj4string(points)=proj4string(Grenspark)
test=over(points, Grenspark)

data$In=test$id
data[which(is.na(data$In)==FALSE),"In"]=1
data[which(is.na(data$In)==TRUE),"In"]=0

check=data.table(data)
check=check[, max(In), by=id]
check=check[V1==1,id]

data=data[data$id %in% check,]
data=data[data$id!=121687018,]


##############################################################################################################
# Combine in List
#############################################################################################################

IDs=unique(data$id)

SP=list()

for (i in 1:length(IDs)) {
  Polgondata=data[which(data$id==IDs[i]),c("lon","lat")]
  colnames(Polgondata)=c("lng", "lat")
  SP[[i]]=Polygons(list(Polygon(data[which(data$id==IDs[i]),c("lon","lat")], hole=FALSE)), ID=IDs[i])
}

##############################################################################################################
# Convert to Spatial polygons
#############################################################################################################

SP <- SpatialPolygons(SP)

##############################################################################################################
# Convert to SpatialPolygonsDataFrame
#############################################################################################################

Info=unique(data.frame(ID=data$id, tag=data$tag, Multi=data$Multi_tag))
rownames(Info)=Info$ID
SP=SpatialPolygonsDataFrame(SP, data=Info)

##############################################################################################################
# Plot
#############################################################################################################

p=leaflet() %>% 
  addPolygons(data=SP[which(SP$tag=="forest"),],   fillColor="#2ca25f", color="#2ca25f", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="wood"),],   fillColor="#2ca25f", color="#2ca25f", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="conservation"),],fillColor="#2ca25f", color="#2ca25f", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="heath"),],   fillColor="#f7fcb9", color="#f7fcb9", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="grass"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="meadow"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="farm"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="grass"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="orchard"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="sand"),],   fillColor="#ffeda0", color="#ffeda0", stroke=FALSE, fillOpacity=1) %>%
  addPolygons(data=SP[which(SP$tag=="water"),],   fillColor="#a6bddb", color="#a6bddb", stroke=FALSE, fillOpacity=1) %>%
  addPolylines(data=hw_line,  opacity=1, weight=20)
print(p)


SP2=fortify(SP)
p=ggplot() +
  geom_polygon(data=SP[which(SP$tag=="forest"),], aes(x=long, y=lat, group=id),  fill="#2ca25f",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="wood"),],  aes(x=long, y=lat, group=id), fill="#2ca25f",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="conservation"),], aes(x=long, y=lat, group=id),  fill="#2ca25f",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="heath"),],   aes(x=long, y=lat, group=id),fill="#f7fcb9",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="grass"),],  aes(x=long, y=lat, group=id), fill="#addd8e",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="meadow"),],  aes(x=long, y=lat, group=id), fill="#addd8e",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="farm"),],  aes(x=long, y=lat, group=id), fill="#addd8e",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="grass"),],  aes(x=long, y=lat, group=id), fill="#addd8e",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="orchard"),], aes(x=long, y=lat, group=id),  fill="#addd8e",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="sand"),],   aes(x=long, y=lat, group=id),fill="#ffeda0",  alpha=1) +
  geom_polygon(data=SP[which(SP$tag=="water"),],  aes(x=long, y=lat, group=id), fill="#a6bddb",  alpha=1)+ 
  geom_path(data=hw_line1, aes(x=long, y=lat, group=id))+
  geom_path(data=hw_line2, aes(x=long, y=lat, group=id))+
  geom_path(data=hw_line3, aes(x=long, y=lat, group=id))+
  theme(panel.background = element_rect(fill = "white"))+
  theme(panel.grid = element_blank())+
  theme(axis.title = element_blank())+
  theme(axis.ticks = element_blank())+
  theme(axis.text = element_blank())
print(p)

ggsave(file="kaart_alle.pdf", width = 297, height = 297, units = "mm")

save(SP, file=paste(getwd(),"/1. Data/Cleaned Data/OSM.RDATA", sep=""))
