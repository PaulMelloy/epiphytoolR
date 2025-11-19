# Calculate field-pea emergence

Function calculates the time, in degree days, between sowing and
emergence (when 50% of sown seeds have produces at least one true leaf).

## Usage

``` r
calc_fpea_emergence(sowing_date, hemisphere = "south")
```

## Source

<https://doi.org/10.1007/978-1-4020-6065-6_9>

## Arguments

- sowing_date:

  sowing date `POSIXct.date`

- hemisphere:

  'North' or 'South' hemisphere

## Value

number of degree days predicted from time of sowing to emergence

## Details

Formula adapted from Schoeny. et al. (2007) in European Journal of Plant
Pathology. Formula is reported to correlate to R^2 = 0.91 for pea
cultivar Cheyenne grown in the west of France

## Examples

``` r
calc_fpea_emergence("2021-05-10")
#> [1] 266.7598
```
