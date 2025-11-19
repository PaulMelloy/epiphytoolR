# Daily Infection Value - temperature index

Calculates the Temperature index for day i and hour j. Temperature index
is used to calculate the Daily Infection Values (DIV) for the model
published by Schoeny et. al (2007).

## Usage

``` r
DIV_Tm_index(temp, rainfall = 0.2)
```

## Source

<https://doi.org/10.1007/978-1-4020-6065-6_9>

## Arguments

- temp:

  daily average temperature in degrees Celsius

- rainfall:

  rainfall in mm

## Value

Temperature index value (numeric), used in calculating DIV

## Details

Formula adapted from Schoeny. et al. (2007) in European Journal of Plant
Pathology.

## Examples

``` r
DIV_Tm_index(25)
#> [1] 0.7434944
```
