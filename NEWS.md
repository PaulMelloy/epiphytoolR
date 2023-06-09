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
 
