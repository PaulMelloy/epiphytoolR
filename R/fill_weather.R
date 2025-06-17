wthr[,c("lon","lat"):= list(mean(lon),mean(lat))]

fwthr <- format_weather(wthr,
                        POSIXct_time = "date_time",
                        verbose = TRUE,
                        time_zone = "UTC",
                        temp = "air_temp",
                        rain = "rain_ten",
                        rh = "rel_hum",
                        wd = "wind_dir_deg",
                        ws = "wind_spd_kmh",
                        station = "name",
                        lat = "lat",
                        lon = "lon",
                        data_check = FALSE)
