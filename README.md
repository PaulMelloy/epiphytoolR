# epiphytoolR

An R package that provides functions for undertaking epiphytotic modelling
and simulation studies in R.

## epiphytoolR aims

This package aims to be a collaborative project to provide a suite of functions
for epidemiologists to build models from. 
The functions should be at their most basic and easy to adapt to the various 
epidemiological models.
We hope this becomes a dependency for many more models. 
We welcome contributions additional branches to explore additional functionality
and features.  

## What epiphytoolR is not  
This does not provide full epidemiological models. 
See the following R packages for flexible complete models:

### my suggestions
- [epicrop](https://codeberg.org/adamhsparks/epicrop)

#### Weather
- [weatherOz](https://github.com/ropensci/weatherOz)  
- [nasapower](https://github.com/ropensci/nasapower)  
- [GSODR](https://github.com/ropensci/GSODR)  
- [stationaRy](https://github.com/rich-iannone/stationaRy)  
- [openmeteo](https://open-meteo.com/)  

#### CRAN Task views
- [Agriculture: Plant Pathology](https://cran.r-project.org/web/views/Agriculture.html#PlantPath)  

### Co-pilot suggestions  
*not yet vetted*  
- [EpiDynamics](https://cran.r-project.org/web/packages/EpiDynamics/index.html)  
- [EpiILM](https://github.com/waleedalmutiry/EpiILM)  
- [EpiNow2](https://cran.r-project.org/web/packages/EpiNow2/index.html)  
- [EpiEstim](https://cran.r-project.org/web/packages/EpiEstim/index.html)  
- [EpiCurve](https://cran.r-project.org/web/packages/EpiCurve/index.html)  
- [EpiModel](https://cran.r-project.org/web/packages/EpiModel/index.html)  
- [epiR](https://cran.r-project.org/web/packages/epiR/index.html)  
- [epiDisplay](https://cran.r-project.org/web/packages/epiDisplay/index.html)  


## How to install
`epiphytoolR` is not on CRAN but is aimed for a release sometime in 2025.

You can install a stable version from the `main` branch with the following code
```
remotes::install_github("PaulMelloy/epiphytoolR")
```

Or you can install the development version from the development (`dev`) branch 
with the following command in R

```
remotes::install_github("PaulMelloy/epiphytoolR", ref = "dev")
```

The `dev` branch will have newer bug fixes and more features, 
see [NEWS.md](https://github.com/PaulMelloy/epiphytoolR/blob/dev/NEWS.md).
However may have new bugs yet to be fully tested


## How to contribute
### Reporting bugs 
Create an [issue](https://github.com/PaulMelloy/epiphytoolR/issues) on this repo.

### Contributing code

 1. Fork the repo make changes and create a pull request.  
 2. Request contribute access in the pull request.  

Contributing is easy, you may notice the reuse of common functions in plant
epidemiological modelling.
Translate these equations to R code and add them to this package through a pull
request.

#### Contribution Example  

$y=a*(x+c)^{-b}$

can become a function
```r
calc_spores <- function(x, a, con, b){
   return(a * (x + con) ^ (-b))
}
```

Also use [roxygen](https://roxygen2.r-lib.org/) headers to describe the function 
in the file.
'Ctrl + Alt + Shift + R' Inserts an Roxygen header skeleton to edit.  

```
#' Estimate spore dispersal
#'
#' @description
#' A modified inverse power function redescribed by Severns et al. (2018). 
#'  "Consequences of Long-Distance Dispersal for Epidemic Spread: Patterns, 
#'   Scaling, and Mitigation"
#'
#'
#' @source <https://doi.org/10.1094/PDIS-03-18-0505-FE>
#'
#' @param x numeric, distance from source lesion in meters
#' @param a numeric, a constant proportional to the amount of source inoculum
#' @param con numeric, a constant that allows for a finite amount of disease at the source
#' @param b numeric, modifies the steepness of the curve
#'
#' @return numeric, The number of effective spores, or infections per unit area
#' @export
#'
#' @examples
#' calc_spores(x = 5,a = 1000, con = 3, b = 4)
```
 
#### Function naming  
Function naming should be concise and have the consistent use of prefixes as 
follows. 
 - `est_` estimate, usually used when the function or equation is based on empirical
 evidence.  
 - `get_` a wrapper for retrieving data or accessing an API, or calculations form
 data.
 - `impute_` imputation functions.  
 - `calc_` Calculate from common equations.  
 

 
## Main features  
### Inoculum dispersal and movement
This package provides common base level functions that can be used in modelling
the spatial movement of splash and wind dispersed plant disease inoculum.

### Disease progress  
Estimating Daily Infection Values, AUDPC, ect.


### Weather formatting
Epidemiological models need clean consistent weather data, this package contains
functions to provide clean interpolated data for models.  

Future versions will look towards an international standard for weather data 
format.  

## Find out more
For more information see pkgdown website [epiphytoolR](https://paul.melloy.github.io/epiphytoolR/)  
