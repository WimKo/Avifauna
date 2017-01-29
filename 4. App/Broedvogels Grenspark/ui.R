

Soorten=c("Bergeend","Blauwborst","Bonte vliegenvanger","Boomklever","Boomleeuwerik","Boompieper",
"Canadese gans","Dodaars","Geelgors","Gekraagde roodstaart","Geoorde fuut","Groene specht","Grutto","Kiviet",
"Kneu","Krakeend","Kuifeend","Kuifmees","Rietgors","Roodborsttapuit","Slobeend","Tapuit",
"Tureluur","Veldleeuwerik","Watersnip","Wielewaal","Wulp","Zwarte specht",
"Boomvalk","Fitis","Grasmus","Kruisbek","Sprinkhaanzanger","Tafeleend","Torenvalk","Wintertaling","Zwarte mees")
Soorten=Soorten[order(Soorten)]

library(shiny)
library(leaflet)




ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                selectInput("Soort","Soort:",choices = c("Alle Soorten",Soorten)),
                selectInput("Teljaar","Teljaar:",choices = c("Alle Jaren",2000:2015)),
                selectInput("Achtergrond","Achtergrond:",choices = c("Grijs", "Satteliet", "Kaart")),
                checkboxInput("Grenzen", "Toon VOG Grenzen:", value=FALSE),
                sliderInput("Transparatie", "Transparantie Polygonen:", min=0, max=1, value=1)
  )
)
