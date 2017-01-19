library(shiny)
library(leaflet)
# read in zip codes
fileZips <- "data/MarylandZipCodes.csv"
zipInput <- read.csv(file=fileZips, head=TRUE, sep=",",na.strings=c('#DIV/0', '', 'NA'))
# read in bridges
fileBridges <- "data/MarylandBridges.csv"
bridgeInput <- read.csv(file=fileBridges, head=TRUE, sep=",",na.strings=c('#DIV/0', '', 'NA'))
# create longname column for leaflet columns
bridgeInput$longName <- paste("<table>",
                              "<tr><td>ID&nbsp;&nbsp;&nbsp;</td>", "<td><b>", as.character(bridgeInput$id), "</b></td></tr>",
                              "<tr><td>ROAD&nbsp;&nbsp;&nbsp;</td>", "<td><b>", bridgeInput$ROAD, "</b></td></tr>",
                              "<tr><td>LOCATION&nbsp;&nbsp;&nbsp;</td>", "<td><b>", bridgeInput$LOCATION, "</b></td></tr>",
                              "<tr><td>ZIP&nbsp;&nbsp;&nbsp;</td>", "<td><b>", as.character(bridgeInput$ZIPCODE), "</b></td></tr>",
                              "<tr><td>OPEN&nbsp;CODE&nbsp;&nbsp;&nbsp;</td>", "<td><b>", bridgeInput$OPEN_CODE, "</b></td></tr>", 
                              "<tr><td>OPEN&nbsp;DESC&nbsp;&nbsp;&nbsp;</td>", "<td><b>", bridgeInput$OPEN_DESC, "</b></td></tr>", 
                              "<tr><td>YEAR&nbsp;BUILT&nbsp;&nbsp;&nbsp;</td>", "<td><b>", as.character(bridgeInput$YEAR_BUILT), "</b></td></tr>", sep="")
# create zip code with number of brides in zip in parens for drop down
fun <- function(x) {nrow(subset(bridgeInput, ZIPCODE == x))}
zipInput$Cnt <- lapply(zipInput$ZIP, fun)
zipInput$Cnt[1] = nrow(bridgeInput)
zipInput$ZIPCNT <- paste(as.character(zipInput$ZIP), '(', as.character(zipInput$Cnt), ')', sep = '')
# only show zip codes that have bridges
zipInput <- subset(zipInput, Cnt > 0)

