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
#> [1] 92.86874
wind_distance(mean_wind_speed = 10,
              wind_cauchy_multiplier = 50,
              PSPH = 10) # returns 10 estimates
#>  [1]  545.1628 1208.6911 1163.7616 2379.8187  389.5521  326.3844  290.0274
#>  [8] 5212.8388 5909.0490 2484.0168
wind_distance(mean_wind_speed = 10,
              wind_cauchy_multiplier = 50,
              PSPH = c(5, 5)) # returns 10 estimates
#>  [1]  416.8657  658.7236  794.4378  470.9079  275.4225 1205.7668  177.0260
#>  [8]  223.2318  417.2118  416.0252
```
