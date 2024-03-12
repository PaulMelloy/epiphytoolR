# epiphytoolR 0.0.2
 * Make `pkgdown` site
 * R function to generate mock raw bom file for testing and examples `make_bom_data()`  
 * tests for `get_weather_coefs()`  
 * patch some bugs to tests and allow calc_estimated_weather to return `rh` and 
  `temp`
 * `calc_estimated_weather()` now returns `epiphy.weather` classed data.tables 
  eliminating the need for subsequent parsing through `format_weather()`
 
 * new functions `impute_temp()` and `impute_rh()` for imputing temperatures and 
  relative humidity using a `impute_fill()` on a rolling window function  
  
 * Add README.md
 * `calc_estimated_weather.R()`  
   - Permit `n_stations` argument to input a integer of single length to provide 
   the number of stations.  
   - More detailed error and warning messages, and checks on min and max temperatures  
   - add na.rm argument for cases where NA data can't be removed manually
   
 
 * Add functions for estimating future weather for environments.:  
   - `calc_estimated_weather()` 
   - `impute_diurnal()` 
   - `get_weather_coefs()`   
 
 * Better time format detection and more informative `format_weather()` errors.  
 
 * Add a function `fill_time_gaps()` that fills time gaps in data.frame with 
 time vector. 
 This is common in many weather data sets to have missing data. 
 This function helps fill the lines which are missing and inserts NAs for any column
 with variable inputs.
 
 * New fictional internal dataset `bris_weather_obs.csv` of weather for testing 
 and practising the use of functions in this package.
 The format reflect some BOM weather data.
 
 * `format_weather()` 
   - *New feature* allows data.checks of specific variable. Previously this was 
   all or nothing.
   - This now accepts relative humidity `rh` and returns the hourly mean.
 

# epiphytoolR 0.0.1

 * Initialise version 0.0.1 and merge `dev` branch to `main`. Package is now a import
 to many other packages and should be incremented to not under development

# epiphytoolR 0.0.0.9001  

 * Initialise news file  
 * Added scripts to download BOM observational data by state from the FTP server.
 See `help(get_bom_observations)`  
 * **Bug fix** in `format_weather()` see issue #10. Detects midnight datetime and 
 corrects HMS formatting  
 * **Bug fix** in `format_weather()` see issue #11. Internal function to fill missing 
 times would not work correctly when formatting weather from multiple stations.
 
