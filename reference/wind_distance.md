# Estimate the distance of spore dispersal from wind speed

Samples from a half-Cauchy distribution to estimate the distance in
meters an spore has dispersed from an inoculum source in meters due to
wind speed

## Usage

``` r
wind_distance(mean_wind_speed, wind_cauchy_multiplier, PSPH = 1)
```

## Arguments

- mean_wind_speed:

  *numeric* wind speed in km / h

- wind_cauchy_multiplier:

  A scaling parameter to estimate a Cauchy distribution which resembles
  the mean distance a spore travels due to wind dispersal.

- PSPH:

  A numeric vector estimated from '.estimate_spore_discharge()'

## Value

Numerical vector, which returns distance a spore is dispersed by wind
from the source of infection

## Details

`wind_distance()` Determines distance conidia disperse, in metres, by
wind driven rain Conidia are assumed to spread from the centre of each
subunit. The destination subunit, where conidia land, could be the same
subunit or another subunit within or outside the paddock.

## Examples

``` r
wind_distance(mean_wind_speed = 10,
              wind_cauchy_multiplier = 50) # returns a single estimate
#> [1] 69.39199
wind_distance(mean_wind_speed = 10,
              wind_cauchy_multiplier = 50,
              PSPH = 10) # returns 10 estimates
#>  [1]   67.49703  453.85386  372.39819  762.45777 1478.05239   92.86874
#>  [7]  545.16284 1208.69113 1163.76161 2379.81873
wind_distance(mean_wind_speed = 10,
              wind_cauchy_multiplier = 50,
              PSPH = c(5, 5)) # returns 10 estimates
#>  [1]  389.5521  326.3844  290.0274 5212.8388 5909.0490 2484.0168  416.8657
#>  [8]  658.7236  794.4378  470.9079
```
