# server.R
source("helpers.R")
shinyServer(function(input, output, session) {
        observe({
                # update choices for zip drop down based on zipInput df
                updateSelectInput(session, 
                                  "zipCodes", 
                                  label="Zip Codes", 
                                  choices=as.character(zipInput$ZIPCNT), 
                                  selected=zipInput$ZIPCNT[1])
        })
        fb <- reactive({
                # react to change in zip code drop down by subsetting bridge df by zip code
                z = as.character(input$zipCodes)
                z2 = substring(z, 1, 3)
                if (z2 != 'All')
                {
                        # use numeric comparison for speed optimization
                        z2 = as.numeric(substring(z, 1, 5))
                        subset(bridgeInput, ZIPCODE == z2)
                }
                else
                {
                        bridgeInput
                }
        })
        
        observe({
                # render leaflet map, for all use mark cluster options, for individual zip do not cluster
                if (substring(as.character(input$zipCodes), 1, 3) != 'All')
                {
                        output$map <- renderLeaflet({
                        fb() %>% leaflet() %>%
                                 addTiles() %>%
                                 addCircleMarkers(weight=1, popup=fb()$longName)})
                }
                else
                {
                        output$map <- renderLeaflet({
                                fb() %>% leaflet() %>%
                                        addTiles() %>%
                                        addCircleMarkers(weight=1, popup=fb()$longName, clusterOptions = markerClusterOptions())})
                }
        })
        observe({
                # render HTML output with summary message
                if (substring(as.character(input$zipCodes), 1, 3) != 'All')
                {
                        output$bridges <- renderUI({
                                        ht <- paste("<p>Number of bridges = <b>",
                                              as.character(nrow(fb())),
                                              "</b> in zip code = <b>", 
                                              substring(as.character(input$zipCodes), 1, 5),
                                              "</b></p>", 
                                              sep='')
                                        HTML(paste(ht))
                                        })
                }
                else
                {
                        output$bridges <- renderUI({
                                ht <- paste("<p>Number of bridges = <b>",
                                      as.character(nrow(fb())),
                                      "</b> in <b>All</b> zip codes</p>", 
                                      sep='')
                                HTML(paste(ht))
                                })
                }
        })
        output$bridgeHelp <- renderUI({
                ht <- paste("<h1>Explore Maryland Bridges with this Shiny<img src='bigorb.png' alt='R logo' height='32' width='32'>Application</h1>",
                            "<p>Server loading takes a little time. Once the drop down select shows All(3358) then server loading is complete.</p>", 
                            "<p>By default system shows all of the bridges in Maryland using leaflet clusters.</p>", 
                            "<p>Click on the cluster marker to explore in more detail.</p>", 
                            "<p>or use the +/- zoom in and zoom out controls at the upper left corner of the map.</p>", 
                            "<p>To filter by zipcode select the appropriate zip code in the drop down. The drop down shows the number of bridges in that zip in parens.</p>", 
                            "<p>All circular markers are shown when viewing an individual zip code.</p>", 
                            "<p>Click on a circular marker to view details about the bridge located there.</p>", 
                            "<p>Bridge data courtesy of the US DOT and can be downloaded <a href='https://catalog.data.gov/organization/dot-gov'>here</a></p>", 
                            sep='')
                HTML(paste(ht))
        })
})
