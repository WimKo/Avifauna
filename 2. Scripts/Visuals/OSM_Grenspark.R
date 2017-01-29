require(osmar)
require(ggplot2)
require(data.table)


src <- osmsource_file(paste(getwd(), "/1. Data/Raw Data/Grenzen/OSM/Grenspark.osm", sep=""))
box <-corner_bbox(left = -180, right = 180, top = 90, bottom = -90)
osmdata <- get_osm(box, src)


Grenspark <- as_sp(osmdata, "polygons")
Grenspark=Grenspark[which(Grenspark$id==71293206), ]

# Extract surface functions ##############################################################################

Get_Surface=function(Map) {
  
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

# Extract ways functions ##############################################################################

Get_Ways=function(Map) {
  
  Nodes_attrs=Map$nodes$attrs
  
  Ways_tags=Map$ways$tags
  Ways_attrs=Map$ways$attrs
  Ways_refs=Map$ways$refs
  
  Relations_tags=Map$relations$tags
  Relations_attrs=Map$relations$attrs
  Relations_refs=Map$relations$refs
  Relations_refs=Relations_refs[which(Relations_refs$role=="outer"),]
  
  Ways_tags=Ways_tags[c(which(Ways_tags$k=="cycleway"),which(Ways_tags$k=="highway")),]
  Relations_tags=Relations_tags[c(which(Relations_tags$k=="cycleway"),which(Relations_tags$k=="highway")),]
  
  Ways_refs$lon=Nodes_attrs[match(Ways_refs$ref, Nodes_attrs$id), "lon"]
  Ways_refs$lat=Nodes_attrs[match(Ways_refs$ref, Nodes_attrs$id), "lat"]
  Ways_refs$tag=as.character(Ways_tags[match(Ways_refs$id, Ways_tags$id), "v"])
  
  Ways_refs$Multi_id=Relations_refs[match(Ways_refs$id, Relations_refs$ref), "id"]
  Ways_refs$Multi_tag=Relations_tags[match(Ways_refs$Multi_id, Relations_tags$id), "v"]
  
  Ways_refs[which(is.na(Ways_refs$tag)==TRUE), "tag"]=as.character(Ways_refs[which(is.na(Ways_refs$tag)==TRUE), "Multi_tag"])
  
  data=Ways_refs[which(is.na(Ways_refs$tag)==FALSE),]
  data
}

# Get Info ########################################################################################################

data=Get_Surface(osmdata)
ways=Get_Ways(osmdata)

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
data=data[data$id!=121722250,]
data=data[data$id!=121450031,]

points=SpatialPoints(ways[,c("lon","lat")])
proj4string(points)=proj4string(Grenspark)
test=over(points, Grenspark)

ways$In=test$id
ways[which(is.na(ways$In)==FALSE),"In"]=1
ways[which(is.na(ways$In)==TRUE),"In"]=0

check=data.table(ways)
check=check[, max(In), by=id]
check=check[V1==1,id]

ways=ways[ways$id %in% check,]


# ggplot2 ##########################################################################################################

p=ggplot()+ 
  geom_polygon(data=data[which(data$tag=="forest"),], aes(x=lon, y=lat, group=id),  fill="#2ca25f",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="wood"),],  aes(x=lon, y=lat, group=id), fill="#2ca25f",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="conservation"),], aes(x=lon, y=lat, group=id),  fill="#2ca25f",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="heath"),],   aes(x=lon, y=lat, group=id),fill="#f7fcb9",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="grass"),],  aes(x=lon, y=lat, group=id), fill="#addd8e",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="meadow"),],  aes(x=lon, y=lat, group=id), fill="#addd8e",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="farm"),],  aes(x=lon, y=lat, group=id), fill="#addd8e",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="grass"),],  aes(x=lon, y=lat, group=id), fill="#addd8e",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="orchard"),], aes(x=lon, y=lat, group=id),  fill="#addd8e",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="sand"),],   aes(x=lon, y=lat, group=id),fill="#ffeda0",  size=0.5, alpha=0.5) +
  geom_polygon(data=data[which(data$tag=="water"),],  aes(x=lon, y=lat, group=id), fill="#a6bddb",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="residential"),],  aes(x=lon, y=lat, group=id), fill="#EBE3DF",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="farm"),],  aes(x=lon, y=lat, group=id), fill="#C8C652",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="farmland"),],  aes(x=lon, y=lat, group=id), fill="#C8C652",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="farmyard"),],  aes(x=lon, y=lat, group=id), fill="#C8C652",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="cemetery"),],  aes(x=lon, y=lat, group=id), fill="#EBE3DF",  size=0.5, alpha=0.5)+
  geom_polygon(data=data[which(data$tag=="industrial"),],  aes(x=lon, y=lat, group=id), fill="#EBE3DF",  size=0.5, alpha=0.5)+
  #geom_path(data=data[which(data$tag=="forest"),], aes(x=lon, y=lat, group=id),  colour="#2ca25f",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="wood"),],  aes(x=lon, y=lat, group=id), colour="#2ca25f",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="conservation"),], aes(x=lon, y=lat, group=id),  colour="#2ca25f",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="heath"),],   aes(x=lon, y=lat, group=id),colour="#f7fcb9",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="grass"),],  aes(x=lon, y=lat, group=id), colour="#addd8e",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="meadow"),],  aes(x=lon, y=lat, group=id), colour="#addd8e",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="farm"),],  aes(x=lon, y=lat, group=id), colour="#addd8e",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="grass"),],  aes(x=lon, y=lat, group=id), colour="#addd8e",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="orchard"),], aes(x=lon, y=lat, group=id),  colour="#addd8e",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="sand"),],   aes(x=lon, y=lat, group=id),colour="#ffeda0",  size=0.5, alpha=0.5) +
  #geom_path(data=data[which(data$tag=="water"),],  aes(x=lon, y=lat, group=id), colour="#a6bddb",  size=0.5, alpha=0.5)+
  #geom_path(data=data[which(data$tag=="residential"),],  aes(x=lon, y=lat, group=id), colour="#EBE3DF",  size=0.5, alpha=0.5)+
  #geom_path(data=data[which(data$tag=="farm"),],  aes(x=lon, y=lat, group=id), colour="#C8C652",  size=0.5, alpha=0.5)+
  #geom_path(data=data[which(data$tag=="farmland"),],  aes(x=lon, y=lat, group=id), colour="#C8C652",  size=0.5, alpha=0.5)+
  #geom_path(data=data[which(data$tag=="farmyard"),],  aes(x=lon, y=lat, group=id), colour="#C8C652",  size=0.5, alpha=0.5)+
  #geom_path(data=data[which(data$tag=="cemetery"),],  aes(x=lon, y=lat, group=id), colour="#EBE3DF",  size=0.5, alpha=0.5)+
  #geom_path(data=data[which(data$tag=="industrial"),],  aes(x=lon, y=lat, group=id), colour="#EBE3DF",  size=0.5, alpha=0.5)+
  #geom_path(data=data[which(data$tag=="recreation_ground"),],  aes(x=lon, y=lat, group=id), colour="#EBE3DF",  size=0.5, alpha=0.5)+
  #geom_path(data=ways[which(ways$tag=="path"),],  aes(x=lon, y=lat, group=id), colour="#522714",  size=0.2)+
  #geom_path(data=ways[which(ways$tag=="footway"),],  aes(x=lon, y=lat, group=id), colour="#522714",  size=0.2)+
  #geom_path(data=ways[which(ways$tag=="track"),],  aes(x=lon, y=lat, group=id), colour="#522714",  size=0.2)+
  #geom_path(data=ways[which(ways$tag=="residential"),],  aes(x=lon, y=lat, group=id), colour="#DF1D54",  size=0.2)+
  #geom_path(data=ways[which(ways$tag=="tertiary"),],  aes(x=lon, y=lat, group=id), colour="#DF1D54",  size=0.2)+
  #geom_path(data=ways[which(ways$tag=="primary"),],  aes(x=lon, y=lat, group=id), colour="#DF1D54",  size=0.2)+
  #geom_path(data=ways[which(ways$tag=="secondary"),],  aes(x=lon, y=lat, group=id), colour="#DF1D54",  size=0.2)+
  #geom_path(data=ways[which(ways$tag=="unclassified"),],  aes(x=lon, y=lat, group=id), colour="#DF1D54",  size=0.2)+
  theme(panel.grid = element_blank())+
  theme(axis.title = element_blank())+
  theme(axis.ticks = element_blank())+
  theme(axis.text = element_blank())+
  theme(panel.background = element_rect(fill = "white"))

ggsave(file=paste(getwd(), "/3.Plots/OSM/Grenspark.pdf", sep=""), width = 10, height = 10, units = "cm")

save(p,data, file=paste(getwd(), "/3.Plots/OSM/Grenspark.RDATA", sep=""))
