# epiphytoolR

An R package that provides functions for undertaking epiphytotic modelling
and simulation studies in R.

## epiphytoolR aims

This package aims to be a collaborative project to provide a suite of functions
for epidemiologists to build models from. 
The functions should be basic and easy to adapt to the various models.
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
see [NEWS.md](https://github.com/PaulMelloy/epiphytoolR/blob/dev/NEWS.md)


## How to contribute
### Reporting bugs 
Create an [issue](https://github.com/PaulMelloy/epiphytoolR/issues) on this repo.

### Contributing code
 1. Fork the repo and create a pull request.  
 2. Request contribute access in the pull request.  

## Main features  
### Inoculum dispersal and movement
This package provides common base level functions that can be used in modelling
the spatial movement of splash and wind dispersed plant disease inoculum.

### Disease progress  
Estimating Daily Infection Values, AUDPC, ect.


### Weather formatting
Epidemiological models need clean consistent weather data, this package contains
functions to provide clean interpolated data for models.

## Find out more
For more information see pkgdown website [epiphytoolR](https://paul.melloy.github.io/epiphytoolR/)
