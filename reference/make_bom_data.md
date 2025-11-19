# Mock Bureau of Meteorology weather data

Simulated raw weather data from AWS weather station

## Usage

``` r
make_bom_data()
```

## Source

simulated

## Value

A data frame with 8,786 rows and 15 columns:

- times:

  record time from weather station

- temp:

  hourly mean temperature in degrees

- rh:

  hourly mean relative humidity

## Examples

``` r
raw_bom <- make_bom_data()
```
