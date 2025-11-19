# Daily Infection Values

Calculates the Temperature index for day i and hour j. Temperature index
is used to calculate the Daily Infection Values (DIV) for the model
published by Shoeny et. al (2007).

## Usage

``` r
DIV(RH, Tm, rainfall = 0.2)
```

## Source

<https://doi.org/10.1007/978-1-4020-6065-6_9>

## Arguments

- RH:

  relative humitiy percentage (numeric)

- Tm:

  daily average temperature in degrees celcius

- rainfall:

  daily rainfall in millimeters

## Value

infection value for day i ranging between 0 (no fungal growth) and 1
(optimal growth)

## Details

Formula adapted from Schoeny. et al. (2007) in European Journal of Plant
Pathology.

## Examples

``` r
DIV(70,20, rainfall = 0)
#> [1] 1
```
