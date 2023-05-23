get_bom_stations <- function(link = "http://www.bom.gov.au/climate/data/lists_by_element/stations.txt",
                             type = "all",
                             years = "all"){
   library(data.table)
   dat <- fread("inst/extdata/stations.csv")

   head(dat)
   dat[,End := as.numeric(End)]
   dat[,Start := as.numeric(Start)]
   dat[,years := End - Start]
   dat[,Lat := as.numeric(Lat)]
   selection <-
      dat[years > 20 |
          is.na(years),][
          End >= 2020 |
          is.na(End),][Lat <= -23,]

   # remove weather stations from interior Australia
   selection <-
      selection[Lon >= 145 |
                Lon <= 117 |
                Lat <= -29 &
                Lat >= -39,]

   # remove antarctica
   selection <- selection[STA != "ANT" &
                Lon < 155]

   library(leaflet)
   leaflet(selection)|>
      addProviderTiles("Esri.WorldImagery") |>
      addMarkers(lng = ~Lon, lat = ~Lat)


   fwrite(selection,"selected_weather_stations.csv")

   }
