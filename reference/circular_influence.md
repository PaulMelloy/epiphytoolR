# Calculate the influence of 2 dimensional vectors

Calculate the influence of 2 dimensional vectors

## Usage

``` r
circular_influence(x, offset = 0)
```

## Arguments

- x:

  degrees (numeric), numeric of length one

- offset:

  degrees (numeric), what angle should the function offset to and the
  returned value be 1.

## Value

numeric double vector giving the proportion of influence from two
dimensions, the *x* dimension and *y* dimension between -1 and 1

## Details

This function determines the circular vector influence on a 1 to -1
scale. For example if the wind is blowing on a northerly vector (0
degrees) there is no influence reduction. If wind blows at a 90 degree
angle there is no influence on the north south plane.

## Examples

``` r
# Wind speed strength from a northerly wind
ws <- 5 # kph
wd <- 0 # degrees
ws * circular_influence(wd)
#> x y 
#> 0 5 

# Wind speed strength from a north east wind
ws <- 5 # kph
wd <- 45 # degrees
ws * circular_influence(wd)
#>        x        y 
#> 3.535532 3.535536 

# Wind speed strength from a south west wind
ws <- 5 # kph
wd <-225 # degrees
ws * circular_influence(wd)
#>         x         y 
#> -3.535522 -3.535546 
```
