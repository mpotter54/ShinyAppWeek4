library(leaflet)
shinyUI(fluidPage(
        titlePanel("Maryland Bridges"),
        
        sidebarLayout(
                sidebarPanel(
                        helpText("Explore Maryland Bridges by Zip Code or All"),
                        selectInput("zipCodes", "Zip Codes", c("All (0)")
                        ), width=3),
                 mainPanel(
                         leafletOutput("map"),
                         br(),
                         htmlOutput("bridges"),
                         br(),
                         htmlOutput("bridgeHelp"), 
                         width=9)
        )
))
