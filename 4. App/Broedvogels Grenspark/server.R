

library(shiny)
library(leaflet)


shinyServer(function(input, output,session) {

  output$map <- renderLeaflet({  
    
    
    p=leaflet() %>% setView(lng = 4.421868324279785, lat = 51.39222164813269, zoom = 13) 
    p
  })
  
  observe({
    
    if (input$Achtergrond=="Satteliet") {
      leafletProxy("map") %>% addProviderTiles("Esri.WorldImagery")
    }
    
    if (input$Achtergrond=="Kaart") {
      leafletProxy("map") %>% addTiles()
    }
    
    if (input$Achtergrond=="Grijs") {
      leafletProxy("map") %>%  clearTiles
    }
    
    
  })
  

  observe({
    
    load(paste(getwd(),"/Data/OSM.RDATA", sep=""))
    load(paste(getwd(),"/Data/VOG.RDATA", sep=""))
    
    leafletProxy("map") %>%
      clearShapes() %>%
      addPolygons(data=SP[which(SP$tag=="forest"),],   fillColor="#2ca25f", color="#2ca25f", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="wood"),],   fillColor="#2ca25f", color="#2ca25f", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="conservation"),],fillColor="#2ca25f", color="#2ca25f", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="heath"),],   fillColor="#f7fcb9", color="#f7fcb9", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="grass"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="meadow"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="farm"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="grass"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="orchard"),],   fillColor="#addd8e", color="#addd8e", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="sand"),],   fillColor="#ffeda0", color="#ffeda0", stroke=FALSE, fillOpacity=input$Transparatie) %>%
      addPolygons(data=SP[which(SP$tag=="water"),],   fillColor="#a6bddb", color="#a6bddb", stroke=FALSE, fillOpacity=input$Transparatie)
      
      if (input$Grenzen==TRUE) {
        leafletProxy("map")  %>% addPolygons(data=VOG, color="#e6550d", stroke=TRUE, fillOpacity=0)
      }
      
  })


  
  observe({
    load(paste(getwd(),"/Data/Grenspark.RDATA", sep=""))
    
    if (input$Soort!="Alle Soorten") {
      Grenspark=Grenspark[which(Grenspark$bvr_soort==input$Soort),]
    }
    
    if (input$Teljaar!="Alle Jaren") {
      Grenspark=Grenspark[which(Grenspark$jaar==input$Teljaar),]
    }
   
    
    leafletProxy("map") %>%
      clearMarkers() %>% 
      addCircleMarkers(data=Grenspark, color = "#f03b20", stroke=FALSE, fillOpacity=1, radius=5)
    
  })
  

})
