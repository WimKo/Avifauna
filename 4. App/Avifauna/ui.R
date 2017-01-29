

Soorten=c("Bergeend","Blauwborst","Bonte vliegenvanger","Boomklever","Boomleeuwerik","Boompieper",
"Canadese gans","Dodaars","Geelgors","Gekraagde roodstaart","Geoorde fuut","Groene specht","Grutto","Kiviet",
"Kneu","Krakeend","Kuifeend","Kuifmees","Rietgors","Roodborsttapuit","Slobeend","Tapuit",
"Tureluur","Veldleeuwerik","Watersnip","Wielewaal","Wulp","Zwarte specht",
"Boomvalk","Fitis","Grasmus","Kruisbek","Sprinkhaanzanger","Tafeleend","Torenvalk","Wintertaling","Zwarte mees")
Soorten=Soorten[order(Soorten)]

library(shiny)
library(leaflet)




ui <- bootstrapPage(
  fluidRow(
  column(11,
         
         textarea:focus, input:focus{
           outline: none;
         },
           
  selectInput("Soort","",choices = c("Alle Soorten",Soorten))

  ))
)

