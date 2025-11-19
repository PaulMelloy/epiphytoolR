# Estimate blackspot primary inoculum

Estimate the amount of blackspot lesions per plant caused by primary
inoculumn, or ascospores. Formula interpreted from Schoeny. et al.
(2007) in European Journal of Plant Pathology.

## Usage

``` r
est_primary_inoculum(degree_days, rainfall)
```

## Source

<https://doi.org/10.1007/978-1-4020-6065-6_9>

## Arguments

- degree_days:

  sum degree days in celcius over 7 days

- rainfall:

  vector of daily rainfall, or maximum rainfall in a week

## Value

number of new blackspot lesions per plant over 7 days

## Examples

``` r
est_primary_inoculum(degree_days = 250,
               rainfall = 15)
#> [1] 7.17275
```
