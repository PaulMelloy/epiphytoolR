# Estimates Bearing Conidia Dispersed by Wind Driven Rain

`wind_angle()` samples from normal distribution to estimate the bearing
of spore or conidia dispersal wind.

## Usage

``` r
wind_angle(mean_wind_direction, stdev_wind_direction, PSPH = 1, min_stdev = 1)
```

## Arguments

- mean_wind_direction:

  A numeric vector representing mean wind direction at a particular time
  interval

- stdev_wind_direction:

  Refer to standard deviation of wind_direction at a particular time
  interval

- PSPH:

  A numeric vector, estimated from `.estimate_spore_discharge()`

- min_stdev:

  the minimum possible standard deviation of wind direction permitted.
  This should reflect the turbulent effect of wind movements to prevent
  std deviations of near zero when wind direction is averaged.

## Value

A numeric vector giving information on the angle component of conidia
dispersed by wind driven rain.

## Examples

``` r
wind_angle(10, 2) # returns a single estimate
#> [1] 9.159019
wind_angle(10, 2, PSPH = 10) # returns 10 estimates
#>  [1]  8.875748 11.995027  7.789740  9.715424 10.629990 12.437101  8.601366
#>  [8]  9.429134  7.376895  9.217975
wind_angle(15, 2, PSPH = c(5, 5)) # returns 10 estimates
#>  [1] 14.19695 17.70104 16.18238 15.20105 16.86214 14.47452 14.98466 15.73431
#>  [9] 18.41433 16.44748
```
