# Calculate Vapour-pressure deficit from relative humidity and temperature

This formula uses the same formula described by the Bureau of
Meteorology (BOM) and the American Meteorological Society. Other
formulas described by described by Murray (1967) or Tetens (1930) to
calculate vapour pressure from temperature in degrees and Celsius and
relative humidity can also be called.

## Usage

``` r
calc_vpd(RH, Tm, eq = "BOM", verbose = FALSE)
```

## Arguments

- RH:

  numeric, Relative humidity

- Tm:

  numeric, Temperature in degrees Celsius

- eq:

  character, Type of equation to use while calculation VPD. defaults to
  the "BOM" (Bureau of Meteorology equation, Australia). Other options,
  "Murray" and "Sapak"

- verbose:

  logical, prints saturated vapour pressure (SVP) and vapour pressure in
  kPa before returning the VPD result.

## Value

Vapour-pressure deficit kPa, class
[units](https://CRAN.R-project.org/package=units)

## References

https://doi.org/10.1175/1520-0450(1967)006\<0203:OTCOSV\>2.0.CO;2

## Examples

``` r
calc_vpd(RH = 99, Tm = 30)
#> 0.04242794 [kPa]
```
