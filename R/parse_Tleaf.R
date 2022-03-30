#' Parse nasapower weather into tealeaves
#'
#' @param longlat
#' @param start_end
#'
#' @return
#' @export
#'
#' @examples
#' tl <- parse_Tleaf(longlat= c(150.884226, -26.826118),
#'                   start_end = c("2020-01-01","2020-03-01"),
#'                   leaf_param = NULL)
parse_Tleaf <- function(longlat= c(150.884226, -26.826118),
                        start_end = c("2020-01-01","2022-01-01"),
                        leaf_param = NULL){
   if(is.null(leaf_param)){
      leaf_param <- make_leafpar()
   }

   nasa_p <- get_power(
      community = "ag",
      pars = c(
         "RH2M",
         "T2M",
         #"PRECTOTCORR",
         "WS2M",
         #"CLRSKY_SFC_SW_DWN",
         "ALLSKY_SFC_SW_DWN",
         #"CLRSKY_SFC_LW_DWN",
         "ALLSKY_SFC_LW_DWN",
         "PS",
         #"T2MDEW",
         #"CLOUD_AMT",
         "ALLSKY_SRF_ALB"
      ),
      temporal_api = "hourly",
      lonlat = longlat,
      dates = start_end
   )

   T_l <-
      apply(nasa_p, 1, function(w) {


         e_p <- make_enviropar(
            replace = list(
               P = data.table::fifelse(
                  "PS" %in% names(w),
                  data.table::fcase(
                     is.na(w["PS"]),
                     set_units(101.3246, "kPa"),
                     TRUE,
                     set_units(w["PS"], "kPa")
                  ),
                  set_units(101.3246, "kPa")
               ),
               r = data.table::fifelse(
                  "ALLSKY_SRF_ALB" %in% names(w),
                  data.table::fcase(
                     is.na(w["ALLSKY_SRF_ALB"]),
                     set_units(0.2),
                     w["ALLSKY_SRF_ALB"] == 0,
                     set_units(0.2),
                     TRUE,
                     set_units(w["ALLSKY_SRF_ALB"])
                  ),
                  set_units(0.2)
               ),
               RH = data.table::fifelse(
                  "RH2M" %in% names(w),
                  data.table::fcase(is.na(w["RH2M"]), set_units(0.5),
                                    TRUE, set_units(w["RH2M"] / 100)),
                  set_units(0.5)
               ),
               S_sw = data.table::fifelse(
                  "ALLSKY_SFC_SW_DWN" %in% names(w),
                  data.table::fcase(
                     is.na(w["ALLSKY_SFC_SW_DWN"]),
                     set_units(1000, "W/m^2"),
                     TRUE,
                     set_units(w["ALLSKY_SFC_SW_DWN"], "W/m^2")
                  ),
                  set_units(1000, "W/m^2")
               ),
               T_air = data.table::fifelse(
                  "T2M" %in% names(w),
                  data.table::fcase(is.na(w["T2M"]),
                                    set_units(298.15, "K"),
                                    TRUE,
                                    set_units(set_units(w["T2M"], "degC"),"K")),
                  set_units(298.15, "K"),
               ),
               wind = data.table::fifelse(
                  "WS2M" %in% names(w),
                  data.table::fcase(is.na(w["WS2M"]), set_units(2, "m/s"),
                                    TRUE, set_units(w["WS2M"], "m/s")),
                  set_units(2, "m/s")
               )
            )
         )
         const <- make_constants()
         return(tleaf(leaf_param, e_p, const, quiet = TRUE))

      })

   leafT_dt <- data.table::rbindlist(T_l)
   leafT_dt[, c("lon", "lat", "time", "T_air","RH","ws") :=
               list(nasa_p$LON,
                    nasa_p$LAT,
                    as.POSIXct(paste0(nasa_p$YEAR,"-",
                                      nasa_p$MO,"-",
                                      nasa_p$DY," ",
                                      nasa_p$HR,":00:00")),
                    set_units(set_units(nasa_p$T2M, "degC"),"K"),
                    nasa_p$RH2M,
                    nasa_p$WS2M)]

      return(leafT_dt)
}
